//
//  NetworkDataResponse.swift
//  Common
//
//  Created by buzz on 2021/05/03.
//

import Foundation

public enum NetworkResult: String {
  // network response의 code는 0(success)을 제외한 모든 문자는 failure
  case success = "0"
  case failure = "1"
}

public struct NetworkDataResponse {
  public let json: Decodable?
  public let result: NetworkResult
  public let error: NetworkError?
}
