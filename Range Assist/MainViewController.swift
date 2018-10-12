//
//  MainViewController.swift
//  Range Assist
//
//  Created by Koray Birand on 20/11/15.
//  Copyright (c) 2015 Koray Birand. All rights reserved.
//

import UIKit

var mainV = MainViewController()


class MainViewController: UIViewController {

    @IBOutlet weak var leftAlign: NSLayoutConstraint!
    @IBOutlet weak var settingsWidth: NSLayoutConstraint!
    @IBOutlet weak var settingsContainer: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        settingsWidth.constant = 375
        leftAlign.constant = -settingsWidth.constant
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainV = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func displaySettings() {
        leftAlign.constant = 0
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = settingsContainer.bounds
//        print(view.bounds)
//        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
//        settingsContainer.addSubview(blurEffectView)
//        
        
        UIView.animate(withDuration: 0.1, animations: { () in
            self.view.layoutIfNeeded()
        })
        
    }
    
    func hideSettings() {
        leftAlign.constant =  -settingsWidth.constant
        
        UIView.animate(withDuration: 0.1, animations: { () in
            self.view.layoutIfNeeded()
        })
        
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
