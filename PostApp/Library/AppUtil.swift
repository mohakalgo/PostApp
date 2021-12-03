//
//  AppUtil.swift
//  Politis
//
//  Created by Dixit Rathod on 06/12/19.
//  Copyright © 2019 Dixit Rathod. All rights reserved.
//

import Foundation
import CDAlertView
import SnapKit
import JGProgressHUD
import SwiftMessages

class AppUtil: NSObject {
    static var shared = AppUtil()
    var loader:JGProgressHUD!
    
   
    
    class func getDays(_ index : Int) -> String {
        switch index {
        case 0:
            return "Saturday"
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        default:
            return "Monday"
        }
    }
    
    class func showSuccessAlert(title:String, dis:String, con:UIViewController?) {
        let viewAlert : SuccessAlert? = SuccessAlert()
        viewAlert!.setData(title:title, Dis: dis)
        viewAlert!.frame = UIScreen.main.bounds
        let myKeyWindow: UIWindow? = UIApplication.shared.keyWindowInConnectedScenes
        viewAlert?.btnViewHideClick = {
            viewAlert?.removeFromSuperview()
            con?.navigationController?.popViewController(animated: true)
        }
        myKeyWindow?.addSubview(viewAlert!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if viewAlert != nil {
                viewAlert?.removeFromSuperview()
                con?.navigationController?.popViewController(animated: true)
            }
        }
    }
  
    
    class func getDeviceId() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? "";
    }
    class func getToken() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? "";
    }
    
    
    func getViewControllerFrom(storyboardName: String, vcId: String) -> UIViewController{
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: vcId)
        return controller
    }
    
    func getFromDefault<T:Codable>(key:String,type:T.Type) -> T?
    {
        let archieved = UserDefaults.standard.value(forKey: key)
        let dict = NSKeyedUnarchiver.unarchiveObject(with: archieved as? Data ?? Data())
        let decoder = JSONDecoder()
        do{
            if let dic = dict
            {
                let data = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
                return try decoder.decode(type, from: data)
            }
            
        }
        catch
        {
            print(error)
        }
        return nil
    }
    
    func setInDefault<T:Codable>(key:String, type:T.Type, data:T)
    {
        do {
            let encoder = JSONEncoder()
            let encodeData = try encoder.encode(data)
            let dict:[String:Any] = try JSONSerialization.jsonObject(with: encodeData, options: .allowFragments) as! [String : Any]
            
            //archive object to handle null values
            let data = NSKeyedArchiver.archivedData(withRootObject: dict)
            //set user data in defaults
            UserDefaults.standard.set(data, forKey: key)
            UserDefaults.standard.synchronize()
        }
        catch
        {
            print(error)
        }
    }
    
    func setInDefault(key:String, data:Any)
    {
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    func getFromDefault(key:String) -> Any
    {
        let value = UserDefaults.standard.value(forKey: key)
        return value ?? ""
    }
    
    
    func showAlertPopup(text: String, type: CDAlertViewType){
        let alert = CDAlertView(title: "", message: text, type: type)
        alert.messageFont = UIFont(name: "Helvetica", size: 14)!
        
        let doneAction = CDAlertViewAction(title: "Ok")
        doneAction.buttonFont = UIFont(name: "Helvetica", size: 16)
        
        alert.add(action: doneAction)
        alert.show()
    }
    
    func showAlertPopupWithCompletion(text: String, type: CDAlertViewType ,_ completion: @escaping ((Bool) -> Void)){
        let alert = CDAlertView(title: "", message: text, type: type)
        alert.messageFont = UIFont(name: "Helvetica", size: 14)!
        
        let yesaction = CDAlertViewAction(title: "Yes") { (_) -> Bool in
            completion(true)
            return true
        }
        let noaction = CDAlertViewAction(title: "No") { (_) -> Bool in
            completion(false)
            return true
        }
        
        alert.add(action: yesaction)
        alert.add(action: noaction)
        alert.show()
    }
    
    //MARK: - Notification View
       func showNotification(msg: String = "This field is required", type: TopNotiType = .error) {
           
           let view = MessageView.viewFromNib(layout: .messageView)
           view.button?.isHidden = true
           view.bodyLabel?.font = UIFont(name: "OpenSans-Bold", size: 15)
           // Theme message elements with the warning style.
           if type == .error {
               view.configureTheme(.error)
               view.configureContent(title: "", body: msg, iconImage: UIImage(named: "ic_warning")!)
           } else {
               view.configureTheme(.success)
               view.configureContent(title: "", body: msg)
           }
           
           
           // Increase the external margin around the card. In general, the effect of this setting
           // depends on how the given layout is constrained to the layout margins.
           view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
           
           // Reduce the corner radius (applicable to layouts featuring rounded corners).
           (view.backgroundView as? CornerRoundingView)?.layer.cornerRadius = 10
           // Show the message.
           SwiftMessages.show(view: view)
       }
    
    //MARK: - Preloader
    func showPreloader(msg: String = "Loading", withProgress: Int = -1){
        if AppUtil.shared.loader?.isHidden == false { return }
        AppUtil.shared.loader = JGProgressHUD(style: .light)
        AppUtil.shared.loader.textLabel.text = msg
        if withProgress != -1 {
            AppUtil.shared.loader.indicatorView = JGProgressHUDPieIndicatorView()
            AppUtil.shared.loader.detailTextLabel.text = "\(withProgress)% Complete"
        }
        
    }
    
    func saveToken(token:String) {
        UserDefaults.standard.set(token, forKey: "tokenKey")
        UserDefaults.standard.synchronize()
    }
    
    func getUserToken() -> String {
        let value = UserDefaults.standard.value(forKey: "tokenKey")
        if value == nil {
            return ""
        } else { return value as! String }
    }
    
    func deleteToken() {
        UserDefaults.standard.removeObject(forKey: "tokenKey")
    }
    
    func showError() {
        AppUtil().showNotification(msg: "Somthing went wrong", type: .error)    }
    
    func uploadProgress(_ progress: Double) {
        if AppUtil.shared.loader == nil { return }
        AppUtil.shared.loader.progress = Float(progress)
        AppUtil.shared.loader.detailTextLabel.text = "\(Int(progress*100))% Complete"
    }
    
    func hidePreloader(){
        
        if AppUtil.shared.loader == nil { return }
        AppUtil.shared.loader.dismiss(afterDelay: 0.1)
    }
    func showEmptyDataView(view: UIView, _ message: String) {
        //        Utility().removeEmptyDataView(view: view)
        let nib = Bundle.main.loadNibNamed("\(NoDataViewController.self)", owner: self, options: nil)?[0] as! NoDataViewController
        nib.messageLbl.text = message.localized
        //        let nib = Bundle.main.loadNibNamed("NoDataViewController", owner: self, options: nil) as! NoDataViewController
        //        let nib = Bundle.main.loadNibNamed("", owner: <#T##Any?#>, options: <#T##[UINib.OptionsKey : Any]?#>)
        //        nib.emptyIcon.image = icon
        //        nib.emptyText.text = text
        view.addSubview(nib)
        nib.snp.makeConstraints { (make) in
            //            if alignment == .center {
            make.centerY.equalTo(view)
            make.centerX.equalTo(view)
            //            } else {
            //                make.centerX.equalTo(view)
            //                make.top.equalTo(view)
            //            }
        }
    }
    func removeEmptyDataView(view: UIView){
        for v in view.subviews {
            if v is NoDataViewController {
                v.removeFromSuperview()
            }
            else {
                removeEmptyDataView(view: v)
            }
        }
    }
    /*func showEmptyDataView(view: UIView, _ message: String) {
        //        Utility().removeEmptyDataView(view: view)
        let nib = Bundle.main.loadNibNamed("\(NoDataViewController.self)", owner: self, options: nil)?[0] as! NoDataViewController
        nib.messageLbl.text = message
        //        let nib = Bundle.main.loadNibNamed("NoDataViewController", owner: self, options: nil) as! NoDataViewController
        //        let nib = Bundle.main.loadNibNamed("", owner: <#T##Any?#>, options: <#T##[UINib.OptionsKey : Any]?#>)
        //        nib.emptyIcon.image = icon
        //        nib.emptyText.text = text
        view.addSubview(nib)
        nib.snp.makeConstraints { (make) in
            //            if alignment == .center {
            make.centerY.equalTo(view)
            make.centerX.equalTo(view)
            //            } else {
            //                make.centerX.equalTo(view)
            //                make.top.equalTo(view)
            //            }
        }
    }*/
    //Mark: - Empty Table Display Message
    /*func showEmptyDataView(view: UIView, icon: UIImage = UIImage(), text: String = "No data found!", alignment:EmptyViewAlign = .center) {
        AppUtil().removeEmptyDataView(view: view)
        let nib = Bundle.main.loadNibNamed("\(EmptySearchCell.self)", owner: self, options: nil)?[0] as! EmptySearchCell
        nib.emptyIcon.image = icon
        nib.emptyText.text = text
        view.addSubview(nib)
        nib.snp.makeConstraints { (make) in
            if alignment == .center {
                make.centerY.equalTo(view)
                make.centerX.equalTo(view)
            } else {
                make.centerX.equalTo(view)
                make.top.equalTo(view)
            }
        }
    }
    
    
    
    func removeEmptyDataView(view: UIView){
        for v in view.subviews {
            if v is EmptySearchCell {
                v.removeFromSuperview()
            }
            else {
                removeEmptyDataView(view: v)
            }
        }
    }*/
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    // (milisecond, second, min)
    func secondsToMinSecMiliSec (seconds : TimeInterval) -> (Int, Int, Int) {
        let sec = Int(seconds)
        let miliSeconds = seconds.truncatingRemainder(dividingBy: 1)
        return (Int(miliSeconds*100), Int((sec % 3600)) % 60, Int((sec % 3600)) / 60)
    }

    func clearDocumentFolder() {
        let fileManager = FileManager.default
       /* let tempFolderPath = NSTemporaryDirectory()
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: tempFolderPath + filePath)
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }*/
        
//        let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//        do {
//            try fileManager.removeItem(at: myDocuments)
//        } catch {
//            print("Could not clear temp folder22: \(error)")
//        }
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch  { print(error) }

    }

}


enum EmptyViewAlign: Int {
    case center = 1
    case top = 2
}

