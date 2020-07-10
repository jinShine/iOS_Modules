//
//  UIStoryboard+Navigator.swift
//  TestStoryboard
//
//  Created by Buzz.Kim on 2020/07/10.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
  
  enum Name {
    case main
    case search
  }
  
  static func get(with name: UIStoryboard.Name) -> UIStoryboard {
    switch name {
    case .main: return UIStoryboard(name: "Main", bundle: nil)
    case .search: return UIStoryboard(name: "Search", bundle: nil)
    }
  }

  func instantiateViewController<T>(ofType type: T.Type) -> T {
    return instantiateViewController(withIdentifier: String(describing: type)) as! T
  }
  
}
