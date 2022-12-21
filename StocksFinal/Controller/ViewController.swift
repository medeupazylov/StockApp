//
//  ViewController.swift
//  StocksFinal
//
//  Created by Medeu Pazylov on 16.12.2022.
//

import UIKit


final class ViewController: UIViewController, UITableViewDataSource {

    
    private let searchBar = SearchBarView()
    private let label = LabelView()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        view = UIView()
        view.backgroundColor = .white
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(searchBar.seacrhBarView)
        view.addSubview(label.labelView)
        view.addSubview(tableView)


        
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "reusableCell")
        
       
        
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
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! TableViewCell
        return cell
    }


}


