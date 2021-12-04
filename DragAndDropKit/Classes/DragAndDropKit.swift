//
//  DragAndDropKit.swift
//  DragAndDropKit
//
//  Created by 逸风 on 2021/10/29.
//

import Foundation

public struct DragAndDrop<Base> {
    public var base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol DragAndDropCompatible {}
extension DragAndDropCompatible {
    public static var dragAndDrop: DragAndDrop<Self>.Type {
        set {}
        get { DragAndDrop<Self>.self }
    }
    public var dragAndDrop: DragAndDrop<Self> {
        set {}
        get { DragAndDrop(self) }
    }
}

