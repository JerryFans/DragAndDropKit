//
//  ListViewController.swift
//  DragAndDropKit_Example
//
//  Created by 逸风 on 2021/10/31.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit
import DragAndDropKit
import JFPopup

class DropItemCell: UICollectionViewCell {
    
    var source: DropSource? {
        didSet {
            guard let source = source else { return }
            self.titleLabel.isHidden = true
            self.imageView.isHidden = true
            if  let imageSource = source as? ImageDropSource {
                self.imageView.image = imageSource.image
                self.imageView.isHidden = false
            } else if let textSource = source as? TextDropSource {
                self.titleLabel.text = textSource.text
                self.titleLabel.isHidden = false
            } else if let _ = source as? VideoDropSource {
                self.titleLabel.text = "视频"
                self.titleLabel.isHidden = false
            }
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func identify() -> String {
        return "DropItemCell"
    }
}

class ListViewController: UIViewController {
    
    var dragAndDropVM: DropViewModel = {
        var vm = DropViewModel()
        let s = [
            ImageDropSource(image: UIImage(named: "template-1")!),
            ImageDropSource(image: UIImage(named: "template-2")!),
            ImageDropSource(image: UIImage(named: "template-3")!),
            ImageDropSource(image: UIImage(named: "template-4")!),
            ImageDropSource(image: UIImage(named: "template-5")!),
            ImageDropSource(image: UIImage(named: "template-6")!),
            ImageDropSource(image: UIImage(named: "template-7")!),
            ImageDropSource(image: UIImage(named: "template-8")!),
            ImageDropSource(image: UIImage(named: "template-9")!),
            ImageDropSource(image: UIImage(named: "template-10")!)
        ]
        vm.sources.append(contentsOf: s)
        return vm
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        var width: CGFloat =  (CGSize.jf.screenWidth() - 30 - (15 * 2)) / 3
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        var c = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        c.register(DropItemCell.self, forCellWithReuseIdentifier: DropItemCell.identify())
        c.delegate = self
        c.dataSource = self
        c.backgroundColor = .white
        if #available(iOS 11.0, *) {
            c.drag.enabled().collectionViewDidItemsForBeginning { [weak self] collectionView, session, indexPath in
                return self?.dragAndDropVM.dragItems(for: indexPath) ?? []
            }.collectionViewWillBeginDragSession { collectionView, session in
                JFPopup.toast(hit: "collection view will begin drag")
            }.collectionViewDidEndDragSession { collectionView, session in
                JFPopup.toast(hit: "collection view did end drag")
            }
            
            c.drop.supportSources = [.rawImage,.rawVideo,.text]
            c.drop.enabled().collectionViewDidReceivedDropSource { [weak self] collectionView, coordinator, dropSources in
                let destinationIndexPath: IndexPath
                
                if let indexPath = coordinator.destinationIndexPath {
                    destinationIndexPath = indexPath
                } else {
                    let item = collectionView.numberOfItems(inSection: 0)
                    destinationIndexPath = IndexPath(item: item, section: 0)
                }
                var indexPaths = [IndexPath]()
                for (index, item) in dropSources.enumerated() {
                    let indexPath = IndexPath(item: destinationIndexPath.item + index, section: destinationIndexPath.section)
                    self?.dragAndDropVM.addItem(item, at: indexPath.item)
                    indexPaths.append(indexPath)
                }
                self?.collectionView.insertItems(at: indexPaths)
            }
        }
        
        return c
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.collectionView)
    }
    
}

extension ListViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let source = dragAndDropVM.sources[indexPath.item]
        if let videoSource = source as? VideoDropSource {
            let vc = VideoViewController()
            vc.asset = videoSource.asset
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dragAndDropVM.sources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DropItemCell.identify(), for: indexPath) as! DropItemCell
        cell.source =  dragAndDropVM.sources[indexPath.item]
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    
}
