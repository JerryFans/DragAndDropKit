//
//  UIView+Drag.swift
//  DragAndDropKit
//
//  Created by 逸风 on 2021/12/6.
//

import UIKit

private var associatedObjectDropSource: UInt8 = 0

extension UIView: DragCompatible {}
extension Drag where Base: UIView {
    
    public var dropSource: DropSource? {
        set {
            objc_setAssociatedObject(base, &associatedObjectDropSource, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            if let rs = objc_getAssociatedObject(base, &associatedObjectDropSource) as? DropSource {
                return rs
            }
            return nil
        }
    }
    
    @available(iOS 11.0, *)
    public func enabledDrag() -> Drag {
        let dragInteraction = UIDragInteraction(delegate: base)
        base.addInteraction(dragInteraction)
        return self
    }
    
}

extension UIView: UIDragInteractionDelegate {
    
    @available(iOS 11.0, *)
    public func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        if let source = self.drag.dropSource {
            let itemProvider = NSItemProvider(object: source)
            return [UIDragItem(itemProvider: itemProvider)]
        }
        return []
    }
}
