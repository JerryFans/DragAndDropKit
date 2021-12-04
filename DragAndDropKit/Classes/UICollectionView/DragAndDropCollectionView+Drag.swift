//
//  DragAndDropCollectionView+Drag.swift
//  DragAndDropCollectionView+Drag
//
//  Created by 逸风 on 2021/10/29.
//

import Foundation

extension DragAndDropCollectionView: UICollectionViewDragDelegate {
    
    @available(iOS 11.0, *)
    private func collectionView(_ collectionView: UICollectionView, dragSessionAllowsMoveOperation session: UIDragSession) -> Bool {
        return false
    }
    
    @available(iOS 11.0, *)
    public func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return dragAndDropVM.dragItems(for: indexPath)
    }
}
