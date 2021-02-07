//
//  LFRadioButton.swift
//  Common
//
//  Created by buzz on 2021/02/05.
//

import RxCocoa
import RxSwift
import UIKit
import NSObject_Rx

/**
 [UI 제플린에서 보기](https://zpl.io/VY6JWLp)
 */

public class LFRadioButton: Button {
  
  // MARK: - Properties
  
  public override var isSelected: Bool {
    didSet {
      changeRadioState(by: isSelected)
    }
  }
  
  // MARK: - Initialize
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    bind()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
    bind()
  }
  
  // MARK: - Setup
  
  private func setupUI() {
    setupDisabledImage()
    updateUI()
  }
  
  private func updateUI() {
    setNeedsDisplay()
  }
  
}

// MARK: - Binding methods

extension LFRadioButton {
  
  private func bind() {
    rx.tap
      .bind { [weak self] in self?.isSelectedToggle() }
      .disposed(by: rx.disposeBag)
  }
  
}

// MARK: - Helper methods

extension LFRadioButton {
  
  private func isSelectedToggle() {
    isSelected = !isSelected
    toggleAnimation()
  }
  
  private func changeRadioState(by isSelected: Bool) {
    isSelected ? setupSelectedImage() : setupDisabledImage()
  }
  
  private func setupSelectedImage() {
    let image = Theme.image.radioSelected.withRenderingMode(.alwaysOriginal)
    setImage(image, for: .normal)
  }
  
  private func setupDisabledImage() {
    let image = Theme.image.radioDisabled.withRenderingMode(.alwaysOriginal)
    setImage(image, for: .normal)
  }
  
  private func toggleAnimation() {
    UIView.animate(withDuration: 0.1) {
      self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    } completion: { _ in
      self.transform = .identity
    }
  }
}


