//
//  AppDelegate.swift
//  TestStoryboard
//
//  Created by Jinnify on 2020/07/09.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    print(AppInfo.version)
    
    return true
  }

}

struct AppInfo {

  static var version: String {
      let info = Bundle.main.infoDictionary
      let version = info?["CFBundleShortVersionString"] as? String ?? ""
      return "\(version)"
  }
}
