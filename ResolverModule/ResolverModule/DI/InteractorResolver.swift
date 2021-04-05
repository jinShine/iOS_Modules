//
//  InteractorResolver.swift
//  ResolverModule
//
//  Created by buzz on 2021/04/05.
//

import Foundation
import Resolver

extension Resolver {

  static func registerInteractor() {
    register(SNSLoginInteractorable.self) {
      SNSLoginInteractor(
        kakaoAppService: $0.resolve(KakaoAppService.self),
        naverAppService: $0.resolve(NaverAppService.self)
      )
    }.scope(.application)
  }
}
