//
//  AppleAppService+Login.swift
//  AppleLogin
//
//  Created by buzz on 2021/04/08.
//  Copyright © 2021 Jinnify. All rights reserved.
//

import AuthenticationServices
import Common
import Foundation
import JWTDecode
import RxCocoa
import RxSwift

extension AppleAppService {

  /// 로그인
  func login() -> Observable<Void> {
    return Observable.create { [weak self] observer -> Disposable in
      guard let self = self else { return Disposables.create() }

      self.authorizationController.presentationContextProvider = self
      self.authorizationController.performRequests()

      observer.onCompleted()

      return Disposables.create()
    }
  }

  /// 로그아웃
  func logout() -> Observable<Void> {
    return Observable.create { [weak self] observer -> Disposable in
      self?.appleIDProvider.getCredentialState(forUserID: AuthManager.shared.accessToken ?? "") { state, error in
        switch state {
        case .authorized:
          return
        case .revoked, .notFound:
          observer.onCompleted()
        default:
          return
        }
      }

      return Disposables.create()
    }
  }

  /// 유저 정보
  func userInfo() -> Observable<(token: LificToken, email: String)> {
    return authorizationController.rx.userInfo
  }

  /// 에러
  func error() -> Observable<Error> {
    return authorizationController.rx.error
  }
}

extension AppleAppService: ASAuthorizationControllerPresentationContextProviding {

  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return Application.shared.window ?? UIWindow()
  }
}

// MARK: - Delegate proxy

class RxAppleAuthorizationDelegateProxy: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>, ASAuthorizationControllerDelegate, DelegateProxyType {

  /// 유저 정보
  let userInfo = PublishSubject<(token: LificToken, email: String)>()

  /// 에러
  let error = PublishSubject<Error>()

  // MARK: DelegateProxy type

  static func registerKnownImplementations() {
    register {
      RxAppleAuthorizationDelegateProxy(parentObject: $0, delegateProxy: self)
    }
  }

  static func currentDelegate(for object: ASAuthorizationController) -> ASAuthorizationControllerDelegate? {
    return object.delegate
  }

  static func setCurrentDelegate(_ delegate: ASAuthorizationControllerDelegate?, to object: ASAuthorizationController) {
    object.delegate = delegate
  }

  // MARK: ASAuthorizationController delegate

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let identityToken = appleIDCredential.identityToken else { return }

      let jwtToken = String(decoding: identityToken, as: UTF8.self)
      let userIdentifier = appleIDCredential.user
      let token = LificToken(accessToken: userIdentifier)

      let decodeEmail = decodeEmail(from: jwtToken)

      if decodeEmail.contains("privaterelay.appleid.com") {
        userInfo.onNext((token, ""))
      } else {
        userInfo.onNext((token, decodeEmail))
      }

      log.debug(decodeEmail)
      log.debug(token)
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    self.error.onNext(error)
  }

  private func decodeEmail(from token: String) -> String {
    guard let jwt = try? decode(jwt: token) else {
      return ""
    }

    return jwt.claim(name: "email").string ?? ""
  }

  deinit {
    userInfo.onCompleted()
    error.onCompleted()
  }
}

// MARK: - ASAuthorizationController + Rx

extension Reactive where Base: ASAuthorizationController {

  var delegate: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate> {
    return RxAppleAuthorizationDelegateProxy.proxy(for: base)
  }

  var userInfo: Observable<(token: LificToken, email: String)> {
    return RxAppleAuthorizationDelegateProxy.proxy(for: base)
      .userInfo
  }

  var error: Observable<Error> {
    return RxAppleAuthorizationDelegateProxy.proxy(for: base)
      .error
  }
}
