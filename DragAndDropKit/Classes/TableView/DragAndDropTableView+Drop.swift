//
//  DragAndDropTableView+Drop.swift
//  DragAndDropTableView+Drop
//
//  Created by 逸风 on 2021/10/29.
//

import UIKit

extension DragAndDropTableView: UITableViewDropDelegate {
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return dragAndDropVM.canHandle(session)
    }
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
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
                let indexPath = IndexPath(item: destinationIndexPath.item + index, section: destinationIndexPath.section)
                self.dragAndDropVM.addItem(item, at: indexPath.item)
                indexPaths.append(indexPath)
            }
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
}
