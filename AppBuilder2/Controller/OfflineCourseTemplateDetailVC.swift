//
//  OfflineCourseTemplateDetailVC.swift
//  AppBuilder2
//
//  Created by PUNDSK003 on 09/05/18.
//  Copyright © 2018 VISHAL. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import VGPlayer
import SnapKit
import MediaPlayer

class OfflineCourseTemplateDetailVC: UIViewController,AVAudioRecorderDelegate,AVAudioPlayerDelegate {

    @IBOutlet weak var topOfTblView: NSLayoutConstraint!
    @IBOutlet weak var heightOfVideoView: NSLayoutConstraint!
    @IBOutlet weak var tblOfOfflineData: UITableView!
    
    var prevCurseID = ""
    var prevTopicID = ""
    var prevLecID = ""
    
    var offlienTimeData : NSMutableArray = [[:]]
    var str1stTime = "1"
    
    @IBOutlet weak var lblofNoData: UILabel!
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
    var finishFlag = "0"
    var firstTime = "0"
    
    //Define the Player Object
    var controller = AVPlayerViewController()
    //CustomAVPlayerViewController()
    var player = AVPlayer()
    var plyerLayer = AVPlayerLayer()
    
    let dropDown = DropDown()
    var flagFroAudiVideo = "1"
    var strValue = "1"
    
    var commonElement = [String:Any]()
    
    //Recording player
    var recordingSession : AVAudioSession!
    var audioRecorder    :AVAudioRecorder!
    var settings         = [String : Int]()
    
    //vishal
    var strCourseTopicsLecturesId = ""
    var strViewedDuration = ""
    var strNextCoursTopicLecturesId = ""
    var lastPlayedVideo = ""
    var playStatus = "1"
    var strMusiclayer = "1"
    var strVideoURl = ""
    var strThumbnailURl = ""
    var i:Float = 1
    var strAudioUrl = ""
    var strVideoTime = ""
    var strAudioTime = ""
    var strDutnTime = ""
    var strSec = "1"
    var strMint = "1"
    var strHr = "1"
    
    var playerFlag = 0
    var strSection = 0
    var timerTest : Timer?
    var navTxtColor = ""
    var cellBgColor = ""
    var rotatEnable = "0"
    var titleForAudioPlayer = ""
    var subTilteForAudioPlayer = ""
    var strngOnlyAudio = false
    var VolumClick = "1"
    var commomdCentre = MPRemoteCommandCenter.shared()
    
    //Audio Player UI
   // @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewofAudio: UIView!
    @IBOutlet weak var btnAudioBackword: UIButton!
    @IBOutlet weak var btnPlayRateAudio: UIButton!
    @IBOutlet weak var btnAudioPlay: UIButton!
    @IBOutlet weak var btnAudioForword: UIButton!
    @IBOutlet weak var btnAudioVolume: UIButton!
    @IBOutlet weak var progressViewAudio: UIProgressView!
    
    @IBOutlet weak var viewOfVideoPlayer: UIView!
    
    //View of Audio
    @IBOutlet weak var widthOfAudioViewSwitch: NSLayoutConstraint!
    
    var expandabaleSection : NSMutableSet = []
    var refreshControl: UIRefreshControl!
    var btnBack:UIButton!
    var appDelegate : AppDelegate!
    var chache:NSCache<AnyObject, AnyObject>!
    var getJsonData: [String:Any]?
    var lessonElement = [String:Any]()
    var lessnActvTxtColor = ""
    var lessnInActvTxtColor = ""
    var selectedRow:Int?
    var selectedSection:Int?
    var btnMenu:UIButton!
    
    var coursesOffline = [OfflineCourses]()
    var topicOffline = [OfflineTopics]()
    var localOfflineData = [[String:Any]]()
    let reachability = Reachability()!
    
    var nextAudioVideoOfflineArry = [[String:Any]]()
    var nextPlayLectID = ""
    var currentPlayLecID = ""
    
    // MARK: - viewDidLoad
     override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set("2", forKey: "VideoAudioRoateFlag")
        
        setStatusBarBackgroundColor(color: UIColor.black)
        self.lblofNoData.isHidden = true
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [.allowBluetooth])
            UIApplication.shared.beginReceivingRemoteControlEvents()
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        //Handling interruptions of Audio player
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption(notification:)), name: .AVAudioSessionInterruption, object: nil)
        
        getofflineTimeData()
        
        self.chache = NSCache()
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(OfflineCourseTemplateDetailVC.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        //for Oriantation
        NotificationCenter.default.addObserver(self, selector: #selector(OfflineCourseTemplateDetailVC.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        controller.view.removeFromSuperview()
        
        videoConfigrationUI()
        
        setBackBtn()

        appDelegate = UIApplication.shared.delegate as! AppDelegate
        getJsonData = appDelegate.jsonData
        tblOfOfflineData.tableFooterView = UIView()
        heightOfVideoView.constant = 0
        //self.topOfTblView.constant = 0
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        //tblOfOfflineData.addSubview(refreshControl)
        
        getUIForOfflineView()
        setNavigationBtn()
        
        configureUI()
    }
    
    func setNavigationBtn() {
        //let origImage = UIImage(named: "offlineImage");
        btnMenu = UIButton(frame: CGRect(x: 0, y:0, width:26,height: 26))
        //let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        if validation.isConnectedToNetwork()  {
            //btnMenu.setImage(#imageLiteral(resourceName: "onlineImage"), for: .normal)
            btnMenu.setImage(UIImage.gifImageWithName("onlineGif"), for: .normal)
        }else {
            btnMenu.setImage(#imageLiteral(resourceName: "offlineImage"), for: .normal)
        }
        btnMenu.addTarget(self,action: #selector(menu), for: .touchUpInside)
        let widthConstraint = btnMenu.widthAnchor.constraint(equalToConstant: 26)
        let heightConstraint = btnMenu.heightAnchor.constraint(equalToConstant: 26)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        let backBarButtonitem = UIBarButtonItem(customView: btnMenu)
        let arrLeftBarButtonItems : Array = [backBarButtonitem]
        self.navigationItem.rightBarButtonItems = arrLeftBarButtonItems
    }
    
    @objc func menu(){
        self.offlineAlert()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.appDelegate.ArryLngResponeCustom != nil{
            self.lblofNoData.text = (appDelegate.ArryLngResponSystm!["no_downloads_msg"] as? String)!
        }else {
            self.lblofNoData.text = "You have not downloaded any videos or audios yet."
        }
        
        if self.appDelegate.ArryLngResponeCustom != nil {
            let str = (appDelegate.ArryLngResponeCustom!["offline_mode"] as? String)!
            if str.count > 28{
                let startIndex = str.index(str.startIndex, offsetBy: 28)
                self.title = String(str[..<startIndex] + "..")
            }else {
                self.title = (appDelegate.ArryLngResponeCustom!["offline_mode"] as? String)!
            }
        }else {
            self.title = "Offline Mode"
        }
        
        self.heightOfVideoView.constant = 0
        self.viewofAudio.isHidden = true
        self.viewOfVideoPlayer.isHidden = true
        setStatusBarBackgroundColor(color: UIColor.black)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChange(notification:)), name: Notification.Name.reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        }catch {
            print("Error")
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
                    if(vc is OfflineCourseTemplateDetailVC){
                        if self.flagFroAudiVideo == "2"{
                            let playingRate = String(UserDefaults.standard.float(forKey: "PlayerRate")) + "x"
                            let strValueCurrent = playingRate.replacingOccurrences(of: ".0", with: "")
                            if strValueCurrent == self.btnPlayRateAudio.currentTitle! {
                                if (self.player.isPlaying) {
                                    self.player.rate = UserDefaults.standard.float(forKey: "PlayerRate")
                                    self.player.pause()
                                    self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                                }else {
                                    self.btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                                    self.player.rate = UserDefaults.standard.float(forKey: "PlayerRate")
                                }
                            }
                            else {
                                if (self.player.isPlaying) {
                                    self.player.pause()
                                    self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                                }else {
                                    self.btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                                    self.player.play()
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
            if self.switchingFlag == "2" || self.flagFroAudiVideo == "2"{
                self.player.play()
                self.player.rate = UserDefaults.standard.float(forKey: "PlayerRate")
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                self.updateAudioProgressView()
                //self.updateInfo()
            }
            return .success
        }
        
        commomdCentre.pauseCommand.addTarget { (pauseEvent) -> MPRemoteCommandHandlerStatus in
            if self.switchingFlag == "2" || self.flagFroAudiVideo == "2"{
                self.player.pause()
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                self.updateAudioProgressView()
                //self.updateInfo()
            }
            return .success
        }
        
        // backword/forward audio rate
        commomdCentre.skipBackwardCommand.addTarget { (backword) -> MPRemoteCommandHandlerStatus in
                if self.switchingFlag == "2" || self.flagFroAudiVideo == "2"{
                    let time = (self.player.currentTime()) - CMTimeMake(Int64(15), 1)
                    self.player.seek(to: time)
                    self.updateAudioProgressView()
                    self.updateInfo()
                }
            return .success
        }
        commomdCentre.skipForwardCommand.addTarget { (forword) -> MPRemoteCommandHandlerStatus in
                if self.switchingFlag == "2" || self.flagFroAudiVideo == "2"{
                    let time = (self.player.currentTime()) + CMTimeMake(Int64(15), 1)
                    self.player.seek(to: time)
                    self.updateAudioProgressView()
                    self.updateInfo()
                }
            return .success
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        self.flagFroAudiVideo = "1"
        super.viewWillDisappear(animated)
        self.flagFroAudiVideo = ""
        let playerView = VGPlayerView()
        if playerView.isDisplayControl == true {
            UIApplication.shared.isStatusBarHidden = false
        }else { 
            UIApplication.shared.isStatusBarHidden = false
        }
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
    }
    
    @objc func canRotate() -> Void {
        print("canRotate")
    }
    
    //MARK:- ChangeInNetwork Method
    @objc func reachabilityChange(notification: Notification) {
        
        let reachability = notification.object as! Reachability
        if reachability.connection != .none {
            print("Network is reachable")
            //btnMenu.setImage(#imageLiteral(resourceName: "onlineImage"), for: .normal)
            btnMenu.setImage(UIImage.gifImageWithName("onlineGif"), for: .normal)
            if let wd = UIApplication.shared.delegate?.window {
                var vc = wd!.rootViewController
                if(vc is UINavigationController){
                    vc = (vc as! UINavigationController).visibleViewController
                }
                if(vc is OfflineCourseTemplateDetailVC){
                    //offliencourse controller
                    setStatusBarBackgroundColor(color: UIColor.black)
                }
            }
        }
        else {
            btnMenu.setImage(#imageLiteral(resourceName: "offlineImage"), for: .normal)
            print("Network not reachable")
        }
    }
    
    func offlineAlert(){
        let alrtTitleStr = NSMutableAttributedString(string: (appDelegate.ArryLngResponSystm!["go_back_online"] as? String)!)
        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
        
        let alrtMessage = NSMutableAttributedString(string: (appDelegate.ArryLngResponSystm!["do_you_want_to_try_and_go_back_online_and_see_all_available_content"] as? String)!)
        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
        alertController.setValue(alrtMessage, forKey: "attributedMessage")
        
        //"Yes"
        let btnYes = UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["yes"] as? String)!, style: .default, handler: { action in
            if validation.isConnectedToNetwork()  {
                UserDefaults.standard.set("1", forKey: "offLineFlag")
                self.addDataInPlist(strPrevTopicID: self.prevTopicID, strPrevLectureID: self.prevLecID, strPrevCourseID: self.prevCurseID, strPrevUserID: userInfo.userId)
                self.player.pause()
                self.player1.cleanPlayer()
                
                if userInfo.userPrivateKey == "" || UserDefaults.standard.string(forKey: "private_key") == "" {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else{
                self.view.makeToast(string.noInternateMessage2)
            }
        })
        //"No"
        let btnNo = UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["no"] as? String)!, style: .default, handler: { action in
            
        })
        alertController.addAction(btnYes)
        alertController.addAction(btnNo)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }
    
    func videoConfigrationUI(){
        
        viewOfVideoPlayer.addSubview(self.player1.displayView)
        self.player.pause()
        self.player1.backgroundMode = .suspend
        self.player1.displayView.closeButton.isHidden = true
        self.player1.delegate = self
        self.player1.displayView.delegate = self
        self.player1.displayView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.top.equalTo(strongSelf.viewOfVideoPlayer.snp.top)
            make.left.equalTo(strongSelf.viewOfVideoPlayer.snp.left)
            make.right.equalTo(strongSelf.viewOfVideoPlayer.snp.right)
            make.height.equalTo(strongSelf.viewOfVideoPlayer.frame.height).multipliedBy(9.0/16.0) // you can 9.0/16.0
        }
    }
    
    func setBackBtn() {
        //setNaviBackButton()
        let origImage = UIImage(named: "back");
        btnBack = UIButton(frame: CGRect(x: 0, y:0, width:28,height: 34))
        //btnBack.translatesAutoresizingMaskIntoConstraints = false
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        btnBack.setImage(tintedImage, for: .normal)
        btnBack.tintColor = UIColor.white
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
        addDataInPlist(strPrevTopicID: prevTopicID, strPrevLectureID: prevLecID, strPrevCourseID: prevCurseID, strPrevUserID: userInfo.userId)
        self.player.pause()
        self.player1.cleanPlayer()
        self.navigationController?.popViewController(animated: true)
    }
    
    func getUIForOfflineView() {
        let status = getJsonData!["status"] as! String
        if status == "1" {
            if let data = getJsonData!["data"] as? [String:Any] {
                if let common_element = data["common_element"] as? [String:Any] {
                    let navigation_bar = common_element["navigation_bar"] as! Dictionary<String,String>
                    let size = navigation_bar["size"]
                    let menu_icon_color = navigation_bar["menu_icon_color"]
                    let sizeInt:Int = Int(size!)!
                    
                    let genarlSettings = common_element["general_settings"] as! [String:Any]
                    let general_font = genarlSettings["general_font"] as! [String:Any]
                    let fontstyle = general_font["fontstyle"] as! String
                    let bgScreenColor = genarlSettings["screen_bg_color"] as! String
                    
                    self.navTxtColor = navigation_bar["txtcolorHex"]!
                    
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor().HexToColor(hexString:self.navTxtColor),NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: CGFloat(sizeInt))]
                    self.navigationController?.navigationBar.barTintColor = UIColor.black
                    
                    commonElement = common_element
                    self.btnBack.tintColor = UIColor().HexToColor(hexString: menu_icon_color!)
                    self.lblofNoData.textColor = UIColor().HexToColor(hexString: navigation_bar["bgcolor"]!)
                    self.lblofNoData.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(sizeInt))
                    if let course_Element = data["course"] as? [String:Any]{
                        lessonElement = (course_Element["lesson"] as? [String:Any])!
                        if let activeDic = lessonElement["active_lesson"]  as? [String:String] {
                            lessnActvTxtColor = (activeDic["txtcolorHex"])!
                        }
                        if let other_lesson_txtcolorHex = lessonElement["other_lesson_txtcolorHex"] as? String{
                            lessnInActvTxtColor = other_lesson_txtcolorHex
                        }
                        if let lesson_bgcolor = lessonElement["lesson_bgcolor"] as? String {
                            cellBgColor = lesson_bgcolor
                            self.view.backgroundColor = UIColor().HexToColor(hexString: lesson_bgcolor)
                            self.tblOfOfflineData.backgroundColor = UIColor().HexToColor(hexString: lesson_bgcolor)
                        }
                    }
                    
                    tblOfOfflineData.backgroundColor = UIColor().HexToColor(hexString: bgScreenColor)
                }
            }
        }
    }
    
    @objc func sectionTaped(gestureRecognizer: UITapGestureRecognizer) {
        
        print("sectionTaped called")
        let cell = gestureRecognizer.view as! CourseHeaderTableViewCell
        let section = cell.tag
        let shouldExpand = !expandabaleSection.contains(section)
        
        if (shouldExpand) {
            //expandabaleSection.removeAllObjects()
            if (self.tblOfOfflineData != nil) {
                expandabaleSection.add(section)
            }
        } else {
            expandabaleSection.removeAllObjects()
        }
        tblOfOfflineData.reloadData()
    }
    
    @objc func rotated() {
        if self.rotatEnable == "1" {
            if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
                DispatchQueue.main.async() {
                    self.heightOfVideoView.constant = UIScreen.main.bounds.height
                }
            }
            
            if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
                UIApplication.shared.isStatusBarHidden = false
                if UserDefaults.standard.string(forKey: "VideoAudioRoateFlag") == "2" && self.flagFroAudiVideo == "2" {
                    self.viewofAudio.isHidden = false
                    self.player1.displayView.isHidden = true
                    self.heightOfVideoView.constant = 100
                }else {
                    self.player1.displayView.isHidden = false
                    self.viewofAudio.isHidden = true
                    self.heightOfVideoView.constant = 240
                }
            }
        }
    }
    
    @objc func refresh(_ sender:AnyObject){
        print("refrsh called")
        refreshControl.endRefreshing()
    }
    
    func configureUI() {
        //MARK: Read from Local
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("OfflineCourse.json")
        if FileManager.default.fileExists(atPath: documentsURL.relativePath) {
            let response = retrieveFromOfflineCourseJsonFile()["courseDetails"] as! [Any]
            //print(#function, " response from local for offline mode" ,response )
            self.lblofNoData.isHidden = true
            for singleCourse in response {
                let course = singleCourse as! [String:Any]
                let id = course["course_id"] as! String
                let name = course["name"] as! String
                let topics = course["topics"] as! [Any]
                self.topicOffline.removeAll()
                for singleTopic in topics {
                    let newTopic = singleTopic as! [String:Any]
                    let topic_id = newTopic["topic_id"] as! String
                    let topic_name = newTopic["name"] as! String
                    let lectures = newTopic["lectures"] as! [Any]
                    for (index,element) in lectures.enumerated() {
                        if index == 0 {
                            let newLecture = element as! [String:Any]
                            let lecture_id = newLecture["lecture_id"] as! String
                            let title = newLecture["title"] as! String
                            let videoExistFlag = newLecture["videoExistFlag"] as! String
                            let audioExistFlag = newLecture["audioExistFlag"] as! String
                            
                            if videoExistFlag == "1" && audioExistFlag == "1" {
                                let dictVideo = newLecture["videoData"] as? [Any]
                                let dicV = dictVideo![0] as? [String:Any]
                                let urlVideo = dicV!["url"] as! String
                                let videoID = dicV!["course_topics_lectures_media_id"] as! String
                                let thumbnail = dicV!["thumbnail"] as! String
                                let videoComeplete = dicV!["videoComeplete"] as! String
                                let remainVideo = dicV!["remain_duration"] as! String
                                let durationVideo = dicV!["duration"] as! String
                                
                                let dictAudio = newLecture["audioData"] as? [Any]
                                let dicA = dictAudio![0] as? [String:Any]
                                let urlAudio = dicA!["url"] as! String
                                let audioID = dicA!["course_topics_lectures_media_id"] as! String
                                
                                let t = OfflineTopics(showHeader: true, lessonNumber: "\(index)", lessonID: lecture_id, lessonTitle: title, videoExistFlag: videoExistFlag, audioExistFlag: audioExistFlag, videoID: videoID, VideoURL: urlVideo, videoThumbnail: thumbnail, audioID: audioID, audioURL: urlAudio, isLessonCompleted: videoComeplete, topicID: topic_id, topicName: topic_name, duration: durationVideo, remainDuration: remainVideo)
                                self.topicOffline.append(t)
                                
                                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                let currentVideoURL = documentsURL.appendingPathComponent("video\(id)_\(topic_id)_\(lecture_id)_\(videoID).mp4")
                                let filePathVideo = currentVideoURL.relativePath
                                let filePathVideoUrl = currentVideoURL.relativeString
                                let fileManager = FileManager.default
                                if fileManager.fileExists(atPath: filePathVideo) {
                                    nextAudioVideoOfflineArry.append(["course_id":id,"topic_id":topic_id,"lecture_id":lecture_id,"titleForAudioPlayer":topic_name,"subTilteForAudioPlayer":title,"urlVideo":filePathVideoUrl,"urlAudio":filePathVideoUrl])
                                }
                                
                            }
                            else if videoExistFlag == "1"  {
                                let dictVideo = newLecture["videoData"] as? [Any]
                                let dicV = dictVideo![0] as? [String:Any]
                                let urlVideo = dicV!["url"] as! String
                                let videoID = dicV!["course_topics_lectures_media_id"] as! String
                                let thumbnail = dicV!["thumbnail"] as! String
                                let videoComeplete = dicV!["videoComeplete"] as! String
                                let remainVideo = dicV!["remain_duration"] as! String
                                let durationVideo = dicV!["duration"] as! String
                                
                                let t = OfflineTopics(showHeader: true, lessonNumber: "\(index)", lessonID: lecture_id, lessonTitle: title, videoExistFlag: videoExistFlag, audioExistFlag: "0", videoID: videoID, VideoURL: urlVideo, videoThumbnail: thumbnail, audioID: "", audioURL: "", isLessonCompleted: videoComeplete, topicID: topic_id, topicName: topic_name, duration: durationVideo, remainDuration: remainVideo)
                                self.topicOffline.append(t)
                                
                                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                let currentVideoURL = documentsURL.appendingPathComponent("video\(id)_\(topic_id)_\(lecture_id)_\(videoID).mp4")
                                let filePathVideo = currentVideoURL.relativePath
                                let filePathVideoUrl = currentVideoURL.relativeString
                                let fileManager = FileManager.default
                                if fileManager.fileExists(atPath: filePathVideo) {
                                    nextAudioVideoOfflineArry.append(["course_id":id,"topic_id":topic_id,"lecture_id":lecture_id,"titleForAudioPlayer":topic_name,"subTilteForAudioPlayer":title,"urlVideo":filePathVideoUrl,"urlAudio":filePathVideoUrl])
                                }
                            }
                            else if audioExistFlag == "1" {
                                let dictAudio = newLecture["audioData"] as? [Any]
                                let dicA = dictAudio![0] as? [String:Any]
                                let urlAudio = dicA!["url"] as! String
                                let audioID = dicA!["course_topics_lectures_media_id"] as! String
                                let audioComeplete = dicA!["audioComeplete"] as! String
                                let remainAudio = dicA!["remain_duration"] as! String
                                let durationAudio = dicA!["duration"] as! String
                                
                                let t = OfflineTopics(showHeader: true, lessonNumber: "\(index)", lessonID: lecture_id, lessonTitle: title, videoExistFlag: "0", audioExistFlag: audioExistFlag, videoID: "", VideoURL: "", videoThumbnail: "", audioID: audioID, audioURL: urlAudio, isLessonCompleted: audioComeplete, topicID: topic_id, topicName: topic_name, duration: durationAudio, remainDuration: remainAudio)
                                self.topicOffline.append(t)
                                
                                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                let currentVideoURL = documentsURL.appendingPathComponent("audio\(id)_\(topic_id)_\(lecture_id)_\(audioID).mp3")
                                let filePathAudio = currentVideoURL.relativePath
                                let filePathAudioUrl = currentVideoURL.relativeString
                                let fileManager = FileManager.default
                                if fileManager.fileExists(atPath: filePathAudio) {
                                    nextAudioVideoOfflineArry.append(["course_id":id,"topic_id":topic_id,"lecture_id":lecture_id,"titleForAudioPlayer":topic_name,"subTilteForAudioPlayer":title,"urlVideo":"","urlAudio":filePathAudioUrl])
                                }
                            }
                        }else {
                            let newLecture = element as! [String:Any]
                            let lecture_id = newLecture["lecture_id"] as! String
                            let title = newLecture["title"] as! String
                            let videoExistFlag = newLecture["videoExistFlag"] as! String
                            let audioExistFlag = newLecture["audioExistFlag"] as! String
                            
                            if videoExistFlag == "1" && audioExistFlag == "1" {
                                let dictVideo = newLecture["videoData"] as? [Any]
                                let dicV = dictVideo![0] as? [String:Any]
                                let urlVideo = dicV!["url"] as! String
                                let videoID = dicV!["course_topics_lectures_media_id"] as! String
                                let thumbnail = dicV!["thumbnail"] as! String
                                let videoComeplete = dicV!["videoComeplete"] as! String
                                let remainVideo = dicV!["remain_duration"] as! String
                                let durationVideo = dicV!["duration"] as! String
                                
                                let dictAudio = newLecture["audioData"] as? [Any]
                                let dicA = dictAudio![0] as? [String:Any]
                                let urlAudio = dicA!["url"] as! String
                                let audioID = dicV!["course_topics_lectures_media_id"] as! String
                                //preference always given to video
                                //let remainAudio = dicA!["remain_duration"] as! String
                                //let durationAudio = dicA!["duration"] as! String
                                
                                let t = OfflineTopics(showHeader: false, lessonNumber: "\(index)", lessonID: lecture_id, lessonTitle: title, videoExistFlag: videoExistFlag, audioExistFlag: audioExistFlag, videoID: videoID, VideoURL: urlVideo, videoThumbnail: thumbnail, audioID: audioID, audioURL: urlAudio, isLessonCompleted: videoComeplete, topicID: topic_id, topicName: topic_name, duration: durationVideo, remainDuration: remainVideo)
                                self.topicOffline.append(t)
                                
                                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                let currentVideoURL = documentsURL.appendingPathComponent("video\(id)_\(topic_id)_\(lecture_id)_\(videoID).mp4")
                                let filePathVideo = currentVideoURL.relativePath
                                let filePathVideoUrl = currentVideoURL.relativeString
                                let fileManager = FileManager.default
                                if fileManager.fileExists(atPath: filePathVideo) {
                                    nextAudioVideoOfflineArry.append(["course_id":id,"topic_id":topic_id,"lecture_id":lecture_id,"titleForAudioPlayer":topic_name,"subTilteForAudioPlayer":title,"urlVideo":filePathVideoUrl,"urlAudio":filePathVideoUrl])
                                }
                                
                                
                            }
                            else if videoExistFlag == "1"  {
                                let dictVideo = newLecture["videoData"] as? [Any]
                                let dicV = dictVideo![0] as? [String:Any]
                                let urlVideo = dicV!["url"] as! String
                                let videoID = dicV!["course_topics_lectures_media_id"] as! String
                                let thumbnail = dicV!["thumbnail"] as! String
                                let videoComeplete = dicV!["videoComeplete"] as! String
                                let remainVideo = dicV!["remain_duration"] as! String
                                let durationVideo = dicV!["duration"] as! String
                                
                                let t = OfflineTopics(showHeader: false, lessonNumber: "\(index)", lessonID: lecture_id, lessonTitle: title, videoExistFlag: videoExistFlag, audioExistFlag: "0", videoID: videoID, VideoURL: urlVideo, videoThumbnail: thumbnail, audioID: "", audioURL: "", isLessonCompleted: videoComeplete, topicID: topic_id, topicName: topic_name, duration: durationVideo, remainDuration: remainVideo)
                                self.topicOffline.append(t)
                               
                                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                let currentVideoURL = documentsURL.appendingPathComponent("video\(id)_\(topic_id)_\(lecture_id)_\(videoID).mp4")
                                let filePathVideo = currentVideoURL.relativePath
                                let filePathVideoUrl = currentVideoURL.relativeString
                                let fileManager = FileManager.default
                                if fileManager.fileExists(atPath: filePathVideo) {
                                    nextAudioVideoOfflineArry.append(["course_id":id,"topic_id":topic_id,"lecture_id":lecture_id,"titleForAudioPlayer":topic_name,"subTilteForAudioPlayer":title,"urlVideo":filePathVideoUrl,"urlAudio":filePathVideoUrl])
                                }
                                
                                
                            }
                            else if audioExistFlag == "1" {
                                let dictAudio = newLecture["audioData"] as? [Any]
                                let dicA = dictAudio![0] as? [String:Any]
                                let urlAudio = dicA!["url"] as! String
                                let audioID = dicA!["course_topics_lectures_media_id"] as! String
                                let audioComeplete = dicA!["audioComeplete"] as! String
                                let remainAudio = dicA!["remain_duration"] as! String
                                let durationAudio = dicA!["duration"] as! String
                                
                                let t = OfflineTopics(showHeader: false, lessonNumber: "\(index)", lessonID: lecture_id, lessonTitle: title, videoExistFlag: "0", audioExistFlag: audioExistFlag, videoID: "", VideoURL: "", videoThumbnail: "", audioID: audioID, audioURL: urlAudio, isLessonCompleted: audioComeplete, topicID: topic_id, topicName: topic_name, duration: durationAudio, remainDuration: remainAudio)
                                self.topicOffline.append(t)
                                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                let currentVideoURL = documentsURL.appendingPathComponent("audio\(id)_\(topic_id)_\(lecture_id)_\(audioID).mp3")
                                let filePathAudio = currentVideoURL.relativePath
                                let filePathAudioUrl = currentVideoURL.relativeString
                                let fileManager = FileManager.default
                                if fileManager.fileExists(atPath: filePathAudio) {
                                    nextAudioVideoOfflineArry.append(["course_id":id,"topic_id":topic_id,"lecture_id":lecture_id,"titleForAudioPlayer":topic_name,"subTilteForAudioPlayer":title,"urlVideo":"","urlAudio":filePathAudioUrl])
                                }
                            }
                        }
                    }
                }
                let newCourse = OfflineCourses(course_id: id, course_name: name, topics: self.topicOffline)
                self.coursesOffline.append(newCourse)
                
            }
            
            //print("Data in nextAudioVideoOfflineArry: ",nextAudioVideoOfflineArry)
            self.tblOfOfflineData.reloadData()
        }else {
            //no data
            self.lblofNoData.isHidden = false
        }
    }
    
    //MARK:- Audio Player
    @IBAction func btnBackClick(_ sender: Any) {
        
        self.flagFroAudiVideo = ""
        self.player.pause()
        self.player1.cleanPlayer()
        UIApplication.shared.isStatusBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAudioPlayClick(_ sender: Any) {
        
        /*let playingRate = "1.0"//self.strValue
        let strValueCurrent = playingRate.replacingOccurrences(of: "x", with: "")
        if playingRate == self.btnPlayRateAudio.currentTitle! {
            if player.isPlaying {
                self.player.rate = Float(strValueCurrent)!
                player.pause()
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            }else {
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                self.player.rate = Float(strValueCurrent)!
            }
        }
        else {
            if player.isPlaying {
                player.pause()
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            }else {
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                player.play()
            }
        }*/
        
        let playingRate = String(UserDefaults.standard.float(forKey: "PlayerRate")) + "x"
        let strValueCurrent = playingRate.replacingOccurrences(of: ".0", with: "")
        if strValueCurrent == self.btnPlayRateAudio.currentTitle! {
            if (self.btnAudioPlay.currentImage?.isEqual(UIImage(named:"pause")))! {
                self.player.rate = UserDefaults.standard.float(forKey: "PlayerRate")
                self.player.pause()
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            }else {
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                self.player.rate = UserDefaults.standard.float(forKey: "PlayerRate")
            }
        }
        else {
            if (self.btnAudioPlay.currentImage?.isEqual(UIImage(named:"pause")))! {
                player.pause()
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            }else {
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                player.play()
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
            self.player.rate = Float(strValueCurrent)!
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
            self.heightOfVideoView.constant = 240
            self.viewofAudio.isHidden = true
            self.player1.displayView.isHidden = false
            player.pause()
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
            
            self.videoAudioPlayer(urlStr: self.strVideoURl, StrstartTime: self.strVideoTime)
        }else if self.strngOnlyAudio {
            if VolumClick == "1" {
                VolumClick = "0"
                self.btnAudioVolume.setImage(#imageLiteral(resourceName: "mute"), for: .normal)
                self.player.isMuted = true
            }else {
                VolumClick = "1"
                self.btnAudioVolume.setImage(#imageLiteral(resourceName: "Volume"), for: .normal)
                self.player.isMuted = false
            }
            
        }else {
            if self.appDelegate.ArryLngResponSystm != nil {
                self.view.makeToast((appDelegate.ArryLngResponSystm!["no_video_available"] as? String)!)
            }else {
                self.view.makeToast("Video not available")
            }
        }
    }
    
    @IBAction func btnForwordClk(_ sender: Any) {
        let time = player.currentTime() + CMTimeMake(Int64(15), 1)
        //print("FastForwrd time ",time)
        self.btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        let playingRate = self.strValue
        if playingRate != "" {
            let strValueCurrent = playingRate.replacingOccurrences(of: "x", with: "")
            self.player.rate = Float(strValueCurrent)!
        }else {
            self.player.play()
        }
        player.seek(to: time)
        
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
        let time = player.currentTime() - CMTimeMake(Int64(15), 1)
        //print("Backword time ",time)
        self.btnAudioPlay.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        let playingRate = self.strValue
        if playingRate != "" {
            let strValueCurrent = playingRate.replacingOccurrences(of: "x", with: "")
            self.player.rate = Float(strValueCurrent)!
        }else {
            self.player.play()
        }
        player.seek(to: time)
        
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
    
    //MARK: - AudioPlayer
    func playSoundWith(urlString:String, strDuration: String) -> Void{
        self.flagFroAudiVideo = "2"
        UserDefaults.standard.set("2", forKey: "VideoAudioRoateFlag")
        self.player1.pause()
        self.player1.cleanPlayer()
        switchingFlag = "0"
        self.viewOfVideoPlayer.isHidden = false
        self.heightOfVideoView.constant = 100
        self.viewOfVideoPlayer.addSubview(viewofAudio)
        self.viewOfVideoPlayer.bringSubview(toFront: viewofAudio)
        self.viewofAudio.isHidden = false
        
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
                    }else if description.portType == AVAudioSessionPortHDMI{
                        print("Route: AVAudioSessionPortHDMI ")
                    }else if description.portType == AVAudioSessionPortBluetoothLE{
                        print("Route: AVAudioSessionPortBluetoothLE ")
                    }else {
                        do {
                            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.allowBluetooth)
                            //Name Receiver Port type Receiver
                        }catch {
                            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
                        }
                    }
                }
                
                let auidoUrl : URL! = URL(string:urlString)
                self.playerFlag = 2
                print("Audio URl ",auidoUrl)
                player = AVPlayer(url: auidoUrl!)
                player.seek(to: startTime)
                Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
                player.play()
                if #available(iOS 10.0, *) {
                    player.automaticallyWaitsToMinimizeStalling = false
                } else {
                    // Fallback on earlier versions
                }
                player.rate = UserDefaults.standard.float(forKey: "PlayerRate")
                let playingRate = String(UserDefaults.standard.float(forKey: "PlayerRate")) + "x"
                let strValueCurrent = playingRate.replacingOccurrences(of: ".0", with: "")
                self.btnPlayRateAudio.setTitle(strValueCurrent, for: .normal)
                
            } catch let error {
                print("error ",error.localizedDescription)
            }
        }else {
            playerFlag = 0
            self.player.pause()
            btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            let currtnDuartion = CMTimeGetSeconds(player.currentTime())
            let totalDuration = CMTimeGetSeconds((player.currentItem?.asset.duration)!)
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
        if player.isPlaying{
            let currtnDuartion = CMTimeGetSeconds(player.currentTime())
            let totalDuration = CMTimeGetSeconds((player.currentItem?.asset.duration)!)
            if switchingFlag != "1" {
                progressViewAudio.setProgress(Float(currtnDuartion/totalDuration), animated: true)
                flagForProgress = "2"
                audioProgssValue = currtnDuartion/totalDuration
            }
        }
    }
    
    func updateInfo() {
        
        if switchingFlag == "1" || self.flagFroAudiVideo == "1"{
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
            return
        }
        
        guard player.currentItem != nil else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
            return
        }
        let image = UIApplication.shared.icon!
        let mediaArtwork = MPMediaItemArtwork(boundsSize: image.size) { (size: CGSize)-> UIImage in return image}
        
        //self.subTilteForAudioPlayer
        let nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyAlbumTitle: self.subTilteForAudioPlayer,
            MPMediaItemPropertyTitle: self.titleForAudioPlayer,
            MPMediaItemPropertyArtwork: mediaArtwork,
            MPMediaItemPropertyPlaybackDuration:  Float(CMTimeGetSeconds((player.currentItem?.asset.duration)!)) ,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: Float(CMTimeGetSeconds((player.currentTime()))),
            MPNowPlayingInfoPropertyPlaybackRate: UserDefaults.standard.float(forKey: "PlayerRate")
        ]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    //response to remote control events
    func remoteControlReceivedWithEvent(_ receivedEvent:UIEvent)  {
        if (receivedEvent.type == .remoteControl) {
            switch receivedEvent.subtype {
            case .remoteControlTogglePlayPause:
                
                if (player.rate) > 0.0 {
                    player.pause()
                } else {
                    player.play()
                }
            case .remoteControlPlay:
                player.play()
            case .remoteControlPause:
                player.pause()
            default:
                print("received sub type \(receivedEvent.subtype) Ignoring")
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
            self.player.pause()
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
    
    
    //MARK:- VideoPlayer
    func videoAudioPlayer(urlStr: String, StrstartTime: String){
        self.flagFroAudiVideo = "1"
        updateInfo()
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        
        self.viewOfVideoPlayer.isHidden = false
        self.player.pause()
        self.viewofAudio.isHidden = true
        UserDefaults.standard.set("1", forKey: "VideoAudioRoateFlag")
        
        self.heightOfVideoView.constant = 240
        
        self.player1.gravityMode = .resize
        self.player1.displayView.reloadGravity()
            
        self.player1.displayView.backgroundColor = UIColor.lightGray
        print("Video Url:",urlStr)
        let url = URL(string:urlStr)
        self.player1.replaceVideo(url!)
        player1.play()
        
        //vishal
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
    
    @objc func didfinishplaying(note : NSNotification){
        controller.dismiss(animated: true)
        self.finishFlag = "1"
        player.seek(to: kCMTimeZero)
        progressViewAudio.setProgress(Float(0.0), animated: true)
        self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        
        selectedSection = nil
        selectedRow = nil
        self.rotatEnable = "1"
        magicHappensHere()  //Logic for user default
    }
    
    func magicHappensHere() {
        mainloop: for course in coursesOffline {
            let topics = course.topics
            let course_id = course.course_id
            for lesson in topics {
                let l_id = lesson.lessonID
                let topic_id = lesson.topicID
                //Logic for view Data-------
                if l_id == self.strNextCoursTopicLecturesId {
                    if lesson.isLessonCompleted == "0" {
                        lesson.isLessonCompleted = "1"
                        if UserDefaults.standard.value(forKey: "ViewData") != nil {
                            prevCurseID = course_id
                            prevTopicID = topic_id
                            prevLecID = l_id
                            self.localOfflineData = UserDefaults.standard.value(forKey: "ViewData") as! [[String:Any]]
                            self.localOfflineData.append(["course_id":course_id,"topic_id":topic_id,"lecture_id":self.strNextCoursTopicLecturesId,"user_id":userInfo.userId])
                            UserDefaults.standard.set(self.localOfflineData, forKey: "ViewData")
                            break mainloop
                        }else {
                            prevCurseID = course_id
                            prevTopicID = topic_id
                            prevLecID = l_id
                            self.localOfflineData.append(["course_id":course_id,"topic_id":topic_id,"lecture_id":self.strNextCoursTopicLecturesId,"user_id":userInfo.userId])
                            UserDefaults.standard.set(self.localOfflineData, forKey: "ViewData")
                            break mainloop
                        }
                    }
                }else if self.strNextCoursTopicLecturesId == ""{
                    break mainloop
                }
            }
        }
        
        
        
        //Logic for next play-------
        for i in 0..<self.nextAudioVideoOfflineArry.count{
            let dic = self.nextAudioVideoOfflineArry[i] as! [String : String]
            
            //Logic for next play-------
            if dic["lecture_id"] == self.nextPlayLectID {
                print("Now this is Currenttly playing lec ID : ", dic["lecture_id"] ?? "0.0" ," = ",self.nextPlayLectID)
                
                if dic["urlVideo"]! != ""{
                    
                    self.strVideoTime = getTimeFromPlist(strPlyTopicID: dic["topic_id"]!, strPlyLectureID: dic["lecture_id"]!, strPlyCourseID: dic["course_id"]!, strPlyUserID: userInfo.userId)
                    print("Time strVideoTime :",self.strVideoTime)
                    self.strAudioUrl = (dic["urlAudio"])!
                    self.strVideoURl = (dic["urlVideo"])!
                    
                    self.subTilteForAudioPlayer = (dic["subTilteForAudioPlayer"])!
                    self.titleForAudioPlayer = (dic["titleForAudioPlayer"])!
                    self.currentPlayLecID = dic["lecture_id"]!
                    
                    if self.flagFroAudiVideo == "1"{
                        self.flagFroAudiVideo = "1"
                        self.videoAudioPlayer(urlStr:self.strVideoURl, StrstartTime: self.strVideoTime)
                        self.heightOfVideoView.constant = 240
                    }else {
                        self.flagFroAudiVideo = "2"
                        self.strAudioTime =  self.strVideoTime
                        self.subTilteForAudioPlayer = (dic["subTilteForAudioPlayer"])!
                        self.titleForAudioPlayer = (dic["titleForAudioPlayer"])!
                        self.currentPlayLecID = dic["lecture_id"]!
                        
                        let strArry1 = strAudioTime.components(separatedBy: ":")
                        var strTemp = ""
                        if strArry1.count == 2 {
                            strTemp = "00:" + (strAudioTime)
                        }else {
                            strTemp = strAudioTime
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
                        
                        self.playerFlag = 0
                        self.heightOfVideoView.constant = 100
                        self.playSoundWith(urlString: self.strAudioUrl ,strDuration:  self.strAudioTime)
                    }
                    
                    self.player1.displayView.audioVideoSwicthBtn.isHidden = false
                    self.widthOfAudioViewSwitch.constant = 62.5
                    self.btnAudioVolume.isHidden = false
                    self.btnAudioVolume.setImage(#imageLiteral(resourceName: "Video2"), for: .normal)
                    strngOnlyAudio = false
                    self.nextPlayLogic(courseID: dic["course_id"]!, topicID: dic["topic_id"]!, lectureID: dic["lecture_id"]!)
                    
                    self.tblOfOfflineData.reloadData()
                    
                    break
                    
                }else {
                    self.strAudioTime = getTimeFromPlist(strPlyTopicID: dic["topic_id"]!, strPlyLectureID: dic["lecture_id"]!, strPlyCourseID: dic["course_id"]!, strPlyUserID: userInfo.userId)
                    self.strAudioUrl = (dic["urlAudio"])!
                    self.strVideoURl = "" 
                    self.subTilteForAudioPlayer = (dic["subTilteForAudioPlayer"])!
                    self.titleForAudioPlayer = (dic["titleForAudioPlayer"])!
                    self.currentPlayLecID = dic["lecture_id"]!
                    
                    let strArry1 = strAudioTime.components(separatedBy: ":")
                    var strTemp = ""
                    if strArry1.count == 2 {
                        strTemp = "00:" + (strAudioTime)
                    }else {
                        strTemp = strAudioTime
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
                    
                    self.playerFlag = 0
                    self.heightOfVideoView.constant = 100
                    self.playSoundWith(urlString: self.strAudioUrl ,strDuration:  self.strAudioTime)
                    //play audio
                    self.player1.displayView.audioVideoSwicthBtn.isHidden = true
                    self.widthOfAudioViewSwitch.constant = 62.5
                    self.btnAudioVolume.isHidden = false
                    self.btnAudioVolume.setImage(#imageLiteral(resourceName: "Volume"), for: .normal)
                    self.player.isMuted = false
                    strngOnlyAudio = true
                    VolumClick = "1"
                    
                    self.nextPlayLogic(courseID: dic["course_id"]!, topicID: dic["topic_id"]!, lectureID: dic["lecture_id"]!)
                    
                    self.tblOfOfflineData.reloadData()
                    
                    break
                }
            }else {
                print("Not getting ")
            }
        }
        
    }
}

extension OfflineCourseTemplateDetailVC {
    
    func updateTime() {
        // Access current item
        if let currentItem = player.currentItem {
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
    
    //MARK:- Handl Audio O/P Changes
    @objc func handleRouteChanges(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
            let reason = AVAudioSessionRouteChangeReason(rawValue:reasonValue) else {
                return
        }
        if reason == .oldDeviceUnavailable {
            self.player1.pause()
            self.player.pause()
            DispatchQueue.main.async {
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            }
        }else if reason == .newDeviceAvailable {
            self.player.pause()
            self.player1.pause()
            DispatchQueue.main.async {
                self.btnAudioPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            }
            
        }
    }
}

// MARK: - Table View Method
extension OfflineCourseTemplateDetailVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return coursesOffline.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (expandabaleSection.contains(section - 1)){
            return coursesOffline[section].topics.count
        }
        else{
            return 0
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 2
//    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = UIView()
//        footerView.backgroundColor = UIColor.white
//        return footerView
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "insideCell") as! VideoDetailCell
        
        if coursesOffline[indexPath.section].topics[indexPath.row].showHeader {
            cell.heightOfHeader.constant = 25
            cell.lblHeader.isHidden = false
            cell.lblHeader.text = coursesOffline[indexPath.section].topics[indexPath.row].topicName
        }else {
            cell.heightOfHeader.constant = 0
            cell.lblHeader.isHidden = true
        }
        
        
        //Title
        let genarlSettings = commonElement["general_settings"] as! [String:Any]
        if let title = genarlSettings["general_fontsize"] as? Dictionary<String,String> {
            let size = title["medium"]
            let _:Int = Int(size!)!
            
            let size1 = title["small"]
            let sizeInt1:Int = Int(size1!)!
            
            let fontStylDic = genarlSettings["general_font"] as! [String:Any]
            let fontstyle = fontStylDic["fontstyle"] as? String
            //}
            
            //Title
            if let title = genarlSettings["title"] as? Dictionary<String,String> {
                let size = title["size"]
                let txtcolorHex = title["txtcolorHex"]
                let fontstyle = title["fontstyle"]
                let sizeInt:Int = Int(size!)!
                
                cell.lblNUmber.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                cell.lblHeader.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt-2))
                cell.lblHeader.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                cell.lblHeader.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeInt-2))
            }
            //Description
            if let dicSubTitle = genarlSettings["description"] as? Dictionary<String,String> {
                let txtcolorHex = dicSubTitle["txtcolorHex"]
                
                //vishal
                cell.lblRowTitle.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt1))
                //cell.lblNUmber.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                cell.lblRowSubtitle.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt1))
            }
        }
        
        //cell.backgroundColor = UIColor().HexToColor(hexString: self.cellBgColor)
        
        let course_id = coursesOffline[indexPath.section].course_id
        let topic_id = coursesOffline[indexPath.section].topics[indexPath.row].topicID
        let lecture_id = coursesOffline[indexPath.section].topics[indexPath.row].lessonID
        
        //logic for viewCompleted and remaining
        if coursesOffline[indexPath.section].topics[indexPath.row].videoExistFlag == "1" {
            
            let video_id = coursesOffline[indexPath.section].topics[indexPath.row].videoID
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let currentVideoURL = documentsURL.appendingPathComponent("video\(course_id)_\(topic_id)_\(lecture_id)_\(video_id).mp4")
            let filePathVideo = currentVideoURL.relativePath
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePathVideo) {
                cell.lblOfFileNotFound.isHidden = true
                cell.heightOfFileNotFound.constant = 0
                
                if selectedSection == indexPath.section && selectedRow == indexPath.row  {
                    cell.lblRowTitle.textColor = UIColor().HexToColor(hexString: lessnActvTxtColor)
                    cell.lblNUmber.textColor = UIColor().HexToColor(hexString: lessnActvTxtColor)
                    cell.lblRowSubtitle.textColor = UIColor().HexToColor(hexString: lessnActvTxtColor)
                }else if self.currentPlayLecID == lecture_id {
                    selectedRow = (indexPath.row)
                    selectedSection = (indexPath.section)
                    cell.lblRowTitle.textColor = UIColor().HexToColor(hexString: lessnActvTxtColor)
                    cell.lblNUmber.textColor = UIColor().HexToColor(hexString: lessnActvTxtColor)
                    cell.lblRowSubtitle.textColor = UIColor().HexToColor(hexString: lessnActvTxtColor)
                }else {
                    cell.lblRowTitle.textColor = UIColor().HexToColor(hexString: lessnInActvTxtColor)
                    cell.lblNUmber.textColor = UIColor().HexToColor(hexString: lessnInActvTxtColor)
                    cell.lblRowSubtitle.textColor = UIColor().HexToColor(hexString: lessnInActvTxtColor)
                }
                
            }else {
                print("Video file does not exists")
                cell.lblOfFileNotFound.isHidden = false
                cell.heightOfFileNotFound.constant = 15
                if self.appDelegate.ArryLngResponeCustom != nil{
                   cell.lblOfFileNotFound.text = (appDelegate.ArryLngResponSystm!["file_not_found_msg"] as? String)!
                }else {
                   cell.lblOfFileNotFound.text = "File not found, Please download this lesson again."
                }
                
                cell.lblOfFileNotFound.textColor = UIColor.red
                
                cell.lblRowTitle.textColor = UIColor().HexToColor(hexString: lessnInActvTxtColor)
                cell.lblNUmber.textColor = UIColor().HexToColor(hexString: lessnInActvTxtColor)
                cell.lblRowSubtitle.textColor = UIColor().HexToColor(hexString: lessnInActvTxtColor)
                
            }
            cell.lblRowTitle.text = coursesOffline[indexPath.section].topics[indexPath.row].lessonTitle
            cell.lblNUmber.text = "\(indexPath.row + 1)"
            
            if coursesOffline[indexPath.section].topics[indexPath.row].isLessonCompleted == "1"{
                cell.imgOfCmpletDownld.isHidden = false
                cell.xPstnOfrowTitle.constant = 36
            }else {
                cell.xPstnOfrowTitle.constant = 8
                cell.imgOfCmpletDownld.isHidden = true
            }
            
            if UserDefaults.standard.value(forKey: "ViewData") != nil{
                if let viewData = UserDefaults.standard.array(forKey: "ViewData") as? [[String: Any]] {
                    for id in viewData {
                        if coursesOffline[indexPath.section].topics[indexPath.row].lessonID == id["lecture_id"] as! String && id["user_id"] as! String == userInfo.userId {
                            cell.imgOfCmpletDownld.isHidden = false
                            cell.xPstnOfrowTitle.constant = 36
                        }
                    }
                }
            }
            
            if self.appDelegate.ArryLngResponeCustom != nil{
                cell.lblRowSubtitle.text = (appDelegate.ArryLngResponeCustom!["video"] as? String)! + " & " + (appDelegate.ArryLngResponeCustom!["audio"] as? String)! + " - " + coursesOffline[indexPath.section].topics[indexPath.row].duration
            }else {
                cell.lblRowSubtitle.text = "Video & Audio - " + coursesOffline[indexPath.section].topics[indexPath.row].duration
            }
            
            
        }else if coursesOffline[indexPath.section].topics[indexPath.row].audioExistFlag == "1"{
            
            let audio_id = coursesOffline[indexPath.section].topics[indexPath.row].audioID
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let currentVideoURL = documentsURL.appendingPathComponent("audio\(course_id)_\(topic_id)_\(lecture_id)_\(audio_id).mp3")
            let filePathVideo = currentVideoURL.relativePath
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePathVideo) {
                cell.lblOfFileNotFound.isHidden = true
                cell.heightOfFileNotFound.constant = 0
                
                if selectedSection == indexPath.section && selectedRow == indexPath.row  {
                    cell.lblRowTitle.textColor = UIColor().HexToColor(hexString: lessnActvTxtColor)
                    cell.lblNUmber.textColor = UIColor().HexToColor(hexString: lessnActvTxtColor)
                    cell.lblRowSubtitle.textColor = UIColor().HexToColor(hexString: lessnActvTxtColor)
                    
                }else if self.currentPlayLecID == lecture_id {
                    selectedRow = (indexPath.row)
                    selectedSection = (indexPath.section)
                    cell.lblRowTitle.textColor = UIColor().HexToColor(hexString: lessnActvTxtColor)
                    cell.lblNUmber.textColor = UIColor().HexToColor(hexString: lessnActvTxtColor)
                    cell.lblRowSubtitle.textColor = UIColor().HexToColor(hexString: lessnActvTxtColor)
                }else {
                    cell.lblRowTitle.textColor = UIColor().HexToColor(hexString: lessnInActvTxtColor)
                    cell.lblNUmber.textColor = UIColor().HexToColor(hexString: lessnInActvTxtColor)
                    cell.lblRowSubtitle.textColor = UIColor().HexToColor(hexString: lessnInActvTxtColor)
                }
                
            }else {
                print("Audio file does not exists")
                cell.lblOfFileNotFound.isHidden = false
                cell.heightOfFileNotFound.constant = 15
                if self.appDelegate.ArryLngResponeCustom != nil{
                    cell.lblOfFileNotFound.text = (appDelegate.ArryLngResponSystm!["file_not_found_msg"] as? String)!
                }else {
                    cell.lblOfFileNotFound.text = "File not found, Please download this lesson again."
                }
                cell.lblOfFileNotFound.textColor = UIColor.red
                
                cell.lblRowTitle.textColor = UIColor().HexToColor(hexString: lessnInActvTxtColor)
                cell.lblNUmber.textColor = UIColor().HexToColor(hexString: lessnInActvTxtColor)
                cell.lblRowSubtitle.textColor = UIColor().HexToColor(hexString: lessnInActvTxtColor)
            }
            cell.lblRowTitle.text = coursesOffline[indexPath.section].topics[indexPath.row].lessonTitle
            cell.lblNUmber.text = "\(indexPath.row + 1)"
            
            if coursesOffline[indexPath.section].topics[indexPath.row].isLessonCompleted == "1"{
                cell.imgOfCmpletDownld.isHidden = false
                cell.xPstnOfrowTitle.constant = 36
            }else {
                cell.xPstnOfrowTitle.constant = 8
                cell.imgOfCmpletDownld.isHidden = true
            }
            
            if UserDefaults.standard.value(forKey: "ViewData") != nil{
                if let viewData = UserDefaults.standard.array(forKey: "ViewData") as? [[String: Any]] {
                    for id in viewData {
                        if coursesOffline[indexPath.section].topics[indexPath.row].lessonID == id["lecture_id"] as! String && id["user_id"] as! String == userInfo.userId{
                            cell.imgOfCmpletDownld.isHidden = false
                            cell.xPstnOfrowTitle.constant = 36
                        }
                    }
                }
            }
            if self.appDelegate.ArryLngResponeCustom != nil{
                cell.lblRowSubtitle.text = (appDelegate.ArryLngResponeCustom!["audio"] as? String)! + " - " + coursesOffline[indexPath.section].topics[indexPath.row].duration
            }else {
                cell.lblRowSubtitle.text = "Audio - " + coursesOffline[indexPath.section].topics[indexPath.row].duration
            }
        }else {
            cell.lblOfFileNotFound.isHidden = false
            cell.heightOfFileNotFound.constant = 15
            if self.appDelegate.ArryLngResponeCustom != nil{
                cell.lblOfFileNotFound.text = (appDelegate.ArryLngResponSystm!["file_not_found_msg"] as? String)!
            }else {
                cell.lblOfFileNotFound.text = "File not found, Please download this lesson again."
            }
            cell.lblOfFileNotFound.textColor = UIColor.red
            
            cell.lblRowTitle.textColor = UIColor().HexToColor(hexString: lessnInActvTxtColor)
            cell.lblNUmber.textColor = UIColor().HexToColor(hexString: lessnInActvTxtColor)
            cell.lblRowSubtitle.textColor = UIColor().HexToColor(hexString: lessnInActvTxtColor)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseHeader") as! CourseHeaderTableViewCell
        cell.lblTitle.text = coursesOffline[section].course_name
        cell.lblNumber.text = "\(section + 1)"
        
        let genarlSettings = commonElement["general_settings"] as! [String:Any]
        let navigation_bar = commonElement["navigation_bar"] as! [String:Any]
        cell.backgroundColor = UIColor().HexToColor(hexString: navigation_bar["bgcolor"] as! String)
        
        //Title
        if let title = genarlSettings["title"] as? Dictionary<String,String> {
            let size = title["size"]
            let txtcolorHex = title["txtcolorHex"]
            let fontstyle = title["fontstyle"]
            let sizeInt:Int = Int(size!)!
            
            cell.lblTitle.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
            cell.lblTitle.textColor = UIColor().HexToColor(hexString:  self.navTxtColor)
            cell.lblTitle.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeInt))
        }
        
        if (expandabaleSection.contains(section - 1)){
            cell.imgDropdown?.image = UIImage(named:"merge")
            let tintedImage = cell.imgDropdown.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            cell.imgDropdown?.image = tintedImage
            cell.imgDropdown?.tintColor = UIColor.white
        }
        else{
            cell.imgDropdown?.image = UIImage(named:"drop-down")
            let tintedImage = cell.imgDropdown.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            cell.imgDropdown?.image = tintedImage
            cell.imgDropdown?.tintColor = UIColor.white
        }
        cell.tag = section - 1
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sectionTaped)))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedRow != indexPath.row {
            selectedRow = (indexPath.row)
            selectedSection = (indexPath.section)
            tblOfOfflineData.reloadData()
            updateTime()
            playAudioVideo(indexPath: indexPath)
        }else if selectedSection != indexPath.section {
            selectedRow = (indexPath.row)
            selectedSection = (indexPath.section)
            tblOfOfflineData.reloadData()
            updateTime()
            playAudioVideo(indexPath: indexPath)
        }
    }
    
    func playAudioVideo(indexPath:IndexPath) {
        let course_id = coursesOffline[indexPath.section].course_id
        let topic_id = coursesOffline[indexPath.section].topics[indexPath.row].topicID
        let lecture_id = coursesOffline[indexPath.section].topics[indexPath.row].lessonID
        self.subTilteForAudioPlayer = coursesOffline[indexPath.section].topics[indexPath.row].lessonTitle
        self.titleForAudioPlayer = coursesOffline[indexPath.section].course_name
        
        nextPlayLogic(courseID:course_id,topicID:topic_id,lectureID:lecture_id)
        
        if str1stTime == "1"{
            str1stTime = "2"
            prevCurseID = course_id
            prevTopicID = topic_id
            prevLecID = lecture_id
        }else {
            addDataInPlist(strPrevTopicID: prevTopicID, strPrevLectureID: prevLecID, strPrevCourseID: prevCurseID, strPrevUserID: userInfo.userId)
        }
        
        self.rotatEnable = "1"
        
        if coursesOffline[indexPath.section].topics[indexPath.row].videoExistFlag == "1" {
            
            let video_id = coursesOffline[indexPath.section].topics[indexPath.row].videoID
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let currentVideoURL = documentsURL.appendingPathComponent("video\(course_id)_\(topic_id)_\(lecture_id)_\(video_id).mp4")
            let filePathVideo = currentVideoURL.relativePath
            let filePathVideoUrl = currentVideoURL.relativeString
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePathVideo) {
                print("filePath :" ,filePathVideoUrl)
                self.strVideoTime = getTimeFromPlist(strPlyTopicID: topic_id, strPlyLectureID: lecture_id, strPlyCourseID: course_id, strPlyUserID: userInfo.userId)
                print("Time strVideoTime :",self.strVideoTime)
                self.strAudioUrl = filePathVideoUrl
                self.strVideoURl = filePathVideoUrl
                prevCurseID = course_id
                prevTopicID = topic_id
                prevLecID = lecture_id
                
                if self.flagFroAudiVideo == "1"{
                    self.flagFroAudiVideo = "1"
                    //play Video
                    self.videoAudioPlayer(urlStr:filePathVideoUrl, StrstartTime: self.strVideoTime)
                    self.heightOfVideoView.constant = 240
                    
                }else {
                    self.flagFroAudiVideo = "2"
                    //play Audio
                    self.strAudioTime = self.strVideoTime
                    let strArry1 = strAudioTime.components(separatedBy: ":")
                    var strTemp = ""
                    if strArry1.count == 2 {
                        strTemp = "00:" + (strAudioTime)
                    }else {
                        strTemp = strAudioTime
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
                    
                    self.playerFlag = 0
                    self.heightOfVideoView.constant = 100
                    prevCurseID = course_id
                    prevTopicID = topic_id
                    prevLecID = lecture_id
                    self.playSoundWith(urlString: filePathVideoUrl ,strDuration:  self.strAudioTime)
                    
                }
                self.player1.displayView.audioVideoSwicthBtn.isHidden = false
                self.widthOfAudioViewSwitch.constant = 62.5
                self.btnAudioVolume.setImage(#imageLiteral(resourceName: "Video2"), for: .normal)
                self.btnAudioVolume.isHidden = false
                strngOnlyAudio = false
            }else {
                //self.view.makeToast("File not found, Please download this lesson again.")
            }
        }else if coursesOffline[indexPath.section].topics[indexPath.row].audioExistFlag == "1"{
            
            let audio_id = coursesOffline[indexPath.section].topics[indexPath.row].audioID
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let currentAduioURL = documentsURL.appendingPathComponent("audio\(course_id)_\(topic_id)_\(lecture_id)_\(audio_id).mp3")
            let filePathAudio = currentAduioURL.relativePath
            let filePathAudioURl = currentAduioURL.relativeString
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePathAudio) {
                print("Audio File",filePathAudioURl)
                self.strAudioTime = getTimeFromPlist(strPlyTopicID: topic_id, strPlyLectureID: lecture_id, strPlyCourseID: course_id, strPlyUserID: userInfo.userId)
                self.strVideoURl = ""
                let strArry1 = strAudioTime.components(separatedBy: ":")
                var strTemp = ""
                if strArry1.count == 2 {
                    strTemp = "00:" + (strAudioTime)
                }else {
                    strTemp = strAudioTime
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
                
                self.playerFlag = 0
                self.heightOfVideoView.constant = 100
                prevCurseID = course_id
                prevTopicID = topic_id
                prevLecID = lecture_id
                self.playSoundWith(urlString: filePathAudioURl ,strDuration:  self.strAudioTime)
                //play audio
                self.player1.displayView.audioVideoSwicthBtn.isHidden = true
                self.widthOfAudioViewSwitch.constant = 62.5
                self.btnAudioVolume.isHidden = false
                self.player.isMuted = false
                self.btnAudioVolume.setImage(#imageLiteral(resourceName: "Volume"), for: .normal)
                strngOnlyAudio = true
                VolumClick = "1"
            }else {
                //self.view.makeToast("File not found, Please download this lesson again.")
            }
        }else {
            self.view.makeToast("No files available")
        }
    }
    
    
    func nextPlayLogic(courseID:String,topicID:String,lectureID:String){
        self.currentPlayLecID = lectureID
        
        for i in 0..<self.nextAudioVideoOfflineArry.count{
            let dic = self.nextAudioVideoOfflineArry[i] as! [String : String]
            if dic["lecture_id"] == lectureID {
                //print("Currenttly playing lec ID : ", dic["lecture_id"] ?? "0.0" ," = ",currentPlayLecID)
                
                if i == (self.nextAudioVideoOfflineArry.count - 1){
                    let dic = self.nextAudioVideoOfflineArry[0] as! [String : String]
                    self.nextPlayLectID = (dic["lecture_id"])!
                    //print("Next playing lec ID : ", dic["lecture_id"] ?? "0.0" ," = ",nextPlayLectID)
                }else {
                    let dic = self.nextAudioVideoOfflineArry[i+1] as! [String : String]
                    self.nextPlayLectID = (dic["lecture_id"])!
                    //print("Next playing lec ID : ", dic["lecture_id"] ?? "0.0" ," = ",nextPlayLectID)
                }
                break
            }else {
                print("Not getting ")
            }
        }
        
        if UserDefaults.standard.value(forKey: "ViewData") != nil {
            let viewData = UserDefaults.standard.value(forKey: "ViewData") as! [[String:Any]]
            for allKeys in viewData {
                if allKeys["lecture_id"] as! String == lectureID && allKeys["user_id"] as! String == userInfo.userId{
                    self.strNextCoursTopicLecturesId = ""
                    break
                }else {
                    self.strNextCoursTopicLecturesId = lectureID
                }
            }
        }else {
            self.strNextCoursTopicLecturesId = lectureID
        }
    }
    
    
    func addDataInPlist(strPrevTopicID:String,strPrevLectureID:String,strPrevCourseID:String,strPrevUserID:String){
        
        getofflineTimeData()
        
        var strArry = [String]()
        if self.flagFroAudiVideo == "1"{
            var strngTime :Double = 1.0
            strngTime = self.player1.currentDuration
            strViewedDuration = String(formatTimeFor(seconds: strngTime))
            strArry = strViewedDuration.components(separatedBy: ":")
        }else {
            updateTime()
            strArry = strViewedDuration.components(separatedBy: ":")
        }
        
        var strDuration = ""
        if strViewedDuration == "" {
            strDuration = "00:00:00"
        }else if strArry.count == 2 {
            strDuration = "00:" + (strViewedDuration)
        }else {
            strDuration = strViewedDuration
        }
        print("duartion ",strDuration)
       
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentDirectory = paths[0] as! String
        
        let path = documentDirectory.appending("/OfflineTimeData.plist")
        let fileManager = FileManager.default
        if(!fileManager.fileExists(atPath: path)){
            if let bundlePath = Bundle.main.path(forResource: "OfflineTimeData", ofType: "plist"){
                let result = NSMutableArray(contentsOfFile: bundlePath)!
                var strCheckFlag = "0"
                do{
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
                }catch{
                    print("copy failure.")
                }
                var myDic : NSMutableDictionary = [:]
                myDic  = [
                    "user_id":strPrevUserID,
                    "duration":strDuration,
                    "course_id":strPrevCourseID,
                    "topic_id":strPrevTopicID,
                    "lecture_id":strPrevLectureID
                ]
                
                for index in 0..<result.count {
                    let dic = result[index] as! [String:String]
                    if dic["user_id"] == strPrevUserID && dic["course_id"] == strPrevCourseID && dic["topic_id"] == strPrevTopicID && dic["lecture_id"] == strPrevLectureID  {
                        result.removeObject(at: index)
                        result.insert(myDic, at: index)
                        strCheckFlag = "1"
                        break
                    }
                }
                
                if strCheckFlag == "0"{
                    result.add(myDic)
                }
                result.write(toFile: path, atomically: false)
                
            }else{
                print("file OfflineTimeData not found.")
                
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
                let documentDirectory = paths.object(at: 0) as! String
                var strCheckFlag = "0"
                let path = documentDirectory.appending("/OfflineTimeData.plist")
                var myDic : NSMutableDictionary = [:]
                myDic  = [
                    "user_id":strPrevUserID,
                    "duration":strDuration,
                    "course_id":strPrevCourseID,
                    "topic_id":strPrevTopicID,
                    "lecture_id":strPrevLectureID
                ]
                
                for index in 0..<offlienTimeData.count {
                    let dic = offlienTimeData[index] as! [String:String]
                    if dic["user_id"] == strPrevUserID && dic["course_id"] == strPrevCourseID && dic["topic_id"] == strPrevTopicID && dic["lecture_id"] == strPrevLectureID  {
                        offlienTimeData.removeObject(at: index)
                        offlienTimeData.insert(myDic, at: index)
                        strCheckFlag = "1"
                        break
                    }
                }
                
                if strCheckFlag == "0"{
                    offlienTimeData.add(myDic)
                }
                offlienTimeData.write(toFile: path, atomically: false)
            }
        }else{
            //"file OfflineTimeData already exits at path.
            
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
            let documentDirectory = paths.object(at: 0) as! String
            var strCheckFlag = "0"
            let path = documentDirectory.appending("/OfflineTimeData.plist")
            var myDic : NSMutableDictionary = [:]
            myDic  = [
                "user_id":strPrevUserID,
                "duration":strDuration,
                "course_id":strPrevCourseID,
                "topic_id":strPrevTopicID,
                "lecture_id":strPrevLectureID
            ]
            
            for index in 0..<offlienTimeData.count {
                let dic = offlienTimeData[index] as! [String:String]
                if dic["user_id"] == strPrevUserID && dic["course_id"] == strPrevCourseID && dic["topic_id"] == strPrevTopicID && dic["lecture_id"] == strPrevLectureID  {
                    offlienTimeData.removeObject(at: index)
                    offlienTimeData.insert(myDic, at: index)
                    strCheckFlag = "1"
                    break
                }
            }
            
            if strCheckFlag == "0"{
                offlienTimeData.add(myDic)
            }
            offlienTimeData.write(toFile: path, atomically: false)
        }
    }
    
    func getTimeFromPlist(strPlyTopicID:String,strPlyLectureID:String,strPlyCourseID:String,strPlyUserID:String)-> String{
        getofflineTimeData()
        var stringDurtn = "00:00:00"
        for index in 0..<offlienTimeData.count {
            let dic = offlienTimeData[index] as! [String:String]
            if dic["user_id"] == strPlyUserID && dic["course_id"] == strPlyCourseID && dic["topic_id"] == strPlyTopicID && dic["lecture_id"] == strPlyLectureID  {
                stringDurtn = (dic["duration"])!
                print("Duration  ", stringDurtn)
                break
            }
        }
        return stringDurtn
    }
 
    func getofflineTimeData() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentDirectory = paths[0] as! String
        
        let path = documentDirectory.appending("/OfflineTimeData.plist")
        let fileManager = FileManager.default
        if(!fileManager.fileExists(atPath: path)){
            if let bundlePath = Bundle.main.path(forResource: "OfflineTimeData", ofType: "plist"){
                offlienTimeData = NSMutableArray(contentsOfFile: bundlePath)!
                //print("OfflineTimeData :" , offlienTimeData)
                do{
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
                }catch{
                    print("copy failure.")
                }
            }else{
                print("file Demo.plist not found.")
            }
        }else{
            print("file myData.plist already exits at path.")
            offlienTimeData = NSMutableArray(contentsOfFile: path)!
        }
        //print("load OfflineTimeData .plist count is -> ",offlienTimeData.count, "and Data : ",offlienTimeData)
    }
    
}

//MARK:- Video Player Delegate
extension OfflineCourseTemplateDetailVC: VGPlayerDelegate {
    func vgPlayer(_ player: VGPlayer, playerFailed error: VGPlayerError) {
        print("Error to play file ",error)
        
        if self.appDelegate.ArryLngResponeCustom != nil{
            self.view.makeToast((appDelegate.ArryLngResponSystm!["file_not_found_msg"] as? String)!)
        }else {
            self.view.makeToast("File not found, Please download this lesson again.")
        }
    }
    
    func vgPlayer(_ player: VGPlayer, stateDidChange state: VGPlayerState) {
        print("player State ",state)
    }
    
    func vgPlayer(_ player: VGPlayer, bufferStateDidChange state: VGPlayerBufferstate) {
        print("buffer State", state)
    }
}

extension OfflineCourseTemplateDetailVC: VGPlayerViewDelegate {
    
    func vgPlayerView(_ playerView: VGPlayerView, willFullscreen fullscreen: Bool) {
        //playerView.exitFullscreen()
        if playerView.isFullScreen {
            self.player1.gravityMode = .resizeAspect
        }else {
            self.player1.gravityMode = .resize
        }
        self.player1.displayView.reloadGravity()
        
        if UserDefaults.standard.string(forKey: "VideoAudioRoateFlag") == "2" && self.rotatEnable == "1"{
            playerView.exitFullscreen()
            self.heightOfVideoView.constant = 100
            self.viewofAudio.isHidden = false
        }
    }
    
    func vgPlayerView(didTappedClose playerView: VGPlayerView) {
        self.player.pause()
        if playerView.isFullScreen {
            playerView.exitFullscreen()
        } else {
            self.player1.pause()
            //callWSOfDanyamicVideo(urlStr: "")
            self.player1.cleanPlayer()
            //self.player1.isDisplayControl = false
            UIApplication.shared.isStatusBarHidden = false
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func vgPlayerView(didTappedAudioVideoSwicthBtn playerView: VGPlayerView) {
        
        /*if playerView.isFullScreen {
            playerView.exitFullscreen()
        }*/
        
        if switchingFlag == "1"{ //audio
            switchingFlag = "0"
            if strAudioUrl != ""{
                self.heightOfVideoView.constant = 100
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
                self.playSoundWith(urlString: self.strAudioUrl, strDuration: self.strAudioTime)
            }else {
                if self.appDelegate.ArryLngResponeCustom != nil {
                    self.view.makeToast((appDelegate.ArryLngResponeCustom!["no_audio_available"] as? String)!)
                }else {
                    self.view.makeToast("No Audio Available")
                }
            }
        }else { //video
            switchingFlag = "1"
            if strVideoURl != ""{
                self.widthOfAudioViewSwitch.constant = 62.5
                self.btnAudioVolume.isHidden = false
                
                self.heightOfVideoView.constant = 240
                self.viewofAudio.isHidden = true
                self.videoAudioPlayer(urlStr: self.strVideoURl, StrstartTime: self.strVideoTime)
                self.flagFroAudiVideo = "1"
            }else {
                
                if self.appDelegate.ArryLngResponeCustom != nil {
                    self.view.makeToast((appDelegate.ArryLngResponeCustom!["no_video_available"] as? String)!)
                }else {
                    self.view.makeToast("No video Available")
                }
            }
        }
    }
    
    func vgPlayerView(didVideoFinished playerView: VGPlayerView) {
        self.magicHappensHere()
    }
    
    func vgPlayerView(didTappedonPreviousBtn playerView: VGPlayerView) {
        print("Previous taped")
    }
    
    func vgPlayerView(didTappedonNextBtn playerView: VGPlayerView) {
        print("Next taped")
    }
    
    func vgPlayerView(didDisplayControl playerView: VGPlayerView) {
        //UIApplication.shared.setStatusBarHidden(!playerView.isDisplayControl, with: .fade)
       /* if flagGoback == "1" {
            UIApplication.shared.isStatusBarHidden = false.self
        }
        else {
            UIApplication.shared.isStatusBarHidden = !playerView.isDisplayControl
        }*/
        UIApplication.shared.isStatusBarHidden = false.self
    }
}

class OfflineCourses {
    var course_id:String = ""
    var course_name :String = ""
    var topics = [OfflineTopics]()
    init(course_id:String,course_name:String,topics : [OfflineTopics]) {
        self.course_id = course_id
        self.course_name = course_name
        self.topics = topics
    }
}

class OfflineTopics {
    var showHeader :Bool = false
    var lessonNumber:String = "";
    var lessonID: String = "";
    var lessonTitle:String = "";
    var topicID: String = "";
    var topicName:String = "";
    var videoExistFlag: String = "";
    var audioExistFlag: String = "";
    var videoID: String = "";
    var VideoURL: String = "";
    var videoThumbnail:String;
    var audioID: String;
    var audioURL:String ;
    var duration:String;
    var remainDuration:String;
//    var isLessonDownloaded:Bool;
//    var isVideoPlaying:Bool;
//    var isVideoDownloading:Bool;
    var isLessonCompleted:String;
    
    init(showHeader:Bool,
         lessonNumber:String,
         lessonID: String,
         lessonTitle:String,
         videoExistFlag: String,
         audioExistFlag: String,
         videoID: String,
         VideoURL: String,
         videoThumbnail:String,
         audioID: String,
         audioURL:String,
         //isLessonDownloaded:Bool,
         //isVideoPlaying:Bool,
         //isVideoDownloading:Bool,
        isLessonCompleted:String,
        topicID: String,
        topicName:String,
        duration:String,
        remainDuration:String) {
        
        self.lessonNumber = lessonNumber
        self.lessonID = lessonID
        self.showHeader = showHeader
        self.lessonTitle = lessonTitle
        self.videoExistFlag = videoExistFlag
        self.audioExistFlag = audioExistFlag
        self.videoID = videoID
        self.audioID = audioID
        self.VideoURL = VideoURL
        self.videoThumbnail = videoThumbnail
        self.audioURL = audioURL
        self.topicID = topicID
        self.topicName = topicName
        self.isLessonCompleted = isLessonCompleted
        self.duration = duration
        self.remainDuration = remainDuration
//        self.isLessonDownloaded = isLessonDownloaded
//        self.isVideoDownloading = isVideoDownloading
//        self.isVideoPlaying = isVideoPlaying
    }
}
