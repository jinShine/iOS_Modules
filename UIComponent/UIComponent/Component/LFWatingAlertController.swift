//
//  LFWatingAlertController.swift
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

public class LFWatingAlertController: UIViewController {

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
    label.textColor = Theme.color.ttGray010
    label.textAlignment = .left
    label.numberOfLines = 0
    return label
  }()

  /// 정원 및 웨이팅 Container 뷰
  private lazy var contentStackView: StackView = {
    let stackView = StackView(arrangedSubviews: [maxPeopleContainerView, watingPeopleContainerView])
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually

    maxPeopleContainerView.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview()
    }

    watingPeopleContainerView.snp.makeConstraints {
      $0.top.trailing.bottom.equalToSuperview()
    }

    return stackView
  }()

  /// 최대 인원 수
  public let maxPeopleLabel: Label = {
    let label = Label()
    label.font = Theme.font.heading2Bold
    label.textColor = Theme.color.black
    label.textAlignment = .center
    label.text = "\(0)"
    return label
  }()

  /// 최대 인원 수 Container 뷰
  lazy var maxPeopleContainerView: UIView = {
    let view = UIView()

    let title: Label = {
      let label = Label()
      label.font = Theme.font.body2Regular
      label.textColor = Theme.color.black
      label.textAlignment = .center
      label.text = "최대정원"
      return label
    }()

    let orderLabel: Label = {
      let label = Label()
      label.font = Theme.font.caption1Regular
      label.textColor = Theme.color.ttGray010
      label.textAlignment = .center
      label.text = "명"
      return label
    }()

    view.addSubviews([title, maxPeopleLabel, orderLabel])

    title.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(Constants.margin10 * 2)
    }

    maxPeopleLabel.snp.makeConstraints {
      $0.top.equalTo(title.snp.bottom).offset(Constants.margin6)
      $0.centerX.bottom.equalToSuperview()
    }

    orderLabel.snp.makeConstraints {
      $0.leading.equalTo(maxPeopleLabel.snp.trailing).offset(Constants.margin4)
      $0.bottom.equalTo(maxPeopleLabel).offset(-Constants.margin2)
    }

    return view
  }()

  private let centerLineView = LineView(axis: .vertical)

  /// 웨이팅 인원 수
  public let watingPeopleLabel: Label = {
    let label = Label()
    label.font = Theme.font.heading2Bold
    label.textColor = Theme.color.black
    label.textAlignment = .center
    label.text = "\(0)"
    return label
  }()

  /// 웨이팅 인원 수 Container 뷰
  lazy var watingPeopleContainerView: UIView = {
    let view = UIView()

    let title: Label = {
      let label = Label()
      label.font = Theme.font.body2Regular
      label.textColor = Theme.color.black
      label.textAlignment = .center
      label.text = "내 앞 웨이팅"
      return label
    }()

    let orderLabel: Label = {
      let label = Label()
      label.font = Theme.font.caption1Regular
      label.textColor = Theme.color.ttGray010
      label.textAlignment = .center
      label.text = "명"
      return label
    }()

    view.addSubviews([title, watingPeopleLabel, orderLabel])

    title.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(Constants.margin10 * 2)
    }

    watingPeopleLabel.snp.makeConstraints {
      $0.top.equalTo(title.snp.bottom).offset(Constants.margin6)
      $0.centerX.bottom.equalToSuperview()
    }

    orderLabel.snp.makeConstraints {
      $0.leading.equalTo(watingPeopleLabel.snp.trailing).offset(Constants.margin4)
      $0.bottom.equalTo(watingPeopleLabel).offset(-Constants.margin2)
    }

    return view
  }()

  public let lineView = LineView(axis: .horizontal)

  /// 액션 버튼 Container 뷰
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
  public var messageText: NSAttributedString? {
    didSet {
      messageLabel.attributedText = messageText
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
    view.addSubview(transparentView)
    transparentView.addSubview(alertContainerView)
    alertContainerView.addSubviews([
      titleLabel, messageLabel, contentStackView,
      lineView, actionStackView
    ])
    contentStackView.addSubview(centerLineView)
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

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(Constants.margin32)
      $0.leading.equalToSuperview().offset(Constants.margin24)
      $0.trailing.equalToSuperview().offset(-Constants.margin24)
    }

    messageLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.margin10)
      $0.leading.equalToSuperview().offset(Constants.margin24)
      $0.trailing.equalToSuperview().offset(-Constants.margin24)
    }

    contentStackView.snp.makeConstraints {
      $0.top.equalTo(messageLabel.snp.bottom).offset(Constants.margin16)
      $0.leading.equalToSuperview().offset(Constants.margin24)
      $0.trailing.equalToSuperview().offset(-Constants.margin24)
      $0.bottom.equalTo(lineView.snp.top).offset(-Constants.margin32)
      $0.height.equalTo(Constants.size32 * 2)
    }

    centerLineView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.height.equalTo(Constants.margin24)
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
  }
}

// MARK: - Helper methods

extension LFWatingAlertController { }
