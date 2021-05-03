//
//  NetworkService.swift
//  Common
//
//  Created by buzz on 2021/04/30.
//

import Foundation
import RxSwift
import RxCocoa

let environment = BehaviorRelay<Environment>(value: .dev)

public struct NetworkService {

  public init(env: Environment) {
    environment.accept(env)
  }
}
