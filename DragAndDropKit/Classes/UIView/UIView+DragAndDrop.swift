//
//  UIView+DragAndDrop.swift
//  UIView+DragAndDrop
//
//  Created by 逸风 on 2021/10/29.
//

import UIKit

private var associatedObjectDropSource: UInt8 = 0
private var associatedObjectDidReceivedDropSource: UInt8 = 0

public typealias DidReceivedDropSource = ([DropSource]) -> ()

extension UIView: DragAndDropCompatible {}
extension DragAndDrop where Base: UIView {
    
    public var didReceivedDropSource: DidReceivedDropSource? {
        set {
            objc_setAssociatedObject(base, &associatedObjectDidReceivedDropSource, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            if let rs = objc_getAssociatedObject(base, &associatedObjectDidReceivedDropSource) as? DidReceivedDropSource {
                return rs
            }
            return nil
        }
    }
    
    var dropSource: DropSource? {
        set {
            objc_setAssociatedObject(base, &associatedObjectDropSource, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            if let rs = objc_getAssociatedObject(base, &associatedObjectDropSource) as? DropSource {
                return rs
            }
            return nil
        }
    }
    
    @available(iOS 11.0, *)
    public func enabledDrag() {
        let dragInteraction = UIDragInteraction(delegate: base)
        base.addInteraction(dragInteraction)
    }
    
    @available(iOS 11.0, *)
    public func enabledDrop() {
        let dropInteraction = UIDropInteraction(delegate: base)
        base.addInteraction(dropInteraction)
    }
}

extension UIView: UIDropInteractionDelegate {
    
    @available(iOS 11.0, *)
    public func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return DropViewModel.canHandle(session)
    }
    
    @available(iOS 11.0, *)
    public func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
//        let dropLocation = session.location(in: self)
        
        let operation: UIDropOperation
        operation = .copy
//        if imageView.frame.contains(dropLocation) {
//            operation = session.localDragSession == nil ? .copy : .move
//        } else {
//            operation = .cancel
//        }
        
        return UIDropProposal(operation: operation)
    }
    
    @available(iOS 11.0, *)
    public func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        session.loadObjects(ofClass: DropSource.self) { dropSources in
            if let dropSources = dropSources as? [DropSource] {
                self.dragAndDrop.didReceivedDropSource?(dropSources)
            }
        }
        
    }
}

extension UIView: UIDragInteractionDelegate {
    
    @available(iOS 11.0, *)
    public func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        if let source = self.dragAndDrop.dropSource {
            let itemProvider = NSItemProvider(object: source)
            return [UIDragItem(itemProvider: itemProvider)]
        }
        return []
    }
}

