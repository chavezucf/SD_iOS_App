//
//  SelectSoundNavBar.swift
//  Project
//
//  Created by Miguel Chavez on 9/3/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import UIKit

extension SelectSoundController{
    
     func setupNavigationBar() {
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = UIColor.rbg(red: 25, green: 25, blue: 25)
        navBar?.isTranslucent = false
        navBar?.tintColor = UIColor.white
        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        let searchButton = UIBarButtonItem(image: #imageLiteral(resourceName: "search").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showSearchBar))
        
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back-1").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(back))
        
        navigationItem.leftBarButtonItem = backButton
        
        navigationItem.rightBarButtonItem = searchButton
        navBar?.addSubview(searchBar)
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 8, paddingLeft: 40, paddingBottom: 8, paddingRight: 10, widthConstant: 0, heightConstant: 0)
        
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
        hideSearchBar()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredSounds = sounds
            filteredDBSounds = dbSounds
            hideSearchBar()
        }
        else {
            filteredSounds = self.sounds.filter({ (sound) -> Bool in
                return sound.name.lowercased().contains(searchText.lowercased())
            })
            filteredDBSounds = self.dbSounds.filter({ (sound) -> Bool in
                return sound.name.lowercased().contains(searchText.lowercased())
            })
        }
        
        collectionView?.reloadData()
    }
    
    func showSearchBar() {
        searchBar.alpha = 1
    }
    
    func hideSearchBar() {
        searchBar.alpha = 0
        dismissKeyboard()
    }
    
    /*
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar()
    }*/
    
}
