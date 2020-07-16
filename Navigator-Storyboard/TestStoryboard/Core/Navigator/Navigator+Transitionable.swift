//
//  Navigator+Transitionable.swift
//  TestStoryboard
//
//  Created by Buzz.Kim on 2020/07/10.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import UIKit

protocol Transitionable {

  func pop(sender: UIViewController?, toRoot: Bool, animated: Bool)
  func dismiss(sender: UIViewController, animated: Bool, completion: (() -> Void)?)
  func show(name: UIStoryboard.Name, scene: Navigator.Scene, sender: UIViewController?, animated: Bool, completion: (() -> Void)?)
  func push(name: UIStoryboard.Name, scene: Navigator.Scene, sender: UINavigationController?, animated: Bool)
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

  func show(name: UIStoryboard.Name,
            scene: Scene,
            sender: UIViewController?,
            animated: Bool,
            completion: (() -> Void)? = nil) {
    DispatchQueue.main.async {
      let vc = self.get(with: name, to: scene)
      vc.modalTransitionStyle = .crossDissolve
      vc.modalPresentationStyle = .fullScreen
      sender?.present(vc, animated: true, completion: completion)
    }
  }

  func push(name: UIStoryboard.Name,
            scene: Scene,
            sender: UINavigationController?,
            animated: Bool) {
    sender?.pushViewController(get(with: name, to: scene), animated: animated)
  }

}
