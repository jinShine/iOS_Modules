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
  
  func get(with storyboard: UIStoryboard, to scene: Scene) -> UIViewController {
    
    switch scene {
    case .movie(let viewModel):
      let vc = storyboard.instantiateViewController(ofType: MovieViewController.self)
      vc.viewModel = viewModel
      vc.navigator = self
      return UINavigationController(rootViewController: vc)
    case .detail(let viewModel):
      let vc = storyboard.instantiateViewController(ofType: DetailViewController.self)
      
      vc.viewModel = viewModel
      vc.navigator = self
      return vc
    case .search(let viewModel):
      let vc = storyboard.instantiateViewController(ofType: SearchViewController.self)
      
      vc.viewModel = viewModel
      vc.navigator = self
      return vc
    }
  }
}

extension Navigator {
  
  static let `default` = Navigator()
}

protocol Transitionable {

  func pop(sender: UIViewController?, toRoot: Bool, animated: Bool)
  func dismiss(sender: UIViewController, animated: Bool, completion: (() -> Void)?)
  func show(storyboard: UIStoryboard, scene: Navigator.Scene, sender: UIViewController?, animated: Bool, completion: (() -> Void)?)
  func push(storyboard: UIStoryboard, scene: Navigator.Scene, sender: UINavigationController?, animated: Bool)
}


//MARK:- Transition
extension Navigator: Transitionable {

  func pop(sender: UIViewController?, toRoot: Bool = false, animated: Bool) {
    if toRoot {
      sender?.navigationController?.popToRootViewController(animated: animated)
    } else {
      sender?.navigationController?.popViewController(animated: animated)
    }
  }

  func dismiss(sender: UIViewController,
               animated: Bool,
               completion: (() -> Void)? = nil) {
    sender.dismiss(animated: animated, completion: completion)
  }

  func show(storyboard: UIStoryboard,
            scene: Scene,
            sender: UIViewController?,
            animated: Bool,
            completion: (() -> Void)? = nil) {
    DispatchQueue.main.async {
      let vc = self.get(with: storyboard, to: scene)
      vc.modalTransitionStyle = .crossDissolve
      vc.modalPresentationStyle = .fullScreen
      sender?.present(vc, animated: true, completion: completion)
    }
  }

  func push(storyboard: UIStoryboard,
            scene: Scene,
            sender: UINavigationController?,
            animated: Bool) {
    sender?.pushViewController(get(with: storyboard, to: scene), animated: animated)
  }

}


extension UIStoryboard {
  func instantiateViewController<T>(ofType type: T.Type) -> T {
    return instantiateViewController(withIdentifier: String(describing: type)) as! T
  }
}
