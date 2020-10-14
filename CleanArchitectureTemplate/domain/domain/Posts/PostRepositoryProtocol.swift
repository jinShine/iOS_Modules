//
//  PostRepositoryProtocol.swift
//  domain
//
//  Created by Buzz.Kim on 2020/10/11.
//  Copyright © 2020 jinnify. All rights reserved.
//

import Foundation

public protocol PostRepositoryProtocol {
  
  func getPosts(handler: @escaping ([PostEntity]) -> ())
}
