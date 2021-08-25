//
//  KakaoAppService.swift
//  KakaoModule
//
//  Created by buzz on 2021/08/25.
//

import Common
import Foundation
import KakaoSDKCommon
import RxSwift

class KakaoAppService: NSObject, AppService, AppGlobalConfiguration {

  /// 에러 메세지
  var errorMessage = PublishSubject<String?>()

  func configure() {
    guard let key = appConfiguration.kakaoAppKey else {
      return
    }

    KakaoSDKCommon.initSDK(appKey: key)
  }
}
