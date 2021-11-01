//
//  DropSource.swift
//  DragAndDropKit_Example
//
//  Created by 逸风 on 2021/10/30.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import JFPopup
import AVFoundation
import Photos

enum DropSourceError: Error {
    case invalidTypeIdentifier
}

protocol Shareable where Self: NSObject {
    static var shareIdentifier: String { get }
}

extension Shareable {
    static var shareIdentifier: String {
        let bundle = Bundle.main.bundleIdentifier!
        let typeString = String(describing: type(of: self))
        return "\(bundle).\(typeString)"
    }
}

final class DropSource: NSObject, Shareable {
    
    let typeIdentifier: String
    var text: String?
    var image: UIImage?
    var asset: AVURLAsset?
    
    init(image: UIImage) {
        typeIdentifier = kUTTypeImage as String
        self.image = image
        super.init()
    }
    
    
    init(text: String) {
        typeIdentifier = kUTTypePlainText as String
        self.text = text
        super.init()
    }
    
    init(asset: AVURLAsset, typeIdentifier: String) {
        self.typeIdentifier = typeIdentifier
        self.asset = asset
        super.init()
    }
}

//extension DropSource: NSItemProviderWriting {
//    static var writableTypeIdentifiersForItemProvider: [String] {
//        return [kUTTypeImage as String,
//                kUTTypePlainText as String,
//                kUTTypeQuickTimeMovie as String,
//                kUTTypeURL as String,
//                kUTTypeText as String,
//                kUTTypeMPEG4 as String]
//    }
//    
//    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
//           
//           switch typeIdentifier {
//           case kUTTypeImage as NSString as String:
//               if let img = image, let data = UIImageJPEGRepresentation(img, 1.0) {
//                   completionHandler(data, nil)
//               } else {
//                   completionHandler(nil, DropSourceError.invalidTypeIdentifier)
//               }
//           case kUTTypePlainText as NSString as String:
//               if let t = text {
//                   completionHandler(t.data(using: .utf8), nil)
//               } else {
//                   completionHandler(nil, DropSourceError.invalidTypeIdentifier)
//               }
//           case kUTTypeMPEG4 as NSString as String,kUTTypeQuickTimeMovie as NSString as String:
//               if let asset = asset {
//                   do {
//                       let d = try Data(contentsOf: asset.url)
//                       completionHandler(d, nil)
//                   } catch {
//                       completionHandler(nil, DropSourceError.invalidTypeIdentifier)
//                   }
//               } else {
//                   completionHandler(nil, DropSourceError.invalidTypeIdentifier)
//               }
//           default:
//               completionHandler(nil, DropSourceError.invalidTypeIdentifier)
//           }
//           
//           // I'm not returning any progress
//           return nil
//       }
//    
//}

extension DropSource: NSItemProviderReading {
    
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [kUTTypeImage as String,
                kUTTypePlainText as String,
                kUTTypeQuickTimeMovie as String,
                kUTTypeURL as String,
                kUTTypeText as String,
                kUTTypeMPEG4 as String]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> DropSource {
        switch typeIdentifier {
        case kUTTypeMPEG4 as NSString as String:
            let tmpDir = NSTemporaryDirectory()
            let tmpFile = "temp-\(UUID().uuidString).mp4"
            let tmpPath = tmpDir.appending(tmpFile)
            if FileManager.default.createFile(atPath: tmpPath, contents: data, attributes: nil) {
                let asset = AVURLAsset(url: URL(fileURLWithPath: tmpPath))
                JFPopupView.popup.alert {
                    [
                        .title("导入成功"),
                        .subTitle("路径是:\(tmpPath)")
                    ]
                }
                return DropSource(asset: asset, typeIdentifier: typeIdentifier)
            } else {
                throw DropSourceError.invalidTypeIdentifier
            }
        case kUTTypeQuickTimeMovie as NSString as String:
            let tmpDir = NSTemporaryDirectory()
            let tmpFile = "temp-\(UUID().uuidString).mov"
            let tmpPath = tmpDir.appending(tmpFile)
            if FileManager.default.createFile(atPath: tmpPath, contents: data, attributes: nil) {
                let asset = AVURLAsset(url: URL(fileURLWithPath: tmpPath))
                JFPopupView.popup.alert {
                    [
                        .title("导入成功"),
                        .subTitle("路径是:\(tmpPath)")
                    ]
                }
                return DropSource(asset: asset, typeIdentifier: typeIdentifier)
            } else {
                throw DropSourceError.invalidTypeIdentifier
            }
        case kUTTypeImage as NSString as String:
            return DropSource(image: UIImage(data: data)!)
        case kUTTypePlainText as NSString as String:
            return DropSource(text: String(data: data, encoding: .utf8)!)
        case kUTTypeText as NSString as String:
            return DropSource(text: String(data: data, encoding: .utf8)!)
        case kUTTypeURL as NSString as String:
            if let t = NSString(data: data, encoding: 0) {
                return DropSource(text: t  as String)
            } else {
                throw DropSourceError.invalidTypeIdentifier
            }
        default:
            throw DropSourceError.invalidTypeIdentifier
        }
    }
}
