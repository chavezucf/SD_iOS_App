//
//  UploadSoundSetController.swift
//  Project
//
//  Created by Miguel Chavez on 8/6/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import UIKit
import Firebase
class UploadSoundSetController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, MyProtocol {
    
    let cellID = "cellID"
    let transitionDelegate: TransitioningDelegate = TransitioningDelegate()
    
    var soundSets = [SoundSet]()
    var filteredSoundSets = [SoundSet]()
    
    var dbSoundSets = [SoundSet]()
    var filteredDBSoundSets = [SoundSet]()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter Sound Set Name"
        sb.barTintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rbg(red: 250, green: 250, blue: 250)
        sb.delegate = self
        sb.alpha = 0
        return sb
    }()
    let menuLauncher = MenuLauncher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        collectionView?.register(SelectSoundHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        
        collectionView?.register(SelectSoundFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerId")
        
        collectionView?.register(SoundSetCell.self, forCellWithReuseIdentifier: cellID)
        
        collectionView?.backgroundColor = UIColor(patternImage: UIImage(named: "wood2")!)
        collectionView?.alwaysBounceVertical = true
        setupNavigationBar()
        fetchUserSoundSets()
        fetchDBSoundSets()
        fetchUser()
        fetchDBUser()
        
    }
    
    func fetchUserSoundSets() {
        soundSets.removeAll()
        //our Sound Sets
        let uid = FIRAuth.auth()?.currentUser?.uid ?? ""
        FIRDatabase.database().reference().child("soundSets").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let soundsetsDictionary = snapshot.value as? [String: Any] else { return }
            
            //print(soundsetsDictionary)
            soundsetsDictionary.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                let soundSet = SoundSet(ssID: key, dictionary: dictionary)
                self.soundSets.append(soundSet)

            })
            self.filteredSoundSets = self.soundSets
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to fetch user's Sound Sets", err)
        }
    }
    
    func fetchDBSoundSets() {
        dbSoundSets.removeAll()
        //our Sound Sets
        let uid = "MgaK3AHac7PYSasKUpJuaUJKdgl1"
        FIRDatabase.database().reference().child("soundSets").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let soundsetsDictionary = snapshot.value as? [String: Any] else { return }
            soundsetsDictionary.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                let soundSet = SoundSet(ssID: key, dictionary: dictionary)
                self.dbSoundSets.append(soundSet)
                
            })
            self.filteredDBSoundSets = self.dbSoundSets
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to fetch user's Sound Sets", err)
        }
    }
    func fetchUser() {
        //our Sound Sets
        let uid = FIRAuth.auth()?.currentUser?.uid ?? ""
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            
            mainUser = User(dictionary: userDictionary)
        }) { (err) in
            print("Failed to fetch user", err)
        }
    }
    func fetchDBUser() {
        let uid = "MgaK3AHac7PYSasKUpJuaUJKdgl1"
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            
            dbUser = User(dictionary: userDictionary)
            
        }) { (err) in
            print("Failed to fetch user", err)
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath as IndexPath, animated: true)
        
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        let attributesFrame = attributes?.frame
        let frameToOpenFrom = collectionView.convert(attributesFrame!, to: collectionView.superview)
        transitionDelegate.openingFrame = frameToOpenFrom
        
        let layout = UICollectionViewFlowLayout()
        let uploadSoundSetDeatilsController = UploadSoundSetDeatilsController(collectionViewLayout: layout)
        if indexPath.section == 0 {
            uploadSoundSetDeatilsController.soundSet = filteredSoundSets[indexPath.item]
        } else if indexPath.section == 1 {
            uploadSoundSetDeatilsController.soundSet = filteredDBSoundSets[indexPath.item]
        }
        let navEditSoundSetController = UINavigationController(rootViewController: uploadSoundSetDeatilsController)
        navEditSoundSetController.transitioningDelegate = transitionDelegate
        navEditSoundSetController.modalPresentationStyle = .custom
        present(navEditSoundSetController, animated: true, completion: nil)
 
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return filteredSoundSets.count
        }else if section == 1 {
            return filteredDBSoundSets.count
        }
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SoundSetCell
        if indexPath.section == 0 {
            cell.soundSet = filteredSoundSets[indexPath.item]
        } else if indexPath.section == 1 {
            cell.soundSet = filteredDBSoundSets[indexPath.item]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width / 2)
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind  == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! SelectSoundHeader
            if indexPath.section == 0 {
                header.headerText = "My Sound Sets"
            }
            if indexPath.section == 1 {
                header.headerText = "DB Sound Sets"
            }
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
    func fetchUserUpdatedSoundSets(_ updated: Bool) {
        if(updated) {
            self.fetchUserSoundSets()
        } else {
            filteredSoundSets = soundSets
            self.collectionView?.reloadData()
        }
    }
}
