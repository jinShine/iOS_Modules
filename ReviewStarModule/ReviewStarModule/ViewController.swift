//
//  ViewController.swift
//  ReviewStarModule
//
//  Created by buzz on 2021/08/05.
//

import UIKit

class ViewController: UIViewController {

  let reviewStarView = LFReviewStarView().then {
    $0.backgroundColor = Theme.color.lightGray
    $0.layer.cornerRadius = Constants.size8
    $0.layer.masksToBounds = true
    $0.style = .purple
    $0.rating = 0
    $0.settings.fillMode = .full
    $0.settings.starSize = Double(Constants.size32)
    $0.settings.starMargin = Double(Constants.margin10)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

  }
}

