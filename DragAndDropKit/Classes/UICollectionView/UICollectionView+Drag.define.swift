//
//  UICollectionView+Drag.define.swift
//  DragAndDropKit
//
//  Created by 逸风 on 2021/12/10.
//

import Foundation


private var associatedObjectCollectionViewDidAllowsMoveOperationSession: UInt8 = 0
private var associatedObjectCollectionViewWillBeginDragSession: UInt8 = 0
private var associatedObjectCollectionViewDidEndDragSession: UInt8 = 0
private var associatedObjectCollectionViewDidItemsForBeginning: UInt8 = 0

@available(iOS 11.0, *)
public typealias CollectionViewDidItemsForBeginning = (_ collectionView: UICollectionView,_ session: UIDragSession, _ indexPath: IndexPath) -> ([UIDragItem])

@available(iOS 11.0, *)
public typealias CollectionViewDidAllowsMoveOperationSession = (_ collectionView: UICollectionView,_ session: UIDragSession) -> (Bool)

@available(iOS 11.0, *)
public typealias CollectionViewWillBeginDragSession = (_ collectionView: UICollectionView,_ session: UIDragSession) -> ()

@available(iOS 11.0, *)
public typealias CollectionViewDidEndDragSession = (_ collectionView: UICollectionView,_ session: UIDragSession) -> ()

extension Drag where Base: UICollectionView {
    
    @available(iOS 11.0, *)
    var _collectionViewDidItemsForBeginning: CollectionViewDidItemsForBeginning? {
        set {
            objc_setAssociatedObject(base, &associatedObjectCollectionViewDidItemsForBeginning, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectCollectionViewDidItemsForBeginning) as? CollectionViewDidItemsForBeginning
        }
    }
    
    @available(iOS 11.0, *)
    var _collectionViewDidEndDragSession: CollectionViewDidEndDragSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectCollectionViewDidEndDragSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectCollectionViewDidEndDragSession) as? CollectionViewDidEndDragSession
        }
    }
    
    @available(iOS 11.0, *)
    var _collectionViewWillBeginDragSession: CollectionViewWillBeginDragSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectCollectionViewWillBeginDragSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectCollectionViewWillBeginDragSession) as? CollectionViewWillBeginDragSession
        }
    }
    
    @available(iOS 11.0, *)
    var _collectionViewDidAllowsMoveOperationSession: CollectionViewDidAllowsMoveOperationSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectCollectionViewDidAllowsMoveOperationSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectCollectionViewDidAllowsMoveOperationSession) as? CollectionViewDidAllowsMoveOperationSession
        }
    }
    
}
