//
//  LFCheckboxButton.swift
//  Common
//
//  Created by buzz on 2021/02/05.
//

import RxCocoa
import RxSwift
import UIKit
import NSObject_Rx

/**
 [UI 제플린에서 보기](https://zpl.io/2jglkgA)
 */

public class LFCheckboxButton: Button {
  
  // MARK: - Properties
  
  public override var isSelected: Bool {
    didSet {
      changeCheckboxState(by: isSelected)
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
    setDisabledImage()
    updateUI()
  }
  
  private func updateUI() {
    setNeedsDisplay()
  }
  
}

// MARK: - Binding methods

extension LFCheckboxButton {
  
  private func bind() {
    rx.tap
      .bind { [weak self] in self?.isSelectedToggle() }
      .disposed(by: rx.disposeBag)
  }
  
}

// MARK: - Helper methods

extension LFCheckboxButton {
  
  private func isSelectedToggle() {
    isSelected = !isSelected
    toggleAnimation()
  }
  
  private func changeCheckboxState(by isSelected: Bool) {
    isSelected ? setSelectedImage() : setDisabledImage()
  }
  
  private func setSelectedImage() {
    let image = Theme.image.checkboxSelected.withRenderingMode(.alwaysOriginal)
    setImage(image, for: .normal)
  }
  
  private func setDisabledImage() {
    let image = Theme.image.checkboxDisabled.withRenderingMode(.alwaysOriginal)
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
