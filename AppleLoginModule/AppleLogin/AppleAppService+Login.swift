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
import RxSwift

extension AppleAppService {

  /// 로그인
  func login() -> Completable {
    return Completable.create { [weak self] completable -> Disposable in
      self?.authorizationController?.performRequests()
      completable(.completed)

      return Disposables.create()
    }
  }

  /// 로그아웃
  func logout() -> Completable {
    return Completable.create { [weak self] completable -> Disposable in
      self?.appleIDProvider.getCredentialState(forUserID: "test") { state, error in
        switch state {
        case .authorized:
          return
        case .revoked, .notFound:
          // logout 로직
          completable(.completed)
        default:
          return
        }
      }

      return Disposables.create()
    }
  }
}

extension AppleAppService: ASAuthorizationControllerDelegate {

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let token = appleIDCredential.identityToken else { return }
      let idToken = String(decoding: token, as: UTF8.self)
      userInfo.onNext(appleIDCredential.email ?? "")
      log.debug(idToken)
      log.debug(appleIDCredential.email ?? "")
      log.debug(appleIDCredential.fullName ?? "")
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    log.error(error.localizedDescription)
  }
}

extension AppleAppService: ASAuthorizationControllerPresentationContextProviding {

  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return Application.shared.window ?? UIWindow()
  }
}
