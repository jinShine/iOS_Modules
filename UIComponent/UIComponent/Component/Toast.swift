//
//  Toast.swift
//  UIComponent
//
//  Created by buzz on 2021/04/26.
//

import UIKit

public class Toast: NSObject {

  public enum Duration: TimeInterval {
    case short = 2.0
    case long = 3.5
  }

  private enum Metric {
    static let delay: TimeInterval = 0.2
  }

  public static func show(message: String, target: UIViewController?, duration: Duration = .short) {
    guard let target = target else {
      log.debug("Toast Target을 설정해주세요.")
      return
    }

    let messageLabel: Label = {
      let label = Label(6, 18, 6, 18)
      label.alpha = 0.1
      label.font = Theme.font.body2Bold
      label.textColor = Theme.color.ttGray090
      label.textAlignment = .center
      label.text = message
      label.numberOfLines = 0

      label.backgroundColor = Theme.color.black
      label.layer.cornerRadius = 16
      label.clipsToBounds = true
      return label
    }()

    target.view.addSubview(messageLabel)

    messageLabel.snp.makeConstraints {
      $0.center.equalTo(target.view.snp.center)
      $0.width.lessThanOrEqualTo(target.view.snp.width).offset(-Constants.margin40)
    }

    UIView.animate(withDuration: Metric.delay, delay: 0, options: .curveEaseIn) {
      messageLabel.alpha = 1.0
    } completion: { _ in
      UIView.animate(withDuration: duration.rawValue, delay: Metric.delay, options: .curveEaseInOut) {
        messageLabel.alpha = 1.0
      } completion: { _ in
        UIView.animate(withDuration: 0.5, delay: duration.rawValue + Metric.delay, options: .curveEaseInOut) {
          messageLabel.alpha = 0
        } completion: { _ in
          messageLabel.removeFromSuperview()
        }
      }
    }
  }
}

// MARK: - Helper methods

extension ViewController {

  /// 토스트 메세지
  public func showToast(message: String, duration: Toast.Duration = .short) {
    Toast.show(message: message, target: self, duration: duration)
  }
}
