//
//  SoundSetController.swift
//  Project
//
//  Created by Miguel Chavez on 8/6/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import UIKit
import Firebase
class SoundSetController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, MyProtocol {
    
    let cellID = "cellID"
    let transitionDelegate: TransitioningDelegate = TransitioningDelegate()
    
    var soundSets = [SoundSet]()
    var filteredSoundSets = [SoundSet]()
    
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
        
        collectionView?.register(SoundSetCell.self, forCellWithReuseIdentifier: cellID)
        
        collectionView?.backgroundColor = UIColor(patternImage: UIImage(named: "wood2")!)
        collectionView?.alwaysBounceVertical = true
        setupNavigationBar()
        
        
        if FIRAuth.auth()?.currentUser == nil {
            //show if not logged in
            DispatchQueue.main.async {
                let loginController = LoginController()
                loginController.soundSetController = self
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            
            return
        }
        
        collectionView?.backgroundColor = UIColor(patternImage: UIImage(named: "wood2")!)
        collectionView?.alwaysBounceVertical = true
        setupNavigationBar()
        fetchUserSoundSets()
        fetchUser()
        fetchDBUser()
        
    }
    
    func fetchUserSoundSets() {
        soundSets.removeAll()
        filteredSoundSets.removeAll()
        self.collectionView?.reloadData()
        
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
    func fetchUser() {
        //our Sound Sets
        let uid = FIRAuth.auth()?.currentUser?.uid ?? ""
        userUID = uid
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            
            mainUser = User(dictionary: userDictionary)
        }) { (err) in
            print("Failed to fetch user", err)
        }
    }
    func fetchDBUser() {
        let uid = dbUID
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
        let editSoundSetController = EditSoundSetController(collectionViewLayout: layout)
        editSoundSetController.soundSet = filteredSoundSets[indexPath.item]
        editSoundSetController.myProtocol = self
        let navEditSoundSetController = UINavigationController(rootViewController: editSoundSetController)
        navEditSoundSetController.transitioningDelegate = transitionDelegate
        navEditSoundSetController.modalPresentationStyle = .custom
        present(navEditSoundSetController, animated: true, completion: nil)
 
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return filteredSoundSets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SoundSetCell
        
        cell.soundSet = filteredSoundSets[indexPath.item]
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 10)
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
