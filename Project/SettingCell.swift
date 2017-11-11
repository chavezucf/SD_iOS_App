//
//  SettingCell.swift
//  Project
//
//  Created by Miguel Chavez on 10/21/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import UIKit

class SettingCell: UICollectionViewCell {
    
    var setting: Settings? {
        didSet {
            let attributedText = NSMutableAttributedString(string: "\((setting?.type)!):", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20)])
            attributedText.append(NSAttributedString(string: " \((setting?.UserInput)!)", attributes: [ NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 20)]))
            settingsImageView.image = setting?.typeImage
            nameLabel.attributedText = attributedText
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let settingsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "gearBlack")
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        addSubview(settingsImageView)
        settingsImageView.anchor(top: topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, widthConstant: 30, heightConstant: 30)
        
        addSubview(nameLabel)
        nameLabel.anchor(top: self.topAnchor, left: settingsImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, widthConstant: 0, heightConstant: 0)
        nameLabel.anchorCenterYToSuperview()
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.black
        
        addSubview(separatorView)
        separatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 0, heightConstant: 1.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
