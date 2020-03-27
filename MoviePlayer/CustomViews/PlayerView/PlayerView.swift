//
//  PlayerView.swift
//  MoviePlayer
//
//  Created by Nguyên Duy on 3/27/20.
//  Copyright © 2020 Nguyên Duy. All rights reserved.
//

import UIKit
import AVFoundation

protocol PlayerViewDelegate: class {
    func playerView(_ playerView: PlayerView, didUpdate playbackTime: Double)
    func playerView(_ playerView: PlayerView, didUpdate status: AVPlayerItem.Status)
}

class PlayerView: UIView {
    // MARK: - VARIABLES
    weak var delegate: PlayerViewDelegate?
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
        
    var playerLayer: AVPlayerLayer {
        let avPlayerLayer = layer as! AVPlayerLayer
        avPlayerLayer.videoGravity = .resizeAspectFill
        return avPlayerLayer
//        return layer as! AVPlayerLayer
    }
    
    var isPlaying: Bool {
        if player != nil && player?.rate != 0 {
            return true
        } else {
            return false
        }
    }

    private var asset: AVAsset!
    private var playerItemContext = 0
    private var timeObserverToken: Any?

    // Keep the reference and use it to observe the loading status.
    private var playerItem: AVPlayerItem?
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    deinit {
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        removeBoundaryTimeObserver()
    }
    
    // MARK: - OVERRIDES
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
            
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
                delegate?.playerView(self, didUpdate: status)
            }
            delegate?.playerView(self, didUpdate: status)
            // Switch over status value
            switch status {
            case .readyToPlay:
                print(".readyToPlay")
                player?.play()
            case .failed:
                print(".failed")
            case .unknown:
                print(".unknown")
            @unknown default:
                print("@unknown default")
            }
        }
    }
    
    // MARK: - PUBLIC FUNCTIONS
    func play(with url: URL) {
        setUpAsset(with: url) { [weak self] (asset: AVAsset) in
            self?.setUpPlayerItem(with: asset)
        }
    }
    
    func pause() {
        player?.pause()
    }
    
    func resume() {
        player?.play()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setUpAsset(with url: URL, completion: ((_ asset: AVAsset) -> Void)?) {
        asset = AVAsset(url: url)
        asset.loadValuesAsynchronously(forKeys: ["playable"]) {
            var error: NSError? = nil
            let status = self.asset.statusOfValue(forKey: "playable", error: &error)
            switch status {
            case .loaded:
                completion?(self.asset)
            case .failed:
                print(".failed")
            case .cancelled:
                print(".cancelled")
            default:
                print("default")
            }
        }
    }
    
    private func setUpPlayerItem(with asset: AVAsset) {
        playerItem = AVPlayerItem(asset: asset)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
            
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.player = AVPlayer(playerItem: self.playerItem!)
            self.addPeriodicTimeObserver()
        }
    }
    
    private func addPeriodicTimeObserver() {
        // Notify every half second
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)

        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
            guard let self = self else { return }
            // update player transport UI
            self.delegate?.playerView(self, didUpdate: time.seconds)
        }
    }

    private func removeBoundaryTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
}
