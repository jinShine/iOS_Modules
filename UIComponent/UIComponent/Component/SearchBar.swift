//
//  SearchBar.swift
//  Common
//
//  Created by buzz on 2021/01/28.
//

import RxCocoa
import RxSwift
import UIKit
import SnapKit
import NSObject_Rx

public class SearchBar: UIView {
  
  private let searchImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = Theme.image.search
    imageView.tintColor = Theme.color.ttGray030
    return imageView
  }()
  
  public let textField: TextField = {
    let textField = TextField()
    return textField
  }()
  
  private let disposeBag = DisposeBag()
  
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
    self.layer.cornerRadius = 6
    self.layer.borderWidth = 1.5
    self.layer.borderColor = Theme.color.ttGray090.cgColor
    self.isUserInteractionEnabled = true
    
    addSubviews([searchImageView, textField])
    
    searchImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(8)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(24)
    }
    
    textField.snp.makeConstraints {
      $0.leading.equalTo(searchImageView.snp.trailing).offset(14)
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-24)
    }
  }
  
}

extension SearchBar {
  
  private func bind() {
    
    textField.rx.controlEvent(.editingDidBegin)
      .subscribe(onNext: { [weak self] in
        self?.layer.borderColor = Theme.color.black.cgColor
      }).disposed(by: rx.disposeBag)
    
    textField.rx.controlEvent(.editingDidEnd)
      .subscribe(onNext: { [weak self] in
        self?.layer.borderColor = Theme.color.ttGray090.cgColor
      }).disposed(by: rx.disposeBag)
  }
  
}
