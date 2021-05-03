//
//  NetworkLoggerPlugin.swift
//  Common
//
//  Created by buzz on 2021/05/03.
//

import Foundation
import Moya
import Toast_Swift
import UIKit

final class NetworkLoggerPlugin: PluginType {

  func willSend(_ request: RequestType, target: TargetType) {

    #if DEBUG
      let url = request.request?.url?.absoluteString ?? ""
      let header = request.request?.allHTTPHeaderFields ?? [:]
      let bodyData = request.request?.httpBody ?? Data()
      let body = String(bytes: bodyData, encoding: .utf8) ?? ""
      let log = """
      [👉🏻 Request]
        🌏 URL : \(url)
           TARGET : \(target)
           HEADER : \(header)
           BODY : \(body)
      [👉🏻 END]
      """
      print(log)
    #endif
  }

  func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
    #if DEBUG
      switch result {
      case let .success(response):
        let request = response.request
        let url = request?.url?.absoluteString ?? ""
        let statusCode = response.statusCode
        let responseData = String(bytes: response.data, encoding: .utf8) ?? ""
        let log = """
        [👈🏻 Response]
          🌏 URL : \(url)
             TARGET : \(target)
             STATUS CODE : \(statusCode)
             RESPONSE DATA : \(responseData)
        [👈🏻 END]
        """
        print(log)

      case let .failure(error):
        let statusCode = error.errorCode
        let reason = error.failureReason ?? error.errorDescription ?? "unknown error"
        let log = """
        [❗️ Error Response]
          🌏 TARGET : \(target)
             STATUS CODE : \(statusCode)
             ERROR REASON : \(reason)
        [❗️ END]
        """
        print(log)
      }
    #endif
  }
}
