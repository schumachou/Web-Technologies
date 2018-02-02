//
//  SearchResultsViewController.swift
//  CS571_HW9
//
//  Created by Chris Chou on 4/8/17.UITabBarController
//  Copyright © 2017 Chris Chou. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Alamofire

class SearchResultsViewController: UITabBarController {
    
    var jsonData : JSON!
    var keyword : String!
    
    let userVC = UsersResultViewController()
    let pageVC = PagesResultViewController()
    let eventVC = EventsResultViewController()
    let placeVC = PlacesResultViewController()
    let groupVC = GroupsResultViewController()
    
    init(withJSON: JSON) {
        jsonData = withJSON
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        navigationItem.title = "Search Results"
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
        
        userVC.jsonData = self.jsonData
        
    }
    
    func setupViews(){
        
        view.backgroundColor = .white
        
    }
    

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        SwiftSpinner.show("Loading data...")
        
        switch item.title! {
            
        case "Users":
            
            let parameters: Parameters = ["keyword": keyword]
            
            Alamofire.request("https://csci571-hw8-163123.appspot.com/main.php", parameters: parameters).responseJSON { [weak self] (response) in
                
                if let json = response.result.value{
                    
                    self?.userVC.jsonData = JSON.init(rawValue: json)
                    
                    SwiftSpinner.hide()
                    
                }
            }

        case "Pages":
            
            let parameters: Parameters = ["keyword": keyword]
            
            Alamofire.request("https://csci571-hw8-163123.appspot.com/", parameters: parameters).responseJSON { [weak self] (response) in
                
                if let json = response.result.value{
                    
//                    self?.pageVC.jsonData = nil
                    self?.pageVC.jsonData = JSON.init(rawValue: json)
                    
                    SwiftSpinner.hide()
                    
                }
                
            }
            
        case "Events":
            
            let parameters: Parameters = ["keyword": keyword]
            
            Alamofire.request("https://csci571-hw8-163123.appspot.com/", parameters: parameters).responseJSON { [weak self] (response) in
                
                if let json = response.result.value{
                    
                    self?.eventVC.jsonData = JSON.init(rawValue: json)
                    SwiftSpinner.hide()
                    
                }
                
            }
            
        case "Places":
            
            let parameters: Parameters = ["keyword": keyword]
            
            Alamofire.request("https://csci571-hw8-163123.appspot.com/", parameters: parameters).responseJSON { [weak self] (response) in
                
                if let json = response.result.value{
                    
                    self?.placeVC.jsonData = JSON.init(rawValue: json)
                    SwiftSpinner.hide()
                    
                }
                
            }
            
        case "Groups":
            
            let parameters: Parameters = ["keyword": keyword]
            
            Alamofire.request("https://csci571-hw8-163123.appspot.com/", parameters: parameters).responseJSON { [weak self] (response) in
                
                if let json = response.result.value{
                    
                    self?.groupVC.jsonData = JSON.init(rawValue: json)
                    SwiftSpinner.hide()
                    
                }
                
            }
         
        default:
            break
        }
        
    }
    
}
