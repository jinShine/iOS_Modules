//
//  LFTextFieldView+InputView.swift
//  UIComponent
//
//  Created by buzz on 2021/09/07.
//

import RxSwift
import UIKit

enum DateOfBirth {
  /*
   출생년도 범위 : 14 ~ 100세

   예)
    14세 = 현재년수 - maxYear
    100세 = 현재년수 - minYear
   */
  static let minYear = 99
  static let maxYear = 13
}

public extension LFTextFieldView {

  private enum Metric {
    static let datePickerHeight: CGFloat = 216
    static let toolBarHeight: CGFloat = 44.0
  }

  @objc func didTapCancel() {
    textField.resignFirstResponder()
  }
}

// MARK: - LFTextFieldView + DatePicker

public extension LFTextFieldView {

  /// 기본 DatePicker
  func setInputViewDatePicker() -> Observable<UIDatePicker> {
    return Observable<UIDatePicker>.create { observer in
      let screenWidth = UIScreen.main.bounds.width
      let datePicker = UIDatePicker(frame: CGRect(origin: .zero, size: CGSize(width: screenWidth, height: Metric.datePickerHeight)))
      datePicker.datePickerMode = .date
      datePicker.locale = Locale(identifier: "ko-KR")

      if #available(iOS 14, *) {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.sizeToFit()
      }

      let toolView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: screenWidth, height: Metric.toolBarHeight)))
      toolView.backgroundColor = Theme.color.ttGray090

      let cancelButton = UIButton()
      cancelButton.setTitle("취소", for: .normal)
      cancelButton.setTitleColor(Theme.color.purple, for: .normal)
      cancelButton.titleLabel?.font = Theme.font.body1Bold
      cancelButton.addTarget(self, action: #selector(self.didTapCancel), for: .touchUpInside)

      let doneButton = UIButton()
      doneButton.setTitle("확인", for: .normal)
      doneButton.setTitleColor(Theme.color.purple, for: .normal)
      doneButton.titleLabel?.font = Theme.font.body1Bold

      toolView.addSubviews([cancelButton, doneButton])

      cancelButton.snp.makeConstraints {
        $0.leading.equalToSuperview().offset(Constants.margin16)
        $0.centerY.equalToSuperview()
      }

      doneButton.snp.makeConstraints {
        $0.trailing.equalToSuperview().offset(-Constants.margin16)
        $0.centerY.equalToSuperview()
      }

      doneButton.rx.tap
        .subscribe(onNext: { [weak self] in
          if let datePicker = self?.textField.inputView as? UIDatePicker {
            observer.onNext(datePicker)
          }
        }).disposed(by: self.rx.disposeBag)

      self.textField.inputAccessoryView = toolView
      self.textField.inputView = datePicker

      return Disposables.create {
        observer.onCompleted()
      }
    }
  }

  /// 출생년도 범위(14 ~ 100세)가 적용된 DatePicker
  func setDateOfBirthDatePicker() -> Observable<UIDatePicker> {
    return Observable<UIDatePicker>.create { observer in
      let screenWidth = UIScreen.main.bounds.width
      let datePicker = UIDatePicker(frame: CGRect(origin: .zero, size: CGSize(width: screenWidth, height: Metric.datePickerHeight)))
      datePicker.datePickerMode = .date
      datePicker.locale = Locale(identifier: "ko-KR")

      let minAndMaxDate = self.minAndMaxDate()
      datePicker.minimumDate = minAndMaxDate.minDate
      datePicker.maximumDate = minAndMaxDate.maxDate

      if #available(iOS 14, *) {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.sizeToFit()
      }

      let toolView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: screenWidth, height: Metric.toolBarHeight)))
      toolView.backgroundColor = Theme.color.ttGray090

      let cancelButton = UIButton()
      cancelButton.setTitle("취소", for: .normal)
      cancelButton.setTitleColor(Theme.color.purple, for: .normal)
      cancelButton.titleLabel?.font = Theme.font.body1Bold
      cancelButton.addTarget(self, action: #selector(self.didTapCancel), for: .touchUpInside)

      let doneButton = UIButton()
      doneButton.setTitle("확인", for: .normal)
      doneButton.setTitleColor(Theme.color.purple, for: .normal)
      doneButton.titleLabel?.font = Theme.font.body1Bold

      toolView.addSubviews([cancelButton, doneButton])

      cancelButton.snp.makeConstraints {
        $0.leading.equalToSuperview().offset(Constants.margin16)
        $0.centerY.equalToSuperview()
      }

      doneButton.snp.makeConstraints {
        $0.trailing.equalToSuperview().offset(-Constants.margin16)
        $0.centerY.equalToSuperview()
      }

      doneButton.rx.tap
        .subscribe(onNext: { [weak self] in
          if let datePicker = self?.textField.inputView as? UIDatePicker {
            observer.onNext(datePicker)
          }
        }).disposed(by: self.rx.disposeBag)

      self.textField.inputAccessoryView = toolView
      self.textField.inputView = datePicker

      return Disposables.create {
        observer.onCompleted()
      }
    }
  }

  /// 출생년도 범위(14 ~ 100세)
  private func minAndMaxDate() -> (minDate: Date?, maxDate: Date?) {
    let currentDate = Date()
    let calendar = Calendar.current
    let dateComponent = calendar.dateComponents([.year], from: currentDate)

    if let year = dateComponent.year {
      let minYear = year - DateOfBirth.minYear
      let maxYear = year - DateOfBirth.maxYear

      let minDateComponent = DateComponents(calendar: calendar, year: minYear, month: 1, day: 1, hour: 00, minute: 00, second: 00)
      let maxDateComponent = DateComponents(calendar: calendar, year: maxYear, month: 12, day: 31, hour: 00, minute: 00, second: 00)

      return (minDateComponent.date, maxDateComponent.date)
    }

    return (nil, nil)
  }
}
