//
//  ResultDetailAlbumsViewController.swift
//  CS571_HW9
//
//  Created by Chris Chou on 4/9/17.
//  Copyright © 2017 Chris Chou. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

struct DetailData {
    
    var id : String?
    var name : String?
    var picture_1 : String?
    var picture_2 : String?
    var expand : Bool?
    
}

class ResultDetailTableViewCell : UITableViewCell {
    
//    var expand : Bool = false
    
    lazy var firstImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var secondImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
 
    
    lazy var title : UILabel = {
       
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews(){
        
        contentView.addSubview(title)
        title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30).isActive = true
        title.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30).isActive = true
        title.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        title.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        contentView.addSubview(firstImageView)
        firstImageView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        firstImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        firstImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        firstImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        contentView.addSubview(secondImageView)
        secondImageView.topAnchor.constraint(equalTo: firstImageView.bottomAnchor, constant: 10).isActive = true
        secondImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        secondImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        secondImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
    
}


class ResultDetailAlbumsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedCellIndex : Int?
    
    let expanedCellHeight : CGFloat = 400.0
    
    var detailDataArray = [DetailData]()
    
    var jsonData : JSON? {
        
        didSet{
            
            guard oldValue == nil else {
                return
            }
            
            for ( _ ,subJson):(String, JSON) in jsonData!["albums"]["data"] {
                
                var detailData = DetailData(id: nil, name: nil, picture_1: nil, picture_2: nil, expand: nil)
                
//                detailData.index = index
                
                if let id = subJson["id"].string { detailData.id = id }
                if let name = subJson["name"].string { detailData.name = name }
                
                
                if let picture_1 = subJson["photos"]["data"][0]["id"].string { detailData.picture_1 = "https://graph.facebook.com/v2.8/\(picture_1)/picture?access_token=EAAFvWSvv8dUBANa7EonctP6hcNZC8uDtvkMTdYYiMAyEGwwOdjOz9GmdITVzx7NzHrOpVz69iFoz0FHc5D4oESc8nHYvFEb6YpHj0bUMSrSdISBlmwU2sC0LN5ayTbJl7oOYjMTCrCrZAR9Vgt" }
                if let picture_2 = subJson["photos"]["data"][1]["id"].string { detailData.picture_2 = "https://graph.facebook.com/v2.8/\(picture_2)/picture?access_token=EAAFvWSvv8dUBANa7EonctP6hcNZC8uDtvkMTdYYiMAyEGwwOdjOz9GmdITVzx7NzHrOpVz69iFoz0FHc5D4oESc8nHYvFEb6YpHj0bUMSrSdISBlmwU2sC0LN5ayTbJl7oOYjMTCrCrZAR9Vgt" }
                
//                if let picture_1 = subJson["photos"]["data"][0]["picture"].string { detailData.picture_1 = picture_1 }
//                if let picture_2 = subJson["photos"]["data"][1]["picture"].string { detailData.picture_2 = picture_2 }
                
                detailData.expand = false
                
                detailDataArray.append(detailData)
                
                tableView.reloadData()
                
                if self.tableView.isHidden == true {
                    self.tableView.isHidden = false
                    self.noDataLabel.isHidden = true
                }
                
            }
            
        }
        
    }
    
    lazy var tableView : UITableView = {
        
        let tb = UITableView()
        tb.dataSource = self
        tb.delegate = self
        tb.isHidden = true
        tb.register(ResultDetailTableViewCell.self, forCellReuseIdentifier: "Cell")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()

        navigationController?.navigationBar.isTranslucent = false
        
        tableView.tableFooterView = UIView()
        
    }
    
    func setupViews(){
        
//        if detailDataArray.count == 0 {
            view.addSubview(noDataLabel)
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
//        } else {
            view.addSubview(tableView)
            tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -55).isActive = true
//        }
    }
    
    // [required]how many cells in a set
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return detailDataArray.count
        
    }
    
    // [required]content each cell shows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ResultDetailTableViewCell
        
        let detailData = detailDataArray[indexPath.row]
        
        cell.title.text = detailData.name
        
        if let urlString = detailDataArray[indexPath.row].picture_1{
            
            if let urlObject = URL(string: urlString) {
                cell.firstImageView.sd_setImage(with: urlObject)
            }
            
        }
        
        if let urlString = detailDataArray[indexPath.row].picture_2{
            
            if let urlObject = URL(string: urlString) {
                cell.secondImageView.sd_setImage(with: urlObject)
            }
            
        }
        
        
        
        if selectedCellIndex == indexPath.row && detailDataArray[indexPath.row].expand! {
            
            cell.firstImageView.isHidden = false
            cell.secondImageView.isHidden = false
            
        } else {
            
            cell.firstImageView.isHidden = true
            cell.secondImageView.isHidden = true
            
        }
 
        return cell
        
    }
    
    //after clicking the cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCellIndex = indexPath.row
        
        detailDataArray[indexPath.row].expand! = !detailDataArray[indexPath.row].expand!
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let index = selectedCellIndex, let expand = detailDataArray[indexPath.row].expand {
            
            if indexPath.row == index && expand {
                return expanedCellHeight;
            } else {
                return 50;
            }
            
        } else {
            
            return 50
            
        }
    

    }

    
}

