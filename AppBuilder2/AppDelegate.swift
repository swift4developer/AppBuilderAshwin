//
//  AppDelegate.swift
//  AppBuilder2
//
//  Created by VISHAL on 27/02/18.
//  Copyright © 2018 VISHAL. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseInstanceID
import UserNotifications
import Fabric
import Crashlytics
import LocalAuthentication
import FirebaseDynamicLinks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var arryFavMenuData = Array<Any>()
    var appStatus = Int()
    let gcmMessageIDKey = "AIzaSyABBm0nXeQgu6BnK3bVtPiS3uqwiBHvC5U"
    var deviceToken = ""
    var jsonData: [String:Any]?
    var alertUiSetting : [String:Any]?
    var strStatusColor = ""
    var helpData = NSDictionary()
    var flgForWebRefresh : Bool!
    var lastPlayedAudoVidoId = ""
    var ArryLngResponSystm: [String:Any]?
    var ArryLngResponeCustom: [String:Any]?
    var appInBackgrnd = false
    
    //var enableAllOrientation = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Override point for customization after application launch.
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        
        IQKeyboardManager.sharedManager().enable = true
        
        //Hold the Splash screen for a seconds
        Thread.sleep(forTimeInterval: 2.0)
        
        NotificationCenter.default.addObserver(self,selector: #selector(self.tokenRefreshNotification),name: NSNotification.Name.InstanceIDTokenRefresh,object: nil)
        
        //MARK: - Call WS
        self.getTheUISettingData()
        
        /*if #available(iOS 10.0, *) {
         // For iOS 10 display notification (sent via APNS)
         UNUserNotificationCenter.current().delegate = self
         let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
         UNUserNotificationCenter.current().requestAuthorization(
         options: authOptions,
         completionHandler: {_, _ in })
         // For iOS 10 data message (sent via FCM)
         // FIRMessaging.messaging().remoteMessageDelegate = self
         } else {
         let settings: UIUserNotificationSettings =
         UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
         application.registerUserNotificationSettings(settings)
         }
         application.registerForRemoteNotifications()*/
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if let incomingURL = userActivity.webpageURL {
            let handleLink = DynamicLinks.dynamicLinks()?.handleUniversalLink(incomingURL, completion: { (dynamicLink, error) in
                if let dynamicLink = dynamicLink, let _ = dynamicLink.url {
                    print("Your Dynamic Link parameter: \(dynamicLink)")
                    
                } else {
                    // Check for errors
                }
            })
            return handleLink!
        }
        return false
    }
    
    func handleDynamicLink(_ dynamicLink: DynamicLink) {
        print("Your Dynamic Link parameter: \(dynamicLink)")
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        //Here we get the dynamic link
        print("URL",url)
        
        return true
    }
    
    func setHomeRootForOffline() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        navigationController.viewControllers = [rootViewController]
        self.window?.rootViewController = navigationController
    }
    
    func loadDynamicUI(getJsonData:[String:Any]) {
        
        self.jsonData = getJsonData
        let data1 = jsonData!["data"] as? [String:Any]
        let commonElement = data1!["common_element"] as! [String:Any]
        
        let navigation = commonElement["navigation_bar"] as! [String:Any]
        strStatusColor = navigation["bgcolor"] as! String
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor().HexToColor(hexString: strStatusColor)
        
        let genralSetting = commonElement["general_settings"] as! [String:Any]
        //Mark: Comman Element for the Comman function
        //Common Font Style
        
        if let title = commonElement["general_font"] as? Dictionary<String,String> {
            let size = title["size"]
            let txtcolorHex = title["txtcolorHex"]
            let fontstyle = title["fontstyle"]
            let sizeInt:Int = Int(size!)!
            
            color.commonTitleColor = txtcolorHex!
            fontAndSize.commonTitleFontSize = CGFloat(sizeInt)
            fontAndSize.commonTitleFontStyle = fontstyle!
        }
        
        //Title for all comman screens
        if let title = commonElement["title"] as? Dictionary<String,String> {
            let size = title["size"]
            let txtcolorHex = title["txtcolorHex"]
            let fontstyle = title["fontstyle"]
            let sizeInt:Int = Int(size!)!
            
            color.commonTitleColor = txtcolorHex!
            fontAndSize.commonTitleFontSize = CGFloat(sizeInt)
            fontAndSize.commonTitleFontStyle = fontstyle!
        }
        
        //SubTitle for all comman screens
        if let subtitle = commonElement["subtitle"] as? Dictionary<String,String> {
            let size = subtitle["size"]
            let txtcolorHex = subtitle["txtcolorHex"]
            let fontstyle = subtitle["fontstyle"]
            let sizeInt:Int = Int(size!)!
            
            color.commonSubTitleColor = txtcolorHex!
            fontAndSize.commonSubTitleFontSize = CGFloat(sizeInt)
            fontAndSize.commonSubTitleFontStyle = fontstyle!
        }
        
        //Notification for all comman screens
        if let notification_bubble = commonElement["notification_bubble"] as? Dictionary<String,String> {
            let size = notification_bubble["size"]
            let txtcolorHex = notification_bubble["txtcolorHex"]
            let fontstyle = notification_bubble["fontstyle"]
            let bgColor = notification_bubble["bgcolor"]
            let sizeInt:Int = Int(size!)!
            
            color.commonNotificationImgBackdrnd = UIColor().HexToColor(hexString: bgColor!)
            color.commonNotificationTitle = UIColor().HexToColor(hexString: txtcolorHex!)
            fontAndSize.commonNotificationTitleFontSize = CGFloat(sizeInt)
            fontAndSize.commonNotificationTitleFontStyle = fontstyle!
        }
        
        
        alertUiSetting = genralSetting["alert_msg"]  as? [String:Any]
        
        //Alert for all title
        if let title = alertUiSetting!["title"] as? Dictionary<String,String> {
            let size = title["size"]
            let txtcolorHex = title["txtcolorHex"]
            let fontstyle = title["fontstyle"]
            let sizeInt:Int = Int(size!)!
            
            color.alertTitleTextColor = UIColor().HexToColor(hexString: txtcolorHex!)
            fontAndSize.alertTitleFontSize = CGFloat(sizeInt)
            fontAndSize.alertTitleFontStyle = fontstyle!
        }
        
        //Alert for sub title
        if let subtitle = alertUiSetting!["subtitle"] as? Dictionary<String,String> {
            let size = subtitle["size"]
            let txtcolorHex = subtitle["txtcolorHex"]
            let fontstyle = subtitle["fontstyle"]
            let sizeInt:Int = Int(size!)!
            
            color.alertSubTitleTextColor = UIColor().HexToColor(hexString: txtcolorHex!)
            fontAndSize.alertSubTitleFontSize = CGFloat(sizeInt)
            fontAndSize.alertSubTitleFontStyle = fontstyle!
        }
        
        //Alert positive button
        if let btnPositiv = alertUiSetting!["positive"] as? Dictionary<String,String> {
            let size = btnPositiv["size"]
            let txtcolorHex = btnPositiv["txtcolorHex"]
            let fontstyle = btnPositiv["fontstyle"]
            let sizeInt:Int = Int(size!)!
            
            color.alertPositiveBtnTxtColor = UIColor().HexToColor(hexString: txtcolorHex!)
            fontAndSize.alertPositiveBtnFontSize = CGFloat(sizeInt)
            fontAndSize.alertPositiveBtnFontStyle = fontstyle!
        }
        //Alert Negative button
        if let btnNegative = alertUiSetting!["positive"] as? Dictionary<String,String> {
            let size = btnNegative["size"]
            let txtcolorHex = btnNegative["txtcolorHex"]
            let fontstyle = btnNegative["fontstyle"]
            let sizeInt:Int = Int(size!)!
            
            color.alertNegativeBtnTxtColor = UIColor().HexToColor(hexString: txtcolorHex!)
            fontAndSize.alertNegativeBtnFontSize = CGFloat(sizeInt)
            fontAndSize.alertNegativeBtnFontStyle = fontstyle!
        }
        //Alert Warning button
        if let btnPositiv = alertUiSetting!["positive"] as? Dictionary<String,String> {
            let size = btnPositiv["size"]
            let txtcolorHex = btnPositiv["txtcolorHex"]
            let fontstyle = btnPositiv["fontstyle"]
            let sizeInt:Int = Int(size!)!
            
            color.alertWarningBtnTxtColor = UIColor().HexToColor(hexString: txtcolorHex!)
            fontAndSize.alertWarningBtnFontSize = CGFloat(sizeInt)
            fontAndSize.alertWarningBtnFontStyle = fontstyle!
        }
    }
    
    func getTheUISettingData() {
        if validation.isConnectedToNetwork() {
            
            let strURL:URL = URL(string: Url.baseURL + "getUiSettingsNew?ostype=2&appclientsId=" + userInfo.appclientsId)!
            
            print("UI Settings ",strURL)
            let result = synchronousDataTaskWithURL(url: strURL, timeout: 7.0)
            
            if result.0 != nil {
                
                do {
                    let data = result.0! as Data
                    
                    //save data to local
                    let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("UISetting.json")
                    do {
                        try data.write(to: documentDirectoryUrl!, options: [])
                    } catch {
                        print("Error while writing data to local",error)
                    }
                    
                    jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    if jsonData != nil {
                        print("json",jsonData!)
                        if (jsonData!["status"] as? String == "1"){
                            
                            userInfo.appId = jsonData!["appId"] as! String
                            userInfo.appclientsId = jsonData!["appclientsId"] as! String
                            UserDefaults.standard.setValue(jsonData!["appId"] as! String, forKey: "appId")
                            UserDefaults.standard.setValue(jsonData!["appclientsId"] as! String, forKey: "appclientsId")
                            loadDynamicUI(getJsonData: jsonData!)
                            userInfo.isMultiLang = jsonData!["isMultiLang"] as! String
                            
                            if userInfo.isMultiLang == "0"{
                                let langId = jsonData!["languageId"] as! String
                                UserDefaults.standard.set(langId, forKey: "strlanguageID")
                                UserDefaults.standard.synchronize()
                                getLagData(strlangID: langId)
                            }else {
                                var langID = ""
                                if UserDefaults.standard.string(forKey: "strlanguageID") != nil {
                                    langID = UserDefaults.standard.string(forKey: "strlanguageID")!
                                }else {
                                    langID = "1"
                                }
                                getLagData(strlangID: langID)
                            }
                        }else {
                            userInfo.appId = "0"
                            userInfo.appclientsId = "0"
                        }
                    }else {
                        print("Error in API UIsetting")
                    }
                }
            } else {
                slowNtwrk()
            }
        }else {
            //Override point for customization after application launch.
            //responceAlert(alertTitle: "Please wait. We are setting the app for you. Please wait or try again.")
            let manager = FileManager.default
            let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("UISetting.json")
            // Transform array into data and save it into file
            if manager.fileExists(atPath: documentDirectoryUrl.relativePath) {
                do {
                    let data = try Data(contentsOf: documentDirectoryUrl, options: [])
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        self.jsonData = jsonArray
                        // navigate to home
                        let data1 = self.jsonData!["data"] as? [String:Any]
                        let commonElement = data1!["common_element"] as! [String:Any]
                        
                        UserDefaults.standard.setValue(jsonData!["appId"] as! String, forKey: "appId")
                        UserDefaults.standard.setValue(jsonData!["appclientsId"] as! String, forKey: "appclientsId")
                        
                        let navigation = commonElement["navigation_bar"] as! [String:Any]
                        strStatusColor = navigation["bgcolor"] as! String
                        UIApplication.shared.statusBarStyle = .lightContent
                        //UIApplication.shared.statusBarView?.backgroundColor = UIColor().HexToColor(hexString: strStatusColor)
                        self.setHomeRootForOffline()
                    } else {
                        print("Oops.!! Something went wrong. Please try again later.")
                    }
                } catch {
                    print("Error while data fetching",error)
                }
            }else {
                print("File Does not exit")
                let topWindow = UIWindow(frame: UIScreen.main.bounds)
                topWindow.rootViewController = UIViewController()
                topWindow.windowLevel = UIWindowLevelAlert + 1
                
                let alrtTitleStr = NSMutableAttributedString(string: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String))
                alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
                
                let alrtMessage = NSMutableAttributedString(string: "Please check your internet connection.")
                alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:14.0) , range: NSRange(location: 0, length: alrtMessage.length))
                
                let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
                alert.setValue(alrtTitleStr, forKey: "attributedTitle")
                alert.setValue(alrtMessage, forKey: "attributedMessage")
                
                //(self.appDelegate.ArryLngResponeCustom!["retry"] as? String)!
                alert.addAction(UIAlertAction(title:"Retry", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                    // continue your work
                    self.getTheUISettingData()
                    topWindow.isHidden = true
                }))
                topWindow.makeKeyAndVisible()
                topWindow.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func slowNtwrk(){
        //responceAlert(alertTitle: "Please wait. We are setting the app for you. Please wait or try again.")
        
        let manager = FileManager.default
        let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("UISetting.json")
        // Transform array into data and save it into file
        if manager.fileExists(atPath: documentDirectoryUrl.relativePath) {
            do {
                let data = try Data(contentsOf: documentDirectoryUrl, options: [])
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    self.jsonData = jsonArray
                    //Get the UISettingData
                    let data1 = self.jsonData!["data"] as? [String:Any]
                    let commonElement = data1!["common_element"] as! [String:Any]
                    
                    UserDefaults.standard.setValue(jsonData!["appId"] as! String, forKey: "appId")
                    UserDefaults.standard.setValue(jsonData!["appclientsId"] as! String, forKey: "appclientsId")
                    
                    let navigation = commonElement["navigation_bar"] as! [String:Any]
                    strStatusColor = navigation["bgcolor"] as! String
                    UIApplication.shared.statusBarStyle = .lightContent
                    
                    //Get the Lang Data
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("LangDataJson.json")
                    if FileManager.default.fileExists(atPath: documentsURL.relativePath) {
                        self.ArryLngResponSystm = retrieveLangDataFileAPPDelegate()["responseSystem"] as? [String:Any]
                        self.ArryLngResponeCustom = retrieveLangDataFileAPPDelegate()["responseCustom"] as? [String:Any]
                        string.noInternateMessage2 = (self.ArryLngResponSystm!["internet_error_msg"] as? String)!
                        string.noDataFoundMsg = (self.ArryLngResponSystm!["no_data_found"] as? String)!
                        string.oppsMsg = "OOPS!"
                        string.someThingWrongMsg = (self.ArryLngResponSystm!["general_err_msg"] as? String)!
                        string.someThingWrongMsg2 = (self.ArryLngResponSystm!["general_err_msg"] as? String)!
                        string.privateKeyMsg = (self.ArryLngResponSystm!["force_logout_msg"] as? String)!
                        string.errodeCodeString = (self.ArryLngResponeCustom!["error_code"] as? String)!
                    }
                    UserDefaults.standard.set("0", forKey: "offLineFlag")
                } else {
                    print("Oops.!! Something went wrong. Please try again later.")
                }
            } catch {
                print("Error while data fetching",error)
            }
        }else {
            print("File Does not exit")
            let topWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            
            let alrtTitleStr = NSMutableAttributedString(string: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String))
            alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
            
            let alrtMessage = NSMutableAttributedString(string: "Please check your internet connection.")
            alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:14.0) , range: NSRange(location: 0, length: alrtMessage.length))
            
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            alert.setValue(alrtTitleStr, forKey: "attributedTitle")
            alert.setValue(alrtMessage, forKey: "attributedMessage")
            
            //(self.appDelegate.ArryLngResponeCustom!["retry"] as? String)!
            alert.addAction(UIAlertAction(title:"Retry", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                // continue your work
                self.getTheUISettingData()
                topWindow.isHidden = true
            }))
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func responceAlert(alertTitle: String){
        let topWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindowLevelAlert + 1
        
        let alrtTitleStr = NSMutableAttributedString(string: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String))
        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
        
        let alrtMessage = NSMutableAttributedString(string: alertTitle)
        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:14.0) , range: NSRange(location: 0, length: alrtMessage.length))
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.setValue(alrtTitleStr, forKey: "attributedTitle")
        alert.setValue(alrtMessage, forKey: "attributedMessage")
        
        //let alert = UIAlertController(title: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String), message: "Please wait. We are setting the app for you. Please wait or try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            // continue your work
            // important to hide the window after work completed.
            // this also keeps a reference to the window until the action is invoked.
            topWindow.isHidden = true
        }))
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
    func retrieveLangDataFileAPPDelegate() -> [String:Any] {
        //Get the url of Persons.json in document directory
        var responseData = [String:Any]()
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return ["":""]}
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("LangDataJson.json")
        //Read data from .json file and transform data into an array
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let personArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]  else {
                return ["":""]
            }
            responseData = personArray
            print(#function,fileUrl)
        } catch {
            print(error)
        }
        return responseData
    }
    
    //MARK:- Lang Data
    func getLagData(strlangID:String){
        
        let langUrl = URL(string: Url.baseURL + "getLabels?osType=2&appclientsId=" + userInfo.appclientsId + "&languageId=" + strlangID + "&userId=" + "&userPrivateKey=" + "&appId=" + userInfo.appId)!
        print("getLabels Url ", langUrl)
        let resultData = synchronousDataTaskWithURL(url: langUrl , timeout: 10.0)
        if resultData.0 != nil {
            do {
                let data = resultData.0! as Data
                //save data to local
                let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("LangDataJson.json")
                do {
                    try data.write(to: documentDirectoryUrl!, options: [])
                    
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("LangDataJson.json")
                    if FileManager.default.fileExists(atPath: documentsURL.relativePath) {
                        self.ArryLngResponSystm = retrieveLangDataFileAPPDelegate()["responseSystem"] as? [String:Any]
                        self.ArryLngResponeCustom = retrieveLangDataFileAPPDelegate()["responseCustom"] as? [String:Any]
                    }
                    
                    string.noInternateMessage2 = (self.ArryLngResponSystm!["internet_error_msg"] as? String)!
                    string.noDataFoundMsg = (self.ArryLngResponSystm!["no_data_found"] as? String)!
                    string.oppsMsg = "OOPS!"
                    string.someThingWrongMsg = (self.ArryLngResponSystm!["general_err_msg"] as? String)!
                    string.someThingWrongMsg2 = (self.ArryLngResponSystm!["general_err_msg"] as? String)!
                    string.privateKeyMsg = (self.ArryLngResponSystm!["force_logout_msg"] as? String)!
                    string.errodeCodeString = (self.ArryLngResponeCustom!["error_code"] as? String)!
                } catch {
                    print("Error while writing data to local",error)
                }
            }
        }else {
            responceAlert(alertTitle: "Please wait. We are setting the app language for you. Please wait or try again.")
        }
    }
    
    //MARK: - Notification Delegates
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        //print("Recvide notification in didReceiveRemoteNotification ",userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        
        let notificationCount = userInfo[AnyHashable("gcm.notification.notificationCount")] as? String
        if notificationCount != nil {
            //let application1 = UIApplication.shared
            application.applicationIconBadgeNumber = Int(notificationCount!)!
        }
        
        switch application.applicationState {
        case .active:
            //app is currently active, can update badges count here
            appStatus = 1
            break
        case .inactive:
            appStatus = 2
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
            break
        case .background:
            appStatus = 3
            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
            break
        default:
            break
        }
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        //print("Recvide notification in fetchCompletionHandler ",userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    // [START refresh_token]
    @objc func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = InstanceID.instanceID().token() {
            //UserDefaults.standard.set(refreshedToken , forKey: "deviceToken")
            deviceToken = refreshedToken
            print("Token",deviceToken)
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    // [END refresh_token]
    // [START connect_to_fcm]
    func connectToFcm() {
        // Won't connect since there is no token
        guard InstanceID.instanceID().token() != nil else {
            return;
        }
        
        // Disconnect previous FCM connection if it exists.
        //FIRMessaging.messaging().disconnect()
        
        /*FIRMessaging.messaging().connect { (error) in
         if error != nil {
         print("Unable to connect with FCM. \(String(describing: error))")
         } else {
         print("Connected to FCM.")
         }
         }*/
    }
    // [END connect_to_fcm]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the InstanceID token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        /*let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
         print("Device Token ",deviceTokenString)
         UserDefaults.standard.set(deviceTokenString , forKey: "deviceToken")*/
        
        // With swizzling disabled you must set the APNs token here.
        // FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
    }
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }    

    func applicationWillResignActive(_ application: UIApplication) {
        appInBackgrnd = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "applicationResignActive"), object: nil)
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        appInBackgrnd = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "applicationInBackground"), object: nil)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        if !(validation.isConnectedToNetwork()) && UserDefaults.standard.string(forKey: "offLineFlag") != "0"{
            
            let topWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            
            let alrtTitleStr = NSMutableAttributedString(string: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String))
            alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
            
            let alrtMessage = NSMutableAttributedString(string: "Please check your internet connection.")
            alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:14.0) , range: NSRange(location: 0, length: alrtMessage.length))
            
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            alert.setValue(alrtTitleStr, forKey: "attributedTitle")
            alert.setValue(alrtMessage, forKey: "attributedMessage")
            
            //let alert = UIAlertController(title: (Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String), message: "Please check your internet connection.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "confirm"), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                // continue your work
                // important to hide the window after work completed.
                // this also keeps a reference to the window until the action is invoked.
                topWindow.isHidden = true
            }))
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: nil)
        }else {
            if UserDefaults.standard.string(forKey: "EnableFingerPrint") == "1"{
                FigerPrint()
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /*func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if (enableAllOrientation == true){
            return UIInterfaceOrientationMask.allButUpsideDown
        }
        return UIInterfaceOrientationMask.portrait
    }*/
    
    
    //For login landscape lock
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        if UserDefaults.standard.string(forKey: "VideoAudioRoateFlag") != nil {
            if UserDefaults.standard.string(forKey: "VideoAudioRoateFlag") == "1" {
                if let rootViewController = self.topViewControllerWithRootViewController(rootViewController: window?.rootViewController) {
                    if (rootViewController.responds(to: Selector(("canRotate")))) {
                        return .allButUpsideDown
                    }else{
                        return .portrait
                    }
                }else {
                    return .portrait
                }
            }else {
                return .portrait
            }
        }
       return .portrait
    }
    
    private func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
        if (rootViewController == nil) { return nil }
        if (rootViewController.isKind(of: UITabBarController.self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UITabBarController).selectedViewController)
        } else if (rootViewController.isKind(of: UINavigationController.self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UINavigationController).visibleViewController)
        } else if (rootViewController.presentedViewController != nil) {
            return topViewControllerWithRootViewController(rootViewController: rootViewController.presentedViewController)
        }
        return rootViewController
    }
}

//MARK:- Call API of UISetting
extension AppDelegate {
    func synchronousDataTaskWithURL(url: URL, timeout: TimeInterval) -> (Data?, URLResponse?, Error?) {
        var data1: Data?, response1: URLResponse?, error1: Error?
        let semaphore = DispatchSemaphore(value: 0)
        let session = URLSession.shared
        var request = URLRequest.init(url: url)
        request.timeoutInterval = timeout
        
        session.dataTask(with: request) { (data, response, error) in
            data1 = data
            response1 = response
            error1 = error
            semaphore.signal()
            }.resume()
        semaphore.wait()
        
        return (data1, response1, error1)
    }
}


@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        completionHandler(.alert);
        //  completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // Application in background mode. Active / In Active (it open the splash)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        completionHandler()
    }
    
    //    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
    //        print(remoteMessage.appData)
    //    }
}

//MARK: Finger print
extension AppDelegate{
    
    func FigerPrint(){
        
        var strResponce = ""
        var strCncledByuser = ""
        var strUserTppedHome = ""
        if ArryLngResponSystm != nil {
            strResponce = (ArryLngResponeCustom!["view_membership"] as? String)!
            strCncledByuser = (ArryLngResponSystm!["authenticatn_canceled_user﻿"] as? String)!
            strUserTppedHome = (ArryLngResponSystm!["user_tapped_Homebutton﻿"] as? String)!
        }else {
            strResponce = "Log on to view your membership"
            strCncledByuser = "Authentication was canceled by user."
            strUserTppedHome = "The user tapped the Home button."
        }
        
        let authentictionContext = LAContext()
        var error: NSError?
        
        if authentictionContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            //Pop for Touch ID and handling the error
            authentictionContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason:
                strResponce, reply: { (success, error) in
                    if success{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "faceFingerIDSucess"), object: nil)
                        /*/self.navigateAuthentictionVC()
                        let alertController = UIAlertController(title: "Success!!", message: "User Authenticated successfully,Your finger print is added succesfully.", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
                        self.present(alertController,animated: true,completion: nil)*/
                    }else {
                        if let error = error as NSError?{
                            //Display specific error
                            let errorMessage = self.errorMessageForLAErrorCode(errorCode: error.code)
                            if errorMessage ==  strCncledByuser{
                                UserDefaults.standard.set("2", forKey: "EnableFingerPrint")
                                self.logOut()
                            }else if errorMessage == strUserTppedHome{
                                UserDefaults.standard.set("3", forKey: "EnableFingerPrint")
                                self.logOut()
                            }else {
                                UserDefaults.standard.set("3", forKey: "EnableFingerPrint")
                                self.showAlerViewAfterEvaluatePolicyWithMessage(message:errorMessage)
                            }
                        }
                    }
            })
            
        }else {
            //showAlertViewForNoBioMatric()
            return
        }
    }
    
    func showAlerViewAfterEvaluatePolicyWithMessage(message: String){
        showAlertWithTitle(title: "Error!", message: message)
    }
    
    func errorMessageForLAErrorCode(errorCode: Int) -> String{
        var message = ""
        switch errorCode {
        case LAError.authenticationFailed.rawValue:
            if ArryLngResponSystm != nil {
                message = (ArryLngResponSystm!["problem_verifying_identity"] as? String)!
            }else {
                message = "There was a problem verifying your identity."
            }
        case LAError.userCancel.rawValue:
            if ArryLngResponSystm != nil {
                message = (ArryLngResponSystm!["authenticatn_canceled_user﻿"] as? String)!
            }else {
                message = "Authentication was canceled by user."
            }
        case LAError.userFallback.rawValue:
            if ArryLngResponSystm != nil {
                message = (ArryLngResponSystm!["user_tapped_Homebutton﻿"] as? String)!
            }else {
                 message = "The user tapped the Home button."
            }
        case LAError.systemCancel.rawValue:
            if ArryLngResponSystm != nil {
                message = (ArryLngResponSystm!["authentictn_cancel_system"] as? String)!
            }else {
                message = "Authentication was canceled by system."
            }
        case LAError.passcodeNotSet.rawValue:
            if ArryLngResponSystm != nil {
                message = (ArryLngResponSystm!["passcod_not_device﻿"] as? String)!
            }else {
                message = "Passcode is not set on the device."
            }
        case LAError.touchIDNotAvailable.rawValue:
            var msgInfo = ""
            if DeviceType.IS_IPHONE_x {
                if ArryLngResponSystm != nil {
                    msgInfo = (ArryLngResponSystm!["face_notAvailable_device"] as? String)!
                }else {
                    msgInfo = "Face ID is not available on the device."
                }
            }else {
                if ArryLngResponSystm != nil {
                    msgInfo = (ArryLngResponSystm!["touchid_notAvailable"] as? String)!
                }else {
                    msgInfo = "Touch ID is not available on the device."
                }
            }
            message = msgInfo
        case LAError.touchIDNotEnrolled.rawValue:
            if ArryLngResponSystm != nil {
                message = (ArryLngResponSystm!["touch_notenrolled_fingers﻿"] as? String)!
            }else {
                message = "Touch ID has no enrolled fingers."
            }
        case LAError.touchIDLockout.rawValue:
            var msgInfo = ""
            if DeviceType.IS_IPHONE_x {
                if ArryLngResponSystm != nil {
                    msgInfo = (ArryLngResponSystm!["failedFaceId_attempts"] as? String)!
                }else {
                    msgInfo = "There were too many failed Face ID attempts and Face ID is now locked."
                }
            }else {
                if ArryLngResponSystm != nil {
                    msgInfo = (ArryLngResponSystm!["failedTouchId_attempts﻿"] as? String)!
                }else {
                    msgInfo = "There were too many failed Touch ID attempts and Touch ID is now locked."
                }
            }
            message = msgInfo
        case LAError.appCancel.rawValue:
            if ArryLngResponSystm != nil {
                message = (ArryLngResponSystm!["Authentictn_canceled_app﻿"] as? String)!
            }else {
                 message = "Authentication was canceled by application."
            }
        case LAError.invalidContext.rawValue:
            message = "LAContext passed to this call has been previously invalidated."
        default:
            var msgInfo = ""
            if DeviceType.IS_IPHONE_x {
                if ArryLngResponSystm != nil {
                    msgInfo = (ArryLngResponSystm!["faceid_notConfigured﻿"] as? String)!
                }else {
                     msgInfo = "Face ID may not be configured"
                }
            }else {
                if ArryLngResponSystm != nil {
                    msgInfo = (ArryLngResponSystm!["touchid_notConfigured"] as? String)!
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
            if ArryLngResponSystm != nil {
                msgInfo = (ArryLngResponSystm!["faceid_notenable"] as? String)!
            }else {
                msgInfo = "You have not enable Face ID access for this device.Please check with settings to enable."
            }
        }else {
            if ArryLngResponSystm != nil {
                msgInfo = (ArryLngResponSystm!["touchid_notenable"] as? String)!
            }else {
                msgInfo = "You have not enable Fingerprint access for this device.Please check with settings to enable."
            }
        }
        
        if ArryLngResponeCustom != nil {
            showAlertWithTitle(title: (ArryLngResponSystm!["sorry"] as? String)!, message: msgInfo)
        }else {
            showAlertWithTitle(title: "Sorry!", message: msgInfo)
        }
        
    }
    
    func showAlertWithTitle(title: String , message : String){
        
        let alrtTitleStr = NSMutableAttributedString(string: title)
        alrtTitleStr.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: NSRange(location: 0, length: alrtTitleStr.length))
        
        let alrtMessage = NSMutableAttributedString(string: message)
        alrtMessage.addAttribute(NSAttributedStringKey.font, value:  UIFont.systemFont(ofSize:16.0) , range: NSRange(location: 0, length: alrtMessage.length))
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.setValue(alrtTitleStr, forKey: "attributedTitle")
        alertController.setValue(alrtMessage, forKey: "attributedMessage")
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{ (UIAlertAction) in
            self.logOut()
        }))
        DispatchQueue.main.async{
            let topWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func logOut(){
        // switch root view controllers
        DispatchQueue.main.async{
            UserDefaults.standard.set("1", forKey: "popToRootController")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "popToRootViewController"), object: nil)
        }
        
    }
}
