//
//  UICollectionView+Drop.define.swift
//  DragAndDropKit
//
//  Created by 逸风 on 2021/12/10.
//

import UIKit

private var associatedObjectCollectionviewDidEnterDropSession: UInt8 = 0
private var associatedObjectCollectionviewDidEndDropSession: UInt8 = 0
private var associatedObjectCollectionviewDidExitDropSession: UInt8 = 0
private var associatedObjectCollectionviewDidUpdateDropSession: UInt8 = 0
private var associatedObjectCollectionviewDidReceivedDropSource: UInt8 = 0

@available(iOS 11.0, *)
public typealias CollectionViewDidEnterDropSession = (_ collectionView: UICollectionView,_ session: UIDropSession) -> ()

@available(iOS 11.0, *)
public typealias CollectionViewDidEndDropSession = (_ collectionView: UICollectionView,_ session: UIDropSession) -> ()

@available(iOS 11.0, *)
public typealias CollectionViewDidExitDropSession = (_ collectionView: UICollectionView,_ session: UIDropSession) -> ()

@available(iOS 11.0, *)
public typealias CollectionViewDidUpdateDropSession = (_ collectionView: UICollectionView, _ session: UIDropSession, _ destinationIndexPath: IndexPath?) -> (UICollectionViewDropProposal)

@available(iOS 11.0, *)
public typealias CollectionViewDidReceivedDropSource = (_ collectionView: UICollectionView , _ coordinator: UICollectionViewDropCoordinator,[DropSource]) -> ()


extension Drop where Base: UICollectionView {
    
    @available(iOS 11.0, *)
    var _collectionViewDidReceivedDropSource: CollectionViewDidReceivedDropSource? {
        set {
            objc_setAssociatedObject(base, &associatedObjectCollectionviewDidReceivedDropSource, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectCollectionviewDidReceivedDropSource) as? CollectionViewDidReceivedDropSource
        }
    }
    
    @available(iOS 11.0, *)
    var _collectionViewDidEnterDropSession: CollectionViewDidEnterDropSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectCollectionviewDidEnterDropSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectCollectionviewDidEnterDropSession) as? CollectionViewDidEnterDropSession
        }
    }
    
    @available(iOS 11.0, *)
    var _collectionViewDidEndDropSession: CollectionViewDidEndDropSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectCollectionviewDidEndDropSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectCollectionviewDidEndDropSession) as? CollectionViewDidEndDropSession
        }
    }
    
    @available(iOS 11.0, *)
    var _collectionViewDidExitDropSession: CollectionViewDidExitDropSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectCollectionviewDidExitDropSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectCollectionviewDidExitDropSession) as? CollectionViewDidExitDropSession
        }
    }
    
    @available(iOS 11.0, *)
    var _collectionViewDidUpdateDropSession: CollectionViewDidUpdateDropSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectCollectionviewDidUpdateDropSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectCollectionviewDidUpdateDropSession) as? CollectionViewDidUpdateDropSession
        }
    }
    
}
