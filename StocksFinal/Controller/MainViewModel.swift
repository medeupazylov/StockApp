import Foundation

protocol MainViewModelOutput: AnyObject {
    func updateTableView()
}

protocol MainViewModelProvider: AnyObject {
    
    func loadStockDataFromAPI()
    
    func getStockData(index: Int, currentState: StockTableViewState) -> StockData?
    
    func getStockModel(ticker: String) -> StockModel?
    
    func isFavouriteStock(ticker: String) -> Bool
    
    func addToFavourites(ticker: String)
    
    func removeFromFavourites(ticker: String) -> Bool
    
    func getFavouriteListSize() -> Int
    
    func getStocksList( for state: StockTableViewState) -> [StockData]
    
    func appendSearchList(stockData: StockData)
    
    func clearSearchList()
    
    func getSearchHistoryList() -> [String]
    
    func addStockToSearchHistory(ticker: String)
    
    func getElementFromStocksDictionary(ticker: String) -> StockModel?
    
    func uploadSearchHistoryToUserDefaults()
    
    func setFavouriteInUserDefaults(val: Bool, ticker: String)
    
}

class MainViewModel: MainViewModelProvider {
    
    var mainModuleModel: MainModuleModel
    var stockManager: StockManager
    weak var output: MainViewModelOutput?
    
    
    init(mainModuleModel: MainModuleModel, stockManager: StockManager) {
        self.mainModuleModel = mainModuleModel
        self.stockManager = stockManager
        self.mainModuleModel.searchHistoryList = mainModuleModel.defaults.object(forKey: "searchHistory") as? [String] ?? []
        loadStockDataFromAPI()
    }
    
    func getStocksList( for state: StockTableViewState) -> [StockData] {
        switch state {
        case .stocks:
            return mainModuleModel.stocksList
        case .favorite:
            return mainModuleModel.favouriteList
        case .search:
            return mainModuleModel.searchList
        case .searchStarted:
            return mainModuleModel.searchList
        }
    }
    
    func uploadSearchHistoryToUserDefaults() {
        mainModuleModel.defaults.set(mainModuleModel.searchHistoryList, forKey: "searchHistory")
    }
    
    func setFavouriteInUserDefaults(val: Bool, ticker: String) {
        mainModuleModel.defaults.set(val,  forKey: ticker)
    }
    
    func appendSearchList(stockData: StockData){
        mainModuleModel.searchList.append(stockData)
    }
    
    func clearSearchList() {
        mainModuleModel.searchList = []
    }
    
    func addStockToSearchHistory(ticker: String) {
        mainModuleModel.addStockToHistory(ticker: ticker)
    }
    
    func getSearchHistoryList() -> [String] {
        return mainModuleModel.searchHistoryList
    }
    
    func getElementFromStocksDictionary(ticker: String) -> StockModel? {
        return mainModuleModel.stocksModelDic[ticker]
    }
    
    
    
    
    func loadStockDataFromAPI() {
        mainModuleModel.stocksList = stockManager.getStockProfiles()
        
        let fetchingStocks = min(mainModuleModel.stocksList.count, 30)
        for i in 0..<fetchingStocks {
            let item = mainModuleModel.stocksList[i]
            let stockLiveData = StockLiveData(currentPrice: mainModuleModel.defaults.double(forKey: "current_price_" + item.ticker ),
                                              change: mainModuleModel.defaults.double(forKey: "change_" + item.ticker),
                                              changePercent: mainModuleModel.defaults.double(forKey: "change_percent" + item.ticker))
            
            let stockModel = StockModel(ticker: item.ticker, name: item.name, linkIcon: item.logo, stockLiveData: stockLiveData)
            mainModuleModel.setStockModel(stockModel, ticker: item.ticker)
            if self.mainModuleModel.defaults.bool(forKey: item.ticker) == true {
                self.addToFavourites(ticker: item.ticker)
            }
        }
        for i in 0..<fetchingStocks {
            let item = mainModuleModel.stocksList[i]
            
            self.stockManager.performRequest(with: item.ticker) { stockLiveData, error in
                if error != nil { return }
                guard let stockLiveData = stockLiveData else { return }
                
                let stockModel = StockModel(ticker: item.ticker, name: item.name, linkIcon: item.logo, stockLiveData: stockLiveData)
                if self.mainModuleModel.defaults.bool(forKey: item.ticker) == true {
                    stockModel.isFavourite = true
                }

                self.mainModuleModel.setStockModel(stockModel, ticker: item.ticker)
                
                self.mainModuleModel.defaults.set(stockLiveData.currentPrice, forKey: "current_price_" + item.ticker)
                self.mainModuleModel.defaults.set(stockLiveData.change, forKey: "change_" + item.ticker)
                self.mainModuleModel.defaults.set(stockLiveData.changePercent, forKey: "change_percent" + item.ticker)
                
                self.output?.updateTableView()
            }
        }
        
    }
    
    func getStockData(index: Int, currentState: StockTableViewState) -> StockData? {
        if(currentState == .stocks) {
            return mainModuleModel.stocksList[index]
        } else if(currentState == .favorite) {
            return mainModuleModel.favouriteList[index]
        } else if(currentState == .searchStarted) {
            return mainModuleModel.searchList[index]
        }
        return nil
    }
    
    func getStockModel(ticker: String) -> StockModel? {
        guard let stockModel = mainModuleModel.stocksModelDic[ticker] else { return nil }
        return stockModel
    }
    
    func isFavouriteStock(ticker: String) -> Bool {
        guard let stockModel = mainModuleModel.stocksModelDic[ticker] else { return false }
        return stockModel.isFavourite
    }
    
    func addToFavourites(ticker: String) {
        guard let stockModel = mainModuleModel.stocksModelDic[ticker] else {
            return }
        if mainModuleModel.stocksModelDic[ticker]?.isFavourite == false {
            mainModuleModel.favouriteList.append(StockData(name: stockModel.name, logo: stockModel.linkIcon, ticker: stockModel.ticker))
            mainModuleModel.stocksModelDic[ticker]?.isFavourite = true
        }
    }
    
    func removeFromFavourites(ticker: String) -> Bool {
        for i in 0..<mainModuleModel.favouriteList.count {
            if(mainModuleModel.favouriteList[i].ticker==ticker) {
                mainModuleModel.favouriteList.remove(at: i)
                mainModuleModel.stocksModelDic[ticker]?.isFavourite = false
                
            return true
            }
        }
        return false
    }
    
    func getFavouriteListSize() -> Int {
        return mainModuleModel.favouriteList.count
    }
    
}
