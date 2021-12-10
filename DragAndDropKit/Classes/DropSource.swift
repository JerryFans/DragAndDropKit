//
//  DropSource.swift
//  DragAndDropKit
//
//  Created by 逸风 on 2021/12/3.
//

import Foundation
import UIKit
import MobileCoreServices
import JFPopup
import AVFoundation
import Photos

public enum DropSourceOption {
    case unknown
    case rawImage
    case rawVideo
    case text
}

public enum DropSourceError: Error {
    case invalidTypeIdentifier
}

public class NetworkImageDropSource: DropSource {
    public var imageUrl: String
    
    public init(imageUrl: String) {
        self.imageUrl = imageUrl
        super.init()
        typeIdentifier = kUTTypeImage as String
        self.type = .rawImage
        if #available(iOS 11.0, *) {
            self.writableTypeIdentifiersForItemProvider = UIImage.writableTypeIdentifiersForItemProvider
            
        }
    }
    
    
    public override func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
        let task = URLSession.shared.downloadTask(with: URL(string: imageUrl)!) { url, rsp, error in
            if let url = url {
                do {
                    let d = try Data(contentsOf: url)
                    completionHandler(d, nil)
                } catch {
                    completionHandler(nil, DropSourceError.invalidTypeIdentifier)
                }
            }
        }
        task.resume()
        // I'm not returning any progress
        if #available(iOS 11.0, *) {
            return task.progress
        } else {
            return progress
        }
    }
}

public class ImageDropSource: DropSource {
    public var image: UIImage
    
    public init(image: UIImage) {
        self.image = image
        super.init()
        typeIdentifier = kUTTypeImage as String
        self.type = .rawImage
        if #available(iOS 11.0, *) {
            self.localObject = image
            self.writableTypeIdentifiersForItemProvider = UIImage.writableTypeIdentifiersForItemProvider
        }
    }
    
    public override func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
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

public class TextDropSource: DropSource {
    public var text: String
    
    public override func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
        completionHandler(text.data(using: .utf8), nil)
        return progress
    }
    
    public init(text: String) {
        self.text = text
        super.init()
        typeIdentifier = kUTTypePlainText as String
        self.type = .text
        if #available(iOS 11.0, *) {
            self.localObject = text
            self.writableTypeIdentifiersForItemProvider = NSString.writableTypeIdentifiersForItemProvider
        }
    }
}

public class NetworkVideoDropSource: DropSource {
    public var videoUrl: String
    
    public init(videoUrl: String) {
        self.videoUrl = videoUrl
        super.init()
        typeIdentifier = kUTTypeMPEG4 as String
        self.type = .rawVideo
        if #available(iOS 11.0, *) {
            self.writableTypeIdentifiersForItemProvider = [typeIdentifier]
        }
    }
    
    
    public override func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
        let task = URLSession.shared.downloadTask(with: URL(string: videoUrl)!) { url, rsp, error in
            if let url = url {
                do {
                    let d = try Data(contentsOf: url)
                    completionHandler(d, nil)
                } catch {
                    completionHandler(nil, DropSourceError.invalidTypeIdentifier)
                }
            }
        }
        task.resume()
        // I'm not returning any progress
        if #available(iOS 11.0, *) {
            return task.progress
        } else {
            return progress
        }
    }
}

public class VideoDropSource: DropSource {
    
    public var asset: AVURLAsset
    
    public override func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
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
    
    public init(asset: AVURLAsset, typeIdentifier: String) {
        self.asset = asset
        super.init()
        self.typeIdentifier = typeIdentifier
        self.type = .rawVideo
        if #available(iOS 11.0, *) {
            self.localObject = asset
            self.writableTypeIdentifiersForItemProvider = [typeIdentifier]
        }
    }
}

public class DropSource: NSObject {
    
    public var writableTypeIdentifiersForItemProvider: [String] = []
    public var type: DropSourceOption = .unknown
    public var typeIdentifier: String = ""
    public var localObject: Any?
    
    override init() {
        super.init()
    }
    
}

extension DropSource: NSItemProviderWriting {
    
    @available(iOS 11.0, *)
    public static var writableTypeIdentifiersForItemProvider: [String] {
        return UIImage.writableTypeIdentifiersForItemProvider +
        [kUTTypePlainText as String,
         kUTTypeQuickTimeMovie as String,
         kUTTypeURL as String,
         kUTTypeText as String,
         kUTTypeMPEG4 as String]
    }
    
    public func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
        completionHandler(nil, DropSourceError.invalidTypeIdentifier)
        return progress
    }
    
}

extension DropSource: NSItemProviderReading {
    
    public static var readableTypeIdentifiersForItemProvider: [String] {
        return [kUTTypeImage as String,
                kUTTypePlainText as String,
                kUTTypeQuickTimeMovie as String,
                kUTTypeURL as String,
                kUTTypeText as String,
                kUTTypeMPEG4 as String]
    }
    
    public static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        switch typeIdentifier {
        case kUTTypeMPEG4 as NSString as String:
            let tmpDir = NSTemporaryDirectory()
            let tmpFile = "temp-\(UUID().uuidString).mp4"
            let tmpPath = tmpDir.appending(tmpFile)
            if FileManager.default.createFile(atPath: tmpPath, contents: data, attributes: nil) {
                let asset = AVURLAsset(url: URL(fileURLWithPath: tmpPath))
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
