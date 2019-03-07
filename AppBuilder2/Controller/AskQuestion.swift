//
//  AskQuestion.swift
//  AppBuilder2
//
//  Created by VISHAL on 13/03/18.
//  Copyright © 2018 VISHAL. All rights reserved.
//

import UIKit

class AskQuestion: UIViewController,NVActivityIndicatorViewable,UITextViewDelegate {

    
    @IBOutlet weak var textViewOfQuestion: UITextView!
    @IBOutlet weak var textViewOfQuestnDetails: UITextView!
    
    var appDelegate : AppDelegate!
    var chache:NSCache<AnyObject, AnyObject>!
    var flgActivity = true
    var timeOut: Timer!
    var apiSuccesFlag = ""
    var arryWSCoursData = Array<Any>()
    var noDataView = UIView()
    var strCourseId = ""
    var btnSubmit:UIButton!
    var btnCancel:UIButton!
    
    var getJsonData: [String:Any]?
    var commonElement = [String:Any]()
    var NavBgcolor = ""
    var txtNavcolorHex = ""
    var strTitle = ""
    var strQuestionId = ""
    var strQuestDetails = ""
    
    //MARK:- ViewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        getJsonData =  appDelegate.jsonData
        
        setNavigationButton()
        
        getUIForASkQuestion()
        
        self.stopActivityIndicator()
        
        if strTitle == "NewQuestion"{
            let str = (appDelegate.ArryLngResponeCustom!["new_question"] as? String)!//"New Question"
            if str.count > 28{
                let startIndex = str.index(str.startIndex, offsetBy: 28)
                self.title = String(str[..<startIndex] + "..")
            }else {
                self.title = (appDelegate.ArryLngResponeCustom!["new_question"] as? String)!
            }
            self.textViewOfQuestnDetails.text = (appDelegate.ArryLngResponSystm!["enter_question_msg"] as? String)!

        }else {
            let str = (appDelegate.ArryLngResponeCustom!["edit_question"] as? String)!//"Edit Question"
            if str.count > 28{
                let startIndex = str.index(str.startIndex, offsetBy: 28)
                self.title = String(str[..<startIndex] + "..")
            }else {
                self.title = (appDelegate.ArryLngResponeCustom!["edit_question"] as? String)!
            }
            textViewOfQuestnDetails.text = strQuestDetails
        }
        
        textViewOfQuestnDetails.delegate = self
        lanuageConversion()
    }
    
    func setNavigationButton()  {
        btnSubmit = UIButton(frame: CGRect(x: 0, y:0, width:80,height: 20))
        btnSubmit.setTitle((appDelegate.ArryLngResponeCustom!["done"] as? String)!, for: .normal)//"Done"
        btnSubmit.addTarget(self,action: #selector(btnSubmitClick), for: .touchUpInside)
        let widthConstraint = btnSubmit.widthAnchor.constraint(equalToConstant: 80)
        let heightConstraint = btnSubmit.heightAnchor.constraint(equalToConstant: 20)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        let rightButtonitem = UIBarButtonItem(customView: btnSubmit)
        let arrRightBarButtonItems : Array = [rightButtonitem]
        self.navigationItem.rightBarButtonItems = arrRightBarButtonItems
        
        //Design Of Navigation Bar Cancel
        btnCancel = UIButton(frame: CGRect(x: 0, y:0, width:80,height: 20))
        btnCancel.setTitle((appDelegate.ArryLngResponeCustom!["cancel"] as? String)!, for: .normal)//"Cancel"
        btnCancel.addTarget(self,action: #selector(backClick(_:)), for: .touchUpInside)
        let widthConstraint1 = btnCancel.widthAnchor.constraint(equalToConstant: 80)
        let heightConstraint1 = btnCancel.heightAnchor.constraint(equalToConstant: 20)
        heightConstraint1.isActive = true
        widthConstraint1.isActive = true
        
        let btnCancelBarButtonitem = UIBarButtonItem(customView: btnCancel)
        let arrLeftBarButtonItems : Array = [btnCancelBarButtonitem]
        self.navigationItem.leftBarButtonItems = arrLeftBarButtonItems
    }
    
    @objc func btnSubmitClick(){
        if strTitle == "NewQuestion"{
            if textViewOfQuestnDetails.text == "" || self.textViewOfQuestnDetails.text == (appDelegate.ArryLngResponSystm!["enter_question_msg"] as? String)!{
                self.view.makeToast((appDelegate.ArryLngResponSystm!["enter_question_msg"] as? String)!)
                //"Please Enter Question Details."
            }else {
                callWS()
            }
        }else {
            if textViewOfQuestnDetails.text == "" && textViewOfQuestnDetails.text == strQuestDetails{
                self.view.makeToast((appDelegate.ArryLngResponSystm!["enter_question_msg"] as? String)!)
                //"Please Enter Question Details."
            }else {
                callWSEditQuestion()
            }
        }
        
    }
    
    @objc func backClick(_ sender: Any){
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor().HexToColor(hexString: "#7FB84D"),NSAttributedStringKey.font: checkForFontType(fontStyle: "2", fontSize: CGFloat(18))]
        self.navigationController?.navigationBar.barTintColor = color.navigationColor
        self.navigationController?.popViewController(animated: true)
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
            self.stopAnimating()
        }
    }
    
    //MARK:- Langauge Conversion
    func lanuageConversion(){
        self.btnCancel.setTitle((appDelegate.ArryLngResponeCustom!["cancel"] as? String)!, for: .normal)
        //"Cancel"
        self.btnSubmit.setTitle((appDelegate.ArryLngResponeCustom!["done"] as? String)!, for: .normal)
        //"Done"
    }
    
    
    func getUIForASkQuestion() {
        let status = getJsonData!["status"] as! String
        if status == "1" {
            if let data = getJsonData!["data"] as? [String:Any] {
                if let common_element = data["common_element"] as? [String:Any] {
                    let navigation_bar = common_element["navigation_bar"] as! Dictionary<String,String>
                    let size = navigation_bar["size"]
                    let bgcolor = navigation_bar["bgcolor"]
                    let txtcolorHex = navigation_bar["txtcolorHex"]
                    let sizeInt:Int = Int(size!)!
                    
                    let genarlSettings = common_element["general_settings"] as! [String:Any]
                    let general_font = genarlSettings["general_font"] as! [String:Any]
                    let fontstyle = general_font["fontstyle"] as! String
                    
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor().HexToColor(hexString: txtcolorHex!),NSAttributedStringKey.font: checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(sizeInt))]
                    self.navigationController?.navigationBar.barTintColor = UIColor().HexToColor(hexString: bgcolor!)
                    
                    self.btnSubmit.setTitleColor(UIColor().HexToColor(hexString: txtcolorHex!), for: .normal)
                    self.btnCancel.setTitleColor(UIColor().HexToColor(hexString: txtcolorHex!), for: .normal)
                    
                    let fromElement = genarlSettings["form_elements"] as! [String:Any]
                    //login
                    if let txtField = fromElement["textfield"] as? Dictionary<String,String> {
                        let size = txtField["size"]
                        let txtcolorHex = txtField["txtcolorHex"]
                        let fontstyle = txtField["fontstyle"]
                        let sizeInt:Int = Int(size!)!
                        
                        textViewOfQuestion.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                        textViewOfQuestion.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                        
                        textViewOfQuestnDetails.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                        textViewOfQuestnDetails.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt + 5))
                    }
                }
            }
        } else {
            stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    //MARK:- textView delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if strTitle == "NewQuestion"{
            textViewOfQuestnDetails.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textViewOfQuestnDetails.text == "" && strTitle == "NewQuestion"{
            textViewOfQuestnDetails.text = (appDelegate.ArryLngResponSystm!["enter_question_msg"] as? String)!//"Enter your comment here..."
        }
    }
}

//MARK:- WS Parsing
extension AskQuestion {
    
    //MARK: WS Add Questions
    func callWS(){
        
    //URL:http://27.109.19.234/app_builder/index.php/api/addCourseQuestion?appclientsId=1&userId=1&userPrivateKey=Oc1PRCG0T48VADsi&appId=1&course_category_id=1&question=samplequestion
        
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "course_category_id" : self.strCourseId,
                          "appId" : userInfo.appId,
                          "question" : self.textViewOfQuestnDetails.text!]
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "addCourseQuestion?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            if flgActivity{
                self.startActivityIndicator()
            }
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSOfAddQuestn(strURL: strURL, dictionary: dictionary )
        }else{
            stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOfAddQuestn(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    //self.view.makeToast((JSONResponse["message"] as? String)!)
                    self.textViewOfQuestnDetails.text = ""
                    self.textViewOfQuestion.text = ""
                    
                    let alrtTitleStr = NSMutableAttributedString(string: (self.appDelegate.ArryLngResponeCustom!["question_submitted"] as? String)!)
                    //"Question Submitted"
                    alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                    
                    let alrtMessage = NSMutableAttributedString(string: (self.appDelegate.ArryLngResponSystm!["question_under_moderation"] as? String)!)
                    //"Your question is under moderation.\n Please wait till it gets approved."
                    alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                    
                    let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                    alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                    alertController.setValue(alrtMessage, forKey: "attributedMessage")
                    
                    //let alertController = UIAlertController(title: "Question Submitted", message: "Your question is under moderation.\n Please wait till it gets approved.", preferredStyle: .alert)
                    
                    let btnOK = UIAlertAction(title: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!, style: .default, handler: { action in
                        DispatchQueue.main.async{
                            
                            self.navigationController?.navigationBar.isHidden = true
                            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor().HexToColor(hexString: "#7FB84D"),NSAttributedStringKey.font: self.checkForFontType(fontStyle: "2", fontSize: CGFloat(18))]
                            self.navigationController?.navigationBar.barTintColor = color.navigationColor
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
    
    
    //MARK: WS editQuestion
    func callWSEditQuestion(){
        
        //URL : http://27.109.19.234/app_builder/index.php/api/editQuestion?appclientsId=1&userId=1&userPrivateKey=yJ4iF4r8z2EabBTq&appId=1&questionId=1&questionText=samplequestion
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "questionId" : self.strQuestionId,
                          "questionText": self.textViewOfQuestnDetails.text] as [String : Any]
        
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
                    self.view.makeToast((JSONResponse["message"] as? String)!)
                    self.textViewOfQuestnDetails.text = ""
                    self.textViewOfQuestion.text = ""                    
                    
                    let alrtTitleStr = NSMutableAttributedString(string: (self.appDelegate.ArryLngResponeCustom!["question_submitted"] as? String)!)
                    //"Question Submitted"
                    alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                    
                    let alrtMessage = NSMutableAttributedString(string: (self.appDelegate.ArryLngResponSystm!["question_under_moderation"] as? String)!)
                    //"Your question is under moderation.\n Please wait till it gets approved."
                    alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                    
                    let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                    alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                    alertController.setValue(alrtMessage, forKey: "attributedMessage")
                    
                    //let alertController = UIAlertController(title: "Question Submitted", message: "Your question is under moderation.\n Please wait till it gets approved.", preferredStyle: .alert)
                   
                    let btnOK = UIAlertAction(title: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!, style: .default, handler: { action in
                        DispatchQueue.main.async{
                            
                            self.navigationController?.navigationBar.isHidden = true
                            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor().HexToColor(hexString: "#7FB84D"),NSAttributedStringKey.font: self.checkForFontType(fontStyle: "2", fontSize: CGFloat(18))]
                            self.navigationController?.navigationBar.barTintColor = color.navigationColor
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
            //self.refreshControl.endRefreshing()
            print("error: ",error)
            DispatchQueue.main.async{
                self.view.makeToast(string.someThingWrongMsg)
            }
        })
    }
    
}

