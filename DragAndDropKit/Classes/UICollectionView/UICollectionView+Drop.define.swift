//
//  UICollectionView+Drop.define.swift
//  DragAndDropKit
//
//  Created by 逸风 on 2021/12/10.
//

import UIKit

private var associatedObjectDidEnterDropSession: UInt8 = 0
private var associatedObjectDidEndDropSession: UInt8 = 0
private var associatedObjectDidExitDropSession: UInt8 = 0
private var associatedObjectDidUpdateDropSession: UInt8 = 0

@available(iOS 11.0, *)
public typealias CollectionViewDidEnterDropSession = (_ collectionView: UICollectionView,_ session: UIDropSession) -> ()

@available(iOS 11.0, *)
public typealias CollectionViewDidEndDropSession = (_ collectionView: UICollectionView,_ session: UIDropSession) -> ()

@available(iOS 11.0, *)
public typealias CollectionViewDidExitDropSession = (_ collectionView: UICollectionView,_ session: UIDropSession) -> ()

@available(iOS 11.0, *)
public typealias CollectionViewDidUpdateDropSession = (_ collectionView: UICollectionView, _ session: UIDropSession, _ destinationIndexPath: IndexPath?) -> (UICollectionViewDropProposal)


extension Drop where Base: UICollectionView {
    
    @available(iOS 11.0, *)
    var _collectionViewDidEnterDropSession: CollectionViewDidEnterDropSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectDidEnterDropSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectDidEnterDropSession) as? CollectionViewDidEnterDropSession
        }
    }
    
    @available(iOS 11.0, *)
    var _collectionViewDidEndDropSession: CollectionViewDidEndDropSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectDidEndDropSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectDidEndDropSession) as? CollectionViewDidEndDropSession
        }
    }
    
    @available(iOS 11.0, *)
    var _collectionViewDidExitDropSession: CollectionViewDidExitDropSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectDidExitDropSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectDidExitDropSession) as? CollectionViewDidExitDropSession
        }
    }
    
    @available(iOS 11.0, *)
    var _collectionViewDidUpdateDropSession: CollectionViewDidUpdateDropSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectDidUpdateDropSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectDidUpdateDropSession) as? CollectionViewDidUpdateDropSession
        }
    }
    
}
