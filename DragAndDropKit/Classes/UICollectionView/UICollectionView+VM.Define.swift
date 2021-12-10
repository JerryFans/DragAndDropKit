//
//  UICollectionView+VM.Define.swift
//  DragAndDropKit
//
//  Created by 逸风 on 2021/12/8.
//

import UIKit

private var associatedObjectDropViewModel: UInt8 = 0

extension UICollectionView {
    
    public var dragAndDropVM: DropViewModel {
        
        set {
            objc_setAssociatedObject(self, &associatedObjectDropViewModel, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            if let rs = objc_getAssociatedObject(self, &associatedObjectDropViewModel) as? DropViewModel {
                return rs
            }
            let vm = DropViewModel()
            objc_setAssociatedObject(self, &associatedObjectDropViewModel, vm, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return vm
        }
    }
    
}
