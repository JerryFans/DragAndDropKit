//
//  UITableView+Drop.define.swift
//  DragAndDropKit
//
//  Created by 逸风 on 2021/12/10.
//

import UIKit

private var associatedObjectTableviewDidEnterDropSession: UInt8 = 0
private var associatedObjectTableviewDidEndDropSession: UInt8 = 0
private var associatedObjectTableviewDidExitDropSession: UInt8 = 0
private var associatedObjectTableviewDidUpdateDropSession: UInt8 = 0
private var associatedObjectTableviewDidReceivedDropSource: UInt8 = 0

@available(iOS 11.0, *)
public typealias TableViewDidEnterDropSession = (_ tableView: UITableView,_ session: UIDropSession) -> ()

@available(iOS 11.0, *)
public typealias TableViewDidEndDropSession = (_ tableView: UITableView,_ session: UIDropSession) -> ()

@available(iOS 11.0, *)
public typealias TableViewDidExitDropSession = (_ tableView: UITableView,_ session: UIDropSession) -> ()

@available(iOS 11.0, *)
public typealias TableViewDidUpdateDropSession = (_ tableView: UITableView, _ session: UIDropSession, _ destinationIndexPath: IndexPath?) -> (UITableViewDropProposal)

@available(iOS 11.0, *)
public typealias TableViewDidReceivedDropSource = (_ tableView: UITableView , _ coordinator: UITableViewDropCoordinator, _ dropSources: [DropSource]) -> ()


extension Drop where Base: UITableView {
    
    @available(iOS 11.0, *)
    var _tableViewDidReceivedDropSource: TableViewDidReceivedDropSource? {
        set {
            objc_setAssociatedObject(base, &associatedObjectTableviewDidReceivedDropSource, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectTableviewDidReceivedDropSource) as? TableViewDidReceivedDropSource
        }
    }
    
    @available(iOS 11.0, *)
    var _tableViewDidEnterDropSession: TableViewDidEnterDropSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectTableviewDidEnterDropSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectTableviewDidEnterDropSession) as? TableViewDidEnterDropSession
        }
    }
    
    @available(iOS 11.0, *)
    var _tableViewDidEndDropSession: TableViewDidEndDropSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectTableviewDidEndDropSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectTableviewDidEndDropSession) as? TableViewDidEndDropSession
        }
    }
    
    @available(iOS 11.0, *)
    var _tableViewDidExitDropSession: TableViewDidExitDropSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectTableviewDidExitDropSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectTableviewDidExitDropSession) as? TableViewDidExitDropSession
        }
    }
    
    @available(iOS 11.0, *)
    var _tableViewDidUpdateDropSession: TableViewDidUpdateDropSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectTableviewDidUpdateDropSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectTableviewDidUpdateDropSession) as? TableViewDidUpdateDropSession
        }
    }
    
}
