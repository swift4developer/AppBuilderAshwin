//
//  Login.swift
//  Login
//
//  Created by Aditya on 27/02/18.
//  Copyright © 2018 Aditya. All rights reserved.
//

import UIKit
import LocalAuthentication
import Firebase
import Alamofire

class Login: UIViewController,NVActivityIndicatorViewable {
    
    @IBOutlet weak var btnRemberMe: UIButton!
    @IBOutlet weak var lblOfProwredBy: UILabel!
    @IBOutlet weak var backgrndImg: UIImageView!
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgCheckbox: UIImageView!
    @IBOutlet weak var btnLoginWithTouchID: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var BtnLang: UIButton!
    
    @IBOutlet weak var btnRememberme: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtFieldUsername: UITextField!
    @IBOutlet weak var viewLogin: UIView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var btnLangTitle: UIButton!
    @IBOutlet weak var lblOfLangName: UILabel!
    @IBOutlet weak var imgOfFlag: UIImageView!
    @IBOutlet weak var viewOfLang: UIView!
    
    @IBOutlet weak var bgStatusView: UIView!
    
    var timeOut: Timer!
    var apiSuccesFlag = ""
    var getJsonData: [String:Any]?
    var chache:NSCache<AnyObject, AnyObject>!
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var flagForFingerPrint = true
    var checkImgbgColor = ""
    var rememberImgFlag:Bool!
    var JSONResponse = [String:Any]()
    var window: UIWindow?
    let reachability = Reachability()!
    var strGetPrvKey = ""
    
    //MARK: - VideDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: "isFirstLaunched")

        getJsonData =  delegate.jsonData
        self.chache = NSCache()
       
        self.btnForgotPassword.isHidden = true
        
        if (UserDefaults.standard.string(forKey: "1stTime") != nil) {
            //"value is not nil"
        }else {
            //"value is nil"
            UserDefaults.standard.set("1", forKey: "1stTime")
            UserDefaults.standard.set(1.0, forKey: "PlayerRate")
        }
        
        if userInfo.isMultiLang == "0"{
            self.BtnLang.isHidden = true
            self.viewOfLang.isHidden = true
        }else {
            self.BtnLang.isHidden = false
            self.viewOfLang.isHidden = false
        }
        
        if UserDefaults.standard.string(forKey: "offLineFlag") != nil {
            if UserDefaults.standard.string(forKey: "offLineFlag") == "0"{
                offlineAlert()
            }
        }
        
        activityIndicator.isHidden = true
        imgHeightConstraint.constant = self.view.frame.height/2
        self.navigationController?.navigationBar.isHidden = true
        
        viewLogin.layer.cornerRadius = 5.0
     
        if UserDefaults.standard.string(forKey: "EnableFingerPrint") == "1"{
            //FigerPrint()
        }
        
        //Notification Centre
        NotificationCenter.default.addObserver(self, selector: #selector(appInBackGround), name: NSNotification.Name(rawValue:"applicationInBackground"), object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive(notification:)),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
        
        
        
    }
   /* override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        
        //checkIfTouchIDEnabled()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChange(notification:)), name: Notification.Name.reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        }catch {
            print("Error")
        }
        
        getUISettingForLogin()
        
        self.navigationController?.navigationBar.isHidden = true
        if (UserDefaults.standard.string(forKey: "checklogin") == "1"){
            txtFieldUsername.text = UserDefaults.standard.string(forKey: "emailId")
            txtPassword.text = UserDefaults.standard.string(forKey: "password")
            self.imgCheckbox.image = UIImage(named: "check-box-selected")
            self.imgCheckbox.tintImageColor(color: UIColor().HexToColor(hexString: checkImgbgColor))
            rememberImgFlag = false
        }else {
            txtFieldUsername.text = ""
            txtPassword.text = ""
            self.imgCheckbox.tintImageColor(color: UIColor().HexToColor(hexString: checkImgbgColor))
            rememberImgFlag = true
        }

        checkAppVerison()
        lanuageConversion()
        
    }
    
    //MARK:- Langauge Conversion
    func lanuageConversion(){
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("LangDataJson.json")
        
        if FileManager.default.fileExists(atPath: documentsURL.relativePath) {
            delegate.ArryLngResponSystm = retrieveLangDataFile()["responseSystem"] as? [String:Any]
            delegate.ArryLngResponeCustom = retrieveLangDataFile()["responseCustom"] as? [String:Any]
        }
        
        if delegate.ArryLngResponeCustom != nil {
            self.btnLogin.setTitle(delegate.ArryLngResponeCustom!["login"] as? String, for: .normal)
            self.lblOfProwredBy.text = delegate.ArryLngResponeCustom!["powered_by"] as? String
            self.btnRemberMe.setTitle(delegate.ArryLngResponeCustom!["remember_me"] as? String, for: .normal)
            self.txtFieldUsername.placeholder = delegate.ArryLngResponeCustom!["enter_username"] as? String
            self.txtPassword.placeholder = delegate.ArryLngResponeCustom!["enter_password"] as? String
        }
    }
    
    //MARK:- ChangeInNetwork Method
    @objc func reachabilityChange(notification: Notification) {
        
        let reachability = notification.object as! Reachability
        if reachability.connection != .none {
            
            getUISettingForLogin()
            
            if (UserDefaults.standard.string(forKey: "checklogin") == "1"){
                txtFieldUsername.text = UserDefaults.standard.string(forKey: "emailId")
                txtPassword.text = UserDefaults.standard.string(forKey: "password")
                self.imgCheckbox.image = UIImage(named: "check-box-selected")
                self.imgCheckbox.tintImageColor(color: UIColor().HexToColor(hexString: checkImgbgColor))
                rememberImgFlag = false
            }else {
                txtFieldUsername.text = ""
                txtPassword.text = ""
                self.imgCheckbox.tintImageColor(color: UIColor().HexToColor(hexString: checkImgbgColor))
                rememberImgFlag = true
            }
            checkAppVerison()
        }
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
       checkAppVerison()
    }
    
    func checkAppVerison(){
        
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        print("Version--------\(version) &  build-------- \(build)")
        callWSOfAppUpdate(buildStr: build)
    }
    
    @IBAction func btnLoginWithTouchID(_ sender: Any) {
        var title = ""
        var msg = ""
        if DeviceType.IS_IPHONE_x {
            
            if delegate.ArryLngResponSystm != nil {
                title = (delegate.ArryLngResponSystm!["face_id_access"] as? String)!
                msg = (delegate.ArryLngResponSystm!["after_login_set_face_id"] as? String)!
            }else {
                title = "Face ID Access"
                msg = "After login set your Face ID Access"
            }
            
            if UserDefaults.standard.string(forKey: "EnableFingerPrint") == "1" && (UserDefaults.standard.string(forKey: "checklogin") == "1"){
                self.strGetPrvKey = "1"
                FigerPrint()
            }else {
                
                let alrtTitleStr = NSMutableAttributedString(string: title)
                alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                
                let alrtMessage = NSMutableAttributedString(string: msg)
                alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                
                let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                alertController.setValue(alrtMessage, forKey: "attributedMessage")
                
                alertController.addAction(UIAlertAction(title: (self.delegate.ArryLngResponeCustom!["ok"] as! String), style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController,animated: true,completion: nil)
            }
        }else {
            if delegate.ArryLngResponSystm != nil {
                title = (delegate.ArryLngResponSystm!["face_id_access"] as? String)!
                msg = (delegate.ArryLngResponSystm!["after_login_set_face_id"] as? String)!
            }else {
                title = "Fingerprint Access"
                msg = "After login set your Fingerprint Access"
            }
           
            if UserDefaults.standard.string(forKey: "EnableFingerPrint") == "1" && (UserDefaults.standard.string(forKey: "checklogin") == "1"){
                self.strGetPrvKey = "1"
                FigerPrint()
            }else {
                
                let alrtTitleStr = NSMutableAttributedString(string: title)
                alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                
                let alrtMessage = NSMutableAttributedString(string: msg)
                alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                
                let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                alertController.setValue(alrtMessage, forKey: "attributedMessage")
                
                alertController.addAction(UIAlertAction(title: (self.delegate.ArryLngResponeCustom!["ok"] as! String), style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController,animated: true,completion: nil)
            }
        }
    }
    
    @IBAction func btnLoginClk(_ sender: Any) {
        
        if validation.checkNotNullParameter(checkStr: txtFieldUsername.text!){
            if delegate.ArryLngResponSystm != nil {
                self.view.makeToast((delegate.ArryLngResponSystm!["enter_email_msg"] as? String)!)
            }else {
                self.view.makeToast("Please enter email address.")
            }
        }
        else if validation.isValidEmail(testEmail: (txtFieldUsername.text?.trimmingCharacters(in: .whitespaces))!){
            if delegate.ArryLngResponSystm != nil {
                self.view.makeToast((delegate.ArryLngResponSystm!["enter_valid_email_msg"] as? String)!)
            }else {
                self.view.makeToast("Please enter valid email address.")
            }
        }
        else if validation.checkNotNullParameter(checkStr: txtPassword.text!){
            self.view.makeToast((delegate.ArryLngResponSystm!["enter_password_msg"] as? String)!)
        }else  if (txtPassword.text?.characters.count)! < 6  {
            self.view.makeToast((delegate.ArryLngResponSystm!["enter_valid_password_msg"] as? String)!)
        }else {
            let userName = txtFieldUsername.text?.trimmingCharacters(in: .whitespaces)
            let password = txtPassword.text
            let devicID = InstanceID.instanceID().token()!
            let deviceId = String(devicID)
            
            var langID = ""
            if UserDefaults.standard.string(forKey: "strlanguageID") != nil {
                langID = UserDefaults.standard.string(forKey: "strlanguageID")!
            }else {
                langID = "1"
            }
            
            let dictionary = ["email" : userName,
                              "password" : password,
                              "appclientsId" : userInfo.appclientsId,
                              "deviceType" : "2",
                              "deviceUDID" : deviceId,
                              "appId" : userInfo.appId,
                              "languageId" : langID
                ] as! [String : String]
            
            print("I/P: userLogin",dictionary)
            var strURL = ""
            strURL = String(strURL.characters.dropFirst(1))
            strURL = Url.baseURL + "userLogin?"
            print(strURL)
            strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            
            if validation.isConnectedToNetwork() == true {
                startActivityIndicator()
                _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
                apiSuccesFlag = "1"
                self.callWSOfLogin(strURL: strURL, dictionary: dictionary )
            }else{
                stopActivityIndicator()
                self.view.makeToast(string.noInternateMessage2)
            }
        }
    }
    
    @IBAction func btnForgotPasswordClk(_ sender: Any) {
        let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountRecoveryVC") as! AccountRecoveryVC
        self.navigationController?.pushViewController(accountVC, animated: true)
    }
    
    @IBAction func btnRememberClk(_ sender: Any) {
        self.imgCheckbox.tintImageColor(color: UIColor().HexToColor(hexString: checkImgbgColor))
        
        if rememberImgFlag == true {
            UserDefaults.standard.set("1", forKey: "checklogin")
            self.imgCheckbox.image = UIImage(named: "check-box-selected")
            self.imgCheckbox.tintImageColor(color: UIColor().HexToColor(hexString: checkImgbgColor))
            UserDefaults.standard.set(txtFieldUsername.text, forKey: "emailId")
            UserDefaults.standard.set(txtPassword.text, forKey: "password")
            rememberImgFlag = false
        }
        else {
            self.imgCheckbox.image = UIImage(named: "check-box-empty")
            self.imgCheckbox.tintImageColor(color: UIColor().HexToColor(hexString: checkImgbgColor))
            rememberImgFlag = true
        }
    }
    
    @IBAction func BtnLangClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectLangauge") as! SelectLangauge
        UserDefaults.standard.set(false, forKey: "isFirstLaunched")
        vc.flagForBackBtn = "2"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)

        self.startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
        self.timeOut = Timer.scheduledTimer(timeInterval: 35.0, target: self, selector: #selector(Login.cancelWeb), userInfo: nil, repeats: false)
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

    //MARK: - Danyamic UI of Login
    func getUISettingForLogin() {
        if getJsonData != nil{
            activityIndicator.isHidden = true
            backgroundImage.isHidden = true

            setUpLoginUI()
        
        }else {
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
            self.backgroundImage.isHidden = false
            callWsOfUI()
        }
    }
    
    
    func offlineAlert(){
        let alrtTitleStr = NSMutableAttributedString(string: (delegate.ArryLngResponSystm!["your_internet_is_very_slow"] as? String)!)
        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
        
        let alrtMessage = NSMutableAttributedString(string: (delegate.ArryLngResponSystm!["do_you_want_to_go_to_offline_mode_and_view_your_downloaded_content"] as? String)!)
        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
        alertController.setValue(alrtMessage, forKey: "attributedMessage")
        
        //"Yes"
        let btnYes = UIAlertAction(title: (delegate.ArryLngResponeCustom!["yes"] as? String)!, style: .default, handler: { action in
            self.navigationController?.navigationBar.isHidden = false
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(vc, animated: true)
        })
        //"No"
        let btnNo = UIAlertAction(title: (delegate.ArryLngResponeCustom!["no"] as? String)!, style: .default, handler: { action in
            
        })
        alertController.addAction(btnYes)
        alertController.addAction(btnNo)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //vishal
    @objc func appInBackGround(){
        //we are in Backfroudn state
        if self.imgCheckbox.image == UIImage(named: "check-box-selected") ||  (UserDefaults.standard.string(forKey: "checklogin") == "1"){
            UserDefaults.standard.set(self.txtFieldUsername.text, forKey: "emailId")
            UserDefaults.standard.set(self.txtPassword.text, forKey: "password")
            self.imgCheckbox.image = UIImage(named: "check-box-selected")
            self.imgCheckbox.tintImageColor(color: UIColor().HexToColor(hexString: checkImgbgColor))
            UserDefaults.standard.set("1", forKey: "checklogin")
        }else {
            UserDefaults.standard.set("2", forKey: "checklogin")
        }
    }
    
    func setUpLoginUI(){
        let status = getJsonData!["status"] as! String
        if status == "1" {
            if let data = getJsonData!["data"] as? [String:Any] {
                
                let loginData = data["login"] as! [String:Any]
                let commonElement = data["common_element"] as! [String:Any]
                let genarlSettings = commonElement["general_settings"] as! [String:Any]
                let fromElement = genarlSettings["form_elements"] as! [String:Any]
                
                delegate.alertUiSetting  = genarlSettings["alert_msg"]  as? [String:Any]
                
                let navigation = commonElement["navigation_bar"] as! [String:Any]
                delegate.strStatusColor = navigation["bgcolor"] as! String
                
                if let course_Element = data["course"] as? [String:Any]{
                    if let lesson = course_Element["lesson"] as? [String:Any] {
                        if let video_progressbar_color = lesson["video_progressbar_color"] as? String {
                            UserDefaults.standard.set(video_progressbar_color, forKey: "VideoPogresColor")
                        }
                    }
                }
                
                userInfo.appId = getJsonData!["appId"] as! String
                userInfo.appclientsId = getJsonData!["appclientsId"] as! String
                UIApplication.shared.statusBarView?.backgroundColor = UIColor().HexToColor(hexString: self.delegate.strStatusColor)
                
                //login
                if let txtField = fromElement["textfield"] as? Dictionary<String,String> {
                    let size = txtField["size"]
                    let txtcolorHex = txtField["txtcolorHex"]
                    let fontstyle = txtField["fontstyle"]
                    let sizeInt:Int = Int(size!)!
                    txtFieldUsername.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                    txtFieldUsername.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    txtPassword.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    txtPassword.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                }
                
                
                //Screen Bg Color
                let screen_bg_color = loginData["screen_bg_color"] as? String
                self.view.backgroundColor = UIColor().HexToColor(hexString: screen_bg_color!)
                self.bgStatusView.backgroundColor = UIColor().HexToColor(hexString: delegate.strStatusColor)
                
                
                //Allow Finger Print Flag
                let fingerprintFlag = loginData["allow_fingerprint_visible"] as? String
                if fingerprintFlag == "1" && UserDefaults.standard.string(forKey: "EnableFingerPrint") == "1" && (UserDefaults.standard.string(forKey: "checklogin") == "1"){
                    btnLoginWithTouchID.isHidden = false
                    
                    if DeviceType.IS_IPHONE_x {
                        btnLoginWithTouchID.setBackgroundImage(UIImage(named:"FaceID"), for: .normal)
                    }else {
                        btnLoginWithTouchID.setBackgroundImage(UIImage(named:"touchID"), for: .normal)
                    }
                }else {
                    btnLoginWithTouchID.isHidden = true
                }
                
                //Login Button
                if let btnFiled = loginData["login_button"] as? Dictionary<String,String>{
                    let size = btnFiled["size"]
                    let txtcolorHex = btnFiled["txtcolorHex"]
                    let fontstyle = btnFiled["fontstyle"]
                    let bgColor = btnFiled["bgcolor"]
                    
                    let sizeInt:Int = Int(size!)!
                    btnLogin.titleLabel?.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    btnLogin.setTitleColor(UIColor().HexToColor(hexString: txtcolorHex!), for: .normal)
                    btnLogin.backgroundColor = UIColor().HexToColor(hexString: bgColor!)
                }
                
                //Forgetpassword Button
                if let forgetpassword = loginData["forgetpassword"] as? Dictionary<String,String> {
                    let size = forgetpassword["size"]
                    let txtcolorHex = forgetpassword["txtcolorHex"]
                    let fontstyle = forgetpassword["fontstyle"]
                    let sizeInt:Int = Int(size!)!
                    btnForgotPassword.titleLabel?.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    btnForgotPassword.setTitleColor(UIColor().HexToColor(hexString: txtcolorHex!), for: .normal)
                }
                
                //Remember me and PowredBy Font
                if let fontSize = genarlSettings["general_fontsize"] as? Dictionary<String,String>{
                    let size = fontSize["medium"]
                    let sizeInt:Int = Int(size!)!
                    let general_font = genarlSettings["general_font"] as! Dictionary<String,String>
                    let fontstyle = general_font["fontstyle"]
                    let generalTxtColor = general_font["txtcolorHex"]
                    
                    lblOfProwredBy.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    
                    let size1 = fontSize["small"]
                    let sizeInt1:Int = Int(size1!)!
                    
                    btnRemberMe.titleLabel?.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    
                    if (self.delegate.ArryLngResponeCustom?.count)! > 0 {
                        let attrsSelect = [
                            NSAttributedStringKey.font : checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt1 + 5)),
                            NSAttributedStringKey.foregroundColor : UIColor().HexToColor(hexString: generalTxtColor!),
                            NSAttributedStringKey.underlineStyle : 1] as [NSAttributedStringKey : Any] as [NSAttributedStringKey : Any]
                        let attributedStringSelect = NSMutableAttributedString(string:"")
                        let buttonTitleStr = NSMutableAttributedString(string:" (" + (delegate.ArryLngResponeCustom!["select_language"] as? String)!+")", attributes:attrsSelect)
                        attributedStringSelect.append(buttonTitleStr)
                        btnLangTitle.setAttributedTitle(buttonTitleStr, for: .normal)
                    }
                    if UserDefaults.standard.string(forKey: "strlanguageID") != nil {
                        self.lblOfLangName.text = UserDefaults.standard.string(forKey: "StrlanguageName")
                    }else {
                        self.lblOfLangName.text = "English"
                    }
                }
                
                //Language Flag image downloaded
                if UserDefaults.standard.string(forKey: "StrlanguageImage") != nil{
                    let imgUrl = UserDefaults.standard.string(forKey: "StrlanguageImage")
                    
                    let imageName = self.separateImageNameFromUrl(Url: imgUrl!)
                    self.imgOfFlag.backgroundColor = UIColor(red: 85.0/255.0, green:  85.0/255.0, blue:  85.0/255.0, alpha: 1.0)
                    
                    if(self.chache.object(forKey: imageName as AnyObject) != nil){
                        self.imgOfFlag.image = self.chache.object(forKey: imageName as AnyObject) as? UIImage
                    }else{
                        if validation.checkNotNullParameter(checkStr: imgUrl!) == false {
                            Alamofire.request(imgUrl!).responseImage{ response in
                                if let image = response.result.value {
                                    self.imgOfFlag.image = image
                                    self.chache.setObject(image, forKey: imageName as AnyObject)
                                }
                                else {
                                    self.imgOfFlag.backgroundColor = UIColor().HexToColor(hexString: "555555")
                                }
                            }
                        }else {
                            self.imgOfFlag.backgroundColor = UIColor().HexToColor(hexString: "555555")
                        }
                    }
                }else{
                    self.imgOfFlag.backgroundColor = UIColor().HexToColor(hexString: "555555")
                }
                
                //Alert for all title
                if let title = delegate.alertUiSetting!["title"] as? Dictionary<String,String> {
                    let size = title["size"]
                    let txtcolorHex = title["txtcolorHex"]
                    let fontstyle = title["fontstyle"]
                    let sizeInt:Int = Int(size!)!
                    
                    color.alertTitleTextColor = UIColor().HexToColor(hexString: txtcolorHex!)
                    fontAndSize.alertTitleFontSize = CGFloat(sizeInt)
                    fontAndSize.alertTitleFontStyle = fontstyle!
                }
                
                //Alert for sub title
                if let subtitle = delegate.alertUiSetting!["subtitle"] as? Dictionary<String,String> {
                    let size = subtitle["size"]
                    let txtcolorHex = subtitle["txtcolorHex"]
                    let fontstyle = subtitle["fontstyle"]
                    let sizeInt:Int = Int(size!)!
                    
                    color.alertSubTitleTextColor = UIColor().HexToColor(hexString: txtcolorHex!)
                    fontAndSize.alertSubTitleFontSize = CGFloat(sizeInt)
                    fontAndSize.alertSubTitleFontStyle = fontstyle!
                }
                
                //Alert positive button
                if let btnPositiv = delegate.alertUiSetting!["positive"] as? Dictionary<String,String> {
                    let size = btnPositiv["size"]
                    let txtcolorHex = btnPositiv["txtcolorHex"]
                    let fontstyle = btnPositiv["fontstyle"]
                    let sizeInt:Int = Int(size!)!
                    
                    color.alertPositiveBtnTxtColor = UIColor().HexToColor(hexString: txtcolorHex!)
                    fontAndSize.alertPositiveBtnFontSize = CGFloat(sizeInt)
                    fontAndSize.alertPositiveBtnFontStyle = fontstyle!
                }
                //Alert Negative button
                if let btnNegative = delegate.alertUiSetting!["positive"] as? Dictionary<String,String> {
                    let size = btnNegative["size"]
                    let txtcolorHex = btnNegative["txtcolorHex"]
                    let fontstyle = btnNegative["fontstyle"]
                    let sizeInt:Int = Int(size!)!
                    
                    color.alertNegativeBtnTxtColor = UIColor().HexToColor(hexString: txtcolorHex!)
                    fontAndSize.alertNegativeBtnFontSize = CGFloat(sizeInt)
                    fontAndSize.alertNegativeBtnFontStyle = fontstyle!
                }
                //Alert Warning button
                if let btnPositiv = delegate.alertUiSetting!["positive"] as? Dictionary<String,String> {
                    let size = btnPositiv["size"]
                    let txtcolorHex = btnPositiv["txtcolorHex"]
                    let fontstyle = btnPositiv["fontstyle"]
                    let sizeInt:Int = Int(size!)!
                    
                    color.alertWarningBtnTxtColor = UIColor().HexToColor(hexString: txtcolorHex!)
                    fontAndSize.alertWarningBtnFontSize = CGFloat(sizeInt)
                    fontAndSize.alertWarningBtnFontStyle = fontstyle!
                }
                
                checkImgbgColor = (loginData["remember_me_chkbox_bgcolor"] as? String)! //"FF0000"
                //Background image
                if loginData["bgimageurl"] as? String != nil{
                    let imgUrl = loginData["bgimageurl"] as? String
                    
                    let imageName = self.separateImageNameFromUrl(Url: imgUrl!)
                    if(self.chache.object(forKey: imageName as AnyObject) != nil){
                        backgrndImg.image = self.chache.object(forKey: imageName as AnyObject) as? UIImage
                    }else{
                        if validation.checkNotNullParameter(checkStr: imgUrl!) == false {
                            Alamofire.request(imgUrl!).responseImage{ response in
                                if let image = response.result.value {
                                    self.backgrndImg.image = image
                                    self.chache.setObject(image, forKey: imageName as AnyObject)
                                }
                                else {
                                    self.backgrndImg.backgroundColor = color.placeholdrImgColor
                                }
                            }
                        }else {
                            backgrndImg.backgroundColor = color.placeholdrImgColor
                        }
                    }
                }
                
                
                
            }
        }
    }
}

// MARK:- LOCAL
extension Login {
    
    func saveToJsonFile(jsonArray:[String:Any])  {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("JsonData.json")
        print(#function,fileUrl)
        //Transform array into data and save it into file
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(#function,"Data Could not stored in local")
        }
        //getTheResponse()
    }
    
    func saveToJsonFileHomeCourse(jsonArray:[String:Any])  {
        
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("HomeCourseJson.json")
        print(#function,fileUrl)
        // Transform array into data and save it into file
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(#function,error)
        }
    }
    
    func getTheResponse() {
        if let paymentFlag = JSONResponse["paymentFlag"] as? String {
            if paymentFlag == "1"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogPostViewController") as! BlogPostViewController
                UserDefaults.standard.set("1", forKey: "ArticleVideoFlag")
                if let paymentFail = JSONResponse["paymentFailure"] as? [Any] {
                    if paymentFail.count > 0{
                        vc.dicMediaData = paymentFail.first! as! NSDictionary
                        vc.strTitle = "artcile"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        self.view.makeToast((delegate.ArryLngResponSystm!["no_artcile"] as? String)!)
                    }
                }
            }else if UserDefaults.standard.string(forKey: "EnableFingerPrint") == "2" {
                self.navigationController?.navigationBar.isHidden = false
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                if self.JSONResponse.keys.contains("TagNames"){
                    vc.ffTagFlag = (self.JSONResponse["TagNames"] as? String)!
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                if UserDefaults.standard.string(forKey: "EnableFingerPrint") == "1" {
                    self.FigerPrint()
                }else if UserDefaults.standard.string(forKey: "EnableFingerPrint") == "3" {
                    self.FigerPrint()
                }else {
                    if DeviceType.IS_IPHONE_x {
                        FigerPrint()
                    }else {
                        let authentictionContext = LAContext()
                        var error: NSError?
                        if authentictionContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                            var titleMsg = ""
                            var msgText = ""
                            if DeviceType.IS_IPHONE_x {
                                titleMsg = (delegate.ArryLngResponSystm!["enable_faceid"] as? String)!
                                msgText = (delegate.ArryLngResponSystm!["turn_on_faceid"] as? String)!
                            }else {
                                titleMsg = (delegate.ArryLngResponSystm!["enable_fingerprint_title"] as? String)!
                                msgText = (delegate.ArryLngResponSystm!["enable_fingerprint_msg"] as? String)!
                            }
                            
                            let alrtTitleStr = NSMutableAttributedString(string: titleMsg)
                            alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                            
                            let alrtMessage = NSMutableAttributedString(string: msgText)
                            alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                            
                            let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                            alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                            alertController.setValue(alrtMessage, forKey: "attributedMessage")
                          
                            let btnYes = UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
                                self.FigerPrint()
                            })
                            
                            alertController.addAction(btnYes)
                            
                            let btnNo = UIAlertAction(title: "No", style: .default, handler: { (UIAlertAction) in
                                UserDefaults.standard.set("2", forKey: "EnableFingerPrint")
                                self.navigationController?.navigationBar.isHidden = false
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                                if self.JSONResponse.keys.contains("TagNames"){
                                    vc.ffTagFlag = (self.JSONResponse["TagNames"] as? String)!
                                }
                                self.navigationController?.pushViewController(vc, animated: true)
                            })
                           alertController.addAction(btnNo)
                            
                            self.present(alertController,animated: true,completion: nil)
                        }else {
                            //showAlertViewForNoBioMatric() //when user not set finger/faceId need to show alert for that user
                            
                            DispatchQueue.main.async{
                                UserDefaults.standard.set("2", forKey: "EnableFingerPrint")
                                UserDefaults.standard.synchronize()
                                userInfo.userId = UserDefaults.standard.string(forKey: "app_user_id")!
                                userInfo.userPrivateKey = UserDefaults.standard.string(forKey: "private_key")!
                                
                                print("userInfo.userId ",userInfo.userId  )
                                print("userInfo.userPrivateKey ", userInfo.userPrivateKey)
                                self.navigationController?.navigationBar.isHidden = false
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                                if self.JSONResponse.keys.contains("TagNames"){
                                    vc.ffTagFlag = (self.JSONResponse["TagNames"] as? String)!
                                }
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            return
                        }
                    }
                }
            }
        }
    }
}
   
//MARK:- Retrive From Local
extension UIViewController {
    
    func retrieveFromJsonFile() -> [String:Any] {
        //Get the url of yourFileName.json in document directory
        var responseData = [String:Any]()
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return ["":""]}
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("JsonData.json")
        //Read data from .json file and transform data into an array
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let personArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]  else {
                self.view.makeToast(string.someThingWrongMsg2)
                return ["":""]
            }
            responseData = personArray
            print(#function,fileUrl)
        } catch {
            print(error)
        }
        return responseData
    }
    
    func retrieveFromOfflineCourseJsonFile() -> [String:Any] {
        //Get the url of yourFileName.json in document directory
        var responseData = [String:Any]()
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return ["":""]}
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("OfflineCourse.json")
        //Read data from .json file and transform data into an array
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let personArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]  else {
                self.view.makeToast(string.someThingWrongMsg2)
                return ["":""]
            }
            responseData = personArray
            print(#function,fileUrl)
        } catch {
            print(error)
        }
        return responseData
    }
    
    func retrieveFromHomeCourseJsonFile() -> [String:Any] {
        //Get the url of Persons.json in document directory
        var responseData = [String:Any]()
        let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileUrl = documentsDirectoryUrl?.appendingPathComponent("HomeCourseJson.json")
        //Read data from .json file and transform data into an array
        do {
            let data = try Data(contentsOf: fileUrl!, options: [])
            if let personArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                responseData = personArray
                print(#function,fileUrl!)
            } else {
                self.view.makeToast(string.someThingWrongMsg2)
            }
        } catch {
            print(error)
        }
        return responseData
    }
    
    func retrieveLangDataFile() -> [String:Any] {
        //Get the url of Persons.json in document directory
        var responseData = [String:Any]()
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return ["":""]}
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("LangDataJson.json")
        //Read data from .json file and transform data into an array
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let personArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]  else {
                self.view.makeToast(string.someThingWrongMsg2)
                return ["":""]
            }
            responseData = personArray
            print(#function,fileUrl)
        } catch {
            print(error)
        }
        return responseData
    }
}
   
   
//MARK: Ws parsing
extension Login {
    
    func callWSOfLogin(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            print("JSONResponse login : ", JSONResponse)
            self.JSONResponse = JSONResponse
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    if let user_id = JSONResponse["app_user_id"] as? String{
                        if let private_Key = JSONResponse["private_key"] as? String {
                            userInfo.userId = user_id
                            userInfo.userPrivateKey = private_Key
                            userInfo.adminUserflag = (JSONResponse["adminFlag"] as? String)!
                            UserDefaults.standard.set("1", forKey: "offLineFlag")
                           
                            if self.rememberImgFlag == false {
                                UserDefaults.standard.set(self.txtFieldUsername.text, forKey: "emailId")
                                UserDefaults.standard.set(self.txtPassword.text, forKey: "password")
                                self.imgCheckbox.image = UIImage(named: "check-box-selected")
                                self.imgCheckbox.tintImageColor(color: UIColor().HexToColor(hexString: self.checkImgbgColor))
                            }else {
                                UserDefaults.standard.set(self.txtFieldUsername.text, forKey: "emailId")
                                UserDefaults.standard.set("2", forKey: "checklogin")
                            }
                            
                            if JSONResponse.keys.contains("ContactId") {
                                let contctKey = (JSONResponse["ContactId"] as? String)!
                                if contctKey != ""{
                                    UserDefaults.standard.set(contctKey, forKey: "contactID")
                                }
                            }
                            
                            if let paymentFlag = JSONResponse["paymentFlag"] as? String {
                                UserDefaults.standard.set(user_id, forKey: "app_user_id")
                                UserDefaults.standard.set(private_Key, forKey: "private_key")
                                UserDefaults.standard.set(paymentFlag, forKey: "paymentFlag")
                                UserDefaults.standard.synchronize()
                            }
                            
                            let manager = FileManager.default
                            let documentDirectoryUrlHomeSosn = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("HomeCourseJson.json")
                            if manager.fileExists(atPath: documentDirectoryUrlHomeSosn.relativePath) {
                                do{
                                    try manager.removeItem(at: documentDirectoryUrlHomeSosn)
                                    //Deleting HomeCourseJson file.
                                } catch {
                                    print("Error in deleting HomeCourseJson file ",error)
                                }
                            }
                            
                            let documentDirectoryUrlAllJson = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("JsonData.json")
                            if manager.fileExists(atPath: documentDirectoryUrlAllJson.relativePath) {
                                do{
                                    try manager.removeItem(at: documentDirectoryUrlAllJson)
                                    //Deleting JsonData file.
                                } catch {
                                    print("Error in deleting file All json file ",error)
                                }
                            }
                            
                            let documentDirectoryUrlOfflineCourse = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("OfflineCourse.json")
                            if manager.fileExists(atPath: documentDirectoryUrlOfflineCourse.relativePath) {
                                do{
                                    try manager.removeItem(at: documentDirectoryUrlOfflineCourse)
                                    //"Deleting OfflineCourse.json file ")
                                } catch {
                                    print("Error in deleting OfflineCourse.json file ",error)
                                }
                            }
                            
                            //callWSForCache
                            DispatchQueue.global(qos: .background).async {
                                //"This is run on the background queue"
                                self.callWSOfHomeCacheResponse()
                                self.callWSOfWholeResponse()
                                self.CallGetOfflineLesson()
                                
                                DispatchQueue.main.async {
                                    //"This is run on the main queue, after the previous code in outer block"
                                    self.getTheResponse()
                                }
                            }
                        }
                        else{
                            self.view.makeToast(string.someThingWrongMsg)
                        }
                    }
                    else{
                        self.view.makeToast(string.someThingWrongMsg)
                    }
                }
            }else{
                let status = JSONResponse["status"] as? String
                self.stopActivityIndicator()
                switch status!{
                case "0":
                    //When Parameter Missing
                    print("error2: ")
                    self.errorCodeAlert(title: (JSONResponse["title"] as? String)!, description: (JSONResponse["description"] as? String)!, errorCode: (JSONResponse["systemErrorCode"] as? String)!, okButton: (self.delegate.ArryLngResponeCustom!["ok"] as? String)!)
                    break
                default:
                    print("error1: ");
                }
            }
        }, failure: { (error) in
            self.apiSuccesFlag = "2"
            print("error: ",error)
            DispatchQueue.main.async{
                self.view.makeToast(string.someThingWrongMsg)
                self.stopActivityIndicator()
            }
        })
    }
    
    func callWsOfUI(){
        
        let dictionary = ["ostype" : "2","appclientsId" : userInfo.appclientsId]
        
        print("getUiSettingsNew I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getUiSettingsNew?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWsOfUISetting(strURL: strURL, dictionary: dictionary )
        }else{
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWsOfUISetting(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            //print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.backgroundImage.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.getJsonData = JSONResponse
                    self.delegate.jsonData = JSONResponse
                    if self.getJsonData != nil {
                        if (self.getJsonData!["status"] as? String == "1"){
                            self.setUpLoginUI()
                        }else {
                            userInfo.appId = "0"
                            userInfo.appclientsId = "0"
                        }
                    }else {
                        
                        let alrtMessage = NSMutableAttributedString(string:(self.delegate.ArryLngResponSystm!["setting_app_msg"] as? String)!)
                        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:14.0) , range: NSRange(location: 0, length: alrtMessage.length))
                        
                        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                        alertController.setValue(alrtMessage, forKey: "attributedMessage")
                        
                        alertController.addAction(UIAlertAction(title: (self.delegate.ArryLngResponeCustom!["retry"] as? String)!, style: UIAlertActionStyle.default, handler:{
                            action in
                            //calling ws
                            self.getUISettingForLogin()
                            
                        }))
                        self.present(alertController,animated: true,completion: nil)
                    }
                }
            }
            else{
                let status = JSONResponse["status"] as? String
                
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                switch status!{
                case "0":
                    //When Parameter Missing
                    self.serverError(title: (JSONResponse["title"] as? String)!, description:((JSONResponse["description"] as? String)! + "[ \((JSONResponse["systemErrorCode"] as? String)!)]"))
                    break
                default:
                    print("error1: ");
                    self.serverError(title: (JSONResponse["title"] as? String)!, description:((JSONResponse["description"] as? String)! + "[ \((JSONResponse["systemErrorCode"] as? String)!)]"))
                }
            }
        }, failure: { (error) in
            self.apiSuccesFlag = "2"
            print("error: ",error)
            DispatchQueue.main.async{
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.serverError(title: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String) ,description: (self.delegate.ArryLngResponSystm!["setting_app_msg"] as? String)!)
            }
        })
    }
    
    func serverError(title: String, description: String) {
        
        let alrtTitleStr = NSMutableAttributedString(string: title)
        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
        
        let alrtMessage = NSMutableAttributedString(string: description)
        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:14.0) , range: NSRange(location: 0, length: alrtMessage.length))
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.setValue(alrtMessage, forKey: "attributedMessage")
        
        var btnTitle = ""
        if self.delegate.ArryLngResponeCustom != nil {
            btnTitle = (self.delegate.ArryLngResponeCustom!["retry"] as? String)!
        }else {
            btnTitle = "retry"
        }
        alertController.addAction(UIAlertAction(title: btnTitle, style: UIAlertActionStyle.default, handler:{
            action in
            
            //calling ws
            self.getUISettingForLogin()
            
        }))
        self.present(alertController,animated: true,completion: nil)
    }
    
    //MARK: callWS Of Home CacheResponse
    func callWSOfHomeCacheResponse(){
        //URL : http://27.109.19.234/app_builder/index.php/api/getallmenuitemList?appclientsId=1&userId=1&userPrivateKey=zJSn1gY5PvDop9O1&appId=1&menuId=0
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateTimeStr = formatter.string(from: Date())
        
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "menuId" : "0",
                          "datetime" : dateTimeStr] as [String : Any]
        
        print("I/P For Home_Cache_Response:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getallmenuitemList?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSOfHomeCache(strURL: strURL, dictionary: dictionary as! Dictionary<String, String> )
        }else{
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    
    func callWSOfHomeCache(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            //print("callWSOfHomeCache JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    if JSONResponse.keys.contains("course_topic_limit") {
                        let courTopicLimitStr = JSONResponse["course_topic_limit"] as? String
                        UserDefaults.standard.set(courTopicLimitStr, forKey: "courseTopicLimit")
                    }
                    self.saveToJsonFileHomeCourse(jsonArray: JSONResponse)
                }
            }
            else{
                let status = JSONResponse["status"] as? String
                switch status!{
                case "0":
                    //When Parameter Missing
                    print("error2: ")
                    break
                default:
                    print("error1: ");
                }
            }
        }, failure: { (error) in
            self.apiSuccesFlag = "2"
            print("error: ",error)
            DispatchQueue.main.async{
                self.view.makeToast(string.someThingWrongMsg)
            }
        })
    }
    
    //MARK: New WS For Caching
    func callWSOfWholeResponse(){
        
        //URL : http://27.109.19.234/app_builder/index.php/api/getJson?appclientsId=1&userId=1&userPrivateKey=T1Hmh6pl0PU4jnCr&appId=1&jsonFlag=1
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateTimeStr = formatter.string(from: Date())
        
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "jsonFlag" : "1",
                          "datetime" : dateTimeStr] as [String : Any]
        
        print("I/P For Whole JSON Response:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getJson?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            //self.startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSOfGetWholeResponse(strURL: strURL, dictionary: dictionary as! Dictionary<String, String> )
        }else{
            //stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    
    func callWSOfGetWholeResponse(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            //print("getJson ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    //self.stopActivityIndicator()
                    self.saveToJsonFile(jsonArray: JSONResponse)
                }
            }
            else{
                let status = JSONResponse["status"] as? String
                //self.stopActivityIndicator()
                switch status!{
                case "0":
                    //When Parameter Missing
                    print("error2: ")
                    break
                default:
                    print("error1: ");
                }
                //self.getTheResponse()
            }
        }, failure: { (error) in
            self.apiSuccesFlag = "2"
            print("error: ",error)
            DispatchQueue.main.async{
                self.view.makeToast(string.someThingWrongMsg)
                //self.stopActivityIndicator()
            }
            //self.getTheResponse()
        })
    }
    
    //MARK:- FoceFullyUdpate
    func callWSOfAppUpdate(buildStr: String){
        
        //URL :: http://27.109.19.234/app_builder/index.php/api/checkappVersion?appclientsId=1&userId=1&userPrivateKey=UGH50O634moTBAQ9&appId=1&version=1.0.0.2&type=2
        
        var langID = ""
        if UserDefaults.standard.string(forKey: "strlanguageID") != nil {
            langID = UserDefaults.standard.string(forKey: "strlanguageID")!
        }else {
            langID = "1"
        }
        
        let dictionary = ["appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "version" : buildStr,
                          "type" : "2",
                          "languageId" : langID] as [String : Any]
        
        var strURL = ""
         print("checkappVersion dictionary ", dictionary)
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "checkappVersion?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSOfForceFullyAppUdpate(strURL: strURL, dictionary: dictionary as! Dictionary<String, String> )
        }else{
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    
    func callWSOfForceFullyAppUdpate(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            print("checkappVersion responces: ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                //self.stopActivityIndicator()
                if JSONResponse["version"] as? String == "1"{
                    
                    let alrtTitleStr = NSMutableAttributedString(string: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String))
                    alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                    
                    let alrtMessage = NSMutableAttributedString(string: (self.delegate.ArryLngResponSystm!["new_version_released_msg"] as? String)!)
                    alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                    
                    let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                    alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                    alertController.setValue(alrtMessage, forKey: "attributedMessage")
                    
                    alertController.addAction(UIAlertAction(title: (self.delegate.ArryLngResponeCustom!["update"] as? String)!, style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                        if let url = URL(string: "itms-apps://itunes.apple.com/app/id" + userInfo.appleId),
                            UIApplication.shared.canOpenURL(url){
                            
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
            }else{
                let status = JSONResponse["status"] as? String
                switch status!{
                case "0":
                    //When Parameter Missing
                    print("error2: ")
                    break
                default:
                    print("error1: ");
                }
            }
        }, failure: { (error) in
            self.apiSuccesFlag = "2"
            print("error: ",error)
        })
    }
    
    //MARK:- WS getOfflineLesson
    func CallGetOfflineLesson(){
        //URL : http://cms.membrandt.com/v2/index.php/api/getOfflineLesson?appclientsId=1&userId=78&userPrivateKey=ct5dSmzwO6Ax1oHf&appId=37
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateTimeStr = formatter.string(from: Date())
        
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "datetime" : dateTimeStr]
        
        print("I/P getOfflineLesson :",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getOfflineLesson?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSOfGetOfflineLesson(strURL: strURL, dictionary: dictionary )
        }else{
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOfGetOfflineLesson(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            //print("login getOfflineLesson", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.saveToOfflineJsonFile(jsonArray: JSONResponse)
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
    
    //MARK:- Ws Get Latest Priavte key
    func CallGetPrivateKey(){
        //URL : http://103.51.153.235/app_builder/index.php/api/getUserPrivateKey?appclientsId=1&appId=1&userId=1
        let dictionary = ["userId" : userInfo.userId,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId]
        
        print("I/P getOfflineLesson :",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getUserPrivateKey?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSOfGetPriavteKey(strURL: strURL, dictionary: dictionary )
        }else{
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOfGetPriavteKey(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    if let private_Key = JSONResponse["userPrivateKey"] as? String {
                        userInfo.userPrivateKey = private_Key
                        UserDefaults.standard.set(private_Key, forKey: "private_key")
                        UserDefaults.standard.synchronize()
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        if self.JSONResponse.keys.contains("TagNames"){
                            vc.ffTagFlag = (self.JSONResponse["TagNames"] as? String)!
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }else{
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
    
    //Local Storage of offline Data
    func saveToOfflineJsonFile(jsonArray:[String:Any])  {
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
 
//MARK: Finger print
extension Login{
    
    func FigerPrint(){
        
        var strResponce = ""
        var strCncledByuser = ""
        var strUserTppedHome = ""
        if self.delegate.ArryLngResponSystm != nil {
            strResponce = (self.delegate.ArryLngResponeCustom!["view_membership"] as? String)!
            strUserTppedHome = (self.delegate.ArryLngResponSystm!["user_tapped_Homebutton﻿"] as? String)!
        }else {
            strResponce = "Log on to view your membership"
            strUserTppedHome = "The user tapped the Home button."
        }
        let authentictionContext = LAContext()
        var error: NSError?
        
        /*if authentictionContext.canEvaluatePolicy(
         LAPolicy.deviceOwnerAuthenticationWithBiometrics,
         error: &error) {*/
        if authentictionContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            //Pop for Touch ID and handling the error
            authentictionContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason:
                 strResponce, reply: { (success, error) in
                    if success{
                        if UserDefaults.standard.value(forKey: "private_key") == nil || (UserDefaults.standard.value(forKey: "app_user_id") == nil) {
                            self.view.makeToast((self.delegate.ArryLngResponSystm!["login_first"] as? String)!)
                        }else {
                            DispatchQueue.main.async {
                                UserDefaults.standard.set("1", forKey: "EnableFingerPrint") //Enbale the Face/fingerPrint for App
                                UserDefaults.standard.synchronize()
                                userInfo.userId = UserDefaults.standard.string(forKey: "app_user_id")!
                                userInfo.userPrivateKey = UserDefaults.standard.string(forKey: "private_key")!
                                
                                print("userInfo.userId ",userInfo.userId  )
                                print("userInfo.userPrivateKey ", userInfo.userPrivateKey)
                                self.navigationController?.navigationBar.isHidden = false
                                
                                if self.strGetPrvKey == "1" {
                                    self.CallGetPrivateKey()
                                }else {
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                                    if self.JSONResponse.keys.contains("TagNames"){
                                        vc.ffTagFlag = (self.JSONResponse["TagNames"] as? String)!
                                    }
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        }
                    }else {
                        if let error = error as NSError?{
                            //Display specific error
                            let errorMessage = self.errorMessageForLAErrorCode(errorCode: error.code)
                            
                            if error.code == LAError.touchIDNotAvailable.rawValue || error.code == LAError.userCancel.rawValue || error.code == LAError.systemCancel.rawValue || error.code == -6{
                                
                                if UserDefaults.standard.value(forKey: "private_key") == nil || (UserDefaults.standard.value(forKey: "app_user_id") == nil) {
                                    self.view.makeToast((self.delegate.ArryLngResponSystm!["login_first"] as? String)!)
                                }else {
                                    DispatchQueue.main.async{
                                        UserDefaults.standard.set("2", forKey: "EnableFingerPrint") //Disable the Face/fingerPrint for App
                                        UserDefaults.standard.synchronize()
                                        userInfo.userId = UserDefaults.standard.string(forKey: "app_user_id")!
                                        userInfo.userPrivateKey = UserDefaults.standard.string(forKey: "private_key")!
                                        
                                        print("userInfo.userId ",userInfo.userId  )
                                        print("userInfo.userPrivateKey ", userInfo.userPrivateKey)
                                        self.navigationController?.navigationBar.isHidden = false
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                                        if self.JSONResponse.keys.contains("TagNames"){
                                            vc.ffTagFlag = (self.JSONResponse["TagNames"] as? String)!
                                        }
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                }
                            }else if errorMessage == strUserTppedHome{
                                //self.logOut()
                            }else {
                                self.showAlerViewAfterEvaluatePolicyWithMessage(message:errorMessage)
                            }
                        }
                    }
            })
        }else {
            //showAlertViewForNoBioMatric() //when user not set finger/faceId need to show alert for that user
            DispatchQueue.main.async{
                UserDefaults.standard.set("2", forKey: "EnableFingerPrint")
                UserDefaults.standard.synchronize()
                userInfo.userId = UserDefaults.standard.string(forKey: "app_user_id")!
                userInfo.userPrivateKey = UserDefaults.standard.string(forKey: "private_key")!
                
                print("userInfo.userId ",userInfo.userId  )
                print("userInfo.userPrivateKey ", userInfo.userPrivateKey)
                self.navigationController?.navigationBar.isHidden = false
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                if self.JSONResponse.keys.contains("TagNames"){
                    vc.ffTagFlag = (self.JSONResponse["TagNames"] as? String)!
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
    }
    
    func showAlerViewAfterEvaluatePolicyWithMessage(message: String){
        showAlertWithTitle(title: "Sorry!", message: message)
    }
    
    func errorMessageForLAErrorCode(errorCode: Int) -> String{
        var message = ""
        switch errorCode { //self.delegate.
        case LAError.authenticationFailed.rawValue:
            if self.delegate.ArryLngResponSystm != nil {
                message = (self.delegate.ArryLngResponSystm!["problem_verifying_identity"] as? String)!
            }else {
                message = "There was a problem verifying your identity."
            }
        case LAError.userCancel.rawValue:
            if self.delegate.ArryLngResponSystm != nil {
                message = (self.delegate.ArryLngResponSystm!["authenticatn_canceled_user﻿"] as? String)!
            }else {
                message = "Authentication was canceled by user."
            }
        case LAError.userFallback.rawValue:
            if self.delegate.ArryLngResponSystm != nil {
                message = (self.delegate.ArryLngResponSystm!["user_tapped_Homebutton﻿"] as? String)!
            }else {
                message = "The user tapped the Home button."
            }
        case LAError.systemCancel.rawValue:
            if self.delegate.ArryLngResponSystm != nil {
                message = (self.delegate.ArryLngResponSystm!["authentictn_cancel_system"] as? String)!
            }else {
                message = "Authentication was canceled by system."
            }
        case LAError.passcodeNotSet.rawValue:
            if self.delegate.ArryLngResponSystm != nil {
                message = (self.delegate.ArryLngResponSystm!["passcod_not_device﻿"] as? String)!
            }else {
                message = "Passcode is not set on the device."
            }
        case LAError.touchIDNotAvailable.rawValue:
            var msgInfo = ""
            if DeviceType.IS_IPHONE_x {
                if self.delegate.ArryLngResponSystm != nil {
                    msgInfo = (self.delegate.ArryLngResponSystm!["face_notAvailable_device"] as? String)!
                }else {
                    msgInfo = "Face ID is not available on the device."
                }
            }else {
                if self.delegate.ArryLngResponSystm != nil {
                    msgInfo = (self.delegate.ArryLngResponSystm!["touchid_notAvailable"] as? String)!
                }else {
                    msgInfo = "Touch ID is not available on the device."
                }
            }
            message = msgInfo
        case LAError.touchIDNotEnrolled.rawValue:
            if self.delegate.ArryLngResponSystm != nil {
                message = (self.delegate.ArryLngResponSystm!["touch_notenrolled_fingers﻿"] as? String)!
            }else {
                message = "Touch ID has no enrolled fingers."
            }
        case LAError.touchIDLockout.rawValue:
            var msgInfo = ""
            if DeviceType.IS_IPHONE_x {
                if self.delegate.ArryLngResponSystm != nil {
                    msgInfo = (self.delegate.ArryLngResponSystm!["failedFaceId_attempts"] as? String)!
                }else {
                    msgInfo = "There were too many failed Face ID attempts and Face ID is now locked."
                }
            }else {
                if self.delegate.ArryLngResponSystm != nil {
                    msgInfo = (self.delegate.ArryLngResponSystm!["failedTouchId_attempts﻿"] as? String)!
                }else {
                    msgInfo = "There were too many failed Touch ID attempts and Touch ID is now locked."
                }
            }
            message = msgInfo
        case LAError.appCancel.rawValue:
            if self.delegate.ArryLngResponSystm != nil {
                message = (self.delegate.ArryLngResponSystm!["Authentictn_canceled_app﻿"] as? String)!
            }else {
                message = "Authentication was canceled by application."
            }
        case LAError.invalidContext.rawValue:
            message = "LAContext passed to this call has been previously invalidated."
        default:
            var msgInfo = ""
            if DeviceType.IS_IPHONE_x {
                if self.delegate.ArryLngResponSystm != nil {
                    msgInfo = (self.delegate.ArryLngResponSystm!["faceid_notConfigured﻿"] as? String)!
                }else {
                    msgInfo = "Face ID may not be configured"
                }
            }else {
                if self.delegate.ArryLngResponSystm != nil {
                    msgInfo = (self.delegate.ArryLngResponSystm!["touchid_notConfigured"] as? String)!
                }else {
                    msgInfo = "Touch ID may not be configured"
                }
            }
            message = msgInfo
            break
        }
        return message
    }
    
    func navigateAuthentictionVC() {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        DispatchQueue.main.async{
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
    }
    
    func showAlertViewForNoBioMatric(){
        var msgInfo = ""
        if DeviceType.IS_IPHONE_x {
            if self.delegate.ArryLngResponSystm != nil {
                msgInfo = (self.delegate.ArryLngResponSystm!["faceid_notenable"] as? String)!
            }else {
                msgInfo = "You have not enable Face ID access for this device.Please check with settings to enable."
            }
        }else {
            if self.delegate.ArryLngResponSystm != nil {
                msgInfo = (self.delegate.ArryLngResponSystm!["touchid_notenable"] as? String)!
            }else {
                msgInfo = "You have not enable Fingerprint access for this device.Please check with settings to enable"
            }
        }
        showAlertWithTitle(title: "Sorry!", message: msgInfo)
    }
    
    func showAlertWithTitle(title: String , message : String){
                
        let alrtTitleStr = NSMutableAttributedString(string: title)
        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
        
        let alrtMessage = NSMutableAttributedString(string: message)
        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:14.0) , range: NSRange(location: 0, length: alrtMessage.length))
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
        alertController.setValue(alrtMessage, forKey: "attributedMessage")
      
        let btnOK = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            /*DispatchQueue.main.async{
                UserDefaults.standard.set("2", forKey: "EnableFingerPrint")
                UserDefaults.standard.synchronize()
                userInfo.userId = UserDefaults.standard.string(forKey: "app_user_id")!
                userInfo.userPrivateKey = UserDefaults.standard.string(forKey: "private_key")!
                
                print("userInfo.userId ",userInfo.userId  )
                print("userInfo.userPrivateKey ", userInfo.userPrivateKey)
                self.navigationController?.navigationBar.isHidden = false
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                if self.JSONResponse.keys.contains("TagNames"){
                    vc.ffTagFlag = (self.JSONResponse["TagNames"] as? String)!
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }*/
        })
        
        alertController.addAction(btnOK)
       
        DispatchQueue.main.async{
            self.present(alertController,animated: true,completion: nil)
        }
    }
    
    func logOut(){
        DispatchQueue.main.async{
            //UserDefaults.standard.set("2", forKey: "EnableFingerPrint")
            UserDefaults.standard.set("3", forKey: "EnableFingerPrint") //When you logout from system
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers
            for aViewController in viewControllers {
                if aViewController is Login {
                    //isVCFound = true
                    self.navigationController!.popToViewController(aViewController, animated: true)
                }
            }
        }
    }
    
   /* func checkIfTouchIDEnabled() {
        let authentictionCheck = LAContext()
        var error:NSError?
        guard authentictionCheck.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            if let error = error as NSError? {
                if error.code == LAError.Code.touchIDNotAvailable.rawValue {
                    print("Finger print sensors are not present in this device")
                    checkFingerPrint = false
                } else if error.code == LAError.Code.touchIDNotEnrolled.rawValue {
                    checkFingerPrint = true
                    print("Finger print sensors are present in this device but no TouchID has been enrolled yet")
                }else {
                    checkFingerPrint = true
                }
            }
            return
        }
    }*/
}
   
