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
//            if let img = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: "http://image.jerryfans.com/sample.jpg", options: nil) {
//                self.networkImageView.drag.dropSource = NetworkImageDropSource(imageUrl: "http://image.jerryfans.com/sample.jpg")
////                self.networkImageView.drag.dropSource = ImageDropSource(image: img)
//            }
            self.networkImageView.drag.dropSource = NetworkImageDropSource(imageUrl: "http://image.jerryfans.com/sample.jpg")
            self.networkImageView.drag.enabled().didPreviewForDragSession { [weak self] interaction, item, session in
                guard let self = self else { return nil }
                guard let image = self.networkImageView.image else { return nil }
                
                let frame: CGRect = self.networkImageView.frame
                let previewImageView = UIImageView(image: image)
                previewImageView.contentMode = .scaleAspectFill
                previewImageView.clipsToBounds = true
                previewImageView.frame = frame
                
                
                let center = CGPoint(x: self.networkImageView.bounds.midX, y: self.imageView.bounds.midY)
                let target = UIDragPreviewTarget(container: self.networkImageView, center: center)
                return UITargetedDragPreview(view: previewImageView, parameters: UIDragPreviewParameters(), target: target)
            }
            
            self.view.drop.supportSources = [.rawImage]
            self.view.drop.enabled().didReceivedDropSource { [weak self] dropSources in
                for (_, item) in dropSources.enumerated() {
                    if let imageSource = item as? ImageDropSource {
                        self?.imageView.image = imageSource.image
                        break
                    }
                }
            }.didEnterDropSession { interaction, session in
                if session.localDragSession == nil {
                    JFPopupView.popup.toast {
                        [.hit("请移入图片中替换"),
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
                } else {
                    operation = .cancel
                }
                
                return UIDropProposal(operation: operation)
            }
        } else {
            // Fallback on earlier versions
        }
        self.view.backgroundColor = .white
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.networkImageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
