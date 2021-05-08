//
//  UITableViewDiffableDataSource.swift
//  NSDiffableDataSourceSnapshot
//
//  Created by buzz on 2021/05/08.
//

import RxCocoa
import RxSwift
import UIKit
import Common

final class MyInfoModifyViewController: ViewController {

  // MARK: - Constant

  typealias ViewModelType = MyInfoModifyViewModelBindable
  typealias DataSource = UITableViewDiffableDataSource<Section, MyInfo>

  // MARK: - UI Properties

  let tableView = TableView()

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
    view.addSubviews([tableView])
    super.setupUI()
    setupNavigationView()
    setupTableView()
  }

  override func setupConstraints() {
    super.setupConstraints()

    tableView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }

  private func setupNavigationView() {
    title = "내정보 수정"
    navigationItem.largeTitleDisplayMode = .never
  }

  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = datasource
    tableView.register(ModifyProfileImageCell.self, forCellReuseIdentifier: ModifyProfileImageCell.reuseIdentifier)
  }

  // MARK: - Binding methods

  override func inputBinding() {
    super.inputBinding()

    rx.viewWillAppear.mapToVoid()
      .bind(to: viewModel.viewWillAppear)
      .disposed(by: rx.disposeBag)
  }

  override func outputBinding() {
    super.outputBinding()

    viewModel.items
      .drive(onNext: { [weak self] in
        self?.updateSnapshot(items: $0)
      }).disposed(by: rx.disposeBag)
  }
}

// MARK: - Helper methods

extension MyInfoModifyViewController { }

// MARK: - Tableview helper

extension MyInfoModifyViewController {

  private func createDatasource() -> DataSource {
    return DataSource(tableView: tableView) { tableview, indexPath, item in
      switch MyInfoModifyViewModel.CellType(rawValue: indexPath.row) {
      case .userProfile:
        guard let cell = tableview.dequeueReusableCell(withIdentifier: ModifyProfileImageCell.reuseIdentifier, for: indexPath) as? ModifyProfileImageCell else {
          return .init()
        }

        return cell
      default:
        return .init()
      }
    }
  }

  private func updateSnapshot(items: [MyInfo]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, MyInfo>()
    snapshot.appendSections([.main])
    snapshot.appendItems(items)
    datasource.apply(snapshot, animatingDifferences: false)
  }
}

// MARK: - Tableview delegate

extension MyInfoModifyViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch MyInfoModifyViewModel.CellType(rawValue: indexPath.row) {
    case .userProfile:
      return UITableView.automaticDimension
    default:
      return .zero
    }
  }
}
