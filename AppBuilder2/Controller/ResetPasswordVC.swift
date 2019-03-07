//
//  ResetPasswordVC.swift
//  AppBuilder2
//
//  Created by Aditya on 21/05/18.
//  Copyright © 2018 VISHAL. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet weak var lblTredmark: UILabel!
    @IBOutlet weak var btnResetPassword: UIButton!
    @IBOutlet weak var txtConfimPass: UITextField!
    @IBOutlet weak var lblConfirmPass: UILabel!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var lblNewPassword: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    
    var appDelegate : AppDelegate!
    var chache:NSCache<AnyObject, AnyObject>!
    var flgActivity = true
    var timeOut: Timer!
    var apiSuccesFlag = ""
    var btnBack:UIButton!
    var getJsonData: [String:Any]?
    var commonElement = [String:Any]()
    
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

    override func viewWillAppear(_ animated: Bool) {
        setBackBtn()
        getUIForAccountRecovery()
        self.title = "Reset New Password"
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func btnResetPasswordClk(_ sender: Any) {
        if validation.checkNotNullParameter(checkStr: txtNewPassword.text!){
            self.view.makeToast("Please enter new password.")
        }else if validation.checkNotNullParameter(checkStr: txtConfimPass.text!){
            self.view.makeToast("Please enter confirm password.")
        }else if txtNewPassword.text != txtConfimPass.text{
            self.view.makeToast("Password does not match")
        }else {
            resetPassword()
        }
        
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
                }
            }
        } else {
            self.view.makeToast(string.noInternateMessage2)
        }
    }
}

//MARK: Ws_Parsing
extension ResetPasswordVC {
    // MARK: - WS_Reset_Password
    func resetPassword(){
        
        // http://27.109.19.234/app_builder/index.php/api/changePassword?appId=1&userId=36&newPassword=tester
        var langID = ""
        if UserDefaults.standard.string(forKey: "strlanguageID") != nil {
            langID = UserDefaults.standard.string(forKey: "strlanguageID")!
        }else {
            langID = "1"
        }
        
        let dictionary = ["appId" : userInfo.appId,
                          "userId" : userInfo.userId,
                          "newPassword" : self.txtConfimPass.text!,
                          "languageId" : langID]
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "changePassword?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.callWSOfResetPassword(strURL: strURL, dictionary: dictionary )
        }else {
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOfResetPassword(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            self.stopActivityIndicator()
            print("JSONResponse ResetPass : ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPassSuccessVC") as! ResetPassSuccessVC
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
