//
//  MenuHeader.swift
//  Project
//
//  Created by Miguel Chavez on 8/6/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import UIKit
class MenuHeader: UICollectionViewCell {
    
    var userName: String? {
        didSet{
            usernameLabel.text = userName;
            
        }
    }
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Walcome"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.rbg(red: 100, green: 100, blue: 100)
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "User123"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.white
        return label
    }()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "music2")
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.rbg(red: 10, green: 10, blue: 10)
        
        addSubview(userImageView)
        addSubview(textLabel)
        addSubview(usernameLabel)
        
        userImageView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 70, heightConstant: 70)
        userImageView.anchorCenterXToSuperview()
        
        textLabel.anchor(top: userImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 0, heightConstant: 20)
        textLabel.anchorCenterXToSuperview()
        
        usernameLabel.anchor(top: textLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 0, heightConstant: 20)
        usernameLabel.anchorCenterXToSuperview()
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        addSubview(separatorView)
        separatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 0, heightConstant: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
