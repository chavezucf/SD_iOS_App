//
//  PlaySounds.swift
//  Project
//
//  Created by Miguel Chavez on 11/12/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import Firebase
import AVFoundation
/*
var playerLayer: AVPlayerLayer? {
    didSet {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "minionsFetched"), object: nil)
    }
}

func playSound(sid:String) -> AVPlayerLayer {
    var uid = dbUID
    var playerLayer: AVPlayerLayer?
    FIRDatabase.database().reference().child("sounds").child(uid).child(sid).child("soundUrl").observeSingleEvent(of: .value, with: { (snapshot) in
        
        let musicURL = String(describing: snapshot.value!)
        print(musicURL)
        if let url = URL(string: musicURL) {
            let player = AVPlayer(url: url)
            player.play()
            print("Playing")
            playerLayer = AVPlayerLayer(player: player)
        }
        
    }) { (err) in
        print("Failed to fetch user", err)
    }
    
    uid = userUID
    FIRDatabase.database().reference().child("sounds").child(uid).child(sid).child("soundUrl").observeSingleEvent(of: .value, with: { (snapshot) in
        
        let musicURL = String(describing: snapshot.value!)
        print(musicURL)
        if let url = URL(string: musicURL) {
            let player = AVPlayer(url: url)
            player.play()
            print("Playing")
            playerLayer = AVPlayerLayer(player: player)
        }
        
    }) { (err) in
        print("Failed to fetch user", err)
    }
    
    return playerLayer!
}*/
