//
//  UICollectionView+Drag.swift
//  DragAndDropKit
//
//  Created by 逸风 on 2021/12/8.
//

import UIKit

extension Drag where Base: UICollectionView {
    
    @available(iOS 11.0, *)
    @discardableResult public func collectionViewDidEndDragSession(collectionViewDidEndDragSession: @escaping CollectionViewDidEndDragSession) -> Drag {
        var muteSelf = self
        muteSelf._collectionViewDidEndDragSession = collectionViewDidEndDragSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func collectionViewWillBeginDragSession(collectionViewWillBeginDragSession: @escaping CollectionViewWillBeginDragSession) -> Drag {
        var muteSelf = self
        muteSelf._collectionViewWillBeginDragSession = collectionViewWillBeginDragSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func collectionViewDidAllowsMoveOperationSession(collectionViewDidAllowsMoveOperationSession: @escaping CollectionViewDidAllowsMoveOperationSession) -> Drag {
        var muteSelf = self
        muteSelf._collectionViewDidAllowsMoveOperationSession = collectionViewDidAllowsMoveOperationSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func enabled() -> Drag {
        base.dragInteractionEnabled = true
        base.dragDelegate = base
        return self
    }
    
}

extension UICollectionView: UICollectionViewDragDelegate {
    
    @available(iOS 11.0, *)
    public func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
        self.drag._collectionViewWillBeginDragSession?(collectionView,session)
        print("CollectionView Will Begin Drag Session")
    }
    
    @available(iOS 11.0, *)
    public func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        self.drag._collectionViewDidEndDragSession?(collectionView,session)
        print("CollectionView Did End Drag Session")
    }
    
    @available(iOS 11.0, *)
    public func collectionView(_ collectionView: UICollectionView, dragSessionAllowsMoveOperation session: UIDragSession) -> Bool {
        return self.drag._collectionViewDidAllowsMoveOperationSession?(collectionView,session) ?? false
    }
    
    @available(iOS 11.0, *)
    public func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return self.dragAndDropVM.dragItems(for: indexPath)
    }
    
}

