//
//  UIView+Drag.Define.swift
//  DragAndDropKit
//
//  Created by 逸风 on 2021/12/6.
//

import UIKit

//@available(iOS 11.0, *)
//public func dragInteraction(_ interaction: UIDragInteraction, sessionWillBegin session: UIDragSession) {
//}

private var associatedObjectDropSource: UInt8 = 0
private var associatedObjectDidPreviewForDragSession: UInt8 = 0
private var associatedObjectDidAllowsMoveOperationSession: UInt8 = 0

private var associatedObjectWillBeginSession: UInt8 = 0
private var associatedObjectWillEndSession: UInt8 = 0
private var associatedObjectDidEndSession: UInt8 = 0
private var associatedObjectDidMoveSession: UInt8 = 0

@available(iOS 11.0, *)
public typealias WillBeginSession = (_ interaction: UIDragInteraction, _ session: UIDragSession) -> ()

@available(iOS 11.0, *)
public typealias WillEndSession = (_ interaction: UIDragInteraction, _ session: UIDragSession, _ operation: UIDropOperation) -> ()

@available(iOS 11.0, *)
public typealias DidEndSession = (_ interaction: UIDragInteraction, _ session: UIDragSession, _ operation: UIDropOperation) -> ()

@available(iOS 11.0, *)
public typealias DidMoveSession = (_ interaction: UIDragInteraction, _ session: UIDragSession) -> ()

@available(iOS 11.0, *)
public typealias DidPreviewForDragSession = (_ interaction: UIDragInteraction, _ item: UIDragItem, _ session: UIDragSession) -> (UITargetedDragPreview?)

@available(iOS 11.0, *)
public typealias DidAllowsMoveOperationSession = (_ interaction: UIDragInteraction, _ session: UIDragSession) -> (Bool)

extension Drag where Base: UIView {
    
    @available(iOS 11.0, *)
    var _willBeginSession: WillBeginSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectWillBeginSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectWillBeginSession) as? WillBeginSession
        }
    }
    
    @available(iOS 11.0, *)
    var _willEndSession: WillEndSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectWillEndSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectWillEndSession) as? WillEndSession
        }
    }
    
    @available(iOS 11.0, *)
    var _didEndSession: DidEndSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectDidEndSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectDidEndSession) as? DidEndSession
        }
    }
    
    @available(iOS 11.0, *)
    var _didMoveSession: DidMoveSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectDidMoveSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectDidMoveSession) as? DidMoveSession
        }
    }
    
    @available(iOS 11.0, *)
    var _didAllowsMoveOperationSession: DidAllowsMoveOperationSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectDidAllowsMoveOperationSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(base, &associatedObjectDidAllowsMoveOperationSession) as? DidAllowsMoveOperationSession
        }
    }
    
    @available(iOS 11.0, *)
    var _didPreviewForDragSession: DidPreviewForDragSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectDidPreviewForDragSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            if let rs = objc_getAssociatedObject(base, &associatedObjectDidPreviewForDragSession) as? DidPreviewForDragSession {
                return rs
            }
            return nil
        }
    }
    
    public var dropSource: DropSource? {
        set {
            objc_setAssociatedObject(base, &associatedObjectDropSource, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            if let rs = objc_getAssociatedObject(base, &associatedObjectDropSource) as? DropSource {
                return rs
            }
            return nil
        }
    }
    
}
