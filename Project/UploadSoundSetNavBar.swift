//
//  UploadSoundSetNavBar.swift
//  Project
//
//  Created by Miguel Chavez on 9/2/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import UIKit

extension UploadSoundSetController {
    func setupNavigationBar() {
        hideKeyboardWhenTappedAround()
        self.navigationItem.title = "Upload Sound Sets"
        
        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.navigationController?.navigationBar.barTintColor = UIColor.rbg(red: 100, green: 100, blue: 100)
        
        let searchButton = UIBarButtonItem(image: UIImage(named: "search")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showSearchBar))
        
        let menuButton = UIBarButtonItem(image: UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(launchMenu))
        
        navigationItem.rightBarButtonItem =  searchButton
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
