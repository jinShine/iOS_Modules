//
//  PostViewModel.swift
//  presentation
//
//  Created by Buzz.Kim on 2020/10/14.
//  Copyright © 2020 jinnify. All rights reserved.
//

import Foundation
import domain

public class PostViewModel {
  
  var posts: [PostEntity] = []
  
  private var postInteractor: PostInteractorProtocol
  
  public init(postInteractor: PostInteractorProtocol) {
    self.postInteractor = postInteractor
  }
  
  func getPosts() {
    postInteractor.getPosts { [weak self] postList in
      DispatchQueue.main.async {
        self?.posts = postList
      }
    }
  }
  
}
