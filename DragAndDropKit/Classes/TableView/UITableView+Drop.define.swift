//
//  UITableView+Drop.define.swift
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
public typealias TableViewDidEnterDropSession = (_ tableView: UITableView,_ session: UIDropSession) -> ()

@available(iOS 11.0, *)
public typealias TableViewDidEndDropSession = (_ tableView: UITableView,_ session: UIDropSession) -> ()

@available(iOS 11.0, *)
public typealias TableViewDidExitDropSession = (_ tableView: UITableView,_ session: UIDropSession) -> ()

@available(iOS 11.0, *)
public typealias TableViewDidUpdateDropSession = (_ tableView: UITableView, _ session: UIDropSession, _ destinationIndexPath: IndexPath?) -> (UITableViewDropProposal)


extension Drop where Base: UITableView {
    
    @available(iOS 11.0, *)
    var _tableViewDidEnterDropSession: TableViewDidEnterDropSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectDidEnterDropSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectDidEnterDropSession) as? TableViewDidEnterDropSession
        }
    }
    
    @available(iOS 11.0, *)
    var _tableViewDidEndDropSession: TableViewDidEndDropSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectDidEndDropSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectDidEndDropSession) as? TableViewDidEndDropSession
        }
    }
    
    @available(iOS 11.0, *)
    var _tableViewDidExitDropSession: TableViewDidExitDropSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectDidExitDropSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectDidExitDropSession) as? TableViewDidExitDropSession
        }
    }
    
    @available(iOS 11.0, *)
    var _tableViewDidUpdateDropSession: TableViewDidUpdateDropSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectDidUpdateDropSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectDidUpdateDropSession) as? TableViewDidUpdateDropSession
        }
    }
    
}
