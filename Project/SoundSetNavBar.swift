//
//  SoundSetNavBar.swift
//  Project
//
//  Created by Miguel Chavez on 9/2/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import UIKit

extension SoundSetController {
    func setupNavigationBar() {
        hideKeyboardWhenTappedAround()
        self.navigationItem.title = "Sound Sets"
        
        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.barTintColor = UIColor.rbg(red: 10, green: 10, blue: 10)
    
        
        let searchButton = UIBarButtonItem(image: #imageLiteral(resourceName: "search").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showSearchBar))
        
        let moreButton = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addMore))
        
        let menuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "menu").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(launchMenu))
        
        navigationItem.rightBarButtonItems = [moreButton, searchButton]
        navigationItem.leftBarButtonItem = menuButton
        
        let navBar = navigationController?.navigationBar
        navBar?.addSubview(searchBar)
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 50, paddingBottom: 8, paddingRight: 50, widthConstant: 0, heightConstant: 0)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredSoundSets = soundSets
            self.hideSearchBar()
        }
        else {
            filteredSoundSets = self.soundSets.filter({ (soundSet) -> Bool in
                return soundSet.name.lowercased().contains(searchText.lowercased())
            })
        }
        
        collectionView?.reloadData()
    }
    
    func addMore() {
        let soundSet = SoundSet(ssID: "-1", dictionary: [String : Any]())
        filteredSoundSets.insert(soundSet, at: 0)
        self.collectionView?.reloadData()
    }
    
    func launchMenu() {
        menuLauncher.user = mainUser
        menuLauncher.showMenu()
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
        collectionView?.reloadData()
    }*/
}
