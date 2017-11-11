//
//  MenuCell.swift
//  Project
//
//  Created by Miguel Chavez on 8/6/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell {
    
    var menuSelection: MenuSelection? {
        didSet {
            nameLabel.text = menuSelection?.name
            if let imageName = menuSelection?.imageName {
                menuImageView.image = UIImage(named: imageName)
            }
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
        return label
    }()
    
    let menuImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "gearBlack")
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nextImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "next")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.rbg(red: 110, green: 110, blue: 110)
        
        addSubview(nameLabel)
        addSubview(menuImageView)
        addSubview(nextImageView)
        
        menuImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 0, widthConstant: 30, heightConstant: 30)
        
        nameLabel.anchor(top: self.topAnchor, left: menuImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, widthConstant: 100, heightConstant: 20)
        nextImageView.anchor(top: self.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, widthConstant: 20, heightConstant: 20)
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        addSubview(separatorView)
        separatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 0, heightConstant: 0.5)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
