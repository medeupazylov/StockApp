import UIKit

class SearchBarView {
    
    let seacrhBarView: UIView = {
        let seacrhView = UIView()
        seacrhView.backgroundColor = .black
        seacrhView.translatesAutoresizingMaskIntoConstraints = false
        seacrhView.layer.cornerRadius = 25
        
        let innerView = UIView()
        seacrhView.addSubview(innerView)
        innerView.backgroundColor = .white
        innerView.translatesAutoresizingMaskIntoConstraints = false
        innerView.layer.cornerRadius = 24.5
//        innerView.layer.borderWidth = 2.0
//        innerView.layer.borderColor = UIColor.green.cgColor


        
        let searchIcon = UIImage(systemName: "magnifyingglass")
        
        let searchButton = UIButton()
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        seacrhView.addSubview(searchButton)
        searchButton.clipsToBounds = true
        
        
        
        let searchIconView = UIImageView(image: searchIcon!)
        searchIconView.tintColor = .black
        searchIconView.translatesAutoresizingMaskIntoConstraints = false
        searchButton.addSubview(searchIconView)
        
        let searchTextField = UITextField()
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Find company or ticker", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black,  NSAttributedString.Key.font : UIFont(name: "Montserrat-SemiBold", size: 16)!])
        
        //TODO: upload a new font and change the placeholder- Monteserrat
    
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            innerView.topAnchor.constraint(equalTo: seacrhView.topAnchor, constant: 1),
            innerView.heightAnchor.constraint(equalToConstant: 48),
            innerView.leftAnchor.constraint(equalTo: seacrhView.leftAnchor, constant: 1),
            innerView.rightAnchor.constraint(equalTo: seacrhView.rightAnchor, constant: -1),
            
            searchButton.heightAnchor.constraint(equalToConstant: 25),
            searchButton.widthAnchor.constraint(equalToConstant: 25),
            searchButton.centerYAnchor.constraint(equalTo: innerView.centerYAnchor),
            searchButton.leftAnchor.constraint(equalTo: innerView.leftAnchor, constant: 16),
            
            searchIconView.widthAnchor.constraint(equalTo: searchButton.widthAnchor),
            searchIconView.heightAnchor.constraint(equalTo: searchButton.heightAnchor),
            
            searchTextField.leftAnchor.constraint(equalTo: searchIconView.rightAnchor, constant: 10),
            searchTextField.centerYAnchor.constraint(equalTo: searchIconView.centerYAnchor),
            
            
        ])
        
        
        return seacrhView
    } ()
    
}
