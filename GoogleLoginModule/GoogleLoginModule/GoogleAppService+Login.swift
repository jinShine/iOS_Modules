//
//  GoogleAppService+Login.swift
//  GoogleLoginModule
//
//  Created by buzz on 2021/08/25.
//  Copyright © 2021 Jinnify. All rights reserved.
//

import Common
import Firebase
import Foundation
import GoogleSignIn
import RxCocoa
import RxSwift

extension GoogleAppService {

  /// 구글로부터 리다이렉트 된 URL 인지 체크 후 요청 결과를 처리
  func googleLoginOpenURL(openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url {
      GIDSignIn.sharedInstance()?.handle(url)
    }
  }

  /// 로그인
  func login(target: UIViewController?) -> Observable<Void> {
    return Observable.create { observer -> Disposable in
      GIDSignIn.sharedInstance()?.presentingViewController = target
      GIDSignIn.sharedInstance()?.signIn()

      observer.onCompleted()
      return Disposables.create()
    }
  }

  /// 로그아웃
  func logout() -> Observable<Void> {
    return Observable.create { observer -> Disposable in
      GIDSignIn.sharedInstance()?.signOut()

      observer.onCompleted()
      return Disposables.create()
    }
  }

  /// 유저 정보
  func userInfo() -> Observable<(token: LificToken, email: String)> {
    return GIDSignIn.sharedInstance().rx.userInfo
      .map { user -> (LificToken, String) in
        let authentication = user.authentication
        let token = LificToken(
          accessToken: authentication?.accessToken ?? "",
          refreshToken: authentication?.refreshToken ?? ""
        )
        let email = user.profile.email ?? ""

        return (token, email)
      }
  }

  /// 에러 정보
  func error() -> Observable<Error> {
    return GIDSignIn.sharedInstance().rx.errorMessage
  }
}

// MARK: - Delegate proxy

class RxGIDSignInDelegateProxy: DelegateProxy<GIDSignIn, GIDSignInDelegate>, GIDSignInDelegate, DelegateProxyType {

  /// 유저 정보
  let userInfo = PublishSubject<GIDGoogleUser>()

  /// 에러 메세지
  let errorMessage = PublishSubject<Error>()

  // MARK: DelegateProxy type

  static func registerKnownImplementations() {
    register {
      RxGIDSignInDelegateProxy(parentObject: $0, delegateProxy: self)
    }
  }

  static func currentDelegate(for object: ParentObject) -> Delegate? {
    return GIDSignIn.sharedInstance().delegate
  }

  static func setCurrentDelegate(_ delegate: Delegate?, to object: ParentObject) {
    object.delegate = delegate
  }

  // MARK: GIDSignIn delegate

  func sign(_ signIn: GIDSignIn, didSignInFor user: GIDGoogleUser, withError error: Error?) {
    if let error = error {
      log.error(error)
      errorMessage.onNext(error)
      return
    }

    userInfo.onNext(user)
  }

  func sign(_ signIn: GIDSignIn, didDisconnectWith user: GIDGoogleUser, withError error: Error) {
    log.error(error)
    errorMessage.onNext(error)
  }

  deinit {
    userInfo.onCompleted()
    errorMessage.onCompleted()
  }
}

// MARK: - GIDSignIn + Rx

extension Reactive where Base: GIDSignIn {

  var delegate: DelegateProxy<GIDSignIn, GIDSignInDelegate> {
    return RxGIDSignInDelegateProxy.proxy(for: base)
  }

  var userInfo: Observable<GIDGoogleUser> {
    return RxGIDSignInDelegateProxy.proxy(for: base)
      .userInfo
  }

  var errorMessage: Observable<Error> {
    return RxGIDSignInDelegateProxy.proxy(for: base)
      .errorMessage
  }
}
