//
//  Previously.swift
//  Currently
//
//  Created by Mohamed Ismail BENNANI on 15/09/2017.
//  Copyright © 2017 mib. All rights reserved.
//

import UIKit
import Foundation

class Previously: UIViewController {

    @IBOutlet weak var orgAmount: UITextField!
    @IBOutlet weak var orgCode: UILabel!
    @IBOutlet weak var orgFlag: UIImageView!
    
    @IBOutlet weak var destAmount: UITextField!
    @IBOutlet weak var destCode: UILabel!
    @IBOutlet weak var destFlag: UIImageView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        matchData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFlag() -> String
    {
        if let pathURL = Bundle.main.url(forResource: "currencies", withExtension: "json"){
            
            do {
                
                let jsonData = try Data(contentsOf: pathURL, options: .mappedIfSafe)
                
                let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! [String: Any]
                
                
            }catch(let error){
                print (error.localizedDescription)
            }
        }
        return "_unknown"
    }

    func matchData()
    {
        
    }

}

