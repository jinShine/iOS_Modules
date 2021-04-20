//
//  LFAlertController.swift
//  UIComponent
//
//  Created by buzz on 2021/04/20.
//

import RxCocoa
import RxSwift
import UIKit

/**
 [UI 제플린에서 보기](https://zpl.io/bLvmgOJ)
 */

public class LFAlertController: UIViewController {

  // MARK: - UI Properties

  public lazy var transparentView: UIView = {
    let view = UIView()
    view.backgroundColor = Theme.color.black.withAlphaComponent(0.6)
    return view
  }()

  public lazy var alertContainerView: UIView = {
    let view = UIView()
    view.backgroundColor = Theme.color.white
    view.layer.cornerRadius = 8
    view.layer.masksToBounds = true
    return view
  }()

  public lazy var contentStackView: StackView = {
    let stackView = StackView(arrangedSubviews: [titleLabel, messageLabel])
    stackView.axis = .vertical
    stackView.distribution = .fillProportionally
    stackView.spacing = Constants.margin8

    titleLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
    }

    messageLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
    }

    return stackView
  }()

  private lazy var titleLabel: Label = {
    let label = Label()
    label.font = Theme.font.body1Bold
    label.textColor = Theme.color.black
    label.textAlignment = .left
    label.numberOfLines = 0
    return label
  }()

  private lazy var messageLabel: Label = {
    let label = Label()
    label.font = Theme.font.body1Regular
    label.textColor = Theme.color.black
    label.textAlignment = .left
    label.numberOfLines = 0
    return label
  }()

  public let lineView = LineView()

  public lazy var actionStackView: StackView = {
    let stackView = StackView(arrangedSubviews: [dismissButton, actionButton])
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually

    dismissButton.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview()
      $0.size.equalTo(actionButton)
    }

    actionButton.snp.makeConstraints {
      $0.top.trailing.bottom.equalToSuperview()
      $0.size.equalTo(dismissButton)
    }

    return stackView
  }()

  public lazy var dismissButton: Button = {
    let button = Button()
    button.setTitleColor(Theme.color.ttGray010, for: .normal)
    button.titleLabel?.font = Theme.font.body1Bold
    button.titleLabel?.textAlignment = .center
    return button
  }()

  public lazy var actionButton: Button = {
    let button = Button()
    button.setTitleColor(Theme.color.black, for: .normal)
    button.titleLabel?.font = Theme.font.body1Bold
    button.titleLabel?.textAlignment = .center
    return button
  }()

  // MARK: - Properties

  /// 타이틀
  public var titleText: String? {
    didSet {
      titleLabel.text = titleText
    }
  }

  /// 메세지
  public var messageText: String? {
    didSet {
      messageLabel.text = messageText
    }
  }

  // MARK: - Life cycle

  override public func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupConstraints()
  }

  // MARK: - Setup

  private func setupUI() {
    view.addSubviews([transparentView])
    transparentView.addSubview(alertContainerView)
    alertContainerView.addSubviews([contentStackView, lineView, actionStackView])
  }

  private func setupConstraints() {
    transparentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    alertContainerView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.leading.equalToSuperview().offset(Constants.margin16)
      $0.trailing.equalToSuperview().offset(-Constants.margin16)
    }

    contentStackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(Constants.margin32)
      $0.leading.equalToSuperview().offset(Constants.margin24)
      $0.trailing.equalToSuperview().offset(-Constants.margin24)
      $0.bottom.equalTo(lineView.snp.top).offset(-Constants.margin32)
    }

    lineView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(Constants.margin1)
      $0.bottom.equalTo(actionStackView.snp.top)
    }

    actionStackView.snp.makeConstraints {
      $0.top.equalTo(lineView.snp.bottom)
      $0.leading.equalToSuperview().offset(Constants.margin24)
      $0.trailing.equalToSuperview().offset(-Constants.margin24)
      $0.bottom.equalToSuperview()
      $0.height.equalTo(Constants.margin32 * 2)
    }

    updateUI()
  }
}

// MARK: - Helper methods

extension LFAlertController {

  public func updateUI() {
    if let title = titleText, title.isEmpty {
      titleLabel.isHidden = true

      contentStackView.snp.updateConstraints {
        $0.top.equalToSuperview().offset(Constants.margin48)
        $0.bottom.equalTo(lineView.snp.top).offset(-Constants.margin48)
      }
    }

    if let message = messageText, message.isEmpty {
      messageLabel.isHidden = true

      contentStackView.snp.updateConstraints {
        $0.top.equalToSuperview().offset(Constants.margin48)
        $0.bottom.equalTo(lineView.snp.top).offset(-Constants.margin48)
      }
    }

    if dismissButton.titleLabel?.text == nil {
      dismissButton.isHidden = true
    }

    if actionButton.titleLabel?.text == nil {
      actionButton.isHidden = true
    }
  }
}
