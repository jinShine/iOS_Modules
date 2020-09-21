//
//  LottieAnimationView.swift
//  LottieModule
//
//  Created by Jinnify on 2020/09/22.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import Foundation
import Lottie

class LottieAnimationView: UIView {
  
  // MARK: - Constant
  
  enum AnimationStatus {
    case play
    case stop
    case pause
    case none
  }
  
  // MARK: - UI Properties
  
  private lazy var animationView: AnimationView = {
    let animationView = AnimationView()
    animationView.translatesAutoresizingMaskIntoConstraints = false
    animationView.contentMode = .scaleAspectFit
    return animationView
    
  }()
  
  private var animation: Animation!
  
  // MARK: - Properties
  
  private var animationStatus: AnimationStatus = .none
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(animationView)
    animationView.clipsToBounds = false
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    addSubview(animationView)
    animationView.clipsToBounds = false
    
    
    NotificationCenter.default.addObserver(self, selector: #selector(LottieAnimationView.willEnterForegroundNotification) , name: UIApplication.willEnterForegroundNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(LottieAnimationView.didEnterBackgroundNotification) , name: UIApplication.didEnterBackgroundNotification, object: nil)
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setConstraint()
    
  }
  override class func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  @objc private func willEnterForegroundNotification() {
    print("willEnterForegroundNotification")
    
  }
  
  @objc private func didEnterBackgroundNotification() {
    print("didEnterBackgroundNotification")
  }
  
  func setup(animationName: String, loopMode: LottieLoopMode = .loop) {
    self.animation = Animation.named(animationName)
    animationView.loopMode = loopMode
  }
  
  
  func playAnimation(completion:(() -> Void)? = nil) {
    animationStatus = .play
    animationView.animation = self.animation
    animationView.play { (bool) in
      completion?()
    }
  }
  
  func pauseAnimation(completion:(() -> Void)? = nil) {
    animationStatus = .pause
    self.animationView.pause()
    completion?()
  }
  
  func stopAnimation(completion:(() -> Void)? = nil) {
    animationStatus = .stop
    self.animationView.stop()
    completion?()
  }
  
  
  fileprivate func setConstraint() {
    let animationViewConstraint: [NSLayoutConstraint] =
      [animationView.topAnchor.constraint(equalTo: topAnchor),
       animationView.bottomAnchor.constraint(equalTo: bottomAnchor),
       animationView.leadingAnchor.constraint(equalTo: leadingAnchor),
       animationView.trailingAnchor.constraint(equalTo: trailingAnchor)]
    
    NSLayoutConstraint.activate(animationViewConstraint)
  }
  
}

