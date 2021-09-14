//
//  RealmStorageProvider.swift
//  RxRealmModule
//
//  Created by buzz on 2021/09/14.
//  Copyright © 2021 jinnify. All rights reserved.
//

import Common
import Foundation
import Realm
import RealmSwift

protocol StorageProviderable {

  var user: RealmStorage<RMUserEntity> { get }
}

final class RealmStorageProvider {

  private let configuration: Realm.Configuration

  init(configuration: Realm.Configuration = Realm.Configuration()) {
    self.configuration = configuration
  }
}

extension RealmStorageProvider: StorageProviderable {

  var user: RealmStorage<RMUserEntity> {
    return RealmStorage<RMUserEntity>(configuration: configuration)
  }
}
