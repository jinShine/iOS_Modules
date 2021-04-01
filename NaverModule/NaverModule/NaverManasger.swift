//
//  NaverManager.swift
//  Consumer
//
//  Created by buzz on 2021/03/24.
//

import Alamofire
import Common
import Foundation
import NaverThirdPartyLogin
import RxCocoa
import RxSwift

class NaverManager: NSObject {

  let naver: NaverThirdPartyLoginConnection

  override init() {
    naver = NaverThirdPartyLoginConnection.getSharedInstance()
    super.init()
  }

  static func naverLoginOpenURL(openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url {
      NaverThirdPartyLoginConnection.getSharedInstance()?.receiveAccessToken(url)
    }
  }

  func login() {
    naver.requestThirdPartyLogin()
  }

  func logout() {
    naver.requestDeleteToken()
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

class RxNaverManagerProxy: DelegateProxy<NaverManager, NaverThirdPartyLoginConnectionDelegate>, DelegateProxyType, NaverThirdPartyLoginConnectionDelegate {

  // MARK: - DelegateProxyType

  static func registerKnownImplementations() {
    register { naverManager -> RxNaverManagerProxy in
      RxNaverManagerProxy(parentObject: naverManager, delegateProxy: self)
    }
  }

  static func currentDelegate(for object: NaverManager) -> NaverThirdPartyLoginConnectionDelegate? {
    return object.naver.delegate
  }

  static func setCurrentDelegate(_ delegate: NaverThirdPartyLoginConnectionDelegate?, to object: NaverManager) {
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

extension Reactive where Base: NaverManager {

  var delegate: DelegateProxy<NaverManager, NaverThirdPartyLoginConnectionDelegate> {
    return RxNaverManagerProxy.proxy(for: base)
  }

  var userEmail: Observable<String> {
    return RxNaverManagerProxy.proxy(for: base)
      .userEmailSubject
      .asObserver()
  }

  var errorMessage: Observable<String> {
    return RxNaverManagerProxy.proxy(for: base)
      .errorMessageSubject
      .asObserver()
  }
}

