//
//  DragAndDropKit.swift
//  DragAndDropKit
//
//  Created by 逸风 on 2021/10/29.
//

import Foundation

public struct Drop<Base> {
    public var base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol DropCompatible {}
extension DropCompatible {
    public static var drop: Drop<Self>.Type {
        set {}
        get { Drop<Self>.self }
    }
    public var drop: Drop<Self> {
        set {}
        get { Drop(self) }
    }
}

public struct Drag<Base> {
    public var base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol DragCompatible {}
extension DragCompatible {
    public static var drag: Drag<Self>.Type {
        set {}
        get { Drag<Self>.self }
    }
    public var drag: Drag<Self> {
        set {}
        get { Drag(self) }
    }
}
