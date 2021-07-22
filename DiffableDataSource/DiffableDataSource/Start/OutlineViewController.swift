//
//  OutlineViewController.swift
//  DiffableDataSource
//
//  Created by buzz on 2021/07/23.
//

import UIKit

class OutlineViewController: UIViewController {

  enum Section {
    case main
  }

  class OutlineItem: Hashable {
    let identifier = UUID()
    let title: String
    let subItems: [OutlineItem]
    let outlineViewController: UIViewController.Type?

    init(
      title: String,
      viewController: UIViewController.Type? = nil,
      subItems: [OutlineItem] = []
    ) {
      self.title = title
      self.subItems = subItems
      self.outlineViewController = viewController
    }

    func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }

    static func == (lhs: OutlineItem, rhs: OutlineItem) -> Bool {
      return lhs.identifier == rhs.identifier
    }
  }

  // MARK: - Properties

  var dataSource: UICollectionViewDiffableDataSource<Section, OutlineItem>! = nil
  var outlineCollectionView: UICollectionView! = nil

  private lazy var menuItems: [OutlineItem] = {
    return [
      OutlineItem(title: "Compositional Layout", subItems: [
        OutlineItem(title: "Getting Started", subItems: [
          OutlineItem(title: "Grid", viewController: GridViewController.self)
        ])
      ])
    ]
  }()

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = "Modern Collection Views"
    configureCollectionView()
    configureDataSource()
  }
}

// MARK: - CollectionView Configure

extension OutlineViewController {

  func configureCollectionView() {
    let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
    view.addSubview(collectionView)
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.backgroundColor = .systemGroupedBackground
    self.outlineCollectionView = collectionView
    collectionView.delegate = self
  }

  func generateLayout() -> UICollectionViewLayout {
    let listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
    let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
    return layout
  }

  func configureDataSource() {
    let containerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, OutlineItem> { cell, indexPath, menuItem in
      var contentConfiguration = cell.defaultContentConfiguration()
      contentConfiguration.text = menuItem.title
      contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .headline)
      cell.contentConfiguration = contentConfiguration

      let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header, isHidden: false, reservedLayoutWidth: .actual, tintColor: .red)
      cell.accessories = [UICellAccessory.outlineDisclosure(displayed: .always, options: disclosureOptions, actionHandler: nil)]
      cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
    }

    let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, OutlineItem> { cell, indexPath, menuItem in
      var contentConfiguration = cell.defaultContentConfiguration()
      contentConfiguration.text = menuItem.title
      cell.contentConfiguration = contentConfiguration
      cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
    }

    dataSource = UICollectionViewDiffableDataSource<Section, OutlineItem>(collectionView: outlineCollectionView, cellProvider: { collectionView, indexPath, item in
      if item.subItems.isEmpty {
        return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
      } else {
        return collectionView.dequeueConfiguredReusableCell(using: containerCellRegistration, for: indexPath, item: item)
      }
    })

    let snapshot = initialSnapshot()
    self.dataSource.apply(snapshot, to: .main, animatingDifferences: false)
  }

  func initialSnapshot() -> NSDiffableDataSourceSectionSnapshot<OutlineItem> {
    var snapshot = NSDiffableDataSourceSectionSnapshot<OutlineItem>()

    func addItems(_ menuItems: [OutlineItem], to parent: OutlineItem?) {
      snapshot.append(menuItems, to: parent)
      for menuItem in menuItems where !menuItem.subItems.isEmpty {
        addItems(menuItem.subItems, to: menuItem)
      }
    }

    addItems(menuItems, to: nil)
    return snapshot
  }
}

extension OutlineViewController: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let menuItem = self.dataSource.itemIdentifier(for: indexPath) else { return }

    collectionView.deselectItem(at: indexPath, animated: true)

    if let viewController = menuItem.outlineViewController {
      navigationController?.pushViewController(viewController.init(), animated: true)
    }
  }
}
