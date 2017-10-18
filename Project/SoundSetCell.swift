//
//  SoundSetCell.swift
//  Project
//
//  Created by Miguel Chavez on 8/6/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import UIKit

class SoundSetCell: UICollectionViewCell {
    
 
    var soundSet: SoundSet? {
        didSet {
            nameLabel.text = soundSet?.name
            dateLabel.text = soundSet?.createdDate
        }
    }
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sound Set"
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "1/12/2004 12:05"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "music")
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //make it look how we want it
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0, alpha: 0)
        
        addSubview(cellView)
        
        cellView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, widthConstant: 0, heightConstant: 0)
        setupCellView()
    }
    
    func setupCellView(){
        cellView.addSubview(cellImageView)
        cellView.addSubview(nameLabel)
        cellView.addSubview(dateLabel)
        cellImageView.anchor(top: cellView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 75, heightConstant: 75)
        cellImageView.anchorCenterXToSuperview()
        
        nameLabel.anchor(top: cellImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 0, heightConstant: 20)
        nameLabel.anchorCenterXToSuperview()
        dateLabel.anchor(top: nameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 0, heightConstant: 20)
        dateLabel.anchorCenterXToSuperview()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
