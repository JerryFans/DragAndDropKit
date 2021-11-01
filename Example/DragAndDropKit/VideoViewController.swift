//
//  VideoViewController.swift
//  DragAndDropKit_Example
//
//  Created by 逸风 on 2021/10/31.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController {
    
    var asset: AVURLAsset?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        if let asset = self.asset {
            let originItem = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: originItem)
            let layer = AVPlayerLayer(player: player)
            layer.frame = view.bounds
            layer.videoGravity = .resizeAspect
            view.layer.addSublayer(layer)
            player.play()
        }
        // Do any additional setup after loading the view.
    }


}
