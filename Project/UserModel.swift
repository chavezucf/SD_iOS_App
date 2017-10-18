//
//  UserModel.swift
//  Project
//
//  Created by Miguel Chavez on 9/2/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import Foundation
var mainUser : User?
var dbUser : User?

struct User {
    var email: String
    var name: String
    var phoneNumber: String
    var profileImageUrl: String
    var userName: String
    var soundsDictionary: [String:Any]
    var soundsArray = [Sound]()
    
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.phoneNumber = dictionary["phoneNumber"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
        self.soundsDictionary = dictionary["sounds"] as? [String:String] ?? [:]
        
        let keysSounds = Array(self.soundsDictionary.keys)
        for key in keysSounds {
            let tempSound = Sound(name: self.soundsDictionary[key] as! String, sid: key)
            self.soundsArray.append(tempSound)
        }
        
    }
}
