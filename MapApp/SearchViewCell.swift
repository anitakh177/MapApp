//
//  TableViewCell.swift
//  MapApp
//
//  Created by anita on 27.07.2022.
//

import UIKit

class SearchViewCell: UITableViewCell {
    
    static let identifier = "SearchCell"
    
     lazy var locationNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
     lazy var locationAddressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Address"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(locationNameLabel)
        contentView.addSubview(locationAddressLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        locationNameLabel.frame = CGRect(x: 5, y: 5, width: frame.size.width-20, height: 20)
        locationAddressLabel.frame = CGRect(x: 5, y: 5+locationNameLabel.frame.size.height, width: frame.size.width-20, height: 15)
    }
    
    public func configureCell(locationName: String, locationAddress: String) {
        locationNameLabel.text = locationName
        locationAddressLabel.text = locationAddress
    }

}
