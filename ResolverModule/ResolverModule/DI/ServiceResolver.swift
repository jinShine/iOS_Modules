//
//  ServiceResolver.swift
//  ResolverModule
//
//  Created by buzz on 2021/04/05.
//

import Foundation
import Resolver

extension Resolver {

  static func registerService() {
    register { FirebaseAppService() }.scope(.application)
    register(KakaoAppService.self) { KakaoAppService() }
    register(NaverAppService.self) { NaverAppService() }
    register { LokalizeService() }.scope(.application)
    register { GoogleAppService() }.scope(.application)
  }
}
