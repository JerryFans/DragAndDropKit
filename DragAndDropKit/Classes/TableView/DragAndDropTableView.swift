//
//  DragAndDropTableView.swift
//  DragAndDropTableView
//
//  Created by 逸风 on 2021/10/29.
//

import UIKit

public class DragAndDropTableView: UITableView {
    
    public var dragAndDropVM: DropViewModel = DropViewModel()
    
    public func enabledDrag() {
        if #available(iOS 11.0, *) {
            self.dragInteractionEnabled = true
            self.dragDelegate = self
        }
    }
    
    public func enabledDrop() {
        if #available(iOS 11.0, *) {
            self.dropDelegate = self
        }
    }
}
