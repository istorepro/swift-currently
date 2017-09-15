//
//  Previously.swift
//  Currently
//
//  Created by Mohamed Ismail BENNANI on 15/09/2017.
//  Copyright © 2017 mib. All rights reserved.
//

import UIKit
import SystemConfiguration

class Previously: UIViewController {

    @IBOutlet weak var orgAmount: UITextField!
    @IBOutlet weak var orgCode: UIButton!
    @IBOutlet weak var orgFlag: UIImageView!
    
    @IBOutlet weak var destAmount: UITextField!
    @IBOutlet weak var destCode: UIButton!
    @IBOutlet weak var destFlag: UIImageView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Swap(_ sender: Any) {
        let keepAmount = orgAmount.text
        let keepCode = orgCode.titleLabel?.text
        let keepFlag = orgFlag.image
        
        orgFlag.image = destFlag.image
        orgCode.titleLabel?.text = destCode.titleLabel?.text
        orgAmount.text = destAmount.text
        
        destAmount.text = keepAmount
        destCode.titleLabel?.text = keepCode
        destFlag.image = keepFlag
    }
    
    

}

