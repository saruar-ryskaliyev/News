//
//  SideMenu.swift
//  NewsAPI
//
//  Created by Saruar on 17.03.2023.
//

import Foundation
import UIKit


protocol SideMenuListControllerDelegate{
    func didSelectMenuItem(named: String)
}

class SideMenuListController: UITableViewController{


    public var delegate: SideMenuListControllerDelegate?
    var items = ["Business", "Entertainment", "General", "Health", "Science", "Sports", "Technology"]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = items[indexPath.row]
        delegate?.didSelectMenuItem(named: selectedItem)

        
        

    }
        

    
override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Categories"
    }
    
}
    

