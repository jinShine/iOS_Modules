//
//  NaverAppService+Login.swift
//  NaverModule
//
//  Created by buzz on 2021/08/25.
//

import Alamofire
import Common
import Foundation
import NaverThirdPartyLogin
import RxCocoa
import RxSwift

extension NaverAppService {

  /// 네이버으로부터 리다이렉트 된 URL 인지 체크 후 요청 결과를 처리
  func naverLoginOpenURL(openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url {
      naver.receiveAccessToken(url)
    }
  }

  /// 로그인
  func login() -> Observable<Void> {
    return Observable.create { [weak self] observer -> Disposable in
      self?.naver.requestThirdPartyLogin()
      observer.onCompleted()
      return Disposables.create()
    }
  }

  /// 로그아웃
  func logout() -> Observable<Void> {
    return Observable.create { [weak self] observer -> Disposable in
      self?.naver.requestDeleteToken()
      observer.onCompleted()
      return Disposables.create()
    }
  }

  /// 유저 정보
  func userInfo() -> Observable<(token: LificToken, email: String)> {
    return naver.rx.userInfo
  }

  /// 에러
  func error() -> Observable<Error> {
    return naver.rx.error
  }

  /// 이메일 요청
  func requestUserEmail() -> Observable<(token: LificToken, email: String)> {
    return Observable<(token: LificToken, email: String)>.create { observer -> Disposable in
      guard self.naver.isValidAccessTokenExpireTimeNow() else {
        observer.onCompleted()
        return Disposables.create()
      }

      let tokenType = self.naver.tokenType ?? "Bearer"
      let accessToken = self.naver.accessToken ?? ""
      let authorization = "\(tokenType) \(accessToken)"
      let url = URL(string: "https://openapi.naver.com/v1/nid/me")!

      AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        .responseJSON { response in
          log.debug(response)
          if let result = response.value as? [String: Any] {
            if let responseDict = result["response"] as? [String: Any] {
              let email = responseDict["email"] as? String ?? ""
              let token = LificToken(accessToken: accessToken)
              observer.onNext((token, email))
              observer.onCompleted()
            }
          }
        }

      return Disposables.create {
        self.naver.resetToken()
      }
    }
  }
}

// MARK: - Delegate proxy

class RxNaverLoginDelegateProxy: DelegateProxy<NaverThirdPartyLoginConnection, NaverThirdPartyLoginConnectionDelegate>, NaverThirdPartyLoginConnectionDelegate, DelegateProxyType {

  let naverService = Application.shared.appSynchronizer.service(type: .naver) as? NaverAppService

  /// 유저 정보
  let userInfo = PublishSubject<(token: LificToken, email: String)>()

  /// 에러
  let error = PublishSubject<Error>()

  // MARK: DelegateProxy type

  static func registerKnownImplementations() {
    register {
      RxNaverLoginDelegateProxy(parentObject: $0, delegateProxy: self)
    }
  }

  static func currentDelegate(for object: NaverThirdPartyLoginConnection) -> NaverThirdPartyLoginConnectionDelegate? {
    return NaverThirdPartyLoginConnection.getSharedInstance().delegate
  }

  static func setCurrentDelegate(_ delegate: NaverThirdPartyLoginConnectionDelegate?, to object: NaverThirdPartyLoginConnection) {
    object.delegate = delegate
  }

  // MARK: Naver login delegate

  func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    naverService?.requestUserEmail()
      .subscribe(onNext: { [weak self] in
        self?.userInfo.onNext($0)
      }).disposed(by: rx.disposeBag)
  }

  func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    naverService?.requestUserEmail()
      .subscribe(onNext: { [weak self] in
        self?.userInfo.onNext($0)
      }).disposed(by: rx.disposeBag)
  }

  func oauth20ConnectionDidFinishDeleteToken() {
    naverService?.naver.requestDeleteToken()
  }

  func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection, didFailWithError error: Error) {
    self.error.onNext(error)
  }

  deinit {
    userInfo.onCompleted()
    error.onCompleted()
  }
}

// MARK: - NaverThirdPartyLoginConnection + Rx

extension Reactive where Base: NaverThirdPartyLoginConnection {

  var delegate: DelegateProxy<NaverThirdPartyLoginConnection, NaverThirdPartyLoginConnectionDelegate> {
    return RxNaverLoginDelegateProxy.proxy(for: base)
  }

  var userInfo: Observable<(token: LificToken, email: String)> {
    return RxNaverLoginDelegateProxy.proxy(for: base)
      .userInfo
  }

  var error: Observable<Error> {
    return RxNaverLoginDelegateProxy.proxy(for: base)
      .error
  }
}
