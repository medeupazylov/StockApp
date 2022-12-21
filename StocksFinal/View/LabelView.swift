import UIKit

class LabelView {
    let labelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        let stocksButton = UIButton()
        view.addSubview(stocksButton)
        stocksButton.translatesAutoresizingMaskIntoConstraints = false
        stocksButton.setAttributedTitle(NSAttributedString(string: "Stocks", attributes: [
            NSAttributedString.Key.font : UIFont(name: "Montserrat-Bold", size: 28)!,
            NSAttributedString.Key.foregroundColor : UIColor.black
        ]),
        for: .normal)
        
        let favourButton = UIButton()
        view.addSubview(favourButton)
        favourButton.translatesAutoresizingMaskIntoConstraints = false
        favourButton.setAttributedTitle(NSAttributedString(string: "Favourite", attributes: [
            NSAttributedString.Key.font : UIFont(name: "Montserrat-Bold", size: 18)!,
            NSAttributedString.Key.foregroundColor : UIColor.gray
        ]),
        for: .normal)
        
        
        
        NSLayoutConstraint.activate([
            stocksButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            stocksButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 3),
            
            favourButton.leftAnchor.constraint(equalTo: stocksButton.rightAnchor, constant: 20),
            favourButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        
        return view
    } ()
}
