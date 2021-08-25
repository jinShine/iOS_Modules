//
//  AppleAppService.swift
//  AppleLogin
//
//  Created by buzz on 2021/04/08.
//  Copyright © 2021 Jinnify. All rights reserved.
//

import AuthenticationServices
import Common
import Foundation
import RxSwift

class AppleAppService: NSObject, AppService {

  let appleIDProvider = ASAuthorizationAppleIDProvider()
  var authorizationController: ASAuthorizationController

  override init() {
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.email, .fullName]
    authorizationController = ASAuthorizationController(authorizationRequests: [request])

    super.init()
  }

  func configure() {}
}
