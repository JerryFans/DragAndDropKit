//
//  TableViewController.swift
//  DragAndDropKit_Example
//
//  Created by 逸风 on 2021/12/10.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import DragAndDropKit

class TableViewDropItemCell: UITableViewCell {
    
    var source: DropSource? {
        didSet {
            guard let source = source else { return }
            self.imgView.isHidden = true
            if  let imageSource = source as? ImageDropSource {
                self.imgView.image = imageSource.image
                self.imgView.isHidden = false
                self.titleLabel.text = "图片"
            } else if let textSource = source as? TextDropSource {
                self.titleLabel.text = "文本：\(textSource.text)"
            } else if let s = source as? VideoDropSource {
                self.titleLabel.text = "视频:\(s.asset.url.path)"
            } else if let s = source as? NetworkImageDropSource {
                self.titleLabel.text = "网络图片:"
                self.imgView.isHidden = false
                self.imgView.kf.setImage(with: URL(string: s.imageUrl), placeholder: nil, options: nil, completionHandler: nil)
            } else if let s = source as? NetworkVideoDropSource {
                self.titleLabel.text = "网络视频:\(s.videoUrl)"
            }
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .white
        self.addSubview(self.imgView)
        self.imgView.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func identify() -> String {
        return "TableViewDropItemCell"
    }
}


class TableViewController: UIViewController {
    
    //you can use your custom models
    var models: [DropSource] = [
        ImageDropSource(image: UIImage(named: "template-1")!),
        ImageDropSource(image: UIImage(named: "template-2")!),
        ImageDropSource(image: UIImage(named: "template-3")!),
        ImageDropSource(image: UIImage(named: "template-4")!),
        ImageDropSource(image: UIImage(named: "template-5")!),
        TextDropSource(text: "I can Drag to other app"),
        TextDropSource(text: "Try It !"),
        NetworkVideoDropSource(videoUrl: "http://image.jerryfans.com/test_1.mp4"),
        NetworkImageDropSource(imageUrl: "http://image.jerryfans.com/sample.jpg")
        
    ]
    
    lazy var tableView: UITableView = {
        var t = UITableView(frame: self.view.frame, style: UITableView.Style.grouped)
        t.backgroundColor = .white
        t.register(TableViewDropItemCell.self, forCellReuseIdentifier: TableViewDropItemCell.identify())
        t.delegate = self
        t.dataSource = self
        
        if #available(iOS 11.0, *) {
            
            t.drag.enabled().tableViewDidItemsForBeginning { [weak self] tableView, session, indexPath in
                guard let self = self else { return [] }
                //if you are the custom model, you should convert to DropSource Object (Text,Image or Video Drop Source)
                let source = self.models[indexPath.row]
                let itemProvider = NSItemProvider(object: source)
                return [
                    UIDragItem(itemProvider: itemProvider)
                ]
            }
            
            t.drop.supportSources = [.rawImage,.rawVideo,.text]
            t.drop.enabled().tableViewDidReceivedDropSource { [weak self] tableView, coordinator, dropSources in
                guard let self = self else { return }
                
                let destinationIndexPath: IndexPath
                
                if let indexPath = coordinator.destinationIndexPath {
                    destinationIndexPath = indexPath
                } else {
                    let item = tableView.numberOfRows(inSection: 0)
                    destinationIndexPath = IndexPath(row: item, section: 0)
                }
                var indexPaths = [IndexPath]()
                for (index, item) in dropSources.enumerated() {
                    let indexPath = IndexPath(row: destinationIndexPath.item + index, section: destinationIndexPath.section)
                    self.models.insert(item, at: indexPath.row)
                    indexPaths.append(indexPath)
                }
                tableView.insertRows(at: indexPaths, with: .bottom)
            }
        }
        return t
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
    }
}

extension TableViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewDropItemCell.identify(), for: indexPath) as! TableViewDropItemCell
        cell.source = self.models[indexPath.row]
        return cell
    }
}
