//
//  RealmService.swift
//  RxRealmModule
//
//  Created by Buzz.Kim on 2020/07/20.
//  Copyright © 2020 jinnify. All rights reserved.
//

import RxSwift
import RealmSwift
import RxRealm

//protocol Realmable {
//  associatedtype T
//
//  @discardableResult
//  func add(object: T) -> Single<Bool>
//
//  @discardableResult
//  func add(objects: [T]) -> Single<Bool>
//
//  func findAll() -> Single<Results<T>>
//
//  func findFirst() -> Single<T?>
//
//  func findLast() -> Single<T?>
//
//  @discardableResult
//  func update(object: T) -> Single<Bool>
//
//  @discardableResult
//  func update(objects: [T]) -> Single<Bool>
//}

public final class RealmService<T: RealmSwift.Object> {
  
  let realm: Realm
  
  public init() {
    try! realm = Realm()
    defer {
      realm.invalidate()
    }
  }
  
  @discardableResult
  public func add(object: T) -> Single<Bool> {
    return Single.create { single -> Disposable in
      do {
        try self.realm.write {
          self.realm.add(object)
          single(.success(true))
        }
      } catch {
        single(.success(false))
        print(error.localizedDescription)
      }
      
      return Disposables.create()
    }
  }
  
  @discardableResult
  public func add(objects: [T]) -> Single<Bool> {
    return Single.create { single -> Disposable in
      do {
        try self.realm.write {
          self.realm.add(objects)
          single(.success(true))
        }
      } catch {
        single(.success(false))
        print(error.localizedDescription)
      }
      
      return Disposables.create()
    }
  }
  
  public func findAll() -> Single<Results<T>> {
    return Single.create { single -> Disposable in
      single(.success(self.realm.objects(T.self)))
      return Disposables.create()
    }
  }
  
  public func findFirst() -> Single<T?> {
    return findAll().map { $0.first }
  }
  
  public func findFirst(key: AnyObject) -> Single<T?> {
    return Single.create { single -> Disposable in
      single(.success(self.realm.object(ofType: T.self, forPrimaryKey: key)))
      return Disposables.create()
    }
  }
  
  public func findLast() -> Single<T?> {
    return findAll().map { $0.last }
  }
  
  @discardableResult
  public func update(object: T) -> Single<Bool> {
    return Single.create { single -> Disposable in
      do {
        try self.realm.write {
          self.realm.add(object, update: .modified)
          single(.success(true))
        }
      } catch {
        single(.success(false))
        print(error.localizedDescription)
      }
      
      return Disposables.create()
    }
  }
  
  @discardableResult
  public func update(objects: [T]) -> Single<Bool> {
    return Single.create { single -> Disposable in
      do {
        try self.realm.write {
          self.realm.add(objects, update: .modified)
          single(.success(true))
        }
      } catch {
        single(.success(false))
        print(error.localizedDescription)
      }
      
      return Disposables.create()
    }
  }
  
  @discardableResult
  public func delete(object: T) -> Single<Bool> {
    return Single.create { single -> Disposable in
      do {
        try self.realm.write {
          self.realm.delete(object)
          single(.success(true))
        }
      } catch {
        single(.success(false))
        print(error.localizedDescription)
      }
      
      return Disposables.create()
    }
  }
  
  @discardableResult
  public func deleteAll() -> Single<Bool> {
    return Single.create { single -> Disposable in
      let objects = self.realm.objects(T.self)
      
      do {
        try self.realm.write {
          self.realm.delete(objects)
          single(.success(true))
        }
      } catch {
        single(.success(false))
        print(error.localizedDescription)
      }
      
      return Disposables.create()
    }
  }
  
}
