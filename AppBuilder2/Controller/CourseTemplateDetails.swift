//
//  CourseTemplateDetails.swift
//  AppBuilder2
//
//  Created by VISHAL on 05/03/18.
//  Copyright © 2018 VISHAL. All rights reserved.


import UIKit
import AVKit
import AVFoundation
import WebKit
import Alamofire
import VGPlayer
import SnapKit
import MediaPlayer

class CourseTemplateDetails: UIViewController,NVActivityIndicatorViewable,AVAudioRecorderDelegate,AVAudioPlayerDelegate {

    var arrlesson = [Lessons]()
    var arrlecture = [Lectures]()
    var idForCurrentPlayingItem = ""    //MARK: video Player
    var player1 : VGPlayer = {
        let playeView = VGCustomPlayerView()
        let playe = VGPlayer(playerView: playeView)
        return playe
    }()
    
    var switchingFlag = "1"
    var flagGoback = "0"
    var audioProgssValue = 0.0
    var flagForProgress = "1"
    var flagMangePlayCondtn = ""
    var appInBackgrnd = "1"
    
    var headerCell = QATableViewCell()
    var lessonCell = VideoDetailCell()
    var heightVideoDisplayView:CGFloat = 211 //NewChange
    @IBOutlet weak var topofVideoView: NSLayoutConstraint!
    @IBOutlet weak var downloadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var heightOfVideoView: NSLayoutConstraint!
    @IBOutlet weak var viewInsideScrollView: UIView!
    @IBOutlet weak var btnAskWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewOfVideoPlayer: UIView!
    @IBOutlet weak var lblAllQuestion: UILabel!
    @IBOutlet weak var lblMyQuestion: UILabel!
    @IBOutlet weak var lblDownloadingStatus: UILabel!
    @IBOutlet weak var switchQuestions: UISwitch!
    @IBOutlet weak var tblViewQA: UITableView!
    //Define the Player Object
    var controller = AVPlayerViewController()
    //CustomAVPlayerViewController()
    var player : AVPlayer?
    var plyerLayer = AVPlayerLayer()

    @IBOutlet weak var parentScrollView: UIScrollView!
    @IBOutlet weak var courseDetailTableView: UITableView!
    
    @IBOutlet weak var WidthOfBtnQA: NSLayoutConstraint!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var btnResourc: UIButton!
    @IBOutlet weak var btnQA: UIButton!
    @IBOutlet weak var btnLessons: UIButton!
    @IBOutlet weak var btnDownloadAll: UIButton!
    @IBOutlet weak var btnMoreConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnResourcConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnQAconstraint: NSLayoutConstraint!
    @IBOutlet weak var btnLessonConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgDownloadAll: UIImageView!
    @IBOutlet weak var lblOfVideoTitle: UILabel!
    @IBOutlet weak var lblOfVideoDricptn: UILabel!
    
    @IBOutlet weak var BtnASKQuestn: UIButton!
    
    var goingUp: Bool? //to track is scrollView is going up or down
    var childScrollingDownDueToParent = false
    
    var selectedRow:Int?
    var selectedSection:Int?
    var selectedIndexPath = [IndexPath]()
    var playVideoArray = IndexPath()
   
    var webViewResources: WKWebView?
    var webViewMore: WKWebView?

    var expandabaleSection : NSMutableSet = []
    
    var leftSwipe:Int = -1
    var rightSwipe:Int = -1
    var bottomTextSize: Int = 20
    
    var userType :String = ""
    
    let dropDown = DropDown()
    
    //API
    var appDelegate : AppDelegate!
    var chache = NSCache<AnyObject,AnyObject>()
    var flgActivity = true
    var flgActivity1 = true
    var timeOut: Timer!
    var apiSuccesFlag = ""
    var arryWSLessonData = [String:Any]()
    var arryWSQuestionData = [[String:Any]]()
    var arrAllQuestion = [[String :Any]]()
    var arrOfflineData = [[String:Any]]()
    var noDataView = UIView()
    var refreshControl: UIRefreshControl!
    var StrCourseCatgryId = ""
    var StrCourseTopicId = ""
    var nextPlayCheckFlag = ""
    var topicId = ""
    var lectureId = ""
    var courseId = ""
    var questionType : String = "0"
    var markReadFlag:String = ""
    
    var question_id:String = ""
    var callServiceFlag = ""
    
    var getJsonData: [String:Any]?
    var commonElement = [String:Any]()
    var lessonElement = [String:Any]()
    var NavBgcolor = ""
    var txtNavcolorHex = ""
    var NavTxtSize = 15
    var NavTxtStyle = ""
    var GenarlTxtcolorHex = ""
    var ActiveBgColor = ""
    var ActiveTxtcolorHex = ""
    var Activefontstyle = ""
    var ActivesizeInt = 15
    var downloadColor = ""
    var progressColor = ""
    
    var InActiveBgColor = ""
    var InActiveTxtcolorHex = ""
    var InActivefontstyle = ""
    var InActivesizeInt = 15
    
    var lessnActvTxtColor = ""
    var lessnInActvTxtColor = ""
    var strCount = 0
    var row = 0
    var playContrlHide = "0"
    var finishFlag = "0"
    var flagVideoPlayId = ""
    var FlagAppInBack = ""
    var flagFroAudiVideo = "1"
    var strVideoTitleLine = 1
    var askFlag = ""
    var allowCmntFlag = ""
    var isDisplayAlltopic = ""
    //Recording UI
    @IBOutlet weak var mianBgviewOfRecording: UIView!
    @IBOutlet weak var bgView2Recording: UIView!
    @IBOutlet weak var viewOfCircle: UIView!
    @IBOutlet weak var viewOfWaves: UIView!
    @IBOutlet weak var imngOfWaves: UIImageView!
    @IBOutlet weak var lblOfAudioCount: UILabel!
    @IBOutlet weak var imgOfHalfCircle: UIImageView!
    @IBOutlet weak var btnSendRecording: UIButton!
    @IBOutlet weak var btnCancleRecording: UIButton!
    @IBOutlet weak var btnStartRecording: UIButton!
    
    //Recording player
    var recordingSession : AVAudioSession!
    var audioRecorder    :AVAudioRecorder!
    var settings         = [String : Int]()
    
    var audioPlayer : AVAudioPlayer!
    var recordingFlag = 0
    var recordingURl : NSURL!
    
    var sennderTag = 0
    var playerFlag = 0
    var strSection = 0
    var timerTest : Timer?
    
    //Variable delecration.
    var lastIndexLectID = ""
    var strCourseTopicsPlayingTd = ""
    var strLectPlayingTd = ""
    var autoPlay = "1"
    var strCourseTopicsLecturesId = ""
    var strViewedDuration = ""
    var strNextCoursTopicLecturesId = ""
    var lastPlayedVideo = ""
    var playStatus = "1"
    var strMusiclayer = "1"
    var strVideoURl = ""
    var i:Float = 1
    var strAudioUrl = ""
    var strVideoTime = ""
    var strAudioTime = ""
    var strDutnTime = ""
    var strSec = "1"
    var strMint = "1"
    var strHr = "1"
    var titleForAudioPlayer = ""
    var subTilteForAudioPlayer = ""
    var strLastVideAudioDuration = ""
    var urlAudioPlayerImg = ""
    //var currentNextArryIndex = 0
    
    var seconds = 0.0 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var recordingTimer = Timer()
    var isTimerRunning = false //This will be used to make su
    
    @IBOutlet weak var heightOfBgView2: NSLayoutConstraint!
    @IBOutlet weak var heightOfViewOfCircl: NSLayoutConstraint!
    
    var downloadAll:Bool = false
    var videoURL = [String]()
    
    var isAnimating:Bool = false
    var isDownloaded:Bool = false
    
    var getNameAndURL = [String:Any]()
    
    var dictNameUrl = NSMutableDictionary()
    var arrNameUrl = NSMutableArray()
    
    var header: UIView!
    var offset:CGFloat = 0
    var internetGone = false
    var fileTypeFlag = "0"
    
    
    var resource_content = ""
    var more_content = ""
    var strValue = ""
    var lesson_bgColor = ""
    var strThumbnailURl = ""
    var localOfflineData = [[String:Any]]()
    var playAudioVideoArry = [[String:Any]]()
    var nextAudioVideoArry = [[String:Any]]()
    
    var nextAudiVidLecID = ""
    var nextAudiVidTopicID = ""
    var commomdCentre = MPRemoteCommandCenter.shared()
    var flagForWeb = ""
    
    //Audio Player UI
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewofAudio: UIView!
    @IBOutlet weak var btnAudioBackword: UIButton!
    @IBOutlet weak var btnPlayRateAudio: UIButton!
    @IBOutlet weak var btnAudioPlay: UIButton!
    @IBOutlet weak var btnAudioForword: UIButton!
    @IBOutlet weak var btnAudioVolume: UIButton!
    @IBOutlet weak var progressViewAudio: UIProgressView!
    
    //View of Audio
    @IBOutlet weak var widthOfAudioViewSwitch: NSLayoutConstraint!
    @IBOutlet weak var bgStatusView: UIView!
    
    // MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NewChange
        //heightVideoDisplayView = ceil((360/640)*self.view.frame.size.width)
        heightVideoDisplayView = (360/640)*self.view.frame.size.width
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [.allowBluetooth])
            UIApplication.shared.beginReceivingRemoteControlEvents()
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }

        //Handling interruptions of Audio player
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption(notification:)), name: .AVAudioSessionInterruption, object: nil)
        
        
        print("All_Files-\(listFilesFromDocumentsFolder()!)")
      
        self.lblDownloadingStatus.isHidden = true
        self.downloadIndicator.isHidden = true
        self.parentScrollView.isScrollEnabled = true
        
        refreshControl = UIRefreshControl()
        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblViewQA.addSubview(refreshControl)
       
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        getJsonData =  appDelegate.jsonData
        
        self.mianBgviewOfRecording.isHidden = true
        getUIForLesson()
        
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
        NotificationCenter.default.addObserver(self,selector: #selector(handleRouteChanges),name: .AVAudioSessionRouteChange,
                                               object: AVAudioSession.sharedInstance())
        
        // Audio Settings
        settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.AVPlayerItemDidPlayToEndTime , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CourseTemplateDetails.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:nil)
        
        //for Oriantation
        NotificationCenter.default.addObserver(self, selector: #selector(CourseTemplateDetails.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

        
        //vishal - add in app delegatew also
        NotificationCenter.default.addObserver(self, selector: #selector(appInBackGround), name: NSNotification.Name(rawValue:"applicationInBackground"), object: nil)
        
        //Notification : applicationResignActive
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue:"applicationResignActive"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appResignActive), name: NSNotification.Name(rawValue:"applicationResignActive"), object: nil)
        
        
        //let url = "http://devstreaming.apple.com/videos/wwdc/2016/102w0bsn0ge83qfv7za/102/hls_vod_mvp.m3u8"
        controller.view.removeFromSuperview()
       
        let webViewConfiguration = WKWebViewConfiguration()
        webViewResources = WKWebView(frame: .zero, configuration: webViewConfiguration)
        webViewResources?.scrollView.delegate = self
        webViewResources?.translatesAutoresizingMaskIntoConstraints = false
        webViewResources?.scrollView.backgroundColor = UIColor.clear
        webViewResources?.backgroundColor = UIColor.clear
        webViewResources?.isOpaque = false
        webViewResources?.uiDelegate = self
        webViewResources?.navigationDelegate = self
        parentScrollView.addSubview(webViewResources!)
        
        webViewResources?.topAnchor.constraint(equalTo: btnResourc.bottomAnchor, constant: 0).isActive = true
        webViewResources?.leftAnchor.constraint(equalTo: parentScrollView.leftAnchor).isActive = true
        webViewResources?.rightAnchor.constraint(equalTo: parentScrollView.rightAnchor).isActive = true
        webViewResources?.widthAnchor.constraint(equalTo: parentScrollView.widthAnchor).isActive = true
        webViewResources?.bottomAnchor.constraint(equalTo: parentScrollView.bottomAnchor, constant: -80).isActive = true
        
        webViewResources?.scrollView.isScrollEnabled = true
        webViewResources?.scrollView.bounces = true
        webViewResources?.sizeToFit()
        
        let webViewConfiguration1 = WKWebViewConfiguration()
        webViewMore = WKWebView(frame: .zero, configuration: webViewConfiguration1)
        webViewMore?.scrollView.delegate = self
        webViewMore?.translatesAutoresizingMaskIntoConstraints = false
        webViewMore?.scrollView.backgroundColor = UIColor.clear
        webViewMore?.backgroundColor = UIColor.clear
        webViewMore?.isOpaque = false
        webViewMore?.uiDelegate = self
        webViewMore?.navigationDelegate = self
        parentScrollView.addSubview(webViewMore!)
        
        webViewMore?.topAnchor.constraint(equalTo: btnMore.bottomAnchor, constant: 0).isActive = true
        webViewMore?.leftAnchor.constraint(equalTo: parentScrollView.leftAnchor).isActive = true
        webViewMore?.rightAnchor.constraint(equalTo: parentScrollView.rightAnchor).isActive = true
        webViewMore?.widthAnchor.constraint(equalTo: parentScrollView.widthAnchor).isActive = true
        webViewMore?.bottomAnchor.constraint(equalTo: parentScrollView.bottomAnchor, constant: -80).isActive = true
        
        webViewMore?.scrollView.isScrollEnabled = true
        webViewMore?.scrollView.bounces = true
        webViewMore?.sizeToFit()
        
        parentScrollView.delegate = self
        
        switchQuestions.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        tblViewQA.isHidden = true
        webViewResources?.isHidden = true
        webViewMore?.isHidden = true
        
        askButtonConf()
        
        courseDetailTableView.tableFooterView = UIView()
        
        if DeviceType.IS_IPHONE_4_OR_LESS{
            heightOfBgView2.constant = 150
            heightOfViewOfCircl.constant = 150
        }else {
            heightOfBgView2.constant = 278
            heightOfViewOfCircl.constant = 278
        }
        
        /*/MARK:Video Initilization
        if  let srt = Bundle.main.url(forResource: "Despacito Remix Luis Fonsi ft.Daddy Yankee Justin Bieber Lyrics [Spanish]", withExtension: "srt") {
            let playerView = self.player1.displayView as! VGCustomPlayerView
            playerView.setSubtitles(VGSubtitles(filePath: srt))
        }*/
        //let url = URL(string:"Set Url link Here")
        //let url = URL(fileURLWithPath: Bundle.main.path(forResource: "2", ofType: "mp4")!)
        
        viewOfVideoPlayer.addSubview(self.player1.displayView)
        self.player?.pause()
        self.player1.backgroundMode = .suspend
        self.player1.delegate = self
        self.player1.displayView.delegate = self
        self.player1.displayView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
           //make.top.equalTo(strongSelf.viewOfVideoPlayer.snp.top)
            make.top.equalTo(0) //NewChange
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(strongSelf.viewOfVideoPlayer.snp.bottom)
        }
        //MARK: call ws
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("JsonData.json")
        if FileManager.default.fileExists(atPath: documentsURL.relativePath) {
            let response = retrieveFromJsonFile()["response"] as! [String:Any]
            if self.isDisplayAlltopic == "1"{
                let responseTopic = response["responseTopics"] as! [String:Any]
                if responseTopic.count != 0 {
                    if let data = responseTopic[self.StrCourseTopicId] as? Dictionary<String,Any> {
                        self.arryWSLessonData = data
                        self.configureUI()
                    }
                }else {
                    callWSOfLesson()
                }
            }else {
                let responseLesson = response["responseLesson"] as! [[String:Any]]
                if responseLesson.count != 0 {
                    for lesson in responseLesson {
                        if self.StrCourseCatgryId == lesson["course_id"] as! String {
                            self.arryWSLessonData = lesson
                            self.configureUI()
                            break
                        }
                    }
                }else {
                    callWSOfLesson()
                }
            }
        }else {
            callWSOfLesson()
        }
        
        //Notification call
        callWSNotifcnCuntUpdate()
    }
    
    //MARK: Ask button Configration
    func askButtonConf(){
        if userInfo.adminUserflag == "1" {
            btnAskWidthConstraint.constant = 0
            BtnASKQuestn.isHidden = true
            lblMyQuestion.text = (appDelegate.ArryLngResponeCustom!["unanswered"] as? String)!//"UnAnswered"
        }else {
            lblMyQuestion.text = (appDelegate.ArryLngResponeCustom!["my_questions"] as? String)!//"My Questions"
            if self.askFlag == "0"{
                btnAskWidthConstraint.constant = 0
                BtnASKQuestn.isHidden = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lanuageConversion()
        UserDefaults.standard.set("0", forKey: "ArticleVideoFlag")
        self.navigationController?.navigationBar.isHidden = true
        super.viewWillAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
        /*if DeviceType.IS_IPHONE_x{
            self.topofVideoView.constant =  40
        }else {
            self.topofVideoView.constant =  20
        }*/
        self.topofVideoView.constant =  UIApplication.shared.statusBarFrame.height //NewChange
        
        if self.flagMangePlayCondtn == "2"{
            self.player1.play()
        }else if self.flagMangePlayCondtn == "3" {
            self.player?.play()
            self.btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }else {
            self.player1.pause()
            self.player?.pause()
        }
       
    }
    
    func updateInfo() {
        
        if switchingFlag == "1" || self.flagFroAudiVideo == "1"{
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
            return
        }
        
        guard player?.currentItem != nil else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
            return
        }

        var image = UIImage()
        if self.urlAudioPlayerImg != ""{
            let imgUrl = self.urlAudioPlayerImg
            //print("Aduio image URl ",imgUrl )
            //let imageName = self.separateImageNameFromUrl(Url: imgUrl)
            if(self.chache.object(forKey: imgUrl as AnyObject) != nil){
                image = (self.chache.object(forKey: imgUrl as AnyObject) as? UIImage)!
                nowPlayingInfoAudio(imageName: image)
            }else{
                if validation.checkNotNullParameter(checkStr: imgUrl) == false {
                    Alamofire.request(imgUrl).responseImage{ response in
                        if let imageIcon = response.result.value {
                            image = imageIcon
                            self.chache.setObject(image, forKey: imgUrl as AnyObject)
                            self.nowPlayingInfoAudio(imageName: image)
                        }else {
                            image = UIApplication.shared.icon!
                            self.nowPlayingInfoAudio(imageName: image)
                        }
                    }
                }else {
                    image = UIApplication.shared.icon!
                    self.nowPlayingInfoAudio(imageName: image)
                }
            }
        }else {
            image = UIApplication.shared.icon!
            self.nowPlayingInfoAudio(imageName: image)
        }
    }
    
    func nowPlayingInfoAudio(imageName: UIImage){
        
        let mediaArtwork = MPMediaItemArtwork(boundsSize: imageName.size) { (size: CGSize) -> UIImage in
            return imageName
        }
        
        let nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyAlbumTitle: self.subTilteForAudioPlayer,
            MPMediaItemPropertyTitle: self.titleForAudioPlayer,
            MPMediaItemPropertyArtwork: mediaArtwork,
            MPMediaItemPropertyPlaybackDuration:  Float(CMTimeGetSeconds((player?.currentItem?.asset.duration)!)) ,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: Float(CMTimeGetSeconds((player?.currentTime())!)),
            MPNowPlayingInfoPropertyPlaybackRate: UserDefaults.standard.float(forKey: "PlayerRate")
        ]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    /*@objc func togglePlayStop(){ //
        print("funcation get called")
        player?.pause()
    }*/
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
    
    
    @objc func handleRouteChanges(_ notification: Notification) {
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
    
    private var popGesture: UIGestureRecognizer?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        
        if navigationController!.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
            self.popGesture = navigationController!.interactivePopGestureRecognizer
            self.navigationController!.view.removeGestureRecognizer(navigationController!.interactivePopGestureRecognizer!)
        }
        
        commomdCentre.togglePlayPauseCommand.addTarget(handler: { (event) in
            DispatchQueue.main.async {
                if let wd = UIApplication.shared.delegate?.window {
                    var vc = wd!.rootViewController
                    if(vc is UINavigationController){
                        vc = (vc as! UINavigationController).visibleViewController
                    }
                    if(vc is CourseTemplateDetails){
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
                            if !self.appDelegate.appInBackgrnd {
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
            }
            return MPRemoteCommandHandlerStatus.success
            
        })
        commomdCentre.changePlaybackPositionCommand.isEnabled = false
        
        commomdCentre.playCommand.addTarget { (playEvent) -> MPRemoteCommandHandlerStatus in
                self.player?.play()
                self.player1.play()
                self.player?.rate = UserDefaults.standard.float(forKey: "PlayerRate")
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                self.updateAudioProgressView()
            return .success
        }
        
        commomdCentre.pauseCommand.addTarget { (pauseEvent) -> MPRemoteCommandHandlerStatus in
                self.player?.pause()
                self.player1.pause() //ashwinee
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                self.updateAudioProgressView()
            return .success
        }
        
        // backword/forward audio rate
        commomdCentre.skipBackwardCommand.addTarget { (backword) -> MPRemoteCommandHandlerStatus in
            if self.player?.isPlaying != nil || self.player1.player?.isPlaying != nil{
                    let time = (self.player!.currentTime()) - CMTimeMake(Int64(15), 1)
                    self.player?.seek(to: time)
                    self.updateAudioProgressView()
                    self.updateInfo()
            }
            return .success
        }
        commomdCentre.skipForwardCommand.addTarget { (forword) -> MPRemoteCommandHandlerStatus in
            if self.player?.isPlaying != nil || self.player1.player?.isPlaying != nil{
                    let time = (self.player!.currentTime()) + CMTimeMake(Int64(15), 1)
                    self.player?.seek(to: time)
                    self.updateAudioProgressView()
                    self.updateInfo()
            }
            return .success
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        self.flagFroAudiVideo = "1"
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(0, for: .default)
        //UIApplication.shared.endReceivingRemoteControlEvents()
        //self.resignFirstResponder()
        self.flagFroAudiVideo = ""
        flagGoback = "1"
        self.player = nil
        let playerView = VGPlayerView()
        UIApplication.shared.isStatusBarHidden = false
        
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        
        if self.flagMangePlayCondtn == "2"{
            self.player?.pause()
            self.player1.pause()
        }else if self.flagMangePlayCondtn == "1"{
            self.player?.pause()
            self.player1.pause()
        }else {
            self.player?.pause()
            self.player1.pause()
            self.player1.cleanPlayer()
        }
        
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.AVPlayerItemDidPlayToEndTime , object:nil)
    }
    
    //MARK:- Langauge Conversion
    func lanuageConversion(){
        self.btnLessons.setTitle((appDelegate.ArryLngResponeCustom!["Lessons"] as? String)!, for: .normal) //Lessons
        self.btnQA.setTitle((appDelegate.ArryLngResponeCustom!["q_a"] as? String)!, for: .normal)//"Q&A"
        self.btnResourc.setTitle((appDelegate.ArryLngResponeCustom!["resources"] as? String)!, for: .normal)//"Resources"
        self.btnMore.setTitle((appDelegate.ArryLngResponeCustom!["more"] as? String)!, for: .normal)//"More..."
        self.BtnASKQuestn.setTitle((appDelegate.ArryLngResponeCustom!["ask"] as? String)!, for: .normal)//"Ask"
        self.lblAllQuestion.text = (appDelegate.ArryLngResponeCustom!["all_questions"] as? String)!//"All Questions"
    }
    
    @objc func canRotate() -> Void {}
    
    func downloadVideo(str:String) {
        
        if let audioUrl = URL(string: str) {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            print("destinationUrl ->\(destinationUrl)")
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                
                // if the file doesn't exist
            } else {
                
            // you can use NSURLSession.sharedSession to download the data asynchronously
            URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                guard let location = location, error == nil else { return }
                do {
                    // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: location, to: destinationUrl)
                    print("File moved to documents folder")
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }).resume()
        }
        }
    }
 
    func downloadFile(urlArray:NSMutableArray)->Void{
        
        let urlArrayTemp = urlArray
        
        let tempArray:[Int ] = urlArrayTemp.value(forKey: "isVideo") as! [Int]
        let tempFileArray = urlArrayTemp.value(forKey: "fileName") as! [NSURL]
        
        var tempVideoArray = [Int]()
        var tempFileNameArray = [NSURL]()
        var tempVideoCount = [NSURL]()
        
        for (index,element) in tempArray.enumerated() {
            if element == 1 {
                let fileName = tempFileArray[index]
                tempVideoArray.append(element)
                tempFileNameArray.append(fileName)
            }
        }
        for video in tempFileNameArray {
            let fileManager = FileManager.default
            let filePath = video.relativePath
            if fileManager.fileExists(atPath: filePath!) {
                tempVideoCount.append(video)
            }
        }
        let remainingCount = tempFileNameArray.count - tempVideoCount.count
        
        if let lastUrl = urlArrayTemp.lastObject{
            
            let singleObject = lastUrl as! NSDictionary
            
            if singleObject.value(forKey: "isVideo") as! Bool {
                let fileName = singleObject.value(forKey: "fileName") as! NSURL
                
                let filePath1 = fileName.relativePath
                
                let fileManager = FileManager.default
                // Check if file not exists
                if !fileManager.fileExists(atPath: filePath1!) {
                    let strUrl = singleObject.value(forKey: "filePath") as! String
                    self.showLabel(message: "\(remainingCount) videos started downloading")
                    self.imgDownloadAll.isHidden = true
                    self.btnDownloadAll.isHidden = true
                    self.downloadIndicator.startAnimating()
                    let manager = Alamofire.SessionManager.default
                    manager.session.configuration.timeoutIntervalForRequest = 10000
                    manager.request(strUrl).downloadProgress(closure : { (progress) in
                        print(progress.fractionCompleted)
                        if progress.fractionCompleted == 1.0 {
                            urlArrayTemp.removeLastObject()
                            if urlArrayTemp.count != 0 {
                                self.downloadFile(urlArray: urlArrayTemp)
                            }else{
                                self.downloadIndicator.stopAnimating()
                                self.imgDownloadAll.isHidden = false
                                self.btnDownloadAll.isHidden = false
                                self.imgDownloadAll.image = UIImage(named: "down-arrow-green")
                            }
                        }
                    }).responseData{ (response) in
                        
                        switch (response.result ) {
                        case .success(_):
                            
                            print(response)
                            print(response.result.value!)
                            print(response.result.description)
                            if let data = response.result.value {
                                do {
                                    try data.write(to: fileName as URL)
                                    self.showLabel(message: "1 video downloaded successfully")
                                    DispatchQueue.main.async {
                                        self.getAllDowloadFlag()
                                        self.courseDetailTableView.reloadData()
                                    }
                                    
                                } catch {
                                    print("Something went wrong!")
                                }
                                
                            }
                            break
                            
                        case .failure(let error):
                            if error._code == NSURLErrorNetworkConnectionLost {
                               
                                DispatchQueue.main.async {
                                    self.showLabel(message: string.noInternateMessage2)
                                    self.downloadAll = false
                                    self.internetGone = true
                                    self.downloadIndicator.stopAnimating()
                                    self.imgDownloadAll.isHidden = false
                                    self.btnDownloadAll.isHidden = false
                                    self.imgDownloadAll.image = UIImage(named: "down-arrow-gray")
                                    self.courseDetailTableView.reloadData()
                                }
                            }
                            else if error._code == NSURLErrorTimedOut {
                                
                                DispatchQueue.main.async {
                                    self.showLabel(message: string.noInternateMessage2)
                                    self.downloadAll = false
                                    self.internetGone = true
                                    self.downloadIndicator.stopAnimating()
                                    self.btnDownloadAll.isHidden = false
                                    self.imgDownloadAll.isHidden = false
                                    self.imgDownloadAll.image = UIImage(named: "down-arrow-gray")
                                    self.courseDetailTableView.reloadData()
                                }
                            }
                            else if error._code == NSURLErrorDownloadDecodingFailedMidStream {
                                print("error",error.localizedDescription)
                            }
                            break
                        }
                    }
                } else{
                    urlArrayTemp.removeLastObject()
                    if urlArrayTemp.count != 0 {
                        self.downloadFile(urlArray: urlArrayTemp)
                    }
                }
            }else{
                urlArrayTemp.removeLastObject()
                if urlArrayTemp.count != 0 {
                    self.downloadFile(urlArray: urlArrayTemp)
                }
            }
        }
    }
    
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)
        
        self.startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
        self.timeOut = Timer.scheduledTimer(timeInterval: 25.0, target: self, selector: #selector(Login.cancelWeb), userInfo: nil, repeats: false)
    }
    
    func stopActivityIndicator() {
        self.stopAnimating()
    }
    
    @objc func cancelWeb() {
        print("cancelWeb")
        if apiSuccesFlag == "1"{
            //self.view.makeToast(string.someThingWrongMsg)
            self.stopAnimating()
            self.refreshControl.endRefreshing()
//            self.refreshControl1.endRefreshing()
        }
    }
    
    @objc func refresh(_ sender:AnyObject){
        flgActivity = false
        self.timeOut = Timer.scheduledTimer(timeInterval: 25.0, target: self, selector: #selector(Login.cancelWeb), userInfo: nil, repeats: false)
        apiSuccesFlag = "1"
        callWSOfGetQuestion()
    }
    
    //vishal
    @objc func appInBackGround(){
        print("App in background")
        appInBackgrnd = "2"
        DispatchQueue.main.async {
            self.player1.pause()
            self.commomdCentre.playCommand.isEnabled = false
            self.commomdCentre.pauseCommand.isEnabled = false
        }
    }
    
    @objc func appResignActive(){
        //updateInfo()
    }
    
    @objc func rotated() {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            DispatchQueue.main.async() {
                self.topofVideoView.constant = UIApplication.shared.statusBarFrame.height
                //self.heightOfVideoView.constant = UIScreen.main.bounds.height
            }
            //UIApplication.shared.isStatusBarHidden = true
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
           
            UIApplication.shared.isStatusBarHidden = false
            /*if DeviceType.IS_IPHONE_x{
                self.topofVideoView.constant =  40
            }else {
                self.topofVideoView.constant =  20
            }*/
            self.topofVideoView.constant =  UIApplication.shared.statusBarFrame.height //NewChange
            if self.flagFroAudiVideo == "2" {
                self.viewofAudio.isHidden = false
                heightVideoDisplayView = 100
                self.heightOfVideoView.constant = 100
            }else {
                self.viewofAudio.isHidden = true
                //self.heightOfVideoView.constant = 240
                heightVideoDisplayView = (360/640)*self.view.frame.size.width
                self.heightOfVideoView.constant = heightVideoDisplayView //NewChange
            }
        }
    }
    
    func noDataLabel(str:String) {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tblViewQA.bounds.size.width, height: tblViewQA.bounds.size.height))
        label.text = str
        label.textColor = UIColor().HexToColor(hexString: NavBgcolor)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        tblViewQA.backgroundView  = label
        tblViewQA.separatorStyle  = .none
    }
    
    func sortQuestions(arr:[[String:Any]]) {
        let tempArr = arr
        if userInfo.adminUserflag == "1" {
            self.arryWSQuestionData.removeAll()
            for temp in tempArr {
                if temp["admin_respond"] as! String != "1" {
                    self.arryWSQuestionData.append(temp)
                }
            }
            if arryWSQuestionData.count == 0 {
                noDataLabel(str: (appDelegate.ArryLngResponSystm!["no_question_admin_msg"] as? String)!)
                ////"You Have Already Answered \nAll The Questions."
            }else {
                noDataLabel(str: "")
                self.tblViewQA.reloadData()
            }
        }else {
            self.arryWSQuestionData.removeAll()
            for temp in tempArr {
                if temp["user_id"] as! String == userInfo.userId {
                    self.arryWSQuestionData.append(temp)
                }
            }
            if arryWSQuestionData.count == 0 {
                noDataLabel(str: (appDelegate.ArryLngResponSystm!["no_question_user_msg"] as? String)!)
                //"You Have Not Asked Any \nQuestion Yet."
            }else {
                noDataLabel(str: "")
                self.tblViewQA.reloadData()
            }
        }
        self.tblViewQA.reloadData()
    }

    //MARK:- SwipeEvents
    func markReadEvent(section:Int) {
        let arryData = arryWSQuestionData[section]
        question_id = (arryData["course_questions_id"] as? String)!
        self.callWSOfmarkRead()
    }
    
    func replyEvent(section:Int) {
        callServiceFlag = "reply"
        
        let replyVC = self.storyboard?.instantiateViewController(withIdentifier: "ReplyViewController") as! ReplyViewController
        
        let arryData = arryWSQuestionData[section]
        let q_id = arryData["course_questions_id"] as? String
        let question = arryData["question"] as? String
        let user_name = arryData["user_name"] as? String
        
        replyVC.callWS = callServiceFlag
        replyVC.user_name = user_name!
        replyVC.question = question!
        replyVC.question_id = q_id!
        
        self.navigationController?.pushViewController(replyVC, animated: true)
    }
    
    func editEvent(section:Int) {
        let arryData = arryWSQuestionData[section]
        
        let answer = arryData["answer"  ] as! [Any]
        
        var lastIndex : [String:Any]!
        var answerType = ""
        var currentUserID = ""
        
        if answer.count != 0 {
            let replyVC = self.storyboard?.instantiateViewController(withIdentifier: "ReplyViewController") as! ReplyViewController
            callServiceFlag = "editAnswer"
            lastIndex = answer[answer.count - 1] as! [String:Any]
            answerType = lastIndex["type"] as! String
            currentUserID = lastIndex["user_id"] as! String
            
            if answerType == "0" {
                let id = lastIndex["id"] as? String
                let answer = lastIndex["answer"] as? String
                let user_name = lastIndex["user_name"] as? String
                
                replyVC.callWS = callServiceFlag
                replyVC.user_name = user_name!
                replyVC.question = answer!
                replyVC.question_id = id!
                replyVC.strQuestion = (arryData["question"] as? String)!
                
            }
            self.navigationController?.pushViewController(replyVC, animated: true)
        }else {
            
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "AskQuestion") as! AskQuestion
            VC.strTitle = "EditQuestion"
            callServiceFlag = "editQuestion"
            
            let arryData = arryWSQuestionData[section]
            let q_id = arryData["course_questions_id"] as? String
            let question = arryData["question"] as? String
            
            VC.strQuestDetails = question!
            VC.strQuestionId = q_id!
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func deleteEvent(section:Int){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let subview = actionSheet.view.subviews.first, let actionSheet = subview.subviews.first {
            for innerView in actionSheet.subviews {
                innerView.backgroundColor = UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0)
                innerView.layer.cornerRadius = 10.0
                innerView.layer.borderWidth = 1
                innerView.layer.borderColor = UIColor.darkGray.cgColor
                innerView.clipsToBounds = true
            }
        }
        actionSheet.view.tintColor = UIColor.white
        
        actionSheet.addAction(UIAlertAction(title:(appDelegate.ArryLngResponeCustom!["confirm_delete"] as? String)! , style: .default, handler: { (UIAlertAction) in
            //"Confirm Delete"
            let arryData = self.arryWSQuestionData[section]
            self.question_id = (arryData["course_questions_id"] as? String)!
            
            self.callWSOfdeleteQuestion()
            
        }))
        let cancelBtn = UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["cancel"] as? String)!, style: UIAlertActionStyle.cancel, handler: nil)
        //"Cancel"
        cancelBtn.setValue(UIColor.red, forKey: "titleTextColor")
        actionSheet.addAction(cancelBtn)
        present(actionSheet, animated: true, completion: nil)
    }
    
    func createDeleteView(section:Int) -> UIView {
        let deleteColor = UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0)
        let delete = MGSwipeButton(title: (appDelegate.ArryLngResponeCustom!["trash"] as? String)!, icon:#imageLiteral(resourceName: "delete"), backgroundColor: deleteColor, padding: 0, callback: { (cell) -> Bool in
            self.deleteEvent(section: section)
            //"Delete"
            return true
        })
        delete.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        delete.centerIconOverText(withSpacing: 10.0)
        delete.buttonWidth = 60.0
        return delete
    }
    
    func createMarkReadView(section:Int) -> UIView {
        let markReadColor = UIColor(red:0.78, green:0.78, blue:0.80, alpha:1.0)
        let markRead = MGSwipeButton(title: (appDelegate.ArryLngResponeCustom!["mark_read"] as? String)!, icon: #imageLiteral(resourceName: "tick"), backgroundColor: markReadColor, padding: 0, callback: { (cell) -> Bool in
            //"Mark Read"
            self.markReadEvent(section: section)
            return true
        })
        markRead.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        markRead.centerIconOverText(withSpacing: 10.0)
        markRead.buttonWidth = 80.0
        return markRead
    }
    
    func createEditView(section:Int) -> UIView {
        let editColor = UIColor(red:0.78, green:0.78, blue:0.80, alpha:1.0)
        let edit = MGSwipeButton(title: (appDelegate.ArryLngResponeCustom!["edit"] as? String)!, icon:#imageLiteral(resourceName: "edit"), backgroundColor: editColor, padding: 0, callback: { (cell) -> Bool in
            //"Edit"
            self.editEvent(section: section)
            return true
        })
        edit.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        edit.centerIconOverText(withSpacing: 10.0)
        return edit
    }
    
    func createReplyView(section:Int) -> UIView {
        let replyColor = UIColor(red:0.11, green:0.47, blue:1.00, alpha:1.0)
        let reply = MGSwipeButton(title: (appDelegate.ArryLngResponeCustom!["reply"] as? String)!, icon:#imageLiteral(resourceName: "reverse"), backgroundColor: replyColor, padding: 0, callback: { (cell) -> Bool in
            //"Reply"
            self.replyEvent(section: section)
            return true
        })
        reply.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        reply.centerIconOverText(withSpacing: 10.0)
        return reply
    }
    
    
    // MARK:- Tap Gesture Methods on Section Header
    @objc func sectionTaped(gestureRecognizer: UITapGestureRecognizer) {
        getLastAudiVideoDuration()
        player1.pause()
        callWSOfDanyamicVideo(urlStr: "",strTopicID:"",strLectureID:"")
        self.player1.cleanPlayer()
        
        let cell = gestureRecognizer.view as! QATableViewCell
        let section = cell.tag
        
        let data = arryWSQuestionData[section]
        question_id = data["course_questions_id"] as! String
        
        let answerVC = self.storyboard?.instantiateViewController(withIdentifier: "AnswerDetailsVC") as! AnswerDetailsVC
        answerVC.questionID = question_id
        answerVC.titleString = data["question"] as! String
        self.navigationController?.pushViewController(answerVC, animated: true)
        
        /*
        // logic for expand
        let cell = gestureRecognizer.view as! QATableViewCell
        
        let section = cell.tag
        
        if leftSwipe == section || rightSwipe == section{
            leftSwipe = -1
            rightSwipe = -1
        }
        
        player?.pause()
        playerFlag = 0

        let shouldExpand = !expandabaleSection.contains(section)
        if (shouldExpand) {
            expandabaleSection.removeAllObjects()
            expandabaleSection.add(section)
        } else {
            expandabaleSection.removeAllObjects()
        }
        tblViewQA.reloadData()
        */
    }
    
    
    
    @objc func leftSwipe(_ gestureRecognizer: UISwipeGestureRecognizer?) {
        //do you left swipe stuff here.
        print("Swipe Left")
        
        let cell = gestureRecognizer?.view as! QATableViewCell
        
        let section = cell.tag
        
        if rightSwipe == section {
            rightSwipe = -1
        }else{
            leftSwipe = section
            rightSwipe = -1
        }

        cell.veiwReply.isHidden = true
        cell.viewDelete.isHidden = false
        cell.viewEdit.isHidden = true
        cell.viewMarkRead.isHidden = false
        
        tblViewQA.reloadData()
    }
    
    @objc func rightSwipe(_ gestureRecognizer: UISwipeGestureRecognizer?) {
      
        let cell = gestureRecognizer?.view as! QATableViewCell
        
        let section = cell.tag
        
        if leftSwipe == section {
            leftSwipe = -1
        }else{
            rightSwipe = section
            leftSwipe = -1
        }

        cell.veiwReply.isHidden = false
        cell.viewDelete.isHidden = true
        cell.viewEdit.isHidden = false
        cell.viewMarkRead.isHidden = true
        
        tblViewQA.reloadData()
        
    }
    
    
    @objc func markReadClk(_ sender : UIButton?) {
        let section = sender?.tag
        print("Mark Read Clicked----\(section!)")
        
        headerCell.viewDelete.isHidden = true
        headerCell.viewMarkRead.isHidden = true
        
        leftSwipe = -1
        
        let arryData = arryWSQuestionData[section!]
        question_id = (arryData["course_questions_id"] as? String)!
        
        self.callWSOfmarkRead()
     }
    
    @objc func replyClk(_ sender : UIButton?) {
        
        let section = sender?.tag
        print("Reply Clicked----\(section!)")
        
        headerCell.viewEdit.isHidden = true
        headerCell.veiwReply.isHidden = true
        
        callServiceFlag = "reply"
        
        rightSwipe = -1
        
        let replyVC = self.storyboard?.instantiateViewController(withIdentifier: "ReplyViewController") as! ReplyViewController
        
        let arryData = arryWSQuestionData[section!]
        let q_id = arryData["course_questions_id"] as? String
        let question = arryData["question"] as? String
        let user_name = arryData["user_name"] as? String
        
        replyVC.callWS = callServiceFlag
        replyVC.user_name = user_name!
        replyVC.question = question!
        replyVC.question_id = q_id!
        
        self.navigationController?.pushViewController(replyVC, animated: true)
      }
    
    @objc func editClk(_ sender : UIButton?) {
        
        //vishal
        
        let section = sender!.tag
        print("Edit Clicked----\(section)")
        let arryData = arryWSQuestionData[section]
        
        let answer = arryData["answer"  ] as! [Any]
        
        var lastIndex : [String:Any]!
        var answerType = ""
        var currentUserID = ""
        
        rightSwipe = -1
        
        if answer.count != 0 {
            
            let replyVC = self.storyboard?.instantiateViewController(withIdentifier: "ReplyViewController") as! ReplyViewController
            
            callServiceFlag = "editAnswer"
            
            lastIndex = answer[answer.count - 1] as! [String:Any]
            answerType = lastIndex["type"] as! String
            currentUserID = lastIndex["user_id"] as! String
            
            if answerType == "0" {
                let id = lastIndex["id"] as? String
                let answer = lastIndex["answer"] as? String
                let user_name = lastIndex["user_name"] as? String
                
                replyVC.callWS = callServiceFlag
                replyVC.user_name = user_name!
                replyVC.question = answer!
                replyVC.question_id = id!
                replyVC.strQuestion = (arryData["question"] as? String)!
                
            }
             self.navigationController?.pushViewController(replyVC, animated: true)
        }else {
            
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "AskQuestion") as! AskQuestion
            VC.strTitle = "EditQuestion"
            
            callServiceFlag = "editQuestion"
            
            let arryData = arryWSQuestionData[section]
            let q_id = arryData["course_questions_id"] as? String
            let question = arryData["question"] as? String
            //let user_name = arryData["user_name"] as? String
            
            VC.strQuestDetails = question!
            VC.strQuestionId = q_id!
            self.navigationController?.pushViewController(VC, animated: true)
        }
       
    }
    
    @objc func deleteClk(_ sender : UIButton?) {
        
        let section = sender?.tag
        print("Delete Clicked----\(section!)")
        headerCell.viewMarkRead.isHidden = true
        headerCell.viewDelete.isHidden = true
        leftSwipe = -1
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let subview = actionSheet.view.subviews.first, let actionSheet = subview.subviews.first {
            for innerView in actionSheet.subviews {
                innerView.backgroundColor = UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0)
                innerView.layer.cornerRadius = 10.0
                innerView.layer.borderWidth = 1
                innerView.layer.borderColor = UIColor.darkGray.cgColor
                innerView.clipsToBounds = true
            }
        }
        actionSheet.view.tintColor = UIColor.white
        
        actionSheet.addAction(UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["confirm_delete"] as? String)!, style: .default, handler: { (UIAlertAction) in
            //"Confirm Delete"
            let section = sender?.tag
            print("Delete Clicked----\(section!)")
            
            let arryData = self.arryWSQuestionData[section!]
            self.question_id = (arryData["course_questions_id"] as? String)!
            
            self.callWSOfdeleteQuestion()
            
        }))
        let cancelBtn = UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["cancel"] as? String)!, style: UIAlertActionStyle.cancel, handler: nil)
        //"Cancel"
        cancelBtn.setValue(UIColor.red, forKey: "titleTextColor")
        actionSheet.addAction(cancelBtn)
        present(actionSheet, animated: true, completion: nil)
        
    }
  
    @IBAction func btnSendRecdngClick(_ sender: Any) {
        recordingTimer.invalidate()
        recordingFlag = 0
        self.finishRecording(success: true)
        
        
        let data = arryWSQuestionData[strSection]
        question_id = data["course_questions_id"] as! String
        print("question_id: " ,question_id, "and :",recordingURl)
        callWSAudio(QuestionID: question_id,strurl: recordingURl as URL)
    }
    
    @IBAction func btnCancleRecdngClick(_ sender: Any) {
        seconds = 0.0
        self.btnStartRecording.setImage(UIImage(named:"pausrecording"), for: .normal)
        self.mianBgviewOfRecording.isHidden = true
    }
    
    @IBAction func btnStartRecordingClick(_ sender: Any) {
        /*self.btnStartRecording.setImage(UIImage(named:"mic"), for: .normal)
        if recordingFlag == 0{
            recordingFlag = 1
            do {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
                //recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
                //(currentDict["filePath"] as! URL != nil)
               startRecording()
            } catch _ {
                print("error ")
            }
        }else {
            recordingFlag = 0
            self.btnStartRecording.setImage(UIImage(named:"pausrecording"), for: .normal)
            self.finishRecording(success: true)
        }*/
    }
    
    //MARK:- Recording
    //Recording URl
    func directoryURL() -> NSURL? {
        let ticks = Date().ticks
        print("ticks ",ticks)
        
        let fileName = "sound" + String(ticks)
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent(fileName)?.appendingPathExtension("m4a")//m4a
        
        recordingURl = soundURL as! NSURL
        print("soundURL ",soundURL!)
        return soundURL as NSURL?
    }
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            audioRecorder = try AVAudioRecorder(url: self.directoryURL()! as URL,
                                                settings: settings)
            
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let s = String(format: "%02d:%02d", min, sec)
            print("time ",s)
            lblOfAudioCount.text = s
            audioRecorder.updateMeters()
            // if you want to draw some graphics...
            //var apc0 = audioRecorder.averagePower(forChannel: 0)
            //var peak0 = audioRecorder.peakPower(forChannel: 0)
            
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch {
            finishRecording(success: false)
        }
        do {
            try audioSession.setActive(true)
            audioRecorder.record()
        } catch {
        }
    }
   
    
// MARK:- Custom Buttons
    
    @IBAction func switchQuestionClk(_ sender: Any) {
        
        if switchQuestions.isOn {
            if DeviceType.IS_IPHONE_5 {
                lblAllQuestion.font = UIFont.boldSystemFont(ofSize: 13.0)
                lblMyQuestion.font = UIFont.systemFont(ofSize: 13.0)
            }else {
                lblAllQuestion.font = UIFont.boldSystemFont(ofSize: 15.0)
                lblMyQuestion.font = UIFont.systemFont(ofSize: 15.0)
            }
            self.arryWSQuestionData.removeAll()
            
            self.arryWSQuestionData = self.arrAllQuestion
            
            if arryWSQuestionData.count == 0 {
                noDataLabel(str: "Questions not available")
            }else {
                noDataLabel(str: "")
                tblViewQA.reloadData()
            }
        }else {
            
            if DeviceType.IS_IPHONE_5 {
                lblMyQuestion.font = UIFont.boldSystemFont(ofSize: 13.0)
                lblAllQuestion.font = UIFont.systemFont(ofSize: 13.0)
            }else {
                lblMyQuestion.font = UIFont.boldSystemFont(ofSize: 15.0)
                lblAllQuestion.font = UIFont.systemFont(ofSize: 15.0)
            }
            self.sortQuestions(arr: self.arryWSQuestionData)
        }
       
    }
    
    @IBAction func btnDownloadAllClk(_ sender: Any) {
        
        if self.imgDownloadAll.image == UIImage(named: "down-arrow-gray") {
            
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let subview = (actionSheet.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
            
            subview.backgroundColor = UIColor().HexToColor(hexString: self.NavBgcolor)
            
            subview.layer.cornerRadius = 10
            subview.alpha = 1
            subview.layer.borderWidth = 1
            subview.layer.borderColor = UIColor.darkGray.cgColor
            subview.clipsToBounds = true
            
            actionSheet.view.tintColor = UIColor.white
            
            actionSheet.addAction(UIAlertAction(title: "Download Entire Course", style: .default, handler: { (UIAlertAction) in
                
                if validation.isConnectedToNetwork() == false {
                    self.showLabel(message: string.noInternateMessage2)
                }else {
                    self.downloadAll = true
                    self.downloadFile(urlArray: self.arrNameUrl)
                    self.courseDetailTableView.reloadData()
                }
            }))
            
            let cancelBtn = UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["cancel"] as? String)!, style: .cancel, handler: { (UIAlertAction) in
                //"Cancel"
                //self.downloadAll = false
                self.courseDetailTableView.reloadData()
            })
            cancelBtn.setValue(UIColor.red, forKey: "titleTextColor")
            actionSheet.addAction(cancelBtn)
            present(actionSheet, animated: true, completion: nil)
        }
        else if self.imgDownloadAll.image == UIImage(named: "down-arrow-green")  {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let subview = (actionSheet.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
            subview.backgroundColor = UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0)
            subview.layer.cornerRadius = 10
            subview.alpha = 1
            subview.layer.borderWidth = 1
            subview.layer.borderColor = UIColor.darkGray.cgColor
            subview.clipsToBounds = true
            
            actionSheet.view.tintColor = UIColor.white
            actionSheet.addAction(UIAlertAction(title: "Remove Entire Course", style: .default, handler: { (UIAlertAction) in
                //                self.downloadIndicator.startAnimating()
                self.imgDownloadAll.image = UIImage()
                self.downloadAll = false
                
                let tempArray:[Int ] = self.arrNameUrl.value(forKey: "isVideo") as! [Int]
                let tempFileArray = self.arrNameUrl.value(forKey: "fileName") as! [NSURL]
                
                var tempVideoArray = [Int]()
                var tempFileNameArray = [NSURL]()
                var tempVideoCount = [NSURL]()
                
                for (index,element) in tempArray.enumerated() {
                    if element == 1 {
                        let fileName = tempFileArray[index]
                        tempVideoArray.append(element)
                        tempFileNameArray.append(fileName)
                    }
                }
                for video in tempFileNameArray {
                    let fileManager = FileManager.default
                    let filePath = video.relativePath
                    if fileManager.fileExists(atPath: filePath!) {
                        tempVideoCount.append(video)
                    }
                }
                self.showLabel(message: "\(tempVideoCount.count) " + (self.appDelegate.ArryLngResponeCustom!["videos_removed"] as? String)!)
                //videos removed from download
                for arr in self.arrNameUrl {
                    let newArr = arr as! [String:Any]
                    let fileName = newArr["fileName"] as! NSURL
                    
                    let filePath = fileName.relativePath
                    let fileManager = FileManager.default
                    if fileManager.fileExists(atPath: filePath! ) {
                        do {
                            try fileManager.removeItem(atPath: filePath! )
                            
                        } catch {
                            print("Could not clear temp folder: \(error)")
                        }
                        self.imgDownloadAll.isHidden = true
                    }else {
                        self.imgDownloadAll.isHidden = false
                        self.imgDownloadAll.image = UIImage(named: "down-arrow-gray")
                    }
                }
                DispatchQueue.main.async {
                    //                    self.downloadIndicator.stopAnimating()
                    self.imgDownloadAll.isHidden = false
                    self.btnDownloadAll.isHidden = false
                    self.imgDownloadAll.image = UIImage(named: "down-arrow-gray")
                    self.courseDetailTableView.reloadData()
                }
                self.getAllDowloadFlag()
            }))
            
            let cancelBtn = UIAlertAction(title:(appDelegate.ArryLngResponeCustom!["cancel"] as? String)! , style: UIAlertActionStyle.cancel, handler: nil)
            //"Cancel"
            cancelBtn.setValue(UIColor.red, forKey: "titleTextColor")
            actionSheet.addAction(cancelBtn)
            present(actionSheet, animated: true, completion: nil)
        }
    }
   
    @IBAction func btnLessons(_ sender: Any) {
       
        btnMoreConstraint.constant = 35.0
        btnQAconstraint.constant = 35.0
        btnLessonConstraint.constant = 45.0
        btnResourcConstraint.constant = 35.0
        
        //Btn lesson
        btnLessons.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(ActivesizeInt))
        btnLessons.setTitleColor(UIColor().HexToColor(hexString: ActiveTxtcolorHex), for:.normal)
        btnLessons.backgroundColor = UIColor().HexToColor(hexString: ActiveBgColor)
        btnLessons.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(ActivesizeInt))
        
        //Btn More
        btnMore.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(InActivesizeInt))
        btnMore.setTitleColor(UIColor().HexToColor(hexString: InActiveTxtcolorHex), for:.normal)
        btnMore.backgroundColor = UIColor().HexToColor(hexString: InActiveBgColor)
        
        //Btn QA
        btnQA.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(InActivesizeInt))
        btnQA.setTitleColor(UIColor().HexToColor(hexString: InActiveTxtcolorHex), for:.normal)
        btnQA.backgroundColor = UIColor().HexToColor(hexString: InActiveBgColor)
        
        //Btn Resources
        btnResourc.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(InActivesizeInt))
        btnResourc.setTitleColor(UIColor().HexToColor(hexString: InActiveTxtcolorHex), for:.normal)
        btnResourc.backgroundColor = UIColor().HexToColor(hexString: InActiveBgColor)
        
        
        tblViewQA.isHidden = true
        courseDetailTableView.isHidden = false
        webViewMore?.isHidden = true
        webViewResources?.isHidden = true
        self.parentScrollView.isScrollEnabled = true
    }
    
    @IBAction func btnQAclk(_ sender: Any) {
        
        //MARK: call ws
        callWSOfGetQuestion()
        
        btnMoreConstraint.constant = 35.0
        btnQAconstraint.constant = 45.0
        btnLessonConstraint.constant = 35.0
        btnResourcConstraint.constant = 35.0
        
        //Btn QA
        btnQA.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(ActivesizeInt))
        btnQA.setTitleColor(UIColor().HexToColor(hexString: ActiveTxtcolorHex), for:.normal)
        btnQA.backgroundColor = UIColor().HexToColor(hexString: ActiveBgColor)
        btnQA.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(ActivesizeInt))
        
        //Btn More
        btnMore.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(InActivesizeInt))
        btnMore.setTitleColor(UIColor().HexToColor(hexString: InActiveTxtcolorHex), for:.normal)
        btnMore.backgroundColor = UIColor().HexToColor(hexString: InActiveBgColor)
        
        //Btn Lesson
        btnLessons.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(InActivesizeInt))
        btnLessons.setTitleColor(UIColor().HexToColor(hexString: InActiveTxtcolorHex), for:.normal)
        btnLessons.backgroundColor = UIColor().HexToColor(hexString: InActiveBgColor)
        
        //Btn Resources
        btnResourc.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(InActivesizeInt))
        btnResourc.setTitleColor(UIColor().HexToColor(hexString: InActiveTxtcolorHex), for:.normal)
        btnResourc.backgroundColor = UIColor().HexToColor(hexString: InActiveBgColor)
        
        
        tblViewQA.isHidden = false
        tblViewQA.reloadData()
        courseDetailTableView.isHidden = true
        webViewMore?.isHidden = true
        webViewResources?.isHidden = true
        self.parentScrollView.isScrollEnabled = true
        
        
    }
    
    @IBAction func btnResourcClk(_ sender: Any) {
        self.flagForWeb = "2"
        btnMoreConstraint.constant = 35.0
        btnQAconstraint.constant = 35.0
        btnLessonConstraint.constant = 35.0
        btnResourcConstraint.constant = 45.0
        
        //Btn resource
        btnResourc.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(ActivesizeInt))
        btnResourc.setTitleColor(UIColor().HexToColor(hexString: ActiveTxtcolorHex), for:.normal)
        btnResourc.backgroundColor = UIColor().HexToColor(hexString: ActiveBgColor)
        btnResourc.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(ActivesizeInt))
        
        //Btn More
        btnMore.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(InActivesizeInt))
        btnMore.setTitleColor(UIColor().HexToColor(hexString: InActiveTxtcolorHex), for:.normal)
        btnMore.backgroundColor = UIColor().HexToColor(hexString: InActiveBgColor)
        
        //Btn Lesson
        btnLessons.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(InActivesizeInt))
        btnLessons.setTitleColor(UIColor().HexToColor(hexString: InActiveTxtcolorHex), for:.normal)
        btnLessons.backgroundColor = UIColor().HexToColor(hexString: InActiveBgColor)
        
        //Btn QA
        btnQA.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(InActivesizeInt))
        btnQA.setTitleColor(UIColor().HexToColor(hexString: InActiveTxtcolorHex), for:.normal)
        btnQA.backgroundColor = UIColor().HexToColor(hexString: InActiveBgColor)
        
        
        tblViewQA.isHidden = true
        courseDetailTableView.isHidden = true
        webViewMore?.isHidden = true
        webViewResources?.isHidden = false
        
        //vishal
//        let htmStrng = (self.arryWSLessonData["resource"] as? String)!
//        webViewResources?.loadHTMLString(htmStrng, baseURL: nil)

//        webViewResources?.load(URLRequest(url: URL(fileURLWithPath: Bundle.main.path(forResource: "resources", ofType: "html")!)))
        self.parentScrollView.isScrollEnabled = false
        webViewResources?.loadUrl(string: resource_content + "&ostype=2")
        
    }
    
    @IBAction func btnMoreClk(_ sender: Any) {
       self.flagForWeb = "1"
        btnMoreConstraint.constant = 45.0
        btnQAconstraint.constant = 35.0
        btnLessonConstraint.constant = 35.0
        btnResourcConstraint.constant = 35.0
        
        //Btn More
        btnMore.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(ActivesizeInt))
        btnMore.setTitleColor(UIColor().HexToColor(hexString: ActiveTxtcolorHex), for:.normal)
        btnMore.backgroundColor = UIColor().HexToColor(hexString: ActiveBgColor)
        btnMore.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(ActivesizeInt))
        
        //Btn resource
        btnResourc.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(InActivesizeInt))
        btnResourc.setTitleColor(UIColor().HexToColor(hexString: InActiveTxtcolorHex), for:.normal)
        btnResourc.backgroundColor = UIColor().HexToColor(hexString: InActiveBgColor)
        
        //Btn Lesson
        btnLessons.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(InActivesizeInt))
        btnLessons.setTitleColor(UIColor().HexToColor(hexString: InActiveTxtcolorHex), for:.normal)
        btnLessons.backgroundColor = UIColor().HexToColor(hexString: InActiveBgColor)
        
        //Btn QA
        btnQA.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(InActivesizeInt))
        btnQA.setTitleColor(UIColor().HexToColor(hexString: InActiveTxtcolorHex), for:.normal)
        btnQA.backgroundColor = UIColor().HexToColor(hexString: InActiveBgColor)
        
        tblViewQA.isHidden = true
        courseDetailTableView.isHidden = true
        webViewMore?.isHidden = false
        webViewResources?.isHidden = true
        
        //vishal
//        let htmStrng = (self.arryWSLessonData["more"] as? String)!
//        webViewMore?.loadHTMLString(htmStrng, baseURL: nil)
//        webViewMore?.load(URLRequest(url: URL(fileURLWithPath: Bundle.main.path(forResource: "more", ofType: "html")!)))
        self.parentScrollView.isScrollEnabled = false
        webViewMore?.loadUrl(string: more_content + "&ostype=2")
    }
    
    @IBAction func btnAskQuetnClick(_ sender: Any) {
        getLastAudiVideoDuration()
        callWSOfDanyamicVideo(urlStr: "",strTopicID:"",strLectureID:"")
        
        if player1.state == .playing && self.flagFroAudiVideo == "1"{
            self.flagMangePlayCondtn = "2"
        }else if (btnAudioPlay.currentImage?.isEqual(UIImage(named: "pause")))!  && self.flagFroAudiVideo == "2"{
            self.flagMangePlayCondtn = "3"
        }else {
            self.flagMangePlayCondtn = "1"
        }
        player1.pause()
        player?.pause()
        //self.player1.cleanPlayer()
        let vc = storyboard?.instantiateViewController(withIdentifier: "AskQuestion") as! AskQuestion
        vc.strCourseId = StrCourseCatgryId
        vc.strTitle = "NewQuestion"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getUIForLesson() {
        let status = getJsonData!["status"] as! String
        if status == "1" {
            if let data = getJsonData!["data"] as? [String:Any] {
                if let common_element = data["common_element"] as? [String:Any] {
                    let navigation_bar = common_element["navigation_bar"] as! Dictionary<String,String>
                    let size = navigation_bar["size"]
                    NavBgcolor = navigation_bar["bgcolor"]!
                    txtNavcolorHex = navigation_bar["txtcolorHex"]!
                    NavTxtSize = Int(size!)!
                    
                    let genarlSettings = common_element["general_settings"] as! [String:Any]
                    let general_font = genarlSettings["general_font"] as! [String:Any]
                    NavTxtStyle = general_font["fontstyle"] as! String
                    GenarlTxtcolorHex = general_font["txtcolorHex"] as! String
                    let genrlFontSize = genarlSettings["general_fontsize"] as! [String:String]
                    //let bgScreenColor = genarlSettings["screen_bg_color"] as! String
                   
                    bottomTextSize = Int(genrlFontSize["medium"]!)!
                    
                    if let course = data["course"] as? [String:Any] {
                        if let lesson = course["lesson"] as? [String:Any] {
                            if let lesson_video_title_txtcolorHex = lesson["lesson_video_title_txtcolorHex"] as? String {
                                lblOfVideoTitle.textColor = UIColor().HexToColor(hexString: lesson_video_title_txtcolorHex)
                                lblOfVideoDricptn.textColor = UIColor().HexToColor(hexString: lesson_video_title_txtcolorHex)
                            }
                            if let lesson_bgcolor = lesson["lesson_bgcolor"] as? String {
                                self.viewInsideScrollView.backgroundColor = UIColor().HexToColor(hexString: lesson_bgcolor)
                                self.parentScrollView.backgroundColor = UIColor().HexToColor(hexString: lesson_bgcolor)
                                self.view.backgroundColor = UIColor().HexToColor(hexString: lesson_bgcolor)
                                self.bgStatusView.backgroundColor = UIColor().HexToColor(hexString: NavBgcolor)
                            }
                            if let download_complete_lesson_txtcolorHex = lesson["download_complete_lesson_txtcolorHex"] as? String {
                                self.lesson_bgColor = (lesson["lesson_bgcolor"] as? String)!
                                downloadColor = download_complete_lesson_txtcolorHex
                            }
                            if let video_progressbar_color = lesson["video_progressbar_color"] as? String {
                                progressColor = video_progressbar_color
                            }
                        }
                    }
                    
                    //Title
                    if let title = genarlSettings["title"] as? Dictionary<String,String> {
                        let size = title["size"]
                        let txtcolorHex = title["txtcolorHex"]
                        let fontstyle = title["fontstyle"]
                        let sizeInt:Int = Int(size!)!
                        
                        lblOfVideoTitle.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt + 2))
                        //lblOfVideoTitle.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                    }
                    
                    //Description
                    if let dicTitle = genarlSettings["description"] as? Dictionary<String,String> {
                        let size = dicTitle["size"]
                        let txtcolorHex = dicTitle["txtcolorHex"]
                        let fontstyle = dicTitle["fontstyle"]
                        let sizeInt:Int = Int(size!)!
                        
                        lblOfVideoDricptn.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                        //lblOfVideoDricptn.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                    }
                    
                    commonElement = common_element

                    if let course_Element = data["course"] as? [String:Any]{
                        lessonElement = (course_Element["lesson"] as? [String:Any])!
                        
                        if let tabBar = lessonElement["tabbar"] as? [String:Any] {
                            
                            if let activeDic = tabBar["active"]  as? [String:String] {
                                let size = activeDic["size"]
                                ActiveTxtcolorHex = (activeDic["txtcolorHex"])!
                                ActiveBgColor = (activeDic["bgcolor"])!
                                ActivesizeInt = Int(size!)!
                            }
                            
                            if let InActiveDic = tabBar["inactive"]  as? [String:String] {
                                let size = InActiveDic["size"]
                                InActiveTxtcolorHex =  (InActiveDic["txtcolorHex"])!
                                InActiveBgColor = (InActiveDic["bgcolor"])!
                                InActivesizeInt = Int(size!)!
                            }
                             btnLessonConstraint.constant = 45.0
                            
                            if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 {
                                
                                //Btn lesson
                                btnLessons.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(ActivesizeInt - 3))
                                btnLessons.setTitleColor(UIColor().HexToColor(hexString: ActiveTxtcolorHex), for:.normal)
                                btnLessons.backgroundColor = UIColor().HexToColor(hexString: ActiveBgColor)
                                btnLessons.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(ActivesizeInt - 3))
                                
                                //Btn More
                                btnMore.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(InActivesizeInt - 3))
                                btnMore.setTitleColor(UIColor().HexToColor(hexString: InActiveTxtcolorHex), for:.normal)
                                btnMore.backgroundColor = UIColor().HexToColor(hexString: InActiveBgColor)
                                
                                //Btn QA
                                btnQA.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(InActivesizeInt - 3))
                                btnQA.setTitleColor(UIColor().HexToColor(hexString: InActiveTxtcolorHex), for:.normal)
                                btnQA.backgroundColor = UIColor().HexToColor(hexString: InActiveBgColor)
                                
                                //Btn Resources
                                btnResourc.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(InActivesizeInt - 3))
                                btnResourc.setTitleColor(UIColor().HexToColor(hexString: InActiveTxtcolorHex), for:.normal)
                                btnResourc.backgroundColor = UIColor().HexToColor(hexString: InActiveBgColor)
                                
                                btnAskWidthConstraint.constant = 55
                                lblAllQuestion.font = UIFont.boldSystemFont(ofSize: 12.0)
                                lblMyQuestion.font = UIFont.systemFont(ofSize: 12.0)
                          
                            }else {
                                //Btn lesson
                                btnLessons.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(ActivesizeInt))
                                btnLessons.setTitleColor(UIColor().HexToColor(hexString: ActiveTxtcolorHex), for:.normal)
                                btnLessons.backgroundColor = UIColor().HexToColor(hexString: ActiveBgColor)
                                btnLessons.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(ActivesizeInt))
                                
                                //Btn More
                                btnMore.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(InActivesizeInt))
                                btnMore.setTitleColor(UIColor().HexToColor(hexString: InActiveTxtcolorHex), for:.normal)
                                btnMore.backgroundColor = UIColor().HexToColor(hexString: InActiveBgColor)
                                
                                //Btn QA
                                btnQA.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(InActivesizeInt))
                                btnQA.setTitleColor(UIColor().HexToColor(hexString: InActiveTxtcolorHex), for:.normal)
                                btnQA.backgroundColor = UIColor().HexToColor(hexString: InActiveBgColor)
                                
                                //Btn Resources
                                btnResourc.titleLabel?.font = checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(InActivesizeInt))
                                btnResourc.setTitleColor(UIColor().HexToColor(hexString: InActiveTxtcolorHex), for:.normal)
                                btnResourc.backgroundColor = UIColor().HexToColor(hexString: InActiveBgColor)
                                
                            }
                        }
                    }
                    
                    if UserDefaults.standard.string(forKey: "courseTopicLimit") != nil{
                        if UserDefaults.standard.string(forKey: "courseTopicLimit") == "0"{
                            self.isDisplayAlltopic = "0"
                        }else {
                            self.isDisplayAlltopic = "1"
                        }
                    }else {
                        self.isDisplayAlltopic = "0"
                    }
                    
                    if let course = data["app_general_settings"] as? [String:Any] {
                        self.askFlag = (course["ask_button"] as? String)!
                        
                        self.allowCmntFlag = (course["allow_comments_to_question_answer"] as? String)!
                        let QAFlag = (course["question_answer_visible"] as? String)!
                        if QAFlag == "0"{
                            self.WidthOfBtnQA.constant = 0
                            self.btnQA.isHidden = true
                        }else {
                            self.WidthOfBtnQA.constant = self.btnLessons.frame.size.width
                        }
                        askButtonConf()
                    }
                }
            }
        } else {
            stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    //MARK: - VideoPlayer
    func videoAudioPlayer(urlStr: String, StrstartTime: String){
        self.flagFroAudiVideo = "1"
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        self.player1.displayView.isHidden = false
        updateInfo()
        player?.replaceCurrentItem(with: nil)
        UserDefaults.standard.set("1", forKey: "VideoAudioRoateFlag")
        self.autoPlay = "1"
        //self.heightOfVideoView.constant = 240
        DispatchQueue.main.async() {
            self.heightVideoDisplayView = (360/640)*self.view.frame.size.width
            self.heightOfVideoView.constant = self.heightVideoDisplayView //NewChange
            self.player1.displayView.snp.makeConstraints { [weak self] (make) in
                guard let strongSelf = self else { return }
                make.top.equalTo(0) //NewChange
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.bottom.equalTo(strongSelf.viewOfVideoPlayer.snp.bottom)
            }
            self.topofVideoView.constant =  UIApplication.shared.statusBarFrame.height
        }
        //Thumbnail_Image dwonloading
        let imgUrl = self.strThumbnailURl
        /*let imageName = self.separateImageNameFromUrl(Url: imgUrl)
        let backgroundColorDisplayView = UIColor.black
        self.player1.displayView.backgroundColor =  UIColor.red//backgroundColorDisplayView
        
       if(self.chache.object(forKey: imageName as AnyObject) != nil){
        
        //NewChange
        (self.player1.displayView as? VGCustomPlayerView)?.imageThumbnailForVideo.image = (self.chache.object(forKey: imageName as AnyObject) as? UIImage)!
        self.player1.displayView.sendSubview(toBack: ((self.player1.displayView as? VGCustomPlayerView)?.imageThumbnailForVideo)!)
        }else{
            if validation.checkNotNullParameter(checkStr: imgUrl) == false {
                Alamofire.request(imgUrl).responseImage{ response in
                    if let image = response.result.value {
                        self.chache.setObject(image, forKey: imageName as AnyObject)
                        
                        //NewChange
                        (self.player1.displayView as? VGCustomPlayerView)?.imageThumbnailForVideo.image = image
                        self.player1.displayView.sendSubview(toBack: ((self.player1.displayView as? VGCustomPlayerView)?.imageThumbnailForVideo)!)
                    }
                    else {
                        self.player1.displayView.backgroundColor =  UIColor.red//backgroundColorDisplayView
                    }
                }
         
            }else {
                self.player1.displayView.backgroundColor = UIColor.red//backgroundColorDisplayView
            }
        }*/
        
        self.player1.gravityMode = .resizeAspect
        self.player1.displayView.reloadGravity()
        let url = URL(string:urlStr)
        
        //let url = URL(string:"https://s3-us-west-1.amazonaws.com/demo-stream-adi/5122018/small2+/master.m3u8")
        //let url = URL(string:"https://s3-us-west-1.amazonaws.com/demo-stream-adi/5122018/smallddemo/adimaster.m3u8")
        //let url = URL(string:"https://s3-us-west-1.amazonaws.com/demo-stream-adi/5122018/mid1.25mb/mid1.25mbmaster.m3u8")
        
        player = nil
        player1.cleanPlayer()
        
        self.player1.replaceVideo(url!)
        
        let strTime : TimeInterval = parseDuration(timeString: StrstartTime)
        player1.play()
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
    
    @objc func didfinishplaying(note : NSNotification) -> String{
        
        getLastAudiVideoDuration()
        var checkSkip = true
        controller.dismiss(animated: true)
        self.finishFlag = "1"
        selectedRow = nil
        self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)

        let dic = nextAudioVideoArry.last
        self.lastIndexLectID = dic!["lecture_id"] as! String
        
        for currentIndex in 0..<nextAudioVideoArry.count{
            let dic = nextAudioVideoArry[currentIndex] as! [String:String]
            if dic["lecture_id"] == self.strLectPlayingTd{
                var dic = nextAudioVideoArry[currentIndex]
                dic["audiVidoComplteFlag"] = "1"
                nextAudioVideoArry[currentIndex] = dic
                print("nextAudioVideoArry after updating : ",nextAudioVideoArry)
                
                var nextVideoIndex = 0
                var playPrevVideo = true
                for index in 0..<nextAudioVideoArry.count{
                    let dic = nextAudioVideoArry[index] as! [String:String]
                    if dic["audiVidoComplteFlag"] == "0"{
                        
                        if index < currentIndex && playPrevVideo{
                            nextVideoIndex = index
                            playPrevVideo = false
                            checkSkip = false
                        }else{
                            
                            if index > currentIndex {
                                nextVideoIndex = index
                                checkSkip = false
                                break
                            }
                            
                        }
                    }
                }
                if checkSkip
                {
                    if currentIndex == (nextAudioVideoArry.count - 1){
                        nextPLaySkipLogin(nextVideoIndex:0)
                    }else {
                        nextPLaySkipLogin(nextVideoIndex:currentIndex+1)
                    }
                }else {
                    nextPLaySkipLogin(nextVideoIndex:nextVideoIndex)
                }
                break
            }
        }
        return ""
    }
    
    func nextPLaySkipLogin(nextVideoIndex:Int){
        //play the next Lesson
        var urlStrng = ""
        
        let dic = nextAudioVideoArry[nextVideoIndex] as! [String:String]
        var BreakMainLoop = false
        for lesson in arrlesson
        {
            let lecture = lesson.lecture
            let topic_id = lesson.topic_id
            for lec in lecture
            {
                let l_id = lec.lecture_id
                if dic["lecture_id"] == l_id && BreakMainLoop == false
                {
                    print("next lecture_id ",l_id)
                    
                    addInlocalData()
                    
                    //if self.nextAudiVidLecID == l_id && self.nextAudiVidTopicID == topic_id{
                    self.flagVideoPlayId = l_id
                    self.strLectPlayingTd = l_id
                    self.strNextCoursTopicLecturesId = l_id
                    self.strCourseTopicsLecturesId = l_id
                    
                    self.player?.pause()
                    self.player1.pause()
                    
                    if lec.videoURL != ""
                    {
                        if self.flagFroAudiVideo == "1"
                        {
                            self.flagFroAudiVideo = "1"
                            self.viewofAudio.isHidden = true
                        }else {
                            self.flagFroAudiVideo = "2"
                            self.viewofAudio.isHidden = false
                        }
                        urlStrng = lec.videoURL
                        self.strVideoURl = lec.videoURL
                        if lec.audioURL != ""{
                            self.strAudioUrl = lec.audioURL
                        }else {
                            self.strAudioUrl = lec.videoURL
                        }
                    }else if lec.audioURL != ""{
                        self.flagFroAudiVideo = "2"
                        self.viewofAudio.isHidden = false
                        urlStrng = lec.audioURL
                    }else {
                        self.flagFroAudiVideo = "1"
                        self.viewofAudio.isHidden = true
                        urlStrng = ""
                    }
                    
                    if UserDefaults.standard.value(forKey: "ViewData") != nil {
                        let viewData = UserDefaults.standard.value(forKey: "ViewData") as! [[String:Any]]
                        for allKeys in viewData {
                            if allKeys["lecture_id"] as! String == l_id && allKeys["user_id"] as! String == userInfo.userId {
                                self.strCourseTopicsLecturesId = ""
                                break
                            }else {
                                self.strCourseTopicsLecturesId = l_id
                            }
                        }
                    }else {
                        self.strCourseTopicsLecturesId = l_id
                    }
                    
                    self.subTilteForAudioPlayer = (dic["subTilteForAudioPlayer"])!
                    self.titleForAudioPlayer = (dic["titleForAudioPlayer"])!
                    
                    VGPlayerCacheManager.shared.cleanAllCache()
                    callWSOfDanyamicVideo(urlStr: urlStrng, strTopicID:topic_id,strLectureID:l_id)
                    self.courseDetailTableView.reloadData()
                    self.autoPlay = "2"
                    BreakMainLoop = true
                    break
                }
            }
            
            if BreakMainLoop {
                break
            }
        }
    }
    
    func addInlocalData(){
        var breakMainLoop = false
        for lesson in arrlesson
        {
            let lecture = lesson.lecture
            let topic_id = lesson.topic_id
            for lec in lecture
            {
                let l_id = lec.lecture_id
                if l_id == self.strCourseTopicsLecturesId {
                    if !lec.audio_completed
                    {
                        lec.audio_completed = true
                        //Complete Audio Video Logic
                        if UserDefaults.standard.value(forKey: "ViewData") != nil {
                            localOfflineData = UserDefaults.standard.value(forKey: "ViewData") as! [[String:Any]]
                            localOfflineData.append(["course_id":self.StrCourseCatgryId,"topic_id":topic_id,"lecture_id":l_id,"user_id":userInfo.userId])
                                UserDefaults.standard.set(localOfflineData, forKey: "ViewData")
                            breakMainLoop = true
                            break
                        }
                        else
                        {
                            localOfflineData.append(["course_id":self.StrCourseCatgryId,"topic_id":topic_id,"lecture_id":l_id,"user_id":userInfo.userId])
                            UserDefaults.standard.set(localOfflineData, forKey: "ViewData")
                            breakMainLoop = true
                            break
                        }
                    }
                }
            }
            
            if breakMainLoop {
                break
            }
        }
    }
    
    
    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        let currentviewController =  navigationController?.visibleViewController
        
        if currentviewController != playerViewController{
            currentviewController?.present(playerViewController,animated: true,completion:nil)
        }
    }
    
    func getindex(indexpath : IndexPath) -> Int{
        
        if  arryWSLessonData.count != 0{
            let arryOfTopic = arryWSLessonData["topics"] as! [[String:Any]]
            var count = 0
            for i in 1..<indexpath.section + 1 {
                let sectionArry = arryOfTopic[i - 1]
                let arryOfLecture = sectionArry["lectures"] as! [Any]
                count += arryOfLecture.count
            }
            return  count + indexpath.row + 1
        }else{
            return 0
        }
    }
    
    func getAllDowloadFlag() {
        if self.arrNameUrl.count != 0 {
            let tempArray:[Int ] = self.arrNameUrl.value(forKey: "isVideo") as! [Int]
            let tempFileArray = self.arrNameUrl.value(forKey: "fileName") as! [NSURL]
            
            var tempVideoArray = [Int]()
            var tempFileNameArray = [NSURL]()
            var tempVideoCount = [NSURL]()
            
            for (index,element) in tempArray.enumerated() {
                if element == 1 {
                    let fileName = tempFileArray[index]
                    tempVideoArray.append(element)
                    tempFileNameArray.append(fileName)
                }
            }
            for video in tempFileNameArray {
                let fileManager = FileManager.default
                let filePath = video.relativePath
                if fileManager.fileExists(atPath: filePath!) {
                    tempVideoCount.append(video)
                }
            }
            
            if tempVideoArray.count ==  tempVideoCount.count {
                self.downloadIndicator.isHidden = true
                self.imgDownloadAll.isHidden = false
                self.imgDownloadAll.image = UIImage(named: "down-arrow-green")
            }else {
                self.imgDownloadAll.image = UIImage(named: "down-arrow-gray")
            }
        }else {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("JsonData.json")
            if FileManager.default.fileExists(atPath: documentsURL.relativePath) {
                let response = retrieveFromJsonFile()["response"] as! [String:Any]
                let responseLesson = response["responseLesson"] as! [[String:Any]]
                if responseLesson.count != 0 {
                    for lesson in responseLesson {
                        if self.StrCourseCatgryId == lesson["course_id"] as! String {
                            self.arryWSLessonData = lesson
                            self.configureUI()
                        }
                    }
                }
            }else {
                callWSOfLesson()
            }
        }
    }
    
    //MARK:- Audio Player
    @IBAction func btnBackClick(_ sender: Any) {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.AVPlayerItemDidPlayToEndTime , object: player?.currentItem)
        player?.replaceCurrentItem(with: nil)
        
        getLastAudiVideoDuration()
        self.flagFroAudiVideo = ""
        self.player?.pause()
        self.player = nil
        self.player1.cleanPlayer()
        callWSOfDanyamicVideo(urlStr: "",strTopicID:"",strLectureID:"")
        UIApplication.shared.isStatusBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAudioPlayClick(_ sender: Any) {
        
        let playingRate = String(UserDefaults.standard.float(forKey: "PlayerRate")) + "x"
        let strValueCurrent = playingRate.replacingOccurrences(of: ".0", with: "")
        if strValueCurrent == self.btnPlayRateAudio.currentTitle! {
            if (self.btnAudioPlay.currentImage?.isEqual(UIImage(named:"pause")))! {
                self.player?.rate = UserDefaults.standard.float(forKey: "PlayerRate")
                self.player?.pause()
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            }else {
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                self.player?.play()
                self.player?.rate = UserDefaults.standard.float(forKey: "PlayerRate")
            }
        }
        else {
            if (self.btnAudioPlay.currentImage?.isEqual(UIImage(named:"pause")))! {
                player?.pause()
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            }else {
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                player?.play()
            }
        }
        
        if self.flagFroAudiVideo == "2" {
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
    
    @IBAction func btnPlayRateAuidoClk(_ sender: Any) {
        
        let arryOfSize = ["1x","1.25x","1.5x","1.75x","2x"] //,"2.5x","3x"
        
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
        dropDown.backgroundColor = UIColor().HexToColor(hexString: "#302E30")//UIColor.white //2B292B
        dropDown.textColor = UIColor.white
        
        if dropDown.isHidden{
            dropDown.show()
        } else{
            dropDown.hide()
        }
    }
    
    @IBAction func btnVolumeCLk(_ sender: Any) {
        switchingFlag = "1"
        if strVideoURl != ""{
            self.viewofAudio.isHidden = true
            player?.pause()
            updateTime()
            var strArry = [String]()
            strArry = strViewedDuration.components(separatedBy: ":")
            self.player1.displayView.isHidden = false
            if strViewedDuration == "" {
                self.strVideoTime = "00:00:00"
            }else if strArry.count == 2 {
                self.strVideoTime = "00:" + (strViewedDuration)
            }else {
                self.strVideoTime = strViewedDuration
            }
            print("self.strVideoTime ",self.strVideoTime)
            self.videoAudioPlayer(urlStr:strVideoURl, StrstartTime:self.strVideoTime)
        }else {
            self.view.makeToast((appDelegate.ArryLngResponSystm!["no_video_available"] as? String)!)
            //"No video Available"
        }
        
    }
    
    @IBAction func btnForwordClk(_ sender: Any) {
        let time = (player?.currentTime())! + CMTimeMake(Int64(15), 1)
        print("FastForwrd time ",time)
        self.btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        let playingRate = String(UserDefaults.standard.float(forKey: "PlayerRate")) + "x"
        if playingRate != "" {
            let strValueCurrent = playingRate.replacingOccurrences(of: "x", with: "")
            self.player?.rate = Float(strValueCurrent)!
        }else {
            self.player?.play()
        }
        player?.seek(to: time)
        
        if self.flagFroAudiVideo == "2" {
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
        
        if self.flagFroAudiVideo == "2" {
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
        
        player?.replaceCurrentItem(with: nil)
        self.flagFroAudiVideo = "2"
        self.autoPlay = "1"
        UserDefaults.standard.set("2", forKey: "VideoAudioRoateFlag")
        self.player1.pause()
        self.player1.cleanPlayer()
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarView?.backgroundColor = UIColor().HexToColor(hexString:appDelegate.strStatusColor)
        self.player1.displayView.isHidden = true
        switchingFlag = "0"
        self.viewofAudio.isHidden = false
        self.topofVideoView.constant =  UIApplication.shared.statusBarFrame.height
        heightVideoDisplayView = 100
        self.heightOfVideoView.constant = 100
        self.viewOfVideoPlayer.addSubview(viewofAudio)
        self.viewOfVideoPlayer.bringSubview(toFront: viewofAudio)
        
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
                btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
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
                    }else {
                        do {
                            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.allowBluetooth)
                        }catch {
                            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
                        }
                    }
                }
                
                let auidoUrl : URL! = URL(string:urlString)
                self.playerFlag = 2
                print("answer URl ",auidoUrl)
                player = AVPlayer(url: auidoUrl!)
                player?.seek(to: startTime)
                self.player?.play()
                
                Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
                if #available(iOS 10.0, *) {
                    //player?.automaticallyWaitsToMinimizeStalling = true
                } else {
                    //Fallback on earlier versions
                }
                player?.rate = UserDefaults.standard.float(forKey: "PlayerRate")
                let playingRate = String(UserDefaults.standard.float(forKey: "PlayerRate")) + "x"
                let strValueCurrent = playingRate.replacingOccurrences(of: ".0", with: "")
                self.btnPlayRateAudio.setTitle(strValueCurrent, for: .normal)
                
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
        
        if self.flagFroAudiVideo == "2" {
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
            let currtnDuartion = CMTimeGetSeconds((player?.currentTime())!)
            if !(currtnDuartion.isNaN) {
                let totalDuration = CMTimeGetSeconds((player?.currentItem?.asset.duration)!)
                if switchingFlag != "1" {
                    progressViewAudio.setProgress(Float(currtnDuartion/totalDuration), animated: true)
                    flagForProgress = "2"
                    audioProgssValue = currtnDuartion/totalDuration
                }
            }else {
                if switchingFlag != "1" {
                    progressViewAudio.setProgress(0, animated: true)
                    flagForProgress = "2"
                    audioProgssValue = 0
                }
            }
        }
    }
    
    //MARK: - Download Events
    func listFilesFromDocumentsFolder() -> [String]? {
        let fileMngr = FileManager.default;
        let docs = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        return try? fileMngr.contentsOfDirectory(atPath:docs)
    }
    
    fileprivate func downloadSingleFile(webUrl:String, localUrl:URL) {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20000
        manager.request(webUrl).downloadProgress(closure : { (progress) in
            print(progress.fractionCompleted)
        }).responseData{ (response) in
            
            switch (response.result ) {
            case .success(_):
                
                print(response)
                print(response.result.value!)
                print(response.result.description)
                if let data = response.result.value {
                    
                    do {
                        try data.write(to: localUrl)
                        
                        if self.fileTypeFlag == "1" {
                            self.showLabel(message: "1 \((self.appDelegate.ArryLngResponSystm!["video_download_success"] as? String)!)")
                        }else if self.fileTypeFlag == "2" {
                            self.showLabel(message: "1 \((self.appDelegate.ArryLngResponSystm!["audio_download_success"] as? String)!)")
                        }else {
                            self.showLabel(message:(self.appDelegate.ArryLngResponSystm!["file_download_success"] as? String)!)
                        }
                        
                        self.courseDetailTableView.reloadData()
                    } catch {
                        print("File could not save to local.")
                    }
                    self.getAllDowloadFlag()
                }
                break
                
            case .failure(let error):
                if error._code == NSURLErrorNetworkConnectionLost { // error-code :
                    DispatchQueue.main.async {
                        self.showLabel(message: string.noInternateMessage2)
                        self.internetGone = true
                        self.getAllDowloadFlag()
                        self.courseDetailTableView.reloadData()
                    }
                    
                }
                else if error._code == NSURLErrorTimedOut {
                    self.downloadSingleFile(webUrl: webUrl, localUrl: localUrl)
                    DispatchQueue.main.async {
                        self.showLabel(message: (self.appDelegate.ArryLngResponSystm!["Please_wait"] as? String)!)
                        self.internetGone = true
                        self.getAllDowloadFlag()
                        self.courseDetailTableView.reloadData()
                    }
                }
                else if error._code == NSURLErrorDownloadDecodingFailedMidStream {
                    print("error",error.localizedDescription)
                    self.internetGone = true
                }
                break
            }
        }
    }
    
    func configureUI() {
        
        if let resource_content = arryWSLessonData["resource_content"] as? String {
            self.resource_content = resource_content
        }
        if let more_content = arryWSLessonData["more_content"] as? String {
            self.more_content = more_content
        }
        let course_id = self.arryWSLessonData["course_id"] as! String
        let arryOfTopic = self.arryWSLessonData["topics"] as! [[String:Any]]
        if arryOfTopic.count > 0 {
            print("---------------Logic for Audio/Video Completed---------------------")
            for topic in arryOfTopic {
                let topic_id = topic["topic_id"] as! String
                let arryOfLecture = topic["lectures"] as! [[String:Any]]
                self.subTilteForAudioPlayer = topic["name"] as! String
                self.arrlecture.removeAll()
                //self.nextAudioVideoArry.removeAll()
                for lecture in arryOfLecture {
                    let lecture_id = lecture["lecture_id"] as! String
                    let videoExistFlag = lecture["videoExistFlag"] as! String
                    let audioExistFlag = lecture["audioExistFlag"] as! String
                    self.titleForAudioPlayer = (lecture["title"] as? String)!
                    var urlVideo = ""
                    var urlAudio = ""
                    var AudiVidoComplte = ""
                    if videoExistFlag == "1" {
                        let dictVideo = lecture["videoData"] as? [Any]
                        let dicV = dictVideo![0] as? [String:Any]
                        urlVideo = dicV!["url"] as! String
                        AudiVidoComplte = dicV!["videoComeplete"] as! String
                        if audioExistFlag == "1" {
                            let dictAudio = lecture["audioData"] as? [Any]
                            let dicA = dictAudio![0] as? [String:Any]
                            urlAudio = dicA!["url"] as! String
                        }else {
                            urlAudio = ""
                        }
                    }
                    else if audioExistFlag == "1" {
                        let dictAudio = lecture["audioData"] as? [Any]
                        let dicA = dictAudio![0] as? [String:Any]
                        urlAudio = dicA!["url"] as! String
                        AudiVidoComplte = dicA!["audioComeplete"] as! String
                    }
                    
                    if AudiVidoComplte == "1"{
                        nextAudioVideoArry.append(["course_id":self.StrCourseCatgryId,"topic_id":topic_id,"lecture_id":lecture_id,"audiVidoComplteFlag":"1","titleForAudioPlayer":self.titleForAudioPlayer,"subTilteForAudioPlayer":self.subTilteForAudioPlayer])
                        
                    }
                    else if AudiVidoComplte == "0"
                    {
                        var addDatInViewData = false
                        if UserDefaults.standard.value(forKey: "ViewData") != nil {
                            let viewData = UserDefaults.standard.value(forKey: "ViewData") as! [[String:Any]]
                            for index in 0..<viewData.count {
                                let data = viewData[index] as! [String:String]
                                
                                if data["lecture_id"] == lecture_id && data["topic_id"] == topic_id && data["course_id"] == self.StrCourseCatgryId && data["user_id"] == userInfo.userId{
                                    /*if nextAudioVideoArry.count > 0 {
                                        nextAudioVideoArry.remove(at: index)
                                    }*/
                                    //nextAudioVideoArry.insert(["course_id":self.StrCourseCatgryId,"topic_id":topic_id,"lecture_id":lecture_id,"audiVidoComplteFlag":"1","titleForAudioPlayer":self.titleForAudioPlayer,"subTilteForAudioPlayer":self.subTilteForAudioPlayer], at: index)
                                    //break
                                    addDatInViewData  = true
                                    break
                                }
                            }
                            
                            if addDatInViewData{
                                nextAudioVideoArry.append(["course_id":self.StrCourseCatgryId,"topic_id":topic_id,"lecture_id":lecture_id,"audiVidoComplteFlag":"1","titleForAudioPlayer":self.titleForAudioPlayer,"subTilteForAudioPlayer":self.subTilteForAudioPlayer])
                            }else {
                                nextAudioVideoArry.append(["course_id":self.StrCourseCatgryId,"topic_id":topic_id,"lecture_id":lecture_id,"audiVidoComplteFlag":"0","titleForAudioPlayer":self.titleForAudioPlayer,"subTilteForAudioPlayer":self.subTilteForAudioPlayer])
                            }
                        }else {
                            nextAudioVideoArry.append(["course_id":self.StrCourseCatgryId,"topic_id":topic_id,"lecture_id":lecture_id,"audiVidoComplteFlag":"0","titleForAudioPlayer":self.titleForAudioPlayer,"subTilteForAudioPlayer":self.subTilteForAudioPlayer])
                        }
                    }
                    
                    let newLecture = Lectures(lecture_id: lecture_id, video_completed: false, audio_completed: false, videoURL: urlVideo, audioURL: urlAudio)
                    self.arrlecture.append(newLecture)
                }
                let newTopic = Lessons(topic_id: topic_id, lecture: self.arrlecture)
                self.arrlesson.append(newTopic)
            }
            //print("Aduio Video ALL Data: ",arryOfTopic)
            print("next playing Aduio Video Data: ",nextAudioVideoArry)
            print("---------------Logic for Downloading---------------------")
            for topic in arryOfTopic {
                let topic_id = topic["topic_id"] as! String
                let arryOfLecture = topic["lectures"] as! [[String:Any]]
                for lecture in arryOfLecture {
                    let lecture_id = lecture["lecture_id"] as! String
                    let videoExistFlag = lecture["videoExistFlag"] as! String
                    let audioExistFlag = lecture["audioExistFlag"] as! String
                    if videoExistFlag == "1" || audioExistFlag == "1" {
                        let arryOfvideoData = lecture["videoData"] as! [[String:Any]]
                        let arryOfaudioData = lecture["audioData"] as! [[String:Any]]
                        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        for video in arryOfvideoData {
                            let course_topics_lectures_media_id = video["course_topics_lectures_media_id"] as! String
                            let url = video["url"] as! String
                            //let url = video["downloadurl"] as! String //HLS - download this when u use HLS
                            
                            let currentVideoURL = documentsURL.appendingPathComponent("video\(course_id)_\(topic_id)_\(lecture_id)_\(course_topics_lectures_media_id).mp4")
                            
                            let dictNameUrl = NSMutableDictionary()
                            dictNameUrl.setValue(url, forKey: "filePath")
                            dictNameUrl.setValue(currentVideoURL, forKey: "fileName")
                            dictNameUrl.setValue(1, forKey: "isVideo")
                            dictNameUrl.setValue(0, forKey:"isDownloading")
                            self.arrNameUrl.add(dictNameUrl)
                        }
                        
                        for video in arryOfaudioData {
                            let course_topics_lectures_media_id = video["course_topics_lectures_media_id"] as! String
                            let url = video["url"] as! String
                            //let url = video["downloadurl"] as! String //HLS - download this when u use HLS
                            
                            
                            let currentVideoURL = documentsURL.appendingPathComponent("audio\(course_id)_\(topic_id)_\(lecture_id)_\(course_topics_lectures_media_id).mp3")
                            
                            let dictNameUrl = NSMutableDictionary()
                            dictNameUrl.setValue(url, forKey: "filePath")
                            dictNameUrl.setValue(currentVideoURL, forKey: "fileName")
                            dictNameUrl.setValue(0, forKey: "isVideo")
                            dictNameUrl.setValue(0, forKey:"isDownloading")
                            self.arrNameUrl.add(dictNameUrl)
                        }
                    }
                }
            }
            self.getAllDowloadFlag()
            self.lblOfVideoTitle.text = self.arryWSLessonData["name"] as? String
            
            if (self.arryWSLessonData["author"] as? String) != "" && (self.arryWSLessonData["website"] as? String)! != ""{
                self.lblOfVideoDricptn.text = (self.arryWSLessonData["author"] as? String)! +  ", " +  (self.arryWSLessonData["website"] as? String)!
            }else if (self.arryWSLessonData["author"] as? String) != "" && (self.arryWSLessonData["website"] as? String)! == ""{
                self.lblOfVideoDricptn.text = (self.arryWSLessonData["author"] as? String)!
            }else if (self.arryWSLessonData["author"] as? String) == "" && (self.arryWSLessonData["website"] as? String)! != ""{
                self.lblOfVideoDricptn.text = (self.arryWSLessonData["website"] as? String)!
            }else {
                self.lblOfVideoDricptn.text = ""
            }
            print("---------------Logic for Last Playing Video/Audio---------------------")
            if flagVideoPlayId == "" {
                self.flagVideoPlayId = self.arryWSLessonData["last_viewed_lession_id"] as! String
            }
            
            for topic in arryOfTopic {
                let topic_id = topic["topic_id"] as! String
                let arryOfLecture = topic["lectures"] as! [[String:Any]]
                for currentDic in arryOfLecture {
                    let videoId = currentDic["lecture_id"] as? String
                    if UserDefaults.standard.value(forKey: "playAudioVideoData") != nil {
                        playAudioVideoArry = UserDefaults.standard.value(forKey: "playAudioVideoData") as! [[String:Any]]
                        for index in 0..<playAudioVideoArry.count {
                            var allKeys = playAudioVideoArry[index] as! [String:String]
                            if allKeys["topic_id"] == self.StrCourseTopicId && allKeys["user_id"] == userInfo.userId{
                                if allKeys["lecture_id"]! == videoId {
                                    self.flagVideoPlayId = allKeys["lecture_id"]!
                                    break
                                }
                            }
                        }
                    }
                    
                    //print("flagVideoPlayId :" ,self.flagVideoPlayId)
                    //print("videoId :" ,videoId ?? "..")
                    
                    self.strCourseTopicsPlayingTd = self.StrCourseTopicId
                    
                    if videoId == self.flagVideoPlayId {
                        self.titleForAudioPlayer = (currentDic["title"] as? String)!
                        self.subTilteForAudioPlayer = topic["name"] as! String
                        self.urlAudioPlayerImg = (currentDic["icon"] as? String)!
                        
                        if UserDefaults.standard.value(forKey: "ViewData") != nil {
                            let viewData = UserDefaults.standard.value(forKey: "ViewData") as! [[String:Any]]
                            for allKeys in viewData {
                                if allKeys["lecture_id"] as? String == videoId && allKeys["user_id"] as! String == userInfo.userId{
                                    self.strCourseTopicsLecturesId = ""
                                    break
                                }else {
                                    self.strCourseTopicsLecturesId = videoId!
                                }
                            }
                        }else {
                            self.strCourseTopicsLecturesId = videoId!
                        }
                        
                        testloop: for dic1 in self.nextAudioVideoArry {
                            //let dicData = self.nextAudioVideoArry[indexValue] as! [String:String]
                            if dic1["lecture_id"] as? String == videoId && dic1["audiVidoComplteFlag"] as? String == "1"{
                                self.strCourseTopicsLecturesId = ""
                                break testloop
                            }
                        }
                        
                        self.strLectPlayingTd = videoId!
                        //vishal
                        //if arryOfTopic.count != 0 {
                        //let sectionDic = arryOfTopic[0]
                        //let arryOfLecture = sectionDic["lectures"] as! [Any]
                        if currentDic.count != 0 {
                            //let currentDic = arryOfLecture[0] as! [String:Any]
                            self.lastPlayedVideo = (currentDic["lecture_id"] as? String)!
                            self.strNextCoursTopicLecturesId = (currentDic["lecture_id"] as? String)!
                            self.updateTime()
                            let videodatDic = currentDic["videoData"] as? [Any]
                            let auidoDic = currentDic["audioData"] as? [Any]
                            if videodatDic?.count != 0{
                                let dic = videodatDic![0] as? [String:Any]
                                if ((dic!["url"] as? String) != nil){
                                    
                                    if ((dic!["thumbnail"] as? String) != nil){
                                        self.strThumbnailURl = (dic!["thumbnail"] as? String)!
                                    }
                                    self.strVideoURl = (dic!["url"] as? String)!
                                    self.flagFroAudiVideo = "1"
                                    getLastAudiVideoDuration()
                                    VGPlayerCacheManager.shared.cleanAllCache()
                                    self.callWSOfDanyamicVideo(urlStr: (dic!["url"] as? String)!,strTopicID:topic_id,strLectureID:videoId!)
                                    self.player?.pause()
                                    self.widthOfAudioViewSwitch.constant = 62.5
                                    self.btnAudioVolume.isHidden = false
                                    
                                    //self.strAudioUrl = (dic!["url"] as? String)!
                                    //self.player1.displayView.audioVideoSwicthBtn.isHidden = false
                                }
                                
                                if auidoDic?.count != 0{
                                    let dic1 = auidoDic![0] as? [String:Any]
                                    if ((dic1!["url"] as? String) != nil){
                                        self.strAudioUrl = (dic1!["url"] as? String)!
                                        self.player1.displayView.audioVideoSwicthBtn.isHidden = false
                                    }else {
                                        self.strAudioUrl = (dic!["url"] as? String)!
                                        self.player1.displayView.audioVideoSwicthBtn.isHidden = false
                                    }
                                }else{
                                    self.strAudioUrl = (dic!["url"] as? String)!
                                    self.player1.displayView.audioVideoSwicthBtn.isHidden = false
                                }
                            }else if auidoDic?.count != 0{
                                let dic = auidoDic![0] as? [String:Any]
                                if ((dic!["url"] as? String) != nil){
                                    self.updateTime()
                                    
                                    self.widthOfAudioViewSwitch.constant = 0
                                    self.btnAudioVolume.isHidden = true
                                    self.player1.displayView.isHidden = true
                                    self.heightOfVideoView.constant = 100
                                    self.strVideoURl = (dic!["url"] as? String)!
                                    self.flagFroAudiVideo = "2"
                                    getLastAudiVideoDuration()
                                    self.callWSOfDanyamicVideo(urlStr: (dic!["url"] as? String)!,strTopicID:topic_id,strLectureID:videoId!)
                                    self.player?.pause()
                                }
                            }
                        }
                    }
                }
            }
            self.courseDetailTableView.reloadData()
        }else {
            callWSOfLesson()
        }
    }
}

// MARK:- TableView Methods
extension CourseTemplateDetails : UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate, MGSwipeTableCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == courseDetailTableView {
            if  arryWSLessonData.count != 0{
                let sectnArray = arryWSLessonData["topics"] as! [[String:Any]]
                return sectnArray.count
            }
            return 0
        }
        else {
                if arryWSQuestionData.count != 0 {
                    if switchQuestions.isOn {
                        return arryWSQuestionData.count
                    }else {
                        return arryWSQuestionData.count
                    }
                }
                else {
                    return 0
                }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == courseDetailTableView {
            if  arryWSLessonData.count != 0{
                let arryOfTopic = arryWSLessonData["topics"] as! [[String:Any]]
                let sectionArry = arryOfTopic[section]
                let arryOfLecture = sectionArry["lectures"] as! [Any]
                    if  arryOfLecture.count != 0{
                        if section == 0 {
                             strCount = strCount + arryOfLecture.count
                        }
                        print("strCount: ",strCount)
                        return arryOfLecture.count
                    }else{
                        return 0
                    }
            }
            return 0
        }
        else {
            if (expandabaleSection.contains(section)){
                if userInfo.adminUserflag == "1" {
                    if arryWSQuestionData.count != 0 {
                        if switchQuestions.isOn {
                            let rows = arryWSQuestionData[section]
                            let currentDic = rows["answer"] as! [Any]
                            if currentDic.count == 0 {
                                return 1
                            }else {
                                return 1
                            }
                        }else {
                            let rows = arryWSQuestionData[section]
                            let currentDic = rows["answer"] as! [Any]
                            if currentDic.count == 0 {
                                return 1
                            }else {
                                return 1
                            }
                        }
                    }
                }else {
                    if arryWSQuestionData.count != 0 {
                        if switchQuestions.isOn {
                            let rows = arryWSQuestionData[section]
                            let currentDic = rows["answer"] as! [Any]
                            if currentDic.count == 0 {
                                return 0
                            }else {
                                return 1
                            }
                        }else {
                            let rows = arryWSQuestionData[section]
                            let currentDic = rows["answer"] as! [Any]
                            if currentDic.count == 0 {
                                return 0
                            }else {
                                return 1
                            }
                        }
                    }
                }
            }else {
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == courseDetailTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rowCell") as! VideoDetailCell
            
            let course_id = self.arryWSLessonData["course_id"] as! String
            let arryOfTopic = self.arryWSLessonData["topics"] as! [[String:Any]]
            let sectionDic = arryOfTopic[indexPath.section]
            let topic_id = sectionDic["topic_id"] as! String
            let arryOfLecture = sectionDic["lectures"] as! [Any]
            let currentDic = arryOfLecture[indexPath.row] as! [String:Any]
            let lecture_id = currentDic["lecture_id"] as! String
            
            //Title
            let genarlSettings = commonElement["general_settings"] as! [String:Any]
            if let title = genarlSettings["general_fontsize"] as? Dictionary<String,String> {
                let size = title["medium"]
                let _:Int = Int(size!)!
                
                //vishal
                let size1 = title["small"]
                let sizeInt1:Int = Int(size1!)!
                
                let fontStylDic = genarlSettings["general_font"] as! [String:Any]
                let fontstyle = fontStylDic["fontstyle"] as? String
                
                if let activeDic = lessonElement["active_lesson"]  as? [String:String] {
                    lessnActvTxtColor = (activeDic["txtcolorHex"])!
                }
                if let other_lesson_txtcolorHex = lessonElement["other_lesson_txtcolorHex"] as? String{
                    lessnInActvTxtColor = other_lesson_txtcolorHex
                }
                
                cell.lblNUmber.text = "\(getindex(indexpath: indexPath))"
                
                if (cell.lblNUmber.text?.count)! > 2 {
                    if let title = genarlSettings["title"] as? Dictionary<String,String> {
                        let size = title["size"]
                        let sizeInt:Int = Int(size!)!
                        cell.lblNUmber.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt-5))
                    }
                }else {
                    if let title = genarlSettings["title"] as? Dictionary<String,String> {
                        let size = title["size"]
                        let sizeInt:Int = Int(size!)!
                        cell.lblNUmber.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    }
                }
                
                //Description
                if let dicSubTitle = genarlSettings["description"] as? Dictionary<String,String> {
                    let txtcolorHex = dicSubTitle["txtcolorHex"]
                    
                    //vishal
                    cell.lblRowTitle.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt1))
                    cell.lblRowSubtitle.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt1))
                    
                    if selectedSection == indexPath.section && selectedRow == indexPath.row  {
                        cell.lblRowTitle.textColor = UIColor().HexToColor(hexString: lessnActvTxtColor)
                        cell.lblNUmber.textColor = UIColor().HexToColor(hexString: lessnActvTxtColor)
                        cell.lblRowSubtitle.textColor = UIColor().HexToColor(hexString: lessnActvTxtColor)
                        
                    }else {
                        cell.lblRowTitle.textColor = UIColor().HexToColor(hexString: lessnInActvTxtColor)
                        cell.lblNUmber.textColor = UIColor().HexToColor(hexString: lessnInActvTxtColor)
                        cell.lblRowSubtitle.textColor = UIColor().HexToColor(hexString: lessnInActvTxtColor)
                    }
                    
                    if lecture_id == self.flagVideoPlayId  {
                        //self.flagVideoPlayId = ""
                        selectedSection = indexPath.section
                        selectedRow = indexPath.row
                        cell.lblRowTitle.textColor = UIColor().HexToColor(hexString: lessnActvTxtColor)
                        cell.lblNUmber.textColor = UIColor().HexToColor(hexString: lessnActvTxtColor)
                        cell.lblRowSubtitle.textColor = UIColor().HexToColor(hexString: lessnActvTxtColor)
                    }
                }
            }
            
            let videoExistFlag = currentDic["videoExistFlag"] as! String
            let audioExistFlag = currentDic["audioExistFlag"] as! String
            let dictVideo = currentDic["videoData"] as? [Any]
            let dictAudio = currentDic["audioData"] as? [Any]
            var course_topics_lectures_media_id = ""
            var filePathVideo = ""
            var filePathAudio = ""
            if dictVideo?.count != 0{
                let dic = dictVideo![0] as? [String:Any]
                course_topics_lectures_media_id = dic!["course_topics_lectures_media_id"] as! String
                
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let currentVideoURL = documentsURL.appendingPathComponent("video\(course_id)_\(topic_id)_\(lecture_id)_\(course_topics_lectures_media_id).mp4")
                
                filePathVideo = currentVideoURL.relativePath
                _ = currentVideoURL.relativeString
                
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePathVideo) {
                    if cell.activityIndicator.isAnimating {
                        cell.imgDownload.isHidden = true
                        cell.btnDownload.isHidden = true
                    }else {
                        cell.imgDownload.isHidden = false
                        cell.btnDownload.isHidden = false
                        cell.imgDownload.image = UIImage(named: "down-arrow-green")
                        cell.imgDownload.tintColor = UIColor().HexToColor(hexString: downloadColor)
                    }
                }else {
                    cell.imgDownload.image = UIImage(named: "down-arrow-gray-empty")
                }
            }
                
            else if dictAudio?.count != 0{
                let dic = dictAudio![0] as? [String:Any]
                course_topics_lectures_media_id = dic!["course_topics_lectures_media_id"] as! String
                
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let currentVideoURL = documentsURL.appendingPathComponent("audio\(course_id)_\(topic_id)_\(lecture_id)_\(course_topics_lectures_media_id).mp3")
                
                filePathAudio = currentVideoURL.relativePath
                _ = currentVideoURL.relativeString
                
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePathAudio) {
                    //                cell.imgDownload.image = UIImage(named: "down-arrow-green")
                    if cell.activityIndicator.isAnimating {
                        cell.imgDownload.isHidden = true
                        cell.btnDownload.isHidden = true
                    }else {
                        cell.imgDownload.isHidden = false
                        cell.btnDownload.isHidden = false
                        cell.imgDownload.image = UIImage(named: "down-arrow-green")
                        cell.imgDownload.tintColor = UIColor().HexToColor(hexString: downloadColor)
                    }
                }else {
                    cell.imgDownload.image = UIImage(named: "down-arrow-gray-empty")
                }
                
            }
            
            if videoExistFlag == "0" && audioExistFlag == "0"{
                cell.btnDownload.isHidden = true
                cell.imgDownload.isHidden = true
                cell.activityIndicator.isHidden = true
            }else {
                cell.btnDownload.isHidden = false
                cell.imgDownload.isHidden = false
                //                cell.activityIndicator.isHidden = false
            }
            
            
            if selectedIndexPath.count != 0 {
                for index in selectedIndexPath {
                    if index == indexPath {
                        let fileManager = FileManager.default
                        if fileManager.fileExists(atPath: filePathAudio) || fileManager.fileExists(atPath: filePathVideo){
                            cell.imgDownload.image = UIImage(named: "down-arrow-green")
                            cell.imgDownload.tintColor = UIColor().HexToColor(hexString: downloadColor)
                        }
                        else{
                            if validation.isConnectedToNetwork() == false {
                                cell.imgDownload.image = UIImage(named: "down-arrow-gray-empty")
                            }else {
                                cell.activityIndicator.startAnimating()
                                cell.btnDownload.isHidden = true
                                cell.imgDownload.isHidden = true
                            }
                        }
                        break
                    }
                }
            }
            
            cell.btnDownload.tag = indexPath.section*1000 + indexPath.row;
            cell.btnDownload.addTarget(self, action: #selector(CourseTemplateDetails.downloadClk(_:)), for: .touchUpInside)

            cell.lblRowTitle.text = currentDic["title"] as? String
            
            let videodic = currentDic["videoData"] as? [Any]
            let audioDic = currentDic["audioData"] as? [Any]
            
            //cell.imgOfCmpletDownld.tintImageColor(color: UIColor().HexToColor(hexString: NavBgcolor))
            
            cell.imgOfCmpletDownld.tintColor = UIColor().HexToColor(hexString: downloadColor)
            
            if videodic?.count != 0{
                let videodic = videodic![0] as? [String:Any]
                if videodic!["videoComeplete"] as? String == "1"{
                    cell.imgOfCmpletDownld.isHidden = false
                    cell.xPstnOfrowTitle.constant = 36
                }else {
                    if arrlesson[indexPath.section].lecture[indexPath.row].lecture_id == lecture_id && arrlesson[indexPath.section].lecture[indexPath.row].audio_completed {
                        cell.imgOfCmpletDownld.isHidden = false
                        cell.xPstnOfrowTitle.constant = 36
                    }else {
                        cell.xPstnOfrowTitle.constant = 8
                        cell.imgOfCmpletDownld.isHidden = true
                    }
                }
                if videodic!["remain_duration"] as? String == "0" {
                    cell.lblRowSubtitle.text = (appDelegate.ArryLngResponeCustom!["video"] as? String)! + " & " + (appDelegate.ArryLngResponeCustom!["audio"] as? String)! + " - " + (videodic!["duration"] as? String)!
                        //"Video - " + (videodic!["duration"] as? String)!
                }else {
                    cell.lblRowSubtitle.text = (appDelegate.ArryLngResponeCustom!["video"] as? String)! + " & "  + (appDelegate.ArryLngResponeCustom!["audio"] as? String)! + " - " + (videodic!["remain_duration"] as? String)!
                        //"Video - " + (videodic!["remain_duration"] as? String)!
                }
                
            }else if audioDic?.count != 0{
                let audioDic = audioDic![0] as? [String:Any]
                if audioDic!["audioComeplete"] as? String == "1"{
                    cell.imgOfCmpletDownld.isHidden = false
                    cell.xPstnOfrowTitle.constant = 36
                }else {
                    if arrlesson[indexPath.section].lecture[indexPath.row].lecture_id == lecture_id && arrlesson[indexPath.section].lecture[indexPath.row].audio_completed {
                        cell.imgOfCmpletDownld.isHidden = false
                        cell.xPstnOfrowTitle.constant = 36
                    }else {
                        cell.xPstnOfrowTitle.constant = 8
                        cell.imgOfCmpletDownld.isHidden = true
                    }
                }
                if audioDic!["remain_duration"] as? String == "0" {
                    cell.lblRowSubtitle.text = (appDelegate.ArryLngResponeCustom!["audio"] as? String)! + " - " + (audioDic!["duration"] as? String)!
                        //"Audio - " + (audioDic!["duration"] as? String)!
                }else {
                    cell.lblRowSubtitle.text = (appDelegate.ArryLngResponeCustom!["audio"] as? String)! + " - " + (audioDic!["remain_duration"] as? String)!
                        //"Audio - " + (audioDic!["remain_duration"] as? String)!
                }
            }else {
                cell.lblRowSubtitle.text = ""
            }
            
            if UserDefaults.standard.value(forKey: "ViewData") != nil{
                if let viewData = UserDefaults.standard.array(forKey: "ViewData") as? [[String: Any]] {
                    for id in viewData {
                        if id["lecture_id"] as! String == lecture_id && id["user_id"] as! String == userInfo.userId {
                            cell.imgOfCmpletDownld.isHidden = false
                            cell.xPstnOfrowTitle.constant = 36
                        }
                    }
                }
            }
            
            if downloadAll {
                if cell.imgDownload.image == UIImage(named: "down-arrow-gray-empty") &&
                    !cell.imgDownload.isHidden {
                    cell.imgDownload.isHidden = true
                    cell.btnDownload.isHidden = true
                    cell.activityIndicator.isHidden = false
                    cell.activityIndicator.startAnimating()
                }
            }
            
            return cell
        }
            
        // QuestionAnswerTableView
        else {
            let genarlSettings = commonElement["general_settings"] as! [String:Any]
            if userInfo.adminUserflag == "1" { //User Flag - 1 - Admin
                let cell = tableView.dequeueReusableCell(withIdentifier: "adminAnswerCell") as! QATableViewCell

                 cell.imgPlay.image = UIImage(named: "play")
                
                if let generalFont = genarlSettings["general_font"] as? Dictionary<String,String> {
                    let size = generalFont["size"]
                    let txtcolorHex = generalFont["txtcolorHex"]
                    let fontstyle = generalFont["fontstyle"]
                    let sizeInt:Int = Int(size!)!
                    
                    cell.lblAnswer.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    cell.lblAnswer.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                    
                    cell.viewOfAdminAddAns.backgroundColor = UIColor().HexToColor(hexString: NavBgcolor)
                    cell.viewOfAdminAddAudio.backgroundColor = UIColor().HexToColor(hexString: NavBgcolor)
                    cell.audioView.backgroundColor = UIColor().HexToColor(hexString: NavBgcolor)
                }
               
                
                cell.btnMore.tag = indexPath.section*1000 + indexPath.row;
                cell.btnAddAudio.tag = indexPath.section*1000 + indexPath.row;
                cell.btnAddAnswer.tag = indexPath.section*1000 + indexPath.row;
                cell.btnPlayAudio.tag = indexPath.section*1000 + indexPath.row;
                
                cell.btnMore.addTarget(self, action: #selector(CourseTemplateDetails.moreClkTbl(_:)), for: .touchUpInside)
                cell.btnAddAudio.addTarget(self, action: #selector(CourseTemplateDetails.btnAddAuidoclk(_:)), for: .touchUpInside)
                cell.btnAddAnswer.addTarget(self, action: #selector(CourseTemplateDetails.moreClkTbl(_:)), for: .touchUpInside)
                cell.btnPlayAudio.addTarget(self, action: #selector(CourseTemplateDetails.playClk(_:)), for: .touchUpInside)
                
                let data = arryWSQuestionData[indexPath.section]
                let answerArr = data["answer"] as! [Any]
                
                if answerArr.count != 0 {
                    let answerData = answerArr[indexPath.row] as! [String:Any]
                    let answer = answerData["answer"] as! String
                    let type = answerData["type"] as! String
                    if type == "1" {
                        cell.audioView.isHidden = false
                        cell.btnPlayAudio.isHidden = false
                        cell.audioViewConstraint.constant = 40
                        cell.btnMore.isHidden = false
                        cell.btnMoreConstraint.constant = 25
                        cell.stackViewTopConstraint.isActive = false
                        cell.stackViewToMoreConstraint.isActive = true
                        cell.lblAnswer.isHidden = true
                        cell.lblAnswerConstraint.constant = 0
                        cell.btnMoreToLabelConstraint.constant = 50
                        cell.viewSideLine.isHidden = false
                        cell.heightOfViewofline.constant = 90
                        
//                    cell.lblAnswer.text = answer
                    }else {
                        cell.audioView.isHidden = true
                        cell.btnPlayAudio.isHidden = true
                        cell.audioViewConstraint.constant = 0
                        cell.btnMore.isHidden = false
                        cell.btnMoreConstraint.constant = 25
                        cell.stackViewTopConstraint.isActive = false
                        cell.stackViewToMoreConstraint.isActive = true
                        cell.lblAnswer.isHidden = false
                        cell.lblAnswerConstraint.constant = 54
                        cell.lblAnswerConstraint.constant = 54
                        cell.btnMoreToLabelConstraint.constant = 0
                        cell.viewSideLine.isHidden = false
                        cell.lblAnswer.text = answer
                        cell.heightOfViewofline.constant = 75
                    }
                }
                else {
                    cell.audioView.isHidden = true
                    cell.btnPlayAudio.isHidden = true
                    cell.audioViewConstraint.constant = -10
                    cell.btnMore.isHidden = true
                    cell.btnMoreConstraint.constant = -10
                    cell.lblAnswer.isHidden = true
                    cell.lblAnswerConstraint.constant = -8
                    cell.btnMoreToLabelConstraint.constant = 0
                    cell.viewSideLine.isHidden = true
                    cell.stackViewTopConstraint.isActive = true
                    cell.stackViewToMoreConstraint.isActive = false
                    cell.stackViewTopConstraint.constant = 0
                }
                
                
                
                return cell
            }else {
                ////User Flag - 0 - User
                let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell") as! QATableViewCell
                cell.imgPlay.image = UIImage(named: "play")
                
                if let generalFont = genarlSettings["general_font"] as? Dictionary<String,String> {
                    let size = generalFont["size"]
                    let txtcolorHex = generalFont["txtcolorHex"]
                    let fontstyle = generalFont["fontstyle"]
                    let sizeInt:Int = Int(size!)!
                    
                    cell.lblAnswer.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    cell.lblAnswer.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                    
                    cell.audioView.backgroundColor = UIColor().HexToColor(hexString: NavBgcolor)
                }
                
                cell.btnMore.tag = indexPath.section*1000 + indexPath.row;
                cell.btnPlayAudio.tag = indexPath.section*1000 + indexPath.row;
                
                cell.btnMore.addTarget(self, action: #selector(CourseTemplateDetails.moreClkTbl(_:)), for: .touchUpInside)
                cell.btnPlayAudio.addTarget(self, action: #selector(CourseTemplateDetails.playClk(_:)), for: .touchUpInside)
                
                let data = arryWSQuestionData[indexPath.section]
                let answerArr = data["answer"] as! [Any]
                
                let answerData = answerArr[indexPath.row] as! [String:Any]
                let answer = answerData["answer"] as! String
                let type = answerData["type"] as! String
                if type == "1" {
                    cell.audioView.isHidden = false
                    cell.btnPlayAudio.isHidden = false
                    cell.audioViewConstraint.constant = 40
                    cell.btnMore.isHidden = false
                    cell.btnMoreConstraint.constant = 25
                    cell.lblAnswer.isHidden = true
                    cell.lblAnswerConstraint.constant = 0
                    cell.btnMoreToLabelConstraint.constant = 50
                    cell.heightOfViewofline.constant = 90
                    //                    cell.lblAnswer.text = answer
                }else {
                    cell.audioView.isHidden = true
                    cell.btnPlayAudio.isHidden = true
                    cell.audioViewConstraint.constant = 0
                    cell.btnMore.isHidden = false
                    cell.btnMoreConstraint.constant = 25
                    cell.lblAnswer.isHidden = false
                    cell.lblAnswerConstraint.constant = 54
                    cell.btnMoreToLabelConstraint.constant = 0
                    cell.lblAnswer.text = answer
                    cell.heightOfViewofline.constant = 75
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // LessonsTableView
        if tableView == courseDetailTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sectionHeader") as! VideoDetailCell
            
            let genarlSettings = commonElement["general_settings"] as! [String:Any]
            cell.backgroundColor = UIColor().HexToColor(hexString: lesson_bgColor)
            
            //Title
            if let title = genarlSettings["title"] as? Dictionary<String,String> {
                let size = title["size"]
                let txtcolorHex = title["txtcolorHex"]
                let fontstyle = title["fontstyle"]
                let sizeInt:Int = Int(size!)!
                
                cell.lblSectionTitle.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                cell.lblSectionTitle.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                cell.lblSectionTitle.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeInt))
            }
            
            //SubTitle
            if let dicSubTitle = genarlSettings["subtitle"] as? Dictionary<String,String> {
                let size = dicSubTitle["size"]
                let txtcolorHex = dicSubTitle["txtcolorHex"]
                let fontstyle = dicSubTitle["fontstyle"]
                let sizeInt:Int = Int(size!)!
                
                cell.lblSectionSubtitle.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                cell.lblSectionSubtitle.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
            }
            
            
            let arryOfTopic = arryWSLessonData["topics"] as! [[String:Any]]
            let sectionDic = arryOfTopic[section]
            //let arryOfLecture = sectionDic["name"] as! [Any]
            
            //"Module #" + "\(section+1) - " +
            cell.lblSectionTitle.text = (sectionDic["name"] as? String)!
            //cell.lblSectionSubtitle.text = sectionDic["description"] as? String
            
            // totalHours = "1.40";
            //totalLession = 3;
            
            let strHour = sectionDic["videototalhours"] as? String
            let strMin = sectionDic["videototalMinutes"] as? String
            let strTotalVideo = sectionDic["totalVideos"] as? String
            let strTotalAudio = sectionDic["totalAudios"] as? String
            if strHour != "0"{
                let strHour2 = strHour?.compare(".")
                let strOnlyHours = strHour?.components(separatedBy: ".")
                if (strHour2 != nil){
                    
                    var strVideoAudioCount = ""
                    if strTotalVideo == "0" || strTotalVideo == "00"{
                        
                    }else if strTotalVideo == "1" || strTotalVideo == "01"{
                        strVideoAudioCount = strTotalVideo! + " " + (appDelegate.ArryLngResponeCustom!["video"] as? String)! + ", "
                        //" Video, "
                    }else {
                        strVideoAudioCount = strTotalVideo! + " " + (appDelegate.ArryLngResponeCustom!["videos"] as? String)! + ", "
                        //" Videos, "
                    }
                    
                    if strTotalAudio == "0" || strTotalAudio == "00"{
                        
                    }else if strTotalAudio == "1" || strTotalAudio == "01"{
                        strVideoAudioCount  += strTotalAudio! + " " + (appDelegate.ArryLngResponeCustom!["audio"] as? String)! + ", "
                        //" Audio, "
                    }else {
                        strVideoAudioCount  += strTotalAudio! + " " + (appDelegate.ArryLngResponeCustom!["audios"] as? String)! + ", "
                        //" Audios, "
                    }
                    
                    var strHourMinCount = ""
                    let strng2 = (strOnlyHours![0])
                    if strng2 == "0" || strng2 == "00"{
                        
                    }else {
                        strHourMinCount = (strOnlyHours![0]) + " " +  (appDelegate.ArryLngResponeCustom!["hours"] as? String)! + ", "
                        //" hours, "
                    }
                    
                    if strMin == "0" || strMin == "00"{
                        
                    }else {
                        strHourMinCount  += strMin! + " " + (appDelegate.ArryLngResponeCustom!["min"] as? String)! + " "
                        ////" min "
                    }
                    cell.lblSectionSubtitle.text = strVideoAudioCount + strHourMinCount + (appDelegate.ArryLngResponeCustom!["of_training"] as? String)!
                    //"of training"
                    
                }else {
                    let numberAsInt = Int(strHour!)
                    let backToString = "\(numberAsInt!)"
                    
                    var strVideoAudioCount = ""
                    if backToString == "0" || backToString == "00"{
                        
                    }else if backToString == "1" || backToString == "01"{
                        strVideoAudioCount = backToString + " " + (appDelegate.ArryLngResponeCustom!["video"] as? String)! + ", "
                        //" Video, "
                    }else {
                        strVideoAudioCount = backToString + " " + (appDelegate.ArryLngResponeCustom!["videos"] as? String)! + ", "
                            //+ " Videos, "
                    }
                    
                    if strTotalAudio == "0" || strTotalAudio == "00"{
                        
                    }else if strTotalAudio == "1" || strTotalAudio == "01"{
                        strVideoAudioCount  += strTotalAudio! + " " + (appDelegate.ArryLngResponeCustom!["audio"] as? String)! + ", "
                            //+ " Audio, "
                    }else {
                        strVideoAudioCount  += strTotalAudio! + " " + (appDelegate.ArryLngResponeCustom!["audios"] as? String)! + ", "
                            //+ " Audios, "
                    }
                    
                    var strHourMinCount = ""
                    if strHour == "0" || strHour == "00"{
                        
                    }else {
                        strHourMinCount = strHour! + " " +  (appDelegate.ArryLngResponeCustom!["hours"] as? String)! + ", "
                        //" hours, "
                    }
                    
                    if strMin == "0" || strMin == "00"{
                        
                    }else {
                        strHourMinCount  += strMin! + " " + (appDelegate.ArryLngResponeCustom!["min"] as? String)! + " "
                        //" min "
                    }
                    cell.lblSectionSubtitle.text = strVideoAudioCount + strHourMinCount + (appDelegate.ArryLngResponeCustom!["of_training"] as? String)!
                    //"of training"
                }
            }else {
                
                var strVideoAudioCount = ""
                if strTotalVideo == "0" || strTotalVideo == "00"{
                    
                }else if strTotalVideo == "1" || strTotalVideo == "01"{
                    strVideoAudioCount = strTotalVideo! + " " + (appDelegate.ArryLngResponeCustom!["video"] as? String)! + ", "
                        //+ " Videos, "
                }else {
                    strVideoAudioCount = strTotalVideo! + " " + (appDelegate.ArryLngResponeCustom!["videos"] as? String)! + ", "
                        //+ " Videos, "
                }
                
                if strTotalAudio == "0" || strTotalAudio == "00"{
                    
                }else if strTotalAudio == "01" || strTotalAudio == "1"{
                    strVideoAudioCount  += strTotalAudio! + " " + (appDelegate.ArryLngResponeCustom!["audio"] as? String)! + ", "
                        //+ " Audio, "
                }else {
                    strVideoAudioCount  += strTotalAudio! + " " + (appDelegate.ArryLngResponeCustom!["audios"] as? String)! + ", "
                        //+ " Audios, "
                }
                
                var strHourMinCount = ""
                if strHour == "0" || strHour == "00"{
                    
                }else {
                    strHourMinCount = strHour! + " " +  (appDelegate.ArryLngResponeCustom!["hours"] as? String)! + ", "
                        //+ " hours, "
                }
                
                if strMin == "0" || strMin == "00"{
                    
                }else {
                    strHourMinCount  += strMin! + " " + (appDelegate.ArryLngResponeCustom!["min"] as? String)! + " "
                        //+ " min "
                }
                cell.lblSectionSubtitle.text = strVideoAudioCount + strHourMinCount + (appDelegate.ArryLngResponeCustom!["of_training"] as? String)!
                //"of training"
            }
            
            return cell
        }
            // QuestionAnswerTableView
        else {
            
            
            if  userInfo.adminUserflag == "1" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "questionAdminCell") as! QATableViewCell
                cell.delegate = self
                
                cell.leftExpansion.threshold = 0
                cell.rightExpansion.threshold = 0
                cell.leftSwipeSettings.transition = .border
                cell.rightSwipeSettings.transition = .border
                cell.leftExpansion.fillOnTrigger = false
                cell.rightExpansion.fillOnTrigger = false
                
                let genarlSettings = commonElement["general_settings"] as! [String:Any]
                //cell.backgroundColor = UIColor().HexToColor(hexString: (genarlSettings["screen_bg_color"] as? String)!)
                //Title
                if let title = genarlSettings["title"] as? Dictionary<String,String> {
                    let size = title["size"]
                    let txtcolorHex = title["txtcolorHex"]
                    let fontstyle = title["fontstyle"]
                    let sizeInt:Int = Int(size!)!
                    
                    cell.lblUsername.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeInt))
                    cell.lblUsername.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    cell.lblUsername.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                }
                
                //SubTitle
                if let dicSubTitle = genarlSettings["subtitle"] as? Dictionary<String,String> {
                    let size = dicSubTitle["size"]
                    let txtcolorHex = dicSubTitle["txtcolorHex"]
                    let fontstyle = dicSubTitle["fontstyle"]
                    let sizeInt:Int = Int(size!)!
                    
                    cell.lblQuestion.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    cell.lblQuestion.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                    
                    cell.lblDateTime.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    cell.lblDateTime.textColor = UIColor.lightGray
                    
                    cell.imgViewIndicator.image = UIImage(named: "right")?.withRenderingMode(.alwaysTemplate)
                    cell.imgViewIndicator.tintColor = UIColor.lightGray
                }
                
                let arryData = arryWSQuestionData[section]
                let flag_read = arryData["flag_read"] as! String
                let answer = arryData["answer"] as! [Any]
                
                var lastIndex : [String:Any]!
                var answerType = ""
                var currentUserID = ""
                
                if answer.count != 0 {
                    lastIndex = answer[answer.count - 1] as! [String:Any]
                    
                    answerType = lastIndex["type"] as! String
                    currentUserID = lastIndex["user_id"] as! String
                }
                
                if flag_read == "0"{
                    cell.lblQuestionType.isHidden = false
                    cell.imgUser.borderColor = UIColor(red:1.00, green:0.38, blue:0.28, alpha:1.0)
                    cell.leftButtons = [createMarkReadView(section: section),createDeleteView(section:section)]
                }else {
                    cell.lblQuestionType.isHidden = true
                    cell.imgUser.borderColor = UIColor.clear
                    cell.leftButtons = [createDeleteView(section: section)]
                }
                
                if answerType == "0" && currentUserID == userInfo.userId && answer.count != 0{
                    if self.allowCmntFlag == "1"{
                        cell.rightButtons = [createReplyView(section: section),createEditView(section: section)]
                    }else {
                        cell.rightButtons = [createEditView(section: section)]
                    }
                }else {
                    if self.allowCmntFlag == "1"{
                        cell.rightButtons = [createReplyView(section: section)]
                    }
                }
                
                if leftSwipe == section {
                    cell.viewMarkRead.isHidden = false
                    cell.viewDelete.isHidden = false
                    
                }else {
                    cell.viewMarkRead.isHidden = true
                    cell.viewDelete.isHidden = true
                }
                
                if switchQuestions.isOn {
                    cell.lblDateTime.text = arryData["date"] as? String
                    cell.lblUsername.text = arryData["user_name"] as? String
                    cell.lblQuestion.text = arryData["question"] as? String
                    
                    if arryData["user_profile"] as? String != nil{
                        let imgUrl = arryData["user_profile"] as? String
                        
                        let imageName = self.separateImageNameFromUrl(Url: imgUrl!)
                        cell.imgUser.backgroundColor = color.placeholdrImgColor
                        
                        if(self.chache.object(forKey: imageName as AnyObject) != nil){
                            cell.imgUser.image = self.chache.object(forKey: imageName as AnyObject) as? UIImage
                        }else{
                            if validation.checkNotNullParameter(checkStr: imgUrl!) == false {
                                Alamofire.request(imgUrl!).responseImage{ response in
                                    if let image = response.result.value {
                                        cell.imgUser.image = image
                                        self.chache.setObject(image, forKey: imageName as AnyObject)
                                    }
                                    else {
                                       cell.imgUser.backgroundColor = color.placeholdrImgColor
                                    }
                                }
                            }else {
                                cell.imgUser.backgroundColor = color.placeholdrImgColor
                            }
                        }
                    }
                    
                }else {
                    cell.lblDateTime.text = arryData["date"] as? String
                    cell.lblUsername.text = arryData["user_name"] as? String
                    cell.lblQuestion.text = arryData["question"] as? String
                    
                    if arryData["user_profile"] as? String != nil{
                        let imgUrl = arryData["user_profile"] as? String
                        
                        let imageName = self.separateImageNameFromUrl(Url: imgUrl!)
                        cell.imgUser.backgroundColor = color.placeholdrImgColor
                        
                        if(self.chache.object(forKey: imageName as AnyObject) != nil){
                            cell.imgUser.image = self.chache.object(forKey: imageName as AnyObject) as? UIImage
                        }else{
                            if validation.checkNotNullParameter(checkStr: imgUrl!) == false {
                                Alamofire.request(imgUrl!).responseImage{ response in
                                    if let image = response.result.value {
                                        cell.imgUser.image = image
                                        self.chache.setObject(image, forKey: imageName as AnyObject)
                                    }
                                    else {
                                        cell.imgUser.backgroundColor = color.placeholdrImgColor
                                    }
                                }
                            }else {
                                cell.imgUser.backgroundColor = color.placeholdrImgColor
                            }
                        }
                    }
                }
                cell.tag = section
                cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sectionTaped)))
               
                cell.btnReply.tag = section
                cell.btnReply.addTarget(self, action: #selector(CourseTemplateDetails.replyClk(_:)), for: .touchUpInside)
                
                cell.btnDelete.tag = section
                cell.btnDelete.addTarget(self, action: #selector(CourseTemplateDetails.deleteClk(_:)), for: .touchUpInside)
                
                cell.btnEdit.tag = section
                cell.btnEdit.addTarget(self, action: #selector(CourseTemplateDetails.editClk(_:)), for: .touchUpInside)
                
                cell.btnMarkRead.tag = section
                cell.btnMarkRead.addTarget(self, action: #selector(CourseTemplateDetails.markReadClk(_:)), for: .touchUpInside)
                
                headerCell = cell
                
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QATableViewCell
                cell.delegate = self
                
                cell.leftExpansion.threshold = 0
                cell.rightExpansion.threshold = 0
                cell.leftSwipeSettings.transition = .border
                cell.rightSwipeSettings.transition = .border
                cell.leftExpansion.fillOnTrigger = false
                cell.rightExpansion.fillOnTrigger = false
                
                let genarlSettings = commonElement["general_settings"] as! [String:Any]
                if let title = genarlSettings["title"] as? Dictionary<String,String> {
                    let size = title["size"]
                    let txtcolorHex = title["txtcolorHex"]
                    let fontstyle = title["fontstyle"]
                    let sizeInt:Int = Int(size!)!
                    
                    cell.lblUsername.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeInt))
                    cell.lblUsername.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    cell.lblUsername.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                }
                
                //SubTitle
                if let dicSubTitle = genarlSettings["subtitle"] as? Dictionary<String,String> {
                    let size = dicSubTitle["size"]
                    let txtcolorHex = dicSubTitle["txtcolorHex"]
                    let fontstyle = dicSubTitle["fontstyle"]
                    let sizeInt:Int = Int(size!)!
                    
                    cell.lblQuestion.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    cell.lblQuestion.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                    
                    cell.lblDateTime.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    cell.lblDateTime.textColor = UIColor.lightGray
                    
                    cell.imgViewIndicator.image = UIImage(named: "right")?.withRenderingMode(.alwaysTemplate)
                    cell.imgViewIndicator.tintColor = UIColor.lightGray
                }
                
                let arryData = arryWSQuestionData[section]
                let flag_read = arryData["flag_read"] as! String
                let answer = arryData["answer"] as! [Any]
                
                if flag_read == "0"{
                    cell.lblQuestionType.isHidden = false
                    cell.imgUser.borderColor = UIColor(red:0.10, green:0.50, blue:0.93, alpha:1.0)
                    cell.leftButtons = [createMarkReadView(section: section)]
                    
                }else {
                    cell.lblQuestionType.isHidden = true
                    cell.imgUser.borderColor = UIColor.clear
                }
                
                if userInfo.userId == arryData["user_id"] as! String {
                    cell.leftButtons = [createDeleteView(section: section)]
                }
                
                var lastIndex : [String:Any]!
                var answerType = ""
                var currentUserID = ""
                
                if answer.count != 0 {
                    lastIndex = answer[answer.count - 1] as! [String:Any]
                    
                    answerType = lastIndex["type"] as! String
                    currentUserID = lastIndex["user_id"] as! String
                }
                
                if userInfo.userId == arryData["user_id"] as! String && answer.count == 0 {
                    if self.allowCmntFlag == "1"{
                        cell.rightButtons = [createReplyView(section: section),createEditView(section: section)]
                    }else {
                        cell.rightButtons = [createEditView(section: section)]
                    }
                }else if answerType == "0" && currentUserID == userInfo.userId  && answer.count != 0{
                    if self.allowCmntFlag == "1"{
                        cell.rightButtons = [createReplyView(section: section),createEditView(section: section)]
                    }else {
                        cell.rightButtons = [createEditView(section: section)]
                    }
                }else {
                    if self.allowCmntFlag == "1"{
                        cell.rightButtons = [createReplyView(section: section)]
                    }
                }
                
                if leftSwipe == section {
                    cell.viewMarkRead.isHidden = false
                    if userInfo.userId == arryData["user_id"] as! String {
                        cell.viewDelete.isHidden = false
                    }
                }else {
                    cell.viewMarkRead.isHidden = true
                    cell.viewDelete.isHidden = true
                }
                
                if switchQuestions.isOn {
                    cell.lblDateTime.text = arryData["date"] as? String
                    cell.lblUsername.text = arryData["user_name"] as? String
                    cell.lblQuestion.text = arryData["question"] as? String
                    
                    if arryData["user_profile"] as? String != nil{
                        let imgUrl = arryData["user_profile"] as? String
                        
                        let imageName = self.separateImageNameFromUrl(Url: imgUrl!)
                       // cell.imgUser.image = UIImage(named:"placeholder2")
                        cell.imgUser.backgroundColor = color.placeholdrImgColor
                        
                        if(self.chache.object(forKey: imageName as AnyObject) != nil){
                            cell.imgUser.image = self.chache.object(forKey: imageName as AnyObject) as? UIImage
                        }else{
                            if validation.checkNotNullParameter(checkStr: imgUrl!) == false {
                                Alamofire.request(imgUrl!).responseImage{ response in
                                    if let image = response.result.value {
                                        cell.imgUser.image = image
                                        self.chache.setObject(image, forKey: imageName as AnyObject)
                                    }
                                    else {
                                        //cell.imgUser.image = UIImage(named:"placeholder2")
                                        cell.imgUser.backgroundColor = color.placeholdrImgColor
                                    }
                                }
                            }else {
                                //cell.imgUser.image = UIImage(named:"placeholder2")
                                cell.imgUser.backgroundColor = color.placeholdrImgColor
                            }
                        }
                    }
                    
                }else {
                    cell.lblDateTime.text = arryData["date"] as? String
                    cell.lblUsername.text = arryData["user_name"] as? String
                    cell.lblQuestion.text = arryData["question"] as? String
                    
                    if arryData["user_profile"] as? String != nil{
                        let imgUrl = arryData["user_profile"] as? String
                        
                        let imageName = self.separateImageNameFromUrl(Url: imgUrl!)
                        //cell.imgUser.image = UIImage(named:"placeholder2")
                        cell.imgUser.backgroundColor = color.placeholdrImgColor
                        
                        if(self.chache.object(forKey: imageName as AnyObject) != nil){
                            cell.imgUser.image = self.chache.object(forKey: imageName as AnyObject) as? UIImage
                        }else{
                            if validation.checkNotNullParameter(checkStr: imgUrl!) == false {
                                Alamofire.request(imgUrl!).responseImage{ response in
                                    if let image = response.result.value {
                                        cell.imgUser.image = image
                                        self.chache.setObject(image, forKey: imageName as AnyObject)
                                    }
                                    else {
                                        //cell.imgUser.image = UIImage(named:"placeholder2")
                                        cell.imgUser.backgroundColor = color.placeholdrImgColor
                                    }
                                }
                            }else {
                                //cell.imgUser.image = UIImage(named:"placeholder2")
                                cell.imgUser.backgroundColor = color.placeholdrImgColor
                            }
                        }
                    }
                }
                
                
                //if (expandabaleSection.contains(section))
                //{
                //    cell.imgViewIndicator?.image = UIImage(named:"down")
                //}
                //else
                //{
                //cell.imgViewIndicator?.image = UIImage(named:"right")
                //}
                
                cell.tag = section
                cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sectionTaped)))
                
                //var recognizer = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe(_:)))
                //recognizer.direction = .right
                //cell.addGestureRecognizer(recognizer)
                //recognizer = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe(_:)))
                //recognizer.delegate = self as UIGestureRecognizerDelegate
                //recognizer.direction = .left
                //cell.addGestureRecognizer(recognizer)
                
                cell.btnReply.tag = section
                cell.btnReply.addTarget(self, action: #selector(CourseTemplateDetails.replyClk(_:)), for: .touchUpInside)
                
                cell.btnMarkRead.tag = section
                cell.btnMarkRead.addTarget(self, action: #selector(CourseTemplateDetails.markReadClk(_:)), for: .touchUpInside)
                
                cell.btnEdit.tag = section
                cell.btnEdit.addTarget(self, action: #selector(CourseTemplateDetails.editClk(_:)), for: .touchUpInside)
                
                cell.btnDelete.tag = section
                cell.btnDelete.addTarget(self, action: #selector(CourseTemplateDetails.deleteClk(_:)), for: .touchUpInside)
                
                headerCell = cell
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if tableView == courseDetailTableView {
            return 40.0
        }else {
            return 90.0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == courseDetailTableView {
//            return 60.0
//        }else {
//            return UITableViewAutomaticDimension
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == courseDetailTableView {
            if selectedRow != indexPath.row {
                self.flagVideoPlayId = ""
                selectedRow = (indexPath.row)
                selectedSection = (indexPath.section)
                playVideoArray = indexPath
                courseDetailTableView.reloadData()
                getLastAudiVideoDuration()
                playAudioVideo(indexPath: indexPath)
            }else if selectedSection != indexPath.section {
                self.flagVideoPlayId = ""
                selectedRow = (indexPath.row)
                selectedSection = (indexPath.section)
                playVideoArray = indexPath
                courseDetailTableView.reloadData()
                getLastAudiVideoDuration()
                playAudioVideo(indexPath: indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == courseDetailTableView {
            player?.pause()
            selectedRow = (indexPath.row)
            selectedSection = (indexPath.section)
            courseDetailTableView.reloadData()
        }
    }
  
    func swipeTableCell(_ cell: MGSwipeTableCell, canSwipe direction: MGSwipeDirection, from point: CGPoint) -> Bool {
        _ = tblViewQA.indexPathForRow(at: point)
        return true
    }
    
    func playAudioVideo(indexPath:IndexPath) {
        
        let course_id = self.arryWSLessonData["course_id"] as! String
        let arryOfTopic = self.arryWSLessonData["topics"] as! [[String:Any]]
        let sectionDic = arryOfTopic[indexPath.section]
        let topic_id = sectionDic["topic_id"] as! String
        self.subTilteForAudioPlayer = sectionDic["name"] as! String
        let arryOfLecture = sectionDic["lectures"] as! [Any]
        let currentDic = arryOfLecture[indexPath.row] as! [String:Any]
        let lecture_id = currentDic["lecture_id"] as! String
        self.titleForAudioPlayer = (currentDic["title"] as? String)!
        self.urlAudioPlayerImg = (currentDic["icon"] as? String)!
        self.strCourseTopicsPlayingTd = topic_id
        self.strLectPlayingTd = lecture_id
        let dict = currentDic["videoData"] as? [Any]
        var course_topics_lectures_media_id = ""
        if dict?.count != 0{
            let dic = dict![0] as? [String:Any]
            course_topics_lectures_media_id = dic!["course_topics_lectures_media_id"] as! String
        }
        
        if UserDefaults.standard.value(forKey: "ViewData") != nil {
            let viewData = UserDefaults.standard.value(forKey: "ViewData") as! [[String:Any]]
            for allKeys in viewData {
                if allKeys["lecture_id"] as! String == lecture_id && allKeys["user_id"] as! String == userInfo.userId{
                    self.strCourseTopicsLecturesId = ""
                    break
                }else {
                    self.strCourseTopicsLecturesId = lecture_id
                }
            }
        }else {
            self.strCourseTopicsLecturesId = lecture_id
        }
        
        //new
        self.player = nil
        self.player1.cleanPlayer()
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //vishal
        self.strNextCoursTopicLecturesId = (currentDic["lecture_id"] as? String)!
        updateTime()
        let videodatDic = currentDic["videoData"] as? [Any]
        let audioDic = currentDic["audioData"] as? [Any]
        if videodatDic?.count != 0{
            let dic = videodatDic![0] as! [String:Any]
            if ((dic["url"] as? String) != nil){
                idForCurrentPlayingItem = dic["course_topics_lectures_media_id"] as! String
                if self.lastPlayedVideo == ""{
                    self.lastPlayedVideo = (currentDic["lecture_id"] as? String)!
                }
                let currentVideoURL = documentsURL.appendingPathComponent("video\(course_id)_\(topic_id)_\(lecture_id)_\(course_topics_lectures_media_id).mp4")
                //                            dir.appendingFormat("/" + "video\(course_id)_\(topic_id)_\(lecture_id)_\(course_topics_lectures_media_id).mp4")
                let filePath1 = currentVideoURL.relativePath
                print("filePath1 :" ,filePath1)
                let filePath = currentVideoURL.relativeString
                print("filePath :" ,filePath)
                
                let fileManager = FileManager.default
                if self.flagFroAudiVideo == "1"{
                    //(self.player1.displayView as? VGCustomPlayerView)?.imageThumbnailForVideo.removeFromSuperview()
                    self.viewofAudio.isHidden = true
                    self.flagFroAudiVideo = "1"
                }else {
                    self.viewofAudio.isHidden = false
                    self.flagFroAudiVideo = "2"
                }
                
                if ((dic["thumbnail"] as? String) != nil){
                    self.strThumbnailURl = (dic["thumbnail"] as? String)!
                }
                
                VGPlayerCacheManager.shared.cleanAllCache()
                // Check if file not exists
                if fileManager.fileExists(atPath: filePath1) {
                    self.strVideoURl = (dic["url"] as? String)!
                    if validation.isConnectedToNetwork() == false {
                        self.videoAudioPlayer(urlStr: (filePath), StrstartTime: "00:00:00")
                    }else {
                        callWSOfDanyamicVideo(urlStr: (filePath),strTopicID:topic_id,strLectureID:lecture_id)
                    }
                    //self.player1.play()
                    self.lastPlayedVideo = (currentDic["lecture_id"] as? String)!
                }else {
                    self.strVideoURl = (dic["url"] as? String)!
                    callWSOfDanyamicVideo(urlStr: (dic["url"] as? String)!,strTopicID:topic_id,strLectureID:lecture_id)
                    //self.player1.play()
                    self.lastPlayedVideo = (currentDic["lecture_id"] as? String)!
                }
            }else {
                self.view.makeToast((appDelegate.ArryLngResponSystm!["no_video_available"] as? String)!)
            }
            
            if audioDic?.count != 0{
                let dic1 = audioDic![0] as! [String:Any]
                if ((dic1["url"] as? String) != nil){
                    self.lastPlayedVideo = (currentDic["lecture_id"] as? String)!
                    self.strAudioUrl = (dic1["url"] as? String)!
                    self.widthOfAudioViewSwitch.constant = 62.5
                    self.btnAudioVolume.isHidden = false
                    self.player1.displayView.audioVideoSwicthBtn.isHidden = false
                }else {
                    self.strAudioUrl = (dic["url"] as? String)!
                    self.widthOfAudioViewSwitch.constant = 62.5
                    self.btnAudioVolume.isHidden = false
                    self.player1.displayView.audioVideoSwicthBtn.isHidden = false
                }
            }else {
                self.strAudioUrl = (dic["url"] as? String)!
                self.widthOfAudioViewSwitch.constant = 62.5
                self.btnAudioVolume.isHidden = false
                self.player1.displayView.audioVideoSwicthBtn.isHidden = false
            }
            
        }else if audioDic?.count != 0{
            heightVideoDisplayView = 100
            self.heightOfVideoView.constant = 100
            
            self.widthOfAudioViewSwitch.constant = 0
            self.btnAudioVolume.isHidden = true
            self.viewofAudio.isHidden = false
            
            let dic = audioDic![0] as! [String:Any]
            var course_topics_lectures_media_id = ""
            if audioDic?.count != 0{
                let dic = audioDic![0] as? [String:Any]
                course_topics_lectures_media_id = dic!["course_topics_lectures_media_id"] as! String
                idForCurrentPlayingItem = dic!["course_topics_lectures_media_id"] as! String
            }
            updateTime()
            
            let currentVideoURL = documentsURL.appendingPathComponent("audio\(course_id)_\(topic_id)_\(lecture_id)_\(course_topics_lectures_media_id).mp3")
            let filePath1 = currentVideoURL.relativePath
            print("Audio filePath1 :" ,filePath1)
            let filePath = currentVideoURL.relativeString
            print("Audio filePath :" ,filePath)
            
            let fileManager = FileManager.default
            self.flagFroAudiVideo = "2"
            // Check if file not exists
            if fileManager.fileExists(atPath: filePath1) {
                self.strAudioUrl = (dic["url"] as? String)!
                if validation.isConnectedToNetwork() == false {
                    playerFlag = 0
                    self.progressViewAudio.setProgress(Float(0.0), animated: false)
                    self.playSoundWith(urlString:(filePath), strDuration: "00:00:00")
                }else {
                    callWSOfDanyamicVideo(urlStr: (filePath),strTopicID:topic_id,strLectureID:lecture_id)
                }
                //self.player?.play()
                self.lastPlayedVideo = (currentDic["lecture_id"] as? String)!
            }else if ((dic["url"] as? String) != nil){
                
                self.flagFroAudiVideo = "2"
                if self.lastPlayedVideo == ""{
                    self.lastPlayedVideo = (currentDic["lecture_id"] as? String)!
                }
                self.strAudioUrl = (dic["url"] as? String)!
                self.strVideoURl = ""
                callWSOfDanyamicVideo(urlStr: (dic["url"] as? String)!,strTopicID:topic_id,strLectureID:lecture_id)
                //self.player?.play()
                self.lastPlayedVideo = (currentDic["lecture_id"] as? String)!
            }else {
                self.view.makeToast((appDelegate.ArryLngResponSystm!["no_audio_available"] as? String)!)
            }
        }else {
            self.view.makeToast((appDelegate.ArryLngResponSystm!["no_video_audio_available"] as? String)!)
        }
    }
}

//MARK: - TableViewCell Click Events
extension CourseTemplateDetails {
    @objc func downloadClk(_ sender : UIButton?){
        
        let section = (sender?.tag)! / 1000
        let row = (sender?.tag)! % 1000
        
        let indexPath = IndexPath(row: row, section: section)
        
        let cellObj = self.courseDetailTableView.cellForRow(at:indexPath) as! VideoDetailCell
        
        let course_id = self.arryWSLessonData["course_id"] as! String
        let arryOfTopic = self.arryWSLessonData["topics"] as! [[String:Any]]
        let sectionDic = arryOfTopic[indexPath.section]
        let topic_id = sectionDic["topic_id"] as! String
        let arryOfLecture = sectionDic["lectures"] as! [Any]
        let currentDic = arryOfLecture[indexPath.row] as! [String:Any]
        let  lecture_id = currentDic["lecture_id"] as! String
        self.courseId = course_id
        self.topicId = topic_id
        self.lectureId = lecture_id
        let videoExistFlag = currentDic["videoExistFlag"] as! String
        let audioExistFlag = currentDic["audioExistFlag"] as! String
        var course_topics_lectures_media_id = ""
        
        if videoExistFlag == "1" || audioExistFlag == "1" {
            let arryOfvideoData = currentDic["videoData"] as! [[String:Any]]
            let arryOfaudioData = currentDic["audioData"] as! [[String:Any]]
            
            if arryOfvideoData.count != 0 {
                var dic = arryOfvideoData[0]
                course_topics_lectures_media_id = dic["course_topics_lectures_media_id"] as! String
                if ((dic["url"] as? String) != nil) {
                //if ((dic["downloadurl"] as? String) != nil) { //HLS - download this when u use HLS
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let currentVideoURL = documentsURL.appendingPathComponent("video\(course_id)_\(topic_id)_\(lecture_id)_\(course_topics_lectures_media_id).mp4")
                    
                    let filePath1 = currentVideoURL.relativePath
                    print("filePath1 :" ,filePath1)
                    let filePath = currentVideoURL.relativeString
                    print("filePath :" ,filePath)
                    
                    let fileManager = FileManager.default
                    // Check if file not exists
                    if fileManager.fileExists(atPath: filePath1) {
                        print("Local path Exists = \(filePath)")
                        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                        
                        let subview = (actionSheet.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
                        subview.backgroundColor = UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0)
                        subview.layer.cornerRadius = 10
                        subview.alpha = 1
                        subview.layer.borderWidth = 1
                        subview.layer.borderColor = UIColor.darkGray.cgColor
                        subview.clipsToBounds = true
                        
                        actionSheet.view.tintColor = UIColor.white
                        actionSheet.addAction(UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["remove_download"] as? String)!, style: .default, handler: { (UIAlertAction) in
                            
                            //"Remove Download"
                            cellObj.imgDownload.image = UIImage()
                            for (index,elememt) in self.selectedIndexPath.enumerated(){
                                if section == elememt.section &&  row == elememt.row{
                                    self.selectedIndexPath.remove(at: index)
                                }
                            }
                            print("Remove IndexPath:-\(self.selectedIndexPath)")
                            
                            do {
                                try fileManager.removeItem(atPath: filePath1)
                                self.downloadAll = false
                                self.showLabel(message: "1 \((self.appDelegate.ArryLngResponeCustom!["video_removed"] as? String)!)") //video is removed from downloads.
                                self.courseDetailTableView.reloadData()
                                
                            } catch {
                                print("Could not clear temp folder: \(error)")
                            }
                            self.getAllDowloadFlag()
                        }))
                        
                        let cancelBtn = UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["cancel"] as? String)!, style: UIAlertActionStyle.cancel, handler: nil)
                        //"Cancel"
                        cancelBtn.setValue(UIColor.red, forKey: "titleTextColor")
                        actionSheet.addAction(cancelBtn)
                        present(actionSheet, animated: true, completion: nil)
                    }else {
                        print("New File= \(filePath)")
                        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                        
                        let subview = (actionSheet.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
                        subview.backgroundColor = UIColor().HexToColor(hexString: self.ActiveBgColor)
                        subview.layer.cornerRadius = 10
                        subview.alpha = 1
                        subview.layer.borderWidth = 1
                        subview.layer.borderColor = UIColor.darkGray.cgColor
                        subview.clipsToBounds = true
                        
                        actionSheet.view.tintColor = UIColor().HexToColor(hexString: self.txtNavcolorHex)
                        actionSheet.addAction(UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["start_download"] as? String)!, style: .default, handler: { (UIAlertAction) in
                            //Start Download
                            if self.selectedIndexPath.count != 0 {
                                for index in self.selectedIndexPath {
                                    if index != indexPath {
                                        self.selectedIndexPath.append(IndexPath(row: row, section: section))
                                        break
                                    }
                                }
                            }else {
                                self.selectedIndexPath.append(IndexPath(row: row, section: section))
                            }
                            
                            print("Current IndexPath:-\(self.selectedIndexPath)")
                            
                            if validation.isConnectedToNetwork() == true {
                                cellObj.imgDownload.isHidden = true
                                cellObj.btnDownload.isHidden = true
                                cellObj.activityIndicator.startAnimating()
                                self.showLabel(message: "1 \((self.appDelegate.ArryLngResponeCustom!["video_downloading"] as? String)!)")
                                //video started downloading..
                                self.downloadAll = false
                                self.fileTypeFlag = "1"
                                self.downloadSingleFile(webUrl: (dic["url"] as? String)!, localUrl: currentVideoURL)
                                //self.downloadSingleFile(webUrl: (dic["downloadurl"] as? String)!, localUrl: currentVideoURL)
                                self.offlineLesson()
                            }else {
                                self.showLabel(message: string.noInternateMessage2)
                            }
                        }))
                        
                        let cancelBtn = UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["cancel"] as? String)!, style: UIAlertActionStyle.cancel, handler: nil)
                        cancelBtn.setValue(UIColor.red, forKey: "titleTextColor")
                        actionSheet.addAction(cancelBtn)
                        present(actionSheet, animated: true, completion: nil)
                    }
                }
            }
                
            else if arryOfaudioData.count != 0 {
                var dic = arryOfaudioData[0]
                course_topics_lectures_media_id = dic["course_topics_lectures_media_id"] as! String
                if ((dic["url"] as? String) != nil) {
                //if ((dic["downloadurl"] as? String) != nil) { //HLS - download this when u use HLS
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let currentAudioURL = documentsURL.appendingPathComponent("audio\(course_id)_\(topic_id)_\(lecture_id)_\(course_topics_lectures_media_id).mp3")
                    
                    let filePath1 = currentAudioURL.relativePath
                    print("filePath1 :" ,filePath1)
                    let filePath = currentAudioURL.relativeString
                    print("filePath :" ,filePath)
                    
                    let fileManager = FileManager.default
                    // Check if file not exists
                    if fileManager.fileExists(atPath: filePath1) {
                        print("Local path Exists = \(filePath)")
                        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                        
                        let subview = (actionSheet.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
                        subview.backgroundColor = UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0)
                        subview.layer.cornerRadius = 10
                        subview.alpha = 1
                        subview.layer.borderWidth = 1
                        subview.layer.borderColor = UIColor.darkGray.cgColor
                        subview.clipsToBounds = true
                        
                        actionSheet.view.tintColor = UIColor.white
                        actionSheet.addAction(UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["remove_download"] as? String)!, style: .default, handler: { (UIAlertAction) in
                            //"Remove Download"
                            cellObj.imgDownload.image = UIImage()
                            for (index,elememt) in self.selectedIndexPath.enumerated(){
                                if section == elememt.section &&  row == elememt.row{
                                    self.selectedIndexPath.remove(at: index)
                                }
                            }
                            print("Remove IndexPath:-\(self.selectedIndexPath)")
                            
                            do {
                                try fileManager.removeItem(atPath: filePath1)
                                self.downloadAll = false
                                self.showLabel(message: "1 \((self.appDelegate.ArryLngResponeCustom!["audio_removed"] as? String)!)")
                                //audio is removed from downloads.
                                self.courseDetailTableView.reloadData()
                                
                            } catch {
                                print("Could not clear temp folder: \(error)")
                            }
                            self.getAllDowloadFlag()
                        }))
                        
                        let cancelBtn = UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["cancel"] as? String)!, style: UIAlertActionStyle.cancel, handler: nil)
                        cancelBtn.setValue(UIColor.red, forKey: "titleTextColor")
                        actionSheet.addAction(cancelBtn)
                        present(actionSheet, animated: true, completion: nil)
                    }else {
                        print("New File= \(filePath)")
                        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                        
                        let subview = (actionSheet.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
                        subview.backgroundColor = UIColor().HexToColor(hexString: self.NavBgcolor)
                        subview.layer.cornerRadius = 10
                        subview.alpha = 1
                        subview.layer.borderWidth = 1
                        subview.layer.borderColor = UIColor.darkGray.cgColor
                        subview.clipsToBounds = true
                        
                        //let titleFont = [NSAttributedStringKey.font: checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(NavTxtSize))]
                        //let messageFont = [NSAttributedStringKey.font: checkForFontType(fontStyle: NavTxtStyle, fontSize: CGFloat(NavTxtSize))]
                        
                        //let titleAttrString = NSMutableAttributedString(string: "Start Download", attributes: titleFont)
                        //let messageAttrString = NSMutableAttributedString(string: "Message Here", attributes: messageFont)
                        
                        //alertController.setValue(titleAttrString, forKey: "attributedTitle")
                        //alertController.setValue(messageAttrString, forKey: "attributedMessage")
                        
                        actionSheet.view.tintColor = UIColor().HexToColor(hexString: self.txtNavcolorHex)
                        actionSheet.addAction(UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["start_download"] as? String)!, style: .default, handler: { (UIAlertAction) in
                            //"Start Download"
                            /*let origImage = UIImage(named: "down-arrow-green");
                             let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                             cellObj.btnDownload.setBackgroundImage(tintedImage, for: .normal)
                             cellObj.btnDownload.tintColor = UIColor().HexToColor(hexString: self.NavBgcolor)*/
                            
                            if self.selectedIndexPath.count != 0 {
                                for index in self.selectedIndexPath {
                                    if index != indexPath {
                                        self.selectedIndexPath.append(IndexPath(row: row, section: section))
                                        break
                                    }
                                }
                            }else {
                                self.selectedIndexPath.append(IndexPath(row: row, section: section))
                            }
                            
                            print("Current IndexPath:-\(self.selectedIndexPath)")
                            
                            if validation.isConnectedToNetwork() == true {
                                cellObj.imgDownload.isHidden = true
                                cellObj.btnDownload.isHidden = true
                                cellObj.activityIndicator.startAnimating()
                                self.showLabel(message: "1 \((self.appDelegate.ArryLngResponeCustom!["audio_downloading"] as? String)!)")
                                //audio started downloading..
                                self.downloadAll = false
                                self.fileTypeFlag = "2"
                                self.downloadSingleFile(webUrl: (dic["url"] as? String)!, localUrl: currentAudioURL)
                                //HLS - download this when u use HLS
                                //self.downloadSingleFile(webUrl: (dic["downloadurl"] as? String)!, localUrl: currentAudioURL)
                                self.offlineLesson()
                            }else {
                                self.showLabel(message: string.noInternateMessage2)
                            }
                        }))
                        
                        let cancelBtn = UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["cancel"] as? String)!, style: UIAlertActionStyle.cancel, handler: nil)
                        cancelBtn.setValue(UIColor.red, forKey: "titleTextColor")
                        actionSheet.addAction(cancelBtn)
                        present(actionSheet, animated: true, completion: nil)
                    }
                }
            }
        }
        
    }
    
    @objc func moreClkTbl(_ sender : UIButton?){
        let section = (sender?.tag)! / 1000
        let row = (sender?.tag)! % 1000
//        let indexPath = IndexPath(row: row, section: section)
        
        let data = arryWSQuestionData[section]
        question_id = data["course_questions_id"] as! String
        
        let answerVC = self.storyboard?.instantiateViewController(withIdentifier: "AnswerDetailsVC") as! AnswerDetailsVC
        answerVC.questionID = question_id
        answerVC.titleString = data["question"] as! String
        self.navigationController?.pushViewController(answerVC, animated: true)
    }
    @objc func btnAddAuidoclk(_ sender : UIButton?){
        let section = (sender?.tag)! / 1000
        let row = (sender?.tag)! % 1000
        //let indexPath = IndexPath(row: row, section: section)
        let data = arryWSQuestionData[section]
        strSection = section
        
        self.mianBgviewOfRecording.isHidden = false
        self.view.bringSubview(toFront: self.mianBgviewOfRecording)
        
        runTimer()
        
        //self.btnStartRecording.setImage(UIImage(named:"mic"), for: .normal)
        if recordingFlag == 0{
            recordingFlag = 1
            do {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
                //recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
                //(currentDict["filePath"] as! URL != nil)
                startRecording()
            } catch _ {
                print("error ")
            }
        }else {
            recordingFlag = 0
            //self.btnStartRecording.setImage(UIImage(named:"pausrecording"), for: .normal)
            self.finishRecording(success: true)
        }
        
    }
    func runTimer() {
        recordingTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(CourseTemplateDetails.updateTimer)), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {
        seconds += 1     //This will decrement(count down)the seconds.
        lblOfAudioCount.text = "\(seconds)" //This will update the label.
        
        let hours = Int(seconds) / 3600
        let minutes = Int(seconds) / 60 % 60
        let seconds1 = Int(seconds) % 60
        
        lblOfAudioCount.text = String(format:"%02i:%02i", minutes, seconds1)
    }
    
    @objc func playClk(_ sender : UIButton?){
        
        //USER PLAY AUDIO
        let section = (sender?.tag)! / 1000
        let row = (sender?.tag)! % 1000
        
        let indexPath = IndexPath(row: row, section: section)
        let cellObj = self.tblViewQA.cellForRow(at:indexPath) as! QATableViewCell
        
        let arryData = arryWSQuestionData[section]
        let answerArry = arryData["answer"] as? [Any]
        let anserDic = answerArry![indexPath.row] as? [String:Any]
        
        if playerFlag == 0{
            do {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
                
                //AVAudioSession(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
                //(currentDict["filePath"] as! URL != nil)
                if (anserDic?.keys.contains("answer"))!{
                    self.playerFlag = 2
                    let auidoUrl = URL(string:(anserDic!["answer"] as? String)!)!
                    
                    print("answer URl ",auidoUrl )
                    
                    cellObj.imgPlay.image = UIImage(named: "stop")
                    
                    player = AVPlayer(url: auidoUrl)
                    player?.play()
                }
            } catch let error {
                print("error ",error.localizedDescription)
            }
        }else {
            playerFlag = 0
            self.player?.pause()
            cellObj.imgPlay.image = UIImage(named: "play")
        }
    }
    func showLabel(message:String) {
        self.lblDownloadingStatus.isHidden = false
        self.lblDownloadingStatus.backgroundColor = UIColor().HexToColor(hexString: self.NavBgcolor)
        self.lblDownloadingStatus.textColor = UIColor().HexToColor(hexString: self.GenarlTxtcolorHex)//UIColor.white
        self.lblDownloadingStatus.font = UIFont.systemFont(ofSize: CGFloat(bottomTextSize + 2))
        self.lblDownloadingStatus.text = message
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)
    }
    
    @objc func dismissAlert(){
        if !self.lblDownloadingStatus.isHidden { // Dismiss the view from here
            self.lblDownloadingStatus.isHidden = true
        }
    }
}

//MARK:- Local Storage
extension CourseTemplateDetails {
    func saveToJsonFile(jsonArray:[String:Any])  {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("OfflineCourse.json")
        print(#function,fileUrl)
        //Transform array into data and save it into file
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(#function,"Data Could not stored in local")
        }
    }
}

//MARK:- ScrollView Delegate
extension CourseTemplateDetails: UIScrollViewDelegate {
    /*func scrollViewDidScroll(_ scrollView: UIScrollView) {
        goingUp = scrollView.panGestureRecognizer.translation(in: scrollView).y < 0
        
        let parentViewMaxContentYOffset = parentScrollView.contentSize.height - parentScrollView.frame.height
        
        if goingUp! {
            if scrollView == courseDetailTableView {
                if parentScrollView.contentOffset.y < parentViewMaxContentYOffset && !childScrollingDownDueToParent {
                    parentScrollView.contentOffset.y = min(parentScrollView.contentOffset.y + courseDetailTableView.contentOffset.y, parentViewMaxContentYOffset)
                    courseDetailTableView.contentOffset.y = 0
                }
            }
            else if scrollView == tblViewQA {
                if parentScrollView.contentOffset.y < parentViewMaxContentYOffset && !childScrollingDownDueToParent {
                    parentScrollView.contentOffset.y = min(parentScrollView.contentOffset.y + tblViewQA.contentOffset.y, parentViewMaxContentYOffset)
                    tblViewQA.contentOffset.y = 0
                }
            }
        }
        else {
            if scrollView == courseDetailTableView {
                if courseDetailTableView.contentOffset.y < 0 && parentScrollView.contentOffset.y > 0 {
                    parentScrollView.contentOffset.y = max(parentScrollView.contentOffset.y - abs(courseDetailTableView.contentOffset.y), 0)
                }
            }
            else if scrollView == tblViewQA {
                if tblViewQA.contentOffset.y < 0 && parentScrollView.contentOffset.y > 0 {
                    parentScrollView.contentOffset.y = max(parentScrollView.contentOffset.y - abs(tblViewQA.contentOffset.y), 0)
                }
            }
            if scrollView == parentScrollView {
                if courseDetailTableView.contentOffset.y > 0 && parentScrollView.contentOffset.y < parentViewMaxContentYOffset {
                    childScrollingDownDueToParent = true
                    courseDetailTableView.contentOffset.y = max(courseDetailTableView.contentOffset.y - (parentViewMaxContentYOffset - parentScrollView.contentOffset.y), 0)
                    parentScrollView.contentOffset.y = parentViewMaxContentYOffset
                    childScrollingDownDueToParent = false
                }
                else if tblViewQA.contentOffset.y > 0 && parentScrollView.contentOffset.y < parentViewMaxContentYOffset {
                    childScrollingDownDueToParent = true
                    tblViewQA.contentOffset.y = max(tblViewQA.contentOffset.y - (parentViewMaxContentYOffset - parentScrollView.contentOffset.y), 0)
                    parentScrollView.contentOffset.y = parentViewMaxContentYOffset
                    childScrollingDownDueToParent = false
                }
            }
        }
    }*/
}

//MARK:- WS Parsing
extension CourseTemplateDetails {
    
    //MARK: WS GET LESSONS
    func callWSOfLesson(){
        
        //URL : http://27.109.19.234/app_builder/index.php/api/getallCourseData?appclientsId=1&userId=1&userPrivateKey=P6HwAapNVu4WK1Ts&appId=1&courseId=6
        
        var strTopicId = ""
        if self.isDisplayAlltopic == "1"{
            strTopicId = self.StrCourseTopicId
        }else {
            strTopicId = ""
        }
        var dictionary = [String:String]()
        
        if self.isDisplayAlltopic == "1"{
            dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "courseId" : StrCourseCatgryId,
                          "topicId":strTopicId]
        }else {
            dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "courseId" : StrCourseCatgryId]
        }
        
        
        print("I/P Lesson:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getallCourseData?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            if flgActivity1{
                self.startActivityIndicator()
            }
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSOfCallWSOfLesson(strURL: strURL, dictionary: dictionary )
        }else{
            stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOfCallWSOfLesson(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            //print("getallCourseData ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    //self.refreshControl1.endRefreshing()
                    if let arrayData = JSONResponse["courseDetails"] as? [String:Any]{
                        self.arryWSLessonData = arrayData
                        self.configureUI()
                    }
                    else{
                        self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.oppsMsg, lableNoInternate: string.noDataFoundMsg)
                        self.courseDetailTableView.addSubview(self.noDataView)
                    }
                }
            }
            else{
                let status = JSONResponse["status"] as? String
                self.stopActivityIndicator()
                self.noDataLabel(str: (JSONResponse["message"] as? String)!)
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
                        
                        let btnOK = UIAlertAction(title: "OK", style: .default, handler: { action in
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
                        //self.errorCodeAlert(title: (JSONResponse["title"] as? String)!, description: (JSONResponse["description"] as? String)!, errorCode: (JSONResponse["systemErrorCode"] as? String)!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)

                        self.noDataLabel(str: ((JSONResponse["description"] as? String)! + " [\((JSONResponse["systemErrorCode"] as? String)!)]"))
                    }
                    break
                default:
                    //self.view.makeToast((JSONResponse["systemMsg"] as? String)!)
                    self.errorCodeAlert(title: (JSONResponse["title"] as? String)!, description: (JSONResponse["description"] as? String)!, errorCode: (JSONResponse["systemErrorCode"] as? String)!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)
                    print("error1: ");
                }
            }
        }, failure: { (error) in
            self.apiSuccesFlag = "2"
            self.stopActivityIndicator()
            print("error: ",error)
            DispatchQueue.main.async{
                self.noDataLabel(str: string.someThingWrongMsg)
            }
        })
    }
    
    //MARK:- WS offlineLesson
    func offlineLesson(){
        
        //URL : http://27.109.19.234/app_builder/index.php/api/offlineLesson?appclientsId=1&userId=1&userPrivateKey=zJSn1gY5PvDop9O1&appId=1&courseId=5&topicId=2&lectureId=6
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateTimeStr = formatter.string(from: Date())

        
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "courseId" : courseId,
                          "topicId": topicId,
                          "lectureId" :lectureId,
                          "datetime" : dateTimeStr]
        
        print("I/P offline:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "offlineLesson?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSOfofflineLesson(strURL: strURL, dictionary: dictionary )
        }else{
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOfofflineLesson(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            //print("JSONResponse Offline", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.saveToJsonFile(jsonArray: JSONResponse)
                }
            } else{
                //self.view.makeToast(JSONResponse["status"] as! String)
            }
        }, failure: { (error) in
            self.apiSuccesFlag = "2"
            print("error: ",error)
            DispatchQueue.main.async{
                self.view.makeToast(string.someThingWrongMsg)
            }
        })
    }
    
    //MARK: WS Get Question List
    func callWSOfGetQuestion(){
        
        //URL : http://27.109.19.234/app_builder/index.php/api/getQuestions?appclientsId=1&userId=2&userPrivateKey=dfsft43wtv4t534f&appId=1&courseId=2&flag=0
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "courseId" : StrCourseCatgryId,
                          "flag": questionType]
        
        print("I/P GetQuestion:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getQuestions?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            if flgActivity{
                self.startActivityIndicator()
            }
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSOfGetQuestion(strURL: strURL, dictionary: dictionary )
        }else{
            stopActivityIndicator()
            self.refreshControl.endRefreshing()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOfGetQuestion(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            print("JSONResponse GetQuestions", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.refreshControl.endRefreshing()
                    self.arryWSQuestionData.removeAll()
                    if let arrayData = JSONResponse["data"] as? [[String:Any]]{
                        if arrayData.count != 0 {
                            if self.switchQuestions.isOn {
                                self.arrAllQuestion = arrayData
                                self.arryWSQuestionData = arrayData
                                self.tblViewQA.reloadData()
                            }else {
                                self.sortQuestions(arr: arrayData)
                            }
                            self.noDataLabel(str: "")
                        }
                    } else{
                        self.noDataLabel(str: "Question not available")
                    }
                }
            }else{
                let status = JSONResponse["status"] as? String
                self.stopActivityIndicator()
                self.noDataLabel(str: "Question not available")
                self.arrAllQuestion.removeAll()
                self.arryWSQuestionData.removeAll()
                
                self.refreshControl.endRefreshing()
                switch status!{
                case "0":
                    self.arryWSQuestionData.removeAll()
                    self.tblViewQA.reloadData()
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
                            //"OK"
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
                        
                    }else if (JSONResponse["errorCode"] as? String) == userInfo.dataErrorCode {
                        self.noDataLabel(str: (self.appDelegate.ArryLngResponSystm!["all_questions_blank_msg"] as? String)!)
                    }else {
                        self.noDataLabel(str: ((JSONResponse["description"] as? String)! + " [\((JSONResponse["systemErrorCode"] as? String)!)]"))
                        
                        //self.errorCodeAlert(title: (JSONResponse["title"] as? String)!, description: (JSONResponse["description"] as? String)!, errorCode: (JSONResponse["systemErrorCode"] as? String)!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)
                    }
                    break
                default:
                    //self.view.makeToast((JSONResponse["systemMsg"] as? String)!)
                    self.errorCodeAlert(title: (JSONResponse["title"] as? String)!, description: (JSONResponse["description"] as? String)!, errorCode: (JSONResponse["systemErrorCode"] as? String)!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)
                    print("error1: ");
                }
            }
        }, failure: { (error) in
            self.apiSuccesFlag = "2"
            self.stopActivityIndicator()
            self.refreshControl.endRefreshing()
            print("error: ",error)
            DispatchQueue.main.async{
                self.noDataLabel(str: string.someThingWrongMsg)
            }
        })
    }
    
    //MARK: WS MARK READ
    func callWSOfmarkRead(){
        
        //URL : http://27.109.19.234/app_builder/index.php/api/readunreadQuestion?appclientsId=1&userId=19&userPrivateKey=WNx5Li12UHflY7w4&appId=1&questionId=1
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "questionId" : question_id]
        
        print("I/P markRead:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "readunreadQuestion?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            if flgActivity{
                self.startActivityIndicator()
            }
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.WSOfmarkRead(strURL: strURL, dictionary: dictionary )
        }else{
            stopActivityIndicator()
            self.refreshControl.endRefreshing()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func WSOfmarkRead(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            print("JSONResponse MarkRead", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.refreshControl.endRefreshing()
//                    self.view.makeToast((JSONResponse["message"] as? String)!)
                    self.callWSOfGetQuestion()
                }
            }
            else{
                let status = JSONResponse["status"] as? String
                self.stopActivityIndicator()
                self.refreshControl.endRefreshing()
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
                        //self.view.makeToast((JSONResponse["message"] as? String)!)
                        self.errorCodeAlert(title: (JSONResponse["title"] as? String)!, description: (JSONResponse["description"] as? String)!, errorCode: (JSONResponse["systemErrorCode"] as? String)!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)
                    }
                    break
                default:
                    //self.view.makeToast((JSONResponse["systemMsg"] as? String)!)
                    self.errorCodeAlert(title: (JSONResponse["title"] as? String)!, description: (JSONResponse["description"] as? String)!, errorCode: (JSONResponse["systemErrorCode"] as? String)!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)
                    print("error1: ");
                }
            }
        }, failure: { (error) in
            self.apiSuccesFlag = "2"
            self.stopActivityIndicator()
            self.refreshControl.endRefreshing()
            print("error: ",error)
            DispatchQueue.main.async{
                self.view.makeToast(string.someThingWrongMsg)
            }
        })
    }
    
    //MARK: WS deleteQuestion
    func callWSOfdeleteQuestion(){
        
        //URL : http://27.109.19.234/app_builder/index.php/api/deleteQuestion?appclientsId=1&userId=1&userPrivateKey=yJ4iF4r8z2EabBTq&appId=1&questionId=1
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "questionId" : question_id]
        
        print("I/P deleteQuestion:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "deleteQuestion?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            if flgActivity{
                self.startActivityIndicator()
            }
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.WSOfdeleteQuestion(strURL: strURL, dictionary: dictionary )
        }else{
            stopActivityIndicator()
            self.refreshControl.endRefreshing()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func WSOfdeleteQuestion(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            print("JSONResponse deleteQuestion", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.refreshControl.endRefreshing()
                    self.view.makeToast((JSONResponse["message"] as? String)!)
                    self.callWSOfGetQuestion()
                }
            }
            else{
                let status = JSONResponse["status"] as? String
                self.stopActivityIndicator()
                self.refreshControl.endRefreshing()
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
                        //self.view.makeToast((JSONResponse["message"] as? String)!)
                        self.errorCodeAlert(title: (JSONResponse["title"] as? String)!, description: (JSONResponse["description"] as? String)!, errorCode: (JSONResponse["systemErrorCode"] as? String)!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)
                    }
                    break
                default:
                    //self.view.makeToast((JSONResponse["systemMsg"] as? String)!)
                    self.errorCodeAlert(title: (JSONResponse["title"] as? String)!, description: (JSONResponse["description"] as? String)!, errorCode: (JSONResponse["systemErrorCode"] as? String)!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)
                    print("error1: ");
                }
            }
        }, failure: { (error) in
            self.apiSuccesFlag = "2"
            self.stopActivityIndicator()
            self.refreshControl.endRefreshing()
            print("error: ",error)
            DispatchQueue.main.async{
                self.view.makeToast(string.someThingWrongMsg)
            }
        })
    }
    
    //MARK:- API of send Audio
    func callWSAudio(QuestionID : String, strurl:URL ){
        //URL: http://27.109.19.234/app_builder/index.php/api/addAnswer?appclientsId=1&userId=1&userPrivateKey=Jg3K5zbmYa06QREp&appId=1&questionId=16&answerType=0&answer=same%20reply&flag=1
        
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "questionId" : QuestionID,
                          "answerType" : "1", //1: audio and 0: text
                          "flag" : userInfo.adminUserflag] as [String : Any] //admin: 1 and user: 0
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "addAnswer?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            if flgActivity{
                self.startActivityIndicator()
            }
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSOfAddAudio(strURL: strURL, dictionary: dictionary as! Dictionary<String, String>, strAudioUrl: strurl)
        }else{
            stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOfAddAudio(strURL: String, dictionary:Dictionary<String,String>, strAudioUrl: URL){
            AFWrapper.requestPostURLForUploadAudio(strURL, isAudioSelect: true, fileName: "answer", params: dictionary as [String : AnyObject], audioURL: strAudioUrl, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            print("JSONResponse addAnswer", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.view.makeToast((JSONResponse["message"] as? String)!)
                    self.mianBgviewOfRecording.isHidden = true
                    self.seconds = 0.0
                    self.callWSOfGetQuestion()
                    
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
                        //self.view.makeToast((JSONResponse["message"] as? String)!)
                        self.errorCodeAlert(title: (JSONResponse["title"] as? String)!, description: (JSONResponse["description"] as? String)!, errorCode: (JSONResponse["systemErrorCode"] as? String)!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)
                    }
                    break
                default:
                    //self.view.makeToast((JSONResponse["message"] as? String)!)
                    self.errorCodeAlert(title: (JSONResponse["title"] as? String)!, description: (JSONResponse["description"] as? String)!, errorCode: (JSONResponse["systemErrorCode"] as? String)!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)
                    print("error1: ");
                }
            }
        }, failure: { (error) in
            self.apiSuccesFlag = "2"
            self.stopActivityIndicator()
            print("error: ",error)
            DispatchQueue.main.async{
                self.view.makeToast(string.someThingWrongMsg)
            }
        })
    }
   
}

//VISHAL
//MARK: - Danyamic video API
extension CourseTemplateDetails {
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
            strDutnTime = "\(formatTimeFor(seconds: playhead))"
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
    
    //MARK: WS of DanyamicVideo
    func callWSOfDanyamicVideo(urlStr: String,strTopicID:String,strLectureID:String){
        
        //URL : http://27.109.19.234/app_builder/index.php/api/videoViewDetails?appclientsId=1&userId=1&userPrivateKey=yJ4iF4r8z2EabBTq&appId=1&course_category_id=1&course_topics_lectures_id=1&viewed_duration=15:25:12&next_course_topics_lectures_id=2

        print("strTopicID: ",strTopicID,"strLectureID: ",strLectureID)
        
        if strTopicID != "" && strLectureID != "" {
            //play Audio/Video Logic
            if UserDefaults.standard.value(forKey: "playAudioVideoData") != nil {
                
                playAudioVideoArry = UserDefaults.standard.value(forKey: "playAudioVideoData") as! [[String:Any]]
                var arryPstn = -1
                for index in 0..<playAudioVideoArry.count {
                    var allKeys = playAudioVideoArry[index] as! [String:String]
                    if allKeys["course_id"] == self.StrCourseCatgryId && allKeys["topic_id"] == strTopicID && allKeys["user_id"] == userInfo.userId {
                        arryPstn = index
                        break
                    }
                }
                if arryPstn == -1 {
                    playAudioVideoArry.append(["course_id":self.StrCourseCatgryId,"topic_id":strTopicID,"lecture_id":strLectureID,"user_id":userInfo.userId])
                    UserDefaults.standard.set(playAudioVideoArry, forKey: "playAudioVideoData")
                }else {
                    var allKeys = playAudioVideoArry[arryPstn] as! [String:String]
                    allKeys["lecture_id"] = strLectureID
                    playAudioVideoArry.remove(at: arryPstn)
                    playAudioVideoArry.insert(["course_id":self.StrCourseCatgryId,"topic_id":strTopicID,"lecture_id":strLectureID,"user_id":userInfo.userId], at: arryPstn)
                    UserDefaults.standard.set(playAudioVideoArry, forKey: "playAudioVideoData")
                }
            }else {
                playAudioVideoArry.append(["course_id":self.StrCourseCatgryId,"topic_id":strTopicID,"lecture_id":strLectureID,"user_id":userInfo.userId])
                UserDefaults.standard.set(playAudioVideoArry, forKey: "playAudioVideoData")
            }
        }
        
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "course_category_id" : StrCourseCatgryId, //Course_id
            "course_topics_lectures_id": self.lastPlayedVideo, //lecture_id
            "viewed_duration" : strLastVideAudioDuration,
            "next_course_topics_lectures_id": self.strNextCoursTopicLecturesId]
        
        print("I/P videoViewDetails:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "videoViewDetails?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            if flgActivity{
                self.startActivityIndicator()
            }
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.WSOfDanyamicVideo(strURL: strURL, dictionary: dictionary, urlVideoStr: urlStr ,strTopicID:"",strLectureID:"")
        }else{
            self.autoPlay = "1"
            stopActivityIndicator()
            self.refreshControl.endRefreshing()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func WSOfDanyamicVideo(strURL: String, dictionary:Dictionary<String,String> ,urlVideoStr:String,strTopicID:String,strLectureID:String){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            print("JSONResponse videoViewDetails", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.refreshControl.endRefreshing()
                    //self.strNextCoursTopicLecturesId = self.strCourseTopicsLecturesId
                    let data = JSONResponse["response"] as! [String:Any]
                    print("Data of vedio view : ",data)
                    var strVideoDuration = data["video_last_viewed_duration"] as? String
                    var strAudioDuration = data["audio_last_viewed_duration"] as? String
                    
                    let videoCompleteFlag = data["video_complete_flag"] as! String
                    print("videoCompleteFlag ::",videoCompleteFlag)
                    
                    if videoCompleteFlag == "1" {
                        strVideoDuration = data["new_duration"] as? String
                        strAudioDuration = data["new_duration"] as? String
                        
                        print("str Audio Duration After ND: ",strAudioDuration ?? "00:00")
                        print("str video Duration After ND: ",strVideoDuration ?? "00:00")
                    }
                    
                    if self.flagFroAudiVideo == "1"{
                        //Video
                        if urlVideoStr != ""{
                            if validation.checkNotNullParameter(checkStr: strVideoDuration!) {
                                self.strVideoTime = "00:00:00"
                                //self.viewofAudio.isHidden = true
                                self.videoAudioPlayer(urlStr:urlVideoStr, StrstartTime: self.strVideoTime)
                            }else {
                                self.strVideoTime = strVideoDuration!
                                //self.viewofAudio.isHidden = true
                                self.videoAudioPlayer(urlStr:urlVideoStr, StrstartTime:  self.strVideoTime)
                            }
                        }
                    }else if self.flagFroAudiVideo == "2" {
                        //Audio
                        if urlVideoStr != ""{
                            if validation.checkNotNullParameter(checkStr: strAudioDuration!) {
                                self.strAudioTime = "00:00:00"
                                self.playerFlag = 0
                                self.playSoundWith(urlString: urlVideoStr ,strDuration:  self.strAudioTime)
                            }else {
                                let strArry1 = strVideoDuration?.components(separatedBy: ":")
                                print("str count ",strArry1?.count ?? "0")
                                var strTemp = ""
                                if strArry1?.count == 2 {
                                    strTemp = "00:" + (strAudioDuration)!
                                }else {
                                    strTemp = strAudioDuration!
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
                                print("self.strAudioTime",self.strAudioTime)
                                //self.strAudioTime = strAudioDuration!
                                self.playerFlag = 0
                                self.playSoundWith(urlString: urlVideoStr ,strDuration: self.strAudioTime)
                            }
                        }
                    }
                    self.strViewedDuration = "00:00:00"
                }
            }
            else{
                self.autoPlay = "1"
                let status = JSONResponse["status"] as? String
                self.stopActivityIndicator()
                self.refreshControl.endRefreshing()
                switch status!{
                case "0":
                    print("error2: ")
                    if (JSONResponse["errorCode"] as? String) == userInfo.logOuterrorCode {
                        
                        let alrtTitleStr = NSMutableAttributedString(string: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String))
                        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                        
                        let alrtMessage = NSMutableAttributedString(string: string.privateKeyMsg)
                        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                        
                        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                        alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                        alertController.setValue(alrtMessage, forKey: "attributedMessage")
                        
                        let btnOK = UIAlertAction(title: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!, style: .default, handler: { action in
                            self.player1.pause()
                            self.player?.pause()
                            
                            DispatchQueue.main.async{
                                let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                                for aViewController in viewControllers {
                                    if aViewController is Login {
                                        self.navigationController!.popToViewController(aViewController, animated: true)
                                    }
                                }
                            }
                        })
                        alertController.addAction(btnOK)
                        self.present(alertController, animated: true, completion: nil)
                    }else {
                        //self.view.makeToast((JSONResponse["message"] as? String)!)
                        print("error2 ",(JSONResponse["message"] as? String)!)
                    }
                    break
                default:
                    //self.view.makeToast((JSONResponse["systemMsg"] as? String)!)
                    print("error1: ");
                }
            }
        }, failure: { (error) in
            self.autoPlay = "1"
            self.apiSuccesFlag = "2"
            self.stopActivityIndicator()
            self.refreshControl.endRefreshing()
            print("error: ",error)
            DispatchQueue.main.async{
                self.view.makeToast(string.someThingWrongMsg)
            }
        })
    }
    
    func getLastAudiVideoDuration(){
        
        var strArry = [String]()
        if self.flagFroAudiVideo == "1"{
            var strngTime :Double = 1.0
            strngTime = self.player1.currentDuration
            print("Video Player currentDuration ",strngTime)
            strViewedDuration = String(formatTimeFor(seconds: strngTime))
            strArry = strViewedDuration.components(separatedBy: ":")
            print("Video strViewedDuration ",strViewedDuration)
        }else {
            updateTime()
            strArry = strViewedDuration.components(separatedBy: ":")
            print("Audio strViewedDuration ",strViewedDuration)
        }
        
        if strViewedDuration == "" {
            strLastVideAudioDuration = "00:00:00"
        }else if strArry.count == 2 {
            strLastVideAudioDuration = "00:" + (strViewedDuration)
        }else {
            strLastVideAudioDuration = strViewedDuration
        }
    }
    
    //MARK:- API of Update Notification Count
    func callWSNotifcnCuntUpdate(){
        //URL: http://27.109.19.234/app_builder/index.php/api/updateCount?appclientsId=1&userId=7&userPrivateKey=NzVxHjwaB6Sqm2u5&appId=1&itemType=2&id=3
        
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "itemType" : "1",
                          "id":self.StrCourseCatgryId] as [String : Any]
        
        print("I/P updateCount :",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "updateCount?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSUpdateNofictnCount(strURL: strURL, dictionary: dictionary as! Dictionary<String, String>)
        }else{
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSUpdateNofictnCount(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            if JSONResponse["status"] as? String == "1"{
                
            }
            else{
                let status = JSONResponse["status"] as? String
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
            print("error: ",error)
        })
    }
    
    
}
//MARK:- AlertController
extension UIView {
    
    var recursiveSubviews: [UIView] {
        var subviews = self.subviews.flatMap({$0})
        subviews.forEach { subviews.append(contentsOf: $0.recursiveSubviews) }
        return subviews
    }
}


extension UIAlertController {
    
    private struct AssociatedKeys {
        static var blurStyleKey = "UIAlertController.blurStyleKey"
    }
    
    public var blurStyle: UIBlurEffectStyle {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.blurStyleKey) as? UIBlurEffectStyle ?? .extraLight
        } set (style) {
            objc_setAssociatedObject(self, &AssociatedKeys.blurStyleKey, style, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
    public var cancelButtonColor: UIColor? {
        return blurStyle == .dark ? UIColor(red:0.50, green:0.72, blue:0.30, alpha:1.0) : nil
    }
    
    private var visualEffectView: UIVisualEffectView? {
        if let presentationController = presentationController, presentationController.responds(to: Selector(("popoverView"))), let view = presentationController.value(forKey: "popoverView") as? UIView // We're on an iPad and visual effect view is in a different place.
        {
            return view.recursiveSubviews.flatMap({$0 as? UIVisualEffectView}).first
        }
        
        return view.recursiveSubviews.flatMap({$0 as? UIVisualEffectView}).first
    }
    
    private var cancelActionView: UIView? {
        return view.recursiveSubviews.flatMap({
            $0 as? UILabel}
            ).first(where: {
                $0.text == actions.first(where: { $0.style == .cancel })?.title
            })?.superview?.superview
    }
    
    public convenience init(title: String?, message: String?, preferredStyle: UIAlertControllerStyle, blurStyle: UIBlurEffectStyle) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        self.blurStyle = blurStyle
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        visualEffectView?.effect = UIBlurEffect(style: blurStyle)
        cancelActionView?.backgroundColor = cancelButtonColor
    }
}

extension CourseTemplateDetails {
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?){
        print("Error",error.debugDescription)
        recordingFlag = 0
        if self.playerFlag == 1 {
            self.audioPlayer.stop()
        }else if self.playerFlag == 2{
            self.player?.pause()
        }
    }
    internal func audioPlayerBeginInterruption(_ player: AVAudioPlayer){
        print("audioPlayerBeginInterruption",player.debugDescription)
        recordingFlag = 0
        if self.playerFlag == 1 {
            self.audioPlayer.stop()
        }else if self.playerFlag == 2{
            self.player?.pause()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            self.finishRecording(success: false)
        }
    }
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        if success {
            print("success",success)
        } else {
            print("Somthing Wrong.")
        }
    }
}

extension WKWebView {
    func loadUrl(string: String) {
        if let url = URL(string: string) {
            load(URLRequest(url: url))
        }
    }
}
//MARK:- Video Player Delegate
extension CourseTemplateDetails: VGPlayerDelegate {
    func vgPlayer(_ player: VGPlayer, playerFailed error: VGPlayerError) {
        print("Error to play file ",error)

        //callWSOfDanyamicVideo(urlStr: strVideoURl, strTopicID: "", strLectureID: "")
    }
    
    func vgPlayer(_ player: VGPlayer, stateDidChange state: VGPlayerState) {
        //print("stateDidChange ",state)
        
    }
    
    func vgPlayer(_ player: VGPlayer, bufferStateDidChange state: VGPlayerBufferstate) {
        //print("buffer State ", state)
        //self.player1.play()
        /*
        if player.bufferState == .readyToPlay {
            if player.state == .playing {
                self.player1.play()
            }else if player.bufferState == .bufferFinished {
                self.player1.play()
            }
        }*/
    }
}

extension CourseTemplateDetails: VGPlayerViewDelegate {
    
    func vgPlayerView(_ playerView: VGPlayerView, willFullscreen fullscreen: Bool) {
        
        if playerView.isFullScreen {
            //self.player?.pause()
            self.player1.gravityMode = .resizeAspect
        }else {
            self.player1.gravityMode = .resizeAspect
        }
        self.player1.displayView.reloadGravity()
        
        if self.flagFroAudiVideo == "2" {
            //self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            self.viewofAudio.isHidden = false
            self.heightOfVideoView.constant = 100
            self.viewOfVideoPlayer.addSubview(viewofAudio)
            self.viewOfVideoPlayer.bringSubview(toFront: viewofAudio)
            
            if playerView.isFullScreen {
                DispatchQueue.main.async() {
                    playerView.exitFullscreen()
                }
            }
        }
    }

    func vgPlayerView(didTappedClose playerView: VGPlayerView) {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.AVPlayerItemDidPlayToEndTime , object: player?.currentItem)
        player?.replaceCurrentItem(with: nil)
        
        getLastAudiVideoDuration()
        self.player?.pause()
        if playerView.isFullScreen {
            DispatchQueue.main.async() {
                playerView.exitFullscreen()
            }
        } else {
            self.player1.pause()
            //sewlf.flagFroAudiVideo = ""
            callWSOfDanyamicVideo(urlStr: "",strTopicID:"",strLectureID:"")
            self.player1.cleanPlayer()
            //self.player1.isDisplayControl = false
            UIApplication.shared.isStatusBarHidden = false
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func vgPlayerView(didTappedAudioVideoSwicthBtn playerView: VGPlayerView) {
        
        if playerView.isFullScreen {
            DispatchQueue.main.async() {
                playerView.exitFullscreen()
            }
        }
        
        if switchingFlag == "1"{ //audio
            switchingFlag = "0"
            if strAudioUrl != ""{
                self.player1.pause()
                self.flagFroAudiVideo = "2"
                self.playerFlag = 0
                var strngTime :Double = 1.0
                var strArry1 = [String]()
                strngTime = self.player1.currentDuration
                strViewedDuration = String(formatTimeFor(seconds: strngTime))
                
                strArry1 = strViewedDuration.components(separatedBy: ":")
                print("str count ",strArry1.count )
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
                print("self.strAudioTime",self.strAudioTime)
                playSoundWith(urlString: self.strAudioUrl, strDuration: self.strAudioTime)
            }else {
                self.view.makeToast((appDelegate.ArryLngResponSystm!["no_audio_available"] as? String)!)
                //"Audio not available"
            }
        }else { //video
            switchingFlag = "1"
            if strVideoURl != ""{
                self.viewofAudio.isHidden = true
                self.flagFroAudiVideo = "1"
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
                self.videoAudioPlayer(urlStr:strVideoURl, StrstartTime:self.strVideoTime)

            }else {
                self.view.makeToast((appDelegate.ArryLngResponSystm!["no_video_available"] as? String)!)
            }
        }
    }
    func vgPlayerView(didTappedonPreviousBtn playerView: VGPlayerView) {
         print("Previous taped")
    }
    
    func vgPlayerView(didTappedonNextBtn playerView: VGPlayerView) {
         print("Next taped")
    }
    
    func vgPlayerView(didDisplayControl playerView: VGPlayerView) {
        //UIApplication.shared.setStatusBarHidden(!playerView.isDisplayControl, with: .fade)
        if flagGoback == "1" {
            UIApplication.shared.isStatusBarHidden = false.self
        }else {
            //UIApplication.shared.isStatusBarHidden = !playerView.isDisplayControl
        }
        
    }
}

//MARK:- WebView Delegate
extension CourseTemplateDetails :WKUIDelegate, WKNavigationDelegate {
    
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
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if self.flagForWeb == "1"{
            self.webViewMore?.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
                if complete != nil {
                    self.webViewMore?.evaluateJavaScript("document.body.offsetHeight", completionHandler: { (height,
                        error) in
                        
                    })
                }
                print("webViewMore error :", error ?? "101")
            })
        }else {
            self.webViewResources?.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
                if complete != nil {
                    self.webViewResources?.evaluateJavaScript("document.body.offsetHeight", completionHandler: { (height,
                        error) in
                        
                    })
                }
                print("webViewResources error : ", error ?? "101")
            })
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
}

//MARK:- Custom Class
class Lessons {
    
    var topic_id:String = ""
    var lecture  : [Lectures]
    
    init(topic_id:String, lecture:[Lectures]){
        self.topic_id = topic_id
        self.lecture = lecture
    }
}

class Lectures {
    
    var lecture_id:String
    var video_completed:Bool
    var audio_completed:Bool
    var videoURL:String = ""
    var audioURL:String = ""
    init(lecture_id:String,video_completed:Bool,audio_completed:Bool,videoURL:String,audioURL:String){
        self.lecture_id = lecture_id
        self.video_completed = video_completed
        self.audio_completed = audio_completed
        self.videoURL = videoURL
        self.audioURL = audioURL
    }
}



