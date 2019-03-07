//
//  VGPlayerView.swift
//  VGPlayer
//
//  Created by Vein on 2017/6/5.
//  Copyright © 2017年 Vein. All rights reserved.
//

import UIKit
import MediaPlayer
import SnapKit

public protocol VGPlayerViewDelegate: class {
    
    /// Fullscreen
    ///
    /// - Parameters:
    ///   - playerView: player view
    ///   - fullscreen: Whether full screen
    func vgPlayerView(_ playerView: VGPlayerView, willFullscreen isFullscreen: Bool)
    
    /// Close play view
    ///
    /// - Parameter playerView: player view
    func vgPlayerView(didTappedClose playerView: VGPlayerView)
    
    // Play rate button
    func vgPlayerView(didTappedAudioVideoSwicthBtn playerView: VGPlayerView)
    
    //On Previous Button
    func vgPlayerView(didTappedonPreviousBtn playerView: VGPlayerView)
    
    //On Next Button
    func vgPlayerView(didTappedonNextBtn playerView: VGPlayerView)
    
    /// Displaye control
    /// - Parameter playerView: playerView
    func vgPlayerView(didDisplayControl playerView: VGPlayerView)
    
}

// MARK: - delegate methods optional
public extension VGPlayerViewDelegate {
    
    func vgPlayerView(_ playerView: VGPlayerView, willFullscreen fullscreen: Bool){}
    
    func vgPlayerView(didTappedClose playerView: VGPlayerView) {}
    
    func vgPlayerView(didDisplayControl playerView: VGPlayerView) {}
    
    func vgPlayerView(didTappedAudioVideoSwicthBtn playerView: VGPlayerView) {}
    
    func vgPlayerView(didTappedonPreviousBtn playerView: VGPlayerView) {}
    
    func vgPlayerView(didTappedonNextBtn playerView: VGPlayerView) {}
}

public enum VGPlayerViewPanGestureDirection: Int {
    case vertical
    case horizontal
}


open class VGPlayerView: UIView {
    
    weak open var vgPlayer : VGPlayer?
    open var controlViewDuration : TimeInterval = 5.0  /// default 5.0
    open fileprivate(set) var playerLayer : AVPlayerLayer?
    open fileprivate(set) var isFullScreen : Bool = false
    open fileprivate(set) var isTimeSliding : Bool = false
    open fileprivate(set) var isDisplayControl : Bool = true {
        didSet {
            if isDisplayControl != oldValue {
                delegate?.vgPlayerView(didDisplayControl: self)
            }
        }
    }
    open weak var delegate : VGPlayerViewDelegate?
    // top view
    open var topView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        return view
    }()
    open var titleLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        return label
    }()
    open var closeButton : UIButton = {
        
        let button = UIButton(type: UIButtonType.custom)
        return button
    }()
    
    open var audioVideoSwicthBtn : UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        return button
    }()
    
    open var forwordButton : UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        return button
    }()
    
    open var backwordButton : UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        return button
    }()
    
    open var nextButton : UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        return button
    }()
    
    open var previousButton : UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        return button
    }()
    
    // bottom view
    open var bottomView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        return view
    }()
    open var timeSlider = VGPlayerSlider ()
    open var loadingIndicator = VGPlayerLoadingIndicator()
    open var loadngIndictrLabel : UILabel = UILabel()
    open var fullscreenButton : UIButton = UIButton(type: UIButtonType.custom)
    open var timeLabel : UILabel = UILabel()
    open var playButtion : UIButton = UIButton(type: UIButtonType.custom)
    open var volumeSlider : UISlider!
    open var replayButton : UIButton = UIButton(type: UIButtonType.custom)
    open fileprivate(set) var panGestureDirection : VGPlayerViewPanGestureDirection = .horizontal
    fileprivate var isVolume : Bool = false
    fileprivate var sliderSeekTimeValue : TimeInterval = .nan
    fileprivate var timer : Timer = {
        let time = Timer()
        return time
    }()
    
    fileprivate weak var parentView : UIView?
    fileprivate var viewFrame = CGRect()
    // GestureRecognizer
    open var singleTapGesture = UITapGestureRecognizer()
    open var doubleTapGesture = UITapGestureRecognizer()
    open var panGesture = UIPanGestureRecognizer()
    
    //MARK:- life cycle
    public override init(frame: CGRect) {
        self.playerLayer = AVPlayerLayer(player: nil)
        super.init(frame: frame)
        addDeviceOrientationNotifications()
        addGestureRecognizer()
        configurationVolumeSlider()
        configurationUI()
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer.invalidate()
        playerLayer?.removeFromSuperlayer()
        NotificationCenter.default.removeObserver(self)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateDisplayerView(frame: bounds)
    }
    
    open func setvgPlayer(vgPlayer: VGPlayer) {
        self.vgPlayer = vgPlayer
    }
    
    open func reloadPlayerLayer() {
        playerLayer = AVPlayerLayer(player: self.vgPlayer?.player)
        layer.insertSublayer(self.playerLayer!, at: 0)
        updateDisplayerView(frame: self.bounds)
        //timeSlider.isUserInteractionEnabled = vgPlayer?.mediaFormat != .m3u8
        reloadGravity()
    }
    
    
    /// play state did change
    ///
    /// - Parameter state: state
    open func playStateDidChange(_ state: VGPlayerState) {
        playButtion.isSelected = state == .playing
        replayButton.isHidden = !(state == .playFinished) //true  // !(state == .playFinished)
        previousButton.isHidden = true
        nextButton.isHidden = true
        if state == .playing || state == .playFinished {
            setupTimer()
        }
        
        if state == .playFinished {
            loadingIndicator.isHidden = true
            loadngIndictrLabel.isHidden = true
            playButtion.isHidden = true
        }
    }
    
    /// buffer state change
    ///
    /// - Parameter state: buffer state
    open func bufferStateDidChange(_ state: VGPlayerBufferstate) {
        if state == .buffering {
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
            playButtion.isHidden = true
            loadngIndictrLabel.isHidden = false
        } else {
            loadingIndicator.isHidden = true
            loadingIndicator.stopAnimating()
            playButtion.isHidden = false
            loadngIndictrLabel.isHidden = true
        }
        var current = formatSecondsToString((vgPlayer?.currentDuration)!)
        if (vgPlayer?.totalDuration.isNaN)! {
            current = "00:00"
        }
        if state == .readyToPlay && !isTimeSliding {
            timeLabel.text = "\(current + " / " +  (formatSecondsToString((vgPlayer?.totalDuration)!)))"
        }
        loadngIndictrLabel.text = "video buffering..."
        loadngIndictrLabel.font = UIFont.systemFont(ofSize: 20.0)
    }
    
    /// buffer duration
    ///
    /// - Parameters:
    ///   - bufferedDuration: buffer duration
    ///   - totalDuration: total duratiom
    open func bufferedDidChange(_ bufferedDuration: TimeInterval, totalDuration: TimeInterval) {
        timeSlider.setProgress(Float(bufferedDuration / totalDuration), animated: true)
    }
    
    /// player diration
    ///
    /// - Parameters:
    ///   - currentDuration: current duration
    ///   - totalDuration: total duration
    open func playerDurationDidChange(_ currentDuration: TimeInterval, totalDuration: TimeInterval) {
        var current = formatSecondsToString(currentDuration)
        if totalDuration.isNaN {
            current = "00:00"
        }
        if !isTimeSliding {
            timeLabel.text = "\(current + " / " +  (formatSecondsToString(totalDuration)))"
            timeSlider.value = Float(currentDuration / totalDuration)
        }
    }
    
    open func configurationUI() {
        //backgroundColor = UIColor(patternImage:#imageLiteral(resourceName: "placeholder _image"))
        //#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        configurationTopView()
        configurationBottomView()
        configurationReplayButton()
        setupViewAutoLayout()
    }
    
    open func reloadPlayerView() {
        playerLayer = AVPlayerLayer(player: nil)
        timeSlider.value = Float(0)
        timeSlider.setProgress(0, animated: false)
        replayButton.isHidden = true
        isTimeSliding = false
        previousButton.isHidden = true
        nextButton.isHidden = true
        loadingIndicator.isHidden = false
        loadngIndictrLabel.isHidden = false
        loadingIndicator.startAnimating()
        timeLabel.text = "--:-- / --:--"
        loadngIndictrLabel.text = "video buffering..."
        loadngIndictrLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        loadngIndictrLabel.textAlignment = .center
        
        reloadPlayerLayer()
    }
    
    /// control view display
    /// - Parameter display: is display
    open func displayControlView(_ isDisplay:Bool) {
        if isDisplay {
            displayControlAnimation()
            if replayButton.isHidden {
                
            }else {
                self.playButtion.isHidden = true
            }
        } else {
            hiddenControlAnimation()
        }
    }
}

//MARK: - public
extension VGPlayerView {
    
    open func updateDisplayerView(frame: CGRect) {
        playerLayer?.frame = frame
        //self.backgroundColor = UIColor.lightGray //NewChange
    }
    
    open func reloadGravity() {
        if vgPlayer != nil {
            switch vgPlayer!.gravityMode {
            case .resize:
                playerLayer?.videoGravity = .resize
            case .resizeAspect:
                playerLayer?.videoGravity = .resizeAspect
            case .resizeAspectFill:
                playerLayer?.videoGravity = .resizeAspectFill
            }
        }
    }
    
    open func enterFullscreen() {
        loadngIndictrLabel.font = UIFont.systemFont(ofSize: 28.0)
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        if statusBarOrientation == .portrait{
            parentView = (self.superview)!
            viewFrame = self.frame
        }
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        UIApplication.shared.statusBarOrientation = .landscapeRight
        UIApplication.shared.setStatusBarHidden(true, with: .fade)//vishal
        
    }
    
    open func exitFullscreen() {
        loadngIndictrLabel.font = UIFont.systemFont(ofSize: 20.0)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIApplication.shared.statusBarOrientation = .portrait
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
    }
    
    /// play failed
    ///
    /// - Parameter error: error
    open func playFailed(_ error: VGPlayerError) {
        // error
    }
    
    public func formatSecondsToString(_ secounds: TimeInterval) -> String {
        if secounds.isNaN{
            return "00:00"
        }
        let interval = Int(secounds)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / (60 * 60)) % 60

        if hours == 00{
            return String(format: "%02d:%02d", minutes, seconds)
        }else {
            return String(format: "%02d:%02d:%02d", hours , minutes, seconds)
        }
        
    }
}

// MARK: - private
extension VGPlayerView {
    
    internal func play() {
        playButtion.isSelected = true
    }
    
    internal func pause() {
        playButtion.isSelected = false
    }
    
    internal func displayControlAnimation() {
        bottomView.isHidden = false
        topView.isHidden = false
        isDisplayControl = true
        previousButton.isHidden = true
        nextButton.isHidden = true
        if loadingIndicator.isAnimating {
            playButtion.isHidden = true
            loadngIndictrLabel.isHidden = false
        }else {
            playButtion.isHidden = false
            loadngIndictrLabel.isHidden = true
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.alpha = 1
            self.topView.alpha = 1
            self.playButtion.alpha = 1
        }) { (completion) in
            self.setupTimer()
        }
    }
    internal func hiddenControlAnimation() {
        timer.invalidate()
        isDisplayControl = false
        previousButton.isHidden = true
        nextButton.isHidden = true
        if loadingIndicator.isAnimating {
            playButtion.isHidden = true
            loadngIndictrLabel.isHidden = false
        }else {
            playButtion.isHidden = false
            loadngIndictrLabel.isHidden = true
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.alpha = 0
            self.topView.alpha = 0
            self.playButtion.alpha = 0
        }) { (completion) in
            self.bottomView.isHidden = true
            self.topView.isHidden = true
            self.playButtion.isHidden = true
        }
    }
    internal func setupTimer() {
        timer.invalidate()
        timer = Timer.vgPlayer_scheduledTimerWithTimeInterval(self.controlViewDuration, block: {  [weak self]  in
            guard let strongSelf = self else { return }
            strongSelf.displayControlView(false)
            }, repeats: false)
    }
    internal func addDeviceOrientationNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationWillChange(_:)), name: .UIApplicationWillChangeStatusBarOrientation, object: nil)
    }
    
    internal func configurationVolumeSlider() {
        let volumeView = MPVolumeView()
        if let view = volumeView.subviews.first as? UISlider {
            volumeSlider = view
        }
    }
}


// MARK: - GestureRecognizer
extension VGPlayerView {
    
    internal func addGestureRecognizer() {
        singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSingleTapGesture(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1
        singleTapGesture.delegate = self
        addGestureRecognizer(singleTapGesture)
        
        doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onDoubleTapGesture(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.numberOfTouchesRequired = 1
        doubleTapGesture.delegate = self
        addGestureRecognizer(doubleTapGesture)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanGesture(_:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension VGPlayerView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view as? VGPlayerView != nil) {
            return true
        }
        return false
    }
}

// MARK: - Event
extension VGPlayerView {
    
    @objc internal func timeSliderValueChanged(_ sender: VGPlayerSlider) {
        isTimeSliding = true
        if let duration = vgPlayer?.totalDuration {
            let currentTime = Double(sender.value) * duration
            timeLabel.text = "\(formatSecondsToString(currentTime) + " / " +  (formatSecondsToString(duration)))"
        }
    }
    
    @objc internal func timeSliderTouchDown(_ sender: VGPlayerSlider) {
        isTimeSliding = true
        timer.invalidate()
    }
    
    @objc internal func timeSliderTouchUpInside(_ sender: VGPlayerSlider) {
        isTimeSliding = true
        
        if let duration = vgPlayer?.totalDuration {
            let currentTime = Double(sender.value) * duration
            vgPlayer?.seekTime(currentTime, completion: { [weak self] (finished) in
                guard let strongSelf = self else { return }
                if finished {
                    strongSelf.isTimeSliding = false
                    strongSelf.setupTimer()
                }
            })
            timeLabel.text = "\(formatSecondsToString(currentTime) + " / " +  (formatSecondsToString(duration)))"
        }
    }
    
    @objc internal func onPlayerButton(_ sender: UIButton) {
        if !sender.isSelected {
            self.playButtion.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            vgPlayer?.play()
        } else {
            self.playButtion.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            vgPlayer?.pause()
        }
    }
    
    @objc internal func onFullscreen(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isFullScreen = sender.isSelected
        if isFullScreen {
            enterFullscreen()
        } else {
            exitFullscreen()
        }
    }
    /// Single Tap Event
    ///
    /// - Parameter gesture: Single Tap Gesture
    @objc open func onSingleTapGesture(_ gesture: UITapGestureRecognizer) {
        isDisplayControl = !isDisplayControl
        displayControlView(isDisplayControl)
    }
    
    /// Double Tap Event
    ///
    /// - Parameter gesture: Double Tap Gesture
    @objc open func onDoubleTapGesture(_ gesture: UITapGestureRecognizer) {
        
        guard vgPlayer == nil else {
            switch vgPlayer!.state {
            case .playFinished:
                break
            case .playing:
                vgPlayer?.pause()
            case .paused:
                vgPlayer?.play()
            case .none:
                break
            case .error:
                break
            }
            return
        }
    }
    
    /// Pan Event
    /// - Parameter gesture: Pan Gesture
    @objc open func onPanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let location = gesture.location(in: self)
        let velocity = gesture.velocity(in: self)
        switch gesture.state {
        case .began:
            let x = fabs(translation.x)
            let y = fabs(translation.y)
            if x < y {
                panGestureDirection = .vertical
                if location.x > bounds.width / 2 {
                    isVolume = true
                } else {
                    isVolume = false
                }
            } else if x > y{
                guard vgPlayer?.mediaFormat == .m3u8 else {
                    panGestureDirection = .horizontal
                    return
                }
            }
        case .changed:
            switch panGestureDirection {
            case .horizontal:
                if vgPlayer?.currentDuration == 0 { break }
                sliderSeekTimeValue = panGestureHorizontal(velocity.x)
            case .vertical:
                panGestureVertical(velocity.y)
            }
        case .ended:
            switch panGestureDirection{
            case .horizontal:
                if sliderSeekTimeValue.isNaN { return }
                self.vgPlayer?.seekTime(sliderSeekTimeValue, completion: { [weak self] (finished) in
                    guard let strongSelf = self else { return }
                    if finished {
                        
                        strongSelf.isTimeSliding = false
                        strongSelf.setupTimer()
                    }
                })
            case .vertical:
                isVolume = false
            }
            
        default:
            break
        }
    }
    
    internal func panGestureHorizontal(_ velocityX: CGFloat) -> TimeInterval {
        displayControlView(true)
        isTimeSliding = true
        timer.invalidate()
        let value = timeSlider.value
        if let _ = vgPlayer?.currentDuration ,let totalDuration = vgPlayer?.totalDuration {
            let sliderValue = (TimeInterval(value) *  totalDuration) + TimeInterval(velocityX) / 100.0 * (TimeInterval(totalDuration) / 400)
            timeSlider.setValue(Float(sliderValue/totalDuration), animated: true)
            return sliderValue
        } else {
            return TimeInterval.nan
        }
        
    }
    
    internal func panGestureVertical(_ velocityY: CGFloat) {
        isVolume ? (volumeSlider.value -= Float(velocityY / 10000)) : (UIScreen.main.brightness -= velocityY / 10000)
    }
    
    @objc internal func onCloseView(_ sender: UIButton) {
        delegate?.vgPlayerView(didTappedClose: self)
    }
    
    @objc internal func onAudioVideoSwicthBtn(_ sender: UIButton) {
        delegate?.vgPlayerView(didTappedAudioVideoSwicthBtn: self)
    }
    
    @objc internal func onReplay(_ sender: UIButton) {
        vgPlayer?.replaceVideo((vgPlayer?.contentURL)!)
        vgPlayer?.play()
    }
    
    @objc internal func onForword(_ sender: UIButton) {
        
        if timeLabel.text != "--:--/--:--" {
            let currentTime =  vgPlayer?.currentDuration
            print("onForword + 15 ",(currentTime! + 15))
            vgPlayer?.seekTime(currentTime! + 15)
            if vgPlayer!.state == .playing {
                vgPlayer?.play()
            }else {
                vgPlayer?.pause()
            }
        }
    }
    
    @objc internal func onBackword(_ sender: UIButton) {
        if timeLabel.text != "--:--/--:--" {
            let currentTime =  vgPlayer?.currentDuration
            print("onBackword + 15 ",(currentTime! - 15))
            vgPlayer?.seekTime((currentTime! - 15))
        }
    }
    
    @objc internal func onPrevious(_ sender: UIButton) {
        delegate?.vgPlayerView(didTappedonPreviousBtn: self)
        print("Previous click")
    }
    
    @objc internal func onNext(_ sender: UIButton) {
        delegate?.vgPlayerView(didTappedonNextBtn: self)
        print("Next click")
    }
    
    @objc internal func deviceOrientationWillChange(_ sender: Notification) {
        let orientation = UIDevice.current.orientation
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        if statusBarOrientation == .portrait{
            if superview != nil {
                parentView = (superview)!
                viewFrame = frame
            }
        }
        switch orientation {
        case .unknown:
            break
        case .faceDown:
            break
        case .faceUp:
            break
        case .landscapeLeft:
            onDeviceOrientation(true, orientation: .landscapeLeft)
        case .landscapeRight:
            onDeviceOrientation(true, orientation: .landscapeRight)
        case .portrait:
            onDeviceOrientation(false, orientation: .portrait)
        case .portraitUpsideDown:
            onDeviceOrientation(false, orientation: .portraitUpsideDown)
        }
    }
    internal func onDeviceOrientation(_ fullScreen: Bool, orientation: UIInterfaceOrientation) {
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        if orientation == statusBarOrientation {
            if orientation == .landscapeLeft || orientation == .landscapeLeft {
                if UserDefaults.standard.string(forKey: "VideoAudioRoateFlag") == "1" {                    
                    let rectInWindow = convert(bounds, to: UIApplication.shared.keyWindow)
                    removeFromSuperview()
                    frame = rectInWindow
                    UIApplication.shared.keyWindow?.addSubview(self)
                    self.snp.remakeConstraints({ [weak self] (make) in
                        guard let strongSelf = self else { return }
                        make.width.equalTo(strongSelf.superview!.bounds.width)
                        make.height.equalTo(strongSelf.superview!.bounds.height)
                    })
                }
            }
        } else {
            if orientation == .landscapeLeft || orientation == .landscapeRight {
                if UserDefaults.standard.string(forKey: "VideoAudioRoateFlag") == "1" {
                    let rectInWindow = convert(bounds, to: UIApplication.shared.keyWindow)
                    removeFromSuperview()
                    frame = rectInWindow
                    UIApplication.shared.keyWindow?.addSubview(self)
                    self.snp.remakeConstraints({ [weak self] (make) in
                        guard let strongSelf = self else { return }
                        make.width.equalTo(strongSelf.superview!.bounds.height)
                        make.height.equalTo(strongSelf.superview!.bounds.width)
                    })
                }
            } else if orientation == .portrait{
                if parentView == nil { return }
                removeFromSuperview()
                parentView!.addSubview(self)
                let frame = parentView!.convert(viewFrame, to: UIApplication.shared.keyWindow)
                self.snp.remakeConstraints({ (make) in
                    make.centerX.equalTo(viewFrame.midX)
                    make.centerY.equalTo(viewFrame.midY)
                    make.width.equalTo(frame.width)
                    make.height.equalTo(frame.height)
                })
                viewFrame = CGRect()
                parentView = nil
            }
        }
        isFullScreen = fullScreen
        fullscreenButton.isSelected = fullScreen
        delegate?.vgPlayerView(self, willFullscreen: isFullScreen)
        
    }
}

//MARK: - UI autoLayout
extension VGPlayerView {
    
    internal func configurationReplayButton() {
        addSubview(self.replayButton)
        let replayImage = VGPlayerUtils.imageResource("VGPlayer_ic_replay")
        replayButton.setImage(VGPlayerUtils.imageSize(image: replayImage!, scaledToSize: CGSize(width: 30, height: 30)), for: .normal)
        replayButton.addTarget(self, action: #selector(onReplay(_:)), for: .touchUpInside)
        replayButton.isHidden = true
    }
    
    internal func configurationTopView() {
        addSubview(topView)
        titleLabel.text = "this is a title."
        topView.addSubview(titleLabel)
        let closeImage = VGPlayerUtils.imageResource("VGPlayer_ic_nav_back")
        closeButton.setImage(VGPlayerUtils.imageSize(image: closeImage!, scaledToSize: CGSize(width: 15, height: 20)), for: .normal)
        closeButton.addTarget(self, action: #selector(onCloseView(_:)), for: .touchUpInside)
        topView.addSubview(closeButton)
        
        audioVideoSwicthBtn.setImage(VGPlayerUtils.imageSize(image:#imageLiteral(resourceName: "Music"), scaledToSize: CGSize(width: 70, height: 50)), for: .normal)
        audioVideoSwicthBtn.addTarget(self, action: #selector(onAudioVideoSwicthBtn(_:)), for: .touchUpInside)
        topView.addSubview(audioVideoSwicthBtn)
        
        
        backwordButton.setImage(VGPlayerUtils.imageSize(image:#imageLiteral(resourceName: "backward"), scaledToSize: CGSize(width: 35, height: 35)), for: .normal)
        backwordButton.addTarget(self, action: #selector(onBackword(_:)), for: .touchUpInside)
        topView.addSubview(backwordButton)
        
        forwordButton.setImage(VGPlayerUtils.imageSize(image:#imageLiteral(resourceName: "fastForward"), scaledToSize: CGSize(width: 35, height: 35)), for: .normal)
        forwordButton.addTarget(self, action: #selector(onForword(_:)), for: .touchUpInside)
        topView.addSubview(forwordButton)
        
        let previousImage = UIImage(named:"previous") //
        previousButton.setImage(VGPlayerUtils.imageSize(image:previousImage!, scaledToSize: CGSize(width: 35, height: 35)), for: .normal)
        previousButton.addTarget(self, action: #selector(onPrevious(_:)), for: .touchUpInside)
        let tintImg = previousImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        previousButton.setImage(tintImg, for: .normal)
        previousButton.tintColor = UIColor.clear
        topView.addSubview(previousButton)
        
        let nexImage = UIImage(named:"next")
        nextButton.setImage(VGPlayerUtils.imageSize(image:nexImage!, scaledToSize: CGSize(width: 35, height: 35)), for: .normal)
        nextButton.addTarget(self, action: #selector(onNext(_:)), for: .touchUpInside)
        let tintImg1 = previousImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        nextButton.setImage(tintImg1, for: .normal)
        nextButton.tintColor = UIColor.clear
        topView.addSubview(nextButton)
        
    }
    
    internal func configurationBottomView() {
        addSubview(bottomView)
        timeSlider.addTarget(self, action: #selector(timeSliderValueChanged(_:)),
                             for: .valueChanged)
        timeSlider.addTarget(self, action: #selector(timeSliderTouchUpInside(_:)), for: .touchUpInside)
        timeSlider.addTarget(self, action: #selector(timeSliderTouchDown(_:)), for: .touchDown)
        loadingIndicator.lineWidth = 1.0
        loadingIndicator.isHidden = false
        loadngIndictrLabel.isHidden = false
        loadingIndicator.startAnimating()
        addSubview(loadingIndicator)
        addSubview(loadngIndictrLabel)
        bottomView.addSubview(timeSlider)
        
        let playImage = UIImage(named:"play")
        playButtion.setImage(VGPlayerUtils.imageSize(image:playImage!, scaledToSize: CGSize(width: 30, height: 30)), for: .normal)
        
        let pauseImage = UIImage(named:"pause")
        playButtion.setImage(VGPlayerUtils.imageSize(image:pauseImage!, scaledToSize: CGSize(width: 30, height: 30)), for: .selected)
        
        playButtion.addTarget(self, action: #selector(onPlayerButton(_:)), for: .touchUpInside)
        self.addSubview(playButtion)
        
        timeLabel.textAlignment = .center
        timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        timeLabel.font = UIFont.systemFont(ofSize:12.0)
        timeLabel.text = "--:-- / --:--"
        bottomView.addSubview(timeLabel)
        
        let enlargeImage = VGPlayerUtils.imageResource("VGPlayer_ic_fullscreen")
        let narrowImage = VGPlayerUtils.imageResource("VGPlayer_ic_fullscreen_exit")
        fullscreenButton.setImage(VGPlayerUtils.imageSize(image: enlargeImage!, scaledToSize: CGSize(width: 25, height: 25)), for: .normal)
        fullscreenButton.setImage(VGPlayerUtils.imageSize(image: narrowImage!, scaledToSize: CGSize(width: 25, height: 25)), for: .selected)
        fullscreenButton.addTarget(self, action: #selector(onFullscreen(_:)), for: .touchUpInside)
        bottomView.addSubview(fullscreenButton)
        
        if loadingIndicator.isAnimating {
            playButtion.isHidden = true
            loadngIndictrLabel.isHidden = false
        }else {
            playButtion.isHidden  = false
            loadngIndictrLabel.isHidden = true
        }
    }
    
    internal func setupViewAutoLayout() {
        replayButton.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.center.equalTo(strongSelf)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        // top view layout
        topView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.left.equalTo(strongSelf)
            make.right.equalTo(strongSelf)
            make.top.equalTo(strongSelf)
            if UserDefaults.standard.string(forKey: "ArticleVideoFlag") == "1" {
                make.height.equalTo(220)
            }else {
                make.height.equalTo(430)
            }
        }
        //close
        closeButton.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.left.equalTo(strongSelf.topView).offset(7)
            make.top.equalTo(strongSelf.topView).offset(10)
            make.height.equalTo(40)
            make.width.equalTo(35)
        }
        if UserDefaults.standard.string(forKey: "ArticleVideoFlag") == "3"{
            audioVideoSwicthBtn.snp.makeConstraints { [weak self] (make) in
                guard let strongSelf = self else { return }
                make.left.equalTo(strongSelf.topView).offset(0)
                make.top.equalTo(closeButton).offset(-5)
                make.height.equalTo(50)
                make.width.equalTo(70)
            }
        }else if UserDefaults.standard.string(forKey: "ArticleVideoFlag") == "1"{
            audioVideoSwicthBtn.snp.makeConstraints { [weak self] (make) in
                guard let strongSelf = self else { return }
                make.left.equalTo(strongSelf.topView).offset(-15)
                make.top.equalTo(closeButton).offset(-10)
                make.height.equalTo(50)
                make.width.equalTo(70)
            }
        }else {
            audioVideoSwicthBtn.snp.makeConstraints { [weak self] (make) in
                guard let strongSelf = self else { return }
                make.left.equalTo(strongSelf.topView).offset(30)
                make.top.equalTo(closeButton).offset(-5)
                make.height.equalTo(50)
                make.width.equalTo(70)
            }
        }
        
        // bottom view layout
        bottomView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.left.equalTo(strongSelf)
            make.right.equalTo(strongSelf)
            make.bottom.equalTo(strongSelf)
            make.height.equalTo(52)
        }
       
        //FullScreen Button
        fullscreenButton.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.centerY.equalTo(strongSelf.timeLabel)
            make.right.equalTo(strongSelf.bottomView).offset(-10)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        //Time label
        timeLabel.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.right.equalTo(strongSelf.fullscreenButton.snp.left).offset(-10)
            make.centerY.equalTo(strongSelf.bottomView)
            make.height.equalTo(30)
        }
        
        //Forword Button
        previousButton.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.top.equalTo(strongSelf.replayButton)
            make.left.equalTo(strongSelf.topView.frame.origin.x).offset(15)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        
        //Backword Button
        nextButton.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.top.equalTo(strongSelf.replayButton)
            make.left.equalTo(strongSelf.timeLabel.snp.right)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        
        playButtion.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.center.equalTo(strongSelf)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        //Forword Button
        backwordButton.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            //make.top.equalTo(strongSelf.replayButton).offset(-10)
            //make.left.equalTo(strongSelf.previousButton.snp.right).offset(27)
            make.center.equalTo(strongSelf)
            make.centerX.equalTo(strongSelf).offset(-89)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        
        //Backword Button
        forwordButton.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            //make.top.equalTo(strongSelf.replayButton)
            make.centerY.equalTo(strongSelf.playButtion)
            make.left.equalTo(strongSelf.playButtion.snp.right).offset(59)
            //make.left.equalTo(strongSelf.nextButton.snp.left).offset(-55)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        
        titleLabel.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.left.equalTo(strongSelf.closeButton.snp.right).offset(20)
            make.centerY.equalTo(strongSelf.closeButton.snp.centerY)
        }
        
        timeSlider.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.centerY.equalTo(strongSelf.timeLabel)
            make.right.equalTo(strongSelf.timeLabel.snp.left).offset(-10)
            make.left.equalTo(20)
            make.height.equalTo(25)
        }
        
        loadingIndicator.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.center.equalTo(strongSelf)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        loadngIndictrLabel.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.center.equalTo(strongSelf)
            make.centerY.equalTo(loadingIndicator.snp.bottom).offset(16)
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
    }
}

