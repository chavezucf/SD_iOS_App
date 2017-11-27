//
//  TeacherAddModuleController2.swift
//  Testly.moc1
//
//  Created by Miguel Chavez on 5/9/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import UIKit
import Firebase

class SelectSoundController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate  {
    
    var selectedItemSID: String!
    let cellID = "cellID"
    
    var sounds = mainUser!.soundsArray
    var filteredSounds = mainUser!.soundsArray
    
    var dbSounds = dbUser!.soundsArray
    var filteredDBSounds = dbUser!.soundsArray
    var key: String? {
        didSet {
            for sound in sounds {
                if(sound.sid == key) {
                    selectedItemSID = key
                }
            }
            for sound in dbSounds {
                if(sound.sid == key) {
                    selectedItemSID = key
                }
            }
            
        }
    }
    var channel: Int? {
        didSet {
            navigationItem.title = "Channel " + String(describing: channel!)
        }
    }
    var masterView: EditSoundSetController? {
        didSet{
            //var soundTitle = masterView?.sounds[index!]
        }
    }
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter Sound Set Name"
        sb.barTintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rbg(red: 250, green: 250, blue: 250)
        sb.delegate = self
        sb.alpha = 0
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        collectionView?.register(SelectSoundHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        
        collectionView?.register(SelectSoundFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerId")
        
        collectionView?.register(SelectSoundCell.self, forCellWithReuseIdentifier: cellID)
        
        
        collectionView?.backgroundColor = UIColor(patternImage: UIImage(named: "wood2")!)
        setupNavigationBar()
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag
        
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return filteredSounds.count
        }else if section == 1 {
            return filteredDBSounds.count
        }
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SelectSoundCell
        if indexPath.section == 0 {
            cell.name = filteredSounds[indexPath.item].name
            cell.sid = filteredSounds[indexPath.item].sid
            cell.uid = String(describing: FIRAuth.auth()?.currentUser)
            if selectedItemSID != nil {
                cell.checkImageView.isHidden = selectedItemSID != filteredSounds[indexPath.item].sid
            }
            else {
                cell.checkImageView.isHidden = true
            }
        } else if indexPath.section == 1 {
            cell.name = filteredDBSounds[indexPath.item].name
            cell.sid = filteredDBSounds[indexPath.item].sid
            cell.uid = "MgaK3AHac7PYSasKUpJuaUJKdgl1"
            if selectedItemSID != nil {
                cell.checkImageView.isHidden = selectedItemSID != filteredDBSounds[indexPath.item].sid
            }
            else {
                cell.checkImageView.isHidden = true
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind  == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! SelectSoundHeader
            if indexPath.section == 0 {
                header.headerText = "My Sounds"
            }
            if indexPath.section == 1 {
                header.headerText = "DB Sounds"
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
    
    func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.selectedItemSID = filteredSounds[indexPath.item].sid
            masterView?.sounds?["sound" + String(describing: channel!)] = self.selectedItemSID
            masterView?.collectionView?.reloadData()
            //change is here
            dismissKeyboard()
            hideSearchBar()
            navigationController?.popViewController(animated: true)
        } else if indexPath.section == 1 {
            self.selectedItemSID = filteredDBSounds[indexPath.item].sid
            masterView?.sounds?["sound" + String(describing: channel!)] = self.selectedItemSID
            masterView?.collectionView?.reloadData()
            //change is here
            dismissKeyboard()
            hideSearchBar()
            navigationController?.popViewController(animated: true)
        }
        collectionView.reloadData()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.selectedItemSID = nil
        collectionView.reloadData()
    }
    
}

