//
//  AnswerDetailsVC.swift
//  AppBuilder2
//
//  Created by Aditya on 12/03/18.
//  Copyright © 2018 VISHAL. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class AnswerDetailsVC: UIViewController,AVAudioRecorderDelegate,AVAudioPlayerDelegate,UITextViewDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var ViewBottomChat: CustomView!
    @IBOutlet weak var txtEnterMessage: UITextView!
    @IBOutlet weak var imgSend: UIImageView!
    @IBOutlet weak var tblOfAnswerDetail: UITableView!
    
    @IBOutlet weak var heightofBottomView: NSLayoutConstraint!
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
    
    var seconds = 0.0 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var recordingTimer = Timer()
    var isTimerRunning = false //This will be used to make su
    
    //recording
    var recordingSession : AVAudioSession!
    var audioRecorder    :AVAudioRecorder!
    var settings         = [String : Int]()
    
    var player = AVPlayer()
    var audioPlayer : AVAudioPlayer!
    var recordingFlag = 0
    var recordingURl : NSURL!
    
    var sennderTag = 0
    var playerFlag = 0
    var playerQustnFlag = IndexPath()
    var playerAnsFlag = IndexPath()
    
    var arrData = [QuestionAnswerData]()
    var selectedRow:Int?
    
    var getJsonData: [String:Any]?
    var btnMenu:UIButton!
    var btnBack:UIButton!
    var commonElement = [String:Any]()
    var courseElement = [String:Any]()
    var NavBgcolor = ""
    var txtNavcolorHex = ""
    var titleString = ""
    
    //api
    var appDelegate : AppDelegate!
    var chache:NSCache<AnyObject, AnyObject>!
    var flgActivity = true
    var timeOut: Timer!
    var apiSuccesFlag = ""
    var arryWSAnswerData = [[String:Any]]()
    var noDataView = UIView()
    var refreshControl: UIRefreshControl!
    
    var questionID:String = ""
    var answerType:String = ""
    
    var selectedIndexPath = IndexPath()
//    var defaultOptions = SwipeTableOptions()
//    var isSwipeRightEnabled = true
//    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    
    var answerID = ""
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if userInfo.adminUserflag == "0" {
            imgSend.image = UIImage(named: "send")
        }else {
            imgSend.image = UIImage(named: "mike")
        }
        
        tblOfAnswerDetail.allowsSelection = true
        tblOfAnswerDetail.allowsMultipleSelectionDuringEditing = true
        
        setBackBtn()
        setNavigationButton()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        getJsonData =  appDelegate.jsonData
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.chache = NSCache()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblOfAnswerDetail.addSubview(refreshControl)
        
         NotificationCenter.default.addObserver(self, selector: #selector(AnswerDetailsVC.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        //Permission Audio Video Player
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
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
        
        settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        tblOfAnswerDetail.tableFooterView = UIView()
        
        txtEnterMessage.text = (appDelegate.ArryLngResponeCustom!["enter_comment"] as? String)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let str = self.titleString
        if str.count > 28{
            let startIndex = str.index(str.startIndex, offsetBy: 28)
            self.title = String(str[..<startIndex] + "..")
        }else {
            self.title = self.titleString
        }
        
        self.navigationController?.navigationBar.isHidden = false
        getUIAnswerList()
        self.mianBgviewOfRecording.isHidden = true
        
        /*if DeviceType.IS_IPHONE_x {
            if (self.title?.count)! > 33 {
                self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(-10, for: .default)
            }else {
                self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(0, for: .default)
            }
        }else {
            self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(0, for: .default)
        }*/
        
        //WS CALL
        callWSOfGetAnswer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(0, for: .default)
    }
    
    @objc func refresh(_ sender:AnyObject){
        flgActivity = false
        self.timeOut = Timer.scheduledTimer(timeInterval: 25.0, target: self, selector: #selector(Login.cancelWeb), userInfo: nil, repeats: false)
        apiSuccesFlag = "1"
        callWSOfGetAnswer()
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
        }
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
        player.pause()
        self.navigationController?.popViewController(animated: true)
    }
    
    func setNavigationButton() {
        let origImage = UIImage(named: "side-menu");
        btnMenu = UIButton(frame: CGRect(x: 0, y:0, width:20,height: 20))
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        btnMenu.setImage(tintedImage, for: .normal)
        btnMenu.addTarget(self,action: #selector(menu), for: .touchUpInside)
        let widthConstraint = btnMenu.widthAnchor.constraint(equalToConstant: 20)
        let heightConstraint = btnMenu.heightAnchor.constraint(equalToConstant: 20)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        let backBarButtonitem = UIBarButtonItem(customView: btnMenu)
        let arrLeftBarButtonItems : Array = [backBarButtonitem]
        self.navigationItem.rightBarButtonItems = arrLeftBarButtonItems
        
        self.btnMenu.tintColor = UIColor().HexToColor(hexString: "#FFFFFF")
        
    }
    
    @objc func menu(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteMenus") as! FavouriteMenus
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    func getUIAnswerList() {
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
                    
                    self.NavBgcolor = bgcolor!
                    self.btnMenu.tintColor = UIColor().HexToColor(hexString: menu_icon_color!)
                    self.btnBack.tintColor = UIColor().HexToColor(hexString: menu_icon_color!)
                   
                    commonElement = common_element
                    tblOfAnswerDetail.backgroundColor = UIColor().HexToColor(hexString: bgScreenColor)
                    
                    if let dic = data["app_general_settings"] as? [String:Any] {
                        let ansFlag = (dic["allow_comments_to_question_answer"] as? String)!
                        if ansFlag == "0"{
                            self.ViewBottomChat.isHidden = true
                            self.heightofBottomView.constant = 0
                        }else {
                            self.ViewBottomChat.isHidden = false
                            self.heightofBottomView.constant = 45
                        }
                    }
                }
            }
        } else {
            stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    @IBAction func btnSendRecdngClick(_ sender: Any) {
        recordingTimer.invalidate()
        recordingFlag = 0
        self.finishRecording(success: true)
        
        self.txtEnterMessage.text! = ""
        userInfo.adminUserflag = "1"
       
        callWSAudio(QuestionID: questionID,strurl: recordingURl as URL)
        
        if !selectedIndexPath.isEmpty {
            self.tblOfAnswerDetail.scrollToRow(at: selectedIndexPath , at: .bottom, animated: true)
        }
       
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
    
    
    @objc func playQusetionAudio(_ sender : UIButton?){
        //USER PLAY AUDIO
        let section = (sender?.tag)! / 1000
        let row = (sender?.tag)! % 1000
        let indexPath = IndexPath(row: row, section: section)
        let cellObj = self.tblOfAnswerDetail.cellForRow(at:indexPath) as! AnswerDetailCell
        let data = arryWSAnswerData[indexPath.row]
        
        if !self.playerQustnFlag.isEmpty {
            if self.playerQustnFlag.row != indexPath.row {
                let cellLastSect = self.tblOfAnswerDetail.cellForRow(at:playerQustnFlag) as! AnswerDetailCell
                cellLastSect.imgPlayQuestion.image = UIImage(named: "play")
            }
        }
        
        /*if !self.playerAnsFlag.isEmpty {
            if self.playerAnsFlag.row != indexPath.row {
                let cellLastSect = self.tblOfAnswerDetail.cellForRow(at:playerAnsFlag) as! AnswerDetailCell
                cellLastSect.imgPlayAnswer.image = UIImage(named: "play")
            }
        }*/
        
        self.player.pause()
        if cellObj.imgPlayQuestion.image == UIImage(named:"play"){ //((player.rate != 0) && (player.error == nil))
            do {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
                
                //AVAudioSession(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
                //(currentDict["filePath"] as! URL != nil)
                if (data.keys.contains("answer")){
                    self.playerQustnFlag = indexPath
                    let auidoUrl = URL(string:(data["answer"] as? String)!)!
                    print("answer URl ",auidoUrl )
                    cellObj.imgPlayQuestion.image = UIImage(named: "stop")
                    player = AVPlayer(url: auidoUrl)
                    player.play()
                }
            } catch let error {
                print("error ",error.localizedDescription)
            }
        }else {
            //playerQustnFlag = 0
            self.player.pause()
            cellObj.imgPlayQuestion.image = UIImage(named: "play")
        }
    }
    
    @objc func playAnsAudio(_ sender : UIButton?){
        
        //USER PLAY AUDIO
        let section = (sender?.tag)! / 1000
        let row = (sender?.tag)! % 1000
        let indexPath = IndexPath(row: row, section: section)
        let cellObj = self.tblOfAnswerDetail.cellForRow(at:indexPath) as! AnswerDetailCell
        let data = arryWSAnswerData[indexPath.row]
        
        if !playerAnsFlag.isEmpty {
            if self.playerAnsFlag.row != indexPath.row {
                let cellLastSect = self.tblOfAnswerDetail.cellForRow(at:playerAnsFlag) as! AnswerDetailCell
                cellLastSect.imgPlayAnswer.image = UIImage(named: "play")
            }
        }
        /*if !playerQustnFlag.isEmpty {
            if self.playerQustnFlag.row != indexPath.row {
                let cellLastSect = self.tblOfAnswerDetail.cellForRow(at:playerQustnFlag) as! AnswerDetailCell
                cellLastSect.imgPlayQuestion.image = UIImage(named: "play")
            }
        }*/
        
        self.player.pause()
        if cellObj.imgPlayAnswer.image == UIImage(named:"play"){
            do {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
                //AVAudioSession(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
                //(currentDict["filePath"] as! URL != nil)
                if (data.keys.contains("answer")){
                    self.playerFlag = 2
                    self.playerAnsFlag = indexPath
                    let auidoUrl = URL(string:(data["answer"] as? String)!)!
                    print("answer URl ",auidoUrl )
                    cellObj.imgPlayAnswer.image = UIImage(named: "stop")
                    
                    player = AVPlayer(url: auidoUrl)
                    player.play()
                }
            } catch let error {
                print("error ",error.localizedDescription)
            }
        }else {
            //playerFlag = 0
            self.player.pause()
            cellObj.imgPlayAnswer.image = UIImage(named: "play")
        }
    }
    
    // MARK:- Button Send Click
    @IBAction func btnSendClk(_ sender: Any) {
        if imgSend.image == UIImage(named: "mike") {
            
            answerType = "1"
            //self.view.makeToast("Audio message cannot be sent..")
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
                self.btnStartRecording.setImage(UIImage(named:"pausrecording"), for: .normal)
                self.finishRecording(success: true)
            }
        }
        else if imgSend.image == UIImage(named: "send") {
            if txtEnterMessage.text! == "" || txtEnterMessage.text! == (appDelegate.ArryLngResponeCustom!["enter_comment"] as? String)! {
                self.view.makeToast((appDelegate.ArryLngResponSystm!["Please_ente_text"] as? String)!)
                //"Please enter some text..."
            } else {
                answerType = "0"
                callWSAddAnswer()
                if !selectedIndexPath.isEmpty {
                    self.tblOfAnswerDetail.scrollToRow(at: selectedIndexPath , at: .bottom, animated: true)
                }
                txtEnterMessage.text = ""
            }
        }
    }
    
    func runTimer() {
        recordingTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(AnswerDetailsVC.updateTimer)), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {
        seconds += 1     //This will decrement(count down)the seconds.
        lblOfAudioCount.text = "\(seconds)" //This will update the label.
        
        let hours = Int(seconds) / 3600
        let minutes = Int(seconds) / 60 % 60
        let seconds1 = Int(seconds) % 60
        
        lblOfAudioCount.text = String(format:"%02i:%02i", minutes, seconds1)
    }
    
    //MARK:- textView delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        imgSend.image = UIImage(named: "send")
        txtEnterMessage.text = ""
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtEnterMessage.text == "" {
            if userInfo.adminUserflag == "0" {
                imgSend.image = UIImage(named: "send")
            }else {
                imgSend.image = UIImage(named: "mike")
            }
            txtEnterMessage.text = (appDelegate.ArryLngResponeCustom!["enter_comment"] as? String)!//"Enter your comment here..."
        }else {
            if userInfo.adminUserflag == "0" {
                imgSend.image = UIImage(named: "send")
            }else {
                imgSend.image = UIImage(named: "mike")
            }
        }
    }
}
//MARK:- Table View Methods
extension AnswerDetailsVC : UITableViewDelegate, UITableViewDataSource,MGSwipeTableCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arryWSAnswerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let answerCell = AnswerDetailCell()
        
        let arrDataAtIndex = arryWSAnswerData[indexPath.row]

        let userType = arrDataAtIndex["user_id"] as! String
        let type = arrDataAtIndex["type"] as! String
      
        let deleteColor = UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0)
        let editColor = UIColor(red:0.78, green:0.78, blue:0.80, alpha:1.0)
      
        if userType == userInfo.userId {
            if type == "0" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Question") as! AnswerDetailCell
                cell.delegate = self
                let genarlSettings = commonElement["general_settings"] as! [String:Any]
                //cell.backgroundColor = UIColor().HexToColor(hexString: (genarlSettings["screen_bg_color"] as? String)!)
                
                //Title
                if let title = genarlSettings["title"] as? Dictionary<String,String> {
                    let size = title["size"]
                    let txtcolorHex = title["txtcolorHex"]
                    let fontstyle = title["fontstyle"]
                    let sizeInt:Int = Int(size!)!
                    
                    cell.lblUsernameQuestion.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    cell.lblUsernameQuestion.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                }
                
                //SubTitle
                if let dicSubTitle = genarlSettings["subtitle"] as? Dictionary<String,String> {
                    let size = dicSubTitle["size"]
                    let txtcolorHex = dicSubTitle["txtcolorHex"]
                    let fontstyle = dicSubTitle["fontstyle"]
                    let sizeInt:Int = Int(size!)!
                    
                    cell.lblQuestion.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    cell.lblQuestion.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                    cell.lblTimeQuestion.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    cell.lblTimeQuestion.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                }
                
                cell.lblUsernameQuestion.text = arrDataAtIndex["user_name"] as? String
                cell.lblQuestion.text = arrDataAtIndex["answer"] as? String
                cell.lblTimeQuestion.text = arrDataAtIndex["date"] as? String
                
                //image
                if arrDataAtIndex["user_profile"] as? String != nil{
                    let imgUrl = arrDataAtIndex["user_profile"] as? String
                    
                    let imageName = self.separateImageNameFromUrl(Url: imgUrl!)
                    //cell.imgUserQuestion.image = UIImage(named:"placeholder2")
                    cell.imgUserQuestion.backgroundColor = color.placeholdrImgColor
                    
                    if(self.chache.object(forKey: imageName as AnyObject) != nil){
                        cell.imgUserQuestion.image = self.chache.object(forKey: imageName as AnyObject) as? UIImage
                    }else{
                        if validation.checkNotNullParameter(checkStr: imgUrl!) == false {
                            Alamofire.request(imgUrl!).responseImage{ response in
                                if let image = response.result.value {
                                    cell.imgUserQuestion.image = image
                                    self.chache.setObject(image, forKey: imageName as AnyObject)
                                }
                                else {
                                    //cell.imgUserQuestion.image = UIImage(named:"placeholder2")
                                    cell.imgUserQuestion.backgroundColor = color.placeholdrImgColor
                                }
                            }
                        }else {
                            //cell.imgUserQuestion.image = UIImage(named:"placeholder2")
                            cell.imgUserQuestion.backgroundColor = color.placeholdrImgColor
                        }
                    }
                }
                
                let arrData = self.arryWSAnswerData[indexPath.row]
                self.answerID = arrData["id"] as! String
                
                if indexPath.row == (self.arryWSAnswerData.count - 1) {
                    let arrLastData = self.arryWSAnswerData.last
                    let user_id =  arrLastData!["user_id"] as! String
                    let type = arrLastData!["type"] as! String
                    
                    if type == "0" && userInfo.userId == user_id {
                        
                        let delete = MGSwipeButton(title: (appDelegate.ArryLngResponeCustom!["trash"] as? String)!, icon:#imageLiteral(resourceName: "delete"), backgroundColor: deleteColor, padding: 0, callback: { (cell) -> Bool in
                            self.callWSOfdeleteAnswer()
                            return true
                        })
                        delete.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
                        delete.centerIconOverText(withSpacing: 10.0)
                        delete.buttonWidth = 60.0
                        if indexPath.row != 0 {
                            cell.leftButtons = [delete]
                        }
                        
                        let edit = MGSwipeButton(title: (appDelegate.ArryLngResponeCustom!["edit"] as? String)!, icon:#imageLiteral(resourceName: "edit"), backgroundColor: editColor, padding: 0, callback: { (cell) -> Bool in
                            //"Edit"
                            let replyVC = self.storyboard?.instantiateViewController(withIdentifier: "ReplyViewController") as! ReplyViewController
                            
                            replyVC.callWS = "editAnswer"
                            replyVC.user_name = (arrLastData!["user_name"] as? String)!
                            replyVC.question = (arrLastData!["answer"] as? String)!
                            replyVC.question_id = (arrLastData!["id"] as? String)!
                            replyVC.strQuestion = (arrLastData!["answer"] as? String)!
                            
                            self.navigationController?.pushViewController(replyVC, animated: true)
                            return true
                        })
                        edit.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
                        edit.centerIconOverText(withSpacing: 10.0)
                        if indexPath.row != 0 {
                            cell.rightButtons = [edit]
                        }
                    }
                    else if userInfo.adminUserflag == "1" {
                        let delete = MGSwipeButton(title: (appDelegate.ArryLngResponeCustom!["trash"] as? String)!, icon:#imageLiteral(resourceName: "delete"), backgroundColor: deleteColor, padding: 0, callback: { (cell) -> Bool in
                            self.callWSOfdeleteAnswer()
                            return true
                        })
                        delete.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
                        delete.centerIconOverText(withSpacing: 10.0)
                        delete.buttonWidth = 60.0
                        if indexPath.row != 0 {
                            cell.leftButtons = [delete]
                        }
                    }
                    else {
                        
                    }
                }
                
                
                selectedIndexPath = indexPath
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionAudio") as! AnswerDetailCell
                cell.delegate = self
                let genarlSettings = commonElement["general_settings"] as! [String:Any]
                //cell.backgroundColor = UIColor().HexToColor(hexString: (genarlSettings["screen_bg_color"] as? String)!)
                
                //Title
                if let title = genarlSettings["title"] as? Dictionary<String,String> {
                    let size = title["size"]
                    let txtcolorHex = title["txtcolorHex"]
                    let fontstyle = title["fontstyle"]
                    let sizeInt:Int = Int(size!)!
                    
                    cell.lblUsernameQuestion.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    cell.lblUsernameQuestion.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                }
                
                //SubTitle
                if let dicSubTitle = genarlSettings["subtitle"] as? Dictionary<String,String> {
                    let size = dicSubTitle["size"]
                    let txtcolorHex = dicSubTitle["txtcolorHex"]
                    let fontstyle = dicSubTitle["fontstyle"]
                    let sizeInt:Int = Int(size!)!
                    
                    cell.lblTimeQuestion.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    cell.lblTimeQuestion.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                }
                
                cell.viewAudioQuestion.backgroundColor = UIColor().HexToColor(hexString: NavBgcolor)
                
                cell.btnAudioResponseQuestion.tag = indexPath.section*1000 + indexPath.row;
                cell.btnAudioResponseQuestion.addTarget(self, action: #selector(AnswerDetailsVC.playQusetionAudio(_:)), for: .touchUpInside)
                cell.imgPlayQuestion.image = UIImage(named: "play")
                
                cell.lblUsernameQuestion.text = arrDataAtIndex["user_name"] as? String
                cell.lblTimeQuestion.text = arrDataAtIndex["date"] as? String
                
                //image
                if arrDataAtIndex["user_profile"] as? String != nil{
                    let imgUrl = arrDataAtIndex["user_profile"] as? String
                    
                    let imageName = self.separateImageNameFromUrl(Url: imgUrl!)
                    //cell.imgUserQuestion.image = UIImage(named:"placeholder2")
                    cell.imgUserQuestion.backgroundColor = color.placeholdrImgColor
                    
                    if(self.chache.object(forKey: imageName as AnyObject) != nil){
                        cell.imgUserQuestion.image = self.chache.object(forKey: imageName as AnyObject) as? UIImage
                    }else{
                        if validation.checkNotNullParameter(checkStr: imgUrl!) == false {
                            Alamofire.request(imgUrl!).responseImage{ response in
                                if let image = response.result.value {
                                    cell.imgUserQuestion.image = image
                                    self.chache.setObject(image, forKey: imageName as AnyObject)
                                }
                                else {
                                  //  cell.imgUserQuestion.image = UIImage(named:"placeholder2")
                                    cell.imgUserQuestion.backgroundColor = color.placeholdrImgColor
                                }
                            }
                        }else {
                            //cell.imgUserQuestion.image = UIImage(named:"placeholder2")
                            cell.imgUserQuestion.backgroundColor = color.placeholdrImgColor
                        }
                    }
                }
                selectedIndexPath = indexPath
                return cell
            }
        }else {
            if type == "0" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Answer") as! AnswerDetailCell
                cell.delegate = self
                let genarlSettings = commonElement["general_settings"] as! [String:Any]
                //cell.backgroundColor = UIColor().HexToColor(hexString: (genarlSettings["screen_bg_color"] as? String)!)
                
                //Title
                if let title = genarlSettings["title"] as? Dictionary<String,String> {
                    let size = title["size"]
                    let txtcolorHex = title["txtcolorHex"]
                    let fontstyle = title["fontstyle"]
                    let sizeInt:Int = Int(size!)!
                    
                    cell.lblUsernameAnswer.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    cell.lblUsernameAnswer.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                }
                
                //SubTitle
                if let dicSubTitle = genarlSettings["subtitle"] as? Dictionary<String,String> {
                    let size = dicSubTitle["size"]
                    let txtcolorHex = dicSubTitle["txtcolorHex"]
                    let fontstyle = dicSubTitle["fontstyle"]
                    let sizeInt:Int = Int(size!)!
                    
                    cell.lblAnswer.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    cell.lblAnswer.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                    cell.lblTimeAnswer.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    cell.lblTimeAnswer.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                }
                
                cell.lblUsernameAnswer.text = arrDataAtIndex["user_name"] as? String
                cell.lblAnswer.text = arrDataAtIndex["answer"] as? String
                cell.lblTimeAnswer.text = arrDataAtIndex["date"] as? String
                
                //image
                if arrDataAtIndex["user_profile"] as? String != nil{
                    let imgUrl = arrDataAtIndex["user_profile"] as? String
                    
                    let imageName = self.separateImageNameFromUrl(Url: imgUrl!)
                   // cell.imgUserAnswer.image = UIImage(named:"placeholder2")
                    cell.imgUserAnswer.backgroundColor = color.placeholdrImgColor
                    
                    if(self.chache.object(forKey: imageName as AnyObject) != nil){
                        cell.imgUserAnswer.image = self.chache.object(forKey: imageName as AnyObject) as? UIImage
                    }else{
                        if validation.checkNotNullParameter(checkStr: imgUrl!) == false {
                            Alamofire.request(imgUrl!).responseImage{ response in
                                if let image = response.result.value {
                                    cell.imgUserAnswer.image = image
                                    self.chache.setObject(image, forKey: imageName as AnyObject)
                                }
                                else {
                                    //cell.imgUserAnswer.image = UIImage(named:"placeholder2")
                                    cell.imgUserAnswer.backgroundColor = color.placeholdrImgColor
                                }
                            }
                        }else {
                          //  cell.imgUserAnswer.image = UIImage(named:"placeholder2")
                            cell.imgUserAnswer.backgroundColor = color.placeholdrImgColor
                        }
                    }
                }
                
                
                let arrData = self.arryWSAnswerData[indexPath.row]
                self.answerID = arrData["id"] as! String
                
                if indexPath.row == (self.arryWSAnswerData.count - 1) {
                    let arrLastData = self.arryWSAnswerData.last
                    let user_id =  arrLastData!["user_id"] as! String
                    let type = arrLastData!["type"] as! String
                    
                    if type == "0" && userInfo.userId == user_id {
                        
                        let delete = MGSwipeButton(title: (appDelegate.ArryLngResponeCustom!["trash"] as? String)!, icon:#imageLiteral(resourceName: "delete"), backgroundColor: deleteColor, padding: 0, callback: { (cell) -> Bool in
                            self.callWSOfdeleteAnswer()
                            return true
                        })
                        delete.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
                        delete.centerIconOverText(withSpacing: 10.0)
                        delete.buttonWidth = 60.0
                        
                        if indexPath.row != 0 {
                            cell.leftButtons = [delete]
                        }
                        
                        let edit = MGSwipeButton(title: (appDelegate.ArryLngResponeCustom!["edit"] as? String)!, icon:#imageLiteral(resourceName: "edit"), backgroundColor: editColor, padding: 0, callback: { (cell) -> Bool in
                            //"Edit"
                            let replyVC = self.storyboard?.instantiateViewController(withIdentifier: "ReplyViewController") as! ReplyViewController
                            
                            replyVC.callWS = "editAnswer"
                            replyVC.user_name = (arrLastData!["user_name"] as? String)!
                            replyVC.question = (arrLastData!["answer"] as? String)!
                            replyVC.question_id = (arrLastData!["id"] as? String)!
                            replyVC.strQuestion = (arrLastData!["answer"] as? String)!
                            
                            self.navigationController?.pushViewController(replyVC, animated: true)
                            return true
                        })
                        edit.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
                        edit.centerIconOverText(withSpacing: 10.0)
                        if indexPath.row != 0 {
                            cell.rightButtons = [edit]
                        }
                    }
                    else if userInfo.adminUserflag == "1" {
                        let delete = MGSwipeButton(title: (appDelegate.ArryLngResponeCustom!["trash"] as? String)!, icon:#imageLiteral(resourceName: "delete"), backgroundColor: deleteColor, padding: 0, callback: { (cell) -> Bool in
                            self.callWSOfdeleteAnswer()
                            return true
                        })
                        delete.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
                        delete.centerIconOverText(withSpacing: 10.0)
                        delete.buttonWidth = 60.0
                        if indexPath.row != 0 {
                            cell.leftButtons = [delete]
                        }
                    }
                    else {
                        
                    }
                }
                
                selectedIndexPath = indexPath
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerAudio") as! AnswerDetailCell
                cell.delegate = self
                let genarlSettings = commonElement["general_settings"] as! [String:Any]
                //cell.backgroundColor = UIColor().HexToColor(hexString: (genarlSettings["screen_bg_color"] as? String)!)
                
                //Title
                if let title = genarlSettings["title"] as? Dictionary<String,String> {
                    let size = title["size"]
                    let txtcolorHex = title["txtcolorHex"]
                    let fontstyle = title["fontstyle"]
                    let sizeInt:Int = Int(size!)!
                    
                    cell.lblUsernameAnswer.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    cell.lblUsernameAnswer.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                }
                
                //SubTitle
                if let dicSubTitle = genarlSettings["subtitle"] as? Dictionary<String,String> {
                    let size = dicSubTitle["size"]
                    let txtcolorHex = dicSubTitle["txtcolorHex"]
                    let fontstyle = dicSubTitle["fontstyle"]
                    let sizeInt:Int = Int(size!)!
                    
                    cell.lblTimeAnswer.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    cell.lblTimeAnswer.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                }
                
                cell.viewAudioAnswer.backgroundColor = UIColor().HexToColor(hexString: NavBgcolor)
               
                cell.btnAudioAnswer.tag = indexPath.section*1000 + indexPath.row;
                cell.btnAudioAnswer.addTarget(self, action: #selector(AnswerDetailsVC.playAnsAudio(_:)), for: .touchUpInside)
                cell.imgPlayAnswer.image = UIImage(named: "play")
                
                cell.lblUsernameAnswer.text = arrDataAtIndex["user_name"] as? String
                cell.lblTimeAnswer.text = arrDataAtIndex["date"] as? String
                //image
                if arrDataAtIndex["user_profile"] as? String != nil{
                    let imgUrl = arrDataAtIndex["user_profile"] as? String
                    
                    let imageName = self.separateImageNameFromUrl(Url: imgUrl!)
                    //cell.imgUserAnswer.image = UIImage(named:"placeholder2")
                    cell.imgUserAnswer.backgroundColor = color.placeholdrImgColor
                    
                    if(self.chache.object(forKey: imageName as AnyObject) != nil){
                        cell.imgUserAnswer.image = self.chache.object(forKey: imageName as AnyObject) as? UIImage
                    }else{
                        if validation.checkNotNullParameter(checkStr: imgUrl!) == false {
                            Alamofire.request(imgUrl!).responseImage{ response in
                                if let image = response.result.value {
                                    cell.imgUserAnswer.image = image
                                    self.chache.setObject(image, forKey: imageName as AnyObject)
                                }
                                else {
                                   //cell.imgUserAnswer.image = UIImage(named:"placeholder2")
                                    cell.imgUserAnswer.backgroundColor = color.placeholdrImgColor
                                }
                            }
                        }else {
                          // cell.imgUserAnswer.image = UIImage(named:"placeholder2")
                            cell.imgUserAnswer.backgroundColor = color.placeholdrImgColor
                        }
                    }
                }
                selectedIndexPath = indexPath
                return cell
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, canSwipe direction: MGSwipeDirection, from point: CGPoint) -> Bool {
        _ = tblOfAnswerDetail.indexPathForRow(at: point)
        return true
    }
}

//MARK:- favMenuDelagte
extension AnswerDetailsVC : favMenuDelagte {
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

/*
extension AnswerDetailsVC : SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        
        if orientation == .left {
            guard isSwipeRightEnabled else { return nil }
            
            let arrData = self.arryWSAnswerData[indexPath.row]
            self.answerID = arrData["id"] as! String
            if userInfo.adminUserflag == "0" {
                if indexPath.row == (self.arryWSAnswerData.count - 1) {
                    let arrLastData = self.arryWSAnswerData.last
                    let user_id =  arrLastData!["user_id"] as! String
                    let type = arrLastData!["type"] as! String
                    
                    if type == "0" && userInfo.userId == user_id {
                        let delete = SwipeAction(style: .default, title: "Delete") { action, indexPath in
//                            self.tblOfAnswerDetail.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                            self.callWSOfdeleteAnswer()
                        }
                        delete.image = UIImage(named: "delete");
                        delete.backgroundColor = UIColor.red
                        delete.hidesWhenSelected = true
                        return [delete]
                    }
                }
                else {
                    return nil
                }
            }
            else {
                let delete = SwipeAction(style: .default, title: "Delete") { action, indexPath in
//                    self.tblOfAnswerDetail.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                    self.callWSOfdeleteAnswer()
                }
                delete.image = UIImage(named: "delete");
                delete.backgroundColor = UIColor.red
                delete.hidesWhenSelected = true
                return [delete]
            }
        } else {
            guard isSwipeRightEnabled else { return nil }
            
            if indexPath.row == (self.arryWSAnswerData.count - 1) {
                let arrLastData = self.arryWSAnswerData.last
                let user_id =  arrLastData!["user_id"] as! String
                let type = arrLastData!["type"] as! String
                
                if type == "0" && userInfo.userId == user_id {
                    let edit = SwipeAction(style: .default, title: "Edit") { action, indexPath in
                       
                        let replyVC = self.storyboard?.instantiateViewController(withIdentifier: "ReplyViewController") as! ReplyViewController
                       
                        replyVC.callWS = "editAnswer"
                        replyVC.user_name = (arrLastData!["user_name"] as? String)!
                        replyVC.question = (arrLastData!["answer"] as? String)!
                        replyVC.question_id = (arrLastData!["id"] as? String)!
                        replyVC.strQuestion = (arrLastData!["answer"] as? String)!
                        
                        self.navigationController?.pushViewController(replyVC, animated: true)
                        
                    }
                    edit.image = UIImage(named: "edit");
                    edit.backgroundColor = UIColor.lightGray
                    edit.hidesWhenSelected = true
                    return [edit]
                }
            }else {
                return nil
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
//        options.expansionStyle = orientation == .right ? .selection : .destructive
        options.transitionStyle = defaultOptions.transitionStyle
        
        return options
    }
   
}

enum ButtonDisplayMode {
    case titleAndImage, titleOnly, imageOnly
}

*/
 
//MARK:- WEB SERVICE
extension AnswerDetailsVC {
    //MARK: WS Get Answer List
    func callWSOfGetAnswer(){
        
        //URL : http://27.109.19.234/app_builder/index.php/api/getAnswer?appclientsId=1&userId=1&userPrivateKey=TvnZqa9f9iD0E86u&appId=1&questionId=1
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "questionId" : questionID]
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getAnswer?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            if flgActivity{
                self.startActivityIndicator()
            }
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSforGetAnswer(strURL: strURL, dictionary: dictionary )
        }else{
            stopActivityIndicator()
            self.refreshControl.endRefreshing()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSforGetAnswer(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.refreshControl.endRefreshing()
                    self.arryWSAnswerData.removeAll()
                    if let arrayData = JSONResponse["data"] as? [[String:Any]]{
                        self.arryWSAnswerData = arrayData
                        self.tblOfAnswerDetail.reloadData()
                    }
                    else{
                        self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.oppsMsg, lableNoInternate: string.noDataFoundMsg)
                        self.tblOfAnswerDetail.addSubview(self.noDataView)
                    }
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
                        
                        let alrtTitleStr = NSMutableAttributedString(string: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String))
                        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                        
                        let alrtMessage = NSMutableAttributedString(string: string.privateKeyMsg)
                        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                        
                        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                        alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                        alertController.setValue(alrtMessage, forKey: "attributedMessage")
                        
                        //let alertController = UIAlertController(title: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String), message: string.privateKeyMsg, preferredStyle: .alert)
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
                        alertController.addAction(btnOK)
                        self.present(alertController, animated: true, completion: nil)
                    }else {
                        //self.errorCodeAlert(title: (JSONResponse["title"] as? String)!, description: (JSONResponse["description"] as? String)!, errorCode: (JSONResponse["systemErrorCode"] as? String)!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)
                        
                        self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: (JSONResponse["title"] as? String)!, lableNoInternate: ((JSONResponse["description"] as? String)! + "\n\(string.errodeCodeString) = [\((JSONResponse["systemErrorCode"] as? String)!)]"))
                        self.tblOfAnswerDetail.addSubview(self.noDataView)
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
                self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: "", lableNoInternate: string.someThingWrongMsg)
                self.tblOfAnswerDetail.addSubview(self.noDataView)
            }
        })
    }
    
    //MARK:- WS for Add Answer
    func callWSAddAnswer(){
        //URL: http://27.109.19.234/app_builder/index.php/api/addAnswer?appclientsId=1&userId=1&userPrivateKey=Jg3K5zbmYa06QREp&appId=1&questionId=16&answerType=0&answer=same%20reply&flag=1
        
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "questionId" : questionID,
                          "answerType" : answerType, //0: audio and 1: text
                          "answer" : self.txtEnterMessage.text!,
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
            self.callWSOfAddAnswer(strURL: strURL, dictionary: dictionary as! Dictionary<String, String> )
        }else{
            stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOfAddAnswer(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            print("JSONResponse Add Answer", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    if userInfo.adminUserflag == "1"{
                        self.view.makeToast((JSONResponse["message"] as? String)!)
                        self.callWSOfGetAnswer()
                    }else {
                        self.txtEnterMessage.text = ""
                        let alrtTitleStr = NSMutableAttributedString(string: "Comment submitted")
                        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                        
                        let alrtMessage = NSMutableAttributedString(string: "Your comment is under moderation.\n Please wait till it gets approved")
                        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                        
                        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                        alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                        alertController.setValue(alrtMessage, forKey: "attributedMessage")
                        
                        //let alertController = UIAlertController(title: "Comment submitted", message: "Your comment is under moderation.\n Please wait till it gets approved", preferredStyle: .alert)
                        let btnOK = UIAlertAction(title: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!, style: .default, handler: { action in
                            DispatchQueue.main.async{
                                self.navigationController?.popViewController(animated: true)
                            }
                        })
                        alertController.addAction(btnOK)
                        self.present(alertController, animated: true, completion: nil)
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
                        let alrtTitleStr = NSMutableAttributedString(string: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String))
                        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                        
                        let alrtMessage = NSMutableAttributedString(string: string.privateKeyMsg)
                        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                        
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
            print("JSONResponse AddAudio", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                 DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    
                    self.mianBgviewOfRecording.isHidden = true
                    self.seconds = 0.0
                    
                    if userInfo.adminUserflag == "1"{
                        self.view.makeToast((JSONResponse["message"] as? String)!)
                        self.callWSOfGetAnswer()
                    }else {
                        self.txtEnterMessage.text = ""
                        let alrtTitleStr = NSMutableAttributedString(string: "Comment submitted")
                        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                        
                        let alrtMessage = NSMutableAttributedString(string: "Your comment is under moderation.\n Please wait till it gets approved")
                        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                        
                        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                        alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                        alertController.setValue(alrtMessage, forKey: "attributedMessage")
                        
                        //let alertController = UIAlertController(title: "Comment submitted", message: "Your comment is under moderation.\n Please wait till it gets approved", preferredStyle: .alert)
                        let btnOK = UIAlertAction(title: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!, style: .default, handler: { action in
                            DispatchQueue.main.async{
                                self.navigationController?.popViewController(animated: true)
                            }
                        })
                        alertController.addAction(btnOK)
                        self.present(alertController, animated: true, completion: nil)
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
                        
                        let alrtTitleStr = NSMutableAttributedString(string: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String))
                        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                        
                        let alrtMessage = NSMutableAttributedString(string: string.privateKeyMsg)
                        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                        
                        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                        alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                        alertController.setValue(alrtMessage, forKey: "attributedMessage")
                        
                        //let alertController = UIAlertController(title: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String), message: string.privateKeyMsg, preferredStyle: .alert)
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
    
    
    //MARK:- WS deleteAnswer
    func callWSOfdeleteAnswer(){
        
        //URL :  http://27.109.19.234/app_builder/index.php/api/deleteAnswer?appclientsId=1&userId=27&userPrivateKey=F1N57wC35ApibW11&appId=1&answerId=291
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "answerId" : answerID]
        
        print("I/P markRead:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "deleteAnswer?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            if flgActivity{
                self.startActivityIndicator()
            }
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.WSOfdeleteAnswer(strURL: strURL, dictionary: dictionary )
        }else{
            stopActivityIndicator()
            self.refreshControl.endRefreshing()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func WSOfdeleteAnswer(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.refreshControl.endRefreshing()
                    self.view.makeToast((JSONResponse["message"] as? String)!)
                    self.callWSOfGetAnswer()
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
                        let alrtTitleStr = NSMutableAttributedString(string: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String))
                        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                        
                        let alrtMessage = NSMutableAttributedString(string: string.privateKeyMsg)
                        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                        
                        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                        alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                        alertController.setValue(alrtMessage, forKey: "attributedMessage")
                        
                        //let alertController = UIAlertController(title: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String), message: string.privateKeyMsg, preferredStyle: .alert)
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
}
//MARK:- Recording Delegate
extension AnswerDetailsVC {
    
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
    
    //MARK:- Recording Delegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Flag",flag)
        recordingFlag = 0
        self.audioPlayer.stop()
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?){
        print("Error",error.debugDescription)
        recordingFlag = 0
        self.audioPlayer.stop()
        
    }
    internal func audioPlayerBeginInterruption(_ player: AVAudioPlayer){
        print("Player",player.debugDescription)
        recordingFlag = 0
        self.audioPlayer.stop()
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
    @objc func didfinishplaying(note : NSNotification){
        self.tblOfAnswerDetail.reloadData()
    }
}

// Swift 3:
extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

struct QuestionAnswerData {
    var userName:String!
    var textMessage:String!
    var timeOrDate:String!
    
    init(userName:String,textMessage:String,timeOrDate:String) {
        self.userName = userName
        self.textMessage = textMessage
        self.timeOrDate = timeOrDate
    }
}
extension AVPlayer {
    var isPlaying: Bool {
        if (self.rate != 0 && self.error == nil) {
            return true
        } else {
            return false
        }
    }
    
}
