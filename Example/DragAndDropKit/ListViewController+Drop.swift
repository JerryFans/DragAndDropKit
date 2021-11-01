//
//  ListViewController+Drop.swift
//  DragAndDropKit_Example
//
//  Created by 逸风 on 2021/10/31.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import JFPopup
extension ListViewController: UICollectionViewDropDelegate {
    
    @available(iOS 11.0, *)
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return dropVM.canHandle(session)
    }
    
    @available(iOS 11.0, *)
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        var dropProposal = UICollectionViewDropProposal(operation: .cancel)
        if collectionView.hasActiveDrag {
            dropProposal = UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            dropProposal = UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
        return dropProposal
    }
    
    
    @available(iOS 11.0, *)
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {

        
        
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
                self.dropVM.addItem(item, at: indexPath.item)
                indexPaths.append(indexPath)
            }
            collectionView.insertItems(at: indexPaths)
        }
    }
    
}
