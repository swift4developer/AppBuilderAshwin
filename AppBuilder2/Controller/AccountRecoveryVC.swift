//
//  AccountRecoveryVC.swift
//  AppBuilder2
//
//  Created by Aditya on 21/05/18.
//  Copyright © 2018 VISHAL. All rights reserved.
//

import UIKit
import MessageUI
import Foundation

class AccountRecoveryVC: UIViewController,NVActivityIndicatorViewable,MFMailComposeViewControllerDelegate {

    var appDelegate : AppDelegate!
    var chache:NSCache<AnyObject, AnyObject>!
    var flgActivity = true
    var timeOut: Timer!
    var apiSuccesFlag = ""
    var btnBack:UIButton!
    var getJsonData: [String:Any]?
    var commonElement = [String:Any]()
    var emailForHelp = ""
    
    @IBOutlet weak var lblTredmark: UILabel!
    @IBOutlet var lblInfo: [UILabel]!
    @IBOutlet weak var lblLostPassword: UILabel!
    @IBOutlet weak var btnContactUs: UIButton!
    @IBOutlet weak var lblEmailAddress: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.shared.delegate as! AppDelegate
        getJsonData =  appDelegate.jsonData
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
    
    @IBAction func btnContactUsClk(_ sender: Any) {
        self.sendEmail()
    }
    
    @IBAction func btnSubmitClk(_ sender: Any) {
        if validation.checkNotNullParameter(checkStr: txtEmail.text!){
            self.view.makeToast("Please enter email address.")
        }else if validation.isValidEmail(testEmail: (txtEmail.text?.trimmingCharacters(in: .whitespaces))!){
            self.view.makeToast("Please enter valid email address.")
        }else {
            self.callWS()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        setBackBtn()
        getUIForAccountRecovery()
        self.title = "Account Recovery"
        self.navigationController?.navigationBar.isHidden = false
    }

    func setBackBtn() {
        //setNaviBackButton()
        let origImage = UIImage(named: "back");
        btnBack = UIButton(frame: CGRect(x: 0, y:0, width:28,height: 34))
        //btnBack.translatesAutoresizingMaskIntoConstraints = false;
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
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getUIForAccountRecovery() {
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
                    
                    self.btnBack.tintColor = UIColor().HexToColor(hexString: menu_icon_color!)
                    
                    commonElement = common_element
                    
                    if let appGenralSettng = data["app_general_settings"] as? [String:Any] {
                        self.emailForHelp = (appGenralSettng["email_us_for_help"] as? String)!
                    }
                    
                }
            }
        } else {
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    //MARK:- Email send
    func sendEmail() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([self.emailForHelp])
        //mailComposerVC.setSubject("Sending you an in-app e-mail...")
        //mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        
        let alrtTitleStr = NSMutableAttributedString(string: "Could Not Send Email")
        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
        
        let alrtMessage = NSMutableAttributedString(string: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
        alertController.setValue(alrtMessage, forKey: "attributedMessage")
        
        //let alertController = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        let btnOK = UIAlertAction(title: "OK", style: .default, handler: { action in
        })
        alertController.addAction(btnOK)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
//MARK: Ws_Parsing
extension AccountRecoveryVC {
    //MARK:- WS Calling
    func callWS(){
        //URL: http://103.51.153.235/app_builder/index.php/api/forgetPassword?appId=1&email=shardul%40gmail.com
        
        var langID = ""
        if UserDefaults.standard.string(forKey: "strlanguageID") != nil {
            langID = UserDefaults.standard.string(forKey: "strlanguageID")!
        }else {
            langID = "1"
        }
        
        let dictionary = ["appId" : userInfo.appId,
                          "email":self.txtEmail.text!,
                          "languageId" : langID] as [String : Any]
        
        print("I/P forgetPassword: ",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "forgetPassword?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            self.startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSOfAccoutRecovery(strURL: strURL, dictionary: dictionary as! Dictionary<String, String>)
        }else{
            stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOfAccoutRecovery(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            self.stopActivityIndicator()
            print("JSONResponse forgetPassword : ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                 let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountRecoverySuccessVC") as! AccountRecoverySuccessVC
                self.navigationController?.pushViewController(nextVC, animated: true)
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
        })
    }
}

