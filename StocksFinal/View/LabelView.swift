import UIKit

final class LabelView {
    
    var stockChosen = true
    
    let labelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    func addSubviews() {
        labelView.addSubview(stocksButton)
        labelView.addSubview(favourButton)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            stocksButton.leftAnchor.constraint(equalTo: labelView.leftAnchor),
            stocksButton.bottomAnchor.constraint(equalTo: labelView.bottomAnchor),
            
            favourButton.leftAnchor.constraint(equalTo: stocksButton.rightAnchor, constant: 20),
            favourButton.bottomAnchor.constraint(equalTo: labelView.bottomAnchor),
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

}
