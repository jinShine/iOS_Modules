//
//  Navigator.swift
//  TestStoryboard
//
//  Created by Jinnify on 2020/07/09.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import UIKit

class Navigator {

  enum Scene {
    case movie(viewModel: MovieViewModel)
    case detail(viewModel: DetailViewModel)
    case search(viewModel: SearchViewModel)
  }
  
  func get(with name: UIStoryboard.Name, to scene: Scene) -> UIViewController {
    
    switch scene {
    case .movie(let viewModel):
      let vc = UIStoryboard.get(with: name).instantiateViewController(ofType: MovieViewController.self)
      vc.viewModel = viewModel
      vc.navigator = self
      return UINavigationController(rootViewController: vc)
    case .detail(let viewModel):
      let vc = UIStoryboard.get(with: name).instantiateViewController(ofType: DetailViewController.self)
      vc.viewModel = viewModel
      vc.navigator = self
      return vc
    case .search(let viewModel):
      let vc = UIStoryboard.get(with: name).instantiateViewController(ofType: SearchViewController.self)
      vc.viewModel = viewModel
      vc.navigator = self
      return vc
    }
  }
}

///SIngleton
extension Navigator {
  
  static let `default` = Navigator()
}
