//
//  UIView+Drag.swift
//  DragAndDropKit
//
//  Created by 逸风 on 2021/12/6.
//

import UIKit

extension UIView: DragCompatible {}
extension Drag where Base: UIView {
    
    @available(iOS 11.0, *)
    @discardableResult public func enabled() -> Drag {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            base.isUserInteractionEnabled = true
            let dragInteraction = UIDragInteraction(delegate: base)
            base.addInteraction(dragInteraction)
        } else if #available(iOS 15.0, *) {
            base.isUserInteractionEnabled = true
            let dragInteraction = UIDragInteraction(delegate: base)
            base.addInteraction(dragInteraction)
        }
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func didPreviewForDragSession(didPreviewForDragSession: @escaping DidPreviewForDragSession) -> Drag {
        var muteSelf = self
        muteSelf._didPreviewForDragSession = didPreviewForDragSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func didAllowsMoveOperationSession(didAllowsMoveOperationSession: @escaping DidAllowsMoveOperationSession) -> Drag {
        var muteSelf = self
        muteSelf._didAllowsMoveOperationSession = didAllowsMoveOperationSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func willBeginSession(willBeginSession: @escaping WillBeginSession) -> Drag {
        var muteSelf = self
        muteSelf._willBeginSession = willBeginSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func willEndSession(willEndSession: @escaping WillEndSession) -> Drag {
        var muteSelf = self
        muteSelf._willEndSession = willEndSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func didEndSession(didEndSession: @escaping DidEndSession) -> Drag {
        var muteSelf = self
        muteSelf._didEndSession = didEndSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func didMoveSession(didMoveSession: @escaping DidMoveSession) -> Drag {
        var muteSelf = self
        muteSelf._didMoveSession = didMoveSession
        return muteSelf
    }
    
}

extension UIView: UIDragInteractionDelegate {
    
    @available(iOS 11.0, *)
    public func dragInteraction(_ interaction: UIDragInteraction, sessionWillBegin session: UIDragSession) {
        self.drag._willBeginSession?(interaction,session)
    }
    
    @available(iOS 11.0, *)
    public func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, willEndWith operation: UIDropOperation) {
        self.drag._willEndSession?(interaction,session,operation)
    }
    
    @available(iOS 11.0, *)
    public func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, didEndWith operation: UIDropOperation) {
        self.drag._didEndSession?(interaction,session,operation)
    }
    
    @available(iOS 11.0, *)
    public func dragInteraction(_ interaction: UIDragInteraction, sessionDidMove session: UIDragSession) {
        self.drag._didMoveSession?(interaction,session)
    }
    
    @available(iOS 11.0, *)
    public func dragInteraction(_ interaction: UIDragInteraction, sessionAllowsMoveOperation session: UIDragSession) -> Bool {
        return self.drag._didAllowsMoveOperationSession?(interaction,session) ?? true
    }
    
    @available(iOS 11.0, *)
    public func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        if self.drag._didPreviewForDragSession != nil {
            return self.drag._didPreviewForDragSession?(interaction,item,session)
        }
        let previewImageView = UIImageView(frame: self.frame)
        if let img = self.convertToImage() {
            previewImageView.image = img
        } else {
            previewImageView.backgroundColor = .red
        }
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.clipsToBounds = true

        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let target = UIDragPreviewTarget(container: self, center: center)
        return UITargetedDragPreview(view: previewImageView, parameters: UIDragPreviewParameters(), target: target)
    }
    
    private func convertToImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
    
    @available(iOS 11.0, *)
    public func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        if let source = self.drag.dropSource {
            let itemProvider = NSItemProvider(object: source)
            let item = UIDragItem(itemProvider: itemProvider)
            item.localObject = source.localObject
            return [item]
        }
        return []
    }
}
