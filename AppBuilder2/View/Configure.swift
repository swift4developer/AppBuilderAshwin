//
//  Configuration.swift
//  MalaBes
//
//  Created by PUNDSK006 on 4/18/17.
//  Copyright © 2017 Intechcreative Pvt. Ltt. All rights reserved.

import Foundation
import UIKit

//URL Struct
struct Url{
    //static let baseURL = ""
    static let baseURL = "http://cms.membrandt.com/index.php/api/"
    
    //"http://cmsstaging.membrandt.com/index.php/api/" AWS new Staging
    //"http://cms.membrandt.com/index.php/api/" AWS Live version V1.0
    //"http://103.51.153.235/app_builder/api/" //for testing only
    //"http://103.51.153.235/app_builder_clone/index.php/api/" // Live Clone on 103
    //"http://cmsstaging.membrandt.com/clone/index.php/api/" //Live Clone on Staging
    //"http://cms.membrandt.com/v2/index.php/api/" AWS Live version V1.2
    
    static let autocompleteLocationApi = "https://maps.googleapis.com/maps/api/place/autocomplete/json?types=establishment&language=eng&key=\(string.googleAPIKeyForGeoCode)&input="
    
    static let getAddressApi = "https://maps.googleapis.com/maps/api/geocode/json?key=\(string.googleAPIKeyForGeoCode)&latlng="
    static let getLatLongApi = "https://maps.googleapis.com/maps/api/place/details/json?key=\(string.googleAPIKeyForGeoCode)&sensor=false&reference="
}
// MARK: static String Data
struct string{
    //MARK: TabMenu Array
    //Toast Msg
    //static var noInternetConnMsg = NSLocalizedString("No Internet", comment: "")
    static var noInternateMessage2 = NSLocalizedString("Please check your internet connection.", comment: "")
    static var noDataFoundMsg = NSLocalizedString("We didn't find any data", comment: "")
    static var noDataFoundMsgForMyPost = NSLocalizedString("We didn't find any Post", comment: "")
    static var noDataFoundMsgForDetal = NSLocalizedString("We didn't find any Notification", comment: "")
    static var oppsMsg = NSLocalizedString("OOPS!", comment: "")
    static var someThingWrongMsg = NSLocalizedString("Something went wrong. Please try again later.", comment: "")
    static var someThingWrongMsg2 = NSLocalizedString("Oops.!! Something went wrong. Please try again later.", comment: "")
    
    static var privateKeyMsg = "For security reasons you are \nlogged out, please login \nonce again."
  
    static let googleAPIKey = "AIzaSyAGQ2I-AIzaSyABBm0nXeQgu6BnK3bVtPiS3uqwiBHvC5U"
    static let googleAPIKeyForGeoCode = "AIzaSyAGQ2I-WDdvkqR3IGUIbNYiNYBvtmfQFMQ"
    
    static let txtFiledMsg = " is blank"
    static var errodeCodeString = ""
}

struct userInfo {
    static var appId = "26" //"19"
    static var userId = "1"
    static var userPrivateKey = ""
    static let deviceType = "2"
    static var deviceUDID = ""
    static var logOuterrorCode = "99"
    static var dataErrorCode = "1"
    static var adminUserflag = "0"
    static var isMultiLang = ""
    
    //MARK:- Select your app appclientsId &  App Apple id :-
    
    //ISMastery - Troy Broussard
    static var appclientsId = "1"
    static var appleId = "1397366387"
    
    //Membrandt™ Fulfillment :
    //static var appclientsId = "6"
    //static var appleId = ""
    
    //Chilionair App : Kevin Nations
    //static var appclientsId = "3"
    //static var appleId = "1414137411"
    
    //Theo Trad - Jeff Roth
    //static var appclientsId = "8"
    //static var appleId = "1397720452"
    
    //iBLE / Bright Line Eating - Julia Harold
    //static var appclientsId = "10"
    //static var appleId = "1398165554"
    
    //Astrology Hub's Inner Circle - Amanda and Richard
    //static var appclientsId = "9"
    //static var appleId = "1398223636"
    
    //Craig Hill -Johnathan Hill (Family Foundations International)
    //static var appclientsId = "17"
    //static var appleId = "1397704704"
    
    //Demo
    //static var appclientsId = "2"
    //static var appleId = ""
    
    //Julian Dickie : Julian Dickie
    //static var appclientsId = "18"
    //static var appleId = ""
    
    //Marketing Web • Stephanie Hetu : Stephanie Hetu
    //static var appclientsId = "19"
    //static var appleId = "1436300496"
    
    //Thrive To Success : Olga Gerardin
    //static var appclientsId = "20"
    //static var appleId = ""
    
    //AdSkills :  Chaunna Brooke
    //static var appclientsId = "21"
    //static var appleId = "1410747693"
    
    //The Created Life : Sandi Amorim
    //static var appclientsId = "22"
    //static var appleId = ""
    
    //Moreno Bonechi : Moreno Bonechi
    //static var appclientsId = "11"
    //static var appleId = "1445815986"
    
    //Big Man Plan : Big Man Plan
    //static var appclientsId = "27"
    //static var appleId = "1435027982"
    
    //The Simplifier : Tom Beal
    //static var appclientsId = "28"
    //static var appleId = "1406784931"
    
    //Kaizen Coaching : Isaac Stegman
    //static var appclientsId = "24"
    //static var appleId = "1436270832"
    
    //Capitalism.com : Ryan Moran
    //static var appclientsId = "32"
    //static var appleId = "1436300634"
    
    //Maxi Mind Learning : Moshe Gotfryd
    //static var appclientsId = "31"
    //static var appleId = "1436280574"
    
    //Iñigo Lacasa / Alex Makarski : Rocio Lacasa
    //static var appclientsId = "33"
    //static var appleId = ""
    
    //Apt. Autopilot  : Autopilot Appointment App
    //static var appclientsId = "29"
    //static var appleId = ""
    
    //Readitfor.me  : Readitfor.me
    //static var appclientsId = "39"
    //static var appleId = "68"
    
    
    //MARK: --------------
}

// MARK: Color
struct color{
    
    //TextField BorderColor
    static let shakeBorderColor = UIColor.red
    static let theamColor = UIColor(red: 106.0/255.0, green: 49.0/255.0, blue: 144.0/255.0, alpha: 1.0)
    
    //Place holder image color
    static let placeholdrImgColor = UIColor(red: 85.0/255.0, green:  85.0/255.0, blue:  85.0/255.0, alpha: 1.0)
    
    //PageMenu
    static let pgeMenuBorderColor = UIColor(red: 193.0/255.0, green: 193.0/255.0, blue: 193.0/255.0, alpha: 1.0)
    static let unSeleMenu = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.8)
    static let selectedMenu = UIColor.black
    
    //MainViewController Color
    static let ImgborderCoor = UIColor(red: 134.0/255.0, green: 135.0/255.0, blue: 136.0/255.0, alpha: 1.0)
    static let viewBgColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    static let selectionIndicatorColor = UIColor.black
    static let navigationColor = UIColor(red: 127.0/255.0, green: 184.0/255.0, blue: 77.0/255.0, alpha: 1.0)
    static let navigationDarkColor = UIColor(red: 17.0/255.0, green: 54.0/255.0, blue: 92.0/255.0, alpha: 1.0)
    static let drawerSelectedCellColor = UIColor(red: 2.0/255.0, green: 94.0/255.0, blue: 166.0/255.0, alpha: 1.0)
    
    static let navigationBar =  UIColor.white
    // green
    static let barTintColor = UIColor(red:0.50, green:0.72, blue:0.30, alpha:1.0)
    //UIColor(red: 37.0/255.0, green: 107.0/255.0, blue: 155.0/255.0, alpha: 1.0)
    
    //rgb(0,122,256)
    static let skyBlueColor = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 256/255.0, alpha: 1.0)
    
    //TextField Color
    static let placeHolderClr = UIColor(red: 68.0/255.0, green: 153.0/255.0, blue: 220.0/255.0, alpha: 1.0)
    static let txtFieldBorderColor = UIColor(red: 68.0/255.0, green: 153.0/255.0, blue: 220.0/255.0, alpha: 1.0)
    static let txtFieldTintColor = UIColor(red: 106.0/255.0, green: 49.0/255.0, blue: 144.0/255.0, alpha: 1.0)
    static let txtColor = UIColor(red: 106.0/255.0, green: 49.0/255.0, blue: 144.0/255.0, alpha: 1.0)
    // static let txtBgColor = UIColor(red: 23.0/255.0, green: 23.0/255.0, blue: 23.0/255.0, alpha: 0.9);
    
    //Error Color
    static let textPlaceHolderColor =  UIColor(red: 68.0/255.0, green: 153.0/255.0, blue: 220.0/255.0, alpha: 1.0)
    
    //rgb(184,223,248) 1
    //rgb(249,226,187) 2
    //rgb(176,234,221) 3
    static let backView1 = UIColor(red: 184.0/255.0, green: 223.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    static let backView2 = UIColor(red: 249.0/255.0, green: 226.0/255.0, blue: 187.0/255.0, alpha: 1.0)
    static let backView3 = UIColor(red: 176.0/255.0, green: 234.0/255.0, blue: 221.0/255.0, alpha: 1.0)
    
    static let smallView1 = UIColor(red: 184.0/255.0, green: 223.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    static let smallView2 = UIColor(red: 249.0/255.0, green: 226.0/255.0, blue: 187.0/255.0, alpha: 1.0)
    static let smallView3 = UIColor(red: 176.0/255.0, green: 234.0/255.0, blue: 221.0/255.0, alpha: 1.0)
    
    //Menu color
    //rgb(243,92,72)
    static let selectionColor = UIColor(red: 243.0/255.0, green: 92.0/255.0, blue: 72.0/255.0, alpha: 1.0)
    //rgb(194,67,50)
    static let UnSelectionColor = UIColor(red: 194.0/255.0, green: 67.0/255.0, blue: 50.0/255.0, alpha: 1.0)
    static let verylightGray = UIColor(red: 236.0/255.0, green: 243.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    //#6a318f; rgb(106,49,143)
    static let purpleColor = UIColor(red: 106.0/255.0, green: 49.0/255.0, blue: 143.0/255.0, alpha: 1.0)
    
    //rgb(162,205,58)
    static let greenColor = UIColor(red: 9.0/255.0, green: 143.0/255.0, blue: 8.0/255.0, alpha: 1.0)
    
    //rgb(255,152,0) FF9800
    static let orangeColor = UIColor(red: 255.0/255.0, green: 152.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    
    //rgb(230,230,230) e6e6e6
    static let grayColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    
    //rgb(255,0,0) #FF0000
    static let redColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    
    //New color codes
    //rgb(61,55,52) #3d3734;
    static let lightGray = UIColor(red: 61.0/255.0, green: 55.0/255.0, blue: 52.0/255.0, alpha: 1.0)
    
    //rgb(38,32,28) #26201c;
    static let DarkGray = UIColor(red: 38.0/255.0, green: 32.0/255.0, blue: 28.0/255.0, alpha: 1.0)
    //rgb(127,184,77) #7FB84D;
    static let navigtaion = UIColor(red: 127.0/255.0, green: 184.0/255.0, blue: 77.0/255.0, alpha: 1.0)
    
    
    static var genralTextColor = UIColor().HexToColor(hexString: "#000000")
    static var commonTitleColor = "#FFFFFF"
    static var commonSubTitleColor = "#FFFFFF"
    static var commonNotificationImgBackdrnd = UIColor().HexToColor(hexString: "#7FB84D")
    static var commonNotificationTitle = UIColor().HexToColor(hexString: "#000000")
    static var commonQuickMenuImg = UIColor().HexToColor(hexString: "#000000")
    static var commonProgressColor = UIColor().HexToColor(hexString: "#1980EE")
    static var commonProgressTitleColor = UIColor().HexToColor(hexString: "#1971EE")
    
    static var alertTitleTextColor = UIColor().HexToColor(hexString: "#000000")
    static var alertSubTitleTextColor = UIColor().HexToColor(hexString: "#000000")
    static var alertPositiveBtnTxtColor = UIColor().HexToColor(hexString: "#7FB84D")
    static var alertNegativeBtnTxtColor = UIColor().HexToColor(hexString: "#FF0000")
    static var alertWarningBtnTxtColor = UIColor().HexToColor(hexString: "#7FB84D")
    
}


// MARK: FontAndSize-------------------------------------------------
struct fontAndSize{
    static let menuItemFont = "System Bold"
    static let menuItemFontSize : CGFloat = 15.0
    static let NaviTitleFont1 = "System Regular"
    static let NaviTitleFontSize1 : CGFloat = 20.0
    static let NaviTitleFont = "Raleway-Medium"
    static let NaviTitleFontSize : CGFloat = 17.0
    static let errorFont = "System Medium"
    
    static var genralTextFontSize : CGFloat = 15
    static var commonTitleFontSize : CGFloat = 15
    static var commonSubTitleFontSize : CGFloat = 12
    static var commonNotificationTitleFontSize : CGFloat = 13
    static var commonProgressTitleFontSize : CGFloat = 14
    
    static var genralTextFontStyle = "1"
    static var commonTitleFontStyle = "1"
    static var commonSubTitleFontStyle = "1"
    static var commonNotificationTitleFontStyle = "1"
    static var commonProgressTitleFontStyle = "1"
    
    static var alertTitleFontSize : CGFloat = 15.0
    static var alertSubTitleFontSize : CGFloat = 12.0
    static var alertPositiveBtnFontSize : CGFloat = 14.0
    static var alertNegativeBtnFontSize : CGFloat = 14.0
    static var alertWarningBtnFontSize : CGFloat = 14.0
    
    static var alertTitleFontStyle = "2"
    static var alertSubTitleFontStyle = "1"
    static var alertPositiveBtnFontStyle = "2"
    static var alertNegativeBtnFontStyle = "2"
    static var alertWarningBtnFontStyle = "2"
    
}

// MARK:  Device  Detection------------------------------------------------
enum UIUserInterfaceIdiom : Int{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P_7P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_x        = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}



// MARK:  Device OS Version  Detection

struct Version
{
    
    static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS7 = (Version.SYS_VERSION_FLOAT < 8.0 && Version.SYS_VERSION_FLOAT >= 7.0)
    static let iOS8 = (Version.SYS_VERSION_FLOAT >= 8.0 && Version.SYS_VERSION_FLOAT < 9.0)
    static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
}



