//
//  FacebookAppService.swift
//  FacebookLoginModule
//
//  Created by buzz on 2021/04/09.
//

import Common
import FBSDKCoreKit
import FBSDKLoginKit
import RxCocoa
import RxSwift
import Firebase
import Resolver

class FacebookAppService: NSObject, AppService {

  /// Facebook 로그인 매니저
  let loginManager = LoginManager()

  /// 에러 메세지
  var errorMessage = PublishSubject<Error>()

  func configure() { }
}

extension FacebookAppService {

  /// 페이스북 초기화
  func initialize(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
    ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// 페이스북으로부터 리다이렉트 된 URL 인지 체크 후 요청 결과를 처리
  func facebookLoginOpenURL(openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url {
      ApplicationDelegate.shared.application(
        UIApplication.shared,
        open: url,
        sourceApplication: nil,
        annotation: [UIApplication.OpenURLOptionsKey.annotation]
      )
    }
  }

  /// 로그인
  func login(target: UIViewController) -> Observable<LificToken> {
    return Observable.create { [weak self] observer -> Disposable in
      self?.loginManager.logIn(permissions: [.email], viewController: target, completion: { result in
        switch result {
        case .cancelled:
          log.debug("User cancelled login")
          observer.onCompleted()
        case let .failed(error):
          log.error(error.localizedDescription)
          self?.errorMessage.onNext(error)
          observer.onCompleted()
        case let .success(_, _, token):
          let lificToken = LificToken(accessToken: token?.tokenString ?? "")
          observer.onNext(lificToken)
          observer.onCompleted()
        }
      })
      return Disposables.create()
    }
  }

  /// 로그아웃
  func logout() -> Observable<Void> {
    return Observable.create { [weak self] observer -> Disposable in
      self?.loginManager.logOut()
      observer.onCompleted()
      return Disposables.create()
    }
  }

  /// 사용자에 대한 정보
  func userInfo() -> Observable<Profile?> {
    return Observable.create { [weak self] observer -> Disposable in
      Profile.loadCurrentProfile { profile, error in
        if let error = error {
          self?.errorMessage.onNext(error)
          observer.onCompleted()
          return
        }

        observer.onNext(profile)
        observer.onCompleted()
      }
      return Disposables.create()
    }
  }
}

