//
//  ThirdViewController.swift
//  GoogleLoginModule
//
//  Created by Buzz.Kim on 2020/07/25.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import UIKit

class ThirdViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("ThirdViewController")
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = true
    title = "333"
  }
}
