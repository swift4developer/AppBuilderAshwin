//
//  DetailViewController.swift
//  AppBuilder2
//
//  Created by Aditya on 01/03/18.
//  Copyright © 2018 VISHAL. All rights reserved.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController,NVActivityIndicatorViewable,UIScrollViewDelegate {

    //MARK: - Out_lest
    @IBOutlet weak var btnQuestonMark: UIButton!
    @IBOutlet weak var detailTableView: UITableView!
    var appDelegate : AppDelegate!
    var chache:NSCache<AnyObject, AnyObject>!
    var flgActivity = true
    var timeOut: Timer!
    var apiSuccesFlag = ""
    var arryWSTemlateData = [String:Any]()
    var noDataView = UIView()
    var refreshControl: UIRefreshControl!
    var strCourseId = ""
    var expandabaleSection : NSMutableSet = []
    var getJsonData: [String:Any]?
    var btnMenu:UIButton!
    var btnBack:UIButton!
    var commonElement = [String:Any]()
    var courseElement = [String:Any]()
    var NavBgcolor = ""
    var txtNavcolorHex = ""
    var strTitle = ""
    var isMoreClick = false
    var strnoofLine: Int = 0
    var TitleLine: Int = 1
    var subtitleLine:Int = 0
    var strngVlue = ""
    var strProgrssBarVlue = ""
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackBtn()
        setNavigationBtn()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        getJsonData =  appDelegate.jsonData
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.chache = NSCache()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        detailTableView.tableFooterView = UIView()
        
        let str = strTitle
        if str.count > 28{
            let startIndex = str.index(str.startIndex, offsetBy: 28)
            self.title = String(str[..<startIndex] + "..")
        }else {
            self.title = strTitle
        }
        
     }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = false
        //Set the UI of screen
        getUIForCourseDetils()
        
        //Gate offline Data
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("JsonData.json")
        if FileManager.default.fileExists(atPath: documentsURL.relativePath) {
            let response = retrieveFromJsonFile()["response"] as! [String:Any]
            if response.count > 0 {
                let responseCourse = response["responseCourse"] as! [[String:Any]]
                if responseCourse.count != 0 {
                    for (course) in responseCourse {
                        if self.strCourseId == course["course_category_id"] as! String {
                            self.arryWSTemlateData = course
                            self.strngVlue = (self.arryWSTemlateData["description"] as? String)!.html2String
                            self.detailTableView.reloadData()
                        }
                    }
                }else {
                    callWSOfTemplate()
                }
            }else {
                callWSOfTemplate()
            }
        }else {
            callWSOfTemplate()
        }
        //MARK: call ws
        callWSProgressUpdate()
        callWSNotifcnCuntUpdate()
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
    
    //MARK:- custom methods
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
    //Refresh
    @objc func refresh(_ sender:AnyObject){
        flgActivity = false
        self.timeOut = Timer.scheduledTimer(timeInterval: 25.0, target: self, selector: #selector(Login.cancelWeb), userInfo: nil, repeats: false)
        apiSuccesFlag = "1"
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("JsonData.json")
        if FileManager.default.fileExists(atPath: documentsURL.relativePath) {
            let response = retrieveFromJsonFile()["response"] as! [String:Any]
            let responseCourse = response["responseCourse"] as! [[String:Any]]
            if responseCourse.count != 0 {
                for (course) in responseCourse {
                    if self.strCourseId == course["course_category_id"] as! String {
                        self.arryWSTemlateData = course
                        self.strngVlue = (self.arryWSTemlateData["description"] as? String)!.html2String
                        self.detailTableView.reloadData()
                    }
                }
            }
            self.refreshControl.endRefreshing()
        }else {
            callWSOfTemplate()
        }
        
    }
    
    //Activity Indicatore
    func startActivityIndicator() {
        let size = CGSize(width: 50, height: 50)
        
        self.startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
        self.timeOut = Timer.scheduledTimer(timeInterval: 25.0, target: self, selector: #selector(DetailViewController.cancelWeb), userInfo: nil, repeats: false)
    }
    
    func stopActivityIndicator() {
        self.stopAnimating()
    }
    
    @objc func cancelWeb() {
        //print("cancelWeb")
        if apiSuccesFlag == "1"{
            self.stopAnimating()
            self.refreshControl.endRefreshing()
        }
    }
    @IBAction func btnQuestonMarkClick(_ sender: Any) {
        if self.appDelegate.helpData.count > 0 && UserDefaults.standard.bool(forKey: "helpData"){
            UserDefaults.standard.set("1", forKey: "ArticleVideoFlag")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogPostViewController") as! BlogPostViewController
            vc.dicMediaData = self.appDelegate.helpData
            vc.flgToShow = "Help"
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            self.view.makeToast((appDelegate.ArryLngResponSystm!["no_help_article_msg"] as? String)!)
        }
    }
    
    //table click methods
    @objc func btnContinueClk(sender: UIButton) {
        if ((arryWSTemlateData["course_category_id"] as? String) != nil) {
            let section = (sender.tag) / 1000
            let row = (sender.tag) % 1000
            
            let arryOfTopic = arryWSTemlateData["topics"] as! [[String:Any]]
            let array = arryOfTopic[section - 1]
            UserDefaults.standard.set("0", forKey: "ArticleVideoFlag")
          //  let nextVC = storyboard?.instantiateViewController(withIdentifier: "myPlayerViewController") as! myPlayerViewController
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "CourseTemplateDetails") as! CourseTemplateDetails
            
            nextVC.StrCourseCatgryId = (arryWSTemlateData["course_category_id"] as? String)!
            nextVC.flagVideoPlayId = (array["topicsLecturesId"] as? String)!
            nextVC.StrCourseTopicId = (array["course_topics_id"] as? String)!
            nextVC.strVideoTitleLine = TitleLine
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @objc func sectionTaped(gestureRecognizer: UITapGestureRecognizer) {
        let cell = gestureRecognizer.view as! CourseHeaderTableViewCell
        let section = cell.tag
        let shouldExpand = !expandabaleSection.contains(section)
        
        if (shouldExpand) {
            expandabaleSection.removeAllObjects()
            expandabaleSection.add(section)
        } else {
            expandabaleSection.removeAllObjects()
        }
        detailTableView.reloadData()
    }
    
    @objc func buttonMoreClick(sender : UIButton){
        isMoreClick = !isMoreClick
        let sectionToReload = 0
        let indexSet: IndexSet = [sectionToReload]
        detailTableView.reloadData()
    }
    
    
    @objc func rotated() {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            DispatchQueue.main.async() {
                //Code
            }
        }
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            //Code
        }
    }
    
    //Set UI to screen
    func getUIForCourseDetils() {
        let status = getJsonData!["status"] as! String
        if status == "1" {
            if let data = getJsonData!["data"] as? [String:Any] {
                if let common_element = data["common_element"] as? [String:Any] {
                    let navigation_bar = common_element["navigation_bar"] as! Dictionary<String,String>
                    let size = navigation_bar["size"]
                    NavBgcolor = navigation_bar["bgcolor"]!
                    txtNavcolorHex = navigation_bar["txtcolorHex"]!
                    let menu_icon_color = navigation_bar["menu_icon_color"]
                    let sizeInt:Int = Int(size!)!
                    
                    let genarlSettings = common_element["general_settings"] as! [String:Any]
                    let general_font = genarlSettings["general_font"] as! [String:Any]
                    let fontstyle = general_font["fontstyle"] as! String
                    let bgScreenColor = genarlSettings["screen_bg_color"] as! String
                    
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor().HexToColor(hexString: txtNavcolorHex),NSAttributedStringKey.font: checkForFontType(fontStyle: fontstyle, fontSize: CGFloat(sizeInt))]
                    self.navigationController?.navigationBar.barTintColor = UIColor().HexToColor(hexString: NavBgcolor)
                    
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
                    if let course_Element = data["course"] as? [String:Any]{
                        courseElement = course_Element
                    }
                    
                    let moduleArry = courseElement["module"] as! [String:Any]
                    let module_bgcolor = moduleArry["module_bgcolor"] as? String
                    detailTableView.backgroundColor = UIColor().HexToColor(hexString: module_bgcolor!)
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
                self.btnQuestonMark.alpha = 1.0
            }, completion: { _ in
                self.btnQuestonMark.isHidden = false
            })
        }
    }
}
// MARK: - TableView Delegate and DataSource
extension DetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if  arryWSTemlateData.count != 0{
            let sectnArray = arryWSTemlateData["topics"] as! [[String:Any]]
            return sectnArray.count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 0
        }else{
            if  arryWSTemlateData.count != 0{
                let arryOfTopic = arryWSTemlateData["topics"] as! [[String:Any]]
                let sectionArry = arryOfTopic[section - 1]
                if (expandabaleSection.contains(section - 1)){
                    return 1
                }
                else{
                    return 0
                }
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseDetails") as! CourseDetailCell
        
        let arryOfTopic = arryWSTemlateData["topics"] as! [[String:Any]]
        let sectionDic = arryOfTopic[indexPath.section - 1] as! [String:Any]
        
        //Title
        let genarlSettings = commonElement["general_settings"] as! [String:Any]
        if let title = genarlSettings["description"] as? Dictionary<String,String> {
            let size = title["size"]
            let txtcolorHex = title["txtcolorHex"]
            let fontstyle = title["fontstyle"]
            let sizeInt:Int = Int(size!)!
            
            cell.lblDescription.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
            cell.btnContinue.setTitleColor(UIColor().HexToColor(hexString: txtNavcolorHex), for: .normal)
        }
        
        let moduleArry = courseElement["module"] as! [String:Any]
        
        let moduleDescBgcolor = moduleArry["module_description_bgcolor"] as? String
        cell.lblDescription.backgroundColor = UIColor().HexToColor(hexString: moduleDescBgcolor!)
        
        let moduleDescTxtcolor = moduleArry["module_description_txtcolorHex"] as? String
        cell.lblDescription.textColor = UIColor().HexToColor(hexString: moduleDescTxtcolor!)
        
        let moduleContinueBtn = moduleArry["continue_btn_bgcolor"] as? String
        cell.viewOfArrow.backgroundColor = UIColor().HexToColor(hexString: moduleContinueBtn!)
        cell.btnContinue.backgroundColor = UIColor().HexToColor(hexString: moduleContinueBtn!)
        
        
        let array = arryOfTopic[indexPath.section - 1]
        let value = array["description"] as! String
        cell.lblDescription.text = value.html2String
        
        strnoofLine = cell.lblDescription.calculateMaxLines()
        if array["ViewedFlag"] as! String == "1" {
            cell.btnContinue.setTitle((appDelegate.ArryLngResponeCustom!["continue_lbl"] as? String)!, for: .normal)
        }else {
            cell.btnContinue.setTitle((appDelegate.ArryLngResponeCustom!["start"] as? String)!, for: .normal) //"Start"
        }
        
        cell.btnContinue.tag = indexPath.section*1000 + indexPath.row;
        cell.btnContinue.addTarget(self, action: #selector(DetailViewController.btnContinueClk(sender:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section  == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! TableViewCell
            
            cell.btnMoreRead.setTitleColor(UIColor().HexToColor(hexString: NavBgcolor), for: .normal)
            
            let genarlSettings = commonElement["general_settings"] as! [String:Any]
            
            //Title
            if let title = genarlSettings["title"] as? Dictionary<String,String> {
                let size = title["size"]
                let txtcolorHex = title["txtcolorHex"]
                let fontstyle = title["fontstyle"]
                let sizeInt:Int = Int(size!)! + 2
                
                cell.lblTtile.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                cell.lblTtile.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                cell.lblTtile.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeInt))
            }
            
            //Description
            if let dicTitle = genarlSettings["description"] as? Dictionary<String,String> {
                let size = dicTitle["size"]
                let txtcolorHex = dicTitle["txtcolorHex"]
                let fontstyle = dicTitle["fontstyle"]
                let sizeInt:Int = Int(size!)!
                
                cell.lblSubtitle.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                cell.lblSubtitle.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                
                if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5{
                   cell.lblHoursDetails.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt - 4))
                   cell.lblLessonsDetails.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt - 4))
                   cell.lblTopicDetails.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt - 4))
                }
                else {
                     cell.lblTopicDetails.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt - 3))
                    cell.lblLessonsDetails.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt - 3))
                    cell.lblHoursDetails.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt - 3))
                }
            
                cell.lblHoursDetails.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
               
                cell.lblTopicDetails.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                
                cell.lblLessonsDetails.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                
            }
            if userInfo.appId == "40" && userInfo.appclientsId == "9"{
                cell.lblCourseOverView.text = (appDelegate.ArryLngResponeCustom!["overview"] as? String)!
            }else {
                cell.lblCourseOverView.text = (appDelegate.ArryLngResponeCustom!["course_overview"] as? String)!
            }
            
            cell.lblTopicDetails.text = (appDelegate.ArryLngResponeCustom!["topics_of_instruction"] as? String)!
            cell.lblLessonsDetails.text = (appDelegate.ArryLngResponeCustom!["practical_lessons"] as? String)!
            
            //Progress and courses overview
            var sizeIntBig = 0
            var fontstyleBig = ""
            let moduleArry = courseElement["module"] as! [String:Any]
            if let overViewDic = moduleArry["overview_text"] as? Dictionary<String,String> {
                let txtcolorHex = overViewDic["txtcolorHex"]
                let bgColor = overViewDic["bgcolor"]
                
                cell.progressView.isHidden = false
                cell.lblProgress.isHidden = false
                cell.viewCourseOverview.isHidden = false
                
                let generalStyle = genarlSettings["general_font"] as! [String:String]
                let fontstyle = generalStyle["fontstyle"]
                
                let generalFontSize = genarlSettings["general_fontsize"] as! [String:String]
                let size = generalFontSize["medium"]
                let sizeInt:Int = Int(size!)!
                
                cell.lblCourseOverView.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                cell.lblCourseOverView.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                cell.lblCourseOverView.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeInt + 2))
                cell.viewCourseOverview.backgroundColor = UIColor().HexToColor(hexString: bgColor!)
                
                if let progresArry = moduleArry["status_highlight"] as? Dictionary<String,String>{
                    let txtcolorHex1 = progresArry["txtcolorHex"]
                    let bgColor1 = progresArry["bgcolor"]
                    
                    cell.lblProgress.textColor = UIColor().HexToColor(hexString: txtcolorHex1!)
                    cell.progressView.progressTintColor = UIColor().HexToColor(hexString: bgColor1!)
                    cell.lblProgress.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt))
                    cell.lblProgress.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeInt))
                }
               
                //Course Module Description
                let course_description_bgcolor = moduleArry["course_description_bgcolor"] as? String
                cell.backgroundColor = UIColor().HexToColor(hexString: course_description_bgcolor!)
                
                //Module Big Font
                if let moduleBigFontDic = moduleArry["module_big_font"] as? Dictionary<String,String>{
                    
                    let size = moduleBigFontDic["size"]
                    fontstyleBig = moduleBigFontDic["fontstyle"]!
                    let txtcolorHex = moduleBigFontDic["txtcolorHex"]
                    sizeIntBig = Int(size!)!
                    
                    cell.lblHours.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                    cell.lblTopics.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                    cell.lblLessons.textColor = UIColor().HexToColor(hexString: txtcolorHex!)
                }
                
                
                //module_subtitle
                if let moduleSubTitle = moduleArry["module_subtitle"] as? Dictionary<String,String>{
                    let size = moduleSubTitle["size"]
                    let fontstyle = moduleSubTitle["fontstyle"]
                    let sizeInt1:Int = Int(size!)!
                    
                    let size2 = generalFontSize["large"]
                    let sizeInt2:Int = Int(size2!)!
                   
                }
            }
            
            cell.lblTtile.text = arryWSTemlateData["name"] as? String
            let strngVlue = arryWSTemlateData["description"] as? String
            cell.lblSubtitle.text = strngVlue?.html2String
            subtitleLine = cell.lblSubtitle.calculateMaxLines()
            if subtitleLine > 4 {
               cell.lblSubtitleBottomConstraint.constant = 21
               
                cell.btnMoreRead.addTarget(self, action: #selector(self.buttonMoreClick(sender:)), for: .touchUpInside)
                cell.btnMoreRead.isHidden = false
                if isMoreClick {
                    cell.btnMoreRead.setTitle((appDelegate.ArryLngResponeCustom!["less"] as? String)!, for: .normal)
                }else {
                    cell.btnMoreRead.setTitle((appDelegate.ArryLngResponeCustom!["read_more"] as? String)!, for: .normal)
                }
            }else if subtitleLine == 1 {
                    cell.btnMoreRead.isHidden = true
                    cell.lblSubtitleBottomConstraint.constant = 40
            }else {
                cell.btnMoreRead.isHidden = true
                cell.lblSubtitleBottomConstraint.constant = 5
            }
            //Time label
            let strHour = arryWSTemlateData["totalHours"] as? String
            let strMinuts = arryWSTemlateData["totalMinutes"] as? String
            if strHour != "0" && strHour != nil{
                let strHour2 = strHour?.compare(".")
                if (strHour2 != nil){
                    let numberAsInt = Int(strHour!)
                    let backToString = "\(numberAsInt!)"
                    cell.lblHours.text =  backToString
                    cell.lblHoursDetails.text = (appDelegate.ArryLngResponeCustom!["hours_of_training"] as? String)!
                }else {
                    let numberAsInt = Int(strHour!)
                    let backToString = "\(numberAsInt!)"
                    cell.lblHours.text =  backToString
                    cell.lblHoursDetails.text = (appDelegate.ArryLngResponeCustom!["hours_of_training"] as? String)!
                }
            }else if strHour == "00"{
                let numberAsInt = Int(strMinuts!)
                let backToString = "\(numberAsInt!)"
                cell.lblHours.text = backToString
                cell.lblHoursDetails.text = (appDelegate.ArryLngResponeCustom!["minutes_of_training"] as? String)!
            }
            else if strMinuts != nil{
                let numberAsInt = Int(strMinuts!)
                let backToString = "\(numberAsInt!)"
                cell.lblHours.text = backToString
                cell.lblHoursDetails.text = (appDelegate.ArryLngResponeCustom!["minutes_of_training"] as? String)!
            }
            
            cell.lblTopics.text =  arryWSTemlateData["topicCount"] as? String
            cell.lblLessons.text = arryWSTemlateData["lessionCount"] as? String
            
           //UI of Time lables
           if (cell.lblLessons.text?.count)! == 3 || (cell.lblTopics.text?.count)! == 3 || (cell.lblHours.text?.count)! == 3 {
                if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5{
                    cell.lblLessons.font = checkForFontType(fontStyle: fontstyleBig, fontSize: CGFloat(sizeIntBig - 20))
                    cell.lblLessons.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeIntBig - 20))
                    
                    cell.lblTopics.font = checkForFontType(fontStyle: fontstyleBig, fontSize: CGFloat(sizeIntBig - 20))
                    cell.lblTopics.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeIntBig - 20))
                    
                    cell.lblHours.font = checkForFontType(fontStyle: fontstyleBig, fontSize: CGFloat(sizeIntBig - 20))
                    cell.lblHours.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeIntBig - 20))
                }
                else {
                    cell.lblLessons.font = checkForFontType(fontStyle: fontstyleBig, fontSize: CGFloat(sizeIntBig - 8))
                    cell.lblLessons.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeIntBig - 8))
                    
                    cell.lblTopics.font = checkForFontType(fontStyle: fontstyleBig, fontSize: CGFloat(sizeIntBig - 8))
                    cell.lblTopics.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeIntBig - 8))
                    
                    cell.lblHours.font = checkForFontType(fontStyle: fontstyleBig, fontSize: CGFloat(sizeIntBig - 8))
                    cell.lblHours.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeIntBig - 8))
                }
            }
            else if cell.lblLessons.text?.count == 2 || cell.lblTopics.text?.count == 2 || cell.lblHours.text?.count == 2 {
                if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5{
                    cell.lblLessons.font = checkForFontType(fontStyle: fontstyleBig, fontSize: CGFloat(sizeIntBig - 15))
                    cell.lblLessons.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeIntBig - 15))

                    cell.lblTopics.font = checkForFontType(fontStyle: fontstyleBig, fontSize: CGFloat(sizeIntBig - 15))
                    cell.lblTopics.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeIntBig - 15))

                    cell.lblHours.font = checkForFontType(fontStyle: fontstyleBig, fontSize: CGFloat(sizeIntBig - 15))
                    cell.lblHours.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeIntBig - 15))
                }
                else {
                    cell.lblLessons.font = checkForFontType(fontStyle: fontstyleBig, fontSize: CGFloat(sizeIntBig - 5))
                    cell.lblLessons.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeIntBig - 5))

                    cell.lblTopics.font = checkForFontType(fontStyle: fontstyleBig, fontSize: CGFloat(sizeIntBig - 5))
                    cell.lblTopics.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeIntBig - 5))

                    cell.lblHours.font = checkForFontType(fontStyle: fontstyleBig, fontSize: CGFloat(sizeIntBig - 5))
                    cell.lblHours.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeIntBig - 5))
                }
            }
            else {
                if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5{
                    cell.lblLessons.font = checkForFontType(fontStyle: fontstyleBig, fontSize: CGFloat(sizeIntBig - 10))
                    cell.lblLessons.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeIntBig - 10))
                    
                    cell.lblTopics.font = checkForFontType(fontStyle: fontstyleBig, fontSize: CGFloat(sizeIntBig - 10))
                    cell.lblTopics.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeIntBig - 10))
                    
                    cell.lblHours.font = checkForFontType(fontStyle: fontstyleBig, fontSize: CGFloat(sizeIntBig - 10))
                    cell.lblHours.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeIntBig - 10))
                }
                else {
                    cell.lblLessons.font = checkForFontType(fontStyle: fontstyleBig, fontSize: CGFloat(sizeIntBig ))
                    cell.lblLessons.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeIntBig ))
                    
                    cell.lblTopics.font = checkForFontType(fontStyle: fontstyleBig, fontSize: CGFloat(sizeIntBig))
                    cell.lblTopics.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeIntBig))
                    
                    cell.lblHours.font = checkForFontType(fontStyle: fontstyleBig, fontSize: CGFloat(sizeIntBig))
                    cell.lblHours.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeIntBig))
                }
            }
            
            //Progress Bar
            if !(validation.checkNotNullParameter(checkStr: (arryWSTemlateData["overview"] as? String)!)) && ((arryWSTemlateData["overview"] as? String) != nil){
                cell.viewCourseOverview.isHidden = false
                cell.progressView.isHidden = false
                if self.strProgrssBarVlue == ""{
                    let str = arryWSTemlateData["overview"] as! String
                    let strArr = str.components(separatedBy: ".")
                    if strArr[0] == "00"{
                        cell.lblProgress.text = (appDelegate.ArryLngResponSystm!["youre_complete"] as? String)!
                    }else if strArr[0] == "0"{
                        cell.lblProgress.text = (appDelegate.ArryLngResponSystm!["youre_complete"] as? String)!
                    }else {
                        cell.lblProgress.text = (appDelegate.ArryLngResponeCustom!["congrats"] as? String)! + ", " + "\((appDelegate.ArryLngResponeCustom!["youre"] as? String)!) " + strArr[0] + "% " + (appDelegate.ArryLngResponeCustom!["complete"] as? String)! + "!"
                    }
                    let strintValue  = "\(arryWSTemlateData["overview"] as! String)"
                    let strProgressValue = Float(strintValue)
                    cell.progressView.progress = Float((strProgressValue)! / 100.00)
                }else {
                    let str = self.strProgrssBarVlue
                    let strArr = str.components(separatedBy: ".")
                    if strArr[0] == "00"{
                        cell.lblProgress.text = (appDelegate.ArryLngResponSystm!["youre_complete"] as? String)!
                    }else if strArr[0] == "0"{
                        cell.lblProgress.text = (appDelegate.ArryLngResponSystm!["youre_complete"] as? String)!
                    }else {
                        cell.lblProgress.text = (appDelegate.ArryLngResponeCustom!["congrats"] as? String)! + ", " + "\((appDelegate.ArryLngResponeCustom!["youre"] as? String)!) " + strArr[0] + "% " + (appDelegate.ArryLngResponeCustom!["complete"] as? String)! + "!"
                    }
                    let strProgressValue = Float(self.strProgrssBarVlue)
                    cell.progressView.progress = Float((strProgressValue)! / 100.00)
                }
            }else {

                if self.strProgrssBarVlue == ""{
                    cell.progressView.isHidden = true
                    cell.lblProgress.isHidden = true
                    cell.viewCourseOverview.isHidden = false
                }else {
                    let str = self.strProgrssBarVlue
                    let strArr = str.components(separatedBy: ".")
                    if strArr[0] == "00"{
                    }else if strArr[0] == "0"{
                    }else {
                        cell.lblProgress.text = (appDelegate.ArryLngResponeCustom!["congrats"] as? String)! + ", " + "\((appDelegate.ArryLngResponeCustom!["youre"] as? String)!) " + strArr[0] + "% " + (appDelegate.ArryLngResponeCustom!["complete"] as? String)! + "!"
                    }
                    let strProgressValue = Float(self.strProgrssBarVlue)
                    cell.progressView.progress = Float((strProgressValue)! / 100.00)
                }
            }
            
            //image Downloading
            if arryWSTemlateData["image"] as? String != nil{
                let imgUrl = arryWSTemlateData["image"] as? String
                
                let imageName = self.separateImageNameFromUrl(Url: imgUrl!)
                 cell.imgProfile.backgroundColor = color.placeholdrImgColor
                
                if(self.chache.object(forKey: imageName as AnyObject) != nil){
                    cell.imgProfile.image = self.chache.object(forKey: imageName as AnyObject) as? UIImage
                }else{
                    if validation.checkNotNullParameter(checkStr: imgUrl!) == false {
                        Alamofire.request(imgUrl!).responseImage{ response in
                            if let image = response.result.value {
                                cell.imgProfile.image = image
                                self.chache.setObject(image, forKey: imageName as AnyObject)
                            }
                            else {
                                cell.imgProfile.backgroundColor = color.placeholdrImgColor
                            }
                        }
                    }else {
                        cell.imgProfile.backgroundColor = color.placeholdrImgColor
                    }
                }
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "courseHeader") as! CourseHeaderTableViewCell
            
            let genarlSettings = commonElement["general_settings"] as! [String:Any]
            
            //Module Background Color
            let moduleArry = courseElement["module"] as! [String:Any]
            let module_bgcolor = moduleArry["module_bgcolor"] as? String
            cell.backgroundColor = UIColor().HexToColor(hexString: module_bgcolor!)
            
            //Arrow Image
            let moduleArrowTxtcolor = moduleArry["module_arrow_txtcolorHex"] as? String
            
            cell.imgDropdown.image = UIImage(named: "drop-down")?.withRenderingMode(.alwaysTemplate)
            cell.imgDropdown.image = cell.imgDropdown.image?.withRenderingMode(.alwaysTemplate)
            cell.imgDropdown.tintColor = UIColor().HexToColor(hexString: moduleArrowTxtcolor!)
            
            //Module title color
            let moduleTxtcolor = moduleArry["module_text_txtcolorHex"] as? String
            cell.lblTitle.textColor = UIColor().HexToColor(hexString: moduleTxtcolor!)
            cell.lblNumber.textColor = UIColor().HexToColor(hexString: moduleTxtcolor!)
            
            //Title
            if let title = genarlSettings["title"] as? Dictionary<String,String> {
                let size = title["size"]
                let fontstyle = title["fontstyle"]
                let sizeInt:Int = Int(size!)!
                
                cell.lblTitle.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt - 1))
                cell.lblTitle.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeInt - 1))
               
                cell.lblNumber.font = checkForFontType(fontStyle: fontstyle!, fontSize: CGFloat(sizeInt + 8))
                cell.lblNumber.font = UIFont.boldSystemFont(ofSize: CGFloat(sizeInt + 8))
                
                let generalStyle = genarlSettings["general_font"] as! [String:String]
                let fontstyle1 = generalStyle["fontstyle"]
                let txtcolorHex1 = generalStyle["txtcolorHex"]
                
                let generalFontSize = genarlSettings["general_fontsize"] as! [String:String]
                let size1 = generalFontSize["small"]
                let sizeInt1:Int = Int(size1!)!
                
                cell.lblSubtitle.font = checkForFontType(fontStyle: fontstyle1!, fontSize: CGFloat(sizeInt1))
                cell.lblSubtitle.textColor = UIColor().HexToColor(hexString: txtcolorHex1!)
            }
            
            
            let arryOfTopic = arryWSTemlateData["topics"] as! [[String:Any]]
            let currentDic = arryOfTopic[section - 1]
            cell.lblTitle.text = currentDic["name"] as? String
            
            let strHour = currentDic["totalHours"] as? String
            if strHour != "0" {
                let strHour2 = strHour?.compare(".")
                if (strHour2 != nil){
                    if (currentDic["totalLession"] as? String)! == "1"{
                        cell.lblSubtitle.text = (currentDic["totalHours"] as? String)! + " \((appDelegate.ArryLngResponeCustom!["of_training"] as? String)!), " + (currentDic["totalLession"] as? String)! + " " + (appDelegate.ArryLngResponeCustom!["lesson"] as? String)!
                    }else {
                         cell.lblSubtitle.text = (currentDic["totalHours"] as? String)! + " \((appDelegate.ArryLngResponeCustom!["of_training"] as? String)!), " + (currentDic["totalLession"] as? String)! + " " +  (appDelegate.ArryLngResponeCustom!["lessons"] as? String)!
                    }
                }else {
                    let numberAsInt = Int(strHour!)
                    let backToString = "\(numberAsInt!)"
                    if (currentDic["totalLession"] as? String)! == "1"{
                         cell.lblSubtitle.text = backToString + " \((appDelegate.ArryLngResponeCustom!["of_training"] as? String)!), " + (currentDic["totalLession"] as? String)! + (appDelegate.ArryLngResponeCustom!["lesson"] as? String)!
                    }else {
                         cell.lblSubtitle.text = backToString + " \((appDelegate.ArryLngResponeCustom!["of_training"] as? String)!), " + (currentDic["totalLession"] as? String)! + " " +  (appDelegate.ArryLngResponeCustom!["lessons"] as? String)!
                    }
               }
            }else {
                cell.lblSubtitle.text = (currentDic["totalHours"] as? String)! + " \((appDelegate.ArryLngResponeCustom!["of_training"] as? String)!), " + (currentDic["totalLession"] as? String)! + " " +  (appDelegate.ArryLngResponeCustom!["lessons"] as? String)!
            }
            
            cell.lblNumber.text = "\(section)"
            if (expandabaleSection.contains(section - 1)){
                cell.imgDropdown?.image = UIImage(named:"merge")
                cell.lblSubtitle.isHidden = false
            }else{
                cell.imgDropdown?.image = UIImage(named:"drop-down")
                cell.lblSubtitle.isHidden = true
            }
            cell.tag = section - 1
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sectionTaped)))
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            if isMoreClick {
                return UITableViewAutomaticDimension
            }else {
                if strngVlue.count > 150 {
                    return 280
                }else {
                    return 240
                }
            }
        }
        return 50.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if strnoofLine < 3{
            return 70.00
        }else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.00
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            if strngVlue.count > 150 {
                return 280
            }else {
                return 240
            }
        }
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if ((arryWSTemlateData["course_category_id"] as? String) != nil) {
            UserDefaults.standard.set("0", forKey: "ArticleVideoFlag")
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "CourseTemplateDetails") as! CourseTemplateDetails
            nextVC.StrCourseCatgryId = (arryWSTemlateData["course_category_id"] as? String)!
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

//MARK:- favMenuDelagte
extension DetailViewController : favMenuDelagte {
    func homeBtnPress() {
        if validation.isConnectedToNetwork()  {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers
            for aViewController in viewControllers {
                if aViewController is HomeViewController {
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
                //call getHomemenuList >> call CoursesList
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CoursesList") as! CoursesList
                vc.strMenuId = (SelecteItem["id"] as? String)!
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if SelecteItem["type"] as? String == "T"{
                if((SelecteItem["itemType"] as? String) != nil){
                    if SelecteItem["itemType"] as? String == "1"{ //itemType == 1 for corses
                        if ((SelecteItem["template_type"] as? String) != nil){
                            if SelecteItem["template_type"] as? String == "D"{
                                //call getCoursetopiclisting API >> DetailViewController
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                                vc.strCourseId = (SelecteItem["id"] as? String)!
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            }else if SelecteItem["template_type"] as? String == "F"{
                                //getallCourseData API ==>>> CourseTemplateDetails
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

struct HeaderSection {
    var numberCount:String!
    var sectionTitle:String!
    var rowData:[String]!
    var expanded:Bool!
    
    init(numberCount:String,sectionTitle:String,rowData:[String],expanded:Bool) {
        self.expanded = expanded
        self.numberCount = numberCount
        self.sectionTitle = sectionTitle
        self.rowData = rowData
    }
}


//MARK:- WS Parsing
extension DetailViewController {
    
    //MARK: WS Get Home List
    func callWSOfTemplate(){
        
        //URL : http://27.109.19.234/app_builder/index.php/api/getCoursetopiclisting?appclientsId=1&userId=1&userPrivateKey=P6HwAapNVu4WK1Ts&appId=1&courseId=1
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "courseId" : strCourseId]
        
        print("getCoursetopiclisting I/P:",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "getCoursetopiclisting?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            if flgActivity{
                self.startActivityIndicator()
            }
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSOfTemplateList(strURL: strURL, dictionary: dictionary )
        }else{
            stopActivityIndicator()
            self.refreshControl.endRefreshing()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSOfTemplateList(strURL: String, dictionary:Dictionary<String,String>){
        
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            //print("getCoursetopiclisting ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    if let arrayData = JSONResponse["data"] as? [String:Any]{
                        self.stopActivityIndicator()
                        self.arryWSTemlateData = arrayData
                        self.strngVlue = (self.arryWSTemlateData["description"] as? String)!.html2String
                        //htmlToString
                        self.detailTableView.reloadData()
                    }
                    else{
                        self.stopActivityIndicator()
                        self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.oppsMsg, lableNoInternate: string.noDataFoundMsg)
                        self.detailTableView.addSubview(self.noDataView)
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
                        
                        self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: (JSONResponse["title"] as? String)!, lableNoInternate: ((JSONResponse["description"] as? String)! + "\n\(string.errodeCodeString) = [\((JSONResponse["systemErrorCode"] as? String)!)]"))
                        self.detailTableView.addSubview(self.noDataView)
                    }
                    break
                default:
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
                self.noDataView = self.noInternatViewWithReturnView(imgeFlag: "", lableNoData: string.oppsMsg, lableNoInternate: string.someThingWrongMsg)
                self.detailTableView.addSubview(self.noDataView)
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
                          "courseId" : self.strCourseId] as [String : Any]
        
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
            stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSProgressStatus(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            //print(" getCoursePercentage ", JSONResponse)
            if JSONResponse["status"] as? String == "1"{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()

                    let arryData = JSONResponse["response"] as? [[String:Any]]
                    let dic = arryData![0]
                    self.strProgrssBarVlue = (dic["percent"] as? String)!
                    self.detailTableView.reloadData()
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
    
    //MARK:- API of Update Notification Count
    func callWSNotifcnCuntUpdate(){
        //URL: http://27.109.19.234/app_builder/index.php/api/updateCount?appclientsId=1&userId=7&userPrivateKey=NzVxHjwaB6Sqm2u5&appId=1&itemType=2&id=3
        
        let dictionary = ["userId" : userInfo.userId,
                          "userPrivateKey" : userInfo.userPrivateKey,
                          "appclientsId" : userInfo.appclientsId,
                          "appId" : userInfo.appId,
                          "itemType" : "1",
                          "id":self.strCourseId] as [String : Any]
        
        print("I/P updateCount :",dictionary)
        var strURL = ""
        strURL = String(strURL.characters.dropFirst(1))
        strURL = Url.baseURL + "updateCount?"
        print(strURL)
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if validation.isConnectedToNetwork() == true {
            _ = DispatchQueue(label: "com.cnoon.response-queue", qos: .utility, attributes: [.concurrent])
            apiSuccesFlag = "1"
            self.callWSUpdateNofictnCount(strURL: strURL, dictionary: dictionary as! Dictionary<String, String>)
        }else{
            stopActivityIndicator()
            self.view.makeToast(string.noInternateMessage2)
        }
    }
    
    func callWSUpdateNofictnCount(strURL: String, dictionary:Dictionary<String,String>){
        let img = UIImage()
        AFWrapper.requestPostURLForUploadImage(strURL, isImageSelect: false, fileName: "", params: dictionary as [String : AnyObject], image: img, success: { (JSONResponse) in
            self.apiSuccesFlag = "2"
            self.stopActivityIndicator()
            if JSONResponse["status"] as? String == "1"{
                
            }
            else{
                let status = JSONResponse["status"] as? String
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
            print("error: ",error)
        })
    }
}
