//
//  ViewController.swift
//  DragAndDropKit
//
//  Created by fanjiaorng919 on 10/29/2021.
//  Copyright (c) 2021 fanjiaorng919. All rights reserved.
//

import UIKit
import MobileCoreServices
import JFPopup
import Photos


class ViewController: UIViewController {
    
    let btn1: UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(click1), for: .touchUpInside)
        btn.backgroundColor = UIColor.red
        btn.setTitle("Only View", for: .normal)
        btn.frame = CGRect(x: 15, y: 100, width: 100, height: 50)
        return btn
    }()
    
    let btn2: UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(click2), for: .touchUpInside)
        btn.backgroundColor = UIColor.red
        btn.setTitle("List View", for: .normal)
        btn.frame = CGRect(x: 15, y: 165, width: 100, height: 50)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Drag And Drop 示例"
        self.view.addSubview(self.btn1)
        self.view.addSubview(self.btn2)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func click1() {
        self.navigationController?.pushViewController(CustomViewController(), animated: true)
    }
    
    @objc func click2() {
        self.navigationController?.pushViewController(ListViewController(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


