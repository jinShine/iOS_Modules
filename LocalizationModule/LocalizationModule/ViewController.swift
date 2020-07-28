//
//  ViewController.swift
//  LocalizationModule
//
//  Created by Buzz.Kim on 2020/07/28.
//  Copyright © 2020 jinnify. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var titleLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleLabel.text = I18N.edit
  }


}

extension String {
  var localized: String {
    return NSLocalizedString(self, comment: "")
  }
}
