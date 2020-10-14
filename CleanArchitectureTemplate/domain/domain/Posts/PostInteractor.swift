//
//  PostInteractor.swift
//  domain
//
//  Created by Buzz.Kim on 2020/10/11.
//  Copyright © 2020 jinnify. All rights reserved.
//

import Foundation

public protocol PostInteractorProtocol {
  func getPosts(handler: @escaping ([PostEntity]) ->())
}

public class PostInteractor: PostInteractorProtocol {
  
  let postRepositoryProtocol: PostRepositoryProtocol
  
  public init(postRepositoryProtocol: PostRepositoryProtocol) {
    self.postRepositoryProtocol = postRepositoryProtocol
  }
  
  public func getPosts(handler: @escaping ([PostEntity]) -> ()) {
    postRepositoryProtocol.getPosts {
      handler($0)
    }
  }
}
