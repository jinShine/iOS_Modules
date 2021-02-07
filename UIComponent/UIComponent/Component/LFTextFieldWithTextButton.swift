//
//  LFTextFieldWithTextButton.swift
//  Common
//
//  Created by buzz on 2021/02/06.
//

import RxCocoa
import RxSwift
import UIKit
import SnapKit
import NSObject_Rx

/**
 [UI 제플린에서 보기](https://zpl.io/be6jA0P)
 */

public class LFTextFieldWithTextButton: UIView {

  // MARK: - Constant

  private enum Metric {
    static let cornerRadius: CGFloat = 6
    static let borderWidth: CGFloat = 1.5
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

  // Container (TextField, TextButton)
  private lazy var textFieldContainerView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = Metric.cornerRadius
    view.layer.borderWidth = Metric.borderWidth
    view.layer.borderColor = Theme.color.ttGray090.cgColor
    view.addSubviews([textField, textButton])
    return view
  }()

  private lazy var textField: TextField = {
    let textField = TextField()
    textField.delegate = self
    textField.keyboardType = .numberPad
    return textField
  }()

  // 오른쪽 텍스트 버튼
  private let textButton: Button = {
    let button = Button()
    button.setTitleColor(Theme.color.purple, for: .normal)
    button.titleLabel?.font = Theme.font.body2Bold
    return button
  }()

  // MARK: - Properties

  /// 입력되는 텍스트 Subject
  public let textSubject = BehaviorRelay<String>(value: "")
  
  /// 버튼 Subject
  public let buttonSubject = PublishRelay<Void>()

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
  
  /// 버튼 타이틀
  public var buttonTitle: String = "" {
    didSet { textButton.setTitle(buttonTitle, for: .normal) }
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
    addSubviews([textFieldContainerView, titleLabel])

    setupConstraints()
  }

  private func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(8)
      $0.height.equalTo(14)
    }

    textFieldContainerView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(7)
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(48)
    }

    textField.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.centerY.equalToSuperview()
    }

    textButton.snp.makeConstraints {
      $0.leading.equalTo(textField.snp.trailing).offset(8)
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-16)
      $0.height.equalTo(40)
      $0.width.lessThanOrEqualTo(45)
    }
  }

}

// MARK: - Binding methods

extension LFTextFieldWithTextButton {

  private func bind() {
    textField.rx.controlEvent(.editingDidBegin)
      .subscribe(onNext: { [weak self] in
        self?.focused()
      }).disposed(by: rx.disposeBag)
    
    textField.rx.controlEvent(.editingDidEnd)
      .subscribe(onNext: { [weak self] in
        self?.unfocused()
      }).disposed(by: rx.disposeBag)
    
    textField.rx.text.orEmpty
      .subscribe(onNext: { [weak self] in
        self?.textSubject.accept($0)
        self?.textField.text = $0
      }).disposed(by: rx.disposeBag)
    
    textButton.rx.tap
      .bind(to: buttonSubject)
      .disposed(by: rx.disposeBag)

  }

}

// MARK: - Helper methods

extension LFTextFieldWithTextButton {

  private func focused() {
    textFieldContainerView.layer.borderColor = Theme.color.black.cgColor
  }
  
  private func unfocused() {
    textFieldContainerView.layer.borderColor = Theme.color.ttGray090.cgColor
  }
  
}

// MARK: - UITextField delegate

extension LFTextFieldWithTextButton: UITextFieldDelegate { }

