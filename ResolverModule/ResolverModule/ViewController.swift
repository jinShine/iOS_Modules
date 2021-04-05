//
//  ViewController.swift
//  ResolverModule
//
//  Created by buzz on 2021/04/05.
//

import UIKit
import Resolver

class ViewController: UIViewController {

  let viewmode = ViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    viewmode.action()
  }
}

class NetworkService {

}


class ViewModel {

  @Injected var network: NetworkService

  func action() {
    print(network)
    print("액션 실행됨")
  }
}

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {

    register { NetworkService() }
    print("실행됨")
  }
}
