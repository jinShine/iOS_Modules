//
//  NetworkError.swift
//  Common
//
//  Created by buzz on 2021/05/03.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

public struct NetworkError: Decodable, Error {
  let code: String
  let message: String
}

// MARK: - Network error builder

extension NetworkError {

  public static func catchError(_ error: Error) {
    if let error = error as? MoyaError {
      switch error {
      case .statusCode(let response):
        let code = NetworkStatusCode(rawValue: response.statusCode)

        if code != .unauthorized && code != .forbidden {
          if AuthManager.shared.hasValidToken {
            AuthManager.shared.removeToken()
            NotificationCenter.default.post(name: .accessTokenDidExpire, object: nil)
          }
        }
      default: break
      }
    }
  }
}

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

  public func catchErrorLific() -> Single<Element> {
    return flatMap { response in
      if let response = try? JSONDecoder().decode(CommonResponse<Default>.self, from: response.data) {
        let code = LificStatusCode(rawValue: response.code)

        if code == .accessTokenExpired {
          if AuthManager.shared.hasValidToken {
            AuthManager.shared.removeToken()
            NotificationCenter.default.post(name: .accessTokenDidExpire, object: nil)
          }
        }

        log.debug(response.message)
      }

      return .just(response)
    }
  }
}
