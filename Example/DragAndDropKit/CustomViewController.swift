//
//  CustomViewController.swift
//  DragAndDropKit_Example
//
//  Created by 逸风 on 2021/10/31.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import MobileCoreServices
import JFPopup
import Photos
import DragAndDropKit
import Kingfisher

class CustomImgView: UIImageView {
    deinit {
        print("CustomImgView dealloc")
    }
}

class CustomViewController: UIViewController {
    
    var isMatch = false
    
    lazy var imageView: CustomImgView = {
        let imageView = CustomImgView()
        imageView.frame = CGRect(x: 210, y: 100, width: 150, height: 150)
        imageView.image = UIImage(named: "template-1")
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.red.cgColor
        
        return imageView
    }()
    
    var networkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.kf.setImage(with: URL(string: "http://image.jerryfans.com/sample.jpg")!, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        imageView.frame = CGRect(x: 210, y: 260, width: 150, height: 150)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.red.cgColor
        return imageView
    }()
    
    var networkVideoLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 50, y: 260, width: 150, height: 150)
        label.text = "Network Video"
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .red
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if #available(iOS 11.0, *) {
            
            self.imageView.drag.dropSource = ImageDropSource(image: self.imageView.image!)
            self.imageView.drag.enabled().didPreviewForDragSession { [weak self] interaction, item, session in
                guard let self = self else { return nil }
                guard let image = item.localObject as? UIImage else { return nil }

                let frame: CGRect = self.imageView.frame
                let previewImageView = UIImageView(image: image)
                previewImageView.contentMode = .scaleAspectFill
                previewImageView.clipsToBounds = true
                previewImageView.frame = frame


                let center = CGPoint(x: self.imageView.bounds.midX, y: self.imageView.bounds.midY)
                let target = UIDragPreviewTarget(container: self.imageView, center: center)
                return UITargetedDragPreview(view: previewImageView, parameters: UIDragPreviewParameters(), target: target)
            }
            
            /*
             你想拖拽时候给予的souce, 目前支持NetworkImageDropSource、NetworkVideoDropSource、ImageDropSource、VideoDropSource、TextDropSource五种
             */
            self.networkImageView.drag.dropSource = NetworkImageDropSource(imageUrl: "http://image.jerryfans.com/sample.jpg")
            
            //开启拖拽
            self.networkImageView.drag.enabled()
            
            
            self.networkVideoLabel.drag.dropSource = NetworkVideoDropSource(videoUrl: "http://image.jerryfans.com/test_1.mp4")
            self.networkVideoLabel.drag.enabled()
            
            self.view.drop.supportSources = [.rawImage]
            self.view.drop.enabled().didReceivedDropSource { [weak self] dropSources in
                for (_, item) in dropSources.enumerated() {
                    if let imageSource = item as? ImageDropSource {
                        self?.imageView.image = imageSource.image
                        self?.imageView.layer.borderWidth = 0.0
                        break
                    }
                }
            }.didEnterDropSession { interaction, session in
                if session.localDragSession == nil {
                    JFPopupView.popup.toast {
                        [.hit("请移入右上角图片中替换"),
                         .withoutAnimation(true),
                         .position(.top),
                         .autoDismissDuration(.seconds(value: 3)),
                         .bgColor(UIColor.jf.rgb(0x000000, alpha: 0.3))
                        ]
                    }
                }
            }.didUpdateDropSource { [weak self] interaction, session in
                guard let self = self else {
                    return UIDropProposal(operation: UIDropOperation.cancel)
                }
                let dropLocation = session.location(in: self.view)
                
                let operation: UIDropOperation
                
                if self.imageView.frame.contains(dropLocation) {
                    operation = session.localDragSession == nil ? .copy : .move
                    self.checkIsMatch(match: true)
                } else {
                    operation = .cancel
                    self.checkIsMatch(match: false)
                }
                self.updateLayers(forDropLocation: dropLocation)
                
                return UIDropProposal(operation: operation)
            }.didEndDropSession { [weak self] interaction, session in
                guard let self = self else { return }
                let dropLocation = session.location(in: self.view)
                self.updateLayers(forDropLocation: dropLocation)
                self.checkIsMatch(match: false)
            }.didExitDropSession { [weak self] interaction, session in
                guard let self = self else { return }
                self.imageView.layer.borderWidth = 0.0
            }
        }
        self.view.backgroundColor = .white
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.networkImageView)
        self.view.addSubview(self.networkVideoLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @available(iOS 11.0, *)
    func updateLayers(forDropLocation dropLocation: CGPoint) {
        if imageView.frame.contains(dropLocation) {
            imageView.layer.borderWidth = 2.0
        } else if view.frame.contains(dropLocation) {
            imageView.layer.borderWidth = 0.0
        } else {
            imageView.layer.borderWidth = 0.0
        }
    }
    
    func checkIsMatch(match: Bool) {
        if self.isMatch != match {
            UISelectionFeedbackGenerator().selectionChanged()
        }
        self.isMatch = match
    }
    
}
