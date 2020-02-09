//
//  MIMEType.swift
//  MessageUIModule
//
//  Created by seungjin on 2020/02/09.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation

enum MIMEType: String {
  case jpg = "image/jpeg"
  case png = "image/png"
  case doc = "application/msword"
  case ppt = "application/vnd.ms-powerpoint"
  case pdf = "application/pdf"
  case html = "text/html"
  
  init?(type: String?) {
    switch type?.lowercased() {
    case "jpg": self = .jpg
    case "png": self = .png
    case "doc": self = .doc
    case "ppt": self = .ppt
    case "html": self = .html
    case "pdf": self = .pdf
    default: return nil
    }
  }
}

