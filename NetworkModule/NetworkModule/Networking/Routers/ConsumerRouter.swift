//
//  ConsumerRouter.swift
//  Common
//
//  Created by buzz on 2021/05/01.
//

import Moya
import Alamofire

public enum ConsumerRouter {
  /* Scene */
  case test
}

extension ConsumerRouter: TargetType {

  public var baseURL: URL {
    return url(for: environment.value)
  }

  public var path: String {
    switch self {
    case .test: return "/consumer/business/branch/info/simple/1"
    }
  }

  public var method: Alamofire.HTTPMethod {
    switch self {
    case .test:
      return .get
    }
  }

  public var sampleData: Data {
    return "data".data(using: String.Encoding.utf8)!
  }

  public var task: Task {
    switch self {
    case .test:
      return .requestPlain
    }
  }

  public var headers: [String: String]? {
    return [
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Lific-Api-Version": "v1",
      "Lific-Domain": "business",
      "Lific-App-Version": "1.x.x",
      "Lific-Device": "iPhone",
      "Lific-Os": "iOS",
//      "Lific-Access-Token": """
//eyJ0eXAiOiJKV1QiLCJtZW1iZXJUeXBlIjoiUEFSVE5FUiIsImFsZyI6IkhTMjU2In0
//.eyJ0b2tlblBvbGljeVZlcnNpb24iOiJ2MSIsImV4cGlyZWRBdCI6IjIwMjEtMDQtMzBUMTM6NDY6MTQ
//iLCJicmFuY2hJZCI6MTkwMDAwMDEwLCJtZW1iZXJVaWQiOjExLCJidXNpbmVzc0lkIjoxOTAwMDAwMT
//AsInR5cGUiOiJCVVNJTkVTUyIsIm1lbWJlcklkIjoiaW9zX2J1enoifQ.24iUBN4nsKx5FmC2ukqlE9ken9dLk-8yGzr7fmk1Trs
//""",
//      "Lific-Refresh-Token": """
//eyJ0eXAiOiJKV1QiLCJtZW1iZXJUeXBlIjoiUEFSVE5FUiIsImFsZyI6IkhTMjU2In0
//.eyJ0b2tlblBvbGljeVZlcnNpb24iOiJ2MSIsImV4cGlyZWRBdCI6IjIwMjEtMDQtMzBUMTM6NDY6MTQiLCJtZW1i
//ZXJVaWQiOjExLCJtZW1iZXJJZCI6Imlvc19idXp6In0.4gKz28-x0JDW4DGauF6PYE5paQn1iXxOzEDRReBiNiA
//""",
      "Lific-Push-Token": AuthManager.shared.pushToken ?? ""
    ]
  }
}

// MARK: - Helper methods

extension ConsumerRouter {

  func url(for environment: Environment) -> URL {
    switch environment {
    case .dev:
      guard let url = URL(string: "http://dev-gateway.api.lific.net") else {
        fatalError("fatal error - invalid url")
      }
      return url
    case .stage:
      guard let url = URL(string: "http://qa-gateway.api.lific.net") else {
        fatalError("fatal error - invalid url")
      }
      return url
    case .release:
      guard let url = URL(string: "http://dev-gateway.api.lific.net") else {
        fatalError("fatal error - invalid url")
      }
      return url
    }
  }
}
