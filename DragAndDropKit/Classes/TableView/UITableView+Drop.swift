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
    @discardableResult public func tableViewDidReceivedDropSource(tableViewDidReceivedDropSource: @escaping TableViewDidReceivedDropSource) -> Drop {
        var muteSelf = self
        muteSelf._tableViewDidReceivedDropSource = tableViewDidReceivedDropSource
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func enabled() -> Drop {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            base.dropDelegate = base
        } else if #available(iOS 15.0, *) {
            base.dropDelegate = base
        }
        return self
    }
    
}

extension UITableView: UITableViewDropDelegate {
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        if self.drop.supportSources.count > 0 {
            return DropViewModel.canHandle(with: self.drop.supportSources, session: session)
        }
        return DropViewModel.canHandle(session)
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
        coordinator.session.loadObjects(ofClass: DropSource.self) { dropSources in
            if let dropSources = dropSources as? [DropSource] {
                let sources = dropSources.filter {
                    return self.drop.supportSources.contains($0.type)
                }
                self.drop._tableViewDidReceivedDropSource?(tableView,coordinator,sources)
            }
        }
    }
    
}
