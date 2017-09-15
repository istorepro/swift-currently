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

    var orgImg : String?
    var orgInfos : [String: String]?
    
    var destImg : String?
    var destInfos : [String: String]?
    
    var picker = Picker()
    
    @IBOutlet weak var orgAmount: UITextField!
    @IBOutlet weak var orgCode: UIButton!
    @IBOutlet weak var orgFlag: UIImageView!
    
    @IBOutlet weak var destAmount: UITextField!
    @IBOutlet weak var destCode: UIButton!
    @IBOutlet weak var destFlag: UIImageView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    func reloadInfos()
    {
        orgFlag.image = UIImage(named: picker.getFlag(id: (orgCode.titleLabel?.text)!)!)
        orgInfos = picker.getInfos(id: (orgCode.titleLabel?.text)!)
        
        orgAmount.placeholder = orgInfos?["currencyName"]
        
        destFlag.image = UIImage(named: picker.getFlag(id: (destCode.titleLabel?.text)!)!)
        destInfos = picker.getInfos(id: (destCode.titleLabel?.text)!)
        
        destAmount.placeholder = destInfos?["currencyName"]

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if (orgImg != nil && orgImg != "") {
            orgFlag.image = UIImage(named: orgImg!)
        }
        
        if (orgInfos != nil && !(orgInfos?.isEmpty)!)
        {
            orgAmount.placeholder = orgInfos?["currencyName"]
            orgCode.titleLabel?.text = orgInfos?["currencyId"]
        }
        
        if (destImg != nil && destImg != "") {
            destFlag.image = UIImage(named: destImg!)
        }
        
        if (destInfos != nil && !(destInfos?.isEmpty)!)
        {
            destAmount.placeholder = destInfos?["currencyName"]
            destCode.titleLabel?.text = destInfos?["currencyId"]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        picker.buildArray()
        reloadInfos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Swap(_ sender: Any) {
        let keepInfos = orgInfos
        let keepFlag = orgFlag.image
        
        orgCode.titleLabel?.text = destInfos?["currencyId"]
        orgFlag.image = destFlag.image
        orgInfos = destInfos
        
        destCode.titleLabel?.text = keepInfos?["currencyId"]
        destFlag.image = keepFlag
        
        destInfos = keepInfos
        
        convert(sender)
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        convert(sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? Picker
            {
                destination.is_src = false
            }
        }
    
    @IBAction func changeOrg(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"Picker")
        self.present(viewController, animated: true)
    }
    
    
    
    @IBAction func changeDest(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"Picker")
        self.present(viewController, animated: true)
    }
    
    
    @IBAction func convert(_ sender: Any) {
        //reloadInfos()
        if (orgAmount.text == nil || orgAmount.text == ""){
            return
        }
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd"
        
        var base = "http://currencies.apps.grandtrunk.net/getrate/"
        base.append(df.string(from: datePicker.date))
        base.append("/")
        base.append((orgInfos?["currencyId"]!)!)
        base.append("/")
        base.append((destInfos?["currencyId"]!)!)
        
        if let url = URL(string: base),
            let html = try? String(contentsOf: url, encoding: String.Encoding.utf8) {
            
            let index = Double(Double(html)!)
            
            destAmount.text = String(Double(Double(orgAmount.text!)!) * index)
        }
        else{
            return
        }

    }

}

