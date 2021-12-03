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

final class ImageDropSource: DropSource {
    var image: UIImage
    
    init(image: UIImage) {
        self.image = image
        super.init()
        typeIdentifier = kUTTypeImage as String
        if #available(iOS 11.0, *) {
        self.writableTypeIdentifiersForItemProvider = UIImage.writableTypeIdentifiersForItemProvider
        }
    }
    
    override func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
        switch typeIdentifier {
        case kUTTypePNG as NSString as String:
            if let data = UIImagePNGRepresentation(image) {
                completionHandler(data, nil)
            } else {
                completionHandler(nil, DropSourceError.invalidTypeIdentifier)
            }
        case kUTTypeJPEG as NSString as String:
            if let data = UIImageJPEGRepresentation(image, 1) {
                completionHandler(data, nil)
            } else {
                completionHandler(nil, DropSourceError.invalidTypeIdentifier)
            }
        default:
            completionHandler(nil, DropSourceError.invalidTypeIdentifier)
        }
        // I'm not returning any progress
        return progress
    }
}

final class TextDropSource: DropSource {
    var text: String
    
    override func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
        completionHandler(text.data(using: .utf8), nil)
        return progress
    }
    
    init(text: String) {
        self.text = text
        super.init()
        typeIdentifier = kUTTypePlainText as String
        if #available(iOS 11.0, *) {
            self.writableTypeIdentifiersForItemProvider = NSString.writableTypeIdentifiersForItemProvider
        }
    }
}

final class VideoDropSource: DropSource {
    
    var asset: AVURLAsset
    
    override func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
        switch typeIdentifier {
        case kUTTypeMPEG4 as NSString as String,kUTTypeQuickTimeMovie as NSString as String:
            do {
                let d = try Data(contentsOf: asset.url)
                completionHandler(d, nil)
            } catch {
                completionHandler(nil, DropSourceError.invalidTypeIdentifier)
            }
        default:
            completionHandler(nil, DropSourceError.invalidTypeIdentifier)
        }
        return progress
    }
    
    init(asset: AVURLAsset, typeIdentifier: String) {
        self.asset = asset
        super.init()
        self.typeIdentifier = typeIdentifier
        if #available(iOS 11.0, *) {
        self.writableTypeIdentifiersForItemProvider = [typeIdentifier]
        }
    }
}

class DropSource: NSObject {
    
    var writableTypeIdentifiersForItemProvider: [String] = []
    var typeIdentifier: String = ""
    
    override init() {
        super.init()
    }
    
}

extension DropSource: NSItemProviderWriting {
    
    @available(iOS 11.0, *)
    static var writableTypeIdentifiersForItemProvider: [String] {
        return UIImage.writableTypeIdentifiersForItemProvider +
        [kUTTypePlainText as String,
         kUTTypeQuickTimeMovie as String,
         kUTTypeURL as String,
         kUTTypeText as String,
         kUTTypeMPEG4 as String,
         kUTTypeData as String]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
        completionHandler(nil, DropSourceError.invalidTypeIdentifier)
        return progress
    }
    
}

extension DropSource: NSItemProviderReading {
    
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [kUTTypeImage as String,
                kUTTypePlainText as String,
                kUTTypeQuickTimeMovie as String,
                kUTTypeURL as String,
                kUTTypeText as String,
                kUTTypeMPEG4 as String]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
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
                return VideoDropSource(asset: asset, typeIdentifier: typeIdentifier) as! Self
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
                return VideoDropSource(asset: asset, typeIdentifier: typeIdentifier) as! Self
            } else {
                throw DropSourceError.invalidTypeIdentifier
            }
        case kUTTypeImage as NSString as String:
            return ImageDropSource(image: UIImage(data: data)!) as! Self
        case kUTTypePlainText as NSString as String:
            return TextDropSource(text: String(data: data, encoding: .utf8)!) as! Self
        case kUTTypeText as NSString as String:
            return TextDropSource(text: String(data: data, encoding: .utf8)!) as! Self
        case kUTTypeURL as NSString as String:
            if let t = NSString(data: data, encoding: 0) {
                return TextDropSource(text: t  as String) as! Self
            } else {
                throw DropSourceError.invalidTypeIdentifier
            }
        default:
            throw DropSourceError.invalidTypeIdentifier
        }
    }
}
