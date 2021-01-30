//
//  CheckboxButton.swift
//  Common
//
//  Created by buzz on 2021/01/27.
//

import RxCocoa
import RxSwift
import UIKit
import NSObject_Rx

public class CheckboxButton: UIButton {
  
  public override var isSelected: Bool {
    didSet {
      changeCheckboxState(by: isSelected)
    }
  }
  
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
  
  private func setupUI() {
    isUserInteractionEnabled = true
    
    setDisabledImage()
    updateUI()
  }
  
  private func updateUI() {
    setNeedsDisplay()
  }
  
  private func bind() {
    rx.tap
      .bind { [weak self] in self?.isSelectedToggle() }
      .disposed(by: rx.disposeBag)
  }
}

extension CheckboxButton {
  
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
