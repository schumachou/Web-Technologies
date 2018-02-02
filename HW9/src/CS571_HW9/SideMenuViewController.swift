//
//  SideMenuViewController.swift
//  CS571_HW9
//
//  Created by Chris Chou on 4/7/17.
//  Copyright © 2017 Chris Chou. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let searchVC = SearchViewController()
    let aboutMeVC = AboutMeViewController()
    let favoriteVC = FavoriteViewController()
    
    var aboutMeTableViewCell : UITableViewCell = {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "aboutMeTableViewCell")
        cell.textLabel?.text = "About me"
        return cell
        
    }()
    
    var homeTableViewCell : UITableViewCell = {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "homeTableViewCell")
        cell.textLabel?.text = "Home"
        cell.imageView?.image = #imageLiteral(resourceName: "home")
        return cell
        
    }()
    
    var favoriteTableViewCell : UITableViewCell = {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "favoriteTableViewCell")
        cell.textLabel?.text = "Favorites"
        cell.imageView?.image = #imageLiteral(resourceName: "black")
        return cell
        
    }()
    
    var facebookTableViewCell : UITableViewCell = {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "favoriteTableViewCell")
        cell.textLabel?.text = "FB Search"
        cell.imageView?.image = #imageLiteral(resourceName: "fb")
        cell.isUserInteractionEnabled = false
        return cell
        
    }()
    
    lazy var tableView : UITableView = {
        
        let tv = UITableView(frame: .zero, style: UITableViewStyle.grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.dataSource = self
        tv.delegate = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tv
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupViews(){
        
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: -30).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    //actions after clicking the cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if indexPath.section == 0{
            
            // Facebook Search
//            let searchVC = SearchViewController()
//            navigationController?.pushViewController(searchVC, animated: false)
            
        }else if indexPath.section == 1 {
            
            if indexPath.row == 0{
                
                // Home                
                let searchVC = SearchViewController()
                navigationController?.pushViewController(searchVC, animated: false)
                
                
            }else{
                
                // Favorites
                let favoriteVC = FavoriteViewController()
                navigationController?.pushViewController(favoriteVC, animated: false)
            }
            
        }else{
            
            // About me
            let aboutMeVC = AboutMeViewController()
            navigationController?.pushViewController(aboutMeVC, animated: false)
            
            
        }
        
        
    }
    
    //set title for each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 1 { return "MENU" }
        else if section == 2 { return "OTHERS" }
        
        return nil
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    //the content each cell shows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            return facebookTableViewCell
            
        }else if indexPath.section == 1 {
            
            if indexPath.row == 0{
                
                return homeTableViewCell
                
            }else{
                
                return favoriteTableViewCell
            }
            
        }else{
            
            return aboutMeTableViewCell
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 { return 1 }
        else if section == 1 { return 2 }
        else{ return 1 }
        
    }
    
    
    
}
