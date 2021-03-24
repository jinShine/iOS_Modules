//
//  kakaoManager.swift
//  KakaoModule
//
//  Created by buzz on 2021/03/24.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import RxCocoa
import RxKakaoSDKAuth
import RxKakaoSDKCommon
import RxKakaoSDKUser
import RxSwift

class KakaoManager {

  init() {}

  /// 카카오톡으로부터 리다이렉트 된 URL 인지 체크 후 요청 결과를 처리
  static func kakaoTalkLoginOpenURL(openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url {
      if AuthApi.isKakaoTalkLoginUrl(url) {
        _ = AuthController.rx.handleOpenUrl(url: url)
      }
    }
  }

  /// 카카오톡 간편로그인이 실행 가능한지 확인합니다.
  func isKakaoTalkLoginAvailable() -> Bool {
    return UserApi.isKakaoTalkLoginAvailable()
  }

  /// 로그인
  func login() -> Observable<OAuthToken> {
    if isKakaoTalkLoginAvailable() {
      return UserApi.shared.rx.loginWithKakaoTalk()
    } else {
      return UserApi.shared.rx.loginWithKakaoAccount()
    }
  }

  /// 로그아웃
  func logout() -> Completable {
    return UserApi.shared.rx.logout()
  }

  /// 현재 토큰의 기본적인 정보를 조회, 가볍게 토큰의 유효성을 체크하는 용도로 사용하는 경우 추천
  func accessTokenInfo() -> Observable<AccessTokenInfo> {
    return UserApi.shared.rx.accessTokenInfo().asObservable()
  }

  /// 사용자에 대한 정보
  func user() -> Observable<User> {
    return UserApi.shared.rx.me().asObservable()
  }

  func errorMessage() -> String? {
    let error = SdkError()

    if error.isApiFailed {
      return error.getApiError().info?.msg
    } else if error.isAuthFailed {
      return error.getAuthError().info?.errorDescription
    } else if error.isClientFailed {
      return error.getClientError().message
    } else {
      return error.localizedDescription
    }
  }
}
