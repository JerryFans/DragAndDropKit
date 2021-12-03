//
//  DropViewModel.swift
//  DragAndDropKit_Example
//
//  Created by 逸风 on 2021/10/31.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

struct DropViewModel {
    
    private(set) var sources: [DropSource] = [
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
    
    mutating func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex else { return }
        let s = sources[sourceIndex]
        sources.remove(at: sourceIndex)
        sources.insert(s, at: destinationIndex)
    }
    
    mutating func addItem(_ source: DropSource, at index: Int) {
        sources.insert(source, at: index)
    }
}

extension DropViewModel {
    
    @available(iOS 11.0, *)
    func canHandle(_ session: UIDropSession) -> Bool {
        return session.hasItemsConforming(toTypeIdentifiers: [kUTTypeImage as String]) || session.hasItemsConforming(toTypeIdentifiers: [kUTTypePlainText as String])
        || session.hasItemsConforming(toTypeIdentifiers: [kUTTypeQuickTimeMovie as String])
        || session.hasItemsConforming(toTypeIdentifiers: [kUTTypeMPEG4 as String])
        || session.hasItemsConforming(toTypeIdentifiers: [kUTTypeURL as String])
    }
    
    @available(iOS 11.0, *)
    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
        let source = sources[indexPath.row]
        let itemProvider = NSItemProvider(object: source)
        return [
            UIDragItem(itemProvider: itemProvider)
        ]
    }
}
