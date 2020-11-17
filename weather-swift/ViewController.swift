//
//  ViewController.swift
//  weather-swift
//
//  Created by Артем Балышев on 17.11.2020.
//  Copyright © 2020 Артем Балышев. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UISearchResultsUpdating {

    var timer: Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupRootVC()
    }
    
    private func setupRootVC() {
        self.navigationItem.title = "weather-swift"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    //MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        let city = searchController.searchBar.text!
        
        guard city != "" else {
            return
        }
        
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
            NetworkManager.shared.getWeather(for: city) { (model) in
                for mod in model!.list! {
                    print(mod.main!.temp!)
                }
            }
        }
    }
    


}

