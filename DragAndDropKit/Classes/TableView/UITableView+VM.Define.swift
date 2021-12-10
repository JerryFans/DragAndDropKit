//
//  UITableView+VM.Define.swift
//  DragAndDropKit
//
//  Created by 逸风 on 2021/12/8.
//

import UIKit

private var associatedObjectTableViewDropViewModel: UInt8 = 0

extension UITableView {
    
    public var dragAndDropVM: DropViewModel {
        
        set {
            objc_setAssociatedObject(self, &associatedObjectTableViewDropViewModel, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            if let rs = objc_getAssociatedObject(self, &associatedObjectTableViewDropViewModel) as? DropViewModel {
                return rs
            }
            let vm = DropViewModel()
            objc_setAssociatedObject(self, &associatedObjectTableViewDropViewModel, vm, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return vm
        }
    }
    
}
