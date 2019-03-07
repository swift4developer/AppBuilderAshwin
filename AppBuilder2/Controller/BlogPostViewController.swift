//
//  BlogPostViewController.swift
//  AppBuilder2
//
//  Created by Aditya on 27/03/18.
//  Copyright © 2018 VISHAL. All rights reserved.
//

import UIKit
import WebKit
import AVKit
import AVFoundation
import Alamofire
import TGPControls
import VGPlayer
import SnapKit
import MediaPlayer

class BlogPostViewController: UIViewController,AVAudioPlayerDelegate,NVActivityIndicatorViewable {
    
    //MARK: video Player
    var player1 : VGPlayer = {
        let playeView = VGCustomPlayerView()
        let playe = VGPlayer(playerView: playeView)
        return playe
    }()
    var switchingFlag = "1"
    var flagGoback = "0"
    var audioProgssValue = 0.0
    var flagForProgress = "1"
    var flagFroAudiVideo = ""
    var playerFlag = 0
    var strValue = ""
    var strParentId = ""
    var strCourseId = ""
    var sliderBtnFlag: Bool!
    
    @IBOutlet weak var viewOfAuther: UIView!
    
    //Slider Button
    @IBOutlet weak var btnOfA3: UIButton!
    @IBOutlet weak var btnOfA2: UIButton!
    @IBOutlet weak var btnOfA1: UIButton!
    @IBOutlet weak var btnOfA4: UIButton!
    @IBOutlet weak var btnOfA5: UIButton!
    
    var strAudiourl = ""
    var strVideoUrl = ""
    var strVideoTime = ""
    var strAudioTime = ""
    var strSec = "1"
    var strMint = "1"
    var strHr = "1"
    var observer:Any?
    
    //Audio Player UI
    @IBOutlet weak var viewofAudio: UIView!
    @IBOutlet weak var btnAudioBackword: UIButton!
    @IBOutlet weak var btnPlayRateAudio: UIButton!
    @IBOutlet weak var btnAudioPlay: UIButton!
    @IBOutlet weak var btnAudioForword: UIButton!
    @IBOutlet weak var btnAudioVolume: UIButton!
    @IBOutlet weak var progressViewAudio: UIProgressView!
    
    @IBOutlet var heightOfbottomBtn: NSLayoutConstraint!
    @IBOutlet var heightOfTopBtn: NSLayoutConstraint!
    @IBOutlet var topOftopBtnToImg: NSLayoutConstraint!
    @IBOutlet weak var slider: TGPDiscreteSlider!
    @IBOutlet var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnPlusMinus: UIButton!
    @IBOutlet weak var viewInsideScrollView: UIView!
    @IBOutlet weak var parentScrollView: UIScrollView!
    @IBOutlet weak var viewOfBottom: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblOfUsername: UILabel!
    @IBOutlet weak var lblOfDate: UILabel!
    @IBOutlet weak var btnQuestionMark: UIButton!
   
    @IBOutlet weak var lblOfLargeFont: UILabel!
    @IBOutlet weak var lblOfSmallFont: UILabel!
    @IBOutlet weak var viewOfSlider: viewOfShadow!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet var imageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var topofVideoView: NSLayoutConstraint!
    @IBOutlet weak var viewOfVideoPlayer: UIView!
    @IBOutlet var heightofVideoView: NSLayoutConstraint!
    
    @IBOutlet var audioTopConstraint: NSLayoutConstraint!
    
    
    //New buttons added
    @IBOutlet weak var btnTopSignMe: UIButton!
    @IBOutlet var videoBottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnBottomSignMe: UIButton!
    @IBOutlet weak var bottomOfBtmSignupBtn: NSLayoutConstraint!
    
    //semi circle + - Button
    @IBOutlet weak var imgOfSemiCircle: UIImageView!
    @IBOutlet weak var btnOfPlus: UIButton!
    @IBOutlet weak var btnOfMinus: UIButton!
    
    var controller = AVPlayerViewController()
    var plyerLayer = AVPlayerLayer()
    var recordingSession : AVAudioSession!
    var settings = [String : Int]()
    var playContrlHide = "0"
    var flagUI = ""
    var flgForPopVC = ""
    var flgToShow = ""
    var flgValue = ""
    var strViewedDuration = ""
    var strDrtnTime = ""
    var condtnID = ""
    
    var strTitle = ""
    let dropDown = DropDown()
    var appDelegate : AppDelegate!
    var chache:NSCache<AnyObject, AnyObject>!
    var flgActivity = true
    var timeOut: Timer!
    var apiSuccesFlag = ""
    var dicMediaData = NSDictionary()
    var noDataView = UIView()
    var refreshControl: UIRefreshControl!
    var strMenuId = ""
    var strWebUrl = ""
    var btnMenu:UIButton!
    var btnBack:UIButton!
    var getJsonData: [String:Any]?
    var webViewMore: WKWebView?
    
    var defaults  = ["textFontSize":12]
    var request: URLRequest!
    
    //Article button data
    var btn1Type = ""
    var btn1Name = ""
    var btn1Link = ""
    
    var btn2Type = ""
    var btn2Name = ""
    var btn2Link = ""
    var bgColorBottomBtn = ""
    
    var player : AVPlayer?
    var commomdCentre = MPRemoteCommandCenter.shared()
    
    //MARK:- viewDidLaod
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //article top , bottom button
        btnBottomSignMe.isHidden = true
        btnTopSignMe.layer.cornerRadius = 0
        btnTopSignMe.layer.masksToBounds = true
        let blueColor = UIColor(red: 22.0/255.0, green: 121.0/255.0, blue: 225.0/255.0, alpha: 1.0)
        btnTopSignMe.backgroundColor = blueColor
        
        btnBottomSignMe.layer.cornerRadius = 0
        btnBottomSignMe.layer.masksToBounds = true
        
        //slider
        slider.addTarget(self, action: #selector(slidervalueChanged(_:)), for: .valueChanged)
        sliderBtnFlag = false
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with:[.allowBluetooth])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
      
        //Handling interruptions of Audio player
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption(notification:)), name: .AVAudioSessionInterruption, object: nil)
        
        self.chache = NSCache()
        setBackBtn()
        setNavigationBtn()
       
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        getJsonData =  appDelegate.jsonData
       
        self.chache = NSCache()
        
        getUIForBlog()
        
        self.viewOfBottom.isHidden = true
        
        btnClose.layer.cornerRadius = 7
        btnClose.layer.borderWidth = 1
        btnClose.layer.borderColor = UIColor.black.cgColor
        
        webViewMore?.uiDelegate = self
        
        let webViewConfiguration = WKWebViewConfiguration()
        webViewMore = WKWebView(frame: .zero, configuration: webViewConfiguration)
        webViewMore?.scrollView.delegate = self
        webViewMore?.translatesAutoresizingMaskIntoConstraints = false
        webViewMore?.scrollView.backgroundColor = UIColor.clear
        webViewMore?.backgroundColor = UIColor.clear
        webViewMore?.isOpaque = false
        
        webViewMore?.uiDelegate = self
        webViewMore?.navigationDelegate = self
        
        lblOfDate.text = ""
        lblOfUsername.text = ""
        self.btnMenu.isHidden = false
        let strngFlag = UserDefaults.standard.value(forKey: "paymentFlag")
        if strngFlag as? String == "1"{
            self.btnBack.isHidden = true
        }else {
            self.btnBack.isHidden = false
       }
        
        //Permission Audio Video Player
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayback)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("Allow")
                    } else {
                        print("Dont Allow")
                    }
                }
            }
        } catch {
            print("failed to record!")
        }
        
        //Avsession Route
        NotificationCenter.default.addObserver(self,selector: #selector(handleRouteChange),name: .AVAudioSessionRouteChange,
                                               object: AVAudioSession.sharedInstance())
        
        
        // Audio Settings
        settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        controller.view.removeFromSuperview()
        
        //webViewMore?.load(URLRequest(url: URL(fileURLWithPath: Bundle.main.path(forResource: "Membrandt-article", ofType: "html")!)))
        
        self.viewInsideScrollView.addSubview(webViewMore!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BlogPostViewController.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        
        self.player?.replaceCurrentItem(with: nil)
        
       
        
    }
    
    func updateInfo() {
        
        if self.flagFroAudiVideo == "1"{
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
            return
        }
        
        guard player?.currentItem != nil else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
            return
        }
        let image = UIApplication.shared.icon!
        let mediaArtwork = MPMediaItemArtwork(boundsSize: image.size) { (size: CGSize)-> UIImage in return image}
        
        let nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: self.title!,
            MPMediaItemPropertyArtwork: mediaArtwork,
            MPMediaItemPropertyPlaybackDuration:  Float(CMTimeGetSeconds((player!.currentItem?.asset.duration)!)) ,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: Float(CMTimeGetSeconds(player!.currentTime()))
        ]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        callWSArticleUpdate()
        
        btnClose.setTitle((appDelegate.ArryLngResponeCustom!["close"] as? String)!, for: .normal)
        
        UserDefaults.standard.set("1", forKey: "ArticleVideoFlag")
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("JsonData.json")
        if self.strTitle == "About Us" {
            if FileManager.default.fileExists(atPath: documentsURL.relativePath) {
                let response = retrieveFromJsonFile()["response"] as! [String:Any]
                if response.keys.contains("responseAbout") {
                    let responseAbout = response["responseAbout"] as! NSArray
                    if responseAbout.count > 0{
                        self.dicMediaData = responseAbout.firstObject as! NSDictionary
                        //print(#function, " response from local" ,self.dicMediaData)
                        //call function
                        getDataForUIManagement()
                    }else {
                        self.callWSOfArticle()
                    }
                }else {
                    self.callWSOfArticle()
                }
            }else {
                self.callWSOfArticle()
            }
        }
        else if self.strTitle == "Legal" {
            if FileManager.default.fileExists(atPath: documentsURL.relativePath) {
                let response = retrieveFromJsonFile()["response"] as! [String:Any]
                if response.keys.contains("responseLegal") {
                    let responseLegal = response["responseLegal"] as! NSArray
                    if responseLegal.count > 0{
                        self.dicMediaData = responseLegal.firstObject as! NSDictionary
                        //print(#function, " response from local" ,self.dicMediaData)
                        //call function
                        getDataForUIManagement()
                    }else {
                        self.callWSOfArticle()
                    }
                }else {
                    self.callWSOfArticle()
                }
                
            }else {
                self.callWSOfArticle()
            }
        }
        else {
            callData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        
        commomdCentre.togglePlayPauseCommand.addTarget(handler: { (event) in
            DispatchQueue.main.async {
                if let wd = UIApplication.shared.delegate?.window {
                    var vc = wd!.rootViewController
                    if(vc is UINavigationController){
                        vc = (vc as! UINavigationController).visibleViewController
                    }
                    if(vc is BlogPostViewController){
                        if self.flagFroAudiVideo == "2"{
                            let playingRate = String(UserDefaults.standard.float(forKey: "PlayerRate")) + "x"
                            let strValueCurrent = playingRate.replacingOccurrences(of: ".0", with: "")
                            if strValueCurrent == self.btnPlayRateAudio.currentTitle! {
                                if (self.player?.isPlaying)! {
                                    self.player?.rate = UserDefaults.standard.float(forKey: "PlayerRate")
                                    self.player?.pause()
                                    self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                                }else {
                                    self.btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                                    self.player?.rate = UserDefaults.standard.float(forKey: "PlayerRate")
                                }
                            }
                            else {
                                if (self.player?.isPlaying)! {
                                    self.player?.pause()
                                    self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                                }else {
                                    self.btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                                    self.player?.play()
                                }
                            }
                        }else {
                            if (self.player1.player?.isPlaying)! {
                                self.player1.pause()
                                self.player1.displayView.playButtion.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                            }else {
                                self.player1.play()
                                self.player1.displayView.playButtion.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                            }
                        }
                    }
                }
            }
            return MPRemoteCommandHandlerStatus.success
        })
        
        commomdCentre.changePlaybackPositionCommand.isEnabled = false
        
        commomdCentre.playCommand.addTarget { (playEvent) -> MPRemoteCommandHandlerStatus in
            if self.flagFroAudiVideo == "2"{
                self.player?.play()
                self.player?.rate = UserDefaults.standard.float(forKey: "PlayerRate")
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                self.updateAudioProgressView()
                //self.updateInfo()
            }
            return .success
        }
        commomdCentre.pauseCommand.addTarget { (pauseEvent) -> MPRemoteCommandHandlerStatus in
            if self.flagFroAudiVideo == "2"{
                self.player?.pause()
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                self.updateAudioProgressView()
                //self.updateInfo()
            }
            return .success
        }
        commomdCentre.skipBackwardCommand.addTarget { (backword) -> MPRemoteCommandHandlerStatus in
            if self.player?.isPlaying != nil {
                if self.flagFroAudiVideo == "2"{
                    let time = (self.player?.currentTime())! - CMTimeMake(Int64(15), 1)
                    self.player?.seek(to: time)
                    self.updateAudioProgressView()
                    self.updateInfo()
                }
            }
            return .success
        }
        commomdCentre.skipForwardCommand.addTarget { (forword) -> MPRemoteCommandHandlerStatus in
            if self.player?.isPlaying != nil {
                if self.flagFroAudiVideo == "2"{
                    let time = (self.player?.currentTime())! + CMTimeMake(Int64(15), 1)
                    self.player?.seek(to: time)
                    self.updateAudioProgressView()
                    self.updateInfo()
                }
            }
            return .success
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(0, for: .default)
        UIApplication.shared.endReceivingRemoteControlEvents()
        self.resignFirstResponder()
        self.player = nil
       //UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
    }
    
    
    //response to remote control events
    func remoteControlReceivedWithEvent(_ receivedEvent:UIEvent)  {
        if (receivedEvent.type == .remoteControl) {
            switch receivedEvent.subtype {
            case .remoteControlTogglePlayPause:
                if (player?.rate)! > 0.0 {
                    player?.pause()
                } else {
                    player?.play()
                }
            case .remoteControlPlay:
                player?.play()
            case .remoteControlPause:
                player?.pause()
            default:
                print("received sub type \(receivedEvent.subtype) Ignoring")
            }
        }
    }
    
    
     //@objc func canRotate() -> Void {}
    
    @objc func handleRouteChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
            let reason = AVAudioSessionRouteChangeReason(rawValue:reasonValue) else {
                return
        }

        if reason == .oldDeviceUnavailable {
            self.player1.pause()
            self.player?.pause()
            DispatchQueue.main.async {
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            }
        }else if reason == .newDeviceAvailable {
            
            self.player?.pause()
            self.player1.pause()
            DispatchQueue.main.async {
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            }
        }
            }
    
    func callData(){
        self.navigationController?.navigationBar.isHidden = false
        if self.strTitle == "About Us" {
            // self.callWSOfArticle()
        }else if self.strTitle == "Legal" {
            //self.callWSOfArticle()
        }else if self.strTitle == "artcile"{
            let str = (dicMediaData.value(forKey: "title") as? String)!
            if str.count > 28{
                let startIndex = str.index(str.startIndex, offsetBy: 28)
                self.title = String(str[..<startIndex] + "..")
            }else {
                self.title = dicMediaData.value(forKey: "title") as? String
            }
            /*if DeviceType.IS_IPHONE_x {
             if (self.title?.count)! > 33 {
             self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(-10, for: .default)
             }else {
             self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(0, for: .default)
             }
             }else {
             self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(0, for: .default)
             }*/
            loadData()
        }else {
            loadData()
        }
        
        var contentType = 1
        if (UserDefaults.standard.string(forKey: "currentValue") != nil) {
            contentType = UserDefaults.standard.value(forKey: "currentValue") as! Int
        }else {
            contentType = 1
        }
        
        if contentType == 1 {
            self.slider.value = CGFloat(Float(contentType))
            if let strContent = dicMediaData.value(forKey: "contenturl") {
                let strValue = "\(strContent)&page=1"
                //webViewMore?.loadUrl(string: strValue)
                //appDelegate.flgForWebRefresh = true
                if appDelegate.flgForWebRefresh == true {  //For  updated content
                    request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 10.0)
                    webViewMore?.load(request)
                    appDelegate.flgForWebRefresh = false
                }
                else {
                    request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
                    webViewMore?.load(request)
                }
            }
        }
        else if contentType == 2 {
            self.slider.value = CGFloat(Float(contentType))
            if let strContent = dicMediaData.value(forKey: "contenturl") {
                let strValue = "\(strContent)&page=3"
                //webViewMore?.loadUrl(string: strValue)
                //appDelegate.flgForWebRefresh = true
                if appDelegate.flgForWebRefresh == true {  //For  updated content
                    request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 10.0)
                    webViewMore?.load(request)
                    appDelegate.flgForWebRefresh = false
                }
                else {
                    request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
                    webViewMore?.load(request)
                }
            }
        }
        else if contentType == 3 {
            self.slider.value = CGFloat(Float(contentType))
            if let strContent = dicMediaData.value(forKey: "contenturl") {
                let strValue = "\(strContent)&page=5"
                //webViewMore?.loadUrl(string: strValue)
                //appDelegate.flgForWebRefresh = true
                if appDelegate.flgForWebRefresh == true {  //For  updated content
                    request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 10.0)
                    webViewMore?.load(request)
                    appDelegate.flgForWebRefresh = false
                }
                else {
                    request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
                    webViewMore?.load(request)
                }
            }
        }
            //New Added
        else if contentType == 4 {
            self.slider.value = CGFloat(Float(contentType))
            if let strContent = dicMediaData.value(forKey: "contenturl") {
                let strValue = "\(strContent)&page=6"
                //webViewMore?.loadUrl(string: strValue)
                //appDelegate.flgForWebRefresh = true
                if appDelegate.flgForWebRefresh == true {  //For  updated content
                    request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 10.0)
                    webViewMore?.load(request)
                    appDelegate.flgForWebRefresh = false
                }
                else {
                    request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
                    webViewMore?.load(request)
                }
            }
        }
        else if contentType == 5 {
            self.slider.value = CGFloat(Float(contentType))
            if let strContent = dicMediaData.value(forKey: "contenturl") {
                let strValue = "\(strContent)&page=7"
                //webViewMore?.loadUrl(string: strValue)
                //appDelegate.flgForWebRefresh = true
                if appDelegate.flgForWebRefresh == true {  //For  updated content
                    request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 10.0)
                    webViewMore?.load(request)
                    appDelegate.flgForWebRefresh = false
                }
                else {
                    request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
                    webViewMore?.load(request)
                }
            }
        }
        else {
            if let strContent = dicMediaData.value(forKey: "contenturl") {
                let strValue = "\(strContent)"
                if strValue.count > 0 {
                    //webViewMore?.loadUrl(string: (dicMediaData["contenturl"])! as! String)
                    
                    //appDelegate.flgForWebRefresh = true
                    if appDelegate.flgForWebRefresh == true {  //For  updated content
                        request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 10.0)
                        webViewMore?.load(request)
                        appDelegate.flgForWebRefresh = false
                    }
                    else {
                        request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
                        webViewMore?.load(request)
                    }
                }
            }
        }
    }
    
    @IBAction func btnMinusClk(_ sender: Any) {
        
    }
    
    @IBAction func btnPlusClk(_ sender: Any) {
     
    }
    
    func loadData(){
        
        btnBottomSignMe.isHidden = true
        if DeviceType.IS_IPHONE_x{
            self.topofVideoView.constant =  0
        }else {
            self.topofVideoView.constant =  0
        }
        
        if flgToShow == "Help"{
            //flgToShow = ""
            btnQuestionMark.isHidden = true
            let str = (appDelegate.ArryLngResponeCustom!["help"] as? String)!
            if str.count > 28{
                let startIndex = str.index(str.startIndex, offsetBy: 28)
                self.title = String(str[..<startIndex] + "..")
            }else {
                 self.title = (appDelegate.ArryLngResponeCustom!["help"] as? String)!//"Help"
            }
        }else {
            btnQuestionMark.isHidden = false
            var str = self.strTitle
            if self.strTitle == "About Us" {
                str = (appDelegate.ArryLngResponeCustom!["about_us"] as? String)!
            }else if self.strTitle == "Legal" {
                str = (appDelegate.ArryLngResponeCustom!["legal"] as? String)!
            }
            if str.count > 28{
                let startIndex = str.index(str.startIndex, offsetBy: 28)
                self.title = String(str[..<startIndex] + "..")
            }else {
                self.title = str
            }
      }
        
        var strImgUrl = ""
       // var strAudiourl = ""
        //var strVideoUrl = ""
        
         if self.strTitle == "artcile"{
            
            let str = (dicMediaData.value(forKey: "title") as? String)!
            if str.count > 28{
                let startIndex = str.index(str.startIndex, offsetBy: 28)
                self.title = String(str[..<startIndex] + "..")
            }else {
                self.title = dicMediaData.value(forKey: "title") as? String
            }
        }
        
        if let arrMedia = dicMediaData.value(forKey: "mediaData") {//"media" //"mediaData"
            let dic = (arrMedia as! NSArray)[0] as! NSDictionary
            
            strImgUrl = (dic["image"] as? String)!
            strAudiourl = (dic["audio"] as? String)!
            strVideoUrl = (dic["video"] as? String)!
            
            lblOfDate.text = dicMediaData["date"] as? String
            lblOfUsername.text = dicMediaData["author"] as? String
            
            self.condtnID = (dicMediaData["conditionId"] as? String)!
            //"1"://only Text
            //"2"://Image and Text
            //"3"://Audio and Text
            //"4"://Image, Audio and Text
            //"5"://Video (As Audio) and Text
            
            if self.condtnID == "1" {
                flagUI = "0" //only Text
            }else if self.condtnID == "2"{
                flagUI = "1" //Image and Text
            }else if self.condtnID == "3"{
                flagUI = "2" //Audio and Text
            }else if self.condtnID == "4"{
                flagUI = "4" //Image, Audio and Text
            }else if self.condtnID == "5"{
                flagUI = "3" //Video, Audio and Text
            }else if self.condtnID == "6"{
                flagUI = "3" //Video (As Audio) and Text
            }else {
                flagUI = "0" //nothing (no video, no audio, no Banner)
            }
        }
        
        if let button1Data = dicMediaData.value(forKey: "button1") {
            let dic = (button1Data as! NSArray)[0] as! NSDictionary
            
            btn1Type = (dic["type"] as? String)!
            btn1Name = (dic["name"] as? String)!
            btn1Link = (dic["link"] as? String)!
            print("btn1Link ::", btn1Link)
            btnTopSignMe.setTitle(btn1Name, for: .normal)
            btnTopSignMe.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        
        if let button2Data = dicMediaData.value(forKey: "button2") {
            let dic = (button2Data as! NSArray)[0] as! NSDictionary
            
            btn2Type = (dic["type"] as? String)!
            btn2Name = (dic["name"] as? String)!
            btn2Link = (dic["link"] as? String)!
            print("btn2Link ::", btn2Link)
            btnBottomSignMe.setTitle(btn2Name, for: .normal)
            btnBottomSignMe.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        
        if btn1Type == "1"{
            btnTopSignMe.isHidden = false
            heightOfTopBtn.constant = 40
        }
        else {
            btnTopSignMe.isHidden = true
            heightOfTopBtn.constant = 0
        }
        
        webViewMore?.leftAnchor.constraint(equalTo: viewInsideScrollView.leftAnchor).isActive = true
        webViewMore?.rightAnchor.constraint(equalTo: viewInsideScrollView.rightAnchor).isActive = true
        
        if flagUI == "4"{
            self.imageViewHeightConstraint.constant = 220
            self.heightofVideoView.constant = 100
            topofVideoView.constant = imageViewHeightConstraint.constant + 8
            //webViewMore?.topAnchor.constraint(equalTo:viewOfVideoPlayer.bottomAnchor).isActive = true
            webViewMore?.topAnchor.constraint(equalTo:btnTopSignMe.bottomAnchor, constant: 7.5).isActive = true
            
        }else {
           // webViewMore?.topAnchor.constraint(equalTo: headerImage.bottomAnchor).isActive = true
           webViewMore?.topAnchor.constraint(equalTo: btnTopSignMe.bottomAnchor, constant: 7.5).isActive = true
       }
        
        webViewMore?.widthAnchor.constraint(equalTo: viewInsideScrollView.widthAnchor).isActive = true
        // webViewMore?.bottomAnchor.constraint(equalTo: viewInsideScrollView.bottomAnchor, constant: 5).isActive = true
        webViewMore?.bottomAnchor.constraint(equalTo: btnBottomSignMe.topAnchor, constant: -7.5).isActive = true
        webViewMore?.scrollView.isScrollEnabled = false
        webViewMore?.scrollView.bounces = false
        webViewMore?.sizeToFit()
        
        viewOfVideoPlayer.addSubview(self.player1.displayView)
        self.player?.pause()
        self.player1.backgroundMode = .suspend
        self.player1.delegate = self
        self.player1.displayView.delegate = self
        self.player1.displayView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.top.equalTo(strongSelf.viewOfVideoPlayer.snp.top)
            make.left.equalTo(strongSelf.viewOfVideoPlayer.snp.left)
            make.right.equalTo(strongSelf.viewOfVideoPlayer.snp.right)
            make.height.equalTo(strongSelf.viewOfVideoPlayer.frame.height).multipliedBy(9.0/16.0)
        }
        self.player1.displayView.isHidden = true
        
        switch flagUI {
        case "0":
            print("Only text")
            self.headerImage.isHidden = true
            self.imageViewHeightConstraint.constant = 0
            videoBottonConstraint.isActive = false
            self.viewOfVideoPlayer.isHidden = true
            player?.pause()
        case "1":
            print("Image and text")
            self.headerImage.isHidden = false
            //self.imageViewHeightConstraint.constant = 220
            self.imageViewHeightConstraint.constant = 272
            self.viewOfVideoPlayer.isHidden = true
            self.videoBottonConstraint.isActive = false
            imgDownload(imgurl: strImgUrl)
            player?.pause()
        case "2":
            print("Audio and text")
            //self.viewHeightConstraint.constant = 110
            self.headerImage.isHidden = true
            self.imageViewHeightConstraint.constant = 100
            self.viewOfVideoPlayer.isHidden = false
            self.heightofVideoView.constant = 100
            self.btnAudioVolume.setImage(#imageLiteral(resourceName: "Volume"), for: .normal)
            
            videoBottonConstraint.isActive = true
            videoBottonConstraint.constant = 5

            self.viewofAudio.isHidden = false
            self.viewOfVideoPlayer.addSubview(viewofAudio)
            self.viewOfVideoPlayer.bringSubview(toFront: viewofAudio)
            playerFlag = 0
            playSoundWith(urlString: strAudiourl, strDuration:"00:00:00")
        case "3":
            print("Video and text")
            self.headerImage.isHidden = true
            self.imageViewHeightConstraint.constant = 220
            self.viewOfVideoPlayer.isHidden = false
            self.heightofVideoView.constant = 220
            
            videoBottonConstraint.constant = 5
            videoBottonConstraint.isActive = true
            self.player1.displayView.removeFromSuperview()
            //self.viewofAudio.removeFromSuperview()
            
            viewOfVideoPlayer.addSubview(self.player1.displayView)
            self.player?.pause()
            self.player1.backgroundMode = .suspend
            self.player1.delegate = self
            self.player1.displayView.delegate = self
            self.player1.displayView.snp.makeConstraints { [weak self] (make) in
                guard let strongSelf = self else { return }
                make.top.equalTo(strongSelf.viewOfVideoPlayer.snp.top)
                make.left.equalTo(strongSelf.viewOfVideoPlayer.snp.left)
                make.right.equalTo(strongSelf.viewOfVideoPlayer.snp.right)
                make.height.equalTo(strongSelf.viewOfVideoPlayer.frame.height).multipliedBy(9.0/16.0)
            }
            self.player1.displayView.isHidden = false
            
            webViewMore?.bottomAnchor.constraint(equalTo: btnBottomSignMe.topAnchor, constant: -7.5).isActive = true
            
            //self.player1.
            videoAudioPlayer(urlStr: strVideoUrl, StrstartTime: "00:00:00")
            
        case "4":
            print("Audio , Image and text")
            self.headerImage.isHidden = false
            self.viewOfVideoPlayer.isHidden = false
            self.viewofAudio.isHidden = false
            
            videoBottonConstraint.isActive = true
            videoBottonConstraint.constant = 10
            topOftopBtnToImg.isActive = false
            
            self.imageViewHeightConstraint.constant = 272
            topofVideoView.constant = self.imageViewHeightConstraint.constant
            //audioTopConstraint.constant = 4
            self.heightofVideoView.constant = 100
            
            self.viewOfVideoPlayer.addSubview(viewofAudio)
            self.viewOfVideoPlayer.bringSubview(toFront: viewofAudio)
            playerFlag = 0
            playSoundWith(urlString: strAudiourl, strDuration:"00:00:00")
            imgDownload(imgurl: strImgUrl)
        default:
            print("Only text")
            self.headerImage.isHidden = true
            self.imageViewHeightConstraint.constant = 0
            self.viewOfVideoPlayer.isHidden = true
            player?.pause()
        }
    }
    
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)
        
        self.startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
        self.timeOut = Timer.scheduledTimer(timeInterval: 25.0, target: self, selector: #selector(MyProfile.cancelWeb), userInfo: nil, repeats: false)
    }
    
    func stopActivityIndicator() {
        self.stopAnimating()
    }
    
    @objc func cancelWeb() {
        print("cancelWeb")
        if apiSuccesFlag == "1"{
            //self.view.makeToast("Something went wrong. Please try again later.")
            self.stopAnimating()
        }
    }
    
    func imgDownload(imgurl : String){
        
        //image
        if imgurl != ""{
            let imgUrl = imgurl
            
            let imageName = self.separateImageNameFromUrl(Url: imgUrl)
            //self.headerImage.image = UIImage(named:"ArtcilePlaceholder")
            self.headerImage.backgroundColor = color.placeholdrImgColor
            
            if(self.chache.object(forKey: imageName as AnyObject) != nil){
                 self.headerImage.image = self.chache.object(forKey: imageName as AnyObject) as? UIImage
            }else{
                if validation.checkNotNullParameter(checkStr: imgUrl) == false {
                    Alamofire.request(imgUrl).responseImage{ response in
                        if let image = response.result.value {
                            self.headerImage.image = image
                            self.chache.setObject(image, forKey: imageName as AnyObject)
                        }
                        else {
                           // self.headerImage.image = UIImage(named:"ArtcilePlaceholder")
                            self.headerImage.backgroundColor = color.placeholdrImgColor
                         }
                    }
                }else {
                    //self.headerImage.image = UIImage(named:"ArtcilePlaceholder")
                    self.headerImage.backgroundColor = color.placeholdrImgColor
                 }
            }
        }else {
            //self.headerImage.image = UIImage(named:"ArtcilePlaceholder")
            self.headerImage.backgroundColor = color.placeholdrImgColor
        }
    }
    
    @IBAction func btnCloseClk(_ sender: Any) {
            self.viewOfBottom.isHidden = true
            self.imgOfSemiCircle.isHidden = false
            btnOfPlus.isHidden = false
            btnOfMinus.isHidden = false
    }
    
    @IBAction func btnPlusMinusClk(_ sender: Any) {
            self.viewOfBottom.isHidden = false
            self.imgOfSemiCircle.isHidden = true
            btnOfPlus.isHidden = true
            btnOfMinus.isHidden = true
    }
    
    func setBackBtn() {
        //setNaviBackButton()
        let origImage = UIImage(named: "back");
        btnBack = UIButton(frame: CGRect(x: 0, y:0, width:28,height: 34))
        //        btnBack.alignmentRectInsets.left = -10
        btnBack.translatesAutoresizingMaskIntoConstraints = false;
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        btnBack.setImage(tintedImage, for: .normal)
        btnBack.addTarget(self,action: #selector(backClick(_:)), for: .touchUpInside)
        let widthConstraint1 = btnBack.widthAnchor.constraint(equalToConstant: 28)
        let heightConstraint1 = btnBack.heightAnchor.constraint(equalToConstant: 34)
        heightConstraint1.isActive = true
        widthConstraint1.isActive = true
        let backBarButtonitem = UIBarButtonItem(customView: btnBack)
        let arrLeftBarButtonItems : Array = [backBarButtonitem]
        self.navigationItem.leftBarButtonItems = arrLeftBarButtonItems
    }
    
    @objc func backClick(_ sender: Any){
        self.flagFroAudiVideo = "1"
        player1.cleanPlayer()
        player?.pause()
        self.player = nil
        self.navigationController?.popViewController(animated: true)
     }
    
    func setNavigationBtn() {
        let origImage = UIImage(named: "side-menu");
        btnMenu = UIButton(frame: CGRect(x: 0, y:0, width:25,height: 25))
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        btnMenu.setImage(tintedImage, for: .normal)
        btnMenu.addTarget(self,action: #selector(menu), for: .touchUpInside)
        let widthConstraint = btnMenu.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = btnMenu.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        let backBarButtonitem = UIBarButtonItem(customView: btnMenu)
        let arrLeftBarButtonItems : Array = [backBarButtonitem]
        self.navigationItem.rightBarButtonItems = arrLeftBarButtonItems
    }
    
    @objc func menu(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteMenus") as! FavouriteMenus
        vc.delegate = self as! favMenuDelagte
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func btnQuestionMarkClick(_ sender: Any) {
        player?.pause()
        if self.appDelegate.helpData.count > 0 && UserDefaults.standard.bool(forKey: "helpData"){
            player1.cleanPlayer()
            UserDefaults.standard.set("1", forKey: "ArticleVideoFlag")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogHelpViewController") as! BlogHelpViewController
            print("AppDelegate helpData : ",self.appDelegate.helpData)
            vc.dicMediaData = self.appDelegate.helpData
            vc.flgToShow = "Help"
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            self.view.makeToast((appDelegate.ArryLngResponSystm!["no_help_article_msg"] as? String)!)
        }
    }
    
    func getUIForBlog() {
        let status = getJsonData!["status"] as! String
        if status == "1" {
            if let data = getJsonData!["data"] as? [String:Any] {
                if let common_element = data["common_element"] as? [String:Any] {
                    let navigation_bar = common_element["navigation_bar"] as! Dictionary<String,String>
                    let size = navigation_bar["size"]
                    let bgcolor = navigation_bar["bgcolor"]
                    let txtcolorHex = navigation_bar["txtcolorHex"]
                    let menu_icon_color = navigation_bar["menu_icon_color"]
                    let sizeInt:Int = Int(size!)!
                    
                    let genarlSettings = common_element["general_settings"] as! [String:Any]
                    let general_font = genarlSettings["general_font"] as! [String:Any]
                    let fontstyle = general_font["fontstyle"] as! String
                    let bgScreenColor = genarlSettings["screen_bg_color"] as! String
                    
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor().HexToColor(hexString: txtcolorHex!),NSAttributedStringKey.font: checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(sizeInt))]
                    
                    self.navigationController?.navigationBar.barTintColor = UIColor().HexToColor(hexString: bgcolor!)
                    self.navigationController?.navigationBar.backgroundColor = UIColor().HexToColor(hexString: bgcolor!)
                    
                    self.btnMenu.tintColor = UIColor().HexToColor(hexString: menu_icon_color!)
                    self.btnBack.tintColor = UIColor().HexToColor(hexString: menu_icon_color!)
                    
                    let helpBubbl = genarlSettings["help_bubble"] as! Dictionary<String,String>
                    let bblBgColor = helpBubbl["bgcolor"]
                    let txtBblClor = helpBubbl["txtcolorHex"]
                    let fontstyle1 = helpBubbl["fontstyle"]
                    let size1 = helpBubbl["size"]
                    let sizeInt1:Int = Int(size1!)!
                    let origImage = UIImage(named: "question");
                    let tintImg = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    btnQuestionMark.setBackgroundImage(tintImg, for: .normal)
                    btnQuestionMark.tintColor = UIColor().HexToColor(hexString: bblBgColor!)
                    btnQuestionMark.titleLabel?.font = checkForFontType(fontStyle: fontstyle1! , fontSize: CGFloat(sizeInt1 + 14))
                    btnQuestionMark.setTitleColor(UIColor().HexToColor(hexString: txtBblClor!), for: .normal)
                    
                    viewInsideScrollView.backgroundColor = UIColor().HexToColor(hexString: bgScreenColor)
                    parentScrollView.backgroundColor = UIColor().HexToColor(hexString: bgScreenColor)
                    view.backgroundColor = UIColor().HexToColor(hexString: bgScreenColor)
                    viewOfAuther.backgroundColor = UIColor().HexToColor(hexString: bgScreenColor)
                    
                    if data.keys.contains("articles"){
                        let articleDic = data["articles"] as? [String:Any]
                        let artileElement = articleDic!["article_templates_detail_page"] as! [String:Any]
                        
                        //Date
                        if let templtDate = artileElement["template_date"] as? Dictionary<String,String> {
                            let size = templtDate["size"]
                            let txtcolorHex = templtDate["txtcolorHex"]
                            let fontstyle = templtDate["fontstyle"]
                            let sizeInt:Int = Int(size!)!
                            
                            //lblOfDate.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt + 2))
                            lblOfDate.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                            
                            if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5{
                                
                                lblOfDate.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt) - 6)
                                lblOfDate.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeInt) - 6)
                            }else {
                               
                                lblOfDate.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                                lblOfDate.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeInt))
                            }
                        }
                        
                        //Author Name
                        if let authoreDic = artileElement["author"] as? Dictionary<String,String> {
                            let size = authoreDic["size"]
                            let txtcolorHex = authoreDic["txtcolorHex"]
                            let fontstyle = authoreDic["fontstyle"]
                            let sizeInt:Int = Int(size!)!
                            
                            //lblOfUsername.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt + 2))
                            lblOfUsername.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                            
                            if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5{
                                lblOfUsername.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt) - 6)
                                lblOfUsername.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeInt) - 6)
                            }else {
                                lblOfUsername.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                                lblOfUsername.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeInt))
                            }
                        }
                        
                        // +/- Button UI
                        
                        if let font_toggle = artileElement["font_toggle"] as? Dictionary<String,String> {
                            
                            let txtcolorHex = font_toggle["txtcolorHex"]
                            let bgcolor = font_toggle["bgcolor"]
                           
                            //Semi Circle image
                            imgOfSemiCircle.image = UIImage(named: "semi-circle")
                            var temp = imgOfSemiCircle.image?.withRenderingMode(.alwaysTemplate)
                            imgOfSemiCircle.image = temp
                            imgOfSemiCircle.tintColor = UIColor().HexToColor(hexString: bgcolor!)
                       }
                        
                        // Top Article Button
                        if let top_buttonDic = artileElement["top_button"] as? Dictionary<String,String> {
                            let size = top_buttonDic["size"]
                            let txtcolorHex = top_buttonDic["txtcolorHex"]
                            let fontstyle = top_buttonDic["fontstyle"]
                            let sizeInt:Int = Int(size!)!
                            let bgColorTopBtn = top_buttonDic["bgcolor"]
                                print("bgColorTopBtn ",bgColorTopBtn)
                            btnTopSignMe.backgroundColor = UIColor().HexToColor(hexString: bgColorTopBtn!)
                            btnTopSignMe.titleLabel?.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                            btnTopSignMe.setTitleColor(UIColor().HexToColor(hexString: txtcolorHex!), for: .normal)
                        }
                        
                        
                        //bottom Article Button
                        if let bottom_buttonDic = artileElement["bottom_button"] as? Dictionary<String,String> {
                            let size = bottom_buttonDic["size"]
                            let txtcolorHex = bottom_buttonDic["txtcolorHex"]
                            let fontstyle = bottom_buttonDic["fontstyle"]
                            let sizeInt:Int = Int(size!)!
                            bgColorBottomBtn = bottom_buttonDic["bgcolor"]!
                            print("bgColorBottomBtn : ",bgColorBottomBtn)
                           // btnBottomSignMe.backgroundColor = UIColor().HexToColor(hexString: bgColorBottomBtn)
                            btnBottomSignMe.backgroundColor = UIColor.clear
                            btnBottomSignMe.titleLabel?.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                            btnBottomSignMe.setTitleColor(UIColor().HexToColor(hexString: txtcolorHex!), for: .normal)
                        }
                    }
                }
            }
        } else {
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func createActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let subview = (actionSheet.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.backgroundColor = UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0)
        subview.layer.cornerRadius = 10
        subview.alpha = 1
        subview.layer.borderWidth = 1
        subview.layer.borderColor = UIColor.darkGray.cgColor
        subview.clipsToBounds = true
        
        actionSheet.view.tintColor = UIColor.white
        actionSheet.addAction(UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["close"] as? String)!, style: .default, handler: nil))
        //"Close"
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    //MARK:- IBAction
    @IBAction func topSignMeBtnClk(_ sender: UIButton) {

        let url = btn1Link
        print("btn1Link ", url)
       
        /*if userInfo.appId == "27" && userInfo.appclientsId == "6"{
            if (UserDefaults.standard.string(forKey: "emailId") != nil) && (UserDefaults.standard.string(forKey: "contactID") != nil) {
                url = btn1Link + "?contactId=" + UserDefaults.standard.string(forKey: "contactID")! + "&inf_field_Email=" + UserDefaults.standard.string(forKey: "emailId")!
            }else {
                url = btn1Link
            }
            self.openLink(url: url)
        }else if userInfo.appId == "50" && userInfo.appclientsId == "27"{
            if (UserDefaults.standard.string(forKey: "emailId") != nil) && (UserDefaults.standard.string(forKey: "contactID") != nil) {
                url = btn1Link + "?inf_field_Id=" + UserDefaults.standard.string(forKey: "contactID")! + "&inf_field_Email=" + UserDefaults.standard.string(forKey: "emailId")!
            }else {
                url = btn1Link
            }
            self.openLink(url: url)
        }else {*/
            if validation.isValidEmail(testEmail: url){
                //open Link
                if let requestUrl = NSURL(string: url) {
                    UIApplication.shared.open(requestUrl as URL, options: [:], completionHandler: nil)
                }
                else {
                    
                    let alrtTitleStr = NSMutableAttributedString(string: (appDelegate.ArryLngResponeCustom!["sorry"] as? String)!)
                    //"Sorry!"
                    alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                    
                    let alrtMessage = NSMutableAttributedString(string: (appDelegate.ArryLngResponSystm!["article_url_err_msg"] as? String)!)
                    //"We can not open the URL or load email composer.\n Please contact to Admin.\n"
                    alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                    
                    let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                    alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                    alertController.setValue(alrtMessage, forKey: "attributedMessage")
                    //let alert = UIAlertController(title: "Sorry!", message: "We can not open the URL or load email composer.\n Please contact to Admin.\n", preferredStyle: .alert)
                    let ok = UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["ok"] as? String)!, style: .cancel, handler: nil)
                    alertController.addAction(ok)
                    present(alertController, animated: true, completion: nil)
                }
            }
            else {
                //Open Mail
                if validation.isValidEmail(testEmail: url){
                    //invalid
                    let alrtTitleStr = NSMutableAttributedString(string: (appDelegate.ArryLngResponeCustom!["sorry"] as? String)!)
                    alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                    
                    let alrtMessage = NSMutableAttributedString(string: (appDelegate.ArryLngResponSystm!["article_url_err_msg"] as? String)!)
                    //"We can not open the URL or load email composer.\n Please contact to Admin.\n"
                    alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                    
                    let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                    alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                    alertController.setValue(alrtMessage, forKey: "attributedMessage")
                    //let alert = UIAlertController(title: "Sorry!", message: "We can not open the URL or load email composer.\n Please contact to Admin.\n", preferredStyle: .alert)
                    let ok = UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["ok"] as? String)!, style: .cancel, handler: nil)
                    alertController.addAction(ok)
                    present(alertController, animated: true, completion: nil)
                    
                }else {
                    //valid
                    if let requestUrl = URL(string: "mailto:\(url)") {
                        UIApplication.shared.open(requestUrl)
                    }
                }
            }
        //}
}
    
    
    @IBAction func bottomSignMeBtnClk(_ sender: UIButton) {
        
        let url = btn2Link
        print("btn2Link ", url)
        /*if userInfo.appId == "27" && userInfo.appclientsId == "6"{
            if (UserDefaults.standard.string(forKey: "emailId") != nil) && (UserDefaults.standard.string(forKey: "contactID") != nil) {
                url = btn2Link + "?contactId=" + UserDefaults.standard.string(forKey: "contactID")! + "&inf_field_Email=" + UserDefaults.standard.string(forKey: "emailId")!
            }else {
                url = btn2Link
            }
            self.openLink(url: url)
        }else if userInfo.appId == "50" && userInfo.appclientsId == "27"{
            if (UserDefaults.standard.string(forKey: "emailId") != nil) && (UserDefaults.standard.string(forKey: "contactID") != nil) {
                url = btn2Link + "?inf_field_Id=" + UserDefaults.standard.string(forKey: "contactID")! + "&inf_field_Email=" + UserDefaults.standard.string(forKey: "emailId")!
            }else {
                url = btn2Link
            }
            self.openLink(url: url)
        }else {*/
            if validation.isValidEmail(testEmail: url){
                //open Link
                if let requestUrl = NSURL(string: url) {
                    UIApplication.shared.open(requestUrl as URL, options: [:], completionHandler: nil)
                }
                else {
                    let alrtTitleStr = NSMutableAttributedString(string: (appDelegate.ArryLngResponeCustom!["sorry"] as? String)!)
                    alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                    
                    let alrtMessage = NSMutableAttributedString(string: (appDelegate.ArryLngResponSystm!["article_url_err_msg"] as? String)!)
                    //"We can not open the URL or load email composer.\n Please contact to Admin.\n"
                    alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                    
                    let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                    alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                    alertController.setValue(alrtMessage, forKey: "attributedMessage")
                    
                    //let alert = UIAlertController(title: "Sorry!", message: "We can not open the URL or load email composer.\nPlease contact to Admin.\n", preferredStyle: .alert)
                    let ok = UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["ok"] as? String)!, style: .cancel, handler: nil)
                    alertController.addAction(ok)
                    present(alertController, animated: true, completion: nil)
                }
            }
            else {
                //Open Mail
                if validation.isValidEmail(testEmail: url)  {
                    //invalid
                    let alrtTitleStr = NSMutableAttributedString(string: (appDelegate.ArryLngResponeCustom!["sorry"] as? String)!)
                    alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                    
                    let alrtMessage = NSMutableAttributedString(string: (appDelegate.ArryLngResponSystm!["article_url_err_msg"] as? String)!)
                    //"We can not open the URL or load email composer.\n Please contact to Admin.\n"
                    alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                    
                    let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                    alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                    alertController.setValue(alrtMessage, forKey: "attributedMessage")
                    
                    //let alert = UIAlertController(title: "Sorry!", message: "We can not open the URL or load email composer.\nPlease contact to Admin.\n", preferredStyle: .alert)
                    let ok = UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["ok"] as? String)!, style: .cancel, handler: nil)
                    alertController.addAction(ok)
                    present(alertController, animated: true, completion: nil)
                    
                }else {
                    //valid
                    if let requestUrl = URL(string: "mailto:\(url)") {
                        UIApplication.shared.open(requestUrl)
                    }
                }
            }
        //}
}
    func openLink(url : String){
        if validation.isValidEmail(testEmail: url){
            //open Link
            if let requestUrl = NSURL(string: url) {
                UIApplication.shared.open(requestUrl as URL, options: [:], completionHandler: nil)
            }
            else {
                let alrtTitleStr = NSMutableAttributedString(string: (appDelegate.ArryLngResponeCustom!["sorry"] as? String)!)
                alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                
                let alrtMessage = NSMutableAttributedString(string: (appDelegate.ArryLngResponSystm!["article_url_err_msg"] as? String)!)
                //"We can not open the URL or load email composer.\n Please contact to Admin.\n"
                alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                
                let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                alertController.setValue(alrtMessage, forKey: "attributedMessage")
                
                //let alert = UIAlertController(title: "Sorry!", message: "We can not open the URL or load email composer.\nPlease contact to Admin.\n", preferredStyle: .alert)
                let ok = UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["ok"] as? String)!, style: .cancel, handler: nil)
                alertController.addAction(ok)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
//     //#MARK :-  Url Validation function
//    func isValidUrl(string: String) -> Bool {
//
//        let urlRegx = "((http|https)://)?((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]?((\\w)*|(:?[0-9]*)|([-|_])*))+"
//        let urltest = NSPredicate(format: "self matches %@", urlRegx)
//        let result = urltest.evaluate(with: string)
//        return result
//    }
   
    //#MARK :-  Slider IBAction
    @IBAction func btnSliderA1Clk(_ sender: UIButton) {
      
        let contentType = 1
        self.slider.value = CGFloat(Float(contentType))
        let fixed = roundf(Float(slider.value / 1.0)) * 1.0
        slider.value = CGFloat(fixed)
        let currentValue = Int(slider.value)
        self.viewHeightConstraint.constant = 667
        if let strContent = dicMediaData.value(forKey: "contenturl") {
                UserDefaults.standard.set(currentValue, forKey: "currentValue")
                let strValue = "\(strContent)&page=1"
                print("strValue ::",strValue)
            
           
            if appDelegate.flgForWebRefresh == true {  //For  updated content
                request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 10.0)
                webViewMore?.load(request)
                appDelegate.flgForWebRefresh = false
            }
            else {
                request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
                webViewMore?.load(request)
            }
        }
        
        btnOfA2.isUserInteractionEnabled = true
        btnOfA1.isUserInteractionEnabled = true
        btnOfA3.isUserInteractionEnabled = true
        btnOfA4.isUserInteractionEnabled = true
        btnOfA5.isUserInteractionEnabled = true
   }
    
    @IBAction func btnSliderA2Clk(_ sender: Any) {
        
        let contentType = 2
        self.slider.value = CGFloat(Float(contentType))
        let fixed = roundf(Float(slider.value / 1.0)) * 1.0
        slider.value = CGFloat(fixed)
        let currentValue = Int(slider.value)
        self.viewHeightConstraint.constant = 667
        if let strContent = dicMediaData.value(forKey: "contenturl") {
            UserDefaults.standard.set(currentValue, forKey: "currentValue")
            let strValue = "\(strContent)&page=3"
            print("strValue ::",strValue)
            
            //appDelegate.flgForWebRefresh = true
            if appDelegate.flgForWebRefresh == true {  //For  updated content
                request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 10.0)
                webViewMore?.load(request)
                appDelegate.flgForWebRefresh = false
            }
            else {
                request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
                webViewMore?.load(request)
            }
        }
        btnOfA2.isUserInteractionEnabled = true
        btnOfA1.isUserInteractionEnabled = true
        btnOfA3.isUserInteractionEnabled = true
        btnOfA4.isUserInteractionEnabled = true
        btnOfA5.isUserInteractionEnabled = true
    }
    
    @IBAction func btnSliderA3Clk(_ sender: UIButton) {
        
        let contentType = 3
        self.slider.value = CGFloat(Float(contentType))
        let fixed = roundf(Float(slider.value / 1.0)) * 1.0
        slider.value = CGFloat(fixed)
        let currentValue = Int(slider.value)
        self.viewHeightConstraint.constant = 667
        if let strContent = dicMediaData.value(forKey: "contenturl") {
            UserDefaults.standard.set(currentValue, forKey: "currentValue")
            let strValue = "\(strContent)&page=5"
            print("strValue ::",strValue)
            
            //appDelegate.flgForWebRefresh = true
            if appDelegate.flgForWebRefresh == true {  //For  updated content
                request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 10.0)
                webViewMore?.load(request)
                appDelegate.flgForWebRefresh = false
            }
            else {
                request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
                webViewMore?.load(request)
            }
        }
        
        btnOfA2.isUserInteractionEnabled = true
        btnOfA1.isUserInteractionEnabled = true
        btnOfA3.isUserInteractionEnabled = true
        btnOfA4.isUserInteractionEnabled = true
        btnOfA5.isUserInteractionEnabled = true
    }
    
    
    @IBAction func btnSliderA4Clk(_ sender: UIButton) {
        
        let contentType = 4
        self.slider.value = CGFloat(Float(contentType))
        let fixed = roundf(Float(slider.value / 1.0)) * 1.0
        slider.value = CGFloat(fixed)
        let currentValue = Int(slider.value)
        self.viewHeightConstraint.constant = 667
        if let strContent = dicMediaData.value(forKey: "contenturl") {
            UserDefaults.standard.set(currentValue, forKey: "currentValue")
            let strValue = "\(strContent)&page=6"
            print("strValue ::",strValue)
            
            //appDelegate.flgForWebRefresh = true
            if appDelegate.flgForWebRefresh == true {  //For  updated content
                request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 10.0)
                webViewMore?.load(request)
                appDelegate.flgForWebRefresh = false
            }
            else {
                request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
                webViewMore?.load(request)
            }
        }
        
        btnOfA2.isUserInteractionEnabled = true
        btnOfA1.isUserInteractionEnabled = true
        btnOfA3.isUserInteractionEnabled = true
        btnOfA4.isUserInteractionEnabled = true
        btnOfA5.isUserInteractionEnabled = true
    }
        
   
    @IBAction func btnSliderA5Clk(_ sender: UIButton) {
        
        
        let contentType = 5
        self.slider.value = CGFloat(Float(contentType))
        let fixed = roundf(Float(slider.value / 1.0)) * 1.0
        slider.value = CGFloat(fixed)
        let currentValue = Int(slider.value)
        self.viewHeightConstraint.constant = 667
        if let strContent = dicMediaData.value(forKey: "contenturl") {
            UserDefaults.standard.set(currentValue, forKey: "currentValue")
            let strValue = "\(strContent)&page=7"
            print("strValue ::",strValue)
            
            //appDelegate.flgForWebRefresh = true
            if appDelegate.flgForWebRefresh == true {  //For  updated content
                request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 10.0)
                webViewMore?.load(request)
                appDelegate.flgForWebRefresh = false
            }
            else {
                request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
                webViewMore?.load(request)
            }
        }
        
        btnOfA2.isUserInteractionEnabled = true
        btnOfA1.isUserInteractionEnabled = true
        btnOfA3.isUserInteractionEnabled = true
        btnOfA4.isUserInteractionEnabled = true
        btnOfA5.isUserInteractionEnabled = true
    }
    
    
    @objc func slidervalueChanged(_ sender: TGPDiscreteSlider) {
    
        print("In slidervalueChanged ")
       
        let fixed = roundf(Float(sender.value / 1.0)) * 1.0
        //sender.setValue(fixed, animated: true)
        sender.value = CGFloat(fixed)
        let currentValue = Int(sender.value)
        self.viewHeightConstraint.constant = 667
        if currentValue == 1 {
            
            btnOfA2.isUserInteractionEnabled = true
            btnOfA1.isUserInteractionEnabled = false
            btnOfA3.isUserInteractionEnabled = true
            btnOfA4.isUserInteractionEnabled = true
            btnOfA5.isUserInteractionEnabled = true
            
            
            if let strContent = dicMediaData.value(forKey: "contenturl") {
                UserDefaults.standard.set(currentValue, forKey: "currentValue")
                let strValue = "\(strContent)&page=1"
               //webViewMore?.loadUrl(string: strValue)
                
                //appDelegate.flgForWebRefresh = true
                if appDelegate.flgForWebRefresh == true {  //For  updated content
                    request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 10.0)
                    webViewMore?.load(request)
                    appDelegate.flgForWebRefresh = false
                }
                else {
                    request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
                    webViewMore?.load(request)
                }
            }
        }
        else if currentValue == 2 {
            
            btnOfA2.isUserInteractionEnabled = false
            btnOfA1.isUserInteractionEnabled = true
            btnOfA3.isUserInteractionEnabled = true
            btnOfA4.isUserInteractionEnabled = true
            btnOfA5.isUserInteractionEnabled = true
            
            if let strContent = dicMediaData.value(forKey: "contenturl") {
                UserDefaults.standard.set(currentValue, forKey: "currentValue")
                let strValue = "\(strContent)&page=3"
                
                //appDelegate.flgForWebRefresh = true
                if appDelegate.flgForWebRefresh == true {  //For  updated content
                    request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 10.0)
                    webViewMore?.load(request)
                    appDelegate.flgForWebRefresh = false
                }
                else {
                    request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
                    webViewMore?.load(request)
                }
            }
        }
        else if currentValue == 3 {
            
            btnOfA2.isUserInteractionEnabled = true
            btnOfA1.isUserInteractionEnabled = true
            btnOfA3.isUserInteractionEnabled = false
            btnOfA4.isUserInteractionEnabled = true
            btnOfA5.isUserInteractionEnabled = true
            
            if let strContent = dicMediaData.value(forKey: "contenturl") {
                UserDefaults.standard.set(currentValue, forKey: "currentValue")
                let strValue = "\(strContent)&page=5"
               // webViewMore?.loadUrl(string: strValue)
                //appDelegate.flgForWebRefresh = true
                if appDelegate.flgForWebRefresh == true {  //For  updated content
                    request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 10.0)
                    webViewMore?.load(request)
                    appDelegate.flgForWebRefresh = false
                }
                else {
                    request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
                    webViewMore?.load(request)
                }
             }
        }
                //New Added slider val
            else if currentValue == 4 {
                
                btnOfA2.isUserInteractionEnabled = true
                btnOfA1.isUserInteractionEnabled = true
                btnOfA3.isUserInteractionEnabled = true
                btnOfA4.isUserInteractionEnabled = false
                btnOfA5.isUserInteractionEnabled = true
            
            if let strContent = dicMediaData.value(forKey: "contenturl") {
                    UserDefaults.standard.set(currentValue, forKey: "currentValue")
                    let strValue = "\(strContent)&page=6"
                    // webViewMore?.loadUrl(string: strValue)
                //appDelegate.flgForWebRefresh = true
                if appDelegate.flgForWebRefresh == true {  //For  updated content
                    request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 10.0)
                    webViewMore?.load(request)
                    appDelegate.flgForWebRefresh = false
                }
                else {
                    request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
                    webViewMore?.load(request)
                }
                }
            }
        else if currentValue == 5 {
            
            btnOfA2.isUserInteractionEnabled = true
            btnOfA1.isUserInteractionEnabled = true
            btnOfA3.isUserInteractionEnabled = true
            btnOfA4.isUserInteractionEnabled = true
            btnOfA5.isUserInteractionEnabled = false
            
            if let strContent = dicMediaData.value(forKey: "contenturl") {
                UserDefaults.standard.set(currentValue, forKey: "currentValue")
                let strValue = "\(strContent)&page=7"
                // webViewMore?.loadUrl(string: strValue)
//                request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
//                webViewMore?.load(request)
                
                //appDelegate.flgForWebRefresh = true
                if appDelegate.flgForWebRefresh == true {  //For  updated content
                    request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 10.0)
                    webViewMore?.load(request)
                    appDelegate.flgForWebRefresh = false
                }
                else {
                    request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
                    webViewMore?.load(request)
                }
            }
        }
    }
    
    
    func changeWebViewFontSize(textSzie: Int, webKitView: WKWebView){
        let jsString = "document.getElementsByTagName('body')[0].style.fontSize='\(textSzie)px'"
        webViewMore?.evaluateJavaScript(jsString, completionHandler: nil)
    }
    
    //MARK:- Audio Player
    @IBAction func btnAudioPlayClick(_ sender: Any) {
       
        let playingRate = String(UserDefaults.standard.float(forKey: "PlayerRate")) + "x"
        let strValueCurrent = playingRate.replacingOccurrences(of: ".0", with: "")
        if strValueCurrent == self.btnPlayRateAudio.currentTitle! {
            if (player?.isPlaying)! {
                self.player?.rate = UserDefaults.standard.float(forKey: "PlayerRate")
                player?.pause()
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            }else {
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                self.player?.rate = UserDefaults.standard.float(forKey: "PlayerRate")
            }
        }
        else {
            if (player?.isPlaying)! {
                player?.pause()
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            }else {
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                player?.play()
            }
        }
        
        if flagUI != "3" {
            updateInfo()
        }else {
            //do nothing
            MPRemoteCommandCenter.shared().changePlaybackPositionCommand.isEnabled = false
            MPRemoteCommandCenter.shared().togglePlayPauseCommand.isEnabled = false
            MPRemoteCommandCenter.shared().skipBackwardCommand.isEnabled = false
            MPRemoteCommandCenter.shared().seekBackwardCommand.isEnabled = false
            
            MPRemoteCommandCenter.shared().skipForwardCommand.isEnabled = false
            MPRemoteCommandCenter.shared().seekForwardCommand.isEnabled = false
            
            MPRemoteCommandCenter.shared().playCommand.isEnabled = false
            MPRemoteCommandCenter.shared().pauseCommand.isEnabled = false
        }
    }
    
    @IBAction func btnVolumeClick(_ sender: Any) {
    
        if flagUI == "2" || flagUI == "4"{
            if (self.btnAudioVolume.currentImage?.isEqual(#imageLiteral(resourceName: "Volume")))! {
                self.btnAudioVolume.setImage(#imageLiteral(resourceName: "mute"), for: .normal)
                player?.isMuted = true
            }else {
                self.btnAudioVolume.setImage(#imageLiteral(resourceName: "Volume"), for: .normal)
                player?.isMuted = false
            }
        }else if flagUI == "6"{
            flagUI = "3"
            
            self.headerImage.isHidden = true
            self.imageViewHeightConstraint.constant = 220
            self.viewOfVideoPlayer.isHidden = false
            self.heightofVideoView.constant = 220
            videoBottonConstraint.constant = 5
            videoBottonConstraint.isActive = true
            self.player1.displayView.removeFromSuperview()
            //self.viewofAudio.removeFromSuperview()
            
            viewOfVideoPlayer.addSubview(self.player1.displayView)
            self.player?.pause()
            self.player1.backgroundMode = .suspend
            self.player1.delegate = self
            self.player1.displayView.delegate = self
            self.player1.displayView.snp.makeConstraints { [weak self] (make) in
                guard let strongSelf = self else { return }
                make.top.equalTo(strongSelf.viewOfVideoPlayer.snp.top)
                make.left.equalTo(strongSelf.viewOfVideoPlayer.snp.left)
                make.right.equalTo(strongSelf.viewOfVideoPlayer.snp.right)
                make.height.equalTo(220).multipliedBy(9.0/16.0)
            }
            self.player1.displayView.isHidden = false
            
            webViewMore?.bottomAnchor.constraint(equalTo: btnBottomSignMe.topAnchor, constant: -7.5).isActive = true
            webViewMore?.reload()
            //self.player1.
            if self.condtnID == "6" {
                updateTime()
                var strArry = [String]()
                strArry = strViewedDuration.components(separatedBy: ":")
                
                if strViewedDuration == "" {
                    self.strVideoTime = "00:00:00"
                }else if strArry.count == 2 {
                    self.strVideoTime = "00:" + (strViewedDuration)
                }else {
                    self.strVideoTime = strViewedDuration
                }
                print("self.strVideoTime ",self.strVideoTime)
                videoAudioPlayer(urlStr: strVideoUrl, StrstartTime: self.strVideoTime)
            }else {
                videoAudioPlayer(urlStr: strVideoUrl, StrstartTime: "00:00:00")
            }
        }
     }
    
    
    @IBAction func btnPlayRateAuidoClk(_ sender: Any) {
        
        let arryOfSize = ["1x","1.25x","1.5x","1.75x","2x"]//,"2.5x","3x"
        
        dropDown.dataSource = arryOfSize
        dropDown.selectionAction = { [unowned self] (index , item) in
            var strValueCurrent = item
            self.strValue = item
            strValueCurrent = strValueCurrent.replacingOccurrences(of: "x", with: "")
            self.player?.rate = Float(strValueCurrent)!
            self.btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self.btnPlayRateAudio.setTitle(item, for: .normal)
            UserDefaults.standard.set(Float(strValueCurrent), forKey: "PlayerRate")
        }
        dropDown.anchorView = btnPlayRateAudio
        dropDown.width = 70
        dropDown.bottomOffset = CGPoint(x: 0, y:62)
        dropDown.backgroundColor = UIColor().HexToColor(hexString: "#302E30")//UIColor.white
        dropDown.textColor = UIColor.white
        
        if dropDown.isHidden{
            dropDown.show()
        } else{
            dropDown.hide()
        }
    }
    
    @IBAction func btnForwordClk(_ sender: Any) {
        let time = (player?.currentTime())! + CMTimeMake(Int64(15), 1)
        print("FastForwrd time ",time)
        self.btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        let playingRate = String(UserDefaults.standard.float(forKey: "PlayerRate")) + "x"//self.strValue
        if playingRate != "" {
            let strValueCurrent = playingRate.replacingOccurrences(of: "x", with: "")
            self.player?.rate = Float(strValueCurrent)!
        }else {
            self.player?.play()
        }
        player?.seek(to: time)
        if flagUI != "3" {
            updateInfo()
        }else {
            //do nothing
            MPRemoteCommandCenter.shared().changePlaybackPositionCommand.isEnabled = false
            MPRemoteCommandCenter.shared().togglePlayPauseCommand.isEnabled = false
            MPRemoteCommandCenter.shared().skipBackwardCommand.isEnabled = false
            MPRemoteCommandCenter.shared().seekBackwardCommand.isEnabled = false
            
            MPRemoteCommandCenter.shared().skipForwardCommand.isEnabled = false
            MPRemoteCommandCenter.shared().seekForwardCommand.isEnabled = false
            
            MPRemoteCommandCenter.shared().playCommand.isEnabled = false
            MPRemoteCommandCenter.shared().pauseCommand.isEnabled = false
        }
    }
    
    @IBAction func btnBackwordClk(_ sender: Any) {
        let time = (player?.currentTime())! - CMTimeMake(Int64(15), 1)
        print("Backword time ",time)
        self.btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        let playingRate = String(UserDefaults.standard.float(forKey: "PlayerRate")) + "x"//self.strValue
        if playingRate != "" {
            let strValueCurrent = playingRate.replacingOccurrences(of: "x", with: "")
            self.player?.rate = Float(strValueCurrent)!
        }else {
            self.player?.play()
        }
        player?.seek(to: time)
        if flagUI != "3" {
            updateInfo()
        }else {
            //do nothing
            MPRemoteCommandCenter.shared().changePlaybackPositionCommand.isEnabled = false
            MPRemoteCommandCenter.shared().togglePlayPauseCommand.isEnabled = false
            MPRemoteCommandCenter.shared().skipBackwardCommand.isEnabled = false
            MPRemoteCommandCenter.shared().seekBackwardCommand.isEnabled = false
            
            MPRemoteCommandCenter.shared().skipForwardCommand.isEnabled = false
            MPRemoteCommandCenter.shared().seekForwardCommand.isEnabled = false
            
            MPRemoteCommandCenter.shared().playCommand.isEnabled = false
            MPRemoteCommandCenter.shared().pauseCommand.isEnabled = false
        }
    }
    
    func playSoundWith(urlString:String, strDuration: String) -> Void{
        self.flagFroAudiVideo = "2"
        UIApplication.shared.isStatusBarHidden = false
        //self.viewofAudio.isHidden = false
        self.heightofVideoView.constant = 100
        self.viewOfVideoPlayer.addSubview(viewofAudio)
        self.viewOfVideoPlayer.bringSubview(toFront: viewofAudio)
        print("answer URl ",urlString)
        
        //vishal
        var startTime :CMTime = CMTimeMake(00, 1);
        if strSec == "2"{
            startTime = CMTimeMake(Int64(strDuration)!, 1);
            print("sec startTime ",strDuration)
            strSec = "1"
        }else if strMint == "2"{
            startTime = CMTimeMake((Int64(strDuration)! * 60), 1);
            print("strMint startTime ",strDuration)
            strMint = "1"
        }else if strHr == "2"{
            startTime = CMTimeMake((Int64(strDuration)! * 60 * 60), 1);
            print("strHr startTime ",strDuration)
            strHr = "1"
        }
        
        if playerFlag == 0{
            do {
                //try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
                let session = AVAudioSession.sharedInstance()
                let currentRoute = session.currentRoute
                for description in currentRoute.outputs{
                    if description.portType == AVAudioSessionPortLineOut {
                        print("Route: AVAudioSessionPortLineOut ")
                    }else if description.portType == AVAudioSessionPortHeadphones {
                        print("Route: AVAudioSessionPortHeadphones ")
                    }else if description.portType == AVAudioSessionPortBluetoothA2DP{
                        print("Route: AVAudioSessionPortBluetoothA2DP ")
                    }else if description.portType == AVAudioSessionPortBuiltInSpeaker{
                        print("Route: AVAudioSessionPortBuiltInSpeaker ")
                        try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
                    }else if description.portType == AVAudioSessionPortHDMI{
                        print("Route: AVAudioSessionPortHDMI ")
                    }else if description.portType == AVAudioSessionPortBluetoothLE{
                        print("Route: AVAudioSessionPortBluetoothLE ")
                    }else if description.portType == AVAudioSessionPortBluetoothHFP{
                        print("Route: AVAudioSessionPortBluetoothHFP ")
                    }else {
                        do {
                            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.allowBluetooth)
                        }catch {
                            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
                        }
                    }
                }
                /*
                 let auidoUrl = URL(string:urlString as String)!
                 print("auidoUrl :",auidoUrl)
                 player = AVPlayer(url: auidoUrl)
                 */
                let auidoUrl : URL! = URL(string:urlString)
                self.playerFlag = 2
                print("auidoUrl ",auidoUrl)
                btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                player = AVPlayer(url: auidoUrl!)
                player?.seek(to: startTime)
                
                Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
                player?.play()
                if #available(iOS 10.0, *) {
                    player?.automaticallyWaitsToMinimizeStalling = false
                } else {
                    //Fallback on earlier versions
                }
                player?.rate = UserDefaults.standard.float(forKey: "PlayerRate")
                self.btnPlayRateAudio.setTitle("\(Int(UserDefaults.standard.float(forKey: "PlayerRate")))x", for: .normal)
            } catch let error {
                print("error ",error.localizedDescription)
            }
        }else {
            playerFlag = 0
            self.player?.pause()
            btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            let currtnDuartion = CMTimeGetSeconds((player?.currentTime())!)
            let totalDuration = CMTimeGetSeconds((player?.currentItem?.asset.duration)!)
            progressViewAudio.setProgress(Float(currtnDuartion/totalDuration), animated: false)
        }
        
        if flagUI != "3" {
            updateInfo()
        }else {
            //do nothing
            MPRemoteCommandCenter.shared().changePlaybackPositionCommand.isEnabled = false
            MPRemoteCommandCenter.shared().togglePlayPauseCommand.isEnabled = false
            MPRemoteCommandCenter.shared().skipBackwardCommand.isEnabled = false
            MPRemoteCommandCenter.shared().seekBackwardCommand.isEnabled = false
            
            MPRemoteCommandCenter.shared().skipForwardCommand.isEnabled = false
            MPRemoteCommandCenter.shared().seekForwardCommand.isEnabled = false
            
            MPRemoteCommandCenter.shared().playCommand.isEnabled = false
            MPRemoteCommandCenter.shared().pauseCommand.isEnabled = false
        }
    }
    
    
    @objc func updateAudioProgressView() {
         if player?.isPlaying != nil {
            // Update progress
            let currtnDuartion = CMTimeGetSeconds((player?.currentTime())!)
            if player?.currentItem?.asset.duration != nil {
                let totalDuration = CMTimeGetSeconds((player?.currentItem?.asset.duration)!)
                progressViewAudio.setProgress(Float(currtnDuartion/totalDuration), animated: true)
            }
        }
    }
    
    
    @objc func handleInterruption(notification: Notification) {
        
        let userInfo = notification.userInfo
        let typeInt = userInfo![AVAudioSessionInterruptionTypeKey] as? UInt
        let type = AVAudioSessionInterruptionType(rawValue: typeInt!)
        
        switch type {
        case .began?:
            print("Pause your player")
            playerFlag = 0
            self.player?.pause()
            btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            
            self.player1.pause()
            self.player1.displayView.playButtion.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            
        case .ended?:
            if let optionInt = userInfo![AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSessionInterruptionOptions(rawValue: optionInt)
                if options.contains(.shouldResume) {
                    //Resume your player
                    print("Resume your player")
                }
            }
        case .none:
            print("none")
        }
    }
    
    func getDataForUIManagement() {
        if let strContent = self.dicMediaData.value(forKey: "contenturl") {
            let strValue = "\(strContent)"
            print("strValue ::",strValue)
            
            if strValue.count > 0 {
                self.btnBottomSignMe.isHidden = true
                self.request = URLRequest(url: URL(string: strValue)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
                self.webViewMore?.load(self.request)
            }
        }
        self.callData()
        self.loadData()
    }
    
    
    
    //MARK: - VideoPlayer
    func videoAudioPlayer(urlStr: String, StrstartTime: String){
        self.flagFroAudiVideo = "1"
        updateInfo()
        
        self.heightofVideoView.constant = 220
        player1.pause()
       
        let url = URL(string:urlStr)
        self.player1.replaceVideo(url!)
        
        let strTime : TimeInterval = parseDuration(timeString: StrstartTime)
        player1.seekTime(strTime)
        player1.play()
    }
    
    func parseDuration(timeString:String) -> TimeInterval {
        guard !timeString.isEmpty else {
            return 0
        }
        
        var interval:Double = 0
        let parts = timeString.components(separatedBy:":")
        for (index, part) in parts.reversed().enumerated() {
            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
        }
        return interval
    }
}
    
//MARK:- WebView Delegate
extension BlogPostViewController :WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let newURL = navigationAction.request.url,
                UIApplication.shared.canOpenURL(newURL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(newURL, options: ["":""], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
                
                print(newURL)
                print("Redirected to browser. No need to open it locally")
                decisionHandler(.cancel)
            } else {
                print("Open it locally")
                //decisionHandler(.allow)
                // handle phone and email links
                let url = navigationAction.request.url
                if url?.scheme == "tel" || url?.scheme == "mailto" {
                    if UIApplication.shared.canOpenURL(url!) {
                        //UIApplication.shared.openURL(url!)
                        UIApplication.shared.open(url!, options: ["" : ""], completionHandler: nil)
                        decisionHandler(.cancel)
                        print("Open it")
                        return
                    }
                }
                decisionHandler(.allow)
            }
        } else {
            print("not a user click")
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
       if btn2Type == "1" {
            btnBottomSignMe.isHidden = false
            heightOfbottomBtn.constant = 40
        }else {
            btnBottomSignMe.isHidden = true
            heightOfbottomBtn.constant = 0
        }
        btnBottomSignMe.backgroundColor = UIColor().HexToColor(hexString: bgColorBottomBtn)
        
        self.webViewMore?.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.webViewMore?.evaluateJavaScript("document.body.offsetHeight", completionHandler: { (height,
                    error) in
                    
                    //let formatter:SwiftyJSFormatter = SwiftyJSFormatter(tagName:nil)
                    //formatter.alignment = .center
                    
                    if self.flagUI == "4"{             //Audio,img text
                        let imgHeight : CGFloat = 458.0 //380.0
                        self.viewHeightConstraint.constant = (height as! CGFloat  + imgHeight + 80)
                    }
                    else if self.flagUI == "2" || self.flagUI == "6" {  //Audio n Text
                        let imgHeight : CGFloat = 268.0
                        self.viewHeightConstraint.constant = (height as! CGFloat  + imgHeight)
                    }
                    else if self.flagUI == "3" {  //vedio n text
                        let imgHeight : CGFloat = 438.0
                        self.viewHeightConstraint.constant = (height as! CGFloat  + imgHeight)
                    }
                    else if self.flagUI == "1" { //image and text
                        let imgHeight : CGFloat = 288.0
                        self.viewHeightConstraint.constant = (height as! CGFloat  + imgHeight + 150)
                    }
                    else  { //only text
                        let imgHeight : CGFloat = 188.0
                        self.viewHeightConstraint.constant = (height as! CGFloat  + imgHeight)
                    }
                })
            }
            print("error :::", error ?? "..")
        })
        
        
        //fail
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        guard let failingUrlStr = (error as NSError).userInfo["NSErrorFailingURLStringKey"] as? String  else { return }
        let failingUrl = URL(string: failingUrlStr)!
        
        switch failingUrl {
            
        case _ where failingUrlStr.starts(with: "mailto:"):
            if UIApplication.shared.canOpenURL(failingUrl) {
                UIApplication.shared.openURL(failingUrl)
                return
            }
        default: break
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("IN didFail :")
    }
    
    func viewForZooming(in: UIScrollView) -> UIView? {
        return nil
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        self.view.makeToast(string.someThingWrongMsg)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if flgToShow != "Help" {
            if(velocity.y>0) {
                UIView.animate(withDuration: 0.2, delay: 0, options:UIViewAnimationOptions.curveEaseIn, animations: {
                    self.btnQuestionMark.alpha = 0.0// Here you will get the animation you want
                }, completion: { _ in
                    self.btnQuestionMark.isHidden = true // Here you hide it when animation done
                })
            } else {
                UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.btnQuestionMark.alpha = 1.0// Here you will get the animation you want
                }, completion: { _ in
                    self.btnQuestionMark.isHidden = false // Here you hide it when animation done
                })
            }
        }
    }
}
//MARK:- Auido Delegate
extension BlogPostViewController {
  
    @objc func didfinishplaying(note : NSNotification){
        if UserDefaults.standard.string(forKey: "ArticleVideoFlag") == "1" {
            if self.flagFroAudiVideo == "2" {
                controller.dismiss(animated: true)
                playerFlag = 0
                progressViewAudio.setProgress(Float(0.0), animated: true)
                playSoundWith(urlString: strAudiourl, strDuration:"00:00:00")
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                player?.pause()
            }else {
                if flagUI == "3" &&  self.flagFroAudiVideo == "1"{
                    let url = URL(string:strVideoUrl)
                    self.player1.replaceVideo(url!)
                }else {
                    controller.dismiss(animated: true)
                    playerFlag = 0
                    progressViewAudio.setProgress(Float(0.0), animated: true)
                    playSoundWith(urlString: strAudiourl, strDuration:"00:00:00")
                    self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                    player?.pause()
                }
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.player?.pause()
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?){
        print("Error",error.debugDescription)
        self.player?.pause()
    }
    internal func audioPlayerBeginInterruption(_ player: AVAudioPlayer){
        print("Player",player.debugDescription)
        self.player?.pause()
    }
    
}

//MARK:- WS of Article
extension BlogPostViewController {
    
    func callWSOfArticle(){
        
        //URL  : https://cmspreview.membrandt.com/api/getArticleAboutUs?  appclientsId=1&userId=1&userPrivateKey=W9M9AgHGQ0Z0F429&appId=1
        //URL  : https://cmspreview.membrandt.com/api/getLegalScreen?appclientsId=1&userId=1&userPrivateKey=W9M9AgHGQ0Z0F429&appId=1
        
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId]
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))

        var strAPIFlag = ""
        if self.strTitle == "About Us" {
            strAPIFlag = "getArticleAboutUs?"
        }else {
            strAPIFlag = "getArticleAboutUs?"
        }
        
        strURL = Url.baseURL + strAPIFlag
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            self.startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSOfAboutLegal(strURL: strURL, dictionary: dictionary )
        }else{
            stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOfAboutLegal(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            print("getArticleAboutUs / getArticleAboutUs ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    if let data = JSONResponse["response"] as? [String:Any] {
                        self.dicMediaData = data as NSDictionary
                        print("self.dicMediaData" ,self.dicMediaData)
                        self.getDataForUIManagement() //function for loading data
                    }else{
                        self.btnTopSignMe.isHidden = true
                        self.viewofAudio.isHidden = true
                        self.btnOfPlus.isHidden = true
                        self.btnOfMinus.isHidden = true
                        self.btnQuestionMark.isHidden = true
                        self.viewOfAuther.isHidden = true
                        self.imgOfSemiCircle.isHidden = true
                        self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.oppsMsg, lableNoInternate: string.noDataFoundMsg)
                        self.view.addSubview(self.noDataView)
                    }
                }
            }
            else{
                let status = JSONResponse["status"] as? String
                self.stopActivityIndicator()
                switch status!{
                case "0":
                    print("error2: ")
                    if (JSONResponse["errorCode"] as? String) == userInfo.logOuterrorCode {
                        //When Parameter Missing and user ID, PrivateKey Wrong
                        let alrtTitleStr = NSMutableAttributedString(string: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String))
                        alrtTitleStr.addAttribute(NSAttributedStringKey.foregroundColor, value: color.alertTitleTextColor, range: NSRange(location: 0, length: alrtTitleStr.length))
                        
                        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value:(self.checkForFontType(fontStyle: fontAndSize.alertTitleFontStyle, fontSize: fontAndSize.alertTitleFontSize)) , range: NSRange(location: 0, length: alrtTitleStr.length))
                        
                        let alrtMessage = NSMutableAttributedString(string: string.privateKeyMsg)
                        alrtMessage.addAttribute(NSAttributedStringKey.foregroundColor, value: color.alertSubTitleTextColor, range: NSRange(location: 0, length: alrtMessage.length))
                        
                        alrtMessage.addAttribute(NSAttributedStringKey.font, value:(self.checkForFontType(fontStyle: fontAndSize.alertSubTitleFontStyle, fontSize: fontAndSize.alertSubTitleFontSize)) , range: NSRange(location: 0, length: alrtMessage.length))
                        
                        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                        alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                        alertController.setValue(alrtMessage, forKey: "attributedMessage")
                        
                        let btnOK = UIAlertAction(title: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!, style: .default, handler: { action in
                            DispatchQueue.main.async{
                                let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                                for aViewController in viewControllers {
                                    if aViewController is Login {
                                        self.navigationController!.popToViewController(aViewController, animated: true)
                                    }
                                }
                            }
                        })
                        
                        btnOK.setValue(color.alertWarningBtnTxtColor, forKey: "titleTextColor")
                        alertController.addAction(btnOK)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                    }else {
                        self.btnTopSignMe.isHidden = true
                        self.viewofAudio.isHidden = true
                        self.btnOfPlus.isHidden = true
                        self.btnOfMinus.isHidden = true
                        self.btnQuestionMark.isHidden = true
                        self.viewOfAuther.isHidden = true
                        self.imgOfSemiCircle.isHidden = true
                        self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: (JSONResponse["title"] as? String)!, lableNoInternate: ((JSONResponse["description"] as? String)! + "\n\(string.errodeCodeString) = [\((JSONResponse["systemErrorCode"] as? String)!)]"))
                        self.view.addSubview(self.noDataView)
                    }
                    break
                default:
                    self.btnTopSignMe.isHidden = true
                    self.viewofAudio.isHidden = true
                    self.btnOfPlus.isHidden = true
                    self.btnOfMinus.isHidden = true
                    self.btnQuestionMark.isHidden = true
                    self.viewOfAuther.isHidden = true
                    self.imgOfSemiCircle.isHidden = true
                    self.errorCodeAlert(title: (JSONResponse["title"] as? String)!, description: (JSONResponse["description"] as? String)!, errorCode: (JSONResponse["systemErrorCode"] as? String)!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)
                    print("error1: ");
                }
            }
        }, failure: { (error) in
            self.apiSuccesFlag = "2"
            self.stopActivityIndicator()
            print("error: ",error)
            DispatchQueue.main.async{
                self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.oppsMsg, lableNoInternate: string.someThingWrongMsg)
                self.view.addSubview(self.noDataView)
            }
        })
    }
    
    //MARK:- API of Update ArticleCount Count
    func callWSArticleUpdate(){
        //URL: http://27.109.19.234/app_builder/index.php/api/updateCount?appclientsId=1&userId=7&userPrivateKey=NzVxHjwaB6Sqm2u5&appId=1&itemType=2&id=3
        
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "itemType" : "2",
                          "id":self.strMenuId] as [String : Any] //,"id":self.strParentId
        
        print("I/P updateCount :",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "updateCount?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            //self.startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSUpdateArticleCount(strURL: strURL, dictionary: dictionary as! Dictionary<String, String>)
        }else{
            stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSUpdateArticleCount(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            self.stopActivityIndicator()
            print("JSONResponse updateCount : ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                
            }
            else{
                let status = JSONResponse["status"] as? String
                //self.stopActivityIndicator()
                //self.refreshControl.endRefreshing()
                switch status!{
                case "0":
                    print("error2: ",status!)
                    break
                default:
                    print("error1: ",status!);
                }
            }
        }, failure: { (error) in
            self.apiSuccesFlag = "2"
            //self.stopActivityIndicator()
            //self.refreshControl.endRefreshing()
            print("error: ",error)
        })
    }
}

//MARK:- favMenuDelagte
extension BlogPostViewController : favMenuDelagte {
    func homeBtnPress() {
        if validation.isConnectedToNetwork()  {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers
            for aViewController in viewControllers {
                if aViewController is HomeViewController {
                    //isVCFound = true
                    self.navigationController!.popToViewController(aViewController, animated: true)
                }
            }
        }
        else{
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func logOutBtnPress() {
        
        if validation.isConnectedToNetwork()  {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers
            for aViewController in viewControllers {
                if aViewController is Login {
                    //isVCFound = true
                    self.dismiss(animated: true, completion: nil)
                    self.navigationController!.popToViewController(aViewController, animated: true)
                }
            }
        }
        else{
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    func getSelectItem(SelecteItem: [String:Any]) {
        if((SelecteItem["type"] as? String) != nil){
            if SelecteItem["type"] as? String == "M"{
                //call getHomemenuList API with ID ==> PDF page no 47 >>> call CoursesList
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CoursesList") as! CoursesList
                vc.strMenuId = (SelecteItem["id"] as? String)!
                vc.strTitle = (SelecteItem["title"] as? String)!
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if SelecteItem["type"] as? String == "T"{
                if((SelecteItem["itemType"] as? String) != nil){
                    if SelecteItem["itemType"] as? String == "1"{ //itemType == 1 for corses
                        if ((SelecteItem["template_type"] as? String) != nil){
                            if SelecteItem["template_type"] as? String == "D"{
                                //call getCoursetopiclisting API ==>PDF page no 49-51 >>> DetailViewController
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                                vc.strCourseId = (SelecteItem["id"] as? String)!
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            }else if SelecteItem["template_type"] as? String == "F"{
                                //getallCourseData API ==>PDF page no 53 >>> CourseTemplateDetails
                                //getallCourseData API ==>PDF page no 53 >>> CourseTemplateDetails
                                UserDefaults.standard.set("0", forKey: "ArticleVideoFlag")
                                let nextVC = storyboard?.instantiateViewController(withIdentifier: "CourseTemplateDetails") as! CourseTemplateDetails
                                nextVC.StrCourseCatgryId = (SelecteItem["id"] as? String)!
                                self.navigationController?.pushViewController(nextVC, animated: true)
                            }
                        }
                    }else if SelecteItem["itemType"] as? String == "2"{ //itemType == 2 for Blog
                        UserDefaults.standard.set("2", forKey: "paymentFlag")
                        UserDefaults.standard.set("1", forKey: "ArticleVideoFlag")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogPostViewController") as! BlogPostViewController
                        vc.strMenuId = (SelecteItem["id"] as? String)!
                        vc.dicMediaData = (SelecteItem as? NSDictionary)!
                        vc.strTitle = (SelecteItem["title"] as? String)!
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
        
    }
}
//MARK:- Video Player Delegate
extension BlogPostViewController: VGPlayerDelegate {
    func updateTime() {
        // Access current item
        if let currentItem = player?.currentItem {
            // Get the current time in seconds
            let playhead = currentItem.currentTime().seconds
            let duration = currentItem.duration.seconds
            // Format seconds for human readable string
            strViewedDuration = "\(formatTimeFor(seconds: playhead))"
            print("Second ",strViewedDuration)
            print("Minuts ",formatTimeFor(seconds: duration))
            strDrtnTime = "\(formatTimeFor(seconds: playhead))"
        }else {
            strViewedDuration = "00:00:00"
        }
    }
    
    func formatTimeFor(seconds: Double) -> String {
        let result = getHoursMinutesSecondsFrom(seconds: seconds)
        let hoursString = "\(result.hours)"
        var minutesString = "\(result.minutes)"
        if minutesString.count == 1 {
            minutesString = "0\(result.minutes)"
        }
        var secondsString = "\(result.seconds)"
        if secondsString.count == 1 {
            secondsString = "0\(result.seconds)"
        }
        var time = "\(hoursString):"
        if result.hours >= 1 {
            time.append("\(minutesString):\(secondsString)")
        }
        else {
            time = "\(minutesString):\(secondsString)"
        }
        return time
    }
    
    func getHoursMinutesSecondsFrom(seconds: Double) -> (hours: Int, minutes: Int, seconds: Int) {
        print("seconds ",seconds)
        if !(seconds.isNaN){
            let secs = Int(seconds)
            let hours = secs / 3600
            let minutes = (secs % 3600) / 60
            let seconds = (secs % 3600) % 60
            return (hours, minutes, seconds)
        }else {
            let secs = Int(0)
            let hours = secs / 3600
            let minutes = (secs % 3600) / 60
            let seconds = (secs % 3600) % 60
            return (hours, minutes, seconds)
        }
    }
    
    
    func vgPlayer(_ player: VGPlayer, playerFailed error: VGPlayerError) {
        print("Error to play file ",error)
        //errorCodeAlert(title: "Error", description: "\(error)" , errorCode: "", okButton: "Ok")
    }
    
    func vgPlayer(_ player: VGPlayer, stateDidChange state: VGPlayerState) {
        print("player State ",state)
    }
    
    func vgPlayer(_ player: VGPlayer, bufferStateDidChange state: VGPlayerBufferstate) {
        print("buffer State", state)
    }
}

extension BlogPostViewController: VGPlayerViewDelegate {
    
    func vgPlayerView(_ playerView: VGPlayerView, willFullscreen fullscreen: Bool) {
       //playerView.exitFullscreen()
    }
    
    func vgPlayerView(didTappedClose playerView: VGPlayerView) {
        self.player?.pause()
        if playerView.isFullScreen {
            playerView.exitFullscreen()
        } else {
            self.player1.pause()
            self.player1.cleanPlayer()
            UIApplication.shared.isStatusBarHidden = false
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func vgPlayerView(didVideoFinished playerView: VGPlayerView) {
        print("Video Finished")
    }
    
    func vgPlayerView(didTappedonPreviousBtn playerView: VGPlayerView) {
        print("Previous taped")
    }
    
    func vgPlayerView(didTappedonNextBtn playerView: VGPlayerView) {
        print("Next taped")
    }
    
    func vgPlayerView(didDisplayControl playerView: VGPlayerView) {
         UIApplication.shared.isStatusBarHidden = false
        /* //UIApplication.shared.setStatusBarHidden(!playerView.isDisplayControl, with: .fade)
        if flagGoback == "1" {
            UIApplication.shared.isStatusBarHidden = false
        }
        else {
            UIApplication.shared.isStatusBarHidden = !playerView.isDisplayControl
        }*/
        
    }
    func vgPlayerView(didTappedAudioVideoSwicthBtn playerView: VGPlayerView) {
        
        self.headerImage.isHidden = true
        self.imageViewHeightConstraint.constant = 100
        self.viewOfVideoPlayer.isHidden = false
        self.heightofVideoView.constant = 100
        self.btnAudioVolume.setImage(#imageLiteral(resourceName: "Video2"), for: .normal)
        self.player1.displayView.isHidden = true
        
        videoBottonConstraint.isActive = true
        videoBottonConstraint.constant = 5
        
        self.viewofAudio.isHidden = false
        self.viewOfVideoPlayer.addSubview(viewofAudio)
        self.viewOfVideoPlayer.bringSubview(toFront: viewofAudio)
        
        webViewMore?.reload()
        self.flagUI = "6"
        self.player1.pause()
        playerFlag = 0
        
        if self.condtnID == "6" {
            
            var strngTime :Double = 1.0
            var strArry1 = [String]()
            strngTime = self.player1.currentDuration
            strViewedDuration = String(formatTimeFor(seconds: strngTime))
            
            strArry1 = strViewedDuration.components(separatedBy: ":")
            
            var strTemp = ""
            if strArry1.count == 2 {
                strTemp = "00:" + (strViewedDuration)
            }else {
                strTemp = strViewedDuration
            }
            
            let strArry = strTemp.components(separatedBy: ":")
            if !(strArry[0] == "00") {
                self.strAudioTime = strArry[0]
                self.strHr = "2"
            }else if !(strArry[1] == "00"){
                self.strAudioTime = strArry[1]
                self.strMint = "2"
            }else if !(strArry[2] == "00"){
                self.strAudioTime = strArry[2]
                self.strSec = "2"
            }else {
                self.strAudioTime = "00"
            }
            print("Str Audio Time: ",self.strAudioTime)
            
            strAudiourl = strVideoUrl
            playSoundWith(urlString: strAudiourl, strDuration: self.strAudioTime)
        }else {
            playSoundWith(urlString: strAudiourl, strDuration: "00:00:00")
        }
    }
}

// ---------------------------------------------------------------------
extension UIApplication {
    var icon: UIImage? {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? NSDictionary,
            let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? NSDictionary,
            let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? NSArray,
            // First will be smallest for the device class, last will be the largest for device class
            let lastIcon = iconFiles.lastObject as? String,
            let icon = UIImage(named: lastIcon) else {
                return nil
        }
        
        return icon
    }
}



