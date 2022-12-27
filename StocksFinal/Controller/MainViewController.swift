import UIKit


final class MainViewController: UIViewController {
    
    private let searchBar = SearchBarView()
    private let label = LabelView()
    
    var stockManager = StockManager()
    
    var stocksList: [StockData]?
    var stocksModelList: [StockModel] = []
    var favourList: [StockData] = []
    
    var stockLiveModel: StockLiveModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupStocksList()
        print("here isrequest")
        stockManager.delegate = self
        setupView()
        setupButtons()
    }
    
    func setupStocksList () {
        self.stocksList = readJson()
        stocksModelList = []
        DispatchQueue.main.async {
            if self.stocksList != nil {
                for item in self.stocksList! {
                    self.stockManager.fetchStockPrice(stockTicker: item.ticker)
                    let image = UIImage()
                    let stockModel = StockModel(ticker: item.ticker, name: item.name, stockIcon: image, stockLiveModel: self.stockLiveModel ?? StockLiveModel(price: 0, changePrice: 0, changePricePercent: 0))
                    self.stocksModelList.append(stockModel)
                }
            }
        }
        
            
        
    }
    
    
    private let tableView : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(StockTableViewCell.self, forCellReuseIdentifier: "reusableCell")
        return table
    }()
    
    
    func setupView() {
        view = UIView()
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorColor = .white
        addSubviews()
        setupLayout()
    }
    
    func addSubviews() {
        view.addSubview(searchBar.seacrhBarView)
        view.addSubview(label.labelView)
        view.addSubview(tableView)
        searchBar.addSubviews()
        label.addSubviews()
    }
    
    
    func setupButtons() {
        label.stocksButton.addTarget(self, action: #selector(stockButtonAction), for: .touchUpInside)
        label.favourButton.addTarget(self, action: #selector(favourButtonAction), for: .touchUpInside)
    }
    
    @objc func stockButtonAction(_sender: UIButton) {
        print("Button pushed")
        if(label.stockChosen==false) {
            label.stocksButton.setAttributedTitle(NSAttributedString(string: "Stocks", attributes: [
                NSAttributedString.Key.font : MontserratFont.makefont(name: .bold, size: 28),
                NSAttributedString.Key.foregroundColor : UIColor.black,
                NSAttributedString.Key.baselineOffset : 0.0
            ]), for: .normal)
            label.favourButton.setAttributedTitle(NSAttributedString(string: "Favourite", attributes: [
                NSAttributedString.Key.font : MontserratFont.makefont(name: .bold, size: 18),
                NSAttributedString.Key.foregroundColor : UIColor.gray,
                NSAttributedString.Key.baselineOffset : 1.5
            ]),
            for: .normal)
            label.stockChosen=true
        }
    }
    
    @objc func favourButtonAction(_sender: UIButton) {
        print("Button pushed")
        if(label.stockChosen==true) {
            label.favourButton.setAttributedTitle(NSAttributedString(string: "Favourite", attributes: [
                NSAttributedString.Key.font : MontserratFont.makefont(name: .bold, size: 28),
                NSAttributedString.Key.foregroundColor : UIColor.black,
                NSAttributedString.Key.baselineOffset : 0.0
            ]), for: .normal)
            label.stocksButton.setAttributedTitle(NSAttributedString(string: "Stocks", attributes: [
                NSAttributedString.Key.font : MontserratFont.makefont(name: .bold, size: 18),
                NSAttributedString.Key.foregroundColor : UIColor.gray,
                NSAttributedString.Key.baselineOffset : 1.5
            ]),
            for: .normal)
            label.stockChosen=false
        }
    }

    
    func setupLayout() {
        NSLayoutConstraint.activate([
            searchBar.seacrhBarView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            searchBar.seacrhBarView.widthAnchor.constraint(equalToConstant: 150),
            searchBar.seacrhBarView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            searchBar.seacrhBarView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            searchBar.seacrhBarView.heightAnchor.constraint(equalToConstant: 50),

            label.labelView.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            label.labelView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            label.labelView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            label.labelView.heightAnchor.constraint(equalToConstant: 32),
            
            tableView.topAnchor.constraint(equalTo:label.labelView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        searchBar.setupLayout()
        label.setupLayout()
    }
    
    func readJson() -> [StockData]? {
        if let path = Bundle.main.path(forResource: "stockProfiles", ofType: "json") {
            do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                let json = try JSONDecoder().decode([StockData].self, from: data)
                return json
            } catch {
                print("ERROR!!!")
            }
        }
        return nil
    }
}


extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocksList!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! StockTableViewCell
        if(indexPath.row%2==0) {
            cell.innerView.backgroundColor = .systemGray6
        } else {
            cell.innerView.backgroundColor = .white
        }
        
        
        stockManager.fetchStockPrice(stockTicker: stocksList![indexPath.row].ticker)
        
        cell.stockLabel.text = stocksList![indexPath.row].ticker
        cell.stockName.text = stocksList![indexPath.row].name
        
        
        cell.starButton.addTarget(self, action: #selector(starButtonPressed), for: .touchUpInside)
        cell.stockPrice.text = String(format: "%f", Float(stockLiveModel?.price ?? 1.0))
        
        
        return cell
    }
    
    
    
    @objc func starButtonPressed(_ sender: UIButton!) {
        sender.tintColor = sender.tintColor == .systemYellow ? .systemGray : .systemYellow
    }
    
    
}

extension MainViewController: StockManagerDelegate {
    func didUpdateStock(_ stockManager: StockManager, stockLiveModel: StockLiveModel) {
        self.stockLiveModel = stockLiveModel
        print(" ")
        print("====================")
        print("MADE CHANGES")
        print("====================")
        print(" ")
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
  
