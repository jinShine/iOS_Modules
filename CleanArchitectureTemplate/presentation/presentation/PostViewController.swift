//
//  PostViewController.swift
//  presentation
//
//  Created by Buzz.Kim on 2020/10/14.
//  Copyright © 2020 jinnify. All rights reserved.
//

import Foundation
import UIKit
import domain

public class PostViewController: UIViewController {
  
  var viewModel: PostViewModel!

  public override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  private func setupViewModel() {
    viewModel = PostViewModel(postInteractor: PostInteractor(postRepositoryProtocol: PostRepo))
  }
}
