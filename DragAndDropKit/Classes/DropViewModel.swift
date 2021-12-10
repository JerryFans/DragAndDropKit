//
//  DropViewModel.swift
//  DragAndDropKit
//
//  Created by 逸风 on 2021/12/3.
//

import Foundation
import UIKit
import MobileCoreServices

public struct DropViewModel {
    
    public init() {
        
    }
    
    public var sources: [DropSource] = [
        ImageDropSource(image: UIImage(named: "template-1")!),
        ImageDropSource(image: UIImage(named: "template-2")!),
        ImageDropSource(image: UIImage(named: "template-3")!),
        ImageDropSource(image: UIImage(named: "template-4")!),
        ImageDropSource(image: UIImage(named: "template-5")!),
        ImageDropSource(image: UIImage(named: "template-6")!),
        ImageDropSource(image: UIImage(named: "template-7")!),
        ImageDropSource(image: UIImage(named: "template-8")!),
        ImageDropSource(image: UIImage(named: "template-9")!),
        ImageDropSource(image: UIImage(named: "template-10")!),
    ]
    
    public mutating func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex else { return }
        let s = sources[sourceIndex]
        sources.remove(at: sourceIndex)
        sources.insert(s, at: destinationIndex)
    }
    
    public mutating func addItem(_ source: DropSource, at index: Int) {
        sources.insert(source, at: index)
    }
}

extension DropViewModel {
    
    @available(iOS 11.0, *)
    public func canHandle(_ session: UIDropSession) -> Bool {
        return Self.canHandle(session)
    }
    
    @available(iOS 11.0, *)
    public static func canHandle(_ session: UIDropSession) -> Bool {
        return session.hasItemsConforming(toTypeIdentifiers: [kUTTypeImage as String]) || session.hasItemsConforming(toTypeIdentifiers: [kUTTypePlainText as String])
        || session.hasItemsConforming(toTypeIdentifiers: [kUTTypeQuickTimeMovie as String])
        || session.hasItemsConforming(toTypeIdentifiers: [kUTTypeMPEG4 as String])
        || session.hasItemsConforming(toTypeIdentifiers: [kUTTypeURL as String])
    }
    
    @available(iOS 11.0, *)
    public static func canHandle(with supportSources: [DropSourceOption], session: UIDropSession) -> Bool {
        var canHandle = false
        for option in supportSources {
            switch option {
            case .rawImage:
                canHandle = session.hasItemsConforming(toTypeIdentifiers: [kUTTypeImage as String])
                break
            case .rawVideo:
                canHandle = session.hasItemsConforming(toTypeIdentifiers: [kUTTypeQuickTimeMovie as String]) || session.hasItemsConforming(toTypeIdentifiers: [kUTTypeMPEG4 as String])
                break
            case .text:
                canHandle = session.hasItemsConforming(toTypeIdentifiers: [kUTTypePlainText as String]) || session.hasItemsConforming(toTypeIdentifiers: [kUTTypeURL as String])
                break
            case .unknown:
                break
            }
        }
        return canHandle
    }
    
    @available(iOS 11.0, *)
    public func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
        let source = sources[indexPath.row]
        let itemProvider = NSItemProvider(object: source)
        return [
            UIDragItem(itemProvider: itemProvider)
        ]
    }
}
