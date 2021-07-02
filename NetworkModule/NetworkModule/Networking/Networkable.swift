//
//  Networkable.swift
//  Common
//
//  Created by buzz on 2021/05/04.
//

import Foundation
import RxSwift

public protocol Networkable {
  associatedtype Router

  func request<T: Decodable>(
    to router: Router,
    decode: T.Type
  ) -> Observable<CommonResponse<T>>

  func request<T: Decodable>(
    to router: Router,
    decode: T.Type
  ) -> Observable<T>
}
