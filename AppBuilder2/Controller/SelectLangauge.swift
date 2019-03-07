//
//  SelectLangauge.swift
//  AppBuilder2
//
//  Created by jaydeep on 03/07/18.
//  Copyright © 2018 VISHAL. All rights reserved.
//

import UIKit
import Alamofire

class SelectLangauge: UIViewController,NVActivityIndicatorViewable {
    
    @IBOutlet weak var collectnOfLang: UICollectionView!
    @IBOutlet weak var btnNext: UIButton!
    
    var btnMenu:UIButton!
    var btnBack:UIButton!
    var getJsonData: [String:Any]?
    var commonElement = [String:Any]()
    var appDelegate : AppDelegate!
    var temSelcArry : [String]!
    var selectedIndexLang = Int()
    var bgcolor = ""
    var bgColorNextBtn = ""
    var arryOflang : [Any] = []
    var noDataView = UIView()
    var flagForBackBtn = ""
    var strLangID = ""
    var apiSuccesFlag = ""
    var timeOut: Timer!
    var strngFrom = ""
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var chache:NSCache<AnyObject, AnyObject>!

    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.isHidden = true
        setBackBtn()
        setNavigationBtn()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        getJsonData =  appDelegate.jsonData
        self.chache = NSCache()
        
        if userInfo.isMultiLang == "0"{
            UserDefaults.standard.set("0", forKey: "popToRootController")
            self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "Login"))!, animated: false)
        }else if flagForBackBtn != "2" && flagForBackBtn != "1"{
            if UserDefaults.standard.string(forKey: "strlanguageID") != nil {
                strLangID = UserDefaults.standard.string(forKey: "strlanguageID")!
                UserDefaults.standard.set("0", forKey: "popToRootController")
                    self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "Login"))!, animated: false)
            }else {
                strLangID = "1"
            }
        }
     }
    
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)
        
        self.startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
        self.timeOut = Timer.scheduledTimer(timeInterval: 25.0, target: self, selector: #selector(Login.cancelWeb), userInfo: nil, repeats: false)
    }
    
    func stopActivityIndicator() {
        self.stopAnimating()
    }
    override func viewWillAppear(_ animated: Bool) {
        let flag = UserDefaults.standard.bool(forKey: "isFirstLaunched")
        if (flag == true) || (UserDefaults.standard.string(forKey: "popToRootController") == "1"){
            UserDefaults.standard.set("0", forKey: "popToRootController")
               self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "Login"))!, animated: false)
        }
        
        UIApplication.shared.isStatusBarHidden = false
        //MARK: call ws
        getUISettingWS()
        callWSGetLang()
        
        self.btnMenu.isHidden = true
        
        var strTitle = ""
        
        if flagForBackBtn == "1"{
            self.btnBack.isHidden = false
            strTitle = (appDelegate.ArryLngResponeCustom!["Change_language"] as? String)!
            //self.btnNext.setTitle((appDelegate.ArryLngResponeCustom!["save"] as? String)!, for: .normal)
            
        }else if flagForBackBtn == "2" {
            strTitle = (appDelegate.ArryLngResponeCustom!["select_language"] as? String)!
            self.btnBack.isHidden = false
            //self.btnNext.setTitle("SAVE", for: .normal)
        }else {
            strTitle = "Select Language"
            self.btnBack.isHidden = true
            //self.btnNext.setTitle("SAVE", for: .normal)
        }
        
        if strTitle.count > 28{
            let startIndex = strTitle.index(strTitle.startIndex, offsetBy: 28)
            self.title = String(strTitle[..<startIndex] + "..")
        }else {
            self.title = strTitle
        }
        
        //MARK: Read from Local
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("LangDataJson.json")
        if FileManager.default.fileExists(atPath: documentsURL.relativePath) {
            //appDelegate.ArryLngResponSystm?.removeAll()
            //appDelegate.ArryLngResponeCustom?.removeAll()
            appDelegate.ArryLngResponSystm = retrieveLangDataFile()["responseSystem"] as? [String:Any]
            appDelegate.ArryLngResponeCustom = retrieveLangDataFile()["responseCustom"] as? [String:Any]
        }else {
            /*if !UserDefaults.standard.bool(forKey: "isFirstLaunched"){//flagForBackBtn == "1" || flagForBackBtn == "2"{
                callWSGetLangData()
            }*/
        }
    }
    
    func getUISettingWS(){
        if getJsonData != nil{
            activityIndicator.isHidden = true
            getUIForSelectLanguag()
        }else {
            self.activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            callWsOfUI()
        }
    }
    
    func setBackBtn() {
        let origImage = UIImage(named: "back");
        btnBack = UIButton(frame: CGRect(x: 0, y:0, width:28,height: 34))
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
        UserDefaults.standard.set(true, forKey: "LeftMenuSelectLang")
        self.navigationController?.navigationBar.isHidden = true
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
    
    func fetchLangData(){
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("LangDataJson.json")
        if FileManager.default.fileExists(atPath: documentsURL.relativePath) {
            appDelegate.ArryLngResponSystm?.removeAll()
            appDelegate.ArryLngResponeCustom?.removeAll()
            
            appDelegate.ArryLngResponSystm = retrieveLangDataFile()["responseSystem"] as? [String:Any]
            appDelegate.ArryLngResponeCustom = retrieveLangDataFile()["responseCustom"] as? [String:Any]
        }
    }
    
    @IBAction func btnNextClick(_ sender: Any) {
        
        UserDefaults.standard.set(self.strLangID, forKey: "strlanguageID")
        UserDefaults.standard.synchronize()
        
        callWSGetLangData()
    }
    
    func getUIForSelectLanguag() {
        var status = ""
        if getJsonData != nil {
            status = getJsonData!["status"] as! String
        }else {
            status = "0"
        }
        
        if status == "1" {
            if let data = getJsonData!["data"] as? [String:Any] {
                if let common_element = data["common_element"] as? [String:Any] {
                    let navigation_bar = common_element["navigation_bar"] as! Dictionary<String,String>
                    let size = navigation_bar["size"]
                    bgcolor = navigation_bar["bgcolor"]!
                    let txtcolorHex = navigation_bar["txtcolorHex"]
                    let menu_icon_color = navigation_bar["menu_icon_color"]
                    let sizeInt:Int = Int(size!)!
                    
                    let genarlSettings = common_element["general_settings"] as! [String:Any]
                    let general_font = genarlSettings["general_font"] as! [String:Any]
                    let fontstyle = general_font["fontstyle"] as! String
                    let bgScreenColor = genarlSettings["screen_bg_color"] as! String
                    self.view.backgroundColor = UIColor().HexToColor(hexString: bgScreenColor)
                    
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor().HexToColor(hexString: txtcolorHex!),NSAttributedStringKey.font: checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(sizeInt))]
                    
                    self.navigationController?.navigationBar.barTintColor = UIColor().HexToColor(hexString: bgcolor)
                    self.navigationController?.navigationBar.backgroundColor = UIColor().HexToColor(hexString: bgcolor)
                    
                    self.btnMenu.tintColor = UIColor().HexToColor(hexString: menu_icon_color!)
                    self.btnBack.tintColor = UIColor().HexToColor(hexString: menu_icon_color!)
                    
                    //Next button
                    let loginData = data["login"] as! [String:Any]
                    if let btnFiled = loginData["login_button"] as? Dictionary<String,String>{
                        let size = btnFiled["size"]
                        let txtcolorHex = btnFiled["txtcolorHex"]
                        let fontstyle = btnFiled["fontstyle"]
                        self.bgColorNextBtn = btnFiled["bgcolor"]!
                        
                        let sizeInt1:Int = Int(size!)!
                        self.btnNext.titleLabel?.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt1))
                        self.btnNext.setTitleColor(UIColor().HexToColor(hexString: txtcolorHex!), for: .normal)
                        self.btnNext.backgroundColor = UIColor().HexToColor(hexString: self.bgColorNextBtn)
                    }
                    commonElement = common_element
                }
            }
        } else {
            self.view.makeToast(string.noInternateMessage2)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func cancelWeb() {
        print("cancelWeb")
        if apiSuccesFlag == "1"{
            self.stopAnimating()
        }
    }
}

//MARK:- UICollectionView Delegate
extension SelectLangauge : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return self.arryOflang.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectnOfLang.dequeueReusableCell(withReuseIdentifier: "langCell", for: indexPath) as! CollectionViewCell
        
        let genarlSettings = commonElement["general_settings"] as! [String:Any]
        let fontSize = genarlSettings["general_fontsize"] as? Dictionary<String,String>
        let size = fontSize!["medium"]
        let sizeInt:Int = Int(size!)!
        let general_font = genarlSettings["general_font"] as! Dictionary<String,String>
        let fontstyle = general_font["fontstyle"]
        let generalTxtColor = general_font["txtcolorHex"]
        
        cell.lblOfLangugeName.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
        cell.lblOfLangugeName.textColor = UIColor().HexToColor(hexString: generalTxtColor!)
        
        
        let dic = arryOflang[indexPath.row] as! [String:String]
        cell.lblOfLangugeName.text = dic["languageName"]
        if temSelcArry[indexPath.row] == "1"{
            cell.bgView.backgroundColor = UIColor().HexToColor(hexString: "F2F2F2")
            self.strLangID = dic["languageId"]!
        }else {
            cell.bgView.backgroundColor = UIColor.clear
        }
        
        if dic["languageImage"] != nil{
            let imgUrl = dic["languageImage"]
            
            let imageName = self.separateImageNameFromUrl(Url: imgUrl!)
            cell.imgOfFlag.backgroundColor = UIColor(red: 85.0/255.0, green:  85.0/255.0, blue:  85.0/255.0, alpha: 1.0)
            
            if(self.chache.object(forKey: imageName as AnyObject) != nil){
                cell.imgOfFlag.image = self.chache.object(forKey: imageName as AnyObject) as? UIImage
            }else{
                if validation.checkNotNullParameter(checkStr: imgUrl!) == false {
                    Alamofire.request(imgUrl!).responseImage{ response in
                        if let image = response.result.value {
                            cell.imgOfFlag.image = image
                            self.chache.setObject(image, forKey: imageName as AnyObject)
                        }
                        else {
                            cell.imgOfFlag.backgroundColor = UIColor().HexToColor(hexString: "F2F2F2")
                        }
                    }
                }else {
                    cell.imgOfFlag.backgroundColor = UIColor().HexToColor(hexString: "555555")
                }
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = (UIScreen.main.bounds.size.width/2) - 20
        return CGSize(width: width, height:65)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let dic = arryOflang[indexPath.row] as! [String:String]
        let langID = dic["languageId"]
        self.strLangID = langID!
        UserDefaults.standard.set(dic["languageName"]!, forKey: "StrlanguageName")
        UserDefaults.standard.set(dic["languageImage"]!, forKey: "StrlanguageImage")
        
        
        temSelcArry = Array(repeating: "0", count: self.arryOflang.count)
        temSelcArry[indexPath.row] = "1"
        self.collectnOfLang.reloadData()
        
        UserDefaults.standard.set(self.strLangID, forKey: "strlanguageID")
        UserDefaults.standard.synchronize()
        
        callWSGetLangData()
    }
    
}

//MARK: - API Parsing
extension SelectLangauge  {
    
    //MARK: - Lanuage list API
    func callWSGetLang(){
        
        //URL :: http://103.51.153.235/app_builder/index.php/api/getLanguages?appclientsId=1&appId=1&osType=1
        
        let dictionary = ["appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "osType" : "2"] as [String : Any]
        
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getLanguages?"
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            self.startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSOfGetLangList(strURL: strURL, dictionary: dictionary as! Dictionary<String, String> )
        }else{
            stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    
    func callWSOfGetLangList(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            self.stopActivityIndicator()
            print("responces ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                if let arrayData = JSONResponse["response"] as? [Any]{
                    self.arryOflang = arrayData
                    self.temSelcArry = Array(repeating: "0", count: self.arryOflang.count)
                    if UserDefaults.standard.string(forKey: "strlanguageID") != nil{
                        for i in 0..<self.arryOflang.count {
                            let dic = self.arryOflang[i] as! [String:String]
                            if dic["languageId"] == UserDefaults.standard.string(forKey: "strlanguageID"){
                                self.temSelcArry[i] = "1"
                                break
                            }
                        }
                    }
                    self.collectnOfLang.reloadData()
                }else {
                    self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: "", lableNoInternate: string.noDataFoundMsg)
                    self.collectnOfLang.addSubview(self.noDataView)
                }
            }else{
                print("error in API ")
            }
        }, failure: { (error) in
            self.stopActivityIndicator()
            self.apiSuccesFlag = "2"
            print("Fails ",error)
        })
    }
    //MARK: - Lanuage Data
    func callWSGetLangData(){
        
        //URL : http://103.51.153.235/app_builder/index.php/api/getLabels?languageId=2&appclientsId=1&userId=1&userPrivateKey=fXy1hB42Dc8Pw3E8&appId=1&osType=0
        var strUserId = ""
        var strPrvtKey = ""
        if flagForBackBtn == "1"{
            strUserId = userInfo.userId
            strPrvtKey = userInfo.userPrivateKey
        }else {
            strUserId = ""
            strPrvtKey = ""
        }
        
        let dictionary = ["appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "languageId" : self.strLangID,
                          "userId" : strUserId,
            "userPrivateKey" : strPrvtKey,
            "osType" : "2"] as [String : Any]
        
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getLabels?"
        print("url ",strURL,"dic : ",dictionary)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            self.startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSOfGetLangData(strURL: strURL, dictionary: dictionary as! Dictionary<String, String> )
        }else{
            self.stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    
    func callWSOfGetLangData(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            self.stopActivityIndicator()
            if JSONResponse["status"] as? String == "1"{
                
                if self.flagForBackBtn == "1"{
                    //From Home screen
                    let manager = FileManager.default
                    let documentDirectoryUrlOfflineCourse = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("OfflineCourse.json")
                    if manager.fileExists(atPath: documentDirectoryUrlOfflineCourse.relativePath) {
                        do{
                            try manager.removeItem(at: documentDirectoryUrlOfflineCourse)
                            //"Deleting OfflineCourse.json file ")
                        } catch {
                            print("Error in deleting OfflineCourse.json file ",error)
                        }
                    }

                    DispatchQueue.global(qos: .background).async {
                        self.CallGetOfflineLesson() //Background Queue
                        DispatchQueue.main.async {
                            self.saveToJsonFileLangData(jsonArray: JSONResponse) //Main Queue
                        }
                    }
                }else {
                    //1st lunch
                    DispatchQueue.main.async {
                        self.saveToJsonFileLangData(jsonArray: JSONResponse) //Main Queue
                    }
                }
                
            }else{
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
            print("Fails ",error)
        })
    }
    
    func saveToJsonFileLangData(jsonArray:[String:Any])  {
        
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("LangDataJson.json")
        print(#function,fileUrl)
        // Transform array into data and save it into file
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
            try data.write(to: fileUrl, options: [])
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("LangDataJson.json")
            if FileManager.default.fileExists(atPath: documentsURL.relativePath) {
                appDelegate.ArryLngResponSystm = retrieveLangDataFile()["responseSystem"] as? [String:Any]
                appDelegate.ArryLngResponeCustom = retrieveLangDataFile()["responseCustom"] as? [String:Any]
            }
            
            string.noInternateMessage2 = (appDelegate.ArryLngResponSystm!["internet_error_msg"] as? String)!
            string.noDataFoundMsg = (appDelegate.ArryLngResponSystm!["no_data_found"] as? String)!
            string.oppsMsg = "OOPS!"
            string.someThingWrongMsg = (appDelegate.ArryLngResponSystm!["general_err_msg"] as? String)!
            string.someThingWrongMsg2 = (appDelegate.ArryLngResponSystm!["general_err_msg"] as? String)!
            string.privateKeyMsg = (appDelegate.ArryLngResponSystm!["force_logout_msg"] as? String)!
            string.errodeCodeString = (appDelegate.ArryLngResponeCustom!["error_code"] as? String)!
            
            var strTitle = ""
            if flagForBackBtn == "1"{
                //From Home screen
                strTitle = (appDelegate.ArryLngResponeCustom!["Change_language"] as? String)!
                //self.navigationController?.popViewController(animated: true)
                //UserDefaults.standard.set(true, forKey: "LeftMenuSelectLang")
            }else if flagForBackBtn == "2"{
                //From Login screen
                strTitle = (appDelegate.ArryLngResponeCustom!["select_language"] as? String)!
                //self.navigationController?.popViewController(animated: true)
            }else {
                //1st lunch
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            if strTitle.count > 28{
                let startIndex = strTitle.index(strTitle.startIndex, offsetBy: 28)
                self.title = String(strTitle[..<startIndex] + "..")
            }else {
                self.title = strTitle
            }
            
        } catch {
            print(error)
        }
    }
    
    func callWsOfUI(){
        
        let dictionary = ["ostype" : "2","appclientsId" : userInfo.appclientsId] // "1"
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        //strURL = "http://cms.membrandt.com/index.php/api/" + "getUiSettingsNew?" //AWS live
        //strURL = "http://cmsstaging.membrandt.com/index.php/api/" + "getUiSettingsNew?" //AWS Staging
        strURL = Url.baseURL + "getUiSettingsNew?"
        print(strURL) //Url.baseURL
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
            print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    
                    self.getJsonData = JSONResponse
                    self.appDelegate.jsonData = JSONResponse
                    
                    if self.getJsonData != nil {
                        if (self.getJsonData!["status"] as? String == "1"){
                            self.getUIForSelectLanguag()
                        }else {
                            userInfo.appId = "0"
                            userInfo.appclientsId = "0"
                        }
                    }else {
                        
                        let alrtMessage = NSMutableAttributedString(string:(self.appDelegate.ArryLngResponSystm!["setting_app_msg"] as? String)!)
                        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:14.0) , range: NSRange(location: 0, length: alrtMessage.length))
                        
                        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
                        alertController.setValue(alrtMessage, forKey: "attributedMessage")
                        
                        //let alertController = UIAlertController(title: nil, message: NSLocalizedString("Please wait. We are setting the app \nfor you. Please wait or try again.", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: (self.appDelegate.ArryLngResponeCustom!["retry"] as? String)!, style: UIAlertActionStyle.default, handler:{
                            action in
                            
                            //calling ws
                            self.getUISettingWS()
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
                self.serverError(title: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String) ,description: (self.appDelegate.ArryLngResponSystm!["setting_app_msg"] as? String)!)
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
            //print("Lang getOfflineLesson", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.saveToJsonFile(jsonArray: JSONResponse)
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
    func saveToJsonFile(jsonArray:[String:Any])  {
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
    
    func serverError(title: String, description: String) {
        
        let alrtTitleStr = NSMutableAttributedString(string: title)
        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
        
        let alrtMessage = NSMutableAttributedString(string: description)
        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:14.0) , range: NSRange(location: 0, length: alrtMessage.length))
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.setValue(alrtMessage, forKey: "attributedMessage")
        
        var btnTitle = ""
        if self.appDelegate.ArryLngResponeCustom != nil {
            btnTitle = (self.appDelegate.ArryLngResponeCustom!["retry"] as? String)!
        }else {
            btnTitle = "retry"
        }
        alertController.addAction(UIAlertAction(title: btnTitle, style: UIAlertActionStyle.default, handler:{
            action in
            
            //calling ws
            self.getUISettingWS()
            
        }))
        self.present(alertController,animated: true,completion: nil)
    }
    
}

//MARK: - favMenuDelagte
extension SelectLangauge : favMenuDelagte {
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
