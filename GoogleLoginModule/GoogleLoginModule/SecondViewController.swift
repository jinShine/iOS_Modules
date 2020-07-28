//
//  SecondViewController.swift
//  GoogleLoginModule
//
//  Created by Buzz.Kim on 2020/07/25.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import UIKit

class SecondViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("SecondViewController")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    title = "222"
  }
}
