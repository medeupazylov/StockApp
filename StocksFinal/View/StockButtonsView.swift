import UIKit

final class StockButtonsView: UIView {
    
    var stockChosen = true
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func addSubviews() {
        self.addSubview(stocksButton)
        self.addSubview(favourButton)
        self.addSubview(stocksButtonInSearch)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            stocksButton.leftAnchor.constraint(equalTo: self.leftAnchor),
            stocksButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            stocksButtonInSearch.leftAnchor.constraint(equalTo: self.leftAnchor),
            stocksButtonInSearch.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            favourButton.leftAnchor.constraint(equalTo: stocksButton.rightAnchor, constant: 20),
            favourButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    

    let stocksButton: UIButton  = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Stocks", attributes: [
            NSAttributedString.Key.font : MontserratFont.makefont(name: .bold, size: 28),
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.baselineOffset : 0.0
        ]),
        for: .normal)
        return button
    } ()
    
    
    let favourButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Favourite", attributes: [
            NSAttributedString.Key.font : MontserratFont.makefont(name: .bold, size: 18),
            NSAttributedString.Key.foregroundColor : UIColor.gray,
            NSAttributedString.Key.baselineOffset : 1.5
        ]),
        for: .normal)
        return button
    } ()
    
    let stocksButtonInSearch: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Stocks", attributes: [
            NSAttributedString.Key.font : MontserratFont.makefont(name: .bold, size: 18),
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.baselineOffset : 1.5
        ]),
        for: .normal)
        button.isHidden = true
        return button
    } ()

}
