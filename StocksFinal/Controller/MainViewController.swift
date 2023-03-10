import UIKit

enum StockTableViewState {
    case stocks
    case favorite
    case search
    case searchStarted
}


final class MainViewController: UIViewController{
    
    private let stockManager: StockManager
    private var mainModuleModel: MainModuleModel
    
    let defaults = UserDefaults.standard
    
    var endEditing: Bool = true
    
    
    var lastMainPageState: StockTableViewState = .stocks
    var currentState: StockTableViewState = .stocks {
        didSet {
            if(currentState == .stocks || currentState == .favorite) { lastMainPageState = currentState }
            searchBarView.searchTextField.resignFirstResponder()
            currentStateConfigurations()
        }
    }
    
    init(stockManager: StockManager, mainModel: MainModuleModel) {
        
        self.stockManager = stockManager
        self.mainModuleModel = mainModel
        mainModuleModel.searchHistoryList = defaults.object(forKey: "searchHistory") as? [String] ?? []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupStocksList()
        setupView()
        setupButtons()
    }
    
    
    
    //MARK: - Private methods:
    
    private func currentStateConfigurations() {
        stocksTableView.isHidden = (currentState != .search) ? false : true
        if (currentState == .favorite && mainModuleModel.favouriteList.count == 0) { stocksTableView.isHidden = true }
        
        searchView.isHidden = currentState == .search ? false : true
        
        searchBarView.searchButton.isHidden = (currentState == .stocks || currentState == .favorite) ? false : true
        searchBarView.backButton.isHidden = (currentState == .stocks || currentState == .favorite) ? true : false
        searchBarView.clearButton.isHidden = currentState == .searchStarted ? false : true
        
        noElementLabel.isHidden = (currentState == .favorite && mainModuleModel.favouriteList.count == 0) ? false : true
        
        stockButtonsView.stocksButton.isHidden = (currentState == .stocks || currentState == .favorite) ? false : true
        stockButtonsView.favourButton.isHidden = (currentState == .stocks || currentState == .favorite) ? false : true
        stockButtonsView.stocksButtonInSearch.isHidden = (currentState == .searchStarted) ? false : true
        
        updateTable()
    }
    
    
    private func setupStocksList() {
        mainModuleModel.stocksList = stockManager.getStockProfiles()
        
        
        let fetchingStocks = min(mainModuleModel.stocksList.count, 30)
        for i in 0..<fetchingStocks {
            let item = mainModuleModel.stocksList[i]
            let stockLiveData = StockLiveData(currentPrice: defaults.double(forKey: "current_price_" + item.ticker ),
                                              change: defaults.double(forKey: "change_" + item.ticker),
                                              changePercent: defaults.double(forKey: "change_percent" + item.ticker))
            
            let stockModel = StockModel(ticker: item.ticker, name: item.name, linkIcon: item.logo, stockLiveData: stockLiveData)
            self.mainModuleModel.setStockModel(stockModel, ticker: item.ticker)
            if self.defaults.bool(forKey: item.ticker) == true {
                self.addToFavourites(ticker: item.ticker)
            }
        }
        

        
        for i in 0..<fetchingStocks {
            let item = mainModuleModel.stocksList[i]
            
            self.stockManager.performRequest(with: item.ticker) { stockLiveData, error in
                if let error = error {
                    print(error)
                    return
                }
                guard let stockLiveData = stockLiveData else {
                    return
                }
                let stockModel = StockModel(ticker: item.ticker, name: item.name, linkIcon: item.logo, stockLiveData: stockLiveData)
                if self.defaults.bool(forKey: item.ticker) == true {
                    stockModel.isFavourite = true
                }

                self.mainModuleModel.setStockModel(stockModel, ticker: item.ticker)
                
                self.defaults.set(stockLiveData.currentPrice, forKey: "current_price_" + item.ticker)
                self.defaults.set(stockLiveData.change, forKey: "change_" + item.ticker)
                self.defaults.set(stockLiveData.changePercent, forKey: "change_percent" + item.ticker)
                
                
                
                DispatchQueue.main.async {
                    self.updateTable()
                }
                
            }
        }
    }
    
    private func setupView() {
        mainModuleModel.searchHistoryList = defaults.object(forKey: "searchHistory") as? [String] ?? []
        view = UIView()
        view.backgroundColor = .white
        searchBarView.searchTextField.delegate = self
        stocksTableView.dataSource = self
        stocksTableView.delegate = self
        stocksTableView.allowsSelection = true
        addSubviews()
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            searchBarView.widthAnchor.constraint(equalToConstant: 150),
            searchBarView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            searchBarView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            searchBarView.heightAnchor.constraint(equalToConstant: 50),
            
            searchView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 30),
            searchView.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchView.heightAnchor.constraint(equalToConstant: 300.0),

            stockButtonsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 118),
            stockButtonsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            stockButtonsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            stockButtonsView.heightAnchor.constraint(equalToConstant: 32),
            
            stocksTableView.topAnchor.constraint(equalTo:stockButtonsView.bottomAnchor, constant: 10.0),
            stocksTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            stocksTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            stocksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            noElementLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noElementLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
        ])
        
    }
    
    private func addSubviews() {
        view.addSubview(searchBarView)
        view.addSubview(stockButtonsView)
        view.addSubview(stocksTableView)
        view.addSubview(noElementLabel)
        view.addSubview(searchView)
    }

    private func setupButtons() {
        stockButtonsView.stocksButton.addTarget(self, action: #selector(stockButtonAction), for: .touchUpInside)
        stockButtonsView.favourButton.addTarget(self, action: #selector(favourButtonAction), for: .touchUpInside)
        searchBarView.backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        searchBarView.clearButton.addTarget(self, action: #selector(clearButtonAction), for: .touchUpInside)
    }
    
    private func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    private func updateTable() {
        stocksTableView.reloadData()
    }
    
    private func buttonIsChosen(button: UIButton, text: String) {
        button.setAttributedTitle(NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.font : MontserratFont.makefont(name: .bold, size: 28),
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.baselineOffset : 0.0
        ]), for: .normal)
    }
    
    private func buttonIsUnchosen(button: UIButton, text: String) {
        button.setAttributedTitle(NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.font : MontserratFont.makefont(name: .bold, size: 18),
            NSAttributedString.Key.foregroundColor : UIColor.gray,
            NSAttributedString.Key.baselineOffset : 1.5
        ]), for: .normal)
    }
    
    
    
    //MARK: - Button Actions:
    func popularButtonAction(name: String) {
        searchBarView.searchTextField.text = name
    }
    
    @objc func clearButtonAction(_sender: UIButton?) {
        searchBarView.searchTextField.text = ""
    }
    
    
    @objc func backButtonAction(_sender: UIButton?) {
        currentState = lastMainPageState
    }
    
    @objc func stockButtonAction(_sender: UIButton?) {
        guard !stockButtonsView.stockChosen else {
            return
        }
        
        buttonIsUnchosen(button: stockButtonsView.favourButton, text: "Favourites")
        buttonIsChosen(button: stockButtonsView.stocksButton, text: "Stocks")
        stockButtonsView.stockChosen=true
        currentState = .stocks
        
    }
    
    @objc func favourButtonAction(_sender: UIButton?) {
        guard stockButtonsView.stockChosen else {
            return
        }
        
        buttonIsChosen(button: stockButtonsView.favourButton, text: "Favourites")
        buttonIsUnchosen(button: stockButtonsView.stocksButton, text: "Stocks")
        stockButtonsView.stockChosen=false
        currentState = .favorite
    }
    
    
    
    //MARK: - UI Elements:
    
    private let stockButtonsView: StockButtonsView = {
        let view = StockButtonsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let searchBarView: SearchBarView = {
        let searchBarView = SearchBarView()
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        return searchBarView
    } ()
    
    private lazy var searchView : SearchView = {
        let search = SearchView(searchHistory: mainModuleModel.searchHistoryList, buttonAction: { string in
            self.popularButtonAction(name: string)
        })
        search.translatesAutoresizingMaskIntoConstraints = false
        search.isHidden = true
        return search
    } ()
    
    private let stocksTableView : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(StockTableViewCell.self, forCellReuseIdentifier: "reusableCell")
        table.allowsSelection = true
        table.separatorColor = .white
        return table
    }()
    
    private let noElementLabel : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No favourite stocks"
        label.font = MontserratFont.makefont(name: .semibold, size: 18.0)
        label.textColor = .gray
        return label
    } ()

}

//MARK: - UITextFieldDelegate


extension MainViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentState = .search
        isEditing = true
    }
 
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if((currentState != .search && currentState != .searchStarted)
           || isEditing == false
        )  {
            isEditing = true
            return true
        }
        return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if(currentState != .search && currentState != .searchStarted)  {
            return true
        }
        return false
    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let searchText = textField.text else { return }
        
        mainModuleModel.searchList = []
        
        if(searchText == "") {
            currentState = .search
        } else {
            var count = 0;
            for item in mainModuleModel.stocksList {
                let ticker = item.ticker.lowercased()
                let name = item.name.lowercased()
                var isfound = false
                if (searchText.count <= ticker.count) {
                    if(searchText.lowercased() == ticker[..<ticker.index(ticker.startIndex, offsetBy: searchText.count)]) {
                        mainModuleModel.searchList.append(item)
                        isfound = true
                    }
                }
                
                if(searchText.count <= name.count && isfound == false) {
                    if(searchText.lowercased() == name[..<name.index(name.startIndex, offsetBy: searchText.count)]) {
                        mainModuleModel.searchList.append(item)
                    }
                }
                count+=1;
                
                if count == 30 {
                    break
                }
            }
            currentState = .searchStarted
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, text != ""{
            mainModuleModel.addStockToHistory(ticker: text)
        }
        defaults.set(mainModuleModel.searchHistoryList, forKey: "searchHistory")
//        defaults.set([], forKey: "searchHistory")

        searchView.updateRequestView(requests: mainModuleModel.searchHistoryList)
        
        isEditing = false
        resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
    
}




//MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (currentState == .stocks) {
            return 30
        } else if (currentState == .favorite){
            return mainModuleModel.favouriteList.count
        } else if (currentState == .searchStarted) {
            return mainModuleModel.searchList.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as? StockTableViewCell else {
            return UITableViewCell()
        }
        
        
        if (currentState == .stocks) {
            cell.configureCell(stocksList: mainModuleModel.stocksList, index: indexPath.row)
            let ticker = mainModuleModel.stocksList[indexPath.row].ticker
            if let stockModel = mainModuleModel.stocksModelDic[ticker] {
                cell.stockModel = stockModel
            }
        } else if (currentState == .favorite) {
            cell.configureCell(stocksList: mainModuleModel.favouriteList, index: indexPath.row)
            let ticker = mainModuleModel.favouriteList[indexPath.row].ticker
            if let stockModel = mainModuleModel.stocksModelDic[ticker] {
                cell.stockModel = stockModel
            }
        
        } else if(currentState == .searchStarted) {
            cell.configureCell(stocksList: mainModuleModel.searchList, index: indexPath.row)
            let ticker = mainModuleModel.searchList[indexPath.row].ticker
            if let stockModel = mainModuleModel.stocksModelDic[ticker] {
                cell.stockModel = stockModel
            }
        }
       
        cell.delegate = self
        
        let view = UIView()
        cell.selectedBackgroundView = view
        let newSize = CGSize(width: (cell.bounds.width-32), height: 74)
        let newOrigin = CGPoint(x: 16, y: 0)
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .systemGray3
        selectedBackgroundView.layer.cornerRadius = 18.0
        selectedBackgroundView.frame = CGRect(origin: newOrigin, size: newSize)
        cell.selectedBackgroundView!.addSubview(selectedBackgroundView)
     
        return cell
    }
   
    
}


//MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print(mainModuleModel.stocksList[indexPath.row])
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var currentTicker: String = ""
        
        if(currentState == .stocks) {
            currentTicker = mainModuleModel.stocksList[indexPath.row].ticker
        } else if(currentState == .favorite) {
            currentTicker = mainModuleModel.favouriteList[indexPath.row].ticker
        } else if(currentState == .searchStarted) {
            currentTicker = mainModuleModel.searchList[indexPath.row].ticker
        }
        
        guard let currentStockModel = mainModuleModel.stocksModelDic[currentTicker] else { return }
        
        let stockDetailsModel = StockDetailsModel()
        let stockDetailsViewModel = StockDetailsViewModel(stockDetailsModel: stockDetailsModel, stockManager: self.stockManager)
        let stockDetailsViewController = StockDetailsViewController(stockDetailsViewModel: stockDetailsViewModel, stockModel: currentStockModel, starPressed: { ticker in
            if(self.isFavouriteStock(ticker: ticker)) {
                self.removeFromFavourites(ticker: ticker)
            } else {
                self.addToFavourites(ticker: ticker)
            }
            self.updateStockTableView()
        })
        stockDetailsViewModel.setStockDetailsView(stockDetailsView: stockDetailsViewController)
        
        stockDetailsViewController.modalPresentationStyle = .fullScreen
        presentDetail(stockDetailsViewController)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82.0
    }
    
}


//MARK: - StocksTableViewCellDelegate

extension MainViewController: StockTableViewCellDelegate {
    
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
    
    func getCurrentState() -> StockTableViewState {
        return currentState
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
        
        
        defaults.set(true, forKey: ticker)
        
    }
    
    func removeFromFavourites(ticker: String) {
        for i in 0..<mainModuleModel.favouriteList.count {
            if(mainModuleModel.favouriteList[i].ticker==ticker) {
                mainModuleModel.favouriteList.remove(at: i)
                mainModuleModel.stocksModelDic[ticker]?.isFavourite = false
                if(mainModuleModel.favouriteList.count == 0 && currentState == .favorite) {
                    noElementLabel.isHidden = false
                }
                defaults.set(false,  forKey: ticker)
            return
            }
        }
        
    }
    
    func getStockTableViewState() -> StockTableViewState {
        return currentState
    }
    
    func updateStockTableView() {
        updateTable()
    }
}
  
