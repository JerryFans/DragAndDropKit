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
    @discardableResult public func collectionViewDidReceivedDropSource(collectionViewDidReceivedDropSource: @escaping CollectionViewDidReceivedDropSource) -> Drop {
        var muteSelf = self
        muteSelf._collectionViewDidReceivedDropSource = collectionViewDidReceivedDropSource
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

extension UICollectionView: UICollectionViewDropDelegate {
    
    @available(iOS 11.0, *)
    public func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        if self.drop.supportSources.count > 0 {
            return DropViewModel.canHandle(with: self.drop.supportSources, session: session)
        }
        return DropViewModel.canHandle(session)
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
        
        coordinator.session.loadObjects(ofClass: DropSource.self) { dropSources in
            if let dropSources = dropSources as? [DropSource] {
                let sources = dropSources.filter {
                    return self.drop.supportSources.contains($0.type)
                }
                self.drop._collectionViewDidReceivedDropSource?(collectionView,coordinator,sources)
            }
        }
    }
    
}
