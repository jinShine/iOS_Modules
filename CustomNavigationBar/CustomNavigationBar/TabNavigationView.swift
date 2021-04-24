//
//  TabNavigationView.swift
//  CustomNavigationBar
//
//  Created by buzz on 2021/04/25.
//  Copyright © 2021 jinnify. All rights reserved.
//

import UIKit

/**
 [UI 제플린에서 보기](https://zpl.io/bP6rdyD)
 */

public class TabNavigationView: UIView {

  // MARK: - Constant

  private enum Constant {
    static let largeHeight: CGFloat = 88
    static let smallHeight: CGFloat = 56
    static let animateDuration: TimeInterval = 0.33
  }

  // MARK: - UI Properties

  public let titleLabel: Label = {
    let label = Label()
    label.font = Theme.font.heading5Bold
    label.textColor = Theme.color.black
    label.textAlignment = .left
    return label
  }()

  public let subButton: Button = {
    let button = Button()
    button.tintColor = Theme.color.black
    return button
  }()

  public let rightButton: Button = {
    let button = Button()
    button.tintColor = Theme.color.black
    button.setTitleColor(Theme.color.black, for: .normal)
    button.titleLabel?.font = Theme.font.heading6Bold
    return button
  }()

  // MARK: - Properties

  private var lastScrollViewVelocityY = 0

  // MARK: - Initialize

  override public init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupConstraints()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
    setupConstraints()
  }

  // MARK: - Setup

  private func setupUI() {
    backgroundColor = Theme.color.white
    addSubviews([titleLabel, subButton, rightButton])
    updateUI()
  }

  private func setupConstraints() {
    snp.makeConstraints {
      $0.height.equalTo(Constant.largeHeight)
    }

    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(Constants.margin16)
      $0.bottom.equalToSuperview().offset(-Constants.margin24)
    }

    subButton.snp.makeConstraints {
      $0.size.equalTo(Constants.size40)
      $0.centerY.equalTo(titleLabel)
      $0.trailing.equalTo(rightButton.snp.leading).offset(-Constants.margin4)
    }

    rightButton.snp.makeConstraints {
      $0.width.greaterThanOrEqualTo(Constants.size40)
      $0.height.equalTo(Constants.size40)
      $0.trailing.equalToSuperview().offset(-Constants.margin8)
      $0.centerY.equalTo(titleLabel)
    }
  }

  private func updateUI() {
    setNeedsDisplay()
  }
}

extension TabNavigationView {

  public func animate(by scrollView: UIScrollView) {
    let scrollViewVelocityY = scrollView.panGestureRecognizer.velocity(in: scrollView).y
    let currentVelocityY = Int(scrollViewVelocityY).signum()

    if currentVelocityY != lastScrollViewVelocityY && currentVelocityY != 0 {
      lastScrollViewVelocityY = currentVelocityY
    }

    if lastScrollViewVelocityY < 0 {
      // DOWN
      updateWhenScrollDown()
    } else {
      // UP
      updateWhenScrollUp()
    }

    UIView.animate(withDuration: Constant.animateDuration) {
      self.superview?.layoutIfNeeded()
    }
  }

  private func updateWhenScrollDown() {
    snp.updateConstraints {
      $0.height.equalTo(Constant.smallHeight)
    }

    titleLabel.snp.updateConstraints {
      $0.leading.equalToSuperview().offset(Constants.margin10)
      $0.bottom.equalToSuperview().offset(-13)
    }

    UIView.animate(withDuration: Constant.animateDuration) {
      self.titleLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }
  }

  private func updateWhenScrollUp() {
    snp.updateConstraints {
      $0.height.equalTo(Constant.largeHeight)
    }

    titleLabel.snp.updateConstraints {
      $0.leading.equalToSuperview().offset(Constants.margin16)
      $0.bottom.equalToSuperview().offset(-Constants.margin24)
    }

    UIView.animate(withDuration: Constant.animateDuration) {
      self.titleLabel.transform = .identity
    }
  }
}
