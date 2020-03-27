//
//  DetailVideoViewController.swift
//  MoviePlayer
//
//  Created by Nguyên Duy on 3/27/20.
//  Copyright © 2020 Nguyên Duy. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class DetailVideoViewController: BaseViewController {
    // MARK: - IBOUTLETS
    @IBOutlet weak var vPlayerContainer: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var sclContent: UIScrollView!
    
    
    
    // MARK: - VARIABLES
    var video: Video?
    var playerController = AVPlayerViewController()
    private var videoPlayerView: VideoPlayerView!
    private var videoPlayerViewCenter = CGPoint.zero
    
    
    // MARK: - OVERRIDES
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        Helper.setupStatusBar(style: .lightContent, backgroundColor: .clear)
        self.videoPlayerView.pause()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Helper.setupStatusBar(style: .lightContent, backgroundColor: UIColor.black)
        setUpPlayerView()
        populateData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - ACTIONS
    
    
    
    // MARK: - FUNCTIONS
    private func setUpPlayerView() {
        videoPlayerView = VideoPlayerView.makeInstance(with: self)
        videoPlayerView.frame = vPlayerContainer.bounds
        
        Helper.addSubview(subView: videoPlayerView, toView: vPlayerContainer)
    }
    
    func playVideo(with url: String) {
        guard let videoUrl = URL(string: url) else { return }
        videoPlayerView.play(with: videoUrl)
    }
    
    func populateData() {
        guard let video = video else { return }
        lbTitle.text = video.title
        lbSubtitle.text = video.subtitle
        tvDescription.text = video.description
        playVideo(with: video.source.orEmpty())
    }

}
// MARK: - EXTENSIONS
extension DetailVideoViewController: VideoPlayerViewDelegate {
    func playerView(_ playerView: VideoPlayerView, didUpdate playbackTime: Double) {
//        log.debug("Playback time: \(playbackTime)")
    }
    
    func playerView(_ playerView: VideoPlayerView, didUpdate status: AVPlayerItem.Status) {
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
    
    func didTapOnButtonDismiss(in playerView: VideoPlayerView) {
        self.closeViewController()
    }
    
    func didTapOnButtonFullscreen(in playerView: VideoPlayerView) {
        
    }
    
    @objc func avPlayerClosed(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.videoPlayerView.player?.play()
        }
    }
    
    private func handleFullScreen(for playerView: VideoPlayerView) {
        if !playerView.isFullscreen {
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
                guard let self = self else { return }
                self.vPlayerContainer.translatesAutoresizingMaskIntoConstraints = false
                self.videoPlayerViewCenter = self.vPlayerContainer.center
                self.vPlayerContainer.frame = CGRect(x: 0, y: 0, width: screenHeight, height: screenWidth)
                playerView.playerLayer.frame = CGRect(x: 0, y: 0, width: screenHeight, height: screenWidth)
                self.vPlayerContainer.center = self.view.center
                self.vPlayerContainer.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
                self.vPlayerContainer.layoutSubviews()
                self.view.layoutIfNeeded()
            }) { [weak self] (finished) in
                guard let self = self else { return }
                playerView.isFullscreen.toggle()
            }
        } else {
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.vPlayerContainer.transform = CGAffineTransform.identity
                self.vPlayerContainer.center = self.videoPlayerViewCenter

                let height = screenWidth * 9 / 16
                let videoPlayerFrame = CGRect(x: 0, y: 0, width: screenWidth, height: height)
                self.vPlayerContainer.frame = videoPlayerFrame
                self.vPlayerContainer.layoutSubviews()
                self.view.layoutIfNeeded()
            }, completion: { [weak self] (finished) in
                guard let self = self else { return }
                playerView.isFullscreen.toggle()
            })
        }
    }
}

extension DetailVideoViewController: AVPlayerViewControllerDelegate {
    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
             let currentviewController =  navigationController?.visibleViewController
             if currentviewController != playerViewController {
                 currentviewController?.present(playerViewController,animated: true,completion:nil)
             }
         }
}
