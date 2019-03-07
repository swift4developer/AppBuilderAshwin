//
//  CoursesList.swift
//  AppBuilder2
//
//  Created by VISHAL on 28/02/18.
//  Copyright © 2018 VISHAL. All rights reserved.
//

import UIKit
import Alamofire

class CoursesList: UIViewController,NVActivityIndicatorViewable,UIScrollViewDelegate {

    @IBOutlet weak var tblOfCourses: UITableView!
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
    var strTitle = ""
    @IBOutlet weak var btnQuestonMark: UIButton!
    var arryOfProgressUpdte = Array<Any>()
    var arryOfNotifcatnUpdte = Array<Any>()
    
    //MARK:- Custom Meothods
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackBtn()
        setNavigationBtn()

        appDelegate = UIApplication.shared.delegate as! AppDelegate
        getJsonData =  appDelegate.jsonData
        
        if strTitle == ""{
            self.title = "Courses"
        }else {
            let str = strTitle
            if str.count > 28{
                let startIndex = str.index(str.startIndex, offsetBy: 28)
                self.title = String(str[..<startIndex] + "..")
            }else {
               self.title = strTitle
            }
        }
        
        self.chache = NSCache()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        //tblOfCourses.addSubview(refreshControl)
        
        tblOfCourses.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.isStatusBarHidden = false
        //MARK: call ws
        getUIForCourseList()
        //callWSOfCorses()
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("HomeCourseJson.json")
        if FileManager.default.fileExists(atPath: documentsURL.relativePath) {
            let menuItem = retrieveFromHomeCourseJsonFile()["Menuitems"] as! [[String:Any]]
            if menuItem.count != 0 {
                for course in menuItem {
                    if self.strMenuId == course["menuid"] as! String {
                        let menuListArry = course["data"] as! [[String:Any]]
                        if menuListArry.count != 0 {
                            self.arryWSCoursData = menuListArry
                            self.tblOfCourses.reloadData()
                        }else{
                            callWSOfCorses()
                        }
                        break
                    }
                }
            }else{
                callWSOfCorses()
            }
        }else {
            callWSOfCorses()
        }
        
        callWSProgressUpdate()
        callWSNotificatnUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if DeviceType.IS_IPHONE_x {
            if (self.title?.count)! >= 33 {
                self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(-10, for: .default)
            }else {
                self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(0, for: .default)
            }
        }else {
            self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(0, for: .default)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(0, for: .default)
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
    /*override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }*/
    
    @objc func refresh(_ sender:AnyObject){
        flgActivity = false
        self.timeOut = Timer.scheduledTimer(timeInterval: 25.0, target: self, selector: #selector(Login.cancelWeb), userInfo: nil, repeats: false)
        apiSuccesFlag = "1"
        //callWSOfCorses()
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
            self.view.makeToast((appDelegate.ArryLngResponSystm!["no_help_article_msg"] as? String)!)
        }
    }
    
    func getUIForCourseList() {
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
                    btnQuestonMark.setBackgroundImage(tintImg, for: .normal)
                    btnQuestonMark.tintColor = UIColor().HexToColor(hexString: bblBgColor!)
                    btnQuestonMark.titleLabel?.font = checkForFontType(fontStyle: fontstyle1! , fontSize: CGFloat(sizeInt1 + 14))
                    btnQuestonMark.setTitleColor(UIColor().HexToColor(hexString: txtBblClor!), for: .normal)
                    
                    commonElement = common_element
                    tblOfCourses.backgroundColor = UIColor().HexToColor(hexString: bgScreenColor)
                }
            }
        } else {
            self.view.makeToast(string.noInternateMessage2)
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

// MARK: - TableView Delegate and DataSource
extension CoursesList : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       return self.arryWSCoursData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tblOfCourses.dequeueReusableCell(withIdentifier: "coursesCell", for: indexPath) as! HomeTableCell
        
        cell.imgOfNotifiction.isHidden = false
        cell.lblOfNotificationCount.isHidden = false
        cell.progreessView.isHidden = true
//        cell.lblOfProgresStatus.isHidden = true
        //
        let genarlSettings = commonElement["general_settings"] as! [String:Any]
        let bgScreenColor = genarlSettings["screen_bg_color"] as! String
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
            
//            cell.lblOfProgresStatus.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
            cell.progreessView.progressTintColor =  UIColor().HexToColor(hexString: bgColor!)
//            cell.lblOfProgresStatus.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
        }
        
        let currentDic = arryWSCoursData[indexPath.row] as! [String:Any]
        
        let colorcode = currentDic["colorcode"] as? String
        let expiry_date = currentDic["expiry_date"] as? String
        if colorcode! != "" {
            cell.backgroundColor = UIColor().HexToColor(hexString: colorcode!)
        }
        else {
            cell.backgroundColor = UIColor().HexToColor(hexString: bgScreenColor)
        }
        
        //title
        if ((currentDic["title"] as? String) != nil){
            cell.lblOftitle.text = currentDic["title"] as? String
        }else {
            cell.lblOftitle.text = ""
        }
        
        cell.imgOfNotifiction.isHidden = true
        cell.lblOfNotificationCount.isHidden = true
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
            if !(validation.checkNotNullParameter(checkStr: (currentDic["count"] as? String)!)){
                if (currentDic["count"] as? String) != "0"{
                    cell.imgOfNotifiction.isHidden = false
                    cell.lblOfNotificationCount.isHidden = false
                    cell.lblOfNotificationCount.text = currentDic["count"] as? String
                }else {
                    cell.imgOfNotifiction.isHidden = true
                    cell.lblOfNotificationCount.isHidden = true
                }
            }else {
                cell.imgOfNotifiction.isHidden = true
                cell.lblOfNotificationCount.isHidden = true
            }
        }else {
            cell.imgOfNotifiction.isHidden = true
            cell.lblOfNotificationCount.isHidden = true
        }
        
        //description
        if ((currentDic["description"] as? String) != nil){
            let strngVlue = currentDic["description"] as? String
            cell.lblOfDiscriptin.text = strngVlue?.html2String//strngVlue?.htmlToString
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
                            //let courseId = dic["courseID"] as! String
                            if dic["courseID"] as? String == currentDic["id"] as? String{
                                if dic["percent"] as? String == ""{
                                    //let str = currentDic["viewComlplete"] as! String
                                    //let strArr = str.components(separatedBy: ".")
                                    let strintValue  = "\(currentDic["viewComlplete"] as! String)"
                                    let strProgressValue = Float(strintValue)
                                    cell.progreessView.progress = Float((strProgressValue)! / 100.00)
                                }else {
                                    //let str = dic["percent"] as? String
                                    //let strArr = str.components(separatedBy: ".")
                                    let strintValue  = "\(dic["percent"] as! String)"
                                    let strProgressValue = Float(strintValue)
                                    cell.progreessView.progress = Float((strProgressValue)! / 100.00)
                                }
                            }
                        }
                    }else {
                        //cell.progreessView.isHidden = true
                        for  dic in (self.arryOfProgressUpdte as? [[String:Any]])!{
                            //let courseId = dic["courseID"] as! String
                            if dic["courseID"] as? String == currentDic["id"] as? String{
                                if dic["percent"] as? String == ""{
                                    cell.progreessView.isHidden = true
                                }else {
                                    //let str = dic["percent"] as? String
                                    //let strArr = str.components(separatedBy: ".")
                                    let strintValue  = "\(dic["percent"] as! String)"
                                    let strProgressValue = Float(strintValue)
                                    cell.progreessView.progress = Float((strProgressValue)! / 100.00)
                                }
                            }
                        }
                    }
                }else {
                    cell.progreessView.isHidden = true
                }
            }else {
                cell.progreessView.isHidden = true
            }
        }
        
        //image
        if currentDic["icon"] as? String != nil{
            let imgUrl = currentDic["icon"] as? String
            
            let imageName = self.separateImageNameFromUrl(Url: imgUrl!)

           // cell.imgOfMenu.image = UIImage(named:"placeholder2")
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
                            //cell.imgOfMenu.image = UIImage(named:"placeholder2")
                            cell.imgOfMenu.backgroundColor = color.placeholdrImgColor
                        }
                    }
                }else {
                  // cell.imgOfMenu.image = UIImage(named:"placeholder2")
                    cell.imgOfMenu.backgroundColor = color.placeholdrImgColor
                }
            }
        }
        return cell
    }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentDic = arryWSCoursData[indexPath.row] as! [String:Any]
        
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
                                //call getCoursetopiclisting API ==>PDF page no 49-51 >>> DetailViewController
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
                        vc.dicMediaData = arryWSCoursData[indexPath.row] as! NSDictionary
                        vc.strTitle = (currentDic["title"] as? String)!
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
}
//MARK:- favMenuDelagte
extension CoursesList : favMenuDelagte {
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

//MARK:- WS Parsing
extension CoursesList {
    
    //MARK: WS Get Home List
    func callWSOfCorses(){
        
        //URL : http://27.109.19.234/app_builder/index.php/api/getHomemenuList?appclientsId=1&userId=1&userPrivateKey=P6HwAapNVu4WK1Ts&appId=1&menuId=1
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateTimeStr = formatter.string(from: Date())
        
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "menuId" : self.strMenuId,
                          "appId" : userInfo.appId,
                          "datetime" : dateTimeStr]
        
        print("I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getHomemenuList?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            if flgActivity{
                self.startActivityIndicator()
            }
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSOfCorseList(strURL: strURL, dictionary: dictionary )
        }else{
            stopActivityIndicator()
            self.refreshControl.endRefreshing()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOfCorseList(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            //print("JSONResponse ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.refreshControl.endRefreshing()
                    if let arrayData = JSONResponse["homeList"] as? [Any]{
                        self.arryWSCoursData = arrayData
                        self.tblOfCourses.reloadData()
                    }
                    else{
                        self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: "", lableNoInternate: string.noDataFoundMsg)
                        self.tblOfCourses.addSubview(self.noDataView)
                    }
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
                        self.tblOfCourses.addSubview(self.noDataView)
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
                self.tblOfCourses.addSubview(self.noDataView)
            }
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
            //self.startActivityIndicator()
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSProgressStatus(strURL: strURL, dictionary: dictionary as! Dictionary<String, String>)
        }else{
            //stopActivityIndicator()
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
                    self.stopActivityIndicator()
                    self.arryOfProgressUpdte = JSONResponse["response"] as! [Any]
                    ///self.strProgrssBarVlue = (dic["total_completion"] as? String)!
                    self.tblOfCourses.reloadData()
                }
            }
            else{
                let status = JSONResponse["status"] as? String
                self.stopActivityIndicator()
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
            self.stopActivityIndicator()
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
                          "menuId" : "1",
                          "datetime" : dateTimeStr] as [String : Any]
        
        print("I/P getallmenuitemListCount course list :",dictionary)
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
            stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSNotoifcatnUpdate(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            //print("JSONResponse Notification Count course list ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    //self.stopActivityIndicator()
                    let menuItems = JSONResponse["Menuitems"] as! [Any]
                    //self.arryOfNotifcatnUpdte = menuItems
                    for  dic in (menuItems as? [[String:Any]])!{
                        if dic["menuid"] as? String == self.strMenuId{
                           self.arryOfNotifcatnUpdte = dic["data"] as! [Any]
                        }
                    }
                    self.tblOfCourses.reloadData()
                }
            }
            else{
                let status = JSONResponse["status"] as? String
                self.stopActivityIndicator()
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

