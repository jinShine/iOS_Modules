//
//  ApplicationResolver.swift
//  ResolverModule
//
//  Created by buzz on 2021/04/05.
//

import Resolver

extension Resolver: ResolverRegistering {

  public static func registerAllServices() {
    register { Navigator.shared }.scope(.application)
    register { AppServiceSynchronizer() }.scope(.application)
    register { AppConfiguration.default }.scope(.application)

    registerService()
    registerInteractor()
    registerTabBar()
    registerLogin()
  }
}
