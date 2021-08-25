//
//  NaverAppService.swift
//  NaverModule
//
//  Created by buzz on 2021/08/25.
//

import Common
import Foundation
import NaverThirdPartyLogin
import RxCocoa
import RxSwift

class NaverAppService: NSObject, AppService, AppGlobalConfiguration {

  let naver: NaverThirdPartyLoginConnection

  override init() {
    naver = NaverThirdPartyLoginConnection.getSharedInstance()
    super.init()
  }

  func configure() {
    guard let id = appConfiguration.naverClientId,
          let secret = appConfiguration.naverClientSecret
    else {
      return
    }

    // 네이버 앱으로 인증하는 방식 활성화
    naver.isNaverAppOauthEnable = true
    // SafariViewController에서 인증하는 방식 활성화
    naver.isInAppOauthEnable = true
    // 인증 화면을 iPhone의 세로 모드에서만 사용
    naver.isOnlyPortraitSupportedInIphone()

    naver.serviceUrlScheme = Application.urlScheme
    naver.consumerKey = id
    naver.consumerSecret = secret
    // TODO: 앱 이름 변경
    naver.appName = "라이픽 소비자 앱"
  }
}
