//
//  LFTextFieldView.swift
//  Common
//
//  Created by buzz on 2021/03/08.
//

import UIKit

/**
 [UI 제플린에서 보기](https://zpl.io/2pw0d8E)
 */

public class LFTextFieldView: UIView {

  // MARK: - Constant

  private enum Metric {
    static let cornerRadius: CGFloat = 6
    static let borderWidth: CGFloat = 1.5
  }

  public enum LFTextFieldStyle {
    case normal
    case focused
    case success
    case warning
    case error
    case disabled
  }

  // MARK: - UI Properties

  private let placeholderLabel: Label = {
    let label = Label()
    label.backgroundColor = Theme.color.white
    label.textColor = Theme.color.ttGray030
    label.font = Theme.font.heading6Regular
    label.layer.cornerRadius = UIConstants.size7
    label.layer.masksToBounds = true
    return label
  }()

  private lazy var containerStackView: StackView = {
    let stackView = StackView(arrangedSubviews: [textFieldContainerView, optionContainerView])
    stackView.axis = .vertical
    stackView.distribution = .fill
    return stackView
  }()

  // Container (TextField, closeButton)
  private lazy var textFieldContainerView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = Metric.cornerRadius
    view.layer.borderWidth = Metric.borderWidth
    view.layer.borderColor = Theme.color.ttGray090.cgColor
    view.addSubviews([textField, closeButton])
    return view
  }()

  private lazy var optionContainerView: UIView = {
    let view = UIView()
    view.addSubview(messageLabel)
    return view
  }()

  private let messageLabel: Label = {
    let label = Label()
    label.font = Theme.font.caption1Regular
    label.textColor = Theme.color.ttGray010
    return label
  }()

  private let closeButton: Button = {
    let button = Button()
    button.setImage(Theme.image.close24, for: .normal)
    button.tintColor = Theme.color.ttGray070
    button.isHidden = true
    return button
  }()

  private let passwordVisibilityButton: Button = {
    let button = Button()
    button.setImage(Theme.image.watchDisabled, for: .normal)
    button.tintColor = Theme.color.ttGray070
    return button
  }()

  public lazy var textField: TextField = {
    let textField = TextField()
    textField.delegate = self
    return textField
  }()

  public var rightButton: Button? {
    didSet {
      setupRightButton()
    }
  }

  // MARK: - Properties

  /// 마지막 style 저장
  private var lastSavedStyle: LFTextFieldStyle = .normal

  /// LFTextField 스타일
  public var style: LFTextFieldStyle = .normal {
    didSet {
      lastSavedStyle = style
      updateStyle(style)
    }
  }

  /// placeholder
  public var placeholder: String {
    get {
      placeholderLabel.text ?? ""
    }
    set {
      textField.placeholder = ""
      placeholderLabel.text = newValue
    }
  }

  /// 하단에 에러,상태 등 설명을 나타내는 메세지
  public var message: String = "" {
    didSet {
      updateStyle(style)
      messageLabel.text = message
      message.isEmpty ? hideMessage() : showMessage()
    }
  }

  public var isSecureTextEntry: Bool = false {
    didSet {
      textField.isSecureTextEntry = true
      setupPasswordVisibilityButton()
    }
  }

  // MARK: - Initialize

  public override init(frame: CGRect) {
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
    isUserInteractionEnabled = true
    addSubviews([containerStackView, placeholderLabel])
  }

  private func setupConstraints() {
    placeholderLabel.snp.makeConstraints {
      $0.leading.trailing.equalTo(textField)
      $0.size.equalTo(textField)
      $0.center.equalTo(textField)
    }

    containerStackView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.bottom.equalToSuperview()
    }

    textFieldContainerView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(UIConstants.size56)
    }

    textField.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(UIConstants.margin16)
      $0.trailing.equalToSuperview().offset(-UIConstants.margin10 * 7)
      $0.centerY.equalToSuperview()
    }

    closeButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-UIConstants.margin8)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(UIConstants.size24)
    }

    optionContainerView.snp.makeConstraints {
      $0.top.equalTo(textFieldContainerView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(UIConstants.size0)
    }

    messageLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(UIConstants.margin7 * 2)
      $0.trailing.equalToSuperview().offset(-UIConstants.margin32)
    }
  }
}

// MARK: - Binding methods

extension LFTextFieldView {

  private func bind() {
    textField.rx.controlEvent(.editingDidBegin)
      .subscribe(onNext: { [weak self] in
        self?.setupFocused()
      }).disposed(by: rx.disposeBag)

    textField.rx.controlEvent(.editingDidEnd)
      .subscribe(onNext: { [weak self] in
        self?.setupUnfocused()
      }).disposed(by: rx.disposeBag)

    closeButton.rx.tap
      .filter { self.rightButton == nil && self.isSecureTextEntry == false }
      .subscribe(onNext: { [weak self] in
        self?.reset()
      }).disposed(by: rx.disposeBag)

    passwordVisibilityButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.togglePasswordVisibility()
      }).disposed(by: rx.disposeBag)
  }
}

// MARK: - Helper methods

extension LFTextFieldView {

  private func setupFocused() {
    style = .focused
    showCloseButton()
    updatePlaceholderWhenFocused()
  }

  private func setupUnfocused() {
    if lastSavedStyle == .focused {
      style = .normal
    } else {
      style = lastSavedStyle
    }
    hideCloseButton()
    updatePlaceholderWhenUnfocused()
  }

  private func showCloseButton() {
    guard rightButton == nil && isSecureTextEntry == false else { return }
    closeButton.isHidden = false
  }

  private func hideCloseButton() {
    guard rightButton == nil && isSecureTextEntry == false else { return }
    closeButton.isHidden = true
  }

  private func updatePlaceholderWhenFocused() {
    placeholderLabel.insets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    placeholderLabel.textColor = Theme.color.ttGray010
    placeholderLabel.font = Theme.font.caption2Bold

    placeholderLabel.snp.remakeConstraints {
      $0.top.equalToSuperview().offset(-UIConstants.margin7)
      $0.leading.equalToSuperview().offset(UIConstants.margin6)
      $0.height.equalTo(UIConstants.margin7 * 2)
    }

    update(withDuration: UIConstants.Animation.duration)
  }

  private func updatePlaceholderWhenUnfocused() {
    guard isTextEmpty() else { return }

    placeholderLabel.insets = UIEdgeInsets.zero
    placeholderLabel.textColor = Theme.color.ttGray030
    placeholderLabel.font = Theme.font.heading6Regular

    placeholderLabel.snp.remakeConstraints {
      $0.leading.trailing.equalTo(textField)
      $0.size.equalTo(textField)
      $0.center.equalTo(textField)
    }

    update(withDuration: UIConstants.Animation.duration)
  }

  private func update(withDuration: TimeInterval) {
    UIView.animate(withDuration: withDuration) {
      self.layoutIfNeeded()
    }
  }

  private func isTextEmpty() -> Bool {
    guard let text = textField.text else { return false }
    return text.isEmpty
  }

  private func updateStyle(_ style: LFTextFieldStyle) {
    switch style {
    case .normal: setupNormalStyle()
    case .focused: setupFocusedStyle()
    case .success: setupSuccessStyle()
    case .warning: setupWarningStyle()
    case .error: setupErrorStyle()
    case .disabled: setupDisabledStyle()
    }
  }

  private func setupNormalStyle() {
    isUserInteractionEnabled = true
    textFieldContainerView.backgroundColor = Theme.color.white
    placeholderLabel.textColor = Theme.color.ttGray030
    textFieldContainerView.layer.borderColor = Theme.color.ttGray090.cgColor
    messageLabel.textColor = Theme.color.ttGray010
  }

  private func setupFocusedStyle() {
    isUserInteractionEnabled = true
    textFieldContainerView.backgroundColor = Theme.color.white
    placeholderLabel.textColor = Theme.color.ttGray010
    textFieldContainerView.layer.borderColor = Theme.color.black.cgColor
    messageLabel.textColor = Theme.color.ttGray010
  }

  private func setupSuccessStyle() {
    isUserInteractionEnabled = true
    textFieldContainerView.backgroundColor = Theme.color.white
    placeholderLabel.textColor = Theme.color.green
    textFieldContainerView.layer.borderColor = Theme.color.green.cgColor
    messageLabel.textColor = Theme.color.green
  }

  private func setupWarningStyle() {
    isUserInteractionEnabled = true
    textFieldContainerView.backgroundColor = Theme.color.white
    placeholderLabel.textColor = Theme.color.yellow
    textFieldContainerView.layer.borderColor = Theme.color.yellow.cgColor
    messageLabel.textColor = Theme.color.yellow
  }

  private func setupErrorStyle() {
    isUserInteractionEnabled = true
    textFieldContainerView.backgroundColor = Theme.color.white
    placeholderLabel.textColor = Theme.color.orange
    textFieldContainerView.layer.borderColor = Theme.color.orange.cgColor
    messageLabel.textColor = Theme.color.orange
  }

  private func setupDisabledStyle() {
    isUserInteractionEnabled = false
    textFieldContainerView.backgroundColor = Theme.color.lightGray
    placeholderLabel.textColor = Theme.color.ttGray030
    textFieldContainerView.layer.borderColor = Theme.color.ttGray090.cgColor
    messageLabel.textColor = Theme.color.ttGray030
  }

  private func setupRightButton() {
    guard let rightButton = rightButton else { return }
    textFieldContainerView.addSubview(rightButton)

    if rightButton.currentImage == nil {
      rightButton.snp.makeConstraints {
        $0.leading.equalTo(textField.snp.trailing).offset(UIConstants.margin8)
        $0.trailing.equalToSuperview().offset(-UIConstants.margin8)
        $0.centerY.equalToSuperview()
      }
    } else {
      rightButton.snp.makeConstraints {
        $0.trailing.equalToSuperview().offset(-UIConstants.margin8)
        $0.centerY.equalToSuperview()
        $0.size.equalTo(UIConstants.size24)
      }
    }
  }

  private func setupPasswordVisibilityButton() {
    textFieldContainerView.addSubview(passwordVisibilityButton)

    passwordVisibilityButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-UIConstants.margin8)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(UIConstants.size24)
    }
  }

  private func togglePasswordVisibility() {
    textField.isSecureTextEntry = !textField.isSecureTextEntry

    if textField.isSecureTextEntry {
      passwordVisibilityButton.setImage(Theme.image.watchDisabled, for: .normal)
      passwordVisibilityButton.tintColor = Theme.color.ttGray070
    } else {
      passwordVisibilityButton.setImage(Theme.image.watchEnabled, for: .normal)
      passwordVisibilityButton.tintColor = Theme.color.purple
    }
  }

  public func showMessage() {
    optionContainerView.isHidden = false
    optionContainerView.snp.updateConstraints {
      $0.height.equalTo(26)
    }
  }

  public func hideMessage() {
    optionContainerView.isHidden = true
    optionContainerView.snp.updateConstraints {
      $0.height.equalTo(UIConstants.size0)
    }
  }

  public func reset() {
    textField.text = nil
  }
}

// MARK: - UITextField delegate

extension LFTextFieldView: UITextFieldDelegate { }
