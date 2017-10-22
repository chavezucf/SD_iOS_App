//
//  EditDoundSetNavBar.swift
//  Project
//
//  Created by Miguel Chavez on 9/19/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import UIKit
import Firebase

extension EditSoundSetController{
    
    func setupNavigationBarItemList() {
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = UIColor.rbg(red: 100, green: 100, blue: 100)
        navBar?.isTranslucent = false
        navBar?.tintColor = UIColor.black
        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "add").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAdd))
        let subButton = UIBarButtonItem(image: #imageLiteral(resourceName: "minus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSub))
        navigationItem.rightBarButtonItems = [addButton, subButton]
        
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "SoundSetMenu").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(back))
        let deleteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "minus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDelete))
        navigationItem.leftBarButtonItems = [backButton, deleteButton]
        
        navigationItem.title = "Sound Set"
        
    }
    
    func back() {
        self.myProtocol?.fetchUserUpdatedSoundSets(false)
        dismiss(animated: true, completion: nil)
    }
    
    func handleAdd() {
        if(sounds!.count < 8) {
            let key = "sound" + String(sounds!.count + 1)
            self.sounds?[key] = "Select a Sound"
            self.collectionView?.reloadData()
        }
    }
    func handleSub() {
        if(sounds!.count > 0) {
            let key = "sound" + String(sounds!.count)
            self.sounds?.removeValue(forKey: key)
            self.collectionView?.reloadData()
        }
    }
    func handleDelete() {
        print("Delete")
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        guard let ssID = self.soundSet?.ssID else { return }
        let soundsetPostRef = FIRDatabase.database().reference().child("soundSets").child(uid)
        
        soundsetPostRef.child(ssID).removeValue { (error, ref) in
            if error != nil {
                print("error \(error)")
            }
            print("Succ to DB")
            self.myProtocol?.fetchUserUpdatedSoundSets(true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

