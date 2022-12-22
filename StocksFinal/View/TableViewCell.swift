import UIKit

final class StockTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupCell() {
        self.contentView.addSubview(innerView)
        innerView.addSubview(stockImageView)
        innerView.addSubview(containerView)
        containerView.addSubview(stockLabel)
        containerView.addSubview(stockPrice)
        containerView.addSubview(stockName)
        containerView.addSubview(stockRate)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            self.contentView.heightAnchor.constraint(equalToConstant: 68),
            
            innerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            innerView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            innerView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            innerView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            
            stockImageView.centerYAnchor.constraint(equalTo: innerView.centerYAnchor),
            stockImageView.leftAnchor.constraint(equalTo: innerView.leftAnchor, constant: 8),
            stockImageView.topAnchor.constraint(equalTo: innerView.topAnchor, constant: 8),
            stockImageView.widthAnchor.constraint(equalToConstant: 52),
            stockImageView.heightAnchor.constraint(equalToConstant: 52),

            containerView.centerYAnchor.constraint(equalTo: innerView.centerYAnchor),
            containerView.leftAnchor.constraint(equalTo: stockImageView.rightAnchor, constant: 12),
            containerView.rightAnchor.constraint(equalTo: innerView.rightAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 40),
            
            stockPrice.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -17),
            stockName.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            stockRate.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            stockRate.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12),
            
            
        ])
    }
    
    let innerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    } ()
    
    let stockImageView: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .gray
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 15
        img.clipsToBounds = true
        return img
    } ()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "AAPL"
        label.font = MontserratFont.makefont(name: .bold, size: 18)
        
        return label
    } ()
    
    let stockName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Apple Inc."
        label.font = MontserratFont.makefont(name: .semibold, size: 12)
        return label
    } ()
    
    let stockPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$999.9"
        label.font = MontserratFont.makefont(name: .bold, size: 18)
        return label
    } ()
    
    let stockRate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "+$0.00 (0.00%)"
        label.font = MontserratFont.makefont(name: .semibold, size: 12)
        label.textColor = .init(red: 36/255, green: 179/255, blue: 93/255, alpha: 1.0)
        return label
    } ()
    
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    } ()
    

    
    
}
