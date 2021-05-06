//
//  CommonResponse.swift
//  Common
//
//  Created by buzz on 2021/05/03.
//

import Foundation

public struct CommonResponse<T: Codable>: Codable {
  public var code: String
  public var message: String
  public var data: T?
}
