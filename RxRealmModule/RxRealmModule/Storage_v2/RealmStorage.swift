//
//  RealmStorage.swift
//  RxRealmModule
//
//  Created by buzz on 2021/09/14.
//  Copyright © 2021 jinnify. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxRealm
import RxSwift

public protocol RealmStorageable {
  associatedtype T

  func queryAll() -> Observable<[T]>
  func query(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) -> Observable<[T]>
  func save(entity: T) -> Observable<Void>
  func delete(entity: T) -> Observable<Void>
}

public final class RealmStorage<T: RealmStorable>: RealmStorageable where T == T.RealmType.EntityType, T.RealmType: Object {

  private let disposeBag = DisposeBag()
  private let configuration: Realm.Configuration

  private var realm: Realm {
    return try! Realm(configuration: configuration)
  }

  public init(configuration: Realm.Configuration) {
    self.configuration = configuration
    log.debug("📁 File url: \(RLMRealmPathForFile("default.realm"))")
  }

  public func queryAll() -> Observable<[T]> {
    return Observable.deferred {
      let realm = self.realm
      let objects = realm.objects(T.RealmType.self)

      return Observable.array(from: objects)
        .map { $0.map { $0.asEntity() } }
    }
  }

  public func query(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) -> Observable<[T]> {
    return Observable.deferred {
      let realm = self.realm
      let objects = realm.objects(T.RealmType.self)
        .filter(predicate)
        .sorted(by: sortDescriptors.map { SortDescriptor(keyPath: $0.key ?? "", ascending: $0.ascending) })

      return Observable.array(from: objects)
        .map { $0.map { $0.asEntity() } }
    }
  }

  public func save(entity: T) -> Observable<Void> {
    return Observable.deferred {
      return self.realm.rx.save(entity: entity)
    }
  }

  public func delete(entity: T) -> Observable<Void> {
    return Observable.deferred {
      return self.realm.rx.delete(entity: entity)
    }
  }
}
