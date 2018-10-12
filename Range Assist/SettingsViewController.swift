//
//  SettingsViewController.swift
//  Range Assist
//
//  Created by Koray Birand on 20/11/15.
//  Copyright © 2015 Koray Birand. All rights reserved.
//

import UIKit

var aa = ""
var bb = ""
var cc = ""

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var serverIPLabel: UITextField!
    @IBOutlet weak var craftBatteryLabel: UITextField!
    @IBOutlet weak var myDistanceLabel: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {


        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let getImagePath = paths.appendingPathComponent("settings.ini")
        let checkValidation = FileManager.default
        
        if (checkValidation.fileExists(atPath: getImagePath))
        {
            var text2 = ""
            
            do {
                text2 = try NSString(contentsOfFile: getImagePath, encoding: String.Encoding.utf8.rawValue) as String
                var settings = text2.components(separatedBy: "\n")
                serverIPLabel.text = settings[0] as String
                craftBatteryLabel.text = settings[2] as String
                myDistanceLabel.text = settings[1] as String
                
            }
            catch {}
            
            print(text2);
        }
        else
        {
            print("FILE NOT AVAILABLE");
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: AnyObject) {
        
        aa = serverIPLabel.text!
        bb = myDistanceLabel.text!
        cc = craftBatteryLabel.text!
        
        let writeString = ("\(aa)\n\(bb)\n\(cc)") as String
     
        
         NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: nil)
        
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let getImagePath = paths.appendingPathComponent("settings.ini")
        
        
        do { try writeString.write(toFile: getImagePath, atomically: true, encoding: String.Encoding.utf8) } catch {}
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: nil)
        settingsState = false
        mainV.hideSettings()
        
        
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        
        settingsState = false
        print("settingsState:\(settingsState)")
        mainV.hideSettings()
        
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
