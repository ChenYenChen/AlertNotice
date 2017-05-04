//
//  ViewController.swift
//  AlertNotice
//
//  Created by Ray on 2017/5/4.
//  Copyright © 2017年 Ray. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func showAlert(_ sender: Any) {
        let alert = RYAlertNotice()
        alert.show("通知", message: "這裡是通知啊~~   這裡是通知啊~~  這裡是通知啊~~   這裡是通知啊~~", style: nil) { 
            print("就是要亂點!!")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

