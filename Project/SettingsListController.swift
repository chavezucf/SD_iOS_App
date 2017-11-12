//
//  SettingsListController.swift
//  Project
//
//  Created by Miguel Chavez on 10/21/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//
import UIKit
import Firebase

struct Settings {
    var type: String
    var UserInput: String
    var typeImage: UIImage
}

class SettingListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    
    var settings: [Settings] = {
        
        
        let Name = Settings(type: "Name", UserInput: "", typeImage: #imageLiteral(resourceName: "user"))
        let UserName = Settings(type: "UserName", UserInput: "", typeImage: #imageLiteral(resourceName: "music"))
        let PhoneNum = Settings(type: "Phone Number", UserInput: "", typeImage: #imageLiteral(resourceName: "phone"))
        let Email = Settings(type: "Email", UserInput: "", typeImage: #imageLiteral(resourceName: "email"))
        
        return [Name,UserName,PhoneNum,Email]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(SelectSoundHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        
        collectionView?.register(SelectSoundFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerId")
        
        collectionView?.register(SettingCell.self, forCellWithReuseIdentifier: cellID)
        
        collectionView?.backgroundColor = UIColor(patternImage: UIImage(named: "wood2")!)
        
        setupNavigationBarItemList()
        collectionView?.alwaysBounceVertical = true
        setupSettings()
        
    }
    
    fileprivate func setupSettings() {
        self.settings[0].UserInput = (mainUser?.name)!
        self.settings[1].UserInput = (mainUser?.userName)!
        self.settings[2].UserInput = (mainUser?.phoneNumber)!
        self.settings[3].UserInput = (mainUser?.email)!
        
    }
    
    func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            do {
                try FIRAuth.auth()?.signOut()
                if let window = UIApplication.shared.keyWindow {
                    //change UiViews
                    guard let rootViewController = window.rootViewController else {
                        return
                    }
                    let layout = UICollectionViewFlowLayout()
                    let soundSetController = SoundSetController(collectionViewLayout: layout)
                    let navController = UINavigationController(rootViewController: soundSetController)
                    soundSetController.viewDidLoad()
                    rootViewController.present(navController, animated: true, completion: {
                        window.rootViewController = navController
                        
                    })
                }
                
            } catch let signOutErr {
                print("Failed to signout", signOutErr)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true,completion: nil)
    }
    
    fileprivate func setupNavigationBarItemList() {
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = UIColor.rbg(red: 100, green: 100, blue: 100)
        navBar?.isTranslucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "SoundSetMenu").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(launchMenu))
        
         navigationItem.title = "Settings"
    }
    
    let menuLauncher = MenuLauncher()
    
    func launchMenu() {
        menuLauncher.user = mainUser
        menuLauncher.showMenu()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SettingCell
        cell.setting = settings[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind  == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! SelectSoundHeader
                header.headerText = "Settings"
            return header
        }
        else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerId", for: indexPath) as! SelectSoundFooter
            return footer
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 10)
        
    }
}
