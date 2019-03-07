//
//  ReplyViewController.swift
//  AppBuilder2
//
//  Created by Aditya on 12/03/18.
//  Copyright © 2018 VISHAL. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController,NVActivityIndicatorViewable, UITextViewDelegate{

    @IBOutlet weak var topOfNavBar: NSLayoutConstraint!
    @IBOutlet weak var lblDescribedQuestion: UILabel!
    @IBOutlet weak var lblExpandConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var txtViewReply: UITextView!
    @IBOutlet weak var lblQuestionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblQuestionBottomConstraint: NSLayoutConstraint!
    @IBOutlet var lblQuestionToSendConstraint: NSLayoutConstraint!
    @IBOutlet var lblQuestionTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var lblQuestionTopConstraint: NSLayoutConstraint!
    @IBOutlet var llblQuestionLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var lblQuestionToCancelConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgArrowDown: UIImageView!
    @IBOutlet weak var lblToName: UILabel!
    @IBOutlet weak var lblTo: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    
    var appDelegate : AppDelegate!
    var chache:NSCache<AnyObject, AnyObject>!
    var flgActivity = true
    var timeOut: Timer!
    var apiSuccesFlag = ""
    var arryWSCoursData = Array<Any>()
    var noDataView = UIView()
    var strCourseId = ""
    var question_id:String = ""
    var type = ""
    var question = ""
    var user_name = ""
    var callWS = ""
    var strQuestion = ""
    
    
    var getJsonData: [String:Any]?
    var commonElement = [String:Any]()
    var NavBgcolor = ""
    var txtNavcolorHex = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        getJsonData =  appDelegate.jsonData
        
        if strQuestion != ""{
            self.lblQuestion.text = "RE: \(strQuestion)"
            self.txtViewReply.text = "RE: \(question)"
        }else {
            self.lblQuestion.text = "RE: \(question)"
            self.txtViewReply.text = (appDelegate.ArryLngResponeCustom!["type_here"] as? String)!
        }
       
        self.lblToName.text = user_name
        lblQuestion.numberOfLines = 1
      
        lblQuestion.textAlignment = NSTextAlignment.center
        lblQuestion.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        lblQuestion.textColor = UIColor.lightGray
        
        
        getUIForRplyQuestion()
        
        if DeviceType.IS_IPHONE_x{
            self.topOfNavBar.constant = 30
        }else {
            self.topOfNavBar.constant = 12
        }
        self.txtViewReply.delegate = self
        
        lanuageConversion()
    }
    
    @IBAction func btnCancelClk(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnExpandClk(_ sender: Any) {
        if imgArrowDown.image == UIImage(named: "down") {
            imgArrowDown.image = UIImage(named: "up")
            lblQuestion.isHidden = true
            lblDescribedQuestion.isHidden = false
            lblDescribedQuestion.text = question
            lblDescribedQuestion.numberOfLines = 0
            lblDescribedQuestion.textAlignment = NSTextAlignment.left
            lblExpandConstraint.constant = (lblDescribedQuestion.text?.height(withConstrainedWidth: self.view.frame.size.width - 20, font: UIFont.systemFont(ofSize: 15.0, weight: .semibold)))!
            lblDescribedQuestion.textColor = UIColor.lightGray
            lblDescribedQuestion.font =  UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        }else {
            imgArrowDown.image = UIImage(named: "down")
            lblDescribedQuestion.isHidden = true
            lblQuestion.isHidden = false
            lblQuestion.text = "RE: " + question
            lblDescribedQuestion.text = ""
            lblExpandConstraint.constant = 0
            lblQuestion.numberOfLines = 1
            lblQuestion.textAlignment = NSTextAlignment.center
            lblQuestion.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
            lblQuestion.textColor = UIColor.black
        }

    }
    
    //MARK:- Langauge Conversion
    func lanuageConversion(){
        self.btnCancel.setTitle((appDelegate.ArryLngResponeCustom!["cancel"] as? String)!, for: .normal)
        //"Cancel"
        self.btnSend.setTitle((appDelegate.ArryLngResponeCustom!["send"] as? String)!, for: .normal)
        //"Send"
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
        }
    }
    
    @IBAction func btnSendClk(_ sender: Any) {
        if callWS == "reply" {
            if self.txtViewReply.text! == "" {
                self.view.makeToast("Please enter some text..")
            }else {
                callWSRply()
            }
        }
        else if callWS == "editQuestion" {
            //callWSOfeditQuestion()
        }
        else if callWS == "editAnswer" {
            callWSOfeditLastAnswer()
        }
    }
    
    
    func getUIForRplyQuestion() {
        let status = getJsonData!["status"] as! String
        if status == "1" {
            if let data = getJsonData!["data"] as? [String:Any] {
                if let common_element = data["common_element"] as? [String:Any] {
                    let navigation_bar = common_element["navigation_bar"] as! Dictionary<String,String>
                    let size = navigation_bar["size"]
                    //let bgcolor = navigation_bar["bgcolor"]
                    let txtcolorHex = navigation_bar["txtcolorHex"]
                    let sizeInt:Int = Int(size!)!
                    
                    let genarlSettings = common_element["general_settings"] as! [String:Any]
                    let general_font = genarlSettings["general_font"] as! [String:Any]
                    let fontstyle = general_font["fontstyle"] as! String
                    //let bgScreenColor = genarlSettings["screen_bg_color"] as! String
                    
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor().HexToColor(hexString: txtcolorHex!),NSAttributedStringKey.font: checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(sizeInt))]
                    self.navigationController?.navigationBar.barTintColor = UIColor().HexToColor(hexString: "#FFFFFF")
                    
                    //Title
                    if let title = genarlSettings["title"] as? Dictionary<String,String> {
                        let size = title["size"]
                        let txtcolorHex = title["txtcolorHex"]
                        let fontstyle = title["fontstyle"]
                        let sizeInt:Int = Int(size!)!
                        
                        lblQuestion.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                        lblQuestion.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    }
                    
                    //SubTitle
                    if let subtitle = genarlSettings["subtitle"] as? Dictionary<String,String> {
                        let size = subtitle["size"]
                        let txtcolorHex = subtitle["txtcolorHex"]
                        let fontstyle = subtitle["fontstyle"]
                        let sizeInt:Int = Int(size!)!
                        
                        lblTo.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                        lblTo.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                    }
                    
                    let fromElement = genarlSettings["form_elements"] as! [String:Any]
                    //login
                    if let txtField = fromElement["textfield"] as? Dictionary<String,String> {
                        let size = txtField["size"]
                        let txtcolorHex = txtField["txtcolorHex"]
                        let fontstyle = txtField["fontstyle"]
                        let sizeInt:Int = Int(size!)!
                        
                        txtViewReply.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                        txtViewReply.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    }
                    //stopActivityIndicator()
                }
            }
        } else {
            stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    //MARK:- textView delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (txtViewReply != nil){
            txtViewReply.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtViewReply.text == "" {
            txtViewReply.text = (appDelegate.ArryLngResponeCustom!["type_here"] as? String)!
        }
    }
    
}

//MARK:- WS Parsing
extension ReplyViewController {
    
    //MARK: WS Replay Questions
    func callWSRply(){
        //URL: http://27.109.19.234/app_builder/index.php/api/addAnswer?appclientsId=1&userId=1&userPrivateKey=Jg3K5zbmYa06QREp&appId=1&questionId=16&answerType=0&answer=same%20reply&flag=1
        
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "questionId" : question_id,
                          "answerType" : "0", //1: audio and 0: text
                          "answer" : self.txtViewReply.text!,
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
            self.callWSOfRply(strURL: strURL, dictionary: dictionary as! Dictionary<String, String> )
        }else{
            stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOfRply(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.txtViewReply.text = ""
                    let alrtTitleStr = NSMutableAttributedString(string: (self.appDelegate.ArryLngResponeCustom!["comment_submitted"] as? String)!)
                    //"Comment submitted"
                    alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                    
                    let alrtMessage = NSMutableAttributedString(string:(self.appDelegate.ArryLngResponSystm!["comment_under_moderation"] as? String)!)
                    //"Your comment is under moderation.\n Please wait till it gets approved"
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
            else{
                let status = JSONResponse["status"] as? String
                self.stopActivityIndicator()
                switch status!{
                case "0":
                    print("error2: ")
                    if (JSONResponse["errorCode"] as? String) == userInfo.logOuterrorCode {
                        //When Parameter Missing and user ID, PrivateKey Wrong
                        
                        let alrtTitleStr = NSMutableAttributedString(string: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String))
                        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                        
                        let alrtMessage = NSMutableAttributedString(string: string.privateKeyMsg)
                        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                        
                        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                        alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                        alertController.setValue(alrtMessage, forKey: "attributedMessage")
                        
                        //let uiAlert = UIAlertController(title: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String), message: "Sorry We Are Unable To Find Your ID \nAssociated With Your Profile.", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!, style: .default, handler: { action in
                            DispatchQueue.main.async{
                                let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                                for aViewController in viewControllers {
                                    if aViewController is Login {
                                        self.navigationController!.popToViewController(aViewController, animated: true)
                                    }
                                }
                            }
                        }))
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
    
    //MARK: WS editQuestion
    func callWSOfeditQuestion(){
        
        //URL : http://27.109.19.234/app_builder/index.php/api/editQuestion?appclientsId=1&userId=1&userPrivateKey=yJ4iF4r8z2EabBTq&appId=1&questionId=1&questionText=samplequestion
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "questionId" : question_id,
                          "questionText": txtViewReply.text] as [String : Any]
        
        print("I/P markRead:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "editQuestion?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            if flgActivity{
                self.startActivityIndicator()
            }
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.WSOfeditQuestion(strURL: strURL, dictionary: dictionary as! Dictionary<String, String> )
        }else{
            stopActivityIndicator()
            //self.refreshControl.endRefreshing()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func WSOfeditQuestion(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    //self.refreshControl.endRefreshing()
                    self.view.makeToast((JSONResponse["message"] as? String)!)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else{
                let status = JSONResponse["status"] as? String
                self.stopActivityIndicator()
                //self.refreshControl.endRefreshing()
                switch status!{
                case "0":
                    print("error2: ")
                    if (JSONResponse["errorCode"] as? String) == userInfo.logOuterrorCode {
                        //When Parameter Missing and user ID, PrivateKey Wrong
                        let alrtTitleStr = NSMutableAttributedString(string: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String))
                        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                        
                        let alrtMessage = NSMutableAttributedString(string: string.privateKeyMsg)
                        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                        
                        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                        alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                        alertController.setValue(alrtMessage, forKey: "attributedMessage")
                        
                        //let uiAlert = UIAlertController(title: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String), message: "Sorry We Are Unable To Find Your ID \nAssociated With Your Profile.", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!, style: .default, handler: { action in
                            DispatchQueue.main.async{
                                let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                                for aViewController in viewControllers {
                                    if aViewController is Login {
                                        self.navigationController!.popToViewController(aViewController, animated: true)
                                    }
                                }
                            }
                        }))
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
            //self.refreshControl.endRefreshing()
            print("error: ",error)
            DispatchQueue.main.async{
                self.view.makeToast(string.someThingWrongMsg)
            }
        })
    }
    
    //MARK: WS editLastAnswer
    func callWSOfeditLastAnswer(){
        
        //URL :  http://27.109.19.234/app_builder/index.php/api/editLastAnswer?appclientsId=1&userId=1&userPrivateKey=yJ4iF4r8z2EabBTq&appId=1&answerId=1&answerType=1&answer=test
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "answerId" : question_id,
                          "answerType": "0",
                          "answer": txtViewReply.text] as [String : Any]
        
        print("I/P markRead:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "editLastAnswer?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            if flgActivity{
                self.startActivityIndicator()
            }
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.WSOfeditLastAnswer(strURL: strURL, dictionary: dictionary as! Dictionary<String, String> )
        }else{
            stopActivityIndicator()
            //self.refreshControl.endRefreshing()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    
    func WSOfeditLastAnswer(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    
                    let alrtTitleStr = NSMutableAttributedString(string: "Comment submitted")
                    alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                    
                    let alrtMessage = NSMutableAttributedString(string: (self.appDelegate.ArryLngResponSystm!["comment_under_moderation"] as? String)!)
                    //"Your comment is under moderation.\n Please wait till it gets approved"
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
            else{
                let status = JSONResponse["status"] as? String
                self.stopActivityIndicator()
                //self.refreshControl.endRefreshing()
                switch status!{
                case "0":
                    print("error2: ")
                    if (JSONResponse["errorCode"] as? String) == userInfo.logOuterrorCode {
                        //When Parameter Missing and user ID, PrivateKey Wrong
                        let alrtTitleStr = NSMutableAttributedString(string: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String))
                        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                        
                        let alrtMessage = NSMutableAttributedString(string: string.privateKeyMsg)
                        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                        
                        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                        alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                        alertController.setValue(alrtMessage, forKey: "attributedMessage")
                        
                        
                        //let uiAlert = UIAlertController(title: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String), message: "Sorry We Are Unable To Find Your ID \nAssociated With Your Profile.", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!, style: .default, handler: { action in
                            DispatchQueue.main.async{
                                let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                                for aViewController in viewControllers {
                                    if aViewController is Login {
                                        self.navigationController!.popToViewController(aViewController, animated: true)
                                    }
                                }
                            }
                        }))
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
            //self.refreshControl.endRefreshing()
            print("error: ",error)
            DispatchQueue.main.async{
                self.view.makeToast(string.someThingWrongMsg)
            }
        })
    }
}

