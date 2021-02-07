//
//  LFSearchBar.swift
//  Common
//
//  Created by buzz on 2021/01/30.
//

import RxCocoa
import RxSwift
import UIKit
import SnapKit
import NSObject_Rx

/**
 [UI 제플린에서 보기](https://zpl.io/blGxpDD)
 */

public class LFSearchBar: UIView {
  
  // MARK: - Constant
  
  private enum Metric {
    static let cornerRadius: CGFloat = 6
    static let borderWidth: CGFloat = 1.5
  }
  
  // MARK: - UI Properties
  
  private let searchImageView: ImageView = {
    let imageView = ImageView()
    imageView.image = Theme.image.search
    imageView.tintColor = Theme.color.ttGray030
    return imageView
  }()
  
  private lazy var textField: TextField = {
    let textField = TextField()
    textField.delegate = self
    return textField
  }()
  
  // MARK: - Properties
  
  /// 입력되는 텍스트 Subject
  public let textSubject = BehaviorRelay<String>(value: "")
  
  /// placeholder
  public var placeholder: String = "" {
    didSet { textField.placeholder = placeholder }
  }
  
  /// 입력 내용
  public var text: String {
    get { textField.text ?? "" }
    set { textField.text = newValue }
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
    layer.cornerRadius = Metric.cornerRadius
    layer.borderWidth = Metric.borderWidth
    layer.borderColor = Theme.color.ttGray090.cgColor
    addSubviews([searchImageView, textField])
    
    setupConstraints()
  }
  
  private func setupConstraints() {
    searchImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(8)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(24)
    }
    
    textField.snp.makeConstraints {
      $0.leading.equalTo(searchImageView.snp.trailing).offset(14)
      $0.top.equalToSuperview().offset(12)
      $0.bottom.equalToSuperview().offset(-12)
      $0.trailing.equalToSuperview().offset(-24)
      $0.height.equalTo(24)
    }
  }
  
}

// MARK: - Binding methods

extension LFSearchBar {
  
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
  }
  
}

// MARK: - Helper methods

extension LFSearchBar {
  
  private func focused() {
    layer.borderColor = Theme.color.black.cgColor
  }
  
  private func unfocused() {
    layer.borderColor = Theme.color.ttGray090.cgColor
  }
  
}

// MARK: - UITextField delegate

extension LFSearchBar: UITextFieldDelegate { }
