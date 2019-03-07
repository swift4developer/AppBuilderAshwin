//
//  MyProfile.swift
//  AppBuilder2
//
//  Created by VISHAL on 28/03/18.
//  Copyright © 2018 VISHAL. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import Photos

class MyProfile: UIViewController,NVActivityIndicatorViewable,UIScrollViewDelegate {

   
    var btnMenu:UIButton!
    var btnBack:UIButton!
    var appDelegate : AppDelegate!
    var chache:NSCache<AnyObject, AnyObject>!
    var flgActivity = true
    var timeOut: Timer!
    var apiSuccesFlag = ""
    var apiLoginSuccesFlag = ""
    var arryProfileData = [String:Any]()
    var noDataView = UIView()
    var publicFBSwitch = ""
    var publicSkypeSwitch = ""
    var oldFBSwitch = ""
    var oldSkypeSwitch = ""
    var fbOldTxt = ""
    
    @IBOutlet weak var viewOfSocialMedia: UIView!
    @IBOutlet weak var heightOfSocialMedia: NSLayoutConstraint!
    @IBOutlet weak var heightOfSkypeView: NSLayoutConstraint!
    @IBOutlet weak var heightOfFbView: NSLayoutConstraint!
    @IBOutlet weak var btnUpdateHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingOfSelectProfilePic: NSLayoutConstraint!
    @IBOutlet weak var profileImgLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var viewOfPhoto: UIView!
    @IBOutlet weak var viewOfName: UIView!
    @IBOutlet weak var viewOfEmail: UIView!
    @IBOutlet weak var viewOfCellPhone: UIView!
    @IBOutlet weak var viewOfPass: UIView!
    @IBOutlet weak var viewOfAboutMe: UIView!
    @IBOutlet weak var viewOfFB: UIView!
    @IBOutlet weak var viewOfSkype: UIView!
    @IBOutlet weak var textOfSkypeName: UITextField!
    @IBOutlet weak var textOfFacebookName: UITextField!
    
    @IBOutlet weak var lblOfCustomzAccnt: UILabel!
    @IBOutlet weak var lblOfPhoto: UILabel!
    @IBOutlet weak var imgOfProfile: UIImageView!
    @IBOutlet weak var btnSelectPhoto: UIButton!
    
    @IBOutlet weak var lblNameTitle: UILabel!
    @IBOutlet weak var textTitleName: UITextField!
    
    @IBOutlet weak var lblOfEmailTitle: UILabel!
    @IBOutlet weak var txtOfEmail: UITextField!
    @IBOutlet weak var lblOfEmailStatus: UILabel!
    
    @IBOutlet weak var lblCellTitle: UILabel!
    @IBOutlet weak var textOfCell: UITextField!
    @IBOutlet weak var lblOfCellStatus: UILabel!
    @IBOutlet weak var btnResendLink: UIButton!
    
    @IBOutlet weak var lblPassTitle: UILabel!
    @IBOutlet weak var textOfPass: UITextField!
    @IBOutlet weak var btnChangePass: UIButton!
    @IBOutlet weak var btnSeePass: UIButton!
    
    @IBOutlet weak var lblAboutMeTitle: UILabel!
    @IBOutlet weak var textViewOfAbotMe: UITextView!
    
    @IBOutlet weak var lblOfSocailMedaiTitle: UILabel!
    @IBOutlet weak var btnShowPublicaly: UIButton!
    
    @IBOutlet weak var lblFbTitle: UILabel!
   // @IBOutlet weak var lblOfFbStatus: UILabel!
    @IBOutlet weak var SwitchOfFb: UISwitch!
    
    @IBOutlet weak var lblSkypeTitle: UILabel!
    @IBOutlet weak var SwitchOfSkype: UISwitch!
    
    @IBOutlet weak var btnQuestionMark: UIButton!
    
    @IBOutlet weak var heightOfBottomSocialView: NSLayoutConstraint!
    @IBOutlet weak var heightOfAbutMeView: NSLayoutConstraint!
    var getJsonData: [String:Any]?
    
    let picker = UIImagePickerController()
    var flag = true
    var updateFlag = false
    var name = ""
    var phone = ""
    var email = ""
    var strPass = ""
    var facebookName = ""
    var skypeName = ""
    var typeOfSocial = ""
    var flagOfSocial = ""
    
    //Social : FB Skype TextField flag
    var fbTxtFlag = ""
    var skypeTxtFlag = ""
    var skVisibleFlag = ""
    var fbVisibleFlag = ""
    var fblinkValidate = ""
    var fblinkValidateFlag = ""
    var flgForFbTxt = ""
    
    // CellPhone
    var phoneNo = ""
    var nationalNo = ""
    
    var fbflag = ""
    var skypflag = ""
    var flgForCellPhnUpdate : Bool!
    var oldCellPhnValue = ""
    var flagForSkypeFbSwitch = "" //for change in switch value
    
    //MARK:- ViwDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chache = NSCache()
        
        textOfCell.keyboardType = .phonePad
        
        flgForCellPhnUpdate = false
        
        self.textOfFacebookName.text = "https://www.facebook.com/"
        self.fblinkValidateFlag = "0"
        
        
        picker.delegate = self
        
        self.textTitleName.text = ""
        self.txtOfEmail.text = ""
        self.textOfCell.text = ""
        self.textOfPass.text = ""
        self.txtOfEmail.text = ""
        self.textOfCell.text = ""
        self.textOfSkypeName.text = ""
      
        self.lblOfEmailStatus.isHidden = true
        self.lblOfCellStatus.isHidden = true
        self.btnChangePass.isHidden = false
        self.btnResendLink.isHidden = true
        self.lblAboutMeTitle.isHidden = true
        self.textViewOfAbotMe.isHidden = true
        
        if updateFlag {
            btnUpdate.isHidden = false
            btnUpdateHeightConstraint.constant = 45
        }else {
            btnUpdate.isHidden = true
            btnUpdateHeightConstraint.constant = 0
        }
        
        setBackBtn()
        setNavigationBtn()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        getJsonData =  appDelegate.jsonData
        
        let str = (appDelegate.ArryLngResponeCustom!["my_profile"] as? String)!//"My Profile"
        if str.count > 28{
            let startIndex = str.index(str.startIndex, offsetBy: 28)
            self.title = String(str[..<startIndex] + "..")
        }else {
            self.title = (appDelegate.ArryLngResponeCustom!["my_profile"] as? String)!//"My Profile"
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font: checkForFontType(fontStyle: "1", fontSize: CGFloat(18))]
        
        self.navigationController?.navigationBar.barTintColor = UIColor().HexToColor(hexString: appDelegate.strStatusColor)
        self.navigationController?.navigationBar.backgroundColor = UIColor().HexToColor(hexString: appDelegate.strStatusColor)
        
        self.btnMenu.tintColor =  UIColor.white
        self.btnBack.tintColor =  UIColor.white
        
        self.txtOfEmail.isUserInteractionEnabled = false
        self.textOfPass.isUserInteractionEnabled = false
        
        //constraint for iphone5 or less
   }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.getUIOfMyProfile()
        
        self.txtOfEmail.isUserInteractionEnabled = false
        self.textOfPass.isUserInteractionEnabled = false
        
        if flag {
            self.callWSOfProfile()
         }
        
        if updateFlag {
            btnUpdate.isHidden = false
            btnUpdateHeightConstraint.constant = 45
        }else {
            btnUpdate.isHidden = true
            btnUpdateHeightConstraint.constant = 0
        }
        
        lanuageConversion()
        
      }
    
    func setBackBtn() {
        //setNaviBackButton()
        let origImage = UIImage(named: "back");
        btnBack = UIButton(frame: CGRect(x: 0, y:0, width:28,height: 34))
        //        btnBack.alignmentRectInsets.left = -10
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
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
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
            if apiLoginSuccesFlag == "1"{
                self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.oppsMsg, lableNoInternate: string.noDataFoundMsg)
                self.view.addSubview(self.noDataView)
            }
        }
    }
    
    
    //MARK:- Langauge Conversion
    func lanuageConversion(){
        
        self.lblOfCustomzAccnt.text = (appDelegate.ArryLngResponeCustom!["customize_account"] as? String)!
        //"Customize Account"
        self.lblOfPhoto.text = (appDelegate.ArryLngResponeCustom!["photo"] as? String)!
        //"Photo"
        self.lblNameTitle.text = (appDelegate.ArryLngResponeCustom!["name"] as? String)!
        //"Name"
        self.textTitleName.placeholder = (appDelegate.ArryLngResponeCustom!["enter_name"] as? String)!
        //"Enter Name"
        self.lblOfEmailTitle.text = (appDelegate.ArryLngResponeCustom!["email"] as? String)!
        //"Email"
        self.txtOfEmail.placeholder = (appDelegate.ArryLngResponeCustom!["enter_email"] as? String)!
        //"Enter email"
        self.lblCellTitle.text = (appDelegate.ArryLngResponeCustom!["cell_phone"] as? String)!
        //"Cell Phone"
        self.textOfCell.placeholder = (appDelegate.ArryLngResponeCustom!["enter_cell_phone"] as? String)!
        //Cell phone text filed
        self.lblPassTitle.text = (appDelegate.ArryLngResponeCustom!["password"] as? String)!
        //"Password"
        self.lblAboutMeTitle.text = (appDelegate.ArryLngResponeCustom!["about_me"] as? String)!
        //"About Me"
        self.lblOfSocailMedaiTitle.text = (appDelegate.ArryLngResponeCustom!["social_media_accounts"] as? String)!
        //"Social Media Accounts"
        self.btnShowPublicaly.setTitle((appDelegate.ArryLngResponeCustom!["show_publicly"] as? String)!, for: .normal)
        //"Show Publicly"
        self.lblFbTitle.text = (appDelegate.ArryLngResponeCustom!["facebook"] as? String)!
        //"Facebook"
        self.textOfFacebookName.placeholder = (appDelegate.ArryLngResponeCustom!["enter_facebook_name"] as? String)!//"Enter Facebook Name"
        self.lblSkypeTitle.text = (appDelegate.ArryLngResponeCustom!["skype"] as? String)!
        //"Skype"
        self.textOfSkypeName.placeholder = (appDelegate.ArryLngResponeCustom!["enter_skype_name"] as? String)!
        //"Enter Skype Name"
        self.btnUpdate.setTitle((appDelegate.ArryLngResponeCustom!["update"] as? String)!, for: .normal)
        //"Update"
        
    }
    
    func getUIOfMyProfile(){
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
                    let genrltxtColor = general_font["txtcolorHex"] as! String
                    let bgScreenColor = genarlSettings["screen_bg_color"] as! String
                    
                    self.view.backgroundColor = UIColor().HexToColor(hexString: bgScreenColor)
                    //"general_fontsize"
                    
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
                    
                    let genrlFontSize = genarlSettings["general_fontsize"] as! [String:String]
                    let small = genrlFontSize["small"]
                    var smallInt:Int = Int(small!)!
                    let medium = genrlFontSize["medium"]
                    var mediumInt:Int = Int(medium!)!
                    
                    if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5{
                        mediumInt = mediumInt - 3
                        smallInt = smallInt - 3
                    }
                    
                    let attrs1 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize:  CGFloat(smallInt - 2)), NSAttributedStringKey.foregroundColor : UIColor().HexToColor(hexString: genrltxtColor)]
                    let attributedString1 = NSMutableAttributedString(string:"status:", attributes:attrs1)
                    
                    let attrConfimred = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: CGFloat(smallInt - 2)), NSAttributedStringKey.foregroundColor : UIColor().HexToColor(hexString: "#63DA38")]
                    let attributedString2 = NSMutableAttributedString(string:" confirmed", attributes:attrConfimred)
                    attributedString1.append(attributedString2)
                    //self.lblOfFbStatus.attributedText = attributedString1
                    self.lblOfEmailStatus.attributedText = attributedString1
                    
                    
                    let attrs = [NSAttributedStringKey.font : UIFont.systemFont(ofSize:  CGFloat(smallInt - 2)), NSAttributedStringKey.foregroundColor : UIColor().HexToColor(hexString: genrltxtColor)]
                    let attributedString = NSMutableAttributedString(string:"status:", attributes:attrs)
                    let attrPending = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: CGFloat(smallInt - 2)), NSAttributedStringKey.foregroundColor : UIColor().HexToColor(hexString: "#FF3B30")]
                    let attributedPending2 = NSMutableAttributedString(string:"pending", attributes:attrPending)
                    attributedString.append(attributedPending2)
                    self.lblOfCellStatus.attributedText = attributedString
                    
                    //btnUpdate.setBackgroundImage(tintImg, for: .normal)
                    btnUpdate.tintColor = UIColor().HexToColor(hexString: bgcolor!)
                    btnUpdate.setTitleColor(UIColor().HexToColor(hexString: txtcolorHex!), for: .normal)
                    btnUpdate.titleLabel?.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 3))
                    btnUpdate.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(mediumInt + 3))
                    btnUpdate.backgroundColor = UIColor().HexToColor(hexString: bgcolor!)
                    
                    lblOfCustomzAccnt.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 3))
                    lblOfCustomzAccnt.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    lblOfCustomzAccnt.font = UIFont.boldSystemFont(ofSize: CGFloat(mediumInt + 3))
                    
                    lblOfPhoto.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 3))
                    lblOfPhoto.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    
                    let attrsSelect = [
                        NSAttributedStringKey.font : checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(smallInt)),
                        NSAttributedStringKey.foregroundColor : UIColor().HexToColor(hexString: genrltxtColor),
                        NSAttributedStringKey.underlineStyle : 1] as [NSAttributedStringKey : Any] as [NSAttributedStringKey : Any]
                    let attributedStringSelect = NSMutableAttributedString(string:"")
                    let buttonTitleStr = NSMutableAttributedString(string:(appDelegate.ArryLngResponeCustom!["select_profile_photo"] as? String)!, attributes:attrsSelect)
                    attributedStringSelect.append(buttonTitleStr)
                    btnSelectPhoto.setAttributedTitle(attributedStringSelect, for: .normal)
                    
                    let attrsChange = [
                        NSAttributedStringKey.font : checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(smallInt)),
                        NSAttributedStringKey.foregroundColor : UIColor().HexToColor(hexString: genrltxtColor),
                        NSAttributedStringKey.underlineStyle : 1] as [NSAttributedStringKey : Any] as [NSAttributedStringKey : Any]
                    let attributedStringChange = NSMutableAttributedString(string:"")
                    let buttonTitleStr1 = NSMutableAttributedString(string:(appDelegate.ArryLngResponeCustom!["change_password"] as? String)!, attributes:attrsChange)
                    attributedStringChange.append(buttonTitleStr1)
                    btnChangePass.setAttributedTitle(attributedStringChange, for: .normal)
                   
                    //btnSelectPhoto.setTitleColor(UIColor().HexToColor(hexString: genrltxtColor), for: .normal)
                    //btnSelectPhoto.titleLabel?.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 1))
                    
                    lblNameTitle.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 3))
                    lblNameTitle.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    textTitleName.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 1))
                    textTitleName.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    
                    lblOfEmailTitle.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 3))
                    lblOfEmailTitle.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    txtOfEmail.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 1))
                    txtOfEmail.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    
                    //lblPassTitle.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 1))
                    lblPassTitle.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 3))
                    lblPassTitle.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    
                    lblCellTitle.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 3))
                    lblCellTitle.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    
                    textOfCell.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 1))
                    textOfCell.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    btnResendLink.setTitleColor(UIColor().HexToColor(hexString: genrltxtColor), for: .normal)
                    btnResendLink.titleLabel?.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 1))
                    
                    lblAboutMeTitle.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 3))
                    lblAboutMeTitle.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    textViewOfAbotMe.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 3))
                    textViewOfAbotMe.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    
                    lblOfSocailMedaiTitle.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 3))
                    lblOfSocailMedaiTitle.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    lblOfSocailMedaiTitle.font = UIFont.boldSystemFont(ofSize: CGFloat(mediumInt + 3))
                    
                    btnShowPublicaly.setTitleColor(UIColor().HexToColor(hexString: genrltxtColor), for: .normal)
                    btnShowPublicaly.titleLabel?.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt - 2))
                    
                    lblFbTitle.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 3 ))
                    lblFbTitle.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    textOfFacebookName.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 1))
                    textOfFacebookName.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    
                    
                    lblSkypeTitle.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 3))
                    lblSkypeTitle.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    textOfSkypeName.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 1))
                    textOfSkypeName.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                 
                    
                    if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5{
                        
                        lblOfPhoto.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(15))
                        lblNameTitle.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(15))
                        lblOfEmailTitle.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(15))
                        lblCellTitle.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(15))
                        lblPassTitle.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(15))
                        lblFbTitle.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(15))
                        lblSkypeTitle.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(15))
                        
                        profileImgLeadingConstraint.constant = 40
                        leadingOfSelectProfilePic.constant = 5
                    }
                }
            }
        } else {
            self.view.makeToast(string.noInternateMessage2)
        }
    }
  
    //MARK:- BUTTON CLICK EVENT
    
    @IBAction func btnUpdateClk(_ sender: Any) {
        if textTitleName.text == "" {
            self.view.makeToast((appDelegate.ArryLngResponSystm!["enter_name_msg"] as? String)!)
        }
        else if fbVisibleFlag == "1" {  //textOfFacebookName.text == ""
         
                if  textOfFacebookName.text! == "https://www.facebook.com/" {
                    if SwitchOfFb.isOn && fbVisibleFlag == "1" {
                        self.view.makeToast((appDelegate.ArryLngResponSystm!["enter_fb_name_msg"] as? String)!)
                    }
                    else {
                        if checkSpace(str: textOfSkypeName.text!) ||  textOfSkypeName.text! == "" {
                            if SwitchOfSkype.isOn && skVisibleFlag == "1" {
                                self.view.makeToast((appDelegate.ArryLngResponSystm!["enter_skype_name_msg"] as? String)!)
                            }
                            else {
                                if self.textOfCell.text?.count != 0{
                                    callWSOfValidCellNo()
                                }else {
                                    updateProfileImage()
                                }
                            }
                        }
                        else {
                            if self.textOfCell.text?.count != 0{
                                callWSOfValidCellNo()
                            }else {
                                updateProfileImage()
                            }
                        }
                    }
                }
                else if checkSpace(str: textOfSkypeName.text!) ||  textOfSkypeName.text! == "" {
                    if SwitchOfSkype.isOn && skypeTxtFlag == "1" {
                        self.view.makeToast((appDelegate.ArryLngResponSystm!["enter_skype_name_msg"] as? String)!)
                    }
                    else {
                        if self.textOfCell.text?.count != 0{
                            callWSOfValidCellNo()
                        }else {
                            updateProfileImage()
                        }
                    }
                }else {
                    if self.textOfCell.text?.count != 0{
                        callWSOfValidCellNo()
                    }else {
                        updateProfileImage()
                }
            }
        }
        else if skVisibleFlag == "1" {  //textOfFacebookName.text == ""
            
                if checkSpace(str: textOfSkypeName.text!) ||  textOfSkypeName.text! == "" {
                    if SwitchOfSkype.isOn && skVisibleFlag == "1" {
                        self.view.makeToast((appDelegate.ArryLngResponSystm!["enter_skype_name_msg"] as? String)!)
                    }
                    else {
                        if self.textOfCell.text?.count != 0{
                            callWSOfValidCellNo()
                        }else {
                            updateProfileImage()
                        }
                    }
                }else {
                    if self.textOfCell.text?.count != 0{
                        callWSOfValidCellNo()
                    }else {
                        updateProfileImage()
                    }
                }
          }
         else {
            if self.textOfCell.text?.count != 0{
                callWSOfValidCellNo()
            }else {
                updateProfileImage()
            }
        }
    }
    
    @IBAction func btnQuestionMarkClick(_ sender: Any) {
        if self.appDelegate.helpData.count > 0 && UserDefaults.standard.bool(forKey: "helpData"){
            UserDefaults.standard.set("1", forKey: "ArticleVideoFlag")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogPostViewController") as! BlogPostViewController
            print("AppDelegate ",self.appDelegate.helpData)
            vc.dicMediaData = self.appDelegate.helpData
            vc.flgToShow = "Help"
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            self.view.makeToast((appDelegate.ArryLngResponSystm!["no_help_article_msg"] as? String)!)
        }
        
    }
   
    @IBAction func btnSelectProfileClk(_ sender: Any) {
        alertCameraGallary()
    }
    
    @IBAction func btnResendConfirmationClk(_ sender: Any) {
    }
    
    @IBAction func btnShowPassword(_ sender: Any) {
        if btnSeePass.currentBackgroundImage == UIImage(named: "visibility") {
            textOfPass.isSecureTextEntry = false
            btnSeePass.setBackgroundImage(UIImage(named: "visibility_off"), for: .normal)
        }
        else{
            textOfPass.isSecureTextEntry = true
            btnSeePass.setBackgroundImage(UIImage(named: "visibility"), for: .normal)
        }
    }
    
    @IBAction func btnChangePassword(_ sender: Any) {
        
        let alrtTitleStr = NSMutableAttributedString(string: (appDelegate.ArryLngResponeCustom!["change_password"] as? String)!)
        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
        
        //let alertController = UIAlertController(title: "Change Password", message: nil, preferredStyle: .alert)

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = (self.appDelegate.ArryLngResponeCustom!["new_password"] as? String)!
            textField.borderStyle = UITextBorderStyle.roundedRect
            textField.isSecureTextEntry = true
            textField.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = (self.appDelegate.ArryLngResponeCustom!["confirm_password"] as? String)!
            textField.borderStyle = UITextBorderStyle.roundedRect
            textField.isSecureTextEntry = true
//            textField.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        }
        let saveAction = UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["update"] as? String)!, style: .default, handler: { alert -> Void in
            
//            alertController.actions[0].isEnabled = false
            alertController.actions[1].isEnabled = false
            
            let newPassword = alertController.textFields![0] as UITextField
            let confirmPassword = alertController.textFields![1] as UITextField
            
            if newPassword.text == "" || confirmPassword.text == "" {
                self.view.makeToast((self.appDelegate.ArryLngResponSystm!["enter_new_pass_msg"] as? String)!)
            }
            else if (newPassword.text?.count)! < 6 && (confirmPassword.text?.count)! < 6 {
                self.view.makeToast((self.appDelegate.ArryLngResponSystm!["enter_valid_password_msg"] as? String)!)
            }
            else if newPassword.text! != confirmPassword.text! {
                self.view.makeToast((self.appDelegate.ArryLngResponSystm!["pass_not_match_msg"] as? String)!)
            }
            else {
                self.strPass = newPassword.text!
                self.changePassword(strNewPass: self.strPass)
            }
        })
        
        let cancelAction = UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["cancel"] as? String)!, style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        for textfield: UIView in alertController.textFields! {
            let container: UIView = textfield.superview!
            let effectView: UIView = container.superview!.subviews[0]
            container.backgroundColor = UIColor.clear
            effectView.removeFromSuperview()
        }
    }
    
    @objc func textChanged(_ sender: Any) {
        let tf = sender as! UITextField
        var resp : UIResponder! = tf
        while !(resp is UIAlertController) { resp = resp.next }
        let alert = resp as! UIAlertController
        alert.actions[1].isEnabled = (tf.text != "")
    }
    
    @IBAction func btnSwitchFBClk(_ sender: Any) {
        if self.publicFBSwitch == "1" {
            self.publicFBSwitch = "0"
            SwitchOfFb.setOn(false, animated: true)
        }else {
            self.publicFBSwitch = "1"
            SwitchOfFb.setOn(true, animated: true)
        }
        
        if oldFBSwitch == self.publicFBSwitch && oldSkypeSwitch == self.publicSkypeSwitch {
            
            if textOfFacebookName.text! == self.facebookName  && textOfSkypeName.text!  == self.skypeName  {
                btnUpdate.isHidden = true
                self.btnUpdateHeightConstraint.constant = 0
            }
            else {
                btnUpdate.isHidden = false
                self.btnUpdateHeightConstraint.constant = 45
            }
            
        }else {
            btnUpdate.isHidden = false
            self.btnUpdateHeightConstraint.constant = 45
        }
}
        
        
//        flagForSkypeFbSwitch = "1"
//        typeOfSocial = "1"
//
//        if SwitchOfFb.isOn {
//            fbflag = "1"
//            SwitchOfFb.setOn(true, animated: false)
//            //UserDefaults.standard.set("1", forKey: "fbTxtFlagGlobal")
//
//            if btnUpdate.isHidden {
//                btnUpdate.isHidden = false
//                self.btnUpdateHeightConstraint.constant = 45
//            }else {
//                btnUpdate.isHidden = true
//                self.btnUpdateHeightConstraint.constant = 0
//            }
//        }
//        else {
//            fbflag = "0"
//            SwitchOfFb.setOn(false, animated: false)
//
//            if btnUpdate.isHidden {
//                btnUpdate.isHidden = false
//                self.btnUpdateHeightConstraint.constant = 45
//            }
//        }

    @IBAction func btnSwitchSkypeClk(_ sender: Any) {
        
        
        if self.publicSkypeSwitch == "1" {
            self.publicSkypeSwitch = "0"
            SwitchOfSkype.setOn(false, animated: true)
        }else {
            self.publicSkypeSwitch = "1"
            SwitchOfSkype.setOn(true, animated: true)
        }
        
        if oldFBSwitch == self.publicFBSwitch && oldSkypeSwitch == self.publicSkypeSwitch {
          if textOfFacebookName.text! == self.facebookName  && textOfSkypeName.text!  == self.skypeName  {
            btnUpdate.isHidden = true
            self.btnUpdateHeightConstraint.constant = 0
            }
          else {
            btnUpdate.isHidden = false
            self.btnUpdateHeightConstraint.constant = 45
            }
        }else {
            btnUpdate.isHidden = false
            self.btnUpdateHeightConstraint.constant = 45
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
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


//MARK:- UITextFieldDelegate
extension MyProfile : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textTitleName || textField == textOfCell || textField == textOfFacebookName || textField == textOfSkypeName {
            if textTitleName.text! == self.name && textOfCell.text! == self.phone && textOfFacebookName.text! == self.facebookName && textOfSkypeName.text!  == self.skypeName {
                DispatchQueue.main.async(execute: {
                    self.btnUpdate.isHidden = true
                    self.btnUpdateHeightConstraint.constant = 0
                })
            }else {
                DispatchQueue.main.async(execute: {
                    self.btnUpdate.isHidden = false
                    self.btnUpdateHeightConstraint.constant = 45
                })
            }
        }
     }
    
    //|| textOfFacebookName.text! == "https://www.facebook.com/")
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textTitleName {
            if textTitleName.text! == self.name {
                DispatchQueue.main.async(execute: {
                    self.btnUpdate.isHidden = true
                    self.btnUpdateHeightConstraint.constant = 0
                })
           }else {
                DispatchQueue.main.async(execute: {
                    self.btnUpdate.isHidden = false
                    self.btnUpdateHeightConstraint.constant = 45
                })
            }
        }
        else if textField == textOfCell {
            self.flgForCellPhnUpdate = true
            if textOfCell.text == self.phone {
                DispatchQueue.main.async(execute: {
                    self.btnUpdate.isHidden = true
                    self.btnUpdateHeightConstraint.constant = 0
                })
            }
            else {
                DispatchQueue.main.async(execute: {
                    self.btnUpdate.isHidden = false
                    self.btnUpdateHeightConstraint.constant = 45
                })
            }
       }
        
        else if textField == textOfFacebookName || textField == textOfSkypeName {
            if textOfFacebookName.text! == self.facebookName  && textOfSkypeName.text!  == self.skypeName  {
            if oldFBSwitch == self.publicFBSwitch && oldSkypeSwitch == self.publicSkypeSwitch {
                    DispatchQueue.main.async(execute: {
                        self.btnUpdate.isHidden = true
                        self.btnUpdateHeightConstraint.constant = 0
                    })
                }else {
                    DispatchQueue.main.async(execute: {
                        self.btnUpdate.isHidden = false
                        self.btnUpdateHeightConstraint.constant = 45
                    })
                }
            }
                
            else if textOfFacebookName.text! == "https://www.facebook.com/" {
                if self.fblinkValidateFlag == "1" {
                    DispatchQueue.main.async(execute: {
                        self.btnUpdate.isHidden = true
                        self.btnUpdateHeightConstraint.constant = 0
                    })
                }
                else {
                    DispatchQueue.main.async(execute: {
                        self.btnUpdate.isHidden = false
                        self.btnUpdateHeightConstraint.constant = 45
                    })
                }
            }
            else {
                DispatchQueue.main.async(execute: {
                    self.btnUpdate.isHidden = false
                    self.btnUpdateHeightConstraint.constant = 45
                })
            }
        }
     }
 
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == textOfFacebookName {
            if range.location <= 24 {
                return false
            }
        }
        return true
    }
    
    func checkSpace(str:String) -> Bool {
        let rawString: String = str
        let whitespace = CharacterSet.whitespacesAndNewlines
        let trimmed = rawString.trimmingCharacters(in: whitespace)
        if (trimmed.count ) == 0 {
            // Text was empty or only whitespace.
            return true
        }
        return false
    }
}

// MARK: UIImagePicker Delegete
extension MyProfile : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    func alertCameraGallary() {
        let alertController = UIAlertController(title:  (appDelegate.ArryLngResponeCustom!["select_profile_photo"] as? String)!, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title:  (appDelegate.ArryLngResponeCustom!["camera"] as? String)!, style: UIAlertActionStyle.default, handler: {
            action in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                
                let imgPicker = UIImagePickerController()
                imgPicker.delegate = self
                imgPicker.sourceType = UIImagePickerControllerSourceType.camera
                imgPicker.allowsEditing = true
                self.present(imgPicker, animated: true, completion: nil)
            }
        }))
        alertController.addAction(UIAlertAction(title:  (appDelegate.ArryLngResponeCustom!["gallery"] as? String)!, style: UIAlertActionStyle.default, handler: {
            
            action in
            let imgPicker = UIImagePickerController()
            imgPicker.allowsEditing = true
            imgPicker.delegate = self
            imgPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imgPicker, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title:  (appDelegate.ArryLngResponeCustom!["cancel"] as? String)!, style: UIAlertActionStyle.default, handler:nil))
        
        present(alertController,animated: true,completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        flag = true
        updateFlag = false
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let possibleImg = info[UIImagePickerControllerEditedImage] as? UIImage {
            imgOfProfile.image = possibleImg
            flag = false
            updateFlag = true
        }
        else if let possibleImg = info[UIImagePickerControllerOriginalImage] as? UIImage{
            //imageOfPRofile1.image = possibleImg
            imgOfProfile.image = possibleImg
            flag = false
            updateFlag = true
        }
        else{
            flag = false
            updateFlag = true
            return
        }
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- favMenuDelagte
extension MyProfile : favMenuDelagte {
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
                                //getallCourseData API ==>PDF page no 53 >>> CourseTemplateDetails
                                let nextVC = storyboard?.instantiateViewController(withIdentifier: "CourseTemplateDetails") as! CourseTemplateDetails
                                nextVC.StrCourseCatgryId = (SelecteItem["id"] as? String)!
                                self.navigationController?.pushViewController(nextVC, animated: true)
                            }
                        }
                    }else if SelecteItem["itemType"] as? String == "2"{ //itemType == 2 for Blog
                        UserDefaults.standard.set("2", forKey: "paymentFlag")
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
//MARK:- WS of MyProfile
extension MyProfile {
    
    func callWSOfProfile(){
        
        //URL : https://cmspreview.membrandt.com/api/getProfile?appclientsId=1&userId=1&userPrivateKey=YJi7ts191N9gf2kx&appId=1
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId]
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getProfile?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            self.startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiLoginSuccesFlag = "1"
            apiSuccesFlag = "1"
            self.callWSOfGetProfile(strURL: strURL, dictionary: dictionary )
        }else{
            stopActivityIndicator()
            self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.oppsMsg, lableNoInternate: string.noInternateMessage2)
            self.view.addSubview(self.noDataView)
        }
    }
    
    func callWSOfGetProfile(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiLoginSuccesFlag = "2"
            print("JSONResponse of callWSOfGetProfile :", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    if let data = JSONResponse["response"] as? [String:Any]{ //Dictionary<String,Any>
                        
                        self.name = data["name"] as! String
                        self.email = data["email"] as! String
                        self.phone = data["phone"] as! String
                        self.textOfPass.text = data["password"] as? String
                        
                        self.textTitleName.text = self.name
                        self.txtOfEmail.text = self.email
                        self.textOfCell.text = data["nationalFormat"] as? String
                        self.oldCellPhnValue = (data["nationalFormat"] as? String)!
                        
                        self.lblOfEmailStatus.isHidden = true
                        self.lblOfCellStatus.isHidden = true
                        self.btnChangePass.isHidden = false
                        self.btnResendLink.isHidden = true
                        //self.lblOfFbStatus.isHidden = true
                        
                        self.lblAboutMeTitle.isHidden = true
                        self.textViewOfAbotMe.isHidden = true
                        self.heightOfAbutMeView.constant = 0
                        
                        if let socialData = data["social"] as? [Any]{
                            if socialData.count > 0{
                                let fbDic = socialData[0] as? [String:Any]
                                self.facebookName = fbDic!["name"] as! String
                                self.fbTxtFlag = fbDic!["flag"] as! String
                                self.fbVisibleFlag = fbDic!["fb_visible"] as! String
                                self.publicFBSwitch = fbDic!["public"] as! String
                                
                                print("self.fbTxtFlag ::",self.fbTxtFlag)
                                print("fbswitch ::",self.publicFBSwitch)
                                
                                let strArry1 = self.facebookName.components(separatedBy: "https://www.facebook.com/")
                                
                                
                                if strArry1.count == 2{
                                    //self.facebookName = strArry1[1] + "\(fbDic!["name"] as! String)"
                                    self.facebookName = "\(fbDic!["name"] as! String)"
                                }else {
                                    self.facebookName = "https://www.facebook.com/\(self.facebookName)"
                                }
                                self.textOfFacebookName.text = self.facebookName
                               
                                
                                let skypeDic = socialData[1] as? [String:Any]
                                self.skypeName = skypeDic!["name"] as! String
                                self.skypeTxtFlag = skypeDic!["flag"] as! String
                                self.skVisibleFlag = skypeDic!["sk_visible"] as! String
                                
                                self.publicSkypeSwitch = skypeDic!["public"] as! String
                                self.textOfSkypeName.text = self.skypeName
                                
                              
                                //for switch
                                if self.publicSkypeSwitch == "1" {
                                    self.SwitchOfSkype.setOn(true, animated: true)
                                    self.oldSkypeSwitch = "1"
                                }
                                else if self.publicSkypeSwitch == "0" {
                                    self.SwitchOfSkype.setOn(false, animated: true)
                                    self.oldSkypeSwitch = "0"
                                }
                                
                                //FB
                                if self.publicFBSwitch == "1" {
                                    self.SwitchOfFb.setOn(true, animated: true)
                                    self.oldFBSwitch = "1"
                                 }
                                else if self.publicFBSwitch == "0" {
                                    self.SwitchOfFb.setOn(false, animated: true)
                                    self.oldFBSwitch = "0"
                                 }
                                
                                //For fb/skype view hide/show
                                
                                if self.fbVisibleFlag == "0" {
                                    self.viewOfFB.isHidden = true
                                    self.heightOfFbView.constant = 0
                                }else {
                                    self.viewOfFB.isHidden = false
                                    self.heightOfFbView.constant = 60
                                }
                                
                                if self.skVisibleFlag == "0" {
                                    self.viewOfSkype.isHidden = true
                                    self.heightOfSkypeView.constant = 0
                                }
                                else {
                                    self.viewOfSkype.isHidden = false
                                    self.heightOfSkypeView.constant = 60
                                }
                                if self.fbVisibleFlag == "0" && self.skVisibleFlag == "0" {
                                    self.viewOfSocialMedia.isHidden = true
                                    self.heightOfSocialMedia.constant = 0
                                }
                            }
                        }
                        
                        //image
                        if data["image"] as? String != nil{
                            let imgUrl = data["image"] as? String
                            
                            let imageName = self.separateImageNameFromUrl(Url: imgUrl!)
                           // self.imgOfProfile.image = UIImage(named:"placeholder2")
                            self.imgOfProfile.backgroundColor = color.placeholdrImgColor
                            
                            if(self.chache.object(forKey: imageName as AnyObject) != nil){
                                self.imgOfProfile.image = self.chache.object(forKey: imageName as AnyObject) as? UIImage
                            }else{
                                if validation.checkNotNullParameter(checkStr: imgUrl!) == false {
                                    Alamofire.request(imgUrl!).responseImage{ response in
                                        if let image = response.result.value {
                                            self.imgOfProfile.image = image
                                            self.chache.setObject(image, forKey: imageName as AnyObject)
                                        }
                                        else {
                                           //  self.imgOfProfile.image = UIImage(named:"placeholder2")
                                            self.imgOfProfile.backgroundColor = color.placeholdrImgColor
                                        }
                                    }
                                }else {
                                     //self.imgOfProfile.image = UIImage(named:"placeholder2")
                                    self.imgOfProfile.backgroundColor = color.placeholdrImgColor
                                }
                            }
                        }
                    }else{
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
                        let alrtTitleStr = NSMutableAttributedString(string: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String))
                        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                        
                        let alrtMessage = NSMutableAttributedString(string: string.privateKeyMsg)
                        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                        
                        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                        alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                        alertController.setValue(alrtMessage, forKey: "attributedMessage")
                        
                        //let alertController = UIAlertController(title: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String), message: string.privateKeyMsg, preferredStyle: .alert)
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
                        alertController.addAction(btnOK)
                        self.present(alertController, animated: true, completion: nil)
                    }else {
                        //self.errorCodeAlert(title: (JSONResponse["title"] as? String)!, description: (JSONResponse["description"] as? String)!, errorCode: (JSONResponse["systemErrorCode"] as? String)!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)
                        
                        self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: (JSONResponse["title"] as? String)!, lableNoInternate: ((JSONResponse["description"] as? String)! + "\n\(string.errodeCodeString) = [\((JSONResponse["systemErrorCode"] as? String)!)]"))
                        self.view.addSubview(self.noDataView)
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
                self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.oppsMsg, lableNoInternate: string.someThingWrongMsg)
                self.view.addSubview(self.noDataView)
            }
        })
    }
    
    //MARK:- Mobile No Validation
    func callWSOfValidCellNo(){
        
        //URL : http://27.109.19.234/app_builder/index.php/api/verifyContactno?appclientsId=1&userId=12&userPrivateKey=YVv31rAhdy7PX6Ts&appId=1&contactno=3126230052
        
        print("self.oldCellPhnValue :",self.oldCellPhnValue)
        
        if self.oldCellPhnValue == self.textOfCell.text {
            self.textOfCell.text = self.phone
        }
        
      let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "contactno" : self.textOfCell.text!] as [String : Any]
        
        //textOfCell.text
        
        print("Cell Validation I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "verifyContactno?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            self.startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSOfMobileNOValidation(strURL: strURL, dictionary: dictionary as! Dictionary<String, String>)
        }else{
            stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOfMobileNOValidation(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            print("JSONResponse For MobileNo : ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                //self.stopActivityIndicator()
                DispatchQueue.main.async {
                    self.phone = JSONResponse["phoneNumber"] as! String
                    self.nationalNo = JSONResponse["nationalNumber"] as! String
                    self.textOfCell.text = self.nationalNo
                    self.oldCellPhnValue = self.nationalNo
                    //CallUpdate API
                    self.updateProfileImage()
                }
            }
            else {
                self.stopActivityIndicator()
                DispatchQueue.main.async {
                    //self.view.makeToast((JSONResponse["message"] as? String)!)
                    self.errorCodeAlert(title: (JSONResponse["title"] as? String)!, description: (JSONResponse["description"] as? String)!, errorCode: (JSONResponse["systemErrorCode"] as? String)!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)
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
    
    
    // MARK: - WS Update Profile
    func updateProfileImage(){
    
        // http://27.109.19.234/app_builder/index.php/api/updateProfileImage?appclientsId=1&userId=13&userPrivateKey=8TkrlIaRy40HUw95&appId=4&name=naushil&contact=7849302109&nationalFormat=+13126232002&facebookname=NJ&skypename=MJ&facebookflag=1&skypeflag=1
        
        if checkSpace(str: textOfSkypeName.text!) {
            textOfSkypeName.text! = ""
        }
        if SwitchOfFb.isOn && self.fbVisibleFlag == "1" {
            fbflag = "1"
             SwitchOfFb.setOn(true, animated: false)
        }else {
            fbflag = "0"
             SwitchOfFb.setOn(false, animated: false)
        }
        
        if SwitchOfSkype.isOn && skVisibleFlag == "1"{
            skypflag = "1"
            SwitchOfSkype.setOn(true, animated: false)
        }else {
            skypflag = "0"
            SwitchOfSkype.setOn(false, animated: false)
        }
        
        var strngConct = ""
        if self.textOfCell.text!.count != 0 {
            strngConct = self.phone
        }else {
            strngConct = ""
        }
        
        if self.imgOfProfile.image == nil {
            self.imgOfProfile.image = UIImage(named:"grayColor")
        }
        
        let dictionary = ["appclientsId" : userInfo.appclientsId,
                          "userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appId" : userInfo.appId,
                          "name" : textTitleName.text!,
                          "contact" : strngConct,
                          "facebookname" : textOfFacebookName.text!,
                          "skypename" : textOfSkypeName.text!,
                          "nationalFormat" : self.textOfCell.text!,
                          "facebookflag" : fbflag,
                          "skypeflag" : skypflag
            ] as [String : Any]
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "updateProfileImage?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.callWSOfUpdateProfile(strURL: strURL, dictionary: dictionary as! Dictionary<String, String> )
        }else {
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOfUpdateProfile(strURL: String, dictionary:Dictionary<String,String>){
        _ = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: true, fileName: "image", params: dictionary as [String : AnyObject], image: imgOfProfile.image!, success: { (JSONResponse) in
            
            print("JSONResponse ", JSONResponse)
            var data = [String:String]()
            data = JSONResponse as! [String : String]
            if data["status"] == "1"{
                DispatchQueue.main.async {

                    self.stopActivityIndicator()
                    self.btnUpdate.isHidden = true
                    self.btnUpdateHeightConstraint.constant = 0
                    self.name = self.textTitleName.text!
                    
                    self.facebookName = self.textOfFacebookName.text!
                    self.skypeName = self.textOfSkypeName.text!
                    self.fbOldTxt = self.textOfFacebookName.text!
                    
                    //new parameter
                    self.fblinkValidate = (data["fblinkValidate"] as? String)!
                    print("fblinkValidate ::", self.fblinkValidate)
                    if self.fblinkValidate == "0" {
                      
                        self.fblinkValidateFlag = "1"   //for update button
                        self.flgForFbTxt = "1"
                        self.textOfFacebookName.text = "https://www.facebook.com/"
                        self.SwitchOfFb.setOn(false, animated: true)
                        
                        let alrtTitleStr = NSMutableAttributedString(string: (self.appDelegate.ArryLngResponeCustom!["profile_updated"] as? String)!)
                        //"Profile Updated"
                        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                        
                        let alrtMessage = NSMutableAttributedString(string: (self.appDelegate.ArryLngResponSystm!["invalid_fb_url_msg"] as? String)!)
                        //"Profile updated. But Your Facebook URL is invalid. Please enter valid URL\n and update profile again.\n"
                        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                        
                        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                        alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                        alertController.setValue(alrtMessage, forKey: "attributedMessage")
                        
                        //let alert = UIAlertController(title: "Profile Updated", message: "Profile updated. But Your Facebook URL is invalid. Please enter valid URL\n and update profile again.\n", preferredStyle: .alert)
                        let ok = UIAlertAction(title: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!, style: .cancel, handler: nil)
                        alertController.addAction(ok)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else {
                        self.view.makeToast((data["message"])!)
                    }
                }
            }
            else{
                let status = data["status"]
                self.stopActivityIndicator()
                switch status!{
                case "0":
                    print("error2: ")
                    if (data["errorCode"]) == userInfo.logOuterrorCode {
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
                        self.errorCodeAlert(title: (data["title"])!, description: (data["description"])!, errorCode: (data["systemErrorCode"])!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)
                    }
                    break
                default:
                    //self.view.makeToast((JSONResponse["systemMsg"] as? String)!)
                    self.errorCodeAlert(title: (data["title"])!, description: (data["description"])!, errorCode: (data["systemErrorCode"])!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)
                    print("error1: ");
                }
            }
        }, failure: { (error) in
            print("error: ",error)
            DispatchQueue.main.async{
                self.view.makeToast(string.someThingWrongMsg)
                self.stopActivityIndicator()
            }
        })
    }
    
    // MARK: - WS Change Password
    func changePassword(strNewPass:String){
        
        // http://27.109.19.234/app_builder/index.php/api/changePassword?appId=1&userId=36&newPassword=tester
        let dictionary = ["appId" : userInfo.appId,
                          "userId" : userInfo.userId,
                          "newPassword" : strNewPass
            ] as [String : String]
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "changePassword?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.callWSOfChangePassword(strURL: strURL, dictionary: dictionary )
        }else {
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOfChangePassword(strURL: String, dictionary:Dictionary<String,String>){
        _ = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: true, fileName: "image", params: dictionary as [String : AnyObject], image: imgOfProfile.image!, success: { (JSONResponse) in
            
            print("JSONResponse ", JSONResponse)
            var data = [String:String]()
            data = JSONResponse as! [String : String]
            if data["status"] == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.view.makeToast((data["message"])!)
                    self.textOfPass.text = self.strPass
                    //self.callWSOfProfile()
                }
            }
            else{
                let status = data["status"]
                self.stopActivityIndicator()
                switch status!{
                case "0":
                    print("error2: ")
                    if (data["errorCode"]) == userInfo.logOuterrorCode {
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
                        self.errorCodeAlert(title: (data["title"])!, description: (data["description"])!, errorCode: (data["systemErrorCode"])!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)
                    }
                    break
                default:
                    //self.view.makeToast((JSONResponse["systemMsg"] as? String)!)
                    self.errorCodeAlert(title: (data["title"])!, description: (data["description"])!, errorCode: (data["systemErrorCode"])!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)
                    print("error1: ");
                }
            }
        }, failure: { (error) in
            print("error: ",error)
            DispatchQueue.main.async{
                self.view.makeToast(string.someThingWrongMsg)
                self.stopActivityIndicator()
            }
        })
    }
    
    // MARK: - WS Update Social Flag
    func updateSocialMediaFlag(){
        
        //http://27.109.19.234/app_builder/index.php/api/updateSocialMediaFlag?appclientsId=4&userId=1&userPrivateKey=H5q526P19no8MFBN&appId=1&facebookname=monika&skypename=monika&type=1&flag=0
        let dictionary = ["appclientsId" : userInfo.appclientsId,
                          "userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appId" : userInfo.appId,
                          "facebookname" : textOfFacebookName.text!,
                          "skypename" : textOfSkypeName.text!,
                          "type": typeOfSocial,
                          "flag": flagOfSocial
            ] as [String : String]
        
        print("I/P: updateSocialMediaFlag ::",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "updateSocialMediaFlag?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.callWSOfupdateSocialMediaFlag(strURL: strURL, dictionary: dictionary )
        }else {
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOfupdateSocialMediaFlag(strURL: String, dictionary:Dictionary<String,String>){
        _ = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: true, fileName: "image", params: dictionary as [String : AnyObject], image: imgOfProfile.image!, success: { (JSONResponse) in
            
            print("JSONResponse ", JSONResponse)
            var data = [String:String]()
            data = JSONResponse as! [String : String]
            if data["status"] == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.view.makeToast((data["message"])!)
                    self.btnUpdate.isHidden = true
                    self.btnUpdateHeightConstraint.constant = 0
                    self.facebookName = self.textOfFacebookName.text!
                    self.skypeName = self.textOfSkypeName.text!
                }
            }
            else{
                let status = data["status"]
                self.stopActivityIndicator()
                switch status!{
                case "0":
                    print("error2: ")
                    if (data["errorCode"]) == userInfo.logOuterrorCode {
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
                        self.errorCodeAlert(title: (data["title"])!, description: (data["description"])!, errorCode: (data["systemErrorCode"])!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)
                    }
                    break
                default:
                    //self.view.makeToast((JSONResponse["systemMsg"] as? String)!)
                    self.errorCodeAlert(title: (data["title"])!, description: (data["description"])!, errorCode: (data["systemErrorCode"])!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)
                    print("error1: ");
                }
            }
        }, failure: { (error) in
            print("error: ",error)
            DispatchQueue.main.async{
                self.view.makeToast(string.someThingWrongMsg)
                self.stopActivityIndicator()
            }
        })
    }
}

// CHECK PERMISSION
extension MyProfile  {
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized: alertCameraGallary()
        //handle authorized status
        case .denied, .restricted : alertToEncourageCameraAccessInitially()
        //handle denied status
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized: self.alertCameraGallary()
                // as above
                case .denied, .restricted: self.alertToEncourageCameraAccessInitially()
                // as above
                case .notDetermined: self.alertToEncourageCameraAccessInitially()
                    // won't happen but still
                }
            }
        }
    }
    
    func checkCamera() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized: alertCameraGallary() // Do your stuff here i.e. callCameraMethod()
        case .denied: alertPromptToAllowCameraAccessViaSetting()
        case .notDetermined: alertToEncourageCameraAccessInitially()
        default: alertToEncourageCameraAccessInitially()
        }
    }
    
    func alertToEncourageCameraAccessInitially() {
        let alert = UIAlertController(
            title: (appDelegate.ArryLngResponSystm!["important"] as? String)!,
            //"IMPORTANT",
            message: (appDelegate.ArryLngResponSystm!["camera_access_required"] as? String)!,
            //"Camera access required for capturing photos!",
            preferredStyle: UIAlertControllerStyle.alert
        )
        alert.addAction(UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["cancel"] as? String)!, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [ : ], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func alertPromptToAllowCameraAccessViaSetting() {
        
        let alert = UIAlertController(
            title: (appDelegate.ArryLngResponSystm!["important"] as? String)!,
            //"IMPORTANT",
            message: (appDelegate.ArryLngResponSystm!["camera_access_required"] as? String)!,
            //"Camera access required for capturing photos!",
            preferredStyle: UIAlertControllerStyle.alert
        )
        alert.addAction(UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["cancel"] as? String)!, style: .cancel) { alert in
            if AVCaptureDevice.devices(for: AVMediaType.video).count > 0 {
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                    DispatchQueue.main.async() {
                        self.checkCamera() } }
            }
            }
        )
        present(alert, animated: true, completion: nil)
    }
}
