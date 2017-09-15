//
//  Picker.swift
//  Currently
//
//  Created by Mohamed Ismail BENNANI on 15/09/2017.
//  Copyright © 2017 mib. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class Picker: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UISearchBarDelegate {
    
    var currencies : (Any)? = nil;
    
    var arr : [(String, Any)?] = []
    var filtered : [(String, Any)?] = []
    
    var is_searching = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    public func buildArray()
    {
        if let pathURL = Bundle.main.url(forResource: "currencies", withExtension: "json"){
            
            do {
                
                let jsonData = try Data(contentsOf: pathURL, options: .mappedIfSafe)
                
                currencies = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! [String: Any]
                
                
            }catch(let error){
                print (error.localizedDescription)
            }
            
            arr.removeAll()
            
            if let dictionary = currencies as? [String: Any] {
                
                for (key, value) in (dictionary["results"] as? [String: Any])! {
                    arr.append((key, value))
                }
                
            }
            
            arr = arr.sorted(by: { $0?.0.localizedCaseInsensitiveCompare(($1?.0)!) == ComparisonResult.orderedAscending})
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
            buildArray()
            
            // self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "testcell")
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.searchBar.delegate = self
            self.searchBar.returnKeyType = UIReturnKeyType.done
            
            tableView.reloadData()
            
            super.viewDidLoad()
            
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if is_searching
        {
            return filtered.count
        }
        return arr.count
    }
    
    
    internal func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "testcell")
        
        var dictionnary : [String: String]
        
        if is_searching {
            dictionnary = filtered[indexPath.item]?.1 as! [String : String]
            cell.imageView?.image = UIImage(named: (filtered[indexPath.item]?.0)!)

        } else {
            dictionnary = arr[indexPath.item]?.1 as! [String : String]
            cell.imageView?.image = UIImage(named: (arr[indexPath.item]?.0)!)
        }
        
        
        cell.textLabel?.text = dictionnary["currencyName"]
        
        if (dictionnary["currencySymbol"] == nil)
        {
            cell.detailTextLabel?.text = dictionnary["currencyId"]
        } else{
            cell.detailTextLabel?.text = dictionnary["currencySymbol"]
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getInfos(infos: (arr[indexPath.item]))
    }
    
    
    public func getFlag(id: String) -> String?
        
    {
        for i in arr {
            if let dictionnary = i?.1 as! [String: String]?
            {
                
                if (dictionnary["currencyId"] == id)
                {
                    return i?.0
                }
            }
        }
        
        return nil
    }
    
    public func getInfos(id: String) -> [String: String]?
    {
        for i in arr {
            if let dictionnary = i?.1 as! [String: String]?
            {
                
                if (dictionnary["currencyId"] == id)
                {
                    return i?.1 as! [String: String]
                }
            }
        }
        
        return nil
    }
    
    public func getInfos(infos: Any!) -> Any!     {
        return infos
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            is_searching = false
        } else
        {
            is_searching = true
            filtered = arr.filter({
                let dictionnary = $0?.1 as! [String: String]
                return ((dictionnary["currencyName"]?.contains(searchBar.text!))! || (dictionnary["name"]?.contains(searchBar.text!))! || (dictionnary["currencyId"]?.contains(searchBar.text!))!)
            })
            
            tableView.reloadData()
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}



class TableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}




