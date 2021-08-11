//
//  PopTipMessageView.swift
//  PopTipMessageViewModule
//
//  Created by buzz on 2021/08/11.
//

import RxCocoa
import RxSwift
import UIKit

/**
 [UI 제플린에서 보기](https://zpl.io/a3EgvxQ)
 [UI 제플린에서 보기](https://zpl.io/bWyQdm1)
 */

public class PopTipMessageView: UIView {

  // MARK: - Constant

  public enum PopTipDirection {
    case up
    case down
    case left
    case right
  }

  // MARK: - UI Properties

  private let tailImageView = ImageView()

  // Container
  private lazy var textLabel = Label().then {
    $0.layer.cornerRadius = Constants.size4
    $0.layer.masksToBounds = true
    $0.numberOfLines = 0
    $0.font = Theme.font.caption1Bold
    $0.textAlignment = .center
    $0.textColor = Theme.color.ttGray090
    $0.backgroundColor = Theme.color.black
    $0.insets = .init(
      top: Constants.margin4,
      left: Constants.margin8,
      bottom: Constants.margin4,
      right: Constants.margin8
    )
  }

  // MARK: - Properties

  private var target: UIViewController?
  private var inView: UIView?
  private var direction: PopTipDirection = .up
  private var directionMargin: CGFloat?
  private var width: CGFloat?
  private var height: CGFloat?
  private var leadingInset: CGFloat?
  private var trailingInset: CGFloat?
  private var topInset: CGFloat?
  private var bottomInset: CGFloat?

  public var text: String? {
    didSet { textLabel.text = text }
  }

  public var cornerRadius: CGFloat = Constants.size4 {
    didSet { textLabel.layer.cornerRadius = cornerRadius }
  }

  public var font: UIFont = Theme.font.caption1Bold {
    didSet { textLabel.font = font }
  }

  public var insets: UIEdgeInsets = .zero {
    didSet { textLabel.insets = insets }
  }

  override public var backgroundColor: UIColor? {
    didSet {
      textLabel.backgroundColor = backgroundColor
      tailImageView.tintColor = backgroundColor
      tailImageView.image = tailImageView.image?.withTintColor(
        backgroundColor ?? Theme.color.black,
        renderingMode: .alwaysTemplate
      )
    }
  }

  public let tap = PublishRelay<LFPopTipView>()

  // MARK: - Initialize

  override public init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    bind()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  // MARK: - Setup

  private func setupUI() {
    addSubviews([tailImageView, textLabel])
  }

  private func bind() {
    rx.tapGesture().mapToVoid()
      .map { _ in self }
      .bind(to: tap)
      .disposed(by: rx.disposeBag)
  }

  public func setup(
    target: UIViewController,
    inView: UIView,
    direction: PopTipMessageView.PopTipDirection,
    directionMargin: CGFloat = Constants.margin6,
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    leadingInset: CGFloat? = nil,
    trailingInset: CGFloat? = nil,
    topInset: CGFloat? = nil,
    bottomInset: CGFloat? = nil
  ) {
    self.target = target
    self.inView = inView
    self.direction = direction
    self.directionMargin = directionMargin
    self.width = width
    self.height = height
    self.leadingInset = leadingInset
    self.trailingInset = trailingInset
    self.topInset = topInset
    self.bottomInset = bottomInset

    target.view.addSubview(self)
    target.view.bringSubviewToFront(self)

    switch direction {
    case .up:
      setUp()
    case .down:
      setDown()
    case .left:
      setLeft()
    case .right:
      setRight()
    }
  }
}

// MARK: - Helper methods

extension PopTipMessageView {

  // MARK: Public

  public func show(message: String) {
    textLabel.text = message
  }

  public func hide() {
    removeFromSuperview()
  }

  // MARK: Private

  private func setUp() {
    guard let target = target,
          let inView = inView,
          let directionMargin = directionMargin else { return }

    tailImageView.image = Theme.image.popupTailUp

    snp.makeConstraints {
      $0.top.equalTo(inView.snp.bottom).offset(directionMargin)
      if let width = width { $0.width.equalTo(width) }
      if let height = height { $0.height.equalTo(height) }
      if let leading = leadingInset { $0.leading.equalTo(target.view).inset(leading) }
      if let trailing = trailingInset { $0.trailing.equalTo(target.view).inset(trailing) }
      if let bottom = bottomInset { $0.bottom.equalTo(target.view).inset(bottom) }
      if let top = topInset { $0.top.equalTo(target.view).inset(top) }
    }

    tailImageView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.centerX.equalTo(inView)
      $0.width.equalTo(Constants.size8)
      $0.height.equalTo(Constants.size5)
    }

    textLabel.snp.makeConstraints {
      $0.top.equalTo(tailImageView.snp.bottom)
      $0.centerX.equalTo(inView).priority(.low)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }

  private func setDown() {
    guard let target = target,
          let inView = inView,
          let directionMargin = directionMargin else { return }

    tailImageView.image = Theme.image.popupTailDown

    snp.makeConstraints {
      $0.bottom.equalTo(inView.snp.top).offset(-directionMargin)
      if let width = width { $0.width.equalTo(width) }
      if let height = height { $0.height.equalTo(height) }
      if let leading = leadingInset { $0.leading.equalTo(target.view).inset(leading) }
      if let trailing = trailingInset { $0.trailing.equalTo(target.view).inset(trailing) }
      if let bottom = bottomInset { $0.bottom.equalTo(target.view).inset(bottom) }
      if let top = topInset { $0.top.equalTo(target.view).inset(top) }
    }

    tailImageView.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.centerX.equalTo(inView)
      $0.width.equalTo(Constants.size8)
      $0.height.equalTo(Constants.size5)
    }

    textLabel.snp.makeConstraints {
      $0.bottom.equalTo(tailImageView.snp.top)
      $0.centerX.equalTo(inView).priority(.low)
      $0.leading.trailing.top.equalToSuperview()
    }
  }

  private func setLeft() {
    guard let target = target,
          let inView = inView,
          let directionMargin = directionMargin else { return }

    tailImageView.image = Theme.image.popupTailLeft

    snp.makeConstraints {
      $0.leading.equalTo(inView.snp.trailing).offset(directionMargin)
      if let width = width { $0.width.equalTo(width) }
      if let height = height { $0.height.equalTo(height) }
      if let leading = leadingInset { $0.leading.equalTo(target.view).inset(leading) }
      if let trailing = trailingInset { $0.trailing.equalTo(target.view).inset(trailing) }
      if let bottom = bottomInset { $0.bottom.equalTo(target.view).inset(bottom) }
      if let top = topInset { $0.top.equalTo(target.view).inset(top) }
    }

    tailImageView.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.centerY.equalTo(inView)
      $0.width.equalTo(Constants.size5)
      $0.height.equalTo(Constants.size8)
    }

    textLabel.snp.makeConstraints {
      $0.leading.equalTo(tailImageView.snp.trailing)
      $0.centerY.equalTo(inView).priority(.low)
      $0.top.bottom.trailing.equalToSuperview()
    }
  }

  private func setRight() {
    guard let target = target,
          let inView = inView,
          let directionMargin = directionMargin else { return }

    tailImageView.image = Theme.image.popupTailRight

    snp.makeConstraints {
      $0.trailing.equalTo(inView.snp.leading).offset(-directionMargin)
      if let width = width { $0.width.equalTo(width) }
      if let height = height { $0.height.equalTo(height) }
      if let leading = leadingInset { $0.leading.equalTo(target.view).inset(leading) }
      if let trailing = trailingInset { $0.trailing.equalTo(target.view).inset(trailing) }
      if let bottom = bottomInset { $0.bottom.equalTo(target.view).inset(bottom) }
      if let top = topInset { $0.top.equalTo(target.view).inset(top) }
    }

    tailImageView.snp.makeConstraints {
      $0.trailing.equalToSuperview()
      $0.centerY.equalTo(inView)
      $0.width.equalTo(Constants.size5)
      $0.height.equalTo(Constants.size8)
    }

    textLabel.snp.makeConstraints {
      $0.trailing.equalTo(tailImageView.snp.leading)
      $0.centerY.equalTo(inView).priority(.low)
      $0.top.bottom.leading.equalToSuperview()
    }
  }
}
