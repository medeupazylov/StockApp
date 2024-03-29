import UIKit

enum StockTableViewState {
    case stocks
    case favorite
    case search
    case searchStarted
}


final class MainViewController: UIViewController{
    
    private let stockManager: StockManager
    private var mainViewModel: MainViewModelProvider
    
    var endEditing: Bool = true
    
    var lastMainPageState: StockTableViewState = .stocks
    var currentState: StockTableViewState = .stocks {
        didSet {
            if(currentState == .stocks || currentState == .favorite) { lastMainPageState = currentState }
            searchBarView.searchTextField.resignFirstResponder()
            currentStateConfigurations()
        }
    }
    
    init(stockManager: StockManager, mainViewModel: MainViewModelProvider) {
        
        self.mainViewModel = mainViewModel
        self.stockManager = stockManager
       
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
        if (currentState == .favorite && mainViewModel.getFavouriteListSize() == 0) { stocksTableView.isHidden = true }
        
        searchView.isHidden = currentState == .search ? false : true
        
        searchBarView.searchButton.isHidden = (currentState == .stocks || currentState == .favorite) ? false : true
        searchBarView.backButton.isHidden = (currentState == .stocks || currentState == .favorite) ? true : false
        searchBarView.clearButton.isHidden = currentState == .searchStarted ? false : true
        
        noElementLabel.isHidden = (currentState == .favorite && mainViewModel.getFavouriteListSize() == 0) ? false : true
        
        stockButtonsView.stocksButton.isHidden = (currentState == .stocks || currentState == .favorite) ? false : true
        stockButtonsView.favourButton.isHidden = (currentState == .stocks || currentState == .favorite) ? false : true
        stockButtonsView.stocksButtonInSearch.isHidden = (currentState == .searchStarted) ? false : true
        
        updateTable()
    }
    
    
    private func setupStocksList() {
        //DELETE!!!
    }
    
    private func setupView() {
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
        let search = SearchView(searchHistory: mainViewModel.getSearchHistoryList(), buttonAction: { string in
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
        
        mainViewModel.clearSearchList()
        
        if(searchText == "") {
            currentState = .search
        } else {
            var count = 0;
            for item in mainViewModel.getStocksList(for: .stocks) {
                let ticker = item.ticker.lowercased()
                let name = item.name.lowercased()
                var isfound = false
                if (searchText.count <= ticker.count) {
                    if(searchText.lowercased() == ticker[..<ticker.index(ticker.startIndex, offsetBy: searchText.count)]) {
                        mainViewModel.appendSearchList(stockData: item)
                        isfound = true
                    }
                }
                
                if(searchText.count <= name.count && isfound == false) {
                    if(searchText.lowercased() == name[..<name.index(name.startIndex, offsetBy: searchText.count)]) {
                        mainViewModel.appendSearchList(stockData: item)
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
            mainViewModel.addStockToSearchHistory(ticker: text)
        }
        mainViewModel.uploadSearchHistoryToUserDefaults()
        
        searchView.updateRequestView(requests: mainViewModel.getSearchHistoryList())
        
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
            return mainViewModel.getStocksList(for: .favorite).count
        } else if (currentState == .searchStarted) {
            return mainViewModel.getStocksList(for: .search).count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as? StockTableViewCell else {
            return UITableViewCell()
        }
        
        
        if (currentState == .stocks) {
            cell.configureCell(stocksList: mainViewModel.getStocksList(for: .stocks), index: indexPath.row)
            let ticker = mainViewModel.getStocksList(for: .stocks)[indexPath.row].ticker
            if let stockModel = mainViewModel.getElementFromStocksDictionary(ticker: ticker) {
                cell.stockModel = stockModel
            }
        } else if (currentState == .favorite) {
            cell.configureCell(stocksList: mainViewModel.getStocksList(for: .favorite), index: indexPath.row)
            let ticker = mainViewModel.getStocksList(for: .favorite)[indexPath.row].ticker
            if let stockModel = mainViewModel.getElementFromStocksDictionary(ticker: ticker) {
                cell.stockModel = stockModel
            }
        
        } else if(currentState == .searchStarted) {
            cell.configureCell(stocksList: mainViewModel.getStocksList(for: .search), index: indexPath.row)
            let ticker = mainViewModel.getStocksList(for: .search)[indexPath.row].ticker
            if let stockModel = mainViewModel.getElementFromStocksDictionary(ticker: ticker) {
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
        print(mainViewModel.getStocksList(for: .stocks)[indexPath.row])
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentTicker = mainViewModel.getStocksList(for: currentState)[indexPath.row].ticker
        
        guard let currentStockModel = mainViewModel.getElementFromStocksDictionary(ticker: currentTicker) else { return }
        
        let stockDetailsModel = StockDetailsModel(currentStockModel: currentStockModel)
        let stockDetailsViewModel = StockDetailsViewModel(stockDetailsModel: stockDetailsModel, stockManager: self.stockManager)
        let stockDetailsViewController = StockDetailsViewController(stockDetailsViewModel: stockDetailsViewModel, starPressed: { ticker in
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
        return mainViewModel.getStockData(index: index, currentState: currentState)
    }
    
    func getStockModel(ticker: String) -> StockModel? {
        return mainViewModel.getStockModel(ticker: ticker)
    }
    
    
    func isFavouriteStock(ticker: String) -> Bool {
        return mainViewModel.isFavouriteStock(ticker: ticker)
    }
    
    func addToFavourites(ticker: String) {
        mainViewModel.addToFavourites(ticker: ticker)
        mainViewModel.setFavouriteInUserDefaults(val: true, ticker: ticker)
    }
    
    func removeFromFavourites(ticker: String) {
        if mainViewModel.removeFromFavourites(ticker: ticker) {
            
            mainViewModel.setFavouriteInUserDefaults(val: false, ticker: ticker)
            
            if (mainViewModel.getFavouriteListSize() == 0 && currentState == .favorite) {
                noElementLabel.isHidden = false
            }
        }
    }
    
    func getStockTableViewState() -> StockTableViewState {
        return currentState
    }
    
    func updateStockTableView() {
        DispatchQueue.main.async {
            self.stocksTableView.reloadData()
        }
    }
}
  
extension MainViewController: MainViewModelOutput {
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.stocksTableView.reloadData()
        }
    }
    
}
