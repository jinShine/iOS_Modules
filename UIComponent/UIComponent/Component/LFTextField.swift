//
//  LFTextField.swift
//  UIComponent
//
//  Created by buzz on 2021/02/06.
//

import RxCocoa
import RxSwift
import UIKit
import SnapKit
import NSObject_Rx

public class LFTextField: UIView {
  
  // MARK: - Constant
  
  private enum Metric {
    static let cornerRadius: CGFloat = 6
    static let borderWidth: CGFloat = 1.5
  }
  
  public enum LFTextFieldStyle {
    case normal
    case success
    case warning
    case error
    case disabled
  }
  
  // MARK: - UI Properties
  
  private let titleLabel: Label = {
    let label = Label(0, 8, 0, 8)
    label.backgroundColor = Theme.color.white
    label.textColor = Theme.color.ttGray010
    label.font = Theme.font.caption2Bold
    label.text = "Title"
    return label
  }()
  
  lazy var containerStackView: StackView = {
    let stackView = StackView(arrangedSubviews: [textFieldContainerView, optionContainerView])
    stackView.axis = .vertical
    stackView.distribution = .fill
    return stackView
  }()
  
  // Container (TextField, StatusImageButton)
  private lazy var textFieldContainerView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = Metric.cornerRadius
    view.layer.borderWidth = Metric.borderWidth
    view.layer.borderColor = Theme.color.ttGray090.cgColor
    view.addSubviews([textField, statusImageButton])
    return view
  }()
  
  private lazy var textField: TextField = {
    let textField = TextField()
    textField.delegate = self
    return textField
  }()
  
  // 오른쪽 상태 이미지 버튼
  private let statusImageButton: Button = {
    let button = Button()
    button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    return button
  }()
  
  // Container (MessageLabel, MaxLengthLabel)
  private lazy var optionContainerView: UIView = {
    let view = UIView()
    view.addSubviews([messageLabel, maxLengthLabel])
    return view
  }()
  
  private let messageLabel: Label = {
    let label = Label()
    label.font = Theme.font.caption1Regular
    return label
  }()
  
  private let maxLengthLabel: Label = {
    let label = Label()
    label.font = Theme.font.caption1Regular
    label.textAlignment = .right
    return label
  }()
  
  // MARK: - Properties
  
  /// 입력되는 텍스트 Subject
  public let textSubject = BehaviorRelay<String>(value: "")
  
  /// 상단 타이틀
  public var title: String {
    get { titleLabel.text ?? "" }
    set { titleLabel.text = newValue }
  }
  
  /// placeholder
  public var placeholder: String = "" {
    didSet { textField.placeholder = placeholder }
  }
  
  /// 입력 내용
  public var text: String {
    get { textField.text ?? "" }
    set { textField.text = newValue }
  }
  
  /// 하단에 에러,상태 등 설명을 나타내는 메세지
  public var message: String = "" {
    didSet {
      messageLabel.text = message
      message.isEmpty ? hideOption() : showOption()
      
      // success일때 message 제거 하고 싶을때 해제
      // style == .success ? hideOption() : showOption()
    }
  }
  
  /// 입력 받을 최대 문자 수
  public var maxLength: Int = 0
  
  /// 마지막 style 저장
  private var lastSavedStyle: LFTextFieldStyle = .normal
  
  /// LFTextField 스타일
  public var style: LFTextFieldStyle = .normal {
    didSet {
      lastSavedStyle = style
      
      switch self.style {
      case .normal:
        setupNormalStyle()
      case .success:
        setupSuccessStyle()
      case .warning:
        setupWarningStyle()
      case .error:
        setupErrorStyle()
      case .disabled:
        setupDisabledStyle()
      }
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
    isUserInteractionEnabled = true
    addSubviews([containerStackView, titleLabel])
    
    setupConstraints()
  }
  
  private func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(8)
      $0.height.equalTo(14)
    }
    
    containerStackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(7)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    textFieldContainerView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(48)
    }
    
    textField.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.centerY.equalToSuperview()
    }
    
    statusImageButton.snp.makeConstraints {
      $0.leading.equalTo(textField.snp.trailing).offset(14)
      $0.trailing.centerY.equalToSuperview()
      $0.size.equalTo(40)
    }
    
    optionContainerView.snp.makeConstraints {
      $0.top.equalTo(textFieldContainerView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(0)
    }
    
    messageLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(14)
      $0.trailing.equalToSuperview().offset(-53)
    }
    
    maxLengthLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-8)
    }
  }
  
}

// MARK: - Binding methods

extension LFTextField {
  
  private func bind() {
    
    let editingDidBegin = textField.rx
      .controlEvent(.editingDidBegin)
      .share()
    
    editingDidBegin
      .subscribe(onNext: {
        self.setupFocused()
      }).disposed(by: rx.disposeBag)
    
    editingDidBegin
      .withLatestFrom(self.textField.rx.text.orEmpty)
      .subscribe(onNext: { text in
        self.setupMaxLengthAttributed(keyword: text, limitedBy: self.maxLength)
      }).disposed(by: rx.disposeBag)
    
    textField.rx.controlEvent(.editingDidEnd)
      .subscribe(onNext: {
        self.setupUnfocused()
      }).disposed(by: rx.disposeBag)
    
    let didInputText = textField.rx.text.orEmpty.share()
    
    didInputText
      .subscribe(onNext: { [weak self] in
        self?.textSubject.accept($0)
        self?.textField.text = $0
      }).disposed(by: rx.disposeBag)
    
    didInputText
      .do(onNext: { text in
        // maxLength까지만 textField에 입력
        if !self.isMaxLengthZero() {
          if text.count > self.maxLength {
            self.textField.setTextMaxLength(by: self.maxLength)
          }
        }
      })
      .subscribe(onNext: { text in
        self.setupMaxLengthAttributed(keyword: text, limitedBy: self.maxLength)
      }).disposed(by: rx.disposeBag)
    
    // normal상태일때 이미지 버튼 클릭시 입력값 초기화
    statusImageButton.rx.tap
      .filter { self.style == .normal }
      .subscribe(onNext: {
        self.reset()
      }).disposed(by: rx.disposeBag)
    
  }
  
}

// MARK: - Helper methods

extension LFTextField {
  
  private func isMaxLengthZero() -> Bool {
    return maxLength == 0
  }
  
  private func setupMaxLengthAttributed(keyword: String, limitedBy limit: Int) {
    if !isMaxLengthZero() {
      if keyword.count <= limit {
        let attributed = NSMutableAttributedString(
          string: "\(keyword.count)", attributes: [
            NSAttributedString.Key.foregroundColor: Theme.color.black,
            NSAttributedString.Key.font: Theme.font.caption1Regular
          ]
        )
        attributed.append(
          NSAttributedString(
            string: "/\(limit)",
            attributes: [
              NSAttributedString.Key.foregroundColor: Theme.color.ttGray030,
              NSAttributedString.Key.font: Theme.font.caption1Regular
            ]
          )
        )
        
        self.maxLengthLabel.attributedText = attributed
      }
    }
  }
  
  private func setupFocused() {
    guard lastSavedStyle == .normal else {
      style = lastSavedStyle
      return
    }
    
    message.isEmpty && isMaxLengthZero() ? hideOption() : showOption()
    textFieldContainerView.layer.borderColor = Theme.color.black.cgColor
    statusImageButton.setImage(Theme.image.close.withRenderingMode(.alwaysOriginal), for: .normal)
  }
  
  private func setupUnfocused() {
    style = lastSavedStyle
  }
  
  private func setupNormalStyle() {
    isUserInteractionEnabled = true
    
    titleLabel.textColor = Theme.color.ttGray010
    
    textFieldContainerView.layer.borderColor = Theme.color.ttGray090.cgColor
    
    statusImageButton.setImage(nil, for: .normal)
    statusImageButton.tintColor = nil
    statusImageButton.isUserInteractionEnabled = true
    
    messageLabel.textColor = Theme.color.ttGray010
  }
  
  private func setupSuccessStyle() {
    isUserInteractionEnabled = true
    
    titleLabel.textColor = Theme.color.green
    
    textFieldContainerView.layer.borderColor = Theme.color.green.cgColor
    
    statusImageButton.setImage(Theme.image.check, for: .normal)
    statusImageButton.tintColor = Theme.color.green
    statusImageButton.isUserInteractionEnabled = false
    
    messageLabel.textColor = Theme.color.green
  }
  
  private func setupWarningStyle() {
    isUserInteractionEnabled = true
    
    titleLabel.textColor = Theme.color.yellow
    
    textFieldContainerView.layer.borderColor = Theme.color.yellow.cgColor
    
    statusImageButton.setImage(Theme.image.warning, for: .normal)
    statusImageButton.tintColor = Theme.color.yellowText
    statusImageButton.isUserInteractionEnabled = false
    
    messageLabel.textColor = Theme.color.yellowText
  }
  
  private func setupErrorStyle() {
    isUserInteractionEnabled = true
    
    titleLabel.textColor = Theme.color.orange
    
    textFieldContainerView.layer.borderColor = Theme.color.orange.cgColor
    
    statusImageButton.setImage(Theme.image.error, for: .normal)
    statusImageButton.tintColor = Theme.color.orange
    statusImageButton.isUserInteractionEnabled = false
    
    messageLabel.textColor = Theme.color.orange
  }
  
  private func setupDisabledStyle() {
    isUserInteractionEnabled = false
    
    titleLabel.textColor = Theme.color.ttGray030
    
    textFieldContainerView.layer.borderColor = Theme.color.ttGray090.cgColor
    
    statusImageButton.setImage(nil, for: .normal)
    statusImageButton.tintColor = nil
    statusImageButton.isUserInteractionEnabled = false
    
    messageLabel.textColor = .clear
  }
  
  public func reset() {
    textField.text = nil
    setupMaxLengthAttributed(keyword: "", limitedBy: self.maxLength)
  }
  
  public func showOption() {
    optionContainerView.subviews.forEach { $0.isHidden = false }
    optionContainerView.snp.updateConstraints {
      $0.height.equalTo(26)
    }
  }
  
  public func hideOption() {
    optionContainerView.subviews.forEach { $0.isHidden = true }
    optionContainerView.snp.updateConstraints {
      $0.height.equalTo(0)
    }
  }
  
}

// MARK: - UITextField delegate

extension LFTextField: UITextFieldDelegate {
  
  public func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    
    if isMaxLengthZero() {
      return true
    }
    
    if let count = textField.text?.count,
       count <= maxLength {
      return true
    }
    
    return false
  }
  
}
