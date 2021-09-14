//
//  RealmHelper.swift
//  RxRealmModule
//
//  Created by buzz on 2021/09/14.
//  Copyright © 2021 jinnify. All rights reserved.
//

import Realm
import RealmSwift
import RxCocoa
import RxSwift

// MARK: - Realm + Rx

extension Reactive where Base == Realm {

  func save<R: RealmStorable>(entity: R) -> Observable<Void> where R.RealmType: Object {
    return Observable.create { observer in
      do {
        try self.base.write {
          self.base.add(entity.asRealm(), update: .modified)
        }

        observer.onNext(())
        observer.onCompleted()
      } catch {
        observer.onError(error)
      }

      return Disposables.create()
    }
  }

  func delete<R: RealmStorable>(entity: R) -> Observable<Void> where R.RealmType: Object {
    return Observable.create { observer in
      do {
        guard let object = self.base.object(ofType: R.RealmType.self, forPrimaryKey: entity.uid) else {
          fatalError("Realm delete error")
        }

        try self.base.write {
          self.base.delete(object)
        }

        observer.onNext(())
        observer.onCompleted()
      } catch {
        observer.onError(error)
      }

      return Disposables.create()
    }
  }
}

// MARK: - Realm object builder

extension Object {

  public static func build<O: Object>(_ builder: (O) -> Void) -> O {
    let object = O()
    builder(object)

    return object
  }
}
