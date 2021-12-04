//
//  DragAndDropView.swift
//  DragAndDropView
//
//  Created by 逸风 on 2021/10/29.
//

import UIKit

class DragAndDropView: UIView {
    
    public func enabledDrag() {
        if #available(iOS 11.0, *) {
            let dragInteraction = UIDragInteraction(delegate: self)
            self.addInteraction(dragInteraction)
        }
    }
    
    public func enabledDrop() {
        if #available(iOS 11.0, *) {
            let dropInteraction = UIDropInteraction(delegate: self)
            self.addInteraction(dropInteraction)
        }
    }
}

