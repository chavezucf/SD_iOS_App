//
//  DownloadSongController.swift
//  Project
//
//  Created by Miguel Chavez on 7/30/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//
import UIKit
import Firebase
import AVFoundation

class DownloadSongController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    
    
    let startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.rbg(red: 51, green: 105, blue: 255)
        button.setTitle("Get", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(Get2), for: .touchUpInside)
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 38)
        label.textAlignment = .center
        label.text = "GetSong"
        return label
    }()
    
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26)
        label.textAlignment = .center
        label.text = "Send it away"
        return label
    }()
    
    
    let moduleImageView: UIImageView = {
        let imageView = UIImageView()
        var color = 0
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "music-player")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        if FIRAuth.auth()?.currentUser == nil {
            //show if not logged in
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            
            return
        }*/
        
        
        self.navigationItem.title = "Bluetooth"
        
        view.backgroundColor = UIColor.blue
        setupNavigationBarItemList()
        
        view.addSubview(moduleImageView)
        view.addSubview(startButton)
        view.addSubview(nameLabel)
        view.addSubview(captionLabel)
        
        
        nameLabel.anchorCenterXToSuperview()
        nameLabel.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 70, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 300, heightConstant: 40)
        
        captionLabel.anchorCenterXToSuperview()
        captionLabel.anchor(top: nameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 400, heightConstant: 35)
        
        moduleImageView.anchorCenterXToSuperview()
        moduleImageView.anchor(top: captionLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 70, heightConstant: 70)
        
        startButton.anchorCenterXToSuperview()
        startButton.anchor(top: moduleImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 80, heightConstant: 80)
        
    }
    
    @IBAction func Get(sender: UIButton) {
        if let audioUrl = URL(string: "gs://sd-project-d3893.appspot.com/music/Drum1.mp3") {
            // create your document folder url
            let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            // your destination file url
            let destination = documentsUrl.appendingPathComponent(audioUrl.lastPathComponent)
            print(destination)
            
            // check if it exists before downloading it
            if FileManager().fileExists(atPath: destination.path) {
                print("The file already exists at path")
            }
            else {
                //  if the file doesn't exist
                //  just download the data from your url
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) in
                    // after downloading your data you need to save it to your destination url
                    guard
                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                        let mimeType = response?.mimeType, mimeType.hasPrefix("audio"),
                        let location = location, error == nil
                        else { return }
                    do {
                        try FileManager.default.moveItem(at: location, to: destination)
                        print("file saved")
                    } catch {
                        print(error)
                    }
                }).resume()
                playSound()
            }
        }
    }
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    func Get2(sender: UIButton) {
        let musicURL = "https://firebasestorage.googleapis.com/v0/b/sd-project-d3893.appspot.com/o/music%2FDrum1.mp3?alt=media&token=1bf96927-27d2-4192-8ef1-c63917355f1e"
        if let url = URL(string: musicURL) {
            let player = AVPlayer(url: url)
            player.play()
            print("Playing")
            playerLayer = AVPlayerLayer(player: player)
            
        }
        
    }
    
    func playSound()
    {
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: "Users/miguelchavez/Library/Developer/CoreSimulator/Devices/2A755D7F-CBC8-4641-95A8-4BCA053E6D16/data/Containers/Data/Application/A391E4D7-6CA5-4D9E-A660-E7053C7B7B0F/Documents/Drum1.mp3"))
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print(error)
            
        }
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
