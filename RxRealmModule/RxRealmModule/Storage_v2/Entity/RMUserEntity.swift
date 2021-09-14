//
//  RMUserEntity.swift
//  RxRealmModule
//
//  Created by buzz on 2021/09/14.
//  Copyright © 2021 jinnify. All rights reserved.
//

import Common
import Realm
import RealmSwift

@objcMembers
class RMUser: Object {
  dynamic var consumerMemberUid: Int = 0
  dynamic var lastLoginType: LoginType.RawValue = ""

  override class func primaryKey() -> String? {
    return "consumerMemberUid"
  }
}

extension RMUser: EntityConvertible {
  func asEntity() -> RMUserEntity {
    RMUserEntity(consumerMemberUid: consumerMemberUid, lastLoginType: lastLoginType)
  }
}

struct RMUserEntity: RealmStorable {
  var consumerMemberUid: Int = 0
  var lastLoginType: LoginType.RawValue = ""

  var uid: String {
    return ""
  }

  func asRealm() -> RMUser {
    return RMUser.build { object in
      object.consumerMemberUid = consumerMemberUid
      object.lastLoginType = lastLoginType
    }
  }
}
