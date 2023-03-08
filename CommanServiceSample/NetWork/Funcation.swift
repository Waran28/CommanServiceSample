//
//  Funcation.swift
//  sampleCommanService
//
//  Created by MacBook on 2023-03-08.
//

import Foundation
import UIKit
import SwiftUI

class Functions {
    public static func printdetails(msg: String) {
        
        let str = String(repeating: "=", count: (msg.count + 3))
        print(str)
        print("||\(String(repeating: " ", count: (msg.count - 2))) ||")
        print("\(msg) ||")
        print("||\(String(repeating: " ", count: (msg.count - 2))) ||")
        print(str)
        print("")
        print("")
    }
    func removeXMLTagsString(strData:String)->String{
        let startIndex = strData.range(of: "<string xmlns=\"http://tempuri1.org/\">")
        let endIndex=strData.range(of: "</string>")
        let sub=strData[startIndex!.upperBound..<endIndex!.lowerBound]
        
        return String(sub)
    }
    func removeXMLTagsInt(strData:String)->String{
        let startIndex=strData.range(of: "<int xmlns=\"http://tempuri1.org/\">")
        let endIndex=strData.range(of: "</int>")
        let sub=strData[startIndex!.upperBound..<endIndex!.lowerBound]
        
        return String(sub)
    }
    func alert(title: String,message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.setValue(NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont(name:"TransatBold",size: 15) as Any,NSAttributedString.Key.foregroundColor : UIColor(named: "colorPurple") ?? Color.purple]), forKey: "attributedTitle")
        alert.setValue(NSAttributedString(string: message, attributes: [NSAttributedString.Key.font : UIFont(name:"TransatBold",size: 14) as Any,NSAttributedString.Key.foregroundColor : UIColor(named: "colorYellow") ?? Color.purple]), forKey: "attributedMessage")
        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.backgroundColor = UIColor(named: "bgColor")
        alert.view.tintColor = UIColor(named: "colorPurple")
        let noAction = UIAlertAction(title: "Ok", style: .default, handler: {
                (alertAc: UIAlertAction!) -> Void in
            
                alert.dismiss(animated: true, completion: nil)
            })
       
        alert.addAction(noAction)
        showAlert(alert: alert)
    }

    func showAlert(alert: UIAlertController) {
        if let controller = topMostViewController() {
            controller.present(alert, animated: true)
        }
    }

    func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
        .filter {$0.activationState == .foregroundActive}
        .compactMap {$0 as? UIWindowScene}
        .first?.windows.filter {$0.isKeyWindow}.first
    }

    func topMostViewController() -> UIViewController? {
        guard let rootController = keyWindow()?.rootViewController else {
            return nil
        }
        return topMostViewController(for: rootController)
    }

    func topMostViewController(for controller: UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            return topMostViewController(for: presentedController)
        } else if let navigationController = controller as? UINavigationController {
            guard let topController = navigationController.topViewController else {
                return navigationController
            }
            return topMostViewController(for: topController)
        } else if let tabController = controller as? UITabBarController {
            guard let topController = tabController.selectedViewController else {
                return tabController
            }
            return topMostViewController(for: topController)
        }
        return controller
    }
}
