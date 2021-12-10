//
//  UITableView+Drop.swift
//  UITableView+Drop
//
//  Created by 逸风 on 2021/10/29.
//

import Foundation
import UIKit
import JFPopup

extension Drop where Base: UITableView {
    
    @available(iOS 11.0, *)
    @discardableResult public func tableViewDidEnterDropSession(tableViewDidEnterDropSession: @escaping TableViewDidEnterDropSession) -> Drop {
        var muteSelf = self
        muteSelf._tableViewDidEnterDropSession = tableViewDidEnterDropSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func tableViewDidEndDropSession(tableViewDidEndDropSession: @escaping TableViewDidEndDropSession) -> Drop {
        var muteSelf = self
        muteSelf._tableViewDidEndDropSession = tableViewDidEndDropSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func tableViewDidExitDropSession(tableViewDidExitDropSession: @escaping TableViewDidExitDropSession) -> Drop {
        var muteSelf = self
        muteSelf._tableViewDidExitDropSession = tableViewDidExitDropSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func tableViewDidUpdateDropSession(tableViewDidUpdateDropSession: @escaping TableViewDidUpdateDropSession) -> Drop {
        var muteSelf = self
        muteSelf._tableViewDidUpdateDropSession = tableViewDidUpdateDropSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func enabled() -> Drop {
        base.dropDelegate = base
        return self
    }
    
}

extension UITableView: UITableViewDropDelegate {
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        if self.drop.supportSources.count > 0 {
            return DropViewModel.canHandle(with: self.drop.supportSources, session: session)
        }
        return self.dragAndDropVM.canHandle(session)
    }
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, dropSessionDidEnter session: UIDropSession) {
        self.drop._tableViewDidEnterDropSession?(tableView,session)
    }
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, dropSessionDidEnd session: UIDropSession) {
        self.drop._tableViewDidEndDropSession?(tableView,session)
    }
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, dropSessionDidExit session: UIDropSession) {
        self.drop._tableViewDidExitDropSession?(tableView,session)
    }
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        
        if let update = self.drop._tableViewDidUpdateDropSession {
            return update(tableView,session,destinationIndexPath)
        }
        
        var dropProposal = UITableViewDropProposal(operation: .cancel)
        if tableView.hasActiveDrag {
            dropProposal = UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            dropProposal = UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
        return dropProposal
    }
    
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let item = tableView.numberOfRows(inSection: 0)
            destinationIndexPath = IndexPath(row: item, section: 0)
        }
        
        coordinator.session.loadObjects(ofClass: DropSource.self) { dropSources in
            let dropSources = dropSources as! [DropSource]
            var indexPaths = [IndexPath]()
            for (index, item) in dropSources.enumerated() {
                if self.drop.supportSources.contains(item.type) == false {
                    continue
                }
                let indexPath = IndexPath(item: destinationIndexPath.item + index, section: destinationIndexPath.section)
                self.dragAndDropVM.addItem(item, at: indexPath.item)
                indexPaths.append(indexPath)
            }
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
}
