//
//  GoogleAppService.swift
//  GoogleLoginModule
//
//  Created by buzz on 2021/08/25.
//  Copyright © 2021 Jinnify. All rights reserved.
//

import Common
import Firebase
import Foundation
import GoogleSignIn
import RxSwift

class GoogleAppService: NSObject, AppService, AppGlobalConfiguration {

  func configure() {
    guard let id = appConfiguration.googleClientId else {
      return
    }

    GIDSignIn.sharedInstance()?.clientID = id
  }
}
