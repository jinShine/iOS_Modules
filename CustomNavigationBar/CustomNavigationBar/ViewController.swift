//
//  ViewController.swift
//  CustomNavigationBar
//
//  Created by Buzz.Kim on 2020/11/08.
//  Copyright © 2020 jinnify. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "네비게이션 바"

    customNavigationBar()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationItem.largeTitleDisplayMode = .always
    
  }

  private func customNavigationBar() {
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.largeTitleTextAttributes = [
      .foregroundColor: UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0),
      .font: UIFont.systemFont(ofSize: 50, weight: .light)
    ]
    
  }

  private func setupUI() {
    interactivePopGestureRecognizer?.delegate = self

    let navigationBarAppearance = UINavigationBar.appearance()
    navigationBarAppearance.isTranslucent = false
    navigationBarAppearance.tintColor = Theme.color.black
    navigationBarAppearance.setBackgroundImage(UIImage(), for: .default)
    navigationBarAppearance.shadowImage = UIImage()

    let backArrowImage = Theme.image.backArrow.withAlignmentRectInsets(
      UIEdgeInsets(top: 0, left: -Constants.margin8, bottom: 0, right: 0)
    )
    navigationBarAppearance.backIndicatorImage = backArrowImage
    navigationBarAppearance.backIndicatorTransitionMaskImage = backArrowImage
    UIBarButtonItem.appearance().setTitleTextAttributes(
      [.foregroundColor: UIColor.clear], for: .normal
    )
    UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(
      UIOffset(horizontal: -1000, vertical: 0), for: UIBarMetrics.default
    )

    navigationBar.titleTextAttributes = [
      .foregroundColor: Theme.color.black,
      .font: Theme.font.body2Regular
    ]

    navigationBar.largeTitleTextAttributes = [
      .foregroundColor: Theme.color.black,
      .font: Theme.font.heading5Bold
    ]
  }

}


