//
//  UITableView+Drag.swift
//  DragAndDropKit
//
//  Created by 逸风 on 2021/12/8.
//

import UIKit

extension Drag where Base: UITableView {
    
    @available(iOS 11.0, *)
    @discardableResult public func tableViewDidEndDragSession(tableViewDidEndDragSession: @escaping TableViewDidEndDragSession) -> Drag {
        var muteSelf = self
        muteSelf._tableViewDidEndDragSession = tableViewDidEndDragSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func tableViewWillBeginDragSession(tableViewWillBeginDragSession: @escaping TableViewWillBeginDragSession) -> Drag {
        var muteSelf = self
        muteSelf._tableViewWillBeginDragSession = tableViewWillBeginDragSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func tableViewDidAllowsMoveOperationSession(tableViewDidAllowsMoveOperationSession: @escaping TableViewDidAllowsMoveOperationSession) -> Drag {
        var muteSelf = self
        muteSelf._tableViewDidAllowsMoveOperationSession = tableViewDidAllowsMoveOperationSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func enabled() -> Drag {
        base.dragInteractionEnabled = true
        base.dragDelegate = base
        return self
    }
    
}

extension UITableView: UITableViewDragDelegate {
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, dragSessionWillBegin session: UIDragSession) {
        self.drag._tableViewWillBeginDragSession?(tableView,session)
        print("TableView Will Begin Drag Session")
    }
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, dragSessionDidEnd session: UIDragSession) {
        self.drag._tableViewDidEndDragSession?(tableView,session)
        print("TableView Did End Drag Session")
    }
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, dragSessionAllowsMoveOperation session: UIDragSession) -> Bool {
        return self.drag._tableViewDidAllowsMoveOperationSession?(tableView,session) ?? false
    }
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return self.dragAndDropVM.dragItems(for: indexPath)
    }
    
}

