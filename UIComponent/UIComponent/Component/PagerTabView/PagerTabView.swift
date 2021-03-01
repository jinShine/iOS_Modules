//
//  PagerTabView.swift
//  Common
//
//  Created by buzz on 2021/02/27.
//

import RxCocoa
import RxSwift
import UIKit
import XLPagerTabStrip

/**
 [UI 제플린에서 보기](https://zpl.io/aR6NNe0)
 */

public class PagerTabView: UIView {
  
  public enum TabStyle {
    case main
    case details
    case filter
  }
  
  // MARK: - UI Properties

  private let rightActionButton: Button = {
    let button = Button(type: .custom)
    button.tintColor = Theme.color.black
    return button
  }()
  
  // MARK: - Properties
  
  /// Right Action Tap
  public let didTapRightAction = PublishRelay<Void>()
  
  private var tabStyle: TabStyle = .main
  
  private var buttonBarView: ButtonBarView?

  // MARK: - Initialize
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    bind()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
    bind()
  }
  
  // MARK: - Setup
  
  private func setupUI() {
    backgroundColor = Theme.color.white
  }
}

// MARK: - Binding methods

extension PagerTabView {
  
  private func bind() {
    rightActionButton.rx.tapx
      .bind(to: didTapRightAction)
      .disposed(by: rx.disposeBag)
  }
}

// MARK: - Helper methods

extension PagerTabView {
  
  public func setupPargerViewStyle(_ tabStyle: TabStyle, with buttonBarView: ButtonBarView) {
    self.tabStyle = tabStyle
    self.buttonBarView = buttonBarView
    
    switch tabStyle {
    case .main:
      setupMainStyle(with: buttonBarView)
    case .details:
      setupDetailStyle(with: buttonBarView)
    case .filter:
      setupFilterStyle(with: buttonBarView)
    }
  }
  
  public func setRightActionImage(_ image: UIImage) {
    rightActionButton.setImage(image, for: .normal)
    
    updateConstraintsTabStyle()
  }
  
  private func setupMainStyle(with buttonBarView: ButtonBarView) {
    addSubviews([buttonBarView, rightActionButton])
    buttonBarView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview()
      $0.trailing.equalTo(rightActionButton.snp.leading)
      $0.height.equalTo(UIConstants.size48)
    }
    
    rightActionButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview()
      $0.size.equalTo(UIConstants.size0)
    }
  }
  
  private func setupDetailStyle(with buttonBarView: ButtonBarView) {
    addSubviews([buttonBarView, rightActionButton])
    buttonBarView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview()
      $0.trailing.equalTo(rightActionButton.snp.leading)
      $0.height.equalTo(UIConstants.size24)
    }
    
    rightActionButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview()
      $0.size.equalTo(UIConstants.size0)
    }
  }
  
  private func setupFilterStyle(with buttonBarView: ButtonBarView) {
    addSubviews([buttonBarView, rightActionButton])
    buttonBarView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview()
      $0.trailing.equalTo(rightActionButton.snp.leading)
      $0.height.equalTo(UIConstants.size24)
    }
    
    rightActionButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview()
      $0.size.equalTo(UIConstants.size0)
    }
  }
  
  private func updateConstraintsTabStyle() {
    buttonBarView?.snp.updateConstraints {
      $0.trailing.equalTo(rightActionButton.snp.leading).offset(-UIConstants.margin10 * 2)
    }
    
    rightActionButton.snp.updateConstraints {
      $0.trailing.equalToSuperview().offset(-UIConstants.margin16)
      $0.size.equalTo(UIConstants.size24)
    }
  }
}
