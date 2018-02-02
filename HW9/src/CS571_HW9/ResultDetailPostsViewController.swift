//
//  ResultDetailPostsViewController.swift
//  CS571_HW9
//
//  Created by Chris Chou on 4/9/17.
//  Copyright © 2017 Chris Chou. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

struct PostData {
    
    var message : String?
    var createdTime : String?
    
}


class ResultPostTableViewCell : UITableViewCell {

    var photoImgeView : UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
            
    }()
    
    var message : UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    var time : UILabel = {
        
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
        
        contentView.addSubview(photoImgeView)
        photoImgeView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
        photoImgeView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        photoImgeView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        photoImgeView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        contentView.addSubview(message)
        message.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        message.leftAnchor.constraint(equalTo: photoImgeView.rightAnchor, constant: 20).isActive = true
        message.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        
        contentView.addSubview(time)
        //message.bottomAnchor.constraint(equalTo: time.topAnchor, constant: -10).isActive = true
        time.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 20).isActive = true
        time.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        time.leftAnchor.constraint(equalTo: message.leftAnchor).isActive = true
        time.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        time.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
}

class ResultDetailPostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var url: String?
    
    var postDataArray = [PostData]()
    
    var jsonData : JSON? {
        
        didSet{
            
            guard oldValue == nil else {
                return
            }
            
            for ( _ ,subJson):(String, JSON) in jsonData!["posts"]["data"] {
                
                var postData = PostData(message: nil, createdTime: nil)
    
                if let message = subJson["message"].string { postData.message = message }
                if let createdTime = subJson["created_time"].string { postData.createdTime = createdTime }
                
                postDataArray.append(postData)
                
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
        tb.register(ResultPostTableViewCell.self, forCellReuseIdentifier: "Cell")
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
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        navigationController?.navigationBar.isTranslucent = false
        
        tableView.tableFooterView = UIView()
        
    }
    
    func setupViews(){
        
            view.addSubview(tableView)
            tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48).isActive = true
        
        
            view.addSubview(noDataLabel)
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        
    }
    
    // [required]how many cells in a set
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postDataArray.count
        
    }
    
    // [required]content each cell shows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ResultPostTableViewCell
        
        if let urlString = url {
            if let urlObject = URL(string: urlString){
                cell.photoImgeView.contentMode = .scaleAspectFit
                cell.photoImgeView.sd_setImage(with: urlObject, placeholderImage: #imageLiteral(resourceName: "users"))
            }
            
        }
        
        let postData = postDataArray[indexPath.row]
        
        cell.message.text = postData.message
        cell.message.numberOfLines = 0
        cell.message.lineBreakMode = NSLineBreakMode.byCharWrapping
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyy hh:mm:ss"
        
        let date: Date? = dateFormatterGet.date(from: postData.createdTime!)
        cell.time.text = dateFormatter.string(from: date!)
        
        cell.isUserInteractionEnabled = false
        
        return cell
        
    }
    
}
