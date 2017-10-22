//
//  TeacherAddModuleController2.swift
//  Testly.moc1
//
//  Created by Miguel Chavez on 5/9/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import UIKit
import Firebase

class UploadSoundSetDeatilsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    
    var soundSet: SoundSet? {
        didSet{
            sounds = soundSet?.soundsDictionary
            soundSetName = soundSet?.name
            
        }
    }
    
    var sounds:[String:Any]?
    var soundSetName:String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        collectionView?.register(UploadSoundSetDetailsHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        
        collectionView?.register(UploadSoundSetDetailsFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerId")
        
        collectionView?.register(EditSoundSetCell.self, forCellWithReuseIdentifier: cellID)
        
        
        collectionView?.backgroundColor = UIColor(patternImage: UIImage(named: "wood2")!)
        setupNavigationBarItemList()
        
        collectionView?.alwaysBounceVertical = true
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (sounds?.count)!
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! EditSoundSetCell
        cell.index = indexPath.item + 1
        let soundDictionaryKey = getSoundDictionaryKey(with: indexPath.item)
        let soundName = mainUser!.soundsDictionary[soundDictionaryKey] as? String ?? dbUser!.soundsDictionary[soundDictionaryKey] as? String ?? "Select a Sound"
        cell.soundName = soundName
        cell.sid = soundDictionaryKey
        cell.showNext = false
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
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UploadSoundSetDetailsHeader
            
            header.masterView = self
            return header
        }
        else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerId", for: indexPath) as! UploadSoundSetDetailsFooter
            
            return footer
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 20)
        
    }
    
    func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func getSoundDictionaryKey(with indexPathItem: Int) -> String{
        let newIndex = indexPathItem + 1
        let soundKey = "sound" + String(newIndex)
        return sounds?[soundKey] as! String
    }
    
}

