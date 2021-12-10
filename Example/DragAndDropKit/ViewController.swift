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
import DragAndDropKit


class ViewController: UIViewController {
    
    let btn1: UIButton = {
        var btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(click1), for: .touchUpInside)
        btn.backgroundColor = UIColor.red
        btn.setTitle("UIView Example", for: .normal)
        btn.frame = CGRect(x: 15, y: 100, width: 290, height: 50)
        btn.jf.width = CGSize.jf.screenWidth() - 30
        return btn
    }()
    
    let btn2: UIButton = {
        var btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(click2), for: .touchUpInside)
        btn.backgroundColor = UIColor.red
        btn.setTitle("UICollectView(Use DropVM) Example", for: .normal)
        btn.frame = CGRect(x: 15, y: 165, width: 290, height: 50)
        btn.jf.width = CGSize.jf.screenWidth() - 30
        return btn
    }()
    
    let btn3: UIButton = {
        var btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(click3), for: .touchUpInside)
        btn.backgroundColor = UIColor.red
        btn.setTitle("UITableView(Custom Model) Example", for: .normal)
        btn.frame = CGRect(x: 15, y: 230, width: 290, height: 50)
        btn.jf.width = CGSize.jf.screenWidth() - 30
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Drag And Drop Example"
        self.view.addSubview(self.btn1)
        self.view.addSubview(self.btn2)
        self.view.addSubview(self.btn3)
    }
    
    @objc func click1() {
        self.navigationController?.pushViewController(CustomViewController(), animated: true)
    }
    
    @objc func click2() {
        self.navigationController?.pushViewController(ListViewController(), animated: true)
    }
    
    @objc func click3() {
        self.navigationController?.pushViewController(TableViewController(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


