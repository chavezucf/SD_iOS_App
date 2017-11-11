//
//  MenuLauncher.swift
//  Project
//
//  Created by Miguel Chavez on 8/6/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import UIKit
import Firebase

class MenuSelection: NSObject {
    let name: String
    let imageName: String
    
    init(name: String, imageName: String)
    {
        self.name = name
        self.imageName = imageName
    }
}

class MenuLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    var user: User? {
        didSet{
        }
    }
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let cellId = "cellId"
    
    let menuSelctions: [MenuSelection] = {
        return [MenuSelection(name: "Sound Sets", imageName: "music"), MenuSelection(name: "Upload", imageName: "bluetooth"), MenuSelection(name: "Settings", imageName: "gearBlack"), MenuSelection(name: "Test Bluetooth", imageName: "logoff")]
    }()
    
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = UIColor.rbg(red: 210, green: 210, blue: 210)
        
        collectionView.register(MenuHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    func showMenu() {
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.75)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            
            window.addSubview(collectionView)
            let width: CGFloat = 225
            collectionView.frame = CGRect(x: -window.frame.width, y: 0, width: width, height: window.frame.height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.85, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: 0, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                
            }, completion: nil)
        }
    }
    
    func handleDismiss() {
        UIView.animate(withDuration: 0.85, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: -window.frame.width, y: 0 , width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.85, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: -window.frame.width, y: 0 , width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }) { completion in
            
            print(indexPath.item)
            if let window = UIApplication.shared.keyWindow {
                guard let rootViewController = window.rootViewController else {
                    return
                }
                var navController = UINavigationController()
                if(indexPath.item == 0)
                {
                    let layout = UICollectionViewFlowLayout()
                    let mySoundSetController = SoundSetController(collectionViewLayout: layout)
                    navController = UINavigationController(rootViewController: mySoundSetController)
                }
                else if(indexPath.item == 1)
                {
                    let layout = UICollectionViewFlowLayout()
                    let myUploadSoundSetController = UploadSoundSetController(collectionViewLayout: layout)
                    navController = UINavigationController(rootViewController: myUploadSoundSetController)
                }
                else if(indexPath.item == 2)
                {
                    let layout = UICollectionViewFlowLayout()
                    let mySettingListController = SettingListController(collectionViewLayout: layout)
                    navController = UINavigationController(rootViewController: mySettingListController)
                    /*
                     let myController = TestBluetoothController()
                     navController = UINavigationController(rootViewController: myController)
                     */
                }
                else if(indexPath.item == 3)
                {
                     let myController = TestBluetoothController()
                     navController = UINavigationController(rootViewController: myController)
                }
             
                rootViewController.present(navController, animated: true, completion: {
                    window.rootViewController = navController
                    
                })

            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuSelctions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        
        let menuSelection = menuSelctions[indexPath.item]
        cell.menuSelection = menuSelection
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! MenuHeader
        header.name = user?.name
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
    
}

