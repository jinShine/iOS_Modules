//
//  kakaoManager.swift
//  KakaoModule
//
//  Created by buzz on 2021/03/24.
//

import Common
import Foundation
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import RxCocoa
import RxKakaoSDKAuth
import RxKakaoSDKCommon
import RxKakaoSDKUser
import RxSwift

extension KakaoAppService {

  /// 카카오톡으로부터 리다이렉트 된 URL 인지 체크 후 요청 결과를 처리
  func kakaoTalkLoginOpenURL(openURLContexts URLContexts: Set<UIOpenURLContext>) {
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
  func login() -> Observable<LificToken> {
    if isKakaoTalkLoginAvailable() {
      return UserApi.shared.rx.loginWithKakaoTalk()
        .map { LificToken(accessToken: $0.accessToken, refreshToken: $0.refreshToken) }
        .catchError { [weak self] in
          self?.errorMessage.onNext(self?.transformError($0))
          return .empty()
        }
    } else {
      return UserApi.shared.rx.loginWithKakaoAccount()
        .map { LificToken(accessToken: $0.accessToken, refreshToken: $0.refreshToken) }
        .catchError { [weak self] in
          self?.errorMessage.onNext(self?.transformError($0))
          return .empty()
        }
    }
  }

  /// 로그아웃
  func logout() -> Observable<Void> {
    return UserApi.shared.rx.logout().asObservable()
      .mapToVoid()
  }

  /// 현재 토큰의 기본적인 정보를 조회, 가볍게 토큰의 유효성을 체크하는 용도로 사용하는 경우 추천
  func accessTokenInfo() -> Observable<AccessTokenInfo> {
    return UserApi.shared.rx.accessTokenInfo().asObservable()
      .catchError { [weak self] in
        self?.errorMessage.onNext(self?.transformError($0))
        return .empty()
      }
  }

  /// 사용자에 대한 정보
  func userInfo() -> Observable<User> {
    return UserApi.shared.rx.me().asObservable()
      .catchError { [weak self] in
        self?.errorMessage.onNext(self?.transformError($0))
        return .empty()
      }
  }

  /// Transform error
  func transformError(_ error: Error) -> String? {
    switch SdkError(error: error) {
    case let .ApiFailed(_, errorInfo):
      return errorInfo?.msg
    case let .AuthFailed(_, errorInfo):
      return errorInfo?.errorDescription
    case let .ClientFailed(_, errorMessage):
      return errorMessage
    case let .GeneralFailed(error):
      return error.localizedDescription
    }
  }
}
