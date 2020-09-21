//
//  ViewController.swift
//  LottieModule
//
//  Created by Jinnify on 2020/09/21.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit
import Lottie

class ViewController: UIViewController {
  
  let lottieAnimationView = LottieAnimationView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .blue
    
    setupLottie()
    play()
  }
  
  private func setupLottie() {
    view.addSubview(lottieAnimationView)
    lottieAnimationView.setup(animationName: "components_loading", loopMode: .loop)
    lottieAnimationView.frame = view.frame
  }
  
  private func play() {
    lottieAnimationView.playAnimation()
  }
  
  
}

