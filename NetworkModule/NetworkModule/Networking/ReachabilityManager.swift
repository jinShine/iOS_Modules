//
//  ReachabilityManager.swift
//  NetworkModule
//
//  Created by buzz on 2021/07/02.
//

import Alamofire
import Foundation
import RxCocoa
import RxSwift

public func networkEnable() -> Observable<Bool> {
  return ReachabilityManager.shared.reach
}

public class ReachabilityManager: NSObject {

  // MARK: - Properties

  /// singleton
  public static let shared = ReachabilityManager()

  let reachSubject = ReplaySubject<Bool>.create(bufferSize: 1)
  var reach: Observable<Bool> {
    return reachSubject.asObservable()
      .do(onNext: { reachable in
        if !reachable {
          NotificationCenter.default.post(name: .notReachable, object: nil)
        }
      })
  }

  // MARK: - Initialize

  override private init() {
    super.init()

    NetworkReachabilityManager.default?.startListening(onUpdatePerforming: { status in
      let reachable = (status == .notReachable || status == .unknown) ? false : true
      self.reachSubject.onNext(reachable)
    })
  }
}
