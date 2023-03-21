import UIKit

final class SearchBarView {
    
    let seacrhBarView: UIView = {
        let seacrhView = UIView()
        seacrhView.backgroundColor = .white
        seacrhView.translatesAutoresizingMaskIntoConstraints = false
        seacrhView.layer.cornerRadius = 25
        seacrhView.layer.borderWidth = 1.0
        seacrhView.layer.borderColor = UIColor.black.cgColor
        return seacrhView
    } ()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Find company or ticker", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black,  NSAttributedString.Key.font : MontserratFont.makefont(name: .semibold, size: 16)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()
    
    
    let searchIconView: UIImageView = {
        let searchIcon = UIImage(systemName: "magnifyingglass")
        let iconView = UIImageView(image: searchIcon!)
        iconView.tintColor = .black
        iconView.translatesAutoresizingMaskIntoConstraints = false
        return iconView
    } ()
    
    func addSubviews() {
        searchButton.addSubview(searchIconView)
        seacrhBarView.addSubview(searchTextField)
        seacrhBarView.addSubview(searchButton)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            
            searchButton.heightAnchor.constraint(equalToConstant: 25),
            searchButton.widthAnchor.constraint(equalToConstant: 25),
            searchButton.centerYAnchor.constraint(equalTo: seacrhBarView.centerYAnchor),
            searchButton.leftAnchor.constraint(equalTo: seacrhBarView.leftAnchor, constant: 16),
            
            searchIconView.widthAnchor.constraint(equalTo: searchButton.widthAnchor),
            searchIconView.heightAnchor.constraint(equalTo: searchButton.heightAnchor),
            
            searchTextField.leftAnchor.constraint(equalTo: searchIconView.rightAnchor, constant: 10),
            searchTextField.centerYAnchor.constraint(equalTo: searchIconView.centerYAnchor),
            
            
        ])
    }
    
}
