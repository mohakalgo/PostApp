//
//  AppDelegate.swift
//  Diamond Connect
//
//  Created by Maulik Goyani on 14/02/2020.
//  Copyright © 2020 Artoon Solutions. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

// deveopment


// production
let BaseUrl = "http://192.168.1.33:3000/api/v1/"
let AssetBaseUrl = "http://192.168.1.33:3000"


class WebServiceHandler {
    
    
//    var alamoFireManager = AFd
    func requestWith<T>(method: HTTPMethod = .get, endPoint: String, loader: Bool = false, params: [String: Any] = [:], model: T.Type, success: @escaping (AnyObject) -> Void, failure: @escaping (AnyObject, String) -> Void) where T: Codable {
       
        var newParam :[String: Any] = params
        if loader {
            AppUtil().showPreloader()
        }
        
        var header:HTTPHeaders = HTTPHeaders()
        let token = AppUtil().getUserToken()
        if token != "" {
            header["Authorization"] = token
            print("userToken =====> \(token)")
        }
        header["Accept"] = "application/json"
//        header["Content-type"] = "application/x-www-form-urlencoded"
        

        var URL = BaseUrl + endPoint
        URL = URL.replacingOccurrences(of: " ", with: "%20")
        AF
        AF.request(URL, method: method, parameters: method == .get ? nil : method == .put ? nil : newParam, encoding: JSONEncoding.prettyPrinted, headers: header).responseJSON {
            response in
            print("===> URL: \(BaseUrl + endPoint)")
            print("===> Sending Dict : \(newParam)")
            if loader {
                AppUtil().hidePreloader()
            }
            switch response.result {
            case .success(let data):
                do {
                    let stringData = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)! as String
                    let dictData = self.convertToDictionary(text: stringData)
                    print("Responce ==> \(dictData)")
                    
                    if let error = dictData!["error"] as? String {
                        if error != "SFD" {
                            failure(dictData as AnyObject, error)
                            return
                        }
//                        else if endPoint == EndPoints.Login || endPoint == EndPoints.Register {
//                            UserDefaults.standard.setValue(response.data!, forKey: "userdata")
//                            UserDefaults.standard.synchronize()
//                        }
                    }
                    if let messageCode = dictData?["messageCode"] as? String
                    {
                        if messageCode == "UNAUTHORIZED" || messageCode == "JWT_EXPIRED" {
                            UserDefaults.standard.set(false, forKey: "isLogin")
                            UserDefaults.standard.setValue("", forKey: "token")
                            UserDefaults.standard.setValue("", forKey: "userID")
                            UserDefaults.standard.synchronize()
                            
                          
                            return
                        }
                    }
                    let decoder = JSONDecoder()
                    let responseData = try decoder.decode(model, from: response.data!)
                    print(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)! as String)
                    success(responseData as AnyObject)
                } catch {
                    let stringData = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)! as String
                    let dictData = self.convertToDictionary(text: stringData)
                    if let messageCode = dictData?["messageCode"] as? String
                    {
                        if messageCode == "UNAUTHORIZED" || messageCode == "JWT_EXPIRED" {
                            UserDefaults.standard.set(false, forKey: "isLogin")
                            UserDefaults.standard.setValue("", forKey: "token")
                            UserDefaults.standard.setValue("", forKey: "userID")
                            UserDefaults.standard.synchronize()
                            
                            
//                            SideMenuNavigation.shared.pushViewController(vc, animated: true)

                        }
                    }
                    print("Error = \(error)")
//                    if failure != nil {
                    failure(error.localizedDescription as AnyObject, "")
//                    }
                }
                
            case .failure(_):
                print("Response failed.............")
                //return (failure ?? "API Developer issue" as? (AnyObject) -> Void)
            }
            
            switch response.result {
            case .success:
                print(response)
                
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
    
    //MARK: - Image upload service releated code
    func requstWithFormdata<T>(Method method: HTTPMethod, Action action: String, ImageParameters imgparams: [String : Any]?, type:T.Type, showProgress: Bool = false, success: @escaping (AnyObject) -> Void, failure: @escaping (AnyObject) -> Void) where T:Codable {
        
        var base_url = BaseUrl
        base_url.append(action)
                
        base_url = base_url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? base_url

        var header:HTTPHeaders = HTTPHeaders()
        let token = AppUtil().getUserToken()
        if token != "" {
            header["Authorization"] = token
            print("userToken =====> \(token)")
        }
        
        header["Accept"] = "application/json"
        
        if showProgress {
            AppUtil().showPreloader(msg: "0% uploaded...")
        }
        
        print("===> URL: \(BaseUrl + action)")
        print("===> Sending Dict : \(imgparams)")
        
        
        AF.upload(multipartFormData: { multiPart in
            for (key, value) in imgparams ?? [:] {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                }
                else if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                else if value is Data {
                    if key == "audio_file" {
                        multiPart.append(value as! Data, withName: key , fileName: "\(NSDate().timeIntervalSince1970 * 1000).mp3", mimeType: "image/mp3")
                    } else {
                        multiPart.append(value as! Data, withName: key , fileName: "\(NSDate().timeIntervalSince1970 * 1000).png", mimeType: "image/png")
                    }
                    
                } else if key == "images" {
                    if let da = value as? Data {
                        multiPart.append(da, withName: key , fileName: "\(NSDate().timeIntervalSince1970 * 1000).png", mimeType: "image/png")
                    }
                } else {
                    multiPart.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, to: base_url, method: .post, headers: header) .uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }).responseJSON(completionHandler: { responseData in
            print("upload finished: \(responseData)")
            if showProgress {
                AppUtil().hidePreloader()
            }
            
                if let value = responseData.data {

                    do {
                        print(try JSONSerialization.jsonObject(with: value, options: .allowFragments))
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(type, from: value)
                        success(response as AnyObject)
                    } catch {
                        print(error)
                        failure(error.localizedDescription as AnyObject)
                    }
                } else {
                    return failure(responseData.error as AnyObject)
                }

//            }
            
        }).response { (response) in
            switch response.result {
            case .success(let resut):
                print("upload success result: \(resut)")
            case .failure(let err):
                print("upload err: \(err)")
                if showProgress {
                    AppUtil().hidePreloader()
                }
                return failure(err.localizedDescription as AnyObject)
            }
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
