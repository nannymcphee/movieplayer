//
//  FullScreenPlayerView.swift
//  MoviePlayer
//
//  Created by Nguyên Duy on 3/28/20.
//  Copyright © 2020 Nguyên Duy. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer

protocol FullScreenPlayerViewDelegate: class {
    func playerView(_ playerView: FullScreenPlayerView, didUpdate playbackTime: Double)
    func playerView(_ playerView: FullScreenPlayerView, didUpdate status: AVPlayerItem.Status)
    func didTapOnButtonDismiss(in playerView: FullScreenPlayerView)
}

extension FullScreenPlayerViewDelegate {
    func playerView(_ playerView: FullScreenPlayerView, didUpdate playbackTime: Double) {}
    func playerView(_ playerView: FullScreenPlayerView, didUpdate status: AVPlayerItem.Status) {}
    func didTapOnButtonDismiss(in playerView: FullScreenPlayerView) {}
}

fileprivate enum PlayerPlaybackState {
    case loading
    case playing
    case paused
    case finished
}

class FullScreenPlayerView: UIView {
    // MARK: - IBOUTLETS
    @IBOutlet weak var vPlayerContainer: UIView!
    @IBOutlet weak var vPlayerControlContainer: UIView!
    @IBOutlet weak var btnSeekPrev: UIButton!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var btnSeekNext: UIButton!
    @IBOutlet weak var vPrev: UIView!
    @IBOutlet weak var vNext: UIView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lbTimePlayed: UILabel!
    @IBOutlet weak var lbTotalTime: UILabel!
    @IBOutlet weak var slProgress: UISlider!
    @IBOutlet weak var slVolume: CustomSlider!
    @IBOutlet weak var btnClose: UIButton!
    
    
    // MARK: - VARIABLES
    weak var delegate: FullScreenPlayerViewDelegate?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer!
    var videoURL: URL!
    var isPlaying: Bool {
        if player != nil && player?.rate != 0 {
            return true
        } else {
            return false
        }
    }
    var currentPlayerStatus: AVPlayerItem.Status = .unknown {
        didSet {
            delegate?.playerView(self, didUpdate: currentPlayerStatus)
        }
    }

    private var asset: AVAsset!
    private var playerItemContext = 0
    private var timeObserverToken: Any?
    // Keep the reference and use it to observe the loading status.
    private var playerItem: AVPlayerItem?
    private var hideControlTimer: Timer?
    private var isSeekInProgress = false {
        didSet {
            if isSeekInProgress {
                playerPlaybackState = .loading
            } else {
                playerPlaybackState = isPlaying ? .playing : .paused
            }
        }
    }
    private var chaseTime = CMTime.zero
    private var isZoomed: Bool {
        return self.playerLayer.videoGravity == .resizeAspectFill
    }
    private var playerPlaybackState = PlayerPlaybackState.paused {
        didSet {
            handlePlayerPlaybackState(playerPlaybackState)
        }
    }
    private weak var nonFullscreenContainer: UIView!
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        gesture.addTarget(self, action: #selector(handleTap))
        gesture.delaysTouchesBegan = false
        gesture.cancelsTouchesInView = false
        gesture.delegate = self
        gesture.require(toFail: seekBackDoubleTap)
        gesture.require(toFail: seekForwardDoubleTap)
        return gesture
    }()
    
    private lazy var seekBackDoubleTap: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 2
        gesture.delaysTouchesBegan = false
        gesture.cancelsTouchesInView = false
        gesture.delegate = self
        gesture.addTarget(self, action: #selector(handleSeekBack))
        return gesture
    }()
    
    private lazy var seekForwardDoubleTap: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 2
        gesture.delaysTouchesBegan = false
        gesture.cancelsTouchesInView = false
        gesture.delegate = self
        gesture.addTarget(self, action: #selector(handleSeekForward))
        return gesture
    }()
    
    private lazy var pinchGesture: UIPinchGestureRecognizer = {
        let gesture = UIPinchGestureRecognizer()
        gesture.scale = 1
        gesture.addTarget(self, action: #selector(handlePinch))
        return gesture
    }()
    
    private let replayIcon = UIImage(named: "icReplay")!
    private let pauseIcon = UIImage(named: "icPause")!
    private let playIcon = UIImage(named: "icPlay")!

    deinit {
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        removeBoundaryTimeObserver()
        cancelHideControlTimer()
    }
    
    // MARK: - OVERRIDES
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer?.frame = self.bounds
    }
    override func awakeFromNib() {
        setUpView()
    }
    
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
                self.currentPlayerStatus = .unknown
            }
            self.currentPlayerStatus = status
            self.loadingActivityIndicator.stopAnimating()
            // Switch over status value
            switch status {
            case .readyToPlay:
                print(".readyToPlay")
                player?.play()
                playerPlaybackState = .playing
            case .failed:
                print(".failed")
            case .unknown:
                print(".unknown")
            @unknown default:
                print("@unknown default")
            }
        }
        
        if keyPath == #keyPath(AVPlayerItem.duration) {
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                let secondsText = Int(seconds) % 60
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                lbTotalTime.text = "\(minutesText):\(secondsText)"
            }
        }
        
        if keyPath == "currentItem.loadedTimeRanges" {
            if let duration = player?.currentItem?.asset.duration {
                let seconds = CMTimeGetSeconds(duration)
                let secondsText = Int(seconds) % 60
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                lbTotalTime.text = "\(minutesText):\(secondsText)"
            }
        }
    }
    
    
    // MARK: - ACTIONS
    @IBAction func didTapOnButtonPlayPause(_ sender: UIButton) {
        if sender.tag == 0 {
            self.handlePlayPauseVideo()
        } else if sender.tag == 1 {
            self.replayVideo()
        }
    }
    
    @IBAction func didTapOnButtonDismiss(_ sender: Any) {
        self.delegate?.didTapOnButtonDismiss(in: self)
    }
    
    @IBAction func didTapOnButtonSeekNext(_ sender: UIButton) {
        if let currentTime = self.playerItem?.currentTime() {
            sender.doRotateAnimation(duration: 0.2, rotateAngle: CGFloat(Double.pi / 4))
            let currentSeconds = CMTimeGetSeconds(currentTime)
            let value = currentSeconds.advanced(by: 10)
            let newChaseTime = CMTime(value: Int64(value), timescale: 1)
            self.stopPlayingAndSeekSmoothlyToTime(newChaseTime: newChaseTime)
        }
    }
    
    @IBAction func didTapOnButtonSeekPrev(_ sender: UIButton) {
        if let currentTime = self.playerItem?.currentTime(), currentTime > CMTime(value: 10, timescale: 1) {
            sender.doRotateAnimation(rotateAngle: -CGFloat(Double.pi / 4))
            let currentSeconds = CMTimeGetSeconds(currentTime)
            let value = currentSeconds.advanced(by: -10)
            let newChaseTime = CMTime(value: Int64(value), timescale: 1)
            self.stopPlayingAndSeekSmoothlyToTime(newChaseTime: newChaseTime)
        }
    }
    
    @IBAction func progressSliderValueChanged(_ sender: UISlider) {
        cancelHideControlTimer()
        
        if let duration = playerItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(sender.value) * totalSeconds
            let newChaseTime = CMTime(value: Int64(value), timescale: 1)
            self.stopPlayingAndSeekSmoothlyToTime(newChaseTime: newChaseTime)
        }
        
        if sender.value == 0 {
            self.animatePlayPauseButtonImage(isPlaying: false)
            self.btnPlayPause.tag = 0
        } else if sender.value == 100 {
            self.btnPlayPause.tag = 1
            self.animatePlayPauseButtonImage(newImage: self.replayIcon)
        }
    }
    
    @IBAction func volumeSliderValueChanged(_ sender: UISlider) {
        cancelHideControlTimer()
        changeVolumeThumbImage(progress: sender.value)
        MPVolumeView.setVolume(sender.value)
        setUpHideControlTimer()
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        if vPlayerControlContainer.alpha == 0 || vPlayerControlContainer.isHidden == true {
            self.animatePlayerControlContainerView(isHidden: false)
            if self.isPlaying == true {
                self.setUpHideControlTimer()
            }
        } else {
            self.animatePlayerControlContainerView(isHidden: true)
        }
    }
    
    @objc private func handleSeekBack(_ sender: UITapGestureRecognizer) {
        if let currentTime = self.playerItem?.currentTime(), currentTime > CMTime(value: 10, timescale: 1) {
            btnSeekPrev.doRotateAnimation(rotateAngle: -CGFloat(Double.pi / 4))
            let currentSeconds = CMTimeGetSeconds(currentTime)
            let value = currentSeconds.advanced(by: -10)
            let newChaseTime = CMTime(value: Int64(value), timescale: 1)
            self.stopPlayingAndSeekSmoothlyToTime(newChaseTime: newChaseTime)
        }
    }
    
    @objc private func handleSeekForward(_ sender: UITapGestureRecognizer) {
        if let currentTime = self.playerItem?.currentTime() {
            btnSeekNext.doRotateAnimation(duration: 0.2, rotateAngle: CGFloat(Double.pi / 4))
            let currentSeconds = CMTimeGetSeconds(currentTime)
            let value = currentSeconds.advanced(by: 10)
            let newChaseTime = CMTime(value: Int64(value), timescale: 1)
            self.stopPlayingAndSeekSmoothlyToTime(newChaseTime: newChaseTime)
        }
    }
    
    @objc private func handlePinch(_ sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .began:
            if self.isZoomed {
                self.playerLayer.videoGravity = .resizeAspect
            } else {
                self.playerLayer.videoGravity = .resizeAspectFill
            }
        default:
            break
        }
    }
    
    // MARK: - PUBLIC FUNCTIONS
    static func makeInstance(with delegate: FullScreenPlayerViewDelegate) -> FullScreenPlayerView {
        let nib = UINib(nibName: "FullScreenPlayerView", bundle: nil)
        guard let fullScreenPlayerView = nib.instantiate(withOwner: nil, options: nil).first as? FullScreenPlayerView else {
            return FullScreenPlayerView()
        }
        fullScreenPlayerView.delegate = delegate
        return fullScreenPlayerView
    }
    
    public func play(with url: URL) {
        setUpAsset(with: url) { [weak self] (asset: AVAsset) in
            guard let self = self else { return }
            self.setUpPlayerItem(with: asset)
            self.videoURL = url
        }
    }
    
    public func pause() {
        player?.pause()
        playerPlaybackState = .paused
    }
    
    public func resume() {
        player?.play()
        playerPlaybackState = .playing
        setUpHideControlTimer()
    }
    
    public func replayVideo() {
        stopPlayingAndSeekSmoothlyToTime(newChaseTime: CMTime.zero)
    }
    
    public func showLoading() {
        self.loadingActivityIndicator.startAnimating()
    }
    
    public func hideLoading() {
        self.loadingActivityIndicator.stopAnimating()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setUpView() {
        playerPlaybackState = .loading
        
        self.addGestureRecognizer(tapGesture)
        self.addGestureRecognizer(seekBackDoubleTap)
        self.addGestureRecognizer(seekForwardDoubleTap)
        self.addGestureRecognizer(pinchGesture)
        
        self.vPlayerControlContainer.alpha = 0
        
        if let thumbImage = makeCircleImageWith(size: CGSize(width: 16, height: 16), backgroundColor: .red) {
            slProgress.setThumbImage(thumbImage, for: .normal)
            slProgress.setThumbImage(thumbImage, for: .selected)
        }
        
        if Device.isIpad {
            slVolume.isHidden = false
            slVolume.subviews.filter({ $0.isKind(of: UIImageView.self) }).forEach({ $0.backgroundColor = .black })
            slVolume.setThumbImage(UIImage(named: "icSpeaker0"), for: .normal)
            slVolume.setValue(AVAudioSession.sharedInstance().outputVolume, animated: false)
        }
    }
    
    private func setUpHideControlTimer() {
        cancelHideControlTimer()
        hideControlTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { [weak self] timer in
            guard let self = self else { return }
            self.animatePlayerControlContainerView(isHidden: true)
        })
    }
    
    private func cancelHideControlTimer() {
        if hideControlTimer != nil {
            hideControlTimer?.invalidate()
            hideControlTimer = nil
        }
    }
    
    private func changeVolumeThumbImage(progress: Float) {
        if progress == 0 && progress <= 0.25 {
            slVolume.setThumbImage(UIImage(named: "icSpeaker0"), for: .normal)
            slVolume.setThumbImage(UIImage(named: "icSpeaker0"), for: .highlighted)
        } else if progress > 0.25 && progress <= 0.5 {
            slVolume.setThumbImage(UIImage(named: "icSpeaker1"), for: .normal)
            slVolume.setThumbImage(UIImage(named: "icSpeaker1"), for: .highlighted)
        } else if progress > 0.5 && progress <= 0.75 {
            slVolume.setThumbImage(UIImage(named: "icSpeaker2"), for: .normal)
            slVolume.setThumbImage(UIImage(named: "icSpeaker2"), for: .highlighted)
        } else if progress > 0.75 {
            slVolume.setThumbImage(UIImage(named: "icSpeaker3"), for: .normal)
            slVolume.setThumbImage(UIImage(named: "icSpeaker3"), for: .highlighted)
        }
    }
    
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
        
        let duration = asset.duration
        let durationText = duration.durationFormatted()
            
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.player = AVPlayer(playerItem: self.playerItem!)
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.playerLayer.frame = self.vPlayerContainer.bounds
            self.playerLayer.videoGravity = .resizeAspect
            self.vPlayerContainer.layer.addSublayer(self.playerLayer)
            self.addPeriodicTimeObserver()
            self.lbTotalTime.text = durationText
        }
    }
    
    private func addPeriodicTimeObserver() {
        // Notify every half second
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)

        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
            guard let self = self else { return }
            
            // update player transport UI
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.lbTimePlayed.text = "\(time.durationFormatted())"
                self.btnSeekPrev.isEnabled = CMTimeGetSeconds(time) > 10

                if let duration = self.playerItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    let timePlayedSeconds = CMTimeGetSeconds(time)
                    self.slProgress.value = Float(timePlayedSeconds / durationSeconds)
                    
                    if CMTimeCompare(duration, time) == 0 {
                        if !self.isSeekInProgress {
                            self.playerPlaybackState = .finished
                        }
                    } else {
                        self.btnPlayPause.tag = 0
                    }
                }
                
            }
            self.delegate?.playerView(self, didUpdate: time.seconds)
        }
    }

    private func removeBoundaryTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    private func handlePlayerPlaybackState(_ state: PlayerPlaybackState) {
        switch state {
        case .loading:
            self.cancelHideControlTimer()
            self.btnSeekNext.isEnabled = true
            self.btnPlayPause.tag = 0
            self.loadingActivityIndicator.startAnimating()
            self.btnPlayPause.isHidden = true
        case .playing:
            self.btnSeekNext.isEnabled = true
            self.btnPlayPause.tag = 0
            self.btnPlayPause.isHidden = false
            self.loadingActivityIndicator.stopAnimating()
            self.animatePlayPauseButtonImage(newImage: pauseIcon)
        case .paused:
            self.btnSeekNext.isEnabled = true
            self.btnPlayPause.tag = 0
            self.btnPlayPause.isHidden = false
            self.loadingActivityIndicator.stopAnimating()
            self.animatePlayPauseButtonImage(newImage: playIcon)
        case .finished:
            if self.vPlayerControlContainer.isHidden || self.vPlayerControlContainer.alpha == 0 {
                self.animatePlayerControlContainerView(isHidden: false)
            }
            self.btnSeekNext.isEnabled = false
            self.btnPlayPause.tag = 1
            self.btnPlayPause.isHidden = false
            self.loadingActivityIndicator.stopAnimating()
            self.animatePlayPauseButtonImage(newImage: replayIcon)
        }
    }
    
    private func handlePlayPauseVideo() {
        if self.isPlaying {
            self.pause()
            self.cancelHideControlTimer()
        } else {
            self.resume()
            self.setUpHideControlTimer()
        }
    }
    
    private func stopPlayingAndSeekSmoothlyToTime(newChaseTime: CMTime) {
        player?.pause()
        
        if CMTimeCompare(newChaseTime, chaseTime) != 0 {
            chaseTime = newChaseTime
            if !isSeekInProgress {
                trySeekToChaseTime()
            }
        }
    }
    
    private func trySeekToChaseTime() {
        if currentPlayerStatus == .unknown {
            // wait until item becomes ready (KVO player.currentItem.status)
        } else if currentPlayerStatus == .readyToPlay {
            actuallySeekToTime()
        }
    }
    
    private func actuallySeekToTime() {
        isSeekInProgress = true
        let seekTimeInProgress = chaseTime
        player?.seek(to: seekTimeInProgress, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero, completionHandler: { [weak self] (isFinished) in
            guard let self = self else { return }
            if CMTimeCompare(seekTimeInProgress, self.chaseTime) == 0 {
                self.resume()
                self.setUpHideControlTimer()
                self.isSeekInProgress = false
            } else {
                self.trySeekToChaseTime()
            }
        })
    }
}

// MARK: - EXTENSIONS
extension FullScreenPlayerView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchView = touch.view
        if touchView == btnPlayPause || touchView == btnSeekNext || touchView == btnSeekPrev || touchView == btnClose {
            return false
        }
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let frame = self.bounds
        if gestureRecognizer == seekForwardDoubleTap {
            let seekForwardRect = CGRect(x: frame.size.width - frame.size.width / 3,
                                         y: frame.origin.y,
                                         width: frame.size.width / 3,
                                         height: frame.size.height)
            return seekForwardRect.contains(gestureRecognizer.location(in: self))
        }
        
        if gestureRecognizer == seekBackDoubleTap {
            let seekBackdRect = CGRect(x: 0,
                                         y: frame.origin.y,
                                         width: frame.size.width / 3,
                                         height: frame.size.height)
            return seekBackdRect.contains(gestureRecognizer.location(in: self))
        }
        
        return true
    }
    
    
}

extension FullScreenPlayerView {
    // Animation functions
    private func animatePlayPauseButtonImage(isPlaying: Bool) {
        let image = isPlaying ? pauseIcon : playIcon
        UIView.transition(with: btnPlayPause, duration: 0.3, options: .transitionFlipFromRight, animations: { [weak self] in
            guard let self = self else { return }
            self.btnPlayPause.setImage(image, for: .normal)
        }) { (finished) in

        }
    }
    
    private func animatePlayerControlContainerView(isHidden: Bool) {
        if !isHidden {
            self.vPlayerControlContainer.isHidden = false
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            guard let self = self else { return }
            self.vPlayerControlContainer.alpha = isHidden ? 0 : 1
        }) { [weak self] (finished) in
            guard let self = self else { return }
            if finished && isHidden == true {
                self.vPlayerControlContainer.isHidden = true
            }
        }
    }
    
    private func animatePlayPauseButtonImage(newImage: UIImage) {
        UIView.transition(with: btnPlayPause, duration: 0.3, options: .transitionFlipFromRight, animations: { [weak self] in
            guard let self = self else { return }
            self.btnPlayPause.setImage(newImage, for: .normal)
        }) { (finished) in

        }
    }
    
    fileprivate func makeCircleImageWith(size: CGSize, backgroundColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(backgroundColor.cgColor)
        context?.setStrokeColor(UIColor.clear.cgColor)
        let bounds = CGRect(origin: .zero, size: size)
        context?.addEllipse(in: bounds)
        context?.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

fileprivate extension CMTime {
    func durationFormatted() -> String {
        let seconds = CMTimeGetSeconds(self)
        let secondsText = String(format: "%02d", Int(seconds) % 60)
        let minutesText = String(format: "%02d", Int(seconds) / 60)
        return "\(minutesText):\(secondsText)"
    }
}
