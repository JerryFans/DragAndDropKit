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

class CustomViewController: UIViewController {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 210, y: 100, width: 150, height: 150)
        imageView.image = UIImage(named: "template-1")
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.red.cgColor
        if #available(iOS 11.0, *) {
            let dragInteraction = UIDragInteraction(delegate: self)
            imageView.addInteraction(dragInteraction)
            let dropInteraction = UIDropInteraction(delegate: self)
            view.addInteraction(dropInteraction)
        }
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.imageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension CustomViewController: UIDragInteractionDelegate {
    
    @available(iOS 11.0, *)
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        let feedBack = UISelectionFeedbackGenerator()
        feedBack.selectionChanged()
        guard let image = imageView.image else { return [] }
        let provider = NSItemProvider(object: image)
        let item = UIDragItem(itemProvider: provider)
        item.localObject = image
        
        return [item]
    }
    
    @available(iOS 11.0, *)
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        guard let image = item.localObject as? UIImage else { return nil }
        
        
        let frame: CGRect = self.imageView.frame
        let previewImageView = UIImageView(image: image)
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.clipsToBounds = true
        previewImageView.frame = frame
        
        
        let center = CGPoint(x: imageView.bounds.midX, y: imageView.bounds.midY)
        let target = UIDragPreviewTarget(container: imageView, center: center)
        return UITargetedDragPreview(view: previewImageView, parameters: UIDragPreviewParameters(), target: target)
    }
}

extension CustomViewController: UIDropInteractionDelegate {
    // MARK: - UIDropInteractionDelegate
    @available(iOS 11.0, *)
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        if let item = session.items.first {
            print("local objcet \(String(describing: item.itemProvider.registeredTypeIdentifiers))")
        }
        return session.hasItemsConforming(toTypeIdentifiers: [kUTTypeImage as String]) && session.items.count == 1
    }
    
    @available(iOS 11.0, *)
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnter session: UIDropSession) {
        if session.localDragSession == nil {
            JFPopupView.popup.toast {
                [.hit("发送到当前屏幕"),
                 .withoutAnimation(true),
                 .position(.top),
                 .autoDismissDuration(.seconds(value: 3)),
                 .bgColor(UIColor.jf.rgb(0x000000, alpha: 0.3))
                ]
            }
        }
        let dropLocation = session.location(in: view)
        updateLayers(forDropLocation: dropLocation)
    }
    
    @available(iOS 11.0, *)
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropLocation = session.location(in: view)
        updateLayers(forDropLocation: dropLocation)
        
        let operation: UIDropOperation
        
        if imageView.frame.contains(dropLocation) {
            operation = session.localDragSession == nil ? .copy : .move
        } else {
            operation = .cancel
        }
        
        return UIDropProposal(operation: operation)
    }
    
    @available(iOS 11.0, *)
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIImage.self) { imageItems in
            let images = imageItems as! [UIImage]
            guard let img = images.first else { return }
            self.imageView.image = img
        }
        
        let dropLocation = session.location(in: view)
        updateLayers(forDropLocation: dropLocation)
    }
    
    @available(iOS 11.0, *)
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidExit session: UIDropSession) {
        let dropLocation = session.location(in: view)
        updateLayers(forDropLocation: dropLocation)
    }
    
    @available(iOS 11.0, *)
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnd session: UIDropSession) {
        let _ = session.location(in: view)
        imageView.layer.borderWidth = 0.0
    }
    
    // MARK: - Helpers
    @available(iOS 11.0, *)
    func updateLayers(forDropLocation dropLocation: CGPoint) {
        if imageView.frame.contains(dropLocation) {
            imageView.layer.borderWidth = 2.0
            UISelectionFeedbackGenerator().selectionChanged()
        } else if view.frame.contains(dropLocation) {
            imageView.layer.borderWidth = 0.0
        } else {
            imageView.layer.borderWidth = 0.0
        }
    }
}
