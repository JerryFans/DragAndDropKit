//
//  UITableView+Drag.define.swift
//  DragAndDropKit
//
//  Created by 逸风 on 2021/12/10.
//

import Foundation


private var associatedObjectTableViewDidAllowsMoveOperationSession: UInt8 = 0
private var associatedObjectTableViewWillBeginDragSession: UInt8 = 0
private var associatedObjectTableViewDidEndDragSession: UInt8 = 0

@available(iOS 11.0, *)
public typealias TableViewDidAllowsMoveOperationSession = (_ tableView: UITableView,_ session: UIDragSession) -> (Bool)

@available(iOS 11.0, *)
public typealias TableViewWillBeginDragSession = (_ tableView: UITableView,_ session: UIDragSession) -> ()

@available(iOS 11.0, *)
public typealias TableViewDidEndDragSession = (_ tableView: UITableView,_ session: UIDragSession) -> ()

extension Drag where Base: UITableView {
    
    @available(iOS 11.0, *)
    var _tableViewDidEndDragSession: TableViewDidEndDragSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectTableViewDidEndDragSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectTableViewDidEndDragSession) as? TableViewDidEndDragSession
        }
    }
    
    @available(iOS 11.0, *)
    var _tableViewWillBeginDragSession: TableViewWillBeginDragSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectTableViewWillBeginDragSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectTableViewWillBeginDragSession) as? TableViewWillBeginDragSession
        }
    }
    
    @available(iOS 11.0, *)
    var _tableViewDidAllowsMoveOperationSession: TableViewDidAllowsMoveOperationSession? {
        set {
            objc_setAssociatedObject(base, &associatedObjectTableViewDidAllowsMoveOperationSession, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(base, &associatedObjectTableViewDidAllowsMoveOperationSession) as? TableViewDidAllowsMoveOperationSession
        }
    }
    
}
