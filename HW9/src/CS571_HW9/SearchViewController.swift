//
//  SearchViewController.swift
//  CS571_HW9
//
//  Created by Chris Chou on 4/7/17.
//  Copyright © 2017 Chris Chou. All rights reserved.
//

import UIKit
import SideMenu
import SwiftSpinner
import Alamofire
import SwiftyJSON
import EasyToast

class SearchViewController: UIViewController,UITextFieldDelegate{
    
    lazy var textField : UITextField = {
        
        let tf = UITextField()
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false//using auto layout by adding your own constraint
        
        tf.borderStyle = .roundedRect
//        tf.layer.cornerRadius = 5
//        tf.layer.borderColor = UIColor.lightGray.cgColor
//        tf.layer.masksToBounds = true//cornerRadius
//        tf.layer.borderWidth = 1
        return tf
        
    }()
    lazy var searchButton : UIButton = {
        
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.setTitleColor(UIColor(red:0.00, green:0.44, blue:1.00, alpha:1.00), for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onSearchButtonTapped), for: .touchUpInside)
        return button
        
    }()
    
    lazy var clearButton : UIButton = {
        
        let button = UIButton()
        button.setTitle("Clear", for: .normal)
        button.setTitleColor(UIColor(red:0.00, green:0.44, blue:1.00, alpha:1.00), for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onCancelButtonTapped), for: .touchUpInside)
        return button
        
    }()
    
    var json : JSON?
    
    func onSearchButtonTapped(){
        
        
        guard let inputString = textField.text, inputString != "" else {
            
            if view.hasDisplayedToast == false {
                self.view.showToast("Enter a valid query!", position: .bottom, popTime: 3, dismissOnTap: false)
            }
            
            return
        
        }
        
        textField.resignFirstResponder()
        
        // Perform search
        SwiftSpinner.show("Loading data...")
        
        let parameters: Parameters = ["keyword": textField.text!]
       
        Alamofire.request("https://csci571-hw8-163123.appspot.com/main.php", parameters: parameters).responseJSON { [weak self] (response) in
            
//            print(response.request)  // original URL request
//            print(response.response) // HTTP URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
            
            if let json = response.result.value{
                
//                print("JSON: \(json)")
                
                let vc = SearchResultsViewController(withJSON: JSON.init(rawValue: json)!)
//                let vc = SearchResultsViewController()
//                vc.jsonData = JSON.init(rawValue: json)
                vc.keyword = self?.textField.text!
                
                self?.navigationController?.pushViewController(vc, animated: false)
                SwiftSpinner.hide()
                
            }
            
        }
        
    }
    
    func onCancelButtonTapped(){
    
        // Empty the UITextField
        textField.text = ""
        
        textField.resignFirstResponder()
        
    }
    
    func onBackgroundViewTapped(){
        
        textField.resignFirstResponder()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews() 
        
        if SideMenuManager.menuLeftNavigationController == nil {
            configureSideMenu()
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackgroundViewTapped)))
        
        navigationItem.title = "FB Search"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(SearchViewController.showMenu))
     
    }
    
    
    func setupViews(){
        
        view.backgroundColor = .white
        
        view.addSubview(textField)
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textField.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(clearButton)
        clearButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10).isActive = true
        clearButton.leftAnchor.constraint(equalTo: textField.leftAnchor, constant: 30).isActive = true
        //clearButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(searchButton)
        searchButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10).isActive = true
        searchButton.rightAnchor.constraint(equalTo: textField.rightAnchor, constant: -30).isActive = true
        //searchButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func configureSideMenu(){
        
        // Define the menus
        let menuLeftNavigationController = UISideMenuNavigationController()
        menuLeftNavigationController.leftSide = true
        
        // UISideMenuNavigationController is a subclass of UINavigationController,
        // so do any additional configuration of it here like setting its viewControllers.
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        
        let sideMenuVC = SideMenuViewController()
        menuLeftNavigationController.viewControllers = [sideMenuVC]
        
        // Configure side menu
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuWidth = 300
        SideMenuManager.menuShadowOpacity = 0.1
        
//        SideMenuManager.menuAllowPushOfSameClassTwice = false
        
    }


}

