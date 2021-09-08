//
//  LFCheckboxButton.swift
//  Common
//
//  Created by buzz on 2021/02/05.
//

import NSObject_Rx
import RxCocoa
import RxSwift
import UIKit

/**
 [UI 제플린에서 보기](https://zpl.io/2jglkgA)
 */

public class LFCheckboxButton: Button {

  // MARK: - Style

  public enum LFCheckboxType {
    case rectangle
    case circle

    var size: CGFloat {
      switch self {
      case .rectangle:
        return 18
      case .circle:
        return 24
      }
    }
  }

  // MARK: - Properties

  public lazy var type: LFCheckboxType = .rectangle {
    didSet {
      changeImage(for: type)
      updateSize(type.size)
    }
  }

  // MARK: - Initialize

  public init(type checkboxType: LFCheckboxType) {
    super.init(frame: .zero)
    type = checkboxType
    setupUI()
    setupConstraints()
    bind()
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupConstraints()
    bind()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
    setupConstraints()
    bind()
  }

  // MARK: - Setup

  private func setupUI() {
    changeImage(for: type)
  }

  private func setupConstraints() {
    self.snp.makeConstraints {
      $0.size.equalTo(type.size)
    }
  }
}

// MARK: - Binding methods

extension LFCheckboxButton {

  private func bind() {
    rx.tap
      .bind { [weak self] in
        self?.isSelectedToggle {
          self?.toggleAnimation()
        }
      }.disposed(by: rx.disposeBag)
  }
}

// MARK: - Helper methods

extension LFCheckboxButton {

  public func updateSize(_ size: CGFloat) {
    self.snp.updateConstraints {
      $0.size.equalTo(size)
    }
  }

  private func changeImage(for type: LFCheckboxType) {
    var selectedImage: UIImage?
    var unselectedImage: UIImage?

    switch type {
    case .rectangle:
      selectedImage = Theme.image.checkboxSelected.withRenderingMode(.alwaysOriginal)
      unselectedImage = Theme.image.checkboxDisabled.withRenderingMode(.alwaysOriginal)

    case .circle:
      selectedImage = Theme.image.checkboxCircleSelected.withRenderingMode(.alwaysOriginal)
      unselectedImage = Theme.image.checkboxCircleDisabled.withRenderingMode(.alwaysOriginal)
    }

    setImage(unselectedImage, for: .normal)
    setImage(selectedImage, for: .selected)
  }

  private func isSelectedToggle(completion: @escaping () -> Void) {
    isSelected = !isSelected
    completion()
  }

  private func toggleAnimation() {
    UIView.animate(withDuration: Constants.Animation.duration) {
      self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    } completion: { _ in
      self.transform = .identity
    }
  }
}
