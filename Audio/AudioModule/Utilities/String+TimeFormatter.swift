//
//  String+TimeFormatter.swift
//  AudioModule
//
//  Created by Seungjin on 04/02/2020.
//  Copyright © 2020 jinnify. All rights reserved.
//

import Foundation

extension Float {

  enum TimeConstant {
    static let secsPerMin = 60
    static let secsPerHour = TimeConstant.secsPerMin * 60
  }

  func formatted() -> String {
    var secs = Int(ceil(self))
    var hours = 0
    var mins = 0

    if secs > TimeConstant.secsPerHour {
      hours = secs / TimeConstant.secsPerHour
      secs -= hours * TimeConstant.secsPerHour
    }

    if secs > TimeConstant.secsPerMin {
      mins = secs / TimeConstant.secsPerMin
      secs -= mins * TimeConstant.secsPerMin
    }

    var formattedString = ""
    if hours > 0 {
      formattedString = "\(String(format: "%02d", hours)):"
    }
    formattedString += "\(String(format: "%02d", mins)):\(String(format: "%02d", secs))"
    return formattedString
  }
}
