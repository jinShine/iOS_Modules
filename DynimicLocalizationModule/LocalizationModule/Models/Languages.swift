//
//  Languages.swift
//  LocalizationModule
//
//  Created by Buzz.Kim on 2020/08/06.
//  Copyright © 2020 jinnify. All rights reserved.
//

import Foundation

struct Languages: Decodable {
  var languages: [Language]
}

struct Language: Decodable {
  var code: String
  var translations: [String: String]
}
