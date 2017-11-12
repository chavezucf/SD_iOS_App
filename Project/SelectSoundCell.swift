//
//  AddCell3.swift
//  Testly.moc1
//
//  Created by Miguel Chavez on 5/9/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class SelectSoundCell: UICollectionViewCell {
    var name: String? {
        didSet{
            let attributedText = NSMutableAttributedString(string: " \(name!)", attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: 20)])
            nameLabel.attributedText = attributedText
        }
    }
    var sid: String?
    var uid: String?
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "select")
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "play-button (1)").withRenderingMode(.alwaysOriginal), for: UIControlState.normal)
        button.addTarget(self, action: #selector(play), for: .touchUpInside)
        return button
    }()
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    @IBAction func play(sender: UIButton)  {
        guard let uid = self.uid else {return}
        guard let sid = self.sid else {return}
        FIRDatabase.database().reference().child("sounds").child(uid).child(sid).child("soundUrl").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let musicURL = String(describing: snapshot.value!)
            print(musicURL)
            if let url = URL(string: musicURL) {
                let player = AVPlayer(url: url)
                player.play()
                print("Playing")
                self.playerLayer = AVPlayerLayer(player: player)
            }
            
        }) { (err) in
            print("Failed to fetch user", err)
        }
    }
    
  
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        addSubview(checkImageView)
        checkImageView.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 15, paddingRight: 40, widthConstant: 30, heightConstant: 30)
        
        addSubview(playButton)
        playButton.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, widthConstant: 30, heightConstant: 30)
        playButton.anchorCenterYToSuperview()
        
        addSubview(nameLabel)
        nameLabel.anchor(top: topAnchor, left: playButton.rightAnchor, bottom: bottomAnchor, right: checkImageView.leftAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, widthConstant: 0, heightConstant: 0)
        nameLabel.anchorCenterYToSuperview()

        let separatorView1 = UIView()
        separatorView1.backgroundColor = UIColor.black
        
        addSubview(separatorView1)
        separatorView1.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widthConstant: 0, heightConstant: 1.5)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
