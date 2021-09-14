//
//  RealmStorable.swift
//  RxRealmModule
//
//  Created by buzz on 2021/09/14.
//  Copyright © 2021 jinnify. All rights reserved.
//

import Foundation

public protocol RealmStorable {
  associatedtype RealmType: EntityConvertible

  var uid: String { get }

  func asRealm() -> RealmType
}

public protocol EntityConvertible {
  associatedtype EntityType

  func asEntity() -> EntityType
}
