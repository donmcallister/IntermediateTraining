//
//  CompanyCell.swift
//  IntermediateTraining
//
//  Created by Donald McAllister on 9/18/19.
//  Copyright © 2019 Donald McAllister. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell {
    
    var company: Company? {
        didSet {
            nameFoundedDateLabel.text = company?.name
            
            if let imageData = company?.imageData {
              companyImageView.image = UIImage(data: imageData)
             }
            
            if let name = company?.name, let founded = company?.founded {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                let foundedDateString = dateFormatter.string(from: founded)
                
                let dateString = "\(name) - Founded: \(foundedDateString)"
                nameFoundedDateLabel.text = dateString
            } else {
                nameFoundedDateLabel.text = company?.name
            }

        }
    }
    
    let companyImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.darkBlue.cgColor
        return imageView
    }()
    
    let nameFoundedDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Company Name"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.tealColor
        
        addSubview(companyImageView)
        companyImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(nameFoundedDateLabel)
        nameFoundedDateLabel.leftAnchor.constraint(equalTo: companyImageView.rightAnchor, constant: 8).isActive = true
        nameFoundedDateLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameFoundedDateLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        nameFoundedDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
