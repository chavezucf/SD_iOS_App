//
//  SoundSetModel.swift
//  Project
//
//  Created by Miguel Chavez on 9/2/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import Foundation

struct SoundSet {
    var ssID: String
    var name: String
    var createdDate: String
    var soundsDictionary: [String:Any]
    
    init(ssID: String, dictionary: [String: Any]) {
        self.ssID = ssID
        self.name = dictionary["name"] as? String ?? ""
        self.createdDate = dictionary["date"] as? String ?? ""
        self.soundsDictionary = dictionary["sounds"] as? [String:Any] ?? [:]
    }
}
