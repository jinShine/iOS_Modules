//
//  ViewController.swift
//  GoogleLoginModule
//
//  Created by Jinnify on 2020/07/16.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.prefersLargeTitles = true
    title = "111"
  }


}

