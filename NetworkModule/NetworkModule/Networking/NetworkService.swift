//
//  NetworkService.swift
//  Common
//
//  Created by buzz on 2021/04/30.
//

import Alamofire
import Moya
import RxCocoa
import RxSwift

public typealias Default = String

public class NetworkService<Router: TargetType> {

  private let dispatchQueue = DispatchQueue(label: "queue.consumer.parser")

  public var provider: MoyaProvider<Router>

  public init() {
    provider = MoyaProvider<Router>(
      endpointClosure: MoyaProvider.defaultEndpointMapping,
      requestClosure: MoyaProvider<Router>.defaultRequestMapping,
      stubClosure: MoyaProvider.neverStub,
      callbackQueue: nil,
      session: AlamofireSession.configuration,
      plugins: [NetworkLoggerPlugin()],
      trackInflights: false
    )
  }
}

extension NetworkService: Networkable {

  public func request<T: Decodable>(
    to router: Router,
    decode: T.Type
  ) -> Single<CommonResponse<T>> {
    // let online = networkEnable()
    return provider.rx.request(router, callbackQueue: dispatchQueue)
      .filterSuccessfulStatusCodes()
      .do(
        onSuccess: { response in },
        onError: { NetworkError.catchError($0) }
      )
      .catchErrorLific()
      .map(CommonResponse<T>.self)
  }
}
