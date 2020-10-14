//
//  PostEntity.swift
//  domain
//
//  Created by Buzz.Kim on 2020/10/11.
//  Copyright © 2020 jinnify. All rights reserved.
//

import Foundation

public struct PostEntity: Identifiable {
  public let userId: Int?
  public let id: Int?
  public let title: String?
  public let body: String
  
  public init(userId: Int?, id: Int?, title: String, body: String) {
    self.userId = userId
    self.id = id
    self.title = title
    self.body = body
  }
}
