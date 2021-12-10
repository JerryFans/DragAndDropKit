//
//  UICollectionView+Drop.swift
//  UICollectionView+Drop
//
//  Created by 逸风 on 2021/10/29.
//

import Foundation
import UIKit
import JFPopup

extension Drop where Base: UICollectionView {
    
    @available(iOS 11.0, *)
    @discardableResult public func collectionViewDidEnterDropSession(collectionViewDidEnterDropSession: @escaping CollectionViewDidEnterDropSession) -> Drop {
        var muteSelf = self
        muteSelf._collectionViewDidEnterDropSession = collectionViewDidEnterDropSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func collectionViewDidEndDropSession(collectionViewDidEndDropSession: @escaping CollectionViewDidEndDropSession) -> Drop {
        var muteSelf = self
        muteSelf._collectionViewDidEndDropSession = collectionViewDidEndDropSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func collectionViewDidExitDropSession(collectionViewDidExitDropSession: @escaping CollectionViewDidExitDropSession) -> Drop {
        var muteSelf = self
        muteSelf._collectionViewDidExitDropSession = collectionViewDidExitDropSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func collectionViewDidUpdateDropSession(collectionViewDidUpdateDropSession: @escaping CollectionViewDidUpdateDropSession) -> Drop {
        var muteSelf = self
        muteSelf._collectionViewDidUpdateDropSession = collectionViewDidUpdateDropSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func enabled() -> Drop {
        base.dropDelegate = base
        return self
    }
    
}

extension UICollectionView: UICollectionViewDropDelegate {
    
    @available(iOS 11.0, *)
    public func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        if self.drop.supportSources.count > 0 {
            return DropViewModel.canHandle(with: self.drop.supportSources, session: session)
        }
        return self.dragAndDropVM.canHandle(session)
    }
    
    @available(iOS 11.0, *)
    public func collectionView(_ collectionView: UICollectionView, dropSessionDidEnter session: UIDropSession) {
        self.drop._collectionViewDidEnterDropSession?(collectionView,session)
    }
    
    @available(iOS 11.0, *)
    public func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        self.drop._collectionViewDidEndDropSession?(collectionView,session)
    }
    
    @available(iOS 11.0, *)
    public func collectionView(_ collectionView: UICollectionView, dropSessionDidExit session: UIDropSession) {
        self.drop._collectionViewDidExitDropSession?(collectionView,session)
    }
    
    @available(iOS 11.0, *)
    public func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        if let update = self.drop._collectionViewDidUpdateDropSession {
            return update(collectionView,session,destinationIndexPath)
        }
        
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
                if self.drop.supportSources.contains(item.type) == false {
                    continue
                }
                let indexPath = IndexPath(item: destinationIndexPath.item + index, section: destinationIndexPath.section)
                self.dragAndDropVM.addItem(item, at: indexPath.item)
                indexPaths.append(indexPath)
            }
            collectionView.insertItems(at: indexPaths)
        }
    }
    
}
