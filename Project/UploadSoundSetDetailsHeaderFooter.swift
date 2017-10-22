//
//  UploadSoundSetDetailsHeaderFooter.swift
//  Testly.moc1
//
//  Created by Miguel Chavez on 5/9/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//


import Firebase

class UploadSoundSetDetailsHeader: UICollectionViewCell {
    
    var masterView: UploadSoundSetDeatilsController? {
        didSet {
            let style = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.center
            let soundSetName = masterView?.soundSetName
            self.soundSetName.attributedText = NSAttributedString(string: soundSetName! , attributes:[NSForegroundColorAttributeName: UIColor.black, NSParagraphStyleAttributeName: style])
        }
    }
    
    lazy var soundSetName: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 1, alpha: 0.5)
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.layer.cornerRadius = 5
        tf.layer.masksToBounds = true
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.black.cgColor
        tf.isUserInteractionEnabled = false
        return tf
    }()
    
    let logoImageView: UIImageView = {
        let logo = UIImageView()
        logo.image = #imageLiteral(resourceName: "music")
        logo.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        logo.contentMode = .scaleAspectFit
        return logo
    }()
    
    let headerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor =  UIColor(white: 1, alpha: 0.5)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    
    
    func saveToMasterview(){
        masterView?.soundSetName = soundSetName.text
    }

    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        addSubview(headerContainerView)
        headerContainerView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 250, heightConstant: 200)
        headerContainerView.anchorCenterXToSuperview()
        headerContainerView.addSubview(logoImageView)
        headerContainerView.addSubview(soundSetName)
        logoImageView.anchor(top: headerContainerView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 100, heightConstant: 100)
        logoImageView.anchorCenterXToSuperview()
        soundSetName.anchor(top: logoImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 200, heightConstant: 50)
        soundSetName.anchorCenterXToSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UploadSoundSetDetailsFooter: UICollectionViewCell {
    
}
