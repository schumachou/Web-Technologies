//
//  PlacesFavoriteViewController.swift
//  CS571_HW9
//
//  Created by ChouCheng-I on 4/24/17.
//  Copyright © 2017 Chris Chou. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import SwiftSpinner
import Alamofire

class PlacesFavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var page : Int = 0
    
    var favoritesArray : [FavoriteData]? = {
        
        if let decodedData  = UserDefaults.standard.object(forKey: "place") as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? [FavoriteData]
        }
        return [FavoriteData]()
        
    }()
    
    //    var favoritesArray : [FavoriteData]?{
    //        get {
    //            if let decodedData  = UserDefaults.standard.object(forKey: "page") as? Data {
    //                return NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? [FavoriteData]
    //            }
    //            return [FavoriteData]()
    //        }
    //    }
    
    
    lazy var nextButton : UIButton = {
        
        let btn = UIButton()
        btn.setTitle("Next", for: .normal)
        if self.favoritesArray!.count > 10 {
            btn.setTitleColor(UIColor(red:0.00, green:0.44, blue:1.00, alpha:1.00), for: .normal)
        } else {
            btn.setTitleColor(.lightGray, for: .normal)
            btn.isUserInteractionEnabled = false
        }
        btn.setTitleColor(.lightGray, for: .highlighted)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(onNextButtonTapped), for: .touchUpInside)
        return btn
        
    }()
    
    lazy var previousButton : UIButton = {
        
        let btn = UIButton()
        btn.setTitle("Previous", for: .normal)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.setTitleColor(.lightGray, for: .highlighted)
        btn.isUserInteractionEnabled = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(onPreviousButtonTapped), for: .touchUpInside)
        return btn
        
    }()
    
    lazy var tableView : UITableView = {
        
        let tb = UITableView()
        tb.dataSource = self
        tb.delegate = self
        tb.isHidden = true
        tb.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "Cell")
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
        
    }()
    
    lazy var noDataLabel : UILabel = {
        
        let label = UILabel()
        label.text = "No data found."
        label.font = UIFont.systemFont(ofSize: 20)
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favoritesArray?.removeAll()
        
        if let decodedData  = UserDefaults.standard.object(forKey: "place") as? Data {
            if let array = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? [FavoriteData]{
                favoritesArray = array
            }
        }
        
        if  favoritesArray?.count != 0 {
            if self.tableView.isHidden == true {
                self.tableView.isHidden = false
                self.noDataLabel.isHidden = true
            }
        } else {
            self.tableView.isHidden = true
            self.noDataLabel.isHidden = false
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        navigationController?.navigationBar.isTranslucent = false
        
        tableView.tableFooterView = UIView()
        
    }
    
    func onPreviousButtonTapped(){
        
        page -= 1
        
        if page == 0 {
            previousButton.setTitleColor(.lightGray, for: .normal)
            previousButton.isUserInteractionEnabled = false
        }
        
        if favoritesArray!.count - page*10 > 10 {
            nextButton.setTitleColor(UIColor(red:0.00, green:0.44, blue:1.00, alpha:1.00), for: .normal)
            nextButton.isUserInteractionEnabled = true
        }
        
        tableView.reloadData()
        print("Current page : \(page)")
        
    }
    
    func onNextButtonTapped(){
        
        page += 1
        
        if page == 1 {
            previousButton.setTitleColor(UIColor(red:0.00, green:0.44, blue:1.00, alpha:1.00), for: .normal)
            previousButton.isUserInteractionEnabled = true
        }
        
        if favoritesArray!.count - page*10 <= 10 {
            nextButton.setTitleColor(.lightGray, for: .normal)
            nextButton.isUserInteractionEnabled = false
        }
        
        tableView.reloadData()
        print("Current page : \(page)")
        
    }
    
    func setupViews(){
        
        view.addSubview(nextButton)
        view.addSubview(previousButton)
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nextButton.leftAnchor.constraint(equalTo: previousButton.rightAnchor).isActive = true
        
        previousButton.bottomAnchor.constraint(equalTo: nextButton.bottomAnchor).isActive = true
        previousButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        previousButton.widthAnchor.constraint(equalTo: nextButton.widthAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: nextButton.topAnchor).isActive = true
        
        view.addSubview(noDataLabel)
        noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let numCells : Int
        if page == 0 {
            numCells = favoritesArray!.count < 10 ? favoritesArray!.count : 10
        } else if page == 1 {
            numCells = favoritesArray!.count < 20 ? favoritesArray!.count - 10 : 10
        } else {
            numCells = favoritesArray!.count < 25 ? favoritesArray!.count - 20 : 5
        }
        return numCells
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchResultTableViewCell
        
        let trueIndex = indexPath.row + page*10
        
        let userData = favoritesArray![trueIndex]
        
        if let urlString =  userData.url{
            
            if let urlObject = URL(string: urlString){
                
                cell.userImg.sd_setImage(with: urlObject, placeholderImage: #imageLiteral(resourceName: "users"))
                
            }
            
        }
        
        cell.nameTextLable.text = userData.name
        
        if let idString =  userData.id {
            if UserDefaults.standard.object(forKey: idString) != nil {
                cell.favoriteButton.image = #imageLiteral(resourceName: "filled")
            } else {
                cell.favoriteButton.image = #imageLiteral(resourceName: "empty")
            }
        }
        else {
            cell.favoriteButton.image = #imageLiteral(resourceName: "empty")
        }
        
        return cell
        
    }
    
    //after clicking the cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Perform search
        SwiftSpinner.show("Loading data...")
        
        let parameters: Parameters = ["id": favoritesArray![indexPath.row].id!, "type": "place"]
        
        Alamofire.request("https://csci571-hw8-163123.appspot.com/main.php", parameters: parameters).responseJSON { [weak self] (response) in
            
            if let json = response.result.value{
                
                let resultDetailVC = ResultDetailViewController()
                
                resultDetailVC.jsonData = JSON.init(rawValue: json)
                resultDetailVC.id = self?.favoritesArray![indexPath.row].id
                resultDetailVC.type = "place"
                resultDetailVC.url = self?.favoritesArray![indexPath.row].url
                resultDetailVC.name = self?.favoritesArray![indexPath.row].name
                
                self?.navigationController?.pushViewController(resultDetailVC, animated: false)
                SwiftSpinner.hide()
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
