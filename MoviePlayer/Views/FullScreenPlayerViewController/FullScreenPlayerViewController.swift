//
//  FullScreenPlayerViewController.swift
//  MoviePlayer
//
//  Created by Nguyên Duy on 3/28/20.
//  Copyright © 2020 Nguyên Duy. All rights reserved.
//

import UIKit
import AVKit

class FullScreenPlayerViewController: BaseViewController {
    // MARK: - IBOUTLETS
    @IBOutlet weak var vPlayerContainer: UIView!
    
    
    
    // MARK: - VARIABLES
    var video: Video?
    private var videoPlayerView: FullScreenPlayerView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    
    // MARK: - OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoPlayerView.pause()
        Ultilities.lockOrientation(.all, andRotateTo: .portrait)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    // MARK: - ACTIONS
    
    
    
    
    // MARK: - FUNCTIONS
    override func initRequest() {
        super.initRequest()
    }
    
    override func initLayout() {
        super.initLayout()
        Ultilities.lockOrientation(.landscape, andRotateTo: .landscapeRight)
        setUpPlayerView()
    }
    
    private func setUpPlayerView() {
        videoPlayerView = FullScreenPlayerView.makeInstance(with: self)
        videoPlayerView.frame = vPlayerContainer.bounds
        
        Helper.addSubview(subView: videoPlayerView, toView: vPlayerContainer)
        playVideo(with: (video?.source).orEmpty())
    }
    
    func playVideo(with url: String) {
        guard let videoUrl = URL(string: url) else { return }
        videoPlayerView.play(with: videoUrl)
    }
}

// MARK: - EXTENSIONS
extension FullScreenPlayerViewController: FullScreenPlayerViewDelegate {
    func playerView(_ playerView: FullScreenPlayerView, didUpdate playbackTime: Double) {
        
    }
    
    func playerView(_ playerView: FullScreenPlayerView, didUpdate status: AVPlayerItem.Status) {
        switch status {
        case .readyToPlay:
            log.debug(".readyToPlay")
        case .failed:
            log.debug(".failed")
        case .unknown:
            log.debug(".unknown")
        @unknown default:
            log.debug(".@unknown default")
        }
    }
    
    func didTapOnButtonDismiss(in playerView: FullScreenPlayerView) {
        self.closeViewController()
    }
}
