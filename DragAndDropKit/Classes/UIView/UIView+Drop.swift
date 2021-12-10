//
//  UIView+Drop.swift
//  UIView+Drop
//
//  Created by 逸风 on 2021/10/29.
//

import UIKit

extension UIView: DropCompatible {}
extension Drop where Base: UIView {
    
    @available(iOS 11.0, *)
    @discardableResult public func didEnterDropSession(didEnterDropSession: @escaping DidEnterDropSession) -> Drop {
        var muteSelf = self
        muteSelf._didEnterDropSession = didEnterDropSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func didEndDropSession(didEndDropSession: @escaping DidEndDropSession) -> Drop {
        var muteSelf = self
        muteSelf._didEndDropSession = didEndDropSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func didReceivedDropSource(didReceivedDropSource: @escaping DidReceivedDropSource) -> Drop {
        var muteSelf = self
        muteSelf._didReceivedDropSource = didReceivedDropSource
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func didUpdateDropSource(didUpdateDropSession: @escaping DidUpdateDropSession) -> Drop {
        var muteSelf = self
        muteSelf._didUpdateDropSession = didUpdateDropSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func didPreviewForDropSession(didPreviewForDropSession: @escaping DidPreviewForDropSession) -> Drop {
        var muteSelf = self
        muteSelf._didPreviewForDropSession = didPreviewForDropSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func willAnimateDropSession(willAnimateDropSession: @escaping WillAnimateDropSession) -> Drop {
        var muteSelf = self
        muteSelf._willAnimateDropSession = willAnimateDropSession
        return muteSelf
    }
    
    @available(iOS 11.0, *)
    @discardableResult public func enabled() -> Drop {
        let dropInteraction = UIDropInteraction(delegate: base)
        base.addInteraction(dropInteraction)
        return self
    }
}

extension UIView: UIDropInteractionDelegate {
    
    @available(iOS 11.0, *)
    public func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        if self.drop.supportSources.count > 0 {
            return DropViewModel.canHandle(with: self.drop.supportSources, session: session)
        }
        return DropViewModel.canHandle(session)
    }
    
    @available(iOS 11.0, *)
    public func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnter session: UIDropSession) {
        self.drop._didEnterDropSession?(interaction,session)
    }
    
    @available(iOS 11.0, *)
    public func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnd session: UIDropSession) {
        self.drop._didEndDropSession?(interaction,session)
    }
    
    @available(iOS 11.0, *)
    public func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        
        if let didUpdateSession = self.drop._didUpdateDropSession {
            return didUpdateSession(interaction, session)
        }
        
        let operation: UIDropOperation
        operation = .copy
        return UIDropProposal(operation: operation)
    }
    
    @available(iOS 11.0, *)
    public func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        session.loadObjects(ofClass: DropSource.self) { dropSources in
            if let dropSources = dropSources as? [DropSource] {
                let sources = dropSources.filter {
                    return self.drop.supportSources.contains($0.type)
                }
                self.drop._didReceivedDropSource?(sources)
            }
        }
        
    }
    
    @available(iOS 11.0, *)
    public func dropInteraction(_ interaction: UIDropInteraction, previewForDropping item: UIDragItem, withDefault defaultPreview: UITargetedDragPreview) -> UITargetedDragPreview? {
        return self.drop._didPreviewForDropSession?(interaction,item,defaultPreview)
    }
    
    @available(iOS 11.0, *)
    public func dropInteraction(_ interaction: UIDropInteraction, item: UIDragItem, willAnimateDropWith animator: UIDragAnimating) {
        self.drop._willAnimateDropSession?(interaction,item,animator)
    }
}

