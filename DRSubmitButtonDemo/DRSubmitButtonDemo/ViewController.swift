//
//  ViewController.swift
//  DRSubmitButtonDemo
//
//  Created by YU CHONKAO on 2016/7/21.
//  Copyright © 2016年 YU CHONKAO. All rights reserved.
//

import UIKit
import DRSubmitButton

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let submitButtonDemo =
            submitButton.init(frame: CGRectMake(80, 150, 160, 54));
        submitButtonDemo.addTarget(self, action: #selector(ViewController.demoFunction));
        self.view.addSubview(submitButtonDemo);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func demoFunction() {
        print("Demo");
    }


}

