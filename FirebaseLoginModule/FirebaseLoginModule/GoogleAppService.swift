//
//  GoogleAppService.swift
//  FirebaseLoginModule
//
//  Created by buzz on 2021/04/06.
//

import Common
import Foundation
import Firebase
import GoogleSignIn
import RxSwift
import RxCocoa

class GoogleAppService: GIDSignInDelegate {

  /// 유저 정보
  var userInfo = PublishSubject<GIDGoogleUser>()

  /// 에러 메세지
  var errorMessage = PublishSubject<Error?>()

  /// 구글로부터 리다이렉트 된 URL 인지 체크 후 요청 결과를 처리
  func googleLoginOpenURL(openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url {
      GIDSignIn.sharedInstance()?.handle(url)
    }
  }

  /// 로그인
  func login(target: UIViewController?) -> Completable {
    return Completable.create { completable -> Disposable in
      GIDSignIn.sharedInstance()?.presentingViewController = target
      GIDSignIn.sharedInstance()?.signIn()

      completable(.completed)
      return Disposables.create()
    }
  }

  /// 로그아웃
  func logout() -> Completable {
    return Completable.create { completable -> Disposable in
      GIDSignIn.sharedInstance()?.signOut()

      completable(.completed)
      return Disposables.create()
    }
  }

  // MARK: - Google SignIn Delegate

  func sign(_ signIn: GIDSignIn, didSignInFor user: GIDGoogleUser, withError error: Error?) {
    if let error = error {
      log.error(error)
      errorMessage.onNext(error)
      return
    }

    guard let authentication = user.authentication else { return }

    userInfo.onNext(user)
    log.info(user.profile.email)
    log.info(authentication.accessToken)
    log.info(authentication.refreshToken)
  }

  func sign(_ signIn: GIDSignIn, didDisconnectWith user: GIDGoogleUser, withError error: Error) {
    log.error(error)
    errorMessage.onNext(error)
  }
}
