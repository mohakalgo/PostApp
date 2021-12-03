//
//  CommonClass.swift
//  Diamond Connect
//
//  Created by Maulik Goyani on 14/02/2020.
//  Copyright © 2020 Artoon Solutions. All rights reserved.
//

import Foundation
import UIKit
import ISMessages
import SwiftMessages
//import JGProgressHUD
//import SnapKit


class CommonClass: NSObject {
    
    static var shared = CommonClass()
//    var loader:JGProgressHUD!
    
    func getViewControllerFrom(vcId: String, StoryName: String) -> UIViewController{
        let storyboard = UIStoryboard(name: StoryName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: vcId)
        controller.hidesBottomBarWhenPushed = true
        return controller
    }
    
    func getTopViewController() -> UIViewController?{
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    func getCurrentViewController(_ vc: UIViewController) -> UIViewController? {
        if let pvc = vc.presentedViewController {
            return getCurrentViewController(pvc)
        }
        else if let svc = vc as? UISplitViewController, svc.viewControllers.count > 0 {
            return getCurrentViewController(svc.viewControllers.last!)
        }
        else if let nc = vc as? UINavigationController, nc.viewControllers.count > 0 {
            return getCurrentViewController(nc.topViewController!)
        }
        else if let tbc = vc as? UITabBarController {
            if let svc = tbc.selectedViewController {
                return getCurrentViewController(svc)
            }
        }
        return vc
    }
    
    func showResponseError(errorCode: String) {
        if errorCode == "ARE" {
            CommonClass.showNotification(msg: "You already registor with this email.")
        }
        else if errorCode == "PIW" {
            CommonClass.showNotification(msg: "Parameter is wrong.")
        }
        else if errorCode == "ARU" {
            CommonClass.showNotification(msg: "USername already Exists.")
        }
        else if errorCode == "ETG" {
            CommonClass.showNotification(msg: "Edit time Gone.")
        }
        else if errorCode == "ODW" {
            CommonClass.showNotification(msg: "Date is not between Order Period.")
        }
        else if errorCode == "PIP" {
            CommonClass.showNotification(msg: "Your Package is in Pause mode.")
        }
        else if errorCode == "ONE" {
            CommonClass.showNotification(msg: "Order not Found.")
        }
        else if errorCode == "PIC" {
            CommonClass.showNotification(msg: "Package cancelled.")
        }
        else if errorCode == "SFND" {
            CommonClass.showNotification(msg: "successfully not done.")
        }
    }

    
//    func showISMessage(str_title:String, Message:String, msgtype:Int) {
//        ISMessages.showCardAlert(withTitle: str_title, message: Message, duration: 3.0, hideOnSwipe: true, hideOnTap: true, alertType:ISAlertType(rawValue: msgtype)!, alertPosition: ISAlertPosition.top) { (finished:Bool) in
//            
//        }
//    }
    
    class func showNotification(msg: String = "This field is required", type: TopNotiType = .error) {
        
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

    func contryCodeDropdown(sorceView: UIView, textField: UITextField) {
        // Alert Picker View
        let alertVC = UIAlertController(title: "Select your country code", message: "", preferredStyle: .actionSheet)
        if let popoverPresentationController = alertVC.popoverPresentationController {
            popoverPresentationController.sourceView = sorceView
        }
        
        let countryCodeArray1:CountryCodeModel = JsonManager().countryCodes

        let answerOptionArr:[String] = (countryCodeArray1.country?.map { "\($0.name!) \($0.dial_code ?? "")" })!
        var row = 0
        alertVC.addPickerView(values: answerOptionArr) { (vc, picker, index, values) in
            DispatchQueue.main.async {
                row = index.row
                textField.text = countryCodeArray1.country?[index.row].dial_code
            }
        }
        
        alertVC.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { (data) in
            sorceView.parentController?.view.endEditing(true)
            DispatchQueue.main.async {
                textField.text = countryCodeArray1.country?[row].dial_code
            }
        }))
        sorceView.parentController?.present(alertVC, animated: true, completion: nil)
    }
    
    func showDropdown(sorceView: UIView, title: String, textField: UITextField, valueArray:[String]) {
        sorceView.parentController?.view.endEditing(true)
        let alertVC = UIAlertController(title: title, message: "", preferredStyle: .actionSheet)
        if let popoverPresentationController = alertVC.popoverPresentationController {
            popoverPresentationController.sourceView = sorceView
        }
        
        var row = 0
        alertVC.addPickerView(values: valueArray) { (vc, picker, index, values) in
            DispatchQueue.main.async {
                row = index.row
                textField.text = valueArray[index.row]
                textField.accessibilityLabel = "\(index.row)"
            }
        }
        
        alertVC.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { (data) in
            DispatchQueue.main.async {
                textField.text = valueArray[row]
                textField.accessibilityLabel = "\(row)"
            }
        }))
        
        sorceView.parentController?.present(alertVC, animated: true, completion: nil)
    }
}
enum TopNotiType: String{
    case error = "error"
    case success = "success"
}
