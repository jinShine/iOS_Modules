//
//  ReviewStarView.swift
//  ReviewStarModule
//
//  Created by buzz on 2021/08/05.
//

import Cosmos
import RxCocoa
import RxSwift
import UIKit

public class LFReviewStarView: UIView {

  // MARK: - Constant

  public enum Style {
    case yellow
    case purple
  }

  // MARK: - UI Properties

  private let starView = CosmosView()

  // MARK: - Properties

  public lazy var settings: CosmosSettings = starView.settings {
    didSet {
      starView.settings = settings
    }
  }

  public var style: Style = .yellow {
    didSet {
      switch style {
      case .yellow:
        settings.emptyImage = Theme.image.reviewStarEmptyYellow
        settings.filledImage = Theme.image.reviewStarFillYellow
      case .purple:
        settings.emptyImage = Theme.image.reviewStarEmptyPurple
        settings.filledImage = Theme.image.reviewStarFillPurple
      }
    }
  }

  public var rating: Double = 0.0 {
    didSet {
      starView.rating = rating
    }
  }

  public var text: String? {
    didSet {
      starView.text = text
    }
  }

  public var didTapRatingSubject = PublishRelay<Double>()

  public var didTapFinishRatingSubject = PublishRelay<Double>()

  // MARK: - Initialize

  override public init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupConstraints()
    bind()
  }

  public init(style: Style) {
    super.init(frame: .zero)
    defer { self.style = style }
    setupUI()
    setupConstraints()
    bind()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  // MARK: - Setup

  private func setupUI() {
    addSubview(starView)
    backgroundColor = Theme.color.white
    style = .yellow
    settings.totalStars = 5
    settings.minTouchRating = 0
  }

  private func setupConstraints() {
    starView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

// MARK: - Binding methods

extension LFReviewStarView {

  private func bind() {
    starView.didTouchCosmos = { [weak self] rating in
      self?.didTapRatingSubject.accept(rating)
    }

    starView.didFinishTouchingCosmos = { [weak self] rating in
      self?.didTapFinishRatingSubject.accept(rating)
    }
  }
}

// MARK: - Helper methods

extension LFReviewStarView {

  public func centerInSuperView() {
    starView.snp.remakeConstraints {
      $0.center.equalToSuperview()
    }
  }
}
