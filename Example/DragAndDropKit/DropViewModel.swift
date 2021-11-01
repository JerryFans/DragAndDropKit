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
        DropSource(image: UIImage(named: "template-1")!),
        DropSource(image: UIImage(named: "template-2")!),
        DropSource(image: UIImage(named: "template-3")!),
        DropSource(image: UIImage(named: "template-4")!),
        DropSource(image: UIImage(named: "template-5")!),
        DropSource(image: UIImage(named: "template-6")!),
        DropSource(image: UIImage(named: "template-7")!),
        DropSource(image: UIImage(named: "template-8")!),
        DropSource(image: UIImage(named: "template-9")!),
        DropSource(image: UIImage(named: "template-10")!),
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
        
        var itemProvider = NSItemProvider()
//        itemProvider = NSItemProvider(object: source)
        
        if source.typeIdentifier == kUTTypePlainText as String {
            let text = source.text ?? ""
            let data = text.data(using: .utf8)
            itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
                completion(data,nil)
                return nil
            }
        } else if source.typeIdentifier == kUTTypeImage as String, let img = source.image {
            itemProvider = NSItemProvider(object: img)
        } else if source.typeIdentifier == kUTTypeMPEG4 as String || source.typeIdentifier == kUTTypeQuickTimeMovie as String, let asset = source.asset {
            itemProvider.registerDataRepresentation(forTypeIdentifier: source.typeIdentifier, visibility: .all) { completion in
                do {
                    let data = try Data(contentsOf: asset.url)
                    completion(data,nil)
                } catch {
                    completion(nil,nil)
                }
                return nil
            }
        }

        return [
            UIDragItem(itemProvider: itemProvider)
        ]
    }
}
