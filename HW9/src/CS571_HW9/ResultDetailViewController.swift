//
//  ResultDetailViewController.swift
//  CS571_HW9
//
//  Created by Chris Chou. on 4/9/17.
//  Copyright © 2017 Chris Chou. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Alamofire

//import FacebookShare
//import FacebookCore
//import FacebookLogin
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit



class FavoriteData: NSObject, NSCoding {
    
    var id : String?
    var name : String?
    var url : String?
    var type : String?
    
    
    init(id: String, name: String, url: String, type: String) {
        self.id = id
        self.name = name
        self.url = url
        self.type = type
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let url = aDecoder.decodeObject(forKey: "url") as! String
        let type = aDecoder.decodeObject(forKey: "type") as! String
        self.init(id: id, name: name, url: url, type: type)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(type, forKey: "type")
    }
    
}


class ResultDetailViewController: UITabBarController,FBSDKSharingDelegate{
    
    /**
     Sent to the delegate when the sharer is cancelled.
     - Parameter sharer: The FBSDKSharing that completed.
     */
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print("Share did Cancel")
    }
    
    /**
    Sent to the delegate when the sharer encounters an error.
     - Parameter sharer: The FBSDKSharing that completed.
     - Parameter error: The error.
     */
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        print("Share did Fail with error : \(error.localizedDescription)")
    }

    /**
     Sent to the delegate when the share completes without error or cancellation.
     - Parameter sharer: The FBSDKSharing that completed.
     - Parameter results: The results from the sharer.  This may be nil or empty.
     */
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print("Share did complete")
        self.view.showToast("Shared!", position: .bottom, popTime: 3, dismissOnTap: false)
    }
    

 

    let albumVC = ResultDetailAlbumsViewController()
    let postVC = ResultDetailPostsViewController()
    
    var jsonData : JSON! {
        didSet {
            albumVC.jsonData = jsonData
        }
    }
    
    var id : String!
    var type : String!
    var url : String!
    var name: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        navigationItem.title = "Details"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "options"), style: .plain, target: self, action: #selector(showMore))
        
        //let albumsVC = ResultDetailAlbumsViewController()
        albumVC.title = "Albums"
        albumVC.tabBarItem.image = #imageLiteral(resourceName: "album")
        
        //let postsVC = ResultDetailPostsViewController()
        postVC.title = "Posts"
        postVC.tabBarItem.image = #imageLiteral(resourceName: "posts")
        
        addChildViewController(albumVC)
        addChildViewController(postVC)
        
    }
    
    func setupViews(){
        
        view.backgroundColor = .white
        
    }

    func showMore(){
        
        let alertVC = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
        
        if UserDefaults.standard.object(forKey: self.id) != nil {
            
            alertVC.addAction(UIAlertAction(title: "Remove from favorites", style: .default, handler: { action in
               
                var favoritesArray : [FavoriteData]!
                
                switch self.type {
                    case "user":
                        let decodedData  = UserDefaults.standard.object(forKey: "user") as! Data
                        favoritesArray = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as! [FavoriteData]
                        var index = 0
                        for data in favoritesArray {
                            if data.id == self.id {
                                break
                            }
                            index += 1
                        }
                        favoritesArray.remove(at:index)
                        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: favoritesArray!)
                        UserDefaults.standard.set(encodedData, forKey: "user")
                        UserDefaults.standard.removeObject(forKey: self.id)
                        
                    case "page":
                        let decodedData  = UserDefaults.standard.object(forKey: "page") as! Data
                        favoritesArray = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as! [FavoriteData]
                        var index = 0
                        for data in favoritesArray {
                            if data.id == self.id {
                                break
                            }
                            index += 1
                        }
                        favoritesArray.remove(at:index)
                        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: favoritesArray!)
                        UserDefaults.standard.set(encodedData, forKey: "page")
                        UserDefaults.standard.removeObject(forKey: self.id)
                        
                    case "event":
                        let decodedData  = UserDefaults.standard.object(forKey: "event") as! Data
                        favoritesArray = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as! [FavoriteData]
                        var index = 0
                        for data in favoritesArray {
                            if data.id == self.id {
                                break
                            }
                            index += 1
                        }
                        favoritesArray.remove(at:index)
                        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: favoritesArray!)
                        UserDefaults.standard.set(encodedData, forKey: "event")
                        UserDefaults.standard.removeObject(forKey: self.id)
                        
                    case "place":
                        let decodedData  = UserDefaults.standard.object(forKey: "place") as! Data
                        favoritesArray = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as! [FavoriteData]
                        var index = 0
                        for data in favoritesArray {
                            if data.id == self.id {
                                break
                            }
                            index += 1
                        }
                        favoritesArray.remove(at:index)
                        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: favoritesArray!)
                        UserDefaults.standard.set(encodedData, forKey: "place")
                        UserDefaults.standard.removeObject(forKey: self.id)
                        
                    case "group":
                        let decodedData  = UserDefaults.standard.object(forKey: "group") as! Data
                        favoritesArray = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as! [FavoriteData]
                        var index = 0
                        for data in favoritesArray {
                            if data.id == self.id {
                                break
                            }
                            index += 1
                        }
                        favoritesArray.remove(at:index)
                        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: favoritesArray!)
                        UserDefaults.standard.set(encodedData, forKey: "group")
                        UserDefaults.standard.removeObject(forKey: self.id)
                    default:
                        break
                }
                
                self.view.showToast("Remove from favorites!", position: .bottom, popTime: 3, dismissOnTap: false)
                
            }))
            
        } else {
            
            alertVC.addAction(UIAlertAction(title: "Add to favorites", style: .default, handler: { action in
                
                let favoriteData = FavoriteData(id: self.id, name:  self.name, url: self.url, type: self.type)
                var favoritesArray : [FavoriteData]?

                switch self.type {
                    case "user":
                        if  let decodedData  = UserDefaults.standard.object(forKey: "user") as? Data{
                            favoritesArray = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? [FavoriteData]
                        } else {
                            favoritesArray = [FavoriteData]()
                        }
                        favoritesArray!.append(favoriteData)
                        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: favoritesArray!)
                        UserDefaults.standard.set(encodedData, forKey: "user")
                        UserDefaults.standard.set("1", forKey: self.id)
                        UserDefaults.standard.synchronize()

                    case "page":
                        if  let decodedData  = UserDefaults.standard.object(forKey: "page") as? Data{
                            favoritesArray = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? [FavoriteData]
                        } else {
                            favoritesArray = [FavoriteData]()
                        }
                        favoritesArray!.append(favoriteData)
                        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: favoritesArray!)
                        UserDefaults.standard.set(encodedData, forKey: "page")
                        UserDefaults.standard.set("1", forKey: self.id)
                        UserDefaults.standard.synchronize()
                        
                    case "event":
                        if  let decodedData  = UserDefaults.standard.object(forKey: "event") as? Data{
                            favoritesArray = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? [FavoriteData]
                        } else {
                            favoritesArray = [FavoriteData]()
                        }
                        favoritesArray!.append(favoriteData)
                        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: favoritesArray!)
                        UserDefaults.standard.set(encodedData, forKey: "event")
                        UserDefaults.standard.set("1", forKey: self.id)
                        UserDefaults.standard.synchronize()

                    case "place":
                        if  let decodedData  = UserDefaults.standard.object(forKey: "place") as? Data{
                            favoritesArray = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? [FavoriteData]
                        } else {
                            favoritesArray = [FavoriteData]()
                        }
                        favoritesArray!.append(favoriteData)
                        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: favoritesArray!)
                        UserDefaults.standard.set(encodedData, forKey: "place")
                        UserDefaults.standard.set("1", forKey: self.id)
                        UserDefaults.standard.synchronize()
                        
                    case "group":
                        if  let decodedData  = UserDefaults.standard.object(forKey: "group") as? Data{
                            favoritesArray = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? [FavoriteData]
                        } else {
                            favoritesArray = [FavoriteData]()
                        }
                        favoritesArray!.append(favoriteData)
                        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: favoritesArray!)
                        UserDefaults.standard.set(encodedData, forKey: "group")
                        UserDefaults.standard.set("1", forKey: self.id)
                        UserDefaults.standard.synchronize()
                    default:
                        break
                }
                
                self.view.showToast("Add to favorites!", position: .bottom, popTime: 3, dismissOnTap: false)

            }))
            
        }
        
        
        alertVC.addAction(UIAlertAction(title: "Share", style: .default, handler: { action in
            
            
            let content :FBSDKShareLinkContent = FBSDKShareLinkContent()
            
            content.contentURL = NSURL(string: "https://scontentxx.fbcdn.net") as URL!
            
            
            content.contentTitle = self.name
            content.contentDescription = "FB Share for CSCI571"
            content.imageURL = NSURL(string: self.url)! as URL
            
            let dialog : FBSDKShareDialog = FBSDKShareDialog()
            dialog.delegate = self
            dialog.fromViewController = self
            dialog.shareContent = content
            dialog.mode = FBSDKShareDialogMode.native
            
            if !dialog.canShow() {
                dialog.mode = FBSDKShareDialogMode.automatic
            }
            
            //FBSDKShareDialog.show(from:self, with: content, delegate: self)
            
            dialog.show()
 
            
            
            /*
            let content = LinkShareContent(url: URL.init(string: "scontentxx.fbcdn.net")! ,
                                           title: self.name,
                                           description: "FB Share for CSCI571",
                                           imageURL: URL.init(string: self.url)! )
            
            let dialog = ShareDialog(content: content)
            dialog.presentingViewController = self
            dialog.mode = .automatic
            
            do {                                
                
                
                try ShareDialog.show(from: self.parent!, content: content, completion: {
                    result in
                    
                    print("Share Pressed")
                    
                    switch result {
                    case .success(let response):
                        self.view.showToast("Shared!", position: .bottom, popTime: 3, dismissOnTap: false)
                        print("Graph Request Succeeded: \(response)")
                    case .failed(let error):
                        print("Graph Request Failed: \(error)")
                    case .cancelled:
                        print("Graph Request Cancelled")
                        self.view.showToast("Cancelled!", position: .bottom, popTime: 3, dismissOnTap: false)
                    }
                })

                try dialog.show()
                
                
            } catch (let error){
                print("Error : \(error.localizedDescription) ")
        
            }
            */
            
            /*
            let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
            content.contentURL = URL(string: "scontentxx.fbcdn.net")
            content.contentTitle = self.name
            content.contentDescription = "FB Share for CSCI571"
            content.imageURL = URL(string: self.url)
            FBSDKShareDialog.show(from: self.parent, with: content, delegate:self)
            //FBSDKShareDialog.sho
            print("Share Pressed")
            */
    
            

            
        }))
        
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler:nil))
        
        present(alertVC, animated: true, completion: nil)
        
        
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        SwiftSpinner.show("Loading data...")
        
        if item.title! == "Albums" {
            
            let parameters: Parameters = ["id": id, "type": type]
            
            Alamofire.request("https://csci571-hw8-163123.appspot.com/main.php", parameters: parameters).responseJSON { [weak self] (response) in
                
                if let json = response.result.value{
                    
                    self?.albumVC.jsonData = JSON.init(rawValue: json)
                    SwiftSpinner.hide()
                    
                }
                
            }
            
        } else if item.title! == "Posts" {
            
            let parameters: Parameters = ["id": id, "type": type]
            
            Alamofire.request("https://csci571-hw8-163123.appspot.com/main.php", parameters: parameters).responseJSON { [weak self] (response) in
                
                if let json = response.result.value{
                    
                    self?.postVC.jsonData = JSON.init(rawValue: json)
                    self?.postVC.url = self?.url
                    SwiftSpinner.hide()
                    
                }
                
            }
        
        }
        
    }

    
}
