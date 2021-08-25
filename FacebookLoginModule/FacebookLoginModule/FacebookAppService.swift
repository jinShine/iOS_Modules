//
//  FacebookAppService.swift
//  FacebookLoginModule
//
//  Created by buzz on 2021/04/09.
//

import Common
import FBSDKCoreKit
import FBSDKLoginKit
import RxSwift

class FacebookAppService: NSObject, AppService {

  /// Facebook 로그인 매니저
  let loginManager = LoginManager()

  /// 에러
  var error = PublishSubject<Error>()

  func configure() { }
}
