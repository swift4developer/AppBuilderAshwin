//
//  SubscriptionsVC.swift
//  AppBuilder2
//
//  Created by Aditya on 05/04/18.
//  Copyright © 2018 VISHAL. All rights reserved.
//

import UIKit

class SubscriptionsVC: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet weak var viewCells: UIView!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var lblSubscription: UILabel!
    @IBOutlet weak var lblActive: UILabel!
    @IBOutlet weak var lblVisaActive: UILabel!
    @IBOutlet weak var lblBackup: UILabel!
    @IBOutlet weak var lblVisaBackup: UILabel!
    @IBOutlet weak var btnActive: UIButton!
    @IBOutlet weak var btnUpdateBackup: UIButton!
    @IBOutlet weak var btnUpdateActive: UIButton!
    @IBOutlet weak var lblRenewal: UILabel!
    @IBOutlet weak var lblAnnualPkg: UILabel!
    @IBOutlet weak var lblActiveSubcription: UILabel!
    @IBOutlet weak var lblCancel: UILabel!
    @IBOutlet weak var btnToCancel: UIButton!
    @IBOutlet weak var btnQuestionMark: UIButton!
    @IBOutlet weak var viewHeaders: UIView!
    
    @IBOutlet weak var viewHeader2: UIView!
    @IBOutlet weak var viewHeader1: UIView!
    @IBOutlet weak var lblInvoice: UILabel!
    @IBOutlet weak var lblViewAllInvoice: UILabel!
    
    var appDelegate : AppDelegate!
    var chache:NSCache<AnyObject, AnyObject>!
    var flgActivity = true
    var timeOut: Timer!
    var apiSuccesFlag = ""
    var arryWSCoursData = Array<Any>()
    var noDataView = UIView()
    var refreshControl: UIRefreshControl!
    var strMenuId = ""
    var btnMenu:UIButton!
    var btnBack:UIButton!
    var getJsonData: [String:Any]?
    var commonElement = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Subscriptions"
        setBackBtn()
        setNavigationBtn()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        getJsonData =  appDelegate.jsonData
        
        self.chache = NSCache()
        
        getUIForSubscription()
//        callWSOfSubscription()
    }
    @IBAction func btnInvoiceClk(_ sender: Any) {
    }
    
    @IBAction func btnActiveClk(_ sender: Any) {
    }
    @IBAction func btnUpdateBackupClk(_ sender: Any) {
    }
    @IBAction func btnToCancelClk(_ sender: Any) {
    }
    @IBAction func btnUpdateClk(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionDetailsVC") as! SubscriptionDetailsVC
        self.navigationController?.pushViewController(nextVC, animated: true)
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
        vc.delegate = self as favMenuDelagte
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @objc func refresh(_ sender:AnyObject){
        flgActivity = false
        self.timeOut = Timer.scheduledTimer(timeInterval: 25.0, target: self, selector: #selector(Login.cancelWeb), userInfo: nil, repeats: false)
        apiSuccesFlag = "1"
//        callWSOfSubscription()
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
    @IBAction func btnQuestonMarkClick(_ sender: Any) {
        if self.appDelegate.helpData.count > 0 && UserDefaults.standard.bool(forKey: "helpData"){
            UserDefaults.standard.set("1", forKey: "ArticleVideoFlag")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogPostViewController") as! BlogPostViewController
            print("AppDelegate ",self.appDelegate.helpData)
            vc.dicMediaData = self.appDelegate.helpData
            vc.flgToShow = "Help"
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            self.view.makeToast("No article available for HELP.")
        }
    }
    
    
    func getUIForSubscription() {
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
                    
                    self.viewCells.backgroundColor = UIColor().HexToColor(hexString: bgScreenColor)
                    
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor().HexToColor(hexString: txtcolorHex!),NSAttributedStringKey.font: checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(sizeInt))]
                    
                    self.navigationController?.navigationBar.barTintColor = UIColor().HexToColor(hexString: bgcolor!)
                    self.navigationController?.navigationBar.backgroundColor = UIColor().HexToColor(hexString: bgcolor!)
                    
                    self.btnMenu.tintColor = UIColor().HexToColor(hexString: menu_icon_color!)
                    self.btnBack.tintColor = UIColor().HexToColor(hexString: menu_icon_color!)
                    
                    let origImage = UIImage(named: "question");
                    let tintImg = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    btnQuestionMark.setBackgroundImage(tintImg, for: .normal)
                    btnQuestionMark.tintColor = UIColor().HexToColor(hexString: bgcolor!)
//                    btnQuestionMark.titleLabel?.font = checkForFontType(fontStyle: fontstyle , fontSize: CGFloat(sizeInt))
                    btnQuestionMark.setTitleColor(UIColor().HexToColor(hexString: txtcolorHex!), for: .normal)
                    
                
                    commonElement = common_element
                    
                    let genrlFontSize = genarlSettings["general_fontsize"] as! [String:String]
                    let small = genrlFontSize["small"]
                    let smallInt:Int = Int(small!)!
                    let medium = genrlFontSize["medium"]
                    var mediumInt:Int = Int(medium!)!
                    
                    if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5{
                        mediumInt = mediumInt - 3
                    }
                    //headers
                    lblSubscription.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 2))
                    lblSubscription.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    lblSubscription.font = UIFont.boldSystemFont(ofSize: CGFloat(mediumInt + 2))
                    
                    lblPayment.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 2))
                    lblPayment.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    lblPayment.font = UIFont.boldSystemFont(ofSize: CGFloat(mediumInt + 2))
                    
                    lblInvoice.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 2))
                    lblInvoice.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    lblInvoice.font = UIFont.boldSystemFont(ofSize: CGFloat(mediumInt + 2))
                    
                    //Cells
                    lblViewAllInvoice.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 2 ))
                    lblViewAllInvoice.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    
                    lblActiveSubcription.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 2))
                    lblActiveSubcription.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                   
                    lblActive.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 2))
                    lblActive.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    
                    lblBackup.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 2))
                    lblBackup.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    
                    lblCancel.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt + 2))
                    lblCancel.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    
                    btnUpdateActive.setTitleColor(UIColor().HexToColor(hexString: txtcolorHex!), for: .normal)
                    btnUpdateActive.titleLabel?.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(smallInt))
                    btnUpdateActive.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(smallInt))
                    
                    btnUpdateBackup.setTitleColor(UIColor().HexToColor(hexString: txtcolorHex!), for: .normal)
                    btnUpdateBackup.titleLabel?.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(smallInt))
                    btnUpdateBackup.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(smallInt))
                    
                    btnActive.setTitleColor(UIColor().HexToColor(hexString: txtcolorHex!), for: .normal)
                    btnActive.titleLabel?.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(smallInt))
                    btnActive.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(smallInt))
                    
                    lblVisaBackup.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(smallInt - 3))
                    lblVisaBackup.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    
                    lblVisaActive.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(smallInt - 3))
                    lblVisaActive.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    
                    lblRenewal.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(smallInt - 1))
                    lblRenewal.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                    
//                    btnToCancel.setTitleColor(UIColor().HexToColor(hexString: genrltxtColor), for: .normal)
                    btnToCancel.titleLabel?.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt ))
                    
                    lblAnnualPkg.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(smallInt + 2))
                    lblAnnualPkg.textColor = UIColor().HexToColor(hexString: genrltxtColor)
                }
            }
        } else {
            self.view.makeToast(string.noInternateMessage2)
        }
    }
}


//MARK:- favMenuDelagte
extension SubscriptionsVC : favMenuDelagte {
    func homeBtnPress() {
        if validation.isConnectedToNetwork()  {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers
            for aViewController in viewControllers {
                if aViewController is HomeViewController {
                    self.navigationController!.popToViewController(aViewController, animated: true)
                }
            }
        }else{
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
        }else{
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

// MARK:- WS PARSING
extension SubscriptionsVC {
    
    func callWSOfSubscription(){
        
        //URL : https://cmspreview.membrandt.com/api/getSubscription?appclientsId=1&userId=1&userPrivateKey=YJi7ts191N9gf2kx&appId=1
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId]
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getSubscription?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            if flgActivity{
                self.startActivityIndicator()
            }
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSOfSubscription(strURL: strURL, dictionary: dictionary )
        }else{
            stopActivityIndicator()
            self.refreshControl.endRefreshing()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOfSubscription(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.refreshControl.endRefreshing()
                    if let arrayData = JSONResponse["response"] as? [String:Any]{
                    }
                    else{
                        self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: "", lableNoInternate: string.noDataFoundMsg)
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
                        self.errorCodeAlert(title: (JSONResponse["title"] as? String)!, description: (JSONResponse["description"] as? String)!, errorCode: (JSONResponse["systemErrorCode"] as? String)!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)
                    }
                    break
                default:
                    self.view.makeToast((JSONResponse["message"] as? String)!)
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
            }
        })
    }
}



