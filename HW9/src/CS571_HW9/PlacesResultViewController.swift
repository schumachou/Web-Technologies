//
//  PlacesResultViewController.swift
//  CS571_HW9
//
//  Created by  Chris Chou on 4/8/17.
//  Copyright © 2017 Chris Chou. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import SwiftSpinner
import Alamofire

class PlacesResultViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var page : Int = 0
    
    var userDataArray = [UserData]()
    
    var jsonData : JSON? {
        
        didSet{
            
            guard oldValue == nil else {
                return
            }
            
            for (_, subJson):(String, JSON) in jsonData!["place"]["data"] {
                
                var userData = UserData(id: nil, name: nil, url: nil, type: nil)
                
                if let id = subJson["id"].string { userData.id = id }
                if let name = subJson["name"].string { userData.name = name }
                if let url = subJson["picture"]["data"]["url"].string { userData.url = url }
                
                userDataArray.append(userData)
                
                tableView.reloadData()
                
                if self.tableView.isHidden == true {
                    self.tableView.isHidden = false
                    self.noDataLabel.isHidden = true
                }
                
            }
            
            if self.userDataArray.count > 10 {
                nextButton.setTitleColor(UIColor(red:0.00, green:0.44, blue:1.00, alpha:1.00), for: .normal)
            } else {
                nextButton.setTitleColor(.lightGray, for: .normal)
                nextButton.isUserInteractionEnabled = false
            }
            
        }
        
    }
    
    lazy var nextButton : UIButton = {
        
        let btn = UIButton()
        btn.setTitle("Next", for: .normal)
        btn.setTitleColor(UIColor(red:0.00, green:0.44, blue:1.00, alpha:1.00), for: .normal)
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
        
        if userDataArray.count - page*10 > 10 {
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
        if userDataArray.count - page*10 <= 10 {
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
            numCells = userDataArray.count < 10 ? userDataArray.count : 10
        } else if page == 1 {
            numCells = userDataArray.count < 20 ? userDataArray.count - 10 : 10
        } else {
            numCells = userDataArray.count < 25 ? userDataArray.count - 20 : 5
        }
        return numCells
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchResultTableViewCell
        
        let trueIndex = indexPath.row + page*10
        
        let userData = userDataArray[trueIndex]
        
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
        
        let trueIndex = indexPath.row + page*10
        let parameters: Parameters = ["id": userDataArray[trueIndex].id!, "type": "place"]
        
        Alamofire.request("https://csci571-hw8-163123.appspot.com/main.php", parameters: parameters).responseJSON { [weak self] (response) in
            
            if let json = response.result.value{
                //                print("JSON: \(json)")
                
                let resultDetailVC = ResultDetailViewController()
                
                resultDetailVC.jsonData = JSON.init(rawValue: json)
                resultDetailVC.id = self?.userDataArray[trueIndex].id
                resultDetailVC.type = "place"
                resultDetailVC.url = self?.userDataArray[trueIndex].url
                resultDetailVC.name = self?.userDataArray[trueIndex].name
                
                self?.navigationController?.pushViewController(resultDetailVC, animated: false)
                SwiftSpinner.hide()
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
