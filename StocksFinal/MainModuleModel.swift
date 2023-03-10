import UIKit

struct MainModuleModel {
    
    var stocksList: [StockData] = []
    var favouriteList: [StockData] = []
    var searchList: [StockData] = []
    var stocksModelDic: [String:StockModel] = [:]
    var searchHistoryList: [String] = []
    
    mutating func addStockToHistory(ticker: String) {
        searchHistoryList.reverse()
        searchHistoryList.append(ticker)
        if searchHistoryList.count > 12 {
            searchHistoryList.remove(at: 0)
        }
        searchHistoryList.reverse()
        
        print(searchHistoryList)
    }
    
    
    let semaphore = DispatchSemaphore(value: 1)
    
    mutating func setStockModel(_ stockModel: StockModel, ticker: String) {
        
        semaphore.wait()
        self.stocksModelDic[ticker] = stockModel
        semaphore.signal()
        
    }
}
    
    

