//
//  NextViewController.swift
//  AlertNotice
//
//  Created by Ray on 2017/5/5.
//  Copyright © 2017年 Ray. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
