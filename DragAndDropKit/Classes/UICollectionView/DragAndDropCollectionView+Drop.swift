//
//  UICollectionView+Drop.swift
//  UICollectionView+Drop
//
//  Created by 逸风 on 2021/10/29.
//

import Foundation
import UIKit
import JFPopup

extension DragAndDropCollectionView: UICollectionViewDropDelegate {
    
    @available(iOS 11.0, *)
    public func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return dragAndDropVM.canHandle(session)
    }
    
    @available(iOS 11.0, *)
    public func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        var dropProposal = UICollectionViewDropProposal(operation: .cancel)
        if collectionView.hasActiveDrag {
            dropProposal = UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            dropProposal = UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
        return dropProposal
    }
    
    
    @available(iOS 11.0, *)
    public func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let item = collectionView.numberOfItems(inSection: 0)
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
            collectionView.insertItems(at: indexPaths)
        }
    }
    
}
