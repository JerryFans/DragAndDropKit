//
//  DragAndDropTableView+Drag.swift
//  DragAndDropTableView+Drag
//
//  Created by 逸风 on 2021/10/29.
//

import UIKit

extension DragAndDropTableView: UITableViewDragDelegate {
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, dragSessionAllowsMoveOperation session: UIDragSession) -> Bool {
        return false
    }
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return dragAndDropVM.dragItems(for: indexPath)
    }
    
}
