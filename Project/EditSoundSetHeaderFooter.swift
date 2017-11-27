//
//  AddModuleHeaderFooter.swift
//  Testly.moc1
//
//  Created by Miguel Chavez on 5/9/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//


import Firebase

class EditSoundSetHeader: UICollectionViewCell {
    
    var masterView: EditSoundSetController? {
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
        /*tf.font = UIFont.systemFont(ofSize: 18)
        tf.layer.cornerRadius = 5
        tf.layer.masksToBounds = true
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.black.cgColor*/
        
        tf.backgroundColor = UIColor(white: 1, alpha: 0.5)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.borderWidth = 1.5
        tf.addTarget(self, action: #selector(saveToMasterview), for: .editingDidEnd)
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

class EditSoundSetFooter: UICollectionViewCell {
    var masterView: EditSoundSetController?
    var classCaption: String?
    var className: String?
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(white: 1, alpha: 0.5)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handelSave), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    func handelSave() {
        
        
        var values = [String:Any]()
        
        guard let ssID = masterView?.soundSet?.ssID else { return }
        guard let sounds = masterView?.sounds else { return }
        guard let name = masterView?.soundSetName else { return }
        
        if (sounds.count < 1) { return }
        if (name == "") { return }
        
        let soundValues = Array(sounds.values)
        
        for value in soundValues {
            if (String(describing: value) == "Select a Sound") { return }
        }
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        let date = formatter.string(from: currentDateTime)
        
        
        values["name"] = name
        values["sounds"] = sounds
        values["date"] = date
        
        
        //POST
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        if(masterView?.soundSet?.ssID == String(-1)){
            let userPostRef = FIRDatabase.database().reference().child("soundSets").child(uid)
            
            let ref = userPostRef.childByAutoId()
            
            
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to DB", err)
                    return
                }
                print("Succ to DB")
                self.masterView?.myProtocol?.fetchUserUpdatedSoundSets(true)
                self.masterView?.dismiss(animated: true, completion: nil)

            }
        }
        //PUT
        else {
            
            let soundsetPostRef = FIRDatabase.database().reference().child("soundSets").child(uid).child(ssID)
        
            soundsetPostRef.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to DB", err)
                    return
                }
                print("Succ to DB")
                self.masterView?.myProtocol?.fetchUserUpdatedSoundSets(true)
                self.masterView?.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(saveButton)
        saveButton.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 150, heightConstant: 100)
        saveButton.anchorCenterXToSuperview()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
