//
//  NetworkStatusCode.swift
//  Common
//
//  Created by buzz on 2021/05/03.
//

import Foundation

public enum NetworkStatusCode: Int {
  case unauthorized = 401
  case forbidden = 403
}

public enum LificStatusCode: String {
  case success = "0"
  case accessTokenExpired = "GWY003"
}
