//
//  UICollectionViewDiffableDataSource.swift
//  NSDiffableDataSourceSnapshot
//
//  Created by buzz on 2021/05/08.
//

import Common
import RxCocoa
import RxSwift
import UIKit

final class RegisterCategoryViewController: ViewController {

  // MARK: - Constant

  typealias ViewModelType = RegisterCategoryViewModelBindable
  typealias DataSource = UICollectionViewDiffableDataSource<Section, RegisterCategoryItem>

  // MARK: - UI Properties

  private lazy var collectionView: CollectionView = {
    let collectionView = CollectionView()
    collectionView.delegate = self
    collectionView.register(RegisterCategoryCell.self, forCellWithReuseIdentifier: RegisterCategoryCell.reuseIdentifier)
    return collectionView
  }()

  private let nextButton: LFButton = {
    let button = LFButton(type: .primary)
    button.title = "다음"
    return button
  }()

  // MARK: - Properties

  lazy var datasource = createDatasource()
  var viewModel: ViewModelType
  var navigator: Navigator

  // MARK: - Initialize

  init(viewModel: ViewModelType, navigator: Navigator) {
    self.viewModel = viewModel
    self.navigator = navigator
    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Life cycle

  // MARK: - Setup

  override func setupUI() {
    view.addSubviews([collectionView, nextButton])
    super.setupUI()
    setupNavigationView()
    setupCollectionView()
  }

  override func setupConstraints() {
    super.setupConstraints()

    collectionView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.margin32)
      $0.leading.equalToSuperview().offset(Constants.margin16)
      $0.trailing.equalToSuperview().offset(-Constants.margin16)
      $0.bottom.equalTo(nextButton.snp.top).offset(-Constants.margin10 * 2)
    }

    nextButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-Constants.SafeArea.bottom)
      $0.leading.equalToSuperview().offset(Constants.margin16)
      $0.trailing.equalToSuperview().offset(-Constants.margin16)
    }
  }

  private func setupNavigationView() {
    title = "나에게 맞는 관심 카테고리 선택."
  }

  private func setupCollectionView() {
    collectionView.dataSource = datasource
    collectionView.collectionViewLayout = createCollectionViewLayout()
  }

  // MARK: - Binding methods

  override func inputBinding() {
    super.inputBinding()

    rx.viewWillAppear.mapToVoid()
      .bind(to: viewModel.viewWillAppear)
      .disposed(by: rx.disposeBag)

    nextButton.rxTap
      .throttle()
      .bind(to: viewModel.didTapNext)
      .disposed(by: rx.disposeBag)
  }

  override func outputBinding() {
    super.outputBinding()

    viewModel.categories
      .drive(onNext: { [weak self] in
        self?.updateSnapshot(items: $0)
      }).disposed(by: rx.disposeBag)

    viewModel.selectedCategories
      .drive(onNext: { log.debug($0) })
      .disposed(by: rx.disposeBag)

    viewModel.showRegisterTerm
      .drive(onNext: { [weak self] in
        self?.navigator.show(
          scene: .registerTerms,
          sender: self,
          transitionType: .overFullScreenModal
        )
      }).disposed(by: rx.disposeBag)
  }
}

// MARK: - CollectionView helper

extension RegisterCategoryViewController {

  private func createDatasource() -> DataSource {
    let datasource = DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegisterCategoryCell.reuseIdentifier, for: indexPath) as? RegisterCategoryCell else {
        return UICollectionViewCell()
      }

      let cellViewModel = RegisterCategoryCellViewModel(with: item)
      cell.bind(to: cellViewModel)

      return cell
    }

    return datasource
  }

  private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let fraction: CGFloat = 1 / 4

    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: Constants.margin8, leading: Constants.margin8, bottom: Constants.margin8, trailing: Constants.margin8)

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)
    let layout = UICollectionViewCompositionalLayout(section: section)

    return layout
  }

  private func updateSnapshot(items: [RegisterCategoryItem]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, RegisterCategoryItem>()
    snapshot.appendSections([.main])
    snapshot.appendItems(items)
    datasource.apply(snapshot, animatingDifferences: true)
  }
}

extension RegisterCategoryViewController: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let categoryItem = datasource.itemIdentifier(for: indexPath) else { return }
    viewModel.didSelectCategoryItem.onNext(categoryItem)
  }

  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    guard let categoryItem = datasource.itemIdentifier(for: indexPath) else { return }
    viewModel.didDeselectCategoryItem.onNext(categoryItem)
  }
}
