//
//  AppInitialization.swift
//  RxRealmModule
//
//  Created by Buzz.Kim on 2020/07/20.
//  Copyright © 2020 jinnify. All rights reserved.
//

import Foundation
import RealmSwift

public class AppInitialization: Object, Codable {
  @objc dynamic var code: String = ""
  @objc dynamic var message: String = ""
  var data: InitializationData?
}

public class InitializationData: Object, Codable {
  var motherTongues: [String] = []
  var commonCodeList: [CommonCodes] = []
}

public class CommonCodes: Object, Codable {
  @objc dynamic var uid: Int = 0
  @objc dynamic var code: String = ""
  @objc dynamic var name: String = ""
  @objc dynamic var version: Int = 0
  var detailList: [CommonCodeDetails] = []

  enum CodingKeys: String, CodingKey {
    case uid = "commonCodeUid"
    case code = "commonCode"
    case name = "commonCodeName"
    case version = "codeVersion"
    case detailList = "commonCodeDetailList"
  }

  public override class func primaryKey() -> String? {
    return "uid"
  }
}

public class CommonCodeDetails: Object, Codable {
  @objc dynamic var detail: String = ""
  @objc dynamic var value: String = ""
  @objc dynamic var odr: Int = 0
}
