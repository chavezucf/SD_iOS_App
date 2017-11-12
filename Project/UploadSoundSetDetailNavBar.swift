//
//  EditDoundSetNavBar.swift
//  Project
//
//  Created by Miguel Chavez on 9/19/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import UIKit
import Firebase

extension UploadSoundSetDeatilsController{
    
    func setupNavigationBarItemList() {
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = UIColor.rbg(red: 100, green: 100, blue: 100)
        navBar?.isTranslucent = false
        navBar?.tintColor = UIColor.black
        let sendButton = UIBarButtonItem(image:  #imageLiteral(resourceName: "Send").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSend))
        navigationItem.rightBarButtonItem = sendButton
        
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "SoundSetMenu").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backButton
        
        navigationItem.title = "Send Sound Set"
        
    }
    
    func back() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleSend() {
        print("BLUETOOTH")
        print(sounds?.count)
        //print(mainUser!.soundsDictionary[sounds?["sound1"] as! String] as? String ?? dbUser!.soundsDictionary[sounds?["sound1"] as! String] as? String ?? "Select a Sound")
        for sound in sounds! {
            print(sound)
        }
    }
    
}

