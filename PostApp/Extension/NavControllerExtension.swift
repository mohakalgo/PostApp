//
//  NavControllerExtension.swift
//  Ethnic Roop
//
//  Created by Devarshi on 06/12/18.
//  Copyright © 2018 SIPL. All rights reserved.
//

import Foundation
import UIKit
//MARK: - NavigationController
extension UINavigationController {
    
    func backToViewController(vc: Any) {
        // iterate to find the type of vc
        for element in viewControllers as Array {
            if element.isKind(of: vc as! AnyClass) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
    
    func isViewcontrollerAvailable(vc: Any) -> Bool? {
        for element in viewControllers as Array {
            if element.isKind(of: vc as! AnyClass) {
                return true
            }
        }
        return false
    }
    
    func getViewController(vc: Any) -> UIViewController? {
        for element in viewControllers as Array {
            if element.isKind(of: vc as! AnyClass) {
                return element
            }
        }
        return nil
    }
    
    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }
    
    func popViewControllers(viewsToPop: Int, animated: Bool = true) {
      if viewControllers.count > viewsToPop {
        let vc = viewControllers[viewControllers.count - viewsToPop - 1]
        popToViewController(vc, animated: animated)
      }
    }
    
}


