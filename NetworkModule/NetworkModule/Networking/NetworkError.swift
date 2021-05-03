//
//  NetworkError.swift
//  Common
//
//  Created by buzz on 2021/05/03.
//

import Foundation

public struct NetworkError: Decodable, Error {
  let code: String
  let message: String
}

// MARK: - Network error builder

extension NetworkError {

  public static func transform(jsonData: Data?) -> NetworkDataResponse {
    do {
      let result = try JSONDecoder().decode(NetworkError.self, from: jsonData ?? Data())
      log.debug(result)
      return NetworkDataResponse(
        json: nil,
        result: .failure,
        error: NetworkError(code: result.code, message: result.message)
      )
    } catch {
      log.debug("Decodable Error")
      return NetworkDataResponse(
        json: nil,
        result: .failure,
        error: NetworkError(code: NetworkResult.failure.rawValue, message: "Decodable Error")
      )
    }
  }

  public static func networkFailure() -> NetworkDataResponse {
    return NetworkDataResponse(
      json: nil,
      result: .failure,
      error: NetworkError(
        code: NetworkResult.failure.rawValue,
        message: "네트워크가 연결되지 않았습니다.\nWIFI 또는 데이터 상태를 확인 후 다시 시도해 주세요."
      )
    )
  }
}
