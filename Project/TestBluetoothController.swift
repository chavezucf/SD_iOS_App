//
//  TestBluetooth.swift
//  Project
//
//  Created by Miguel Chavez on 7/15/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import UIKit
import Firebase

class TestBluetoothController: UIViewController {
    var moduleID: String?
    
    
    let onButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.setTitle("On", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(On), for: .touchUpInside)
        return button
    }()
    
    let offButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Off", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(Off), for: .touchUpInside)
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 38)
        label.textAlignment = .center
        label.text = "Test Bluetooth"
        return label
    }()
    
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26)
        label.textAlignment = .center
        label.text = "Lights"
        return label
    }()
    
    
    let moduleImageView: UIImageView = {
        let imageView = UIImageView()
        var color = 0
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "bluetooth")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Bluetooth"
        
        view.backgroundColor = UIColor.blue
        setupNavigationBarItemList()
        
        view.addSubview(moduleImageView)
        view.addSubview(onButton)
        view.addSubview(offButton)
        view.addSubview(nameLabel)
        view.addSubview(captionLabel)
        
        //setupStartLabel()
        nameLabel.anchorCenterXToSuperview()
        nameLabel.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 70, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 300, heightConstant: 40)
        
        captionLabel.anchorCenterXToSuperview()
        captionLabel.anchor(top: nameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 400, heightConstant: 35)
        
        moduleImageView.anchorCenterXToSuperview()
        moduleImageView.anchor(top: captionLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 70, heightConstant: 70)
        
        onButton.anchorCenterXToSuperview()
        onButton.anchor(top: moduleImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 80, heightConstant: 80)
        offButton.anchorCenterXToSuperview()
        offButton.anchor(top: onButton.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 80, heightConstant: 80)
        
    }
    
    var dictionary: [String:Any]?
    func On(sender: UIButton) {
        print("On")
    } 
    func Off(sender: UIButton) {
        print("Off")
    }
    
    fileprivate func setupNavigationBarItemList() {
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = UIColor.rbg(red: 100, green: 100, blue: 100)
        navBar?.isTranslucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(launchMenu))
    }
    
    let menuLauncher = MenuLauncher()
    
    func launchMenu() {
        
        menuLauncher.showMenu()
    }
    
    func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            do {
                try FIRAuth.auth()?.signOut()
                
                //change UiViews
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
                
            } catch let signOutErr {
                print("Failed to signout", signOutErr)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true,completion: nil)
    }
}
