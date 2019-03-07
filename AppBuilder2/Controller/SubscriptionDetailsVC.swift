//
//  SubscriptionDetailsVC.swift
//  AppBuilder2
//
//  Created by Aditya on 05/04/18.
//  Copyright © 2018 VISHAL. All rights reserved.
//

import UIKit

class SubscriptionDetailsVC: UIViewController,NVActivityIndicatorViewable {
    
    @IBOutlet weak var btnQuestionMark: UIButton!
    @IBOutlet weak var tblOfAddress: UITableView!
    
    var appDelegate : AppDelegate!
    var chache:NSCache<AnyObject, AnyObject>!
    var flgActivity = true
    var timeOut: Timer!
    var apiSuccesFlag = ""
    var arryWSCoursData = [String:Any]()
    var noDataView = UIView()
    var refreshControl: UIRefreshControl!
    var strMenuId = ""
    var btnMenu:UIButton!
    var btnBack:UIButton!
    var getJsonData: [String:Any]?
    var commonElement = [String:Any]()
    
    var tempArr1 = ["Street 1","Street 2","City","State","Postal Code","Country",""]
    var tempArr2 = ["13407 CARROWAY STREET","","Windermere","Florida","34786-7344","United States Of America",""]
    
    var arrBilling = [String]()
    var arrShipping = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Subscriptions"
        setBackBtn()
        setNavigationBtn()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        getJsonData =  appDelegate.jsonData
        
        self.chache = NSCache()
        
        refreshControl = UIRefreshControl()
        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblOfAddress.addSubview(refreshControl)
        
        getUIForSubscription()
        callWSOfSubscription()
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
        callWSOfSubscription()
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
                    
                    self.view.backgroundColor = UIColor().HexToColor(hexString: bgScreenColor)
                    
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor().HexToColor(hexString: txtcolorHex!),NSAttributedStringKey.font: checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(sizeInt))]
                    
                    self.navigationController?.navigationBar.barTintColor = UIColor().HexToColor(hexString: bgcolor!)
                    self.navigationController?.navigationBar.backgroundColor = UIColor().HexToColor(hexString: bgcolor!)
                    
                    self.btnMenu.tintColor = UIColor().HexToColor(hexString: menu_icon_color!)
                    self.btnBack.tintColor = UIColor().HexToColor(hexString: menu_icon_color!)
                    
                    let origImage = UIImage(named: "question");
                    let tintImg = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    btnQuestionMark.setBackgroundImage(tintImg, for: .normal)
                    btnQuestionMark.tintColor = UIColor().HexToColor(hexString: bgcolor!)
                    btnQuestionMark.setTitleColor(UIColor().HexToColor(hexString: txtcolorHex!), for: .normal)
                    
                    commonElement = common_element
                }
            }
        } else {
            self.view.makeToast(string.noInternateMessage2)
        }
    }
}

//MARK:- favMenuDelagte
extension SubscriptionDetailsVC : favMenuDelagte {
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

// MARK:- TABLEVIEW DELEGATE DATASOURCE
extension SubscriptionDetailsVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellOfRow", for: indexPath) as! TableViewCell
        
        
        let genarlSettings = commonElement["general_settings"] as! [String:Any]
        
        let genrlFontSize = genarlSettings["general_fontsize"] as! [String:String]
        let medium = genrlFontSize["medium"]
        let mediumInt:Int = Int(medium!)!
        
        let general_font = genarlSettings["general_font"] as! [String:Any]
        let fontstyle = general_font["fontstyle"] as! String
        let genrltxtColor = general_font["txtcolorHex"] as! String
        let bgScreenColor = genarlSettings["screen_bg_color"] as! String
        
        self.view.backgroundColor = UIColor().HexToColor(hexString: bgScreenColor)
        cell.backgroundColor = UIColor().HexToColor(hexString: bgScreenColor)
        
        cell.lblAddressFields.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt))
        cell.lblAddressFields.textColor = UIColor().HexToColor(hexString: genrltxtColor)
            
        cell.lblRowAdress.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt - 1))
        cell.lblRowAdress.textColor = UIColor().HexToColor(hexString: genrltxtColor)
      
        if indexPath.section == 0 {
            cell.lblAddressFields.text = tempArr1[indexPath.row]
            if arrBilling.count != 0 {
              cell.lblRowAdress.text = arrBilling[indexPath.row]
            }
        }else {
            cell.lblAddressFields.text = tempArr1[indexPath.row]
            if arrShipping.count != 0 {
                cell.lblRowAdress.text = arrShipping[indexPath.row]
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellOfHeader") as! TableViewCell
        
        let genarlSettings = commonElement["general_settings"] as! [String:Any]
        
        let genrlFontSize = genarlSettings["general_fontsize"] as! [String:String]
        let medium = genrlFontSize["medium"]
        let mediumInt:Int = Int(medium!)!
        
        let general_font = genarlSettings["general_font"] as! [String:Any]
        let fontstyle = general_font["fontstyle"] as! String
        let genrltxtColor = general_font["txtcolorHex"] as! String
        
        cell.lblHeaderAddress.font = checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(mediumInt))
        cell.lblHeaderAddress.textColor = UIColor().HexToColor(hexString: genrltxtColor)
        cell.lblHeaderAddress.font = UIFont.boldSystemFont(ofSize: CGFloat(mediumInt))
       
        if section == 0 {
            cell.lblHeaderAddress.text = "Billing Address"
//                arryWSCoursData["billing"] as? String
        }else {
            cell.lblHeaderAddress.text = "Shipping Address"
//                arryWSCoursData["shipping"] as? String
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

// MARK:- WS PARSING
extension SubscriptionDetailsVC {
    
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
                        self.arryWSCoursData = arrayData
                        
                        let billing = self.arryWSCoursData["billing"] as! [Any]
                        let bil = billing[0] as! [String:Any]
                        self.arrBilling.append(bil["street1"] as! String)
                        self.arrBilling.append(bil["street2"] as! String)
                        self.arrBilling.append(bil["city"] as! String)
                        self.arrBilling.append(bil["state"] as! String)
                        self.arrBilling.append(bil["postalcode"] as! String)
                        self.arrBilling.append(bil["country"] as! String)
//                        for b in bil  {
//                            self.arrBilling.append(b.value as! String)
//                        }
                        self.arrBilling.append("")
                        
                        let shipping = self.arryWSCoursData["shipping"] as! [Any]
                        let ship = shipping[0] as! [String:Any]
                        self.arrShipping.append(ship["street1"] as! String)
                        self.arrShipping.append(ship["street2"] as! String)
                        self.arrShipping.append(ship["city"] as! String)
                        self.arrShipping.append(ship["state"] as! String)
                        self.arrShipping.append(ship["postalcode"] as! String)
                        self.arrShipping.append(ship["country"] as! String)
//                        for b in ship {
//                            self.arrShipping.append(b.value as! String)
//                        }
                        self.arrShipping.append("")
                        self.tblOfAddress.reloadData()
                    }
                    else{
                        self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: "", lableNoInternate: string.noDataFoundMsg)
                        self.tblOfAddress.addSubview(self.noDataView)
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
                        //self.errorCodeAlert(title: (JSONResponse["title"] as? String)!, description: (JSONResponse["description"] as? String)!, errorCode: (JSONResponse["systemErrorCode"] as? String)!, okButton: (self.appDelegate.ArryLngResponeCustom!["ok"] as? String)!)
                        
                        self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: (JSONResponse["title"] as? String)!, lableNoInternate: ((JSONResponse["description"] as? String)! + "\n\(string.errodeCodeString) = [\((JSONResponse["systemErrorCode"] as? String)!)]"))
                        self.tblOfAddress.addSubview(self.noDataView)
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
                self.tblOfAddress.addSubview(self.noDataView)
            }
        })
    }
}

