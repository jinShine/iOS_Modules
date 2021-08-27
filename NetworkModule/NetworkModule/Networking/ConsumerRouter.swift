//
//  ConsumerRouter.swift
//  Common
//
//  Created by buzz on 2021/05/01.
//

import Alamofire
import Common
import Moya

public enum ConsumerRouter {
  /* Scene */
  case test
}

extension ConsumerRouter: TargetType {

  public var baseURL: URL {
    switch Application.environment {
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

      /*
     case .expertUsePush(let isUse):
       return .requestParameters(
          parameters: ["useYn": isUse.yn],
          encoding: JSONEncoding.default
     case .registrationProductForImmediately(let immediatelyProduct):
        return .requestJSONEncodable(immediatelyProduct)

     case .exchangeRate(let currencyCode, let price):
       return .requestParameters(parameters: [
         "currencyCode": currencyCode,
         "price": price
       ], encoding: URLEncoding.default)

     case .profileImageUpload(let data):
       let multipartFormData = MultipartFormData(
         provider: .data(data), name: "imageUploadFile", fileName: "profileImage.png"
       )
       return .uploadMultipart([multipartFormData])
     )
     */

    }
  }

  public var headers: [String: String]? {
    return [
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Lific-Api-Version": "v1",
      "Lific-Domain": "business",
      "Lific-App-Version": Application.appVersion,
      "Lific-Device": UIDevice.current.model,
      "Lific-Os": UIDevice.current.systemName,
      "Lific-Timezone": TimeZone.current.identifier,
      "Lific-Language-Code": Locale.current.languageCode ?? "",
      "Lific-Country-Code": Locale.current.regionCode ?? "",
      "Lific-Access-Token": AuthManager.shared.accessToken ?? "",
      "Lific-Refresh-Token": AuthManager.shared.refreshToken ?? "",
      "Lific-Push-Token": AuthManager.shared.pushToken ?? ""
    ]
  }
}
