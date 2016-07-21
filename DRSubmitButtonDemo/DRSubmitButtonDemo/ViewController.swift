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
        submitButtonDemo.submitImage = UIImage(named: "icon_submit");
        submitButtonDemo.successImage = UIImage(named: "icon_success");
        submitButtonDemo.warningImage = UIImage(named: "icon_warning");
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            submitButtonDemo.buttonState = .success;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(4.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            submitButtonDemo.buttonState = .warning;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(6.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            submitButtonDemo.buttonState = .loading;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(8.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            submitButtonDemo.buttonState = .warning;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(10.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            submitButtonDemo.buttonState = .normal;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(12.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            submitButtonDemo.buttonState = .warning;
        }
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

