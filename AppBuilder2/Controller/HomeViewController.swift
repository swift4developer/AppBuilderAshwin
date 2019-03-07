//
//  HomeViewController.swift
//  MoneyLander
//
//  Created by PUNDSK006 on 8/1/17.
//  Copyright © 2017 Magneto. All rights reserved.
//

import UIKit
import Alamofire
import ImageIO

//, NVActivityIndicatorViewable
class HomeViewController: UIViewController,NVActivityIndicatorViewable,UIScrollViewDelegate {

    var appDelegate : AppDelegate!
    
    @IBOutlet weak var scroll_View: UIScrollView!
    @IBOutlet weak var heightOfImge: NSLayoutConstraint!
    @IBOutlet weak var heightOfTbl: NSLayoutConstraint!
    @IBOutlet weak var heightOfViewOfScroll: NSLayoutConstraint!
    @IBOutlet weak var imgOfTopOfTbl: UIImageView!
    @IBOutlet weak var btnQuestonMark: UIButton!
    @IBOutlet weak var lblOfVersionName: UILabel!
    @IBOutlet weak var viewtopOfDrawer: UIView!
    @IBOutlet var noPostLbl: UILabel!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var viewNavBar: UIView!
    
    @IBOutlet var menuImgView: UIImageView!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var slideView: UIView!
    var cellImgArr : [String] = []
    var cellTitleArr : [String] = []
    var cellTitleArr2 : [String] = []
    var headerArray : [String] = []
    var arryofProgress : [Any] = []
    var lblelForImg = UILabel()
    var popView = UIView()
    
    @IBOutlet var bgViewOfAlert: UIView!
    @IBOutlet var viewOfAlert: UIView!
    @IBOutlet var lblOfLogutTitle: UILabel!
    @IBOutlet var btnNo: UIButton!
    @IBOutlet var btnYes: UIButton!
  
    @IBOutlet var tblOfHomes: UITableView!
    @IBOutlet weak var imgOfFavMenu: UIImageView!
    @IBOutlet weak var btnOfFavMenu: UIButton!

    //Offline data
    @IBOutlet weak var lblOfflineMainTitle: UILabel!
    @IBOutlet weak var imgOfOflineData: UIImageView!
    @IBOutlet weak var lblOflineDataTitle: UILabel!
    @IBOutlet weak var lblOflineDataSubtitle: UILabel!
    @IBOutlet weak var viewOfOfflineMode: UIView!
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var heightOfStatusBarView: NSLayoutConstraint!
    
    var chache:NSCache<AnyObject, AnyObject>!

    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    var getJsonData: [String:Any]?
    var template1 = [String:Any]()
    var template2 = [String:Any]()
    var descriptionArry = [String:String]()
    var titleName = [String:String]()
    var notification_count = [String:String]()
    var template_id = String()
    var arryWSData = Array<Any>()
    var noDataView = UIView()
    var refreshControl: UIRefreshControl!
    var flgActivity = true
    var strStyle = "2"
    var commonElement = [String:Any]()
    var navigationMenu = [String:Any]()
    var arryOfProgressUpdte = Array<Any>()
    var arryOfNotifcatnUpdte = Array<Any>()
    
    var strFontStyle = ""
    
    var timeOut: Timer!
    var rerfTimeOut: Timer!
    var refreshForLang = "1"
    var apiSuccesFlag = ""
    var ffTagFlag = ""
    let reachability = Reachability()!
    var window: UIWindow?
    
    // MARK:- Custom Method
    override func viewDidLoad(){
        super.viewDidLoad()

        self.chache = NSCache()
        let tagName = ffTagFlag
        if userInfo.appId == "27" && userInfo.appclientsId == "6"{
            var imgurl = ""
            if tagName.contains("125"){
                imgurl = "https://demo-fulfillment-app-image.s3.us-west-1.amazonaws.com/images/image1.jpg"
            }else if tagName.contains("135"){
                imgurl = "https://demo-fulfillment-app-image.s3.us-west-1.amazonaws.com/images/image2.jpg"
            }else if tagName.contains("139"){
                imgurl = "https://demo-fulfillment-app-image.s3.us-west-1.amazonaws.com/images/image3.jpg"
            }else if tagName.contains("143"){
                imgurl = "https://demo-fulfillment-app-image.s3.us-west-1.amazonaws.com/images/image4.jpg"
            }else if tagName.contains("147"){
                imgurl = "https://demo-fulfillment-app-image.s3.us-west-1.amazonaws.com/images/image5.jpg"
            }else {
                imgurl = ""
            }
            
            if imgurl != ""{
                let imghieght = sizeOfImage(at: URL(string:imgurl)!)
                self.heightOfImge.constant = CGFloat(truncating: imghieght)
                let imgUrl = imgurl
                let imageName = self.separateImageNameFromUrl(Url: imgUrl)
                self.imgOfTopOfTbl.backgroundColor = color.placeholdrImgColor
                
                if(self.chache.object(forKey: imageName as AnyObject) != nil){
                    self.imgOfTopOfTbl.image = self.chache.object(forKey: imageName as AnyObject) as? UIImage
                }else{
                    if validation.checkNotNullParameter(checkStr: imgUrl) == false {
                        Alamofire.request(imgUrl).responseImage{ response in
                            if let image = response.result.value {
                                self.imgOfTopOfTbl.image = image
                                self.chache.setObject(image, forKey: imageName as AnyObject)
                            }
                            else {
                                self.imgOfTopOfTbl.backgroundColor = color.placeholdrImgColor
                            }
                        }
                    }else {
                        self.imgOfTopOfTbl.backgroundColor = color.placeholdrImgColor
                    }
                }
            }else {
                self.imgOfTopOfTbl.backgroundColor = color.placeholdrImgColor
            }
        }
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        getJsonData =  appDelegate.jsonData
        
        let panGestureLeft = UIPanGestureRecognizer()
        panGestureLeft.addTarget(self, action: #selector(handleSwipe(gesture:)))
        self.tblOfHomes.addGestureRecognizer(panGestureLeft)
        self.tblOfHomes.isUserInteractionEnabled = true
        panGestureLeft.delegate = self
        
        // Hide SlideMenu
        self.slideView.isHidden = true
        noPostLbl.isHidden = true
        
        self.slideView.backgroundColor = UIColor.clear
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        menuImgView.isUserInteractionEnabled = true
        menuImgView.addGestureRecognizer(tapGestureRecognizer)
        
        refreshControl = UIRefreshControl()
        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        scroll_View.addSubview(refreshControl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(popViewCntller), name: NSNotification.Name(rawValue:"popToRootViewController"), object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive(notification:)),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
        
        tblOfHomes.tableFooterView = UIView()
        tblView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChange(notification:)), name: Notification.Name.reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        }catch {
            print("Error")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(faceFingerSucess), name: NSNotification.Name(rawValue:"faceFingerIDSucess"), object: nil)
        
    }
    func leftDrawerData(){
        
        if appDelegate.ArryLngResponeCustom != nil{
            headerArray = [(appDelegate.ArryLngResponeCustom!["preferences"] as? String)!,(appDelegate.ArryLngResponeCustom!["system"] as? String)!]
            
            self.titleLbl.text = appDelegate.ArryLngResponeCustom!["home"] as? String

            if userInfo.isMultiLang == "0"{
                cellTitleArr = [(appDelegate.ArryLngResponeCustom!["my_profile"] as? String)!];
            }else {
                cellTitleArr = [(appDelegate.ArryLngResponeCustom!["my_profile"] as? String)!,(appDelegate.ArryLngResponeCustom!["Change_language"] as? String)!];
            }
            cellTitleArr2 = [(appDelegate.ArryLngResponeCustom!["help"] as? String)!,(appDelegate.ArryLngResponeCustom!["legal"] as? String)!,(appDelegate.ArryLngResponeCustom!["about_us"] as? String)!,(appDelegate.ArryLngResponeCustom!["offline_mode"] as? String)!,(appDelegate.ArryLngResponeCustom!["logout"] as? String)!]

            self.tblView.reloadData()
            self.tblOfHomes.reloadData()
        }else {
            self.titleLbl.text = "Home"
            headerArray = ["PREFERENCES","SYSTEM"]
            cellTitleArr = ["My Profile","Change Language"]; //,"Manage Subscription" ,"Other Settings"
            cellTitleArr2 = ["Help","Legal","About Us","Offline Mode","Log Out"]
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        leftDrawerData()
        
        if UserDefaults.standard.bool(forKey: "LeftMenuSelectLang"){
            UserDefaults.standard.set(false, forKey: "LeftMenuSelectLang")
            refreshForLang = "2"
            startActivityIndicator()
            refresh()
        }
        if DeviceType.IS_IPHONE_x {
            self.statusBarView.backgroundColor = UIColor().HexToColor(hexString: appDelegate.strStatusColor)
            self.heightOfStatusBarView.constant = 25
        }else {
            self.statusBarView.isHidden = true
            self.heightOfStatusBarView.constant = 0
        }
        
        
        UIApplication.shared.isStatusBarHidden = false
        self.navigationController?.navigationBar.isHidden = true
        
        if UserDefaults.standard.value(forKey: "app_user_id") != nil {
            userInfo.userId = UserDefaults.standard.value(forKey: "app_user_id") as! String
        }else {
            userInfo.userId = ""
        }
        
        if UserDefaults.standard.value(forKey: "appclientsId") != nil {
            userInfo.appclientsId = UserDefaults.standard.value(forKey: "appclientsId") as! String
        }else {
            userInfo.appclientsId = getJsonData!["appclientsId"] as! String
        }
        
        if UserDefaults.standard.value(forKey: "private_key") != nil {
            userInfo.userPrivateKey = UserDefaults.standard.value(forKey: "private_key") as! String
        }else {
            userInfo.userPrivateKey = ""
        }
        
        if UserDefaults.standard.value(forKey: "appId") != nil {
            userInfo.appId = UserDefaults.standard.value(forKey: "appId") as! String
        }else {
            userInfo.appId = getJsonData!["appId"] as! String
        }
        
        if validation.isConnectedToNetwork() {
            if UserDefaults.standard.string(forKey: "offLineFlag") != nil{
                if UserDefaults.standard.string(forKey: "offLineFlag") == "0"{
                   offlineFlow()
                }else {
                    viewOfOfflineMode.isHidden = true
                    btnMenu.isEnabled = true
                    btnSideMenu.isEnabled = true
                    imgOfFavMenu.isHidden = false
                    menuImgView.isHidden = false
                    imgOfFavMenu.image = #imageLiteral(resourceName: "side-menu")
                    
                    callFavCache()
                    callCacheJson()
                    checkAppVerison()
                }
            }else {
                viewOfOfflineMode.isHidden = true
                btnMenu.isEnabled = true
                btnSideMenu.isEnabled = true
                imgOfFavMenu.isHidden = false
                menuImgView.isHidden = false
                imgOfFavMenu.image = #imageLiteral(resourceName: "side-menu")
                
                callFavCache()
                callCacheJson()
                checkAppVerison()
            }
        }else {
            offlineFlow()
        }
        
        getUIForHome()
        getUIForDrawer()
        
        let dictionary = Bundle.main.infoDictionary!
        let build = dictionary["CFBundleVersion"] as! String
        
        if Url.baseURL == "http://cmsstaging.membrandt.com/index.php/api/"{
            lblOfVersionName.text = "v" + build + " - STAGING"
        }else if Url.baseURL == "http://27.109.19.234/app_builder/index.php/api/" || Url.baseURL == "http://103.51.153.235/app_builder/api/"{
            lblOfVersionName.text = "v" + build + " - DEV"
        }else {
            lblOfVersionName.text = "v" + build
        }
        
        bgViewOfAlert.isHidden = true
        
        lblOfLogutTitle.text = appDelegate.ArryLngResponSystm!["logout_msg"] as? String
        lblOfLogutTitle.textColor = color.alertSubTitleTextColor
        lblOfLogutTitle.font = checkForFontType(fontStyle: fontAndSize.alertSubTitleFontStyle, fontSize: fontAndSize.alertSubTitleFontSize)
        
        if validation.isConnectedToNetwork() {
            callWSProgressUpdate()
            callWSNotificatnUpdate()
        }
        
        setStatusBarBackgroundColor(color: UIColor().HexToColor(hexString: appDelegate.strStatusColor))
    }
    
    func onlineFlow(){
    
        print("Network is back to online...")
        UserDefaults.standard.set("1", forKey: "offLineFlag")
        viewOfOfflineMode.isHidden = true
        btnMenu.isEnabled = true
        btnSideMenu.isEnabled = true
        imgOfFavMenu.isHidden = false
        menuImgView.isHidden = false
        imgOfFavMenu.image = #imageLiteral(resourceName: "side-menu")
        
        setStatusBarBackgroundColor(color: UIColor().HexToColor(hexString: appDelegate.strStatusColor))
        
        if userInfo.userPrivateKey == "" || UserDefaults.standard.string(forKey: "private_key") == "" {
            let vc = storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            //MARK: Read from Local
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("JsonData.json")
            if FileManager.default.fileExists(atPath: documentsURL.relativePath) {
                let response = retrieveFromJsonFile()["response"] as! [String:Any]
                let responseFav = response["responseFav"] as! [Any]
                self.appDelegate.arryFavMenuData = responseFav
            }else {
                self.callWSOfFavMenu()
            }
            callCacheJson()
            checkAppVerison()
        }
    }

    func offlineFlow(){
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("LangDataJson.json")
        if FileManager.default.fileExists(atPath: documentsURL.relativePath) {
            appDelegate.ArryLngResponSystm = retrieveLangDataFile()["responseSystem"] as? [String:Any]
            appDelegate.ArryLngResponeCustom = retrieveLangDataFile()["responseCustom"] as? [String:Any]
        }
        
        UserDefaults.standard.set("0", forKey: "offLineFlag")
        imgOfOflineData.layer.cornerRadius = 5.0
        viewOfOfflineMode.isHidden = false
        lblOflineDataTitle.text = appDelegate.ArryLngResponeCustom!["my_downloaded_lessons"] as? String
        lblOflineDataSubtitle.text = appDelegate.ArryLngResponSystm!["access_downloads_msg"] as? String
        imgOfOflineData.image = UIImage(named: "NoInternet.jpg")
        lblOfflineMainTitle.text = appDelegate.ArryLngResponSystm!["working_offline_msg"] as? String
        btnMenu.isEnabled = false
        btnSideMenu.isEnabled = true
        imgOfFavMenu.isHidden = false
        menuImgView.isHidden = true
        
        if validation.isConnectedToNetwork()  {
            //imgOfFavMenu.image =  #imageLiteral(resourceName: "onlineImage")
            imgOfFavMenu.image = UIImage.gifImageWithName("onlineGif")
            //imgOfFavMenu.maskCircle(anyImage: imgOfFavMenu.image!)
        }else {
            imgOfFavMenu.image =  #imageLiteral(resourceName: "offlineImage")
        }
    }
    
    //MARK:- ChangeInNetwork Method
    @objc func reachabilityChange(notification: Notification) {
        
        let reachability = notification.object as! Reachability
        if reachability.connection != .none {
            if UserDefaults.standard.string(forKey: "offLineFlag") != nil{
                if UserDefaults.standard.string(forKey: "offLineFlag") == "0"{
                    offlineFlow()
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
                }else {
                   onlineFlow()
                }
            }else {
                onlineFlow()
            }
        }else {
            offlineFlow()
            if let wd = UIApplication.shared.delegate?.window {
                var vc = wd!.rootViewController
                if(vc is UINavigationController){
                    vc = (vc as! UINavigationController).visibleViewController
                }
                if(vc is OfflineCourseTemplateDetailVC){
                    //offliencourse controller
                    setStatusBarBackgroundColor(color: UIColor.black)
                }else if(vc is HomeViewController){
                    
                }else{
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                    for aViewController in viewControllers {
                        if aViewController is HomeViewController {
                            self.navigationController!.popToViewController(aViewController, animated: true)
                            break
                        }
                    }
                }
            }else {
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                for aViewController in viewControllers {
                    if aViewController is HomeViewController {
                        self.navigationController!.popToViewController(aViewController, animated: true)
                        break
                    }
                }
            }
        }
    }
    
    func sizeOfImage(at imageURL: URL) -> NSNumber {
        // With CGImageSource we avoid loading the whole image into memory
        var imageSize = NSNumber()
        let source: CGImageSource = CGImageSourceCreateWithURL((imageURL as? CFURL)!, nil)!
        //if source != nil {
        let options = [(kCGImageSourceShouldCache as String) : (false ? 1 : 0) ]
        let properties = (CGImageSourceCopyPropertiesAtIndex(source, 0, (options as? CFDictionary)) as? [AnyHashable: Any]) as CFDictionary?
        if properties != nil {
            let width = (properties as? [AnyHashable: Any])?[(kCGImagePropertyPixelWidth as? String)!] as? NSNumber
            let height = (properties as? [AnyHashable: Any])?[(kCGImagePropertyPixelHeight as? String)!] as? NSNumber
            if (width != nil) && (height != nil) {
                imageSize = height!
            }
        }
        //}
        return imageSize
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        checkAppVerison()
    }
    
    func checkAppVerison(){
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        print("Home version: \(version) & Build: \(build)")
        callWSOfAppUpdate(buildStr: build)
    }
    
    
    func callCacheJson(){
        let manager = FileManager.default
        let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("HomeCourseJson.json")
        // Transform array into data and save it into file
        if manager.fileExists(atPath: documentDirectoryUrl.relativePath) {
            let response = retrieveFromHomeCourseJsonFile()["Home"] as! [[String:Any]]
            if response.count > 0{
                self.noDataView.removeFromSuperview()
                self.arryWSData = response
                let helpDic = retrieveFromHomeCourseJsonFile()["help"] as! [[String:Any]]
                if helpDic.count > 0{
                    appDelegate.helpData = helpDic[0] as NSDictionary
                    UserDefaults.standard.set(true, forKey: "helpData")
                    UserDefaults.standard.synchronize()
                }else {
                    UserDefaults.standard.set(false, forKey: "helpData")
                    UserDefaults.standard.synchronize()
                }
                
                self.tblOfHomes.reloadData()
                self.refreshControl.endRefreshing()
                self.heightOfTbl.constant = CGFloat(self.arryWSData.count * 89)
            }else {
                print("Data not found in file")
                callWSOfHome()
            }
        }else {
            print("File Does not exit")
            //call live API first time
            callWSOfHome()
        }
    }
    
    func callFavCache(){
        //MARK: Read from Local
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("JsonData.json")
        if FileManager.default.fileExists(atPath: documentsURL.relativePath) {
            let response = retrieveFromJsonFile()["response"] as! [String:Any]
            let responseFav = response["responseFav"] as! [Any]
            self.appDelegate.arryFavMenuData = responseFav
        }else {
            self.callWSOfFavMenu()
        }
    }
    
    private var popGesture: UIGestureRecognizer?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if navigationController!.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
            self.popGesture = navigationController!.interactivePopGestureRecognizer
            self.navigationController!.view.removeGestureRecognizer(navigationController!.interactivePopGestureRecognizer!)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool){
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    func setStatusBarBackgroundColor(color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }
    
    @objc func refresh(_ sender:AnyObject){
        refresh()
    }
    
    @objc func faceFingerSucess(){
        DispatchQueue.main.async {
            if let wd = UIApplication.shared.delegate?.window {
                var vc = wd!.rootViewController
                if(vc is UINavigationController){
                    vc = (vc as! UINavigationController).visibleViewController
                }
                
                if(vc is HomeViewController){
                    print("home view controller ")
                    if validation.isConnectedToNetwork() == true {
                        self.refresh()
                    }
                }else {
                    print("Other view controller ")
                }
            }
        }
    }
    
    func refresh(){
        self.noDataView.removeFromSuperview()
        
        let manager = FileManager.default
        
        let documentDirectoryUrlHomeSosn = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("HomeCourseJson.json")
        if manager.fileExists(atPath: documentDirectoryUrlHomeSosn.relativePath) {
            do{
                try manager.removeItem(at: documentDirectoryUrlHomeSosn)
               //"Deleting HomeCourseJson file ")
            } catch {
                print("Error in deleting HomeCourseJson file ",error)
            }
        }
        
        let documentDirectoryUrlAllJson = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("JsonData.json")
        if manager.fileExists(atPath: documentDirectoryUrlAllJson.relativePath) {
            do{
                try manager.removeItem(at: documentDirectoryUrlAllJson)
                //"Deleting JsonData file ")
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

        
        flgActivity = false
        apiSuccesFlag = "1"
        refreshControl.isHidden = true
        refreshControl.isEnabled = true
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        appDelegate.flgForWebRefresh = true

        //DispatchQueue.global(qos: .background).async {
            //self.callWSOfWholeResponse()
            DispatchQueue.main.async {
                self.callWSOfHomeCacheResponse()
                self.callWSOfWholeResponse()
                self.CallGetOfflineLesson()
            }
        //}
        
        callWSNotificatnUpdate()
        callWSProgressUpdate()
    }

    func getUIForHome() {
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
                    
                    self.scroll_View.backgroundColor = UIColor().HexToColor(hexString: bgScreenColor)
                    
                    self.titleLbl.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                    self.viewNavBar.backgroundColor = UIColor().HexToColor(hexString: bgcolor!)
                    self.titleLbl.font = checkForFontType(fontStyle: fontstyle , fontSize: CGFloat(sizeInt))
                    menuImgView.image = menuImgView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    self.menuImgView.tintColor = UIColor().HexToColor(hexString: menu_icon_color!)
                    
                    if UserDefaults.standard.string(forKey: "offLineFlag") != nil{
                        if UserDefaults.standard.string(forKey: "offLineFlag") == "0"{
                            if validation.isConnectedToNetwork()  {
                                //imgOfFavMenu.image =  #imageLiteral(resourceName: "onlineImage")
                                imgOfFavMenu.image = UIImage.gifImageWithName("onlineGif")
                                //imgOfFavMenu.maskCircle(anyImage: imgOfFavMenu.image!)
                            }else {
                                imgOfFavMenu.image =  #imageLiteral(resourceName: "offlineImage")
                            }
                        }else {
                            imgOfFavMenu.image = imgOfFavMenu.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                            self.imgOfFavMenu.tintColor = UIColor().HexToColor(hexString: menu_icon_color!)
                        }
                    }else {
                        imgOfFavMenu.image = imgOfFavMenu.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                        self.imgOfFavMenu.tintColor = UIColor().HexToColor(hexString: menu_icon_color!)
                    }
                    
                    
                    self.noPostLbl.textColor = UIColor().HexToColor(hexString: bgcolor!)
                    
                    let helpBubbl = genarlSettings["help_bubble"] as! Dictionary<String,String>
                    let bblBgColor = helpBubbl["bgcolor"]
                    let txtBblClor = helpBubbl["txtcolorHex"]
                    let fontstyle1 = helpBubbl["fontstyle"]
                    let size1 = helpBubbl["size"]
                    let sizeInt1:Int = Int(size1!)!
                    let origImage = UIImage(named: "question");
                    let tintImg = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    btnQuestonMark.setBackgroundImage(tintImg, for: .normal)
                    btnQuestonMark.tintColor = UIColor().HexToColor(hexString: bblBgColor!)
                    btnQuestonMark.titleLabel?.font = checkForFontType(fontStyle: fontstyle1! , fontSize: CGFloat(sizeInt1 + 14))
                    btnQuestonMark.setTitleColor(UIColor().HexToColor(hexString: txtBblClor!), for: .normal)
                    commonElement = common_element
                }
            }
        } else {
            //self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func getUIForDrawer() {
        let status = getJsonData!["status"] as! String
        if status == "1" {
            if let data = getJsonData!["data"] as? [String:Any] {
                
                if let navigation_menu = data["navigation_menu"] as? [String:Any] {
                    let screen_bg_color = navigation_menu["screen_bg_color"] as! String
                    navigationMenu = navigation_menu
                    tblView.backgroundColor = UIColor().HexToColor(hexString: screen_bg_color)
                    
                    //Common Font Style
                    let common_element = data["common_element"] as! [String:Any]
                    let general_font = common_element["general_settings"] as? [String:Any]
                    if let title = general_font!["general_font"] as? Dictionary<String,String> {
                        let fontstyle = title["fontstyle"]
                        strFontStyle = fontstyle!
                    }
                    
                    if let version = navigationMenu["list_header"] as? Dictionary<String,String>{
                        let size = version["size"]
                        let txtcolorHex = version["txtcolorHex"]
                        let sizeInt:Int = Int(size!)!
                        
                        self.lblOfVersionName.font = checkForFontType(fontStyle: strFontStyle, fontSize: CGFloat(sizeInt))
                        self.lblOfVersionName.textColor = UIColor().HexToColor(hexString: txtcolorHex!)

                    }
                }
            }
        }  else {
            //self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        // let tappedImage = tapGestureRecognizer.view as! UIImageView
        menuOpen()
    }
    func notificationViewTapped(tapGestureRecognizer: UITapGestureRecognizer){
        menuHide()

    }
    @objc func profileViewTapped(tapGestureRecognizer: UITapGestureRecognizer){
        menuHide()
    }

    @IBAction func btnOfflineModeClk(_ sender: Any) {
        UserDefaults.standard.set("3", forKey: "ArticleVideoFlag")
        let offlineVC = self.storyboard?.instantiateViewController(withIdentifier: "OfflineCourseTemplateDetailVC") as! OfflineCourseTemplateDetailVC
        self.navigationController?.pushViewController(offlineVC, animated: true)
    }
    @IBAction func btnNoClick(_ sender: Any) {
        bgViewOfAlert.isHidden = true
    }
    @IBAction func btnYesClick(_ sender: Any) {
       
        bgViewOfAlert.isHidden = true
        if validation.isConnectedToNetwork()  {
            //MARK:- logOut API
            callWSlogOut()
        }
        else{
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    
    
    @IBAction func btnMenuPress(_ sender: Any){
        if validation.isConnectedToNetwork() {
            menuOpen()
        }else {
            btnMenu.isEnabled = false
        }
    }
    
    //MARK :- Swipe Gesture
    @objc func handleSwipe(gesture : UIPanGestureRecognizer){
        if(gesture.state == UIGestureRecognizerState.ended){
            
            //let velocity : CGPoint = gesture.velocity(in: slideView)
            let velocity : CGPoint = gesture.velocity(in: self.view)
            //Pan Left
            
            if(velocity.x > 0.0 && velocity.y == 0.0){
                
                //self.view.bringSubview(toFront: slideView)
                let transition: CATransition = CATransition()
                let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.duration = 0.5
                transition.timingFunction = timeFunc
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromLeft
                self.slideView.layer.add(transition, forKey: kCATransition)
                self.viewOfOfflineMode.layer.add(transition, forKey: kCATransition)
                self.viewNavBar.layer.add(transition, forKey: kCATransition)
                self.tblOfHomes.layer.add(transition, forKey: kCATransition)
                
                self.viewNavBar.frame.origin.x = self.tblView.frame.size.width
                self.tblOfHomes.frame.origin.x = self.tblView.frame.size.width
                self.viewOfOfflineMode.frame.origin.x = self.tblView.frame.size.width
                self.slideView.isHidden = false
            }
            else {
                self.slideView.isHidden = true
            }
            
            if(velocity.y > 0) {
                //print("UP")
            }
            else {
                //print("Down")
            }
        }
    }
    
    @objc func handleRightSwipe(gesture : UIPanGestureRecognizer){
       
    }
    
    func menuOpen(){
        
        //Set Profile Pic with Circle
        self.view.endEditing(true)
        self.slideView.isHidden = false
        
        if  self.viewNavBar.frame.origin.x == 0 && self.tblOfHomes.frame.origin.x == 0 {
            self.viewNavBar.frame.origin.x = self.tblView.frame.size.width
            self.tblOfHomes.frame.origin.x = self.tblView.frame.size.width
            self.viewOfOfflineMode.frame.origin.x = self.tblView.frame.size.width
            
        }
 
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.25
        transition.timingFunction = timeFunc
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.slideView.layer.add(transition, forKey: kCATransition)
        self.viewNavBar.layer.add(transition, forKey: kCATransition)
        self.tblOfHomes.layer.add(transition, forKey: kCATransition)
        self.viewOfOfflineMode.layer.add(transition, forKey: kCATransition)
    }
    
    func menuHide(){
       
        self.viewNavBar.frame.origin.x = self.view.frame.origin.x
        self.tblOfHomes.frame.origin.x = self.view.frame.origin.x
        self.viewOfOfflineMode.frame.origin.x = 0
        
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.25
        transition.timingFunction = timeFunc
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.slideView.layer.add(transition, forKey: kCATransition)
        self.viewOfOfflineMode.layer.add(transition, forKey: kCATransition)
        self.viewNavBar.layer.add(transition, forKey: kCATransition)
        self.tblOfHomes.layer.add(transition, forKey: kCATransition)
        self.slideView.isHidden = true
   }
    
    @IBAction func bb(_ sender: Any){
        menuHide()
    }

    func removeView(){
        self.popView.removeFromSuperview()
    }
    
    @IBAction func btnfavMenuClick(_ sender: Any) {
        
        if UserDefaults.standard.string(forKey: "offLineFlag") != nil{
            if UserDefaults.standard.string(forKey: "offLineFlag") == "0"{
                offlineAlert()
            }else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteMenus") as! FavouriteMenus
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionPush
                transition.subtype = kCAGravityTop
                transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
                view.window!.layer.add(transition, forKey: kCATransition)
                vc.delegate = self
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false, completion: nil)
            }
        }else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteMenus") as! FavouriteMenus
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCAGravityTop
            transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
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
                self.onlineFlow()
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
    
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)
        
        self.startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
        if refreshForLang == "2"{
            refreshForLang = "1"
            self.rerfTimeOut = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(HomeViewController.cancelRefresh), userInfo: nil, repeats: false)
        }else {
            self.timeOut = Timer.scheduledTimer(timeInterval: 25.0, target: self, selector: #selector(HomeViewController.cancelWeb), userInfo: nil, repeats: false)
        }
    }
    
    func stopActivityIndicator() {
        self.stopAnimating()
    }
    @objc func cancelWeb() {
        print("cancelWeb")
        if apiSuccesFlag == "1"{
            self.stopAnimating()
            self.refreshControl.endRefreshing()
        }
    }
    @objc func cancelRefresh(){
        self.stopActivityIndicator()
    }
    
    //MARK: Custum  Methods
    @objc func popViewCntller(){
        UserDefaults.standard.set("1", forKey: "popToRootController")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnQuestonMarkClick(_ sender: Any) {
        if self.appDelegate.helpData.count > 0 && UserDefaults.standard.bool(forKey: "helpData") {
            UserDefaults.standard.set("1", forKey: "ArticleVideoFlag")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogPostViewController") as! BlogPostViewController
            vc.dicMediaData = self.appDelegate.helpData
            vc.flgToShow = "Help"
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            self.view.makeToast((appDelegate.ArryLngResponSystm!["no_help_article_msg"] as? String)!)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(velocity.y>0) {
            UIView.animate(withDuration: 0.2, delay: 0, options:UIViewAnimationOptions.curveEaseIn, animations: {
                self.btnQuestonMark.alpha = 0.0// Here you will get the animation you want
            }, completion: { _ in
                self.btnQuestonMark.isHidden = true // Here you hide it when animation done
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.btnQuestonMark.alpha = 1.0// Here you will get the animation you want
            }, completion: { _ in
                self.btnQuestonMark.isHidden = false // Here you hide it when animation done
            })
        }
    }

}

// MARK: - Gesture Delegate
extension HomeViewController : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
}

// MARK: - TableView Delegate and DataSource
extension HomeViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int{
        if tableView == tblView {
            return self.headerArray.count + 1
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == tblView{
            if (section == 1){
                return self.cellTitleArr.count
            }
            else if (section == 2){
                return self.cellTitleArr2.count
            }else {
                return 0
            }
        }else {
            return self.arryWSData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if tableView == tblView{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "leftMenuCell") as! LeftMenuCell
            cell.selectionStyle = .none
            
            if indexPath.section == 1 {
                cell.titleLbl.text = self.cellTitleArr[indexPath.row]
            }else if indexPath.section == 2{
                cell.titleLbl.text = self.cellTitleArr2[indexPath.row]
            }
            
            //Common Font Style
            if let list_item = navigationMenu["list_item"] as? Dictionary<String,String> {
                let size = list_item["size"]
                let txtcolorHex = list_item["txtcolorHex"]
                let bgcolor = list_item["bgcolor"]
                let sizeInt:Int = Int(size!)!
                
                cell.titleLbl.font = checkForFontType(fontStyle: strFontStyle, fontSize: CGFloat(sizeInt))
                cell.titleLbl.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                cell.viewofCell.backgroundColor = UIColor().HexToColor(hexString: bgcolor!)
                self.lblOfVersionName.backgroundColor = UIColor().HexToColor(hexString: bgcolor!)
            }
            
            return cell
        }
        else {
            noPostLbl.isHidden = true
            let cell = tblOfHomes.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! HomeTableCell
            
            cell.imgOfNotifiction.isHidden = false
            cell.lblOfNotificationCount.isHidden = false
            let genarlSettings = commonElement["general_settings"] as! [String:Any]
            let general_font = genarlSettings["general_font"] as! [String:Any]
            let fontstyle = general_font["fontstyle"] as! String
            let bgScreenColor = genarlSettings["screen_bg_color"] as! String
            
            let currentDic = arryWSData[indexPath.row] as! [String:Any]
            
            //payment Failure == 1
            let paymentFlag = UserDefaults.standard.value(forKey: "paymentFlag") as! String
            if paymentFlag == "1"{
                if  indexPath.row == 0 {
                    cell.backgroundColor = UIColor().HexToColor(hexString: bgScreenColor)
                    cell.isUserInteractionEnabled = true
                }
            }else {
                let colorcode = currentDic["colorcode"] as? String
                let expiry_date = currentDic["expiry_date"] as? String
                if colorcode! != "" {
                    cell.backgroundColor = UIColor().HexToColor(hexString: colorcode!)
                }
                else {
                    cell.backgroundColor = UIColor().HexToColor(hexString: bgScreenColor)
                }
            }
            
            //Title for all comman screens
            if let title = genarlSettings["title"] as? Dictionary<String,String> {
                let size = title["size"]
                let txtcolorHex = title["txtcolorHex"]
                let fontstyle = title["fontstyle"]
                let sizeInt:Int = Int(size!)!
                
                cell.lblOftitle.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                cell.lblOftitle.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
            }
            
            //SubTitle for all comman screens
            if let subtitle = genarlSettings["subtitle"] as? Dictionary<String,String> {
                let size = subtitle["size"]
                let txtcolorHex = subtitle["txtcolorHex"]
                let fontstyle = subtitle["fontstyle"]
                let sizeInt:Int = Int(size!)!
                
                cell.lblOfDiscriptin.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                cell.lblOfDiscriptin.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                
            }
            
            //Notification for all comman screens
            if let notification_bubble = genarlSettings["notification_bubble"] as? Dictionary<String,String> {
                let size = notification_bubble["size"]
                let txtcolorHex = notification_bubble["txtcolorHex"]
                let fontstyle = notification_bubble["fontstyle"]
                let imgColor = notification_bubble["bgcolor"]
                let sizeInt:Int = Int(size!)!
                
                // Danyamic UI
                cell.imgOfNotifiction.tintImageColor(color: UIColor().HexToColor(hexString: imgColor!))
                cell.lblOfNotificationCount.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                cell.lblOfNotificationCount.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                cell.lblOfNotificationCount.font =  UIFont.boldSystemFont(ofSize: CGFloat(sizeInt))
            }
            
            //Progress for all comman screens
            if let progress = genarlSettings["highlight_status"] as? Dictionary<String,String> {
                let size = progress["size"]
                let txtcolorHex = progress["txtcolorHex"]
                let fontstyle = progress["fontstyle"]
                let bgColor = progress["bgcolor"]
                let sizeInt:Int = Int(size!)!
                
                cell.progreessView.progressTintColor = UIColor().HexToColor(hexString: bgColor!)
                
            }
            //count
            cell.progreessView.isHidden = true
            
            if ((currentDic["title"] as? String) != nil){
                let strngVlue = currentDic["title"] as? String
                cell.lblOftitle.text = strngVlue?.html2String
            }else {
                cell.lblOftitle.text = ""
            }
            
            if self.arryOfNotifcatnUpdte.count > 0{
                for  dic in (self.arryOfNotifcatnUpdte as? [[String:Any]])!{
                    if dic["id"] as? String == currentDic["id"] as? String && dic["itemType"] as? String == currentDic["itemType"] as? String && dic["type"] as? String == currentDic["type"] as? String{
                        if dic["count"] as? String == "" || dic["count"] as? String == " "{
                            cell.imgOfNotifiction.isHidden = true
                            cell.lblOfNotificationCount.isHidden = true
                        }else {
                            if (dic["count"] as? String) != "0"{
                                cell.imgOfNotifiction.isHidden = false
                                cell.lblOfNotificationCount.isHidden = false
                                cell.lblOfNotificationCount.text = dic["count"] as? String
                            }else {
                                cell.imgOfNotifiction.isHidden = true
                                cell.lblOfNotificationCount.isHidden = true
                            }
                        }
                    }
                }
            }else if currentDic.keys.contains("count") {
                cell.imgOfNotifiction.isHidden = true
                cell.lblOfNotificationCount.isHidden = true
            }else {
                cell.imgOfNotifiction.isHidden = true
                cell.lblOfNotificationCount.isHidden = true
            }
             
            //description
            if ((currentDic["description"] as? String) != nil){
                let strngVlue = currentDic["description"] as? String
                cell.lblOfDiscriptin.text = strngVlue?.html2String//htmlToString
            }else {
                cell.lblOfDiscriptin.text = ""
            }

            //Progress Bar
            if ((currentDic["type"] as? String) != nil){
                if currentDic["type"] as? String == "T"{
                    if currentDic.keys.contains("viewComlplete") {
                        if !(validation.checkNotNullParameter(checkStr: (currentDic["viewComlplete"] as? String)!)) && ((currentDic["viewComlplete"] as? String) != nil){
                            cell.progreessView.isHidden = false
                            for  dic in (self.arryOfProgressUpdte as? [[String:Any]])!{
                                if dic["courseID"] as? String == currentDic["id"] as? String{
                                    if dic["percent"] as? String == ""{
                                        let strintValue  = "\(currentDic["viewComlplete"] as! String)"
                                        let strProgressValue = Float(strintValue)
                                        cell.progreessView.progress = Float((strProgressValue)! / 100.00)
                                    }else {
                                        let strintValue  = "\(dic["percent"] as! String)"
                                        let strProgressValue = Float(strintValue)
                                        cell.progreessView.progress = Float((strProgressValue)! / 100.00)
                                    }
                                }
                            }
                        }else {
                            for  dic in (self.arryOfProgressUpdte as? [[String:Any]])!{
                                if dic["courseID"] as? String == currentDic["id"] as? String{
                                    if dic["percent"] as? String == ""{
                                        cell.progreessView.isHidden = true
                                    }else {
                                        let strintValue  = "\(dic["percent"] as! String)"
                                        let strProgressValue = Float(strintValue)
                                        cell.progreessView.progress = Float((strProgressValue)! / 100.00)
                                    }
                                }
                            }
                        }
                    }else {
                        
                    }
                }else {
                    cell.progreessView.isHidden = true
                }
            }
            
            //image
            if currentDic["icon"] as? String != nil{
                let imgUrl = currentDic["icon"] as? String
                
                let imageName = self.separateImageNameFromUrl(Url: imgUrl!)
                cell.imgOfMenu.backgroundColor = color.placeholdrImgColor
                if(self.chache.object(forKey: imageName as AnyObject) != nil){
                    cell.imgOfMenu.image = self.chache.object(forKey: imageName as AnyObject) as? UIImage
                }else{
                    if validation.checkNotNullParameter(checkStr: imgUrl!) == false {
                        Alamofire.request(imgUrl!).responseImage{ response in
                            if let image = response.result.value {
                                cell.imgOfMenu.image = image
                                self.chache.setObject(image, forKey: imageName as AnyObject)
                            }
                            else {
                                cell.imgOfMenu.backgroundColor = color.placeholdrImgColor
                            }
                        }
                    }else {
                        cell.imgOfMenu.backgroundColor = color.placeholdrImgColor
                    }
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == tblView{
            
            if (section == 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "Header1") as! LeftMenuHeader1Cell
                cell.selectionStyle = .none
                
                let data = getJsonData!["data"] as! [String:Any]
                let loginData = data["login"] as! [String:Any]
                
                var bgImge = ""
                if loginData.keys.contains("bgimageurl"){
                    bgImge = (loginData["bgimageurl"] as? String)!
                }
                if bgImge != "" {
                    let imageName = self.separateImageNameFromUrl(Url: bgImge)
                    cell.profImg.backgroundColor = UIColor().HexToColor(hexString: "#B2B2B2")
                    if(self.chache.object(forKey: imageName as AnyObject) != nil){
                        cell.profImg.image = self.chache.object(forKey: imageName as AnyObject) as? UIImage
                    }else{
                        if validation.checkNotNullParameter(checkStr: bgImge) == false {
                            Alamofire.request(bgImge).responseImage{ response in
                                if let image = response.result.value {
                                    cell.profImg.image = image
                                    self.chache.setObject(image, forKey: imageName as AnyObject)
                                    _ = UIImageJPEGRepresentation(image, 1)
                                }
                                else {
                                    cell.profImg.backgroundColor = UIColor().HexToColor(hexString: "#B2B2B2")
                                }
                            }
                        }else {
                            cell.profImg.backgroundColor = UIColor().HexToColor(hexString: "#B2B2B2")
                        }
                    }
                } else {
                    cell.profImg.backgroundColor = UIColor().HexToColor(hexString: "#B2B2B2")
                }
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileViewTapped(tapGestureRecognizer:)))
                cell.contentView.isUserInteractionEnabled = true
                cell.contentView.addGestureRecognizer(tapGestureRecognizer)
                
                return cell
            }else if (section == 1){
                let cell = tableView.dequeueReusableCell(withIdentifier: "header2") as! LeftMenuHeader2Cell
                cell.selectionStyle = .none
                
                if let title = navigationMenu["list_header"] as? Dictionary<String,String>{
                    let size = title["size"]
                    let txtcolorHex = title["txtcolorHex"]
                    let bgcolor = title["bgcolor"]
                    let sizeInt:Int = Int(size!)!
                    
                    cell.lblOfheader2Title.font = checkForFontType(fontStyle: strFontStyle, fontSize: CGFloat(sizeInt))
                    cell.lblOfheader2Title.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                    cell.viewOfHeader2.backgroundColor = UIColor().HexToColor(hexString: bgcolor!)

                }
                
                cell.lblOfheader2Title.text = headerArray[0]
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "header2") as! LeftMenuHeader2Cell
                cell.selectionStyle = .none
                
                if let title = navigationMenu["list_header"] as? Dictionary<String,String> {
                    let size = title["size"]
                    let txtcolorHex = title["txtcolorHex"]
                    let bgcolor = title["bgcolor"]
                    let sizeInt:Int = Int(size!)!
                    
                    cell.lblOfheader2Title.font = checkForFontType(fontStyle: strFontStyle, fontSize: CGFloat(sizeInt))
                    cell.lblOfheader2Title.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                    cell.viewOfHeader2.backgroundColor = UIColor().HexToColor(hexString: bgcolor!)
                }
                cell.lblOfheader2Title.text = headerArray[1]
                return cell
            }
           
        }
        else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        menuHide()
        if tableView == tblView{
            
                if (indexPath.section == 0){
                     
                }
                else if (indexPath.section == 1){
                    switch indexPath.row{
                    case 0:  // My Profile
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfile") as! MyProfile
                        self.navigationController?.pushViewController(vc, animated: true)
                    case 1:  //Language selection
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectLangauge") as! SelectLangauge
                        UserDefaults.standard.set(false, forKey: "isFirstLaunched")
                        vc.flagForBackBtn = "1"
                        self.navigationController?.pushViewController(vc, animated: true)
                       
                    /*case 1:  //About Us
                        print( "Manage subcripations ")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionsVC") as! SubscriptionsVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    case 1:  // LogOut
                        print( " Other setting")*/
                    default: break
                    }
                }else if (indexPath.section == 2){
                    switch indexPath.row{
                    case 0:  // Help
                        print("Help")
                        if self.appDelegate.helpData.count > 0 && UserDefaults.standard.bool(forKey: "helpData") {
                            UserDefaults.standard.set("1", forKey: "ArticleVideoFlag")
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogPostViewController") as! BlogPostViewController
                            vc.dicMediaData = self.appDelegate.helpData
                            vc.flgToShow = "Help"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else {
                            self.view.makeToast((appDelegate.ArryLngResponSystm!["no_help_article_msg"] as? String)!)
                            //"No article available for HELP."
                        }
                    case 1:  //Legal
                        print( "Legal")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogPostViewController") as! BlogPostViewController
                        UserDefaults.standard.set("1", forKey: "ArticleVideoFlag")
                        vc.strTitle = "Legal"
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    case 2:  //About Us
                        print("About Us")
                        UserDefaults.standard.set("1", forKey: "ArticleVideoFlag")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogPostViewController") as! BlogPostViewController
                        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutUs") as! AboutUs
                        vc.strTitle = "About Us"
                        self.navigationController?.pushViewController(vc, animated: true)
                    case 3:  //Offline mode
                        
                        if validation.isConnectedToNetwork()  {
                            //imgOfFavMenu.image = #imageLiteral(resourceName: "onlineImage")
                            imgOfFavMenu.image = UIImage.gifImageWithName("onlineGif")
                            //imgOfFavMenu.maskCircle(anyImage: imgOfFavMenu.image!)
                        }else {
                            imgOfFavMenu.image = #imageLiteral(resourceName: "offlineImage")
                        }
                        offlineFlow()
                        
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                        for aViewController in viewControllers {
                            if aViewController is HomeViewController {
                                self.navigationController!.popToViewController(aViewController, animated: true)
                                break
                            }
                        }
                    case 4:  // LogOut
                        
                        self.navigationController?.navigationBar.isHidden = true
                        let alrtTitleStr = NSMutableAttributedString(string: (appDelegate.ArryLngResponeCustom!["logout"] as? String)!)
                        //"Logout?"
                        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                        
                        let alrtMessage = NSMutableAttributedString(string: (appDelegate.ArryLngResponSystm!["logout_msg"] as? String)!)
                        //"Are you sure you want to logout?"
                        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                        
                        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                        alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                        alertController.setValue(alrtMessage, forKey: "attributedMessage")
                        
                        //let alertController = UIAlertController(title: "Logout?", message: "Are you sure you want to \nlogout?", preferredStyle: .alert)
                        //"Yes"
                        let btnYes = UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["yes"] as? String)!, style: .default, handler: { action in
                            if validation.isConnectedToNetwork()  {
                                self.callWSlogOut()
                            }else{
                                self.view.makeToast(string.noInternateMessage2)
                            }
                        })
                        //"No"
                        let btnNo = UIAlertAction(title: (appDelegate.ArryLngResponeCustom!["no"] as? String)!, style: .default, handler: { action in
                            
                        })
                        alertController.addAction(btnNo)
                        alertController.addAction(btnYes)
                        self.present(alertController, animated: true, completion: nil)
                        
                    default: break
                        
                    }
                }else {
                    print("other ")
            }
        }
        else {
            
            let currentDic = arryWSData[indexPath.row] as! [String:Any]
            
            if((currentDic["type"] as? String) != nil){
                if currentDic["type"] as? String == "M"{
                    //call getHomemenuList API with ID ==> PDF page no 47 >>> call CoursesList
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CoursesList") as! CoursesList
                    vc.strMenuId = (currentDic["id"] as? String)!
                    vc.strTitle = (currentDic["title"] as? String)!
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else if currentDic["type"] as? String == "T"{
                    if((currentDic["itemType"] as? String) != nil){
                        if currentDic["itemType"] as? String == "1"{ //itemType == 1 for corses
                            if ((currentDic["template_type"] as? String) != nil){
                                if currentDic["template_type"] as? String == "D"{
                                    //call getCoursetopiclisting API ==>PDF page no 49-51 >>> DetailViewController
                                    self.navigationController?.navigationBar.isHidden = false
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                                    vc.strCourseId = (currentDic["id"] as? String)!
                                    vc.strTitle = (currentDic["title"] as? String)!
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }else if currentDic["template_type"] as? String == "F"{
                                    //getallCourseData API ==>PDF page no 53 >>> CourseTemplateDetails
                                    UserDefaults.standard.set("0", forKey: "ArticleVideoFlag")
                                    let nextVC = storyboard?.instantiateViewController(withIdentifier: "CourseTemplateDetails") as! CourseTemplateDetails
                                    nextVC.StrCourseCatgryId = (currentDic["id"] as? String)!
                                    for  dic in (self.arryOfProgressUpdte as? [[String:Any]])!{
                                        //let courseId = dic["courseID"] as! String
                                        if dic["courseID"] as? String == currentDic["id"] as? String {
                                            nextVC.StrCourseTopicId = (dic["topicID"] as? String)!
                                            break
                                        }
                                    }
                                    self.navigationController?.pushViewController(nextVC, animated: true)
                                }
                            }
                        }else if currentDic["itemType"] as? String == "2"{ //itemType == 2 for Blog
                            UserDefaults.standard.set("1", forKey: "ArticleVideoFlag")
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogPostViewController") as! BlogPostViewController
                            vc.strMenuId = (currentDic["id"] as? String)!
                            vc.dicMediaData = arryWSData[indexPath.row] as! NSDictionary
                            vc.strTitle = (currentDic["title"] as? String)!
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerArray[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if tableView == tblView{
           
            if (section == 0){
                return 280
            }
            else if (section == 1){
                return 30
            }else {
                return 30
            }
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
       
        if tableView == tblView{
            return 45
        }
        else {
            return 89
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
//MARK:- favMenuDelagte
extension HomeViewController : favMenuDelagte {
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
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CoursesList") as! CoursesList
                vc.strMenuId = (SelecteItem["id"] as? String)!
                vc.strTitle = (SelecteItem["title"] as? String)!
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if SelecteItem["type"] as? String == "T"{
                if((SelecteItem["itemType"] as? String) != nil){
                    if SelecteItem["itemType"] as? String == "1"{ //itemType == 1 for corses
                        if ((SelecteItem["template_type"] as? String) != nil){
                            if SelecteItem["template_type"] as? String == "D"{
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                                vc.strCourseId = (SelecteItem["id"] as? String)!
                                vc.strTitle = (SelecteItem["title"] as? String)!
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            }else if SelecteItem["template_type"] as? String == "F"{
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
//MARK:- WS Parsing
extension HomeViewController {
    
    //MARK: WS Get Home List
    func callWSOfHome(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateTimeStr = formatter.string(from: Date())
        
        //URL : http://27.109.19.234/app_builder/index.php/api/getHomemenuList?appclientsId=1&userId=1&userPrivateKey=P6HwAapNVu4WK1Ts&appId=1&menuId=1
        let paymentFlag = UserDefaults.standard.value(forKey: "paymentFlag") as! String
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "menuId" : "0",
                          "appId" : userInfo.appId,
                          "paymentFlag": paymentFlag,
                          "datetime" : dateTimeStr]
        
        print("getHomemenuList I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getHomemenuList?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        self.noDataView.removeFromSuperview()
        if validation.isConnectedToNetwork() == true {
            if flgActivity{
                self.startActivityIndicator()
            }
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSOfHomeList(strURL: strURL, dictionary: dictionary )
        }else{
            stopActivityIndicator()
            self.refreshControl.endRefreshing()
            self.noPostLbl.isHidden = false
            self.noPostLbl.text = string.noInternateMessage2
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOfHomeList(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            //print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                let paymentFlag = UserDefaults.standard.value(forKey: "paymentFlag") as! String
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.refreshControl.endRefreshing()
                    //"PaymentFailure"
                    self.arryWSData.removeAll()
                    if let paymentFail = JSONResponse["PaymentFailure"] as? [Any]{
                        self.noPostLbl.isHidden = true
                        if paymentFlag == "1" {
                            self.arryWSData.append(paymentFail.first as Any)
                        }
                        if let arrayData = JSONResponse["homeList"] as? [Any]{
                            for homelist in arrayData {
                                self.arryWSData.append(homelist as Any)
                            }
                            self.tblOfHomes.reloadData()
                            self.heightOfTbl.constant = CGFloat(self.arryWSData.count * 89)// + self.heightOfImge.constant
                        }
                    }
                    else{
                        self.noPostLbl.isHidden = false
                        self.noPostLbl.text = string.noDataFoundMsg
                    }
                    
                    if JSONResponse.keys.contains("course_topic_limit") {
                        let courTopicLimitStr = JSONResponse["course_topic_limit"] as? String
                        UserDefaults.standard.set(courTopicLimitStr, forKey: "courseTopicLimit")
                    }
                    
                    if let helpDic = JSONResponse["help"] as? NSArray{
                        if helpDic.count > 0 {
                            self.appDelegate.helpData = helpDic[0] as! NSDictionary
                            UserDefaults.standard.set(true, forKey: "helpData")
                        }else {
                            UserDefaults.standard.set(false, forKey: "helpData")
                        }
                    }
                    UserDefaults.standard.synchronize()
                }
            }else{
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
                        self.arryWSData.removeAll()
                        self.noDataView.removeFromSuperview()
                        self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: (JSONResponse["title"] as? String)!, lableNoInternate: ((JSONResponse["description"] as? String)! + "\n\(string.errodeCodeString) = [\((JSONResponse["systemErrorCode"] as? String)!)]"))
                        self.heightOfTbl.constant = self.view.frame.height
                        self.tblOfHomes.addSubview(self.noDataView)
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
            self.refreshControl.endRefreshing()
            print("error: ",error)
            DispatchQueue.main.async{
                self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: "", lableNoInternate: string.someThingWrongMsg)
                self.tblOfHomes.addSubview(self.noDataView)
            }
        })
    }
    
    //MARK: WS Get FavMenuList
    func callWSOfFavMenu(){
        
        //URL : http://27.109.19.234/app_builder/index.php/api/getfavouriteMenulist?appclientsId=1&userId=1&userPrivateKey=P6HwAapNVu4WK1Ts&appId=1
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateTimeStr = formatter.string(from: Date())
        
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "datetime" : dateTimeStr]
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getfavouriteMenulist?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!

        if validation.isConnectedToNetwork() == true {
            //startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            //apiSuccesFlag = "1"
            self.callWSOfFavList(strURL: strURL, dictionary: dictionary )
        }else{
            //stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOfFavList(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            //self.apiSuccesFlag = "2"
            //print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    //self.stopActivityIndicator()
                    if let arrayData = JSONResponse["homeList"] as? [Any]{
                        self.appDelegate.arryFavMenuData = arrayData
                    }
                    else{
                        self.noPostLbl.text = string.noDataFoundMsg
                    }
                }
            }
            else{
                let status = JSONResponse["status"] as? String
                switch status!{
                case "0":
                    print("error2: ")
                    if (JSONResponse["errorCode"] as? String) == userInfo.logOuterrorCode {
                        //When Parameter Missing
                        self.view.makeToast((JSONResponse["message"] as? String)!)
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                        for aViewController in viewControllers {
                            if aViewController is Login {
                                self.navigationController!.popToViewController(aViewController, animated: true)
                            }
                        }
                    }else {
                        print("error: ",(JSONResponse["message"] as? String) ?? "error")
                    }
                    break
                default:
                    print("error1: ",(JSONResponse["message"] as? String) ?? "error");
                }
            }
        }, failure: { (error) in
            print("error: ",error)
        })
    }
    
    
    //MARK: WS Get logOut
    func callWSlogOut(){
        
        //URL : https://cmspreview.membrandt.com/api/logout?appclientsId=1&userId=1&userPrivateKey=yJ4iF4r8z2EabBTq&appId=1
        
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId]
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "logout?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            self.callWSOflogOut(strURL: strURL, dictionary: dictionary )
        }else{
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOflogOut(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            if JSONResponse["status"] as? String == "1"{
                userInfo.userPrivateKey = ""
                UserDefaults.standard.set("", forKey: "private_key")
                UserDefaults.standard.synchronize()
                DispatchQueue.main.async {
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                    for aViewController in viewControllers {
                        if aViewController is Login {
                            //isVCFound = true
                            self.navigationController!.popToViewController(aViewController, animated: true)
                        }
                    }
                }
            }
            else{
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                for aViewController in viewControllers {
                    if aViewController is Login {
                        self.navigationController!.popToViewController(aViewController, animated: true)
                    }
                }
            }
        }, failure: { (error) in
            print("error: ",error)
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers
            for aViewController in viewControllers {
                if aViewController is Login {
                    self.navigationController!.popToViewController(aViewController, animated: true)
                }
            }
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
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "checkappVersion?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            //apiSuccesFlag = "1"
            self.callWSOfForceFullyAppUdpate(strURL: strURL, dictionary: dictionary as! Dictionary<String, String> )
        }else{
            //self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    
    func callWSOfForceFullyAppUdpate(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            if JSONResponse["status"] as? String == "1"{
                if JSONResponse["version"] as? String == "1"{
                    
                    let alrtTitleStr = NSMutableAttributedString(string: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String))
                    alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                    
                    let alrtMessage = NSMutableAttributedString(string: (self.appDelegate.ArryLngResponSystm!["new_version_released_msg"] as? String)!)
                    alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
                    
                    let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                    alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
                    alertController.setValue(alrtMessage, forKey: "attributedMessage")
                    
                    alertController.addAction(UIAlertAction(title: "UPDATE", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                        if let url = URL(string: "itms-apps://itunes.apple.com/app/id" + userInfo.appleId),
                        UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }else {
                    
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
    
    //MARK:- API of GetProgress Update
    func callWSProgressUpdate(){
        //URL: http://27.109.19.234/app_builder/index.php/api/getCoursePercentage?appclientsId=1&userId=2&userPrivateKey=zJSn1gY5PvDop9Oy&appId=1&courseId=5
        
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "courseId" : ""] as [String : Any]
        
        print("I/P getCoursePercentage :",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getCoursePercentage?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSProgressStatus(strURL: strURL, dictionary: dictionary as! Dictionary<String, String>)
        }else{
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSProgressStatus(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            //print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.arryOfProgressUpdte = JSONResponse["response"] as! [Any]
                    self.tblOfHomes.reloadData()
                }
            }
            else{
                let status = JSONResponse["status"] as? String
                self.refreshControl.endRefreshing()
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
            self.refreshControl.endRefreshing()
            print("error: ",error)
            
        })
    }
    
    
    //MARK:- API of UpdateNotfication
    func callWSNotificatnUpdate(){
        //URL: http://27.109.19.234/app_builder/index.php/api/getallmenuitemListCount?appclientsId=1&userId=7&userPrivateKey=LTRNO4SdPK1JYq43&appId=1&menuId=0
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateTimeStr = formatter.string(from: Date())
        
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "menuId" : "0",
                          "datetime" : dateTimeStr] as [String : Any]
        
        print("I/P getallmenuitemListCount :",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getallmenuitemListCount?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            //self.startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSNotoifcatnUpdate(strURL: strURL, dictionary: dictionary as! Dictionary<String, String>)
        }else{
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSNotoifcatnUpdate(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            //print("JSONResponse Notification Count", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    //self.stopActivityIndicator()
                    self.arryOfNotifcatnUpdte = JSONResponse["Home"] as! [Any]
                    self.tblOfHomes.reloadData()
                }
            }
            else{
                let status = JSONResponse["status"] as? String
                //self.stopActivityIndicator()
                self.refreshControl.endRefreshing()
                switch status!{
                case "0":
                    print("error2: ",status!)
                    break
                default:
                    //self.view.makeToast((JSONResponse["message"] as? String)!)
                    print("error1: ",status!);
                }
            }
        }, failure: { (error) in
            self.apiSuccesFlag = "2"
            //self.stopActivityIndicator()
            //self.refreshControl.endRefreshing()
            print("error: ",error)
            
        })
    }
}

// CACHE API
extension HomeViewController{
    
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
        self.noDataView.removeFromSuperview()
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
            //print("getallmenuitemList", JSONResponse["status"] as? String)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    if JSONResponse.keys.contains("course_topic_limit") {
                        let courTopicLimitStr = JSONResponse["course_topic_limit"] as? String
                        UserDefaults.standard.set(courTopicLimitStr, forKey: "courseTopicLimit")
                    }
                    
                    self.refreshControl.endRefreshing()
                    self.stopActivityIndicator()
                    self.saveToJsonFile(jsonArray: JSONResponse)
                }
            }else{
                //self.callCacheJson()
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
                                    }else {
                                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "SelectLangauge") as! SelectLangauge
                                        UserDefaults.standard.set("1", forKey: "popToRootController")
                                        let nav = UINavigationController.init(rootViewController: viewController)
                                        nav.navigationBar.isTranslucent = false
                                        UIApplication.shared.keyWindow?.rootViewController = nav
                                    }
                                }
                            }
                        })
                        alertController.addAction(btnOK)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }else {
                        //self.errorCodeAlert(title: (JSONResponse["title"] as? String)!, description: (JSONResponse["description"] as? String)!, errorCode: (JSONResponse["systemErrorCode"] as? String)!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)
                        self.arryWSData.removeAll()
                        self.noDataView.removeFromSuperview()
                        self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: (JSONResponse["title"] as? String)!, lableNoInternate: ((JSONResponse["description"] as? String)! + "\n\(string.errodeCodeString) = [\((JSONResponse["systemErrorCode"] as? String)!)]"))
                        self.heightOfTbl.constant = self.view.frame.height
                        self.tblOfHomes.addSubview(self.noDataView)
                    }
                    break
                default:
                    self.view.makeToast((JSONResponse["message"] as? String)!)
                    print("error1: ");
                }
            }
        }, failure: { (error) in
            self.apiSuccesFlag = "2"
            self.refreshControl.endRefreshing()
            self.stopActivityIndicator()
            print("error: ",error)
            DispatchQueue.main.async{
                self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: "", lableNoInternate: string.someThingWrongMsg)
                self.tblOfHomes.addSubview(self.noDataView)
            }
        })
    }
    
    //MARK: New WS For getJson Caching
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
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSOfGetWholeResponse(strURL: strURL, dictionary: dictionary as! Dictionary<String, String> )
        }else{
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    
    func callWSOfGetWholeResponse(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            //print("getJson", JSONResponse["status"] as? String)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.saveToJsonFileGetJson(jsonArray: JSONResponse)
                }
            }
            else{
                
                let status = JSONResponse["status"] as? String
                self.stopActivityIndicator()
                self.refreshControl.endRefreshing()
                switch status!{
                case "0":
                    print("error2: ")
                    //"Sorry We Are Unable To Find Your ID \nAssociated With Your Profile."
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
                                    }else {
                                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "SelectLangauge") as! SelectLangauge
                                        UserDefaults.standard.set("1", forKey: "popToRootController")
                                        let nav = UINavigationController.init(rootViewController: viewController)
                                        nav.navigationBar.isTranslucent = false
                                        UIApplication.shared.keyWindow?.rootViewController = nav
                                    }
                                }
                            }
                        })
                        
                        alertController.addAction(btnOK)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }else {
                         print("error 0 ")
                    }
                    break
                default:
                    self.view.makeToast((JSONResponse["message"] as? String)!)
                    print("error1: ");
                }
            }
        }, failure: { (error) in
            self.apiSuccesFlag = "2"
            print("error: ",error)
            self.refreshControl.endRefreshing()
            DispatchQueue.main.async{
                self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: "", lableNoInternate: string.someThingWrongMsg)
                self.view.makeToast(string.someThingWrongMsg)
            }
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
            //print("Refresh getOfflineLesson", JSONResponse)
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
    
    //Local Storage of Home course json data
    func saveToJsonFile(jsonArray:[String:Any])  {
        
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("HomeCourseJson.json")
        print(#function,fileUrl)
        // Transform array into data and save it into file
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
            try data.write(to: fileUrl, options: [])
            self.callCacheJson()
        } catch {
            print(error)
        }
    }
    
    //Local Storage of all json data
    func saveToJsonFileGetJson(jsonArray:[String:Any])  {
        
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("JsonData.json")
        print(#function,fileUrl)
        // Transform array into data and save it into file
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
            try data.write(to: fileUrl, options: [])
            callFavCache()
        } catch {
            print(error)
        }
    }
}


