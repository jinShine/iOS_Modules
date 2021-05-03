//
//  NetworkService+Consumer.swift
//  Common
//
//  Created by buzz on 2021/05/01.
//

import Alamofire
import Foundation
import Moya
import RxCocoa
import RxSwift

public protocol LificNetworkable {

  func request<T: Decodable>(
    to router: ConsumerRouter,
    decode: T.Type
  ) -> Single<CommonResponse<T>>
}

extension NetworkService: LificNetworkable {

  private static let sharedManager: Alamofire.Session = {
    let configuration = URLSessionConfiguration.default
    configuration.headers = HTTPHeaders.default
    configuration.timeoutIntervalForRequest = 30
    configuration.timeoutIntervalForResource = 30
    configuration.requestCachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
    return Alamofire.Session(configuration: configuration)
  }()

  public var provider: MoyaProvider<ConsumerRouter> {
    let provider = MoyaProvider<ConsumerRouter>(
      endpointClosure: MoyaProvider.defaultEndpointMapping,
      requestClosure: MoyaProvider<ConsumerRouter>.defaultRequestMapping,
      stubClosure: MoyaProvider.neverStub,
      callbackQueue: nil,
      session: NetworkService.sharedManager,
      plugins: [NetworkLoggerPlugin()],
      trackInflights: false
    )

    return provider
  }

  public func request<T: Decodable>(
    to router: ConsumerRouter,
    decode: T.Type
  ) -> Single<CommonResponse<T>> {
    let request = provider.rx.request(router).debug("111111111111")
    let online = ReachabilityManager.shared.networkEnable()

    return request
//      .filter { $0 == true }
//      .asSingle()
      .flatMap { _ -> Single<Response> in
        request
          .debug("12312312312312")
          .filterSuccessfulStatusCodes()
          .do(
            onSuccess: { response in },
            onError: { error in
              if let error = error as? NetworkError {
                let errorCode = NetworkErrorCode(rawValue: error.code)
                if errorCode == .accessTokenExpired {
                  // accessTokenExpired
                  if AuthManager.shared.hasValidToken {
                    AuthManager.shared.removeToken()
                    NotificationCenter.default.post(name: .accessTokenDidExpire, object: nil)
                  }
                }
              }
            }
          )
      }.map(CommonResponse<T>.self)
  }
}
