//
//  NaverManager.swift
//  Consumer
//
//  Created by buzz on 2021/03/24.
//

import Common
import Foundation
import NaverThirdPartyLogin

class NaverAppService: NSObject, AppService {

  let naver: NaverThirdPartyLoginConnection

  override init() {
    naver = NaverThirdPartyLoginConnection.getSharedInstance()
    super.init()
  }

  func configure() {
    guard let id = Application.shared.config.naverClientId,
          let secret = Application.shared.config.naverClientSecret else {
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

extension NaverAppService {

  /// 네이버으로부터 리다이렉트 된 URL 인지 체크 후 요청 결과를 처리
  func naverLoginOpenURL(openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url {
      NaverThirdPartyLoginConnection.getSharedInstance()?.receiveAccessToken(url)
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

  /// 사용자 이메일
  func userEmail() -> Observable<String> {
//    return rx.userEmail
    return rx.test
  }

  /// 에러 메세지
  func errorMessage() -> Observable<String> {
    return rx.errorMessage
  }

  func requestUserEmail() -> Observable<String> {
    return Observable<String>.create { observer -> Disposable in
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
              observer.onNext(email)
              observer.onCompleted()
            }
          }
        }

      return Disposables.create()
    }
  }
}

// MARK: - RxNaverManagerProxy

class RxNaverAppServiceProxy: DelegateProxy<NaverAppService, NaverThirdPartyLoginConnectionDelegate>, DelegateProxyType, NaverThirdPartyLoginConnectionDelegate {

  // MARK: - DelegateProxyType

  static func registerKnownImplementations() {
    register { naverAppService -> RxNaverAppServiceProxy in
      RxNaverAppServiceProxy(parentObject: naverAppService, delegateProxy: self)
    }
  }

  static func currentDelegate(for object: NaverAppService) -> NaverThirdPartyLoginConnectionDelegate? {
    return object.naver.delegate
  }

  static func setCurrentDelegate(_ delegate: NaverThirdPartyLoginConnectionDelegate?, to object: NaverAppService) {
    return object.naver.delegate = delegate
  }

  // MARK: - Proxy Subject

  let naver = NaverThirdPartyLoginConnection.getSharedInstance()
  let userEmailSubject = PublishSubject<String>()
  let errorMessageSubject = PublishSubject<String>()

  // MARK: - Naver Login Delegate

  func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    requestUserEmail()
      .bind(to: userEmailSubject)
      .disposed(by: rx.disposeBag)
  }

  func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    requestUserEmail()
      .bind(to: userEmailSubject)
      .disposed(by: rx.disposeBag)
  }

  func oauth20ConnectionDidFinishDeleteToken() {
    naver?.requestDeleteToken()
  }

  func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection, didFailWithError error: Error) {
    errorMessageSubject.onNext(error.localizedDescription)
  }

  // MARK: - Helper method

  func requestUserEmail() -> Observable<String> {
    return Observable<String>.create { observer -> Disposable in
      guard let naver = self.naver, naver.isValidAccessTokenExpireTimeNow() else {
        observer.onCompleted()
        return Disposables.create()
      }

      let tokenType = naver.tokenType ?? "Bearer"
      let accessToken = naver.accessToken ?? ""
      let authorization = "\(tokenType) \(accessToken)"
      let url = URL(string: "https://openapi.naver.com/v1/nid/me")!

      AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        .responseJSON { response in
          log.debug(response)
          if let result = response.value as? [String: Any] {
            if let responseDict = result["response"] as? [String: Any] {
              let email = responseDict["email"] as? String ?? ""
              observer.onNext(email)
            }
          }
        }

      return Disposables.create()
    }
  }
}

// MARK: - NaverManager + Rx

extension Reactive where Base: NaverAppService {

  var delegate: DelegateProxy<NaverAppService, NaverThirdPartyLoginConnectionDelegate> {
    return RxNaverAppServiceProxy.proxy(for: base)
  }

  var userEmail: Observable<String> {
    return RxNaverAppServiceProxy.proxy(for: base)
      .userEmailSubject
      .asObserver()
  }

  var test: Observable<String> {
    return RxNaverAppServiceProxy.proxy(for: base)
      .methodInvoked(#selector(NaverThirdPartyLoginConnectionDelegate.oauth20ConnectionDidFinishRequestACTokenWithAuthCode))
      .flatMapLatest { _ in base.requestUserEmail() }
  }

  var errorMessage: Observable<String> {
    return RxNaverAppServiceProxy.proxy(for: base)
      .errorMessageSubject
      .asObserver()
  }
}


// Delegate 프록시 아닌 버전


extension NaverAppService: NaverThirdPartyLoginConnectionDelegate {

  /// 네이버으로부터 리다이렉트 된 URL 인지 체크 후 요청 결과를 처리
  func naverLoginOpenURL(openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url {
      NaverThirdPartyLoginConnection.getSharedInstance()?.receiveAccessToken(url)
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

      return Disposables.create()
    }
  }

  // MARK: - Naver Login Delegate

  func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    requestUserEmail()
      .bind(to: userInfo)
      .disposed(by: rx.disposeBag)
  }

  func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    requestUserEmail()
      .bind(to: userInfo)
      .disposed(by: rx.disposeBag)
  }

  func oauth20ConnectionDidFinishDeleteToken() {
    naver.requestDeleteToken()
  }

  func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection, didFailWithError error: Error) {
    errorMessage.onNext(error)
  }
}
