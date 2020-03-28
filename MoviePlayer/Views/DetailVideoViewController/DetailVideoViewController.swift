//
//  DetailVideoViewController.swift
//  MoviePlayer
//
//  Created by Nguyên Duy on 3/27/20.
//  Copyright © 2020 Nguyên Duy. All rights reserved.
//

import UIKit
import AVKit

class DetailVideoViewController: BaseViewController {
    // MARK: - IBOUTLETS
    @IBOutlet weak var vPlayerContainer: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var sclContent: UIScrollView!
    @IBOutlet weak var vContent: UIView!
    
    
    
    // MARK: - VARIABLES
    var video: Video?
    private var videoPlayerView: VideoPlayerView!
    private var viewTranslation = CGPoint(x: 0, y: 0)
    private lazy var panDismissGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(handleDismiss))
        return gesture
    }()
    
    // MARK: - OVERRIDES
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        Helper.setupStatusBar(style: .lightContent, backgroundColor: UIColor.black)
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

        setUpPlayerView()
        populateData()
        self.view.addGestureRecognizer(panDismissGesture)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - ACTIONS
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            if sender.direction != PanDirection.up && sclContent.isAtTop {
                viewTranslation = sender.translation(in: view)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                })
            }
            
        case .ended:
            let dismissableValue = screenHeight * 0.4
            if viewTranslation.y < dismissableValue {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                })
            } else {
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
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
}
