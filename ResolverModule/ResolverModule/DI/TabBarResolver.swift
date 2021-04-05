//
//  TabBarResolver.swift
//  ResolverModule
//
//  Created by buzz on 2021/04/05.
//

import Foundation
import Resolver

extension Resolver {

  static func registerTabBar() {
    register { HomeTabBarViewModelBindable.self }
    register(HomeTabBarController.self) {
      HomeTabBarController(
        viewModel: $0.resolve(HomeTabBarViewModelBindable.self),
        navigator: $0.resolve(Navigator.self)
      )
    }
  }
}
