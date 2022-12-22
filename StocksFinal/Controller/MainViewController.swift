import UIKit


final class MainViewController: UIViewController {

    
    private let searchBar = SearchBarView()
    private let label = LabelView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
        addSubviews()
        setupLayout()
    }
    
    func addSubviews() {
        view.addSubview(searchBar.seacrhBarView)
        view.addSubview(label.labelView)
        view.addSubview(tableView)
        searchBar.addSubviews()
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
    }
}



extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! StockTableViewCell
        return cell
    }
}
