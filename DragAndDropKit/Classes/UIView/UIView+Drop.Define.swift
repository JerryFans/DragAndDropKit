//
//  UIView+Drop.Define.swift
//  DragAndDropKit
//
//  Created by 逸风 on 2021/12/5.
//

import UIKit

private var associatedObjectDidReceivedDropSource: UInt8 = 0
private var associatedObjectDidEnterDropSession: UInt8 = 0
private var associatedObjectDidEndDropSession: UInt8 = 0
private var associatedObjectDidUpdateDropSession: UInt8 = 0
private var associatedObjectDidPreviewForDropSession: UInt8 = 0
private var associatedObjectWillAnimateDropSession: UInt8 = 0
private var associatedObjectDropSourceOption: UInt8 = 0

@available(iOS 11.0, *)
public typealias WillAnimateDropSession = (_ interaction: UIDropInteraction, _ item: UIDragItem, _ animator: UIDragAnimating) -> ()

@available(iOS 11.0, *)
public typealias DidPreviewForDropSession = (_ interaction: UIDropInteraction, _ item: UIDragItem, _ defaultPreview: UITargetedDragPreview) -> (UITargetedDragPreview?)

@available(iOS 11.0, *)
public typealias DidUpdateDropSession = (_ interaction: UIDropInteraction, _ session: UIDropSession) -> (UIDropProposal)

@available(iOS 11.0, *)
public typealias DidEnterDropSession = (_ interaction: UIDropInteraction, _ session: UIDropSession) -> ()

@available(iOS 11.0, *)
public typealias DidEndDropSession = (_ interaction: UIDropInteraction, _ session: UIDropSession) -> ()

public typealias DidReceivedDropSource = ([DropSource]) -> ()

extension Drop where Base: UIView {
    
    public var supportSources: [DropSourceOption] {
        set {
            objc_setAssociatedObject(base, &associatedObjectDropSourceOption, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            if let rs = objc_getAssociatedObject(base, &associatedObjectDropSourceOption) as? [DropSourceOption] {
                return rs
            }
            return []
        }
    }
    
    @available(iOS 11.0, *)
    var _willAnimateDropSession: WillAnimateDropSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectWillAnimateDropSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            if let rs = objc_getAssociatedObject(base, &associatedObjectWillAnimateDropSession) as? WillAnimateDropSession {
                return rs
            }
            return nil
        }
    }
    
    @available(iOS 11.0, *)
    var _didPreviewForDropSession: DidPreviewForDropSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectDidPreviewForDropSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            if let rs = objc_getAssociatedObject(base, &associatedObjectDidPreviewForDropSession) as? DidPreviewForDropSession {
                return rs
            }
            return nil
        }
    }
    
    @available(iOS 11.0, *)
    var _didUpdateDropSession: DidUpdateDropSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectDidUpdateDropSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            if let rs = objc_getAssociatedObject(base, &associatedObjectDidUpdateDropSession) as? DidUpdateDropSession {
                return rs
            }
            return nil
        }
    }
    
    @available(iOS 11.0, *)
    var _didEndDropSession: DidEndDropSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectDidEndDropSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            if let rs = objc_getAssociatedObject(base, &associatedObjectDidEndDropSession) as? DidEndDropSession {
                return rs
            }
            return nil
        }
    }
    
    @available(iOS 11.0, *)
    var _didEnterDropSession: DidEnterDropSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectDidEnterDropSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            if let rs = objc_getAssociatedObject(base, &associatedObjectDidEnterDropSession) as? DidEnterDropSession {
                return rs
            }
            return nil
        }
    }
    
    var _didReceivedDropSource: DidReceivedDropSource? {
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
    
}
