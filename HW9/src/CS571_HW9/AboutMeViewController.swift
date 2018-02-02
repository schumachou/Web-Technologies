//
//  AboutMeViewController.swift
//  CS571_HW9
//
//  Created by Chris Chou on 4/7/17.
//  Copyright © 2017 Chris Chou. All rights reserved.
//

import UIKit
import SideMenu

extension UIViewController{
    
    func showMenu(){
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
}


class AboutMeViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let profileImageView = UIImageView()
        
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.image = #imageLiteral(resourceName: "IMG_0241")
        
        let nameLabel = UILabel()
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "CHOU, CHRIS CHENG-I"
        nameLabel.font = UIFont.systemFont(ofSize: 22)
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40).isActive = true
        nameLabel.textAlignment = .center
        nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        let IdLabel = UILabel()
        view.addSubview(IdLabel)
        IdLabel.translatesAutoresizingMaskIntoConstraints = false
        IdLabel.text = "7765-6318-09"
        IdLabel.font = UIFont.systemFont(ofSize: 22)
        IdLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30).isActive = true
        IdLabel.textAlignment = .center
        IdLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        IdLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(AboutMeViewController.showMenu))
        
        navigationItem.title = "About me"
        
    }
    
    
}
