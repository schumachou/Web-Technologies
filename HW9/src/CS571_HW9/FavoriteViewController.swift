//
//  FavoriteViewController.swift
//  CS571_HW9
//
//  Created by ChouCheng-I on 4/24/17.
//  Copyright © 2017 Chris Chou. All rights reserved.
//

import UIKit

class FavoriteViewController:  UITabBarController{
    
    let userVC = UsersFavoriteViewController()
    let pageVC = PagesFavoriteViewController()
    let eventVC = EventsFavoriteViewController()
    let placeVC = PlacesFavoriteViewController()
    let groupVC = GroupsFavoriteViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        navigationItem.title = "Favorites"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(SearchResultsViewController.showMenu))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Results", style: .plain, target: self, action: nil)
        
        let titleArray = ["Users","Pages","Events","Places","Groups"]
        let imageArray = [#imageLiteral(resourceName: "users"),#imageLiteral(resourceName: "page"),#imageLiteral(resourceName: "event"),#imageLiteral(resourceName: "place"),#imageLiteral(resourceName: "groups")]
        let vcArray = [userVC,pageVC,eventVC,placeVC,groupVC]
        
        for i in 0..<vcArray.count{
            vcArray[i].title = titleArray[i]
            vcArray[i].tabBarItem.image = imageArray[i]
            addChildViewController(vcArray[i])
            
        }
        
        
    }
    
    func setupViews(){
        
        view.backgroundColor = .white
        
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
