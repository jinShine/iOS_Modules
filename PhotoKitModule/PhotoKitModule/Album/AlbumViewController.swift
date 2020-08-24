//
//  AlbumViewController.swift
//  core
//
//  Created by Buzz.Kim on 2020/08/21.
//  Copyright © 2020 Stat.So. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

typealias AlbumOfSection = SectionModel<String, AlbumItem>

class AlbumViewController: BaseViewController {
  
  // MARK: - Constant
  
  struct Constant {
    static let title = "이미지 선택"
  }
  
  struct Metric {
    static let collectionViewColumn: CGFloat = 3
    static let itemSpacing: CGFloat = 2
    static let lineSpacing: CGFloat = 2
  }
  
  // MARK: - UI Properties
  
  lazy var collectionView: BaseCollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = BaseCollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.delegate = self
    collectionView.register(
      AlbumItemCell.self,
      forCellWithReuseIdentifier: AlbumItemCell.reuseIdentifier
    )
    return collectionView
  }()
  
  // MARK: - Properties
  
  let viewModel: AlbumViewModel?
  let navigator: Navigator
  
  init(viewModel: BaseViewModel, navigator: Navigator) {
    self.viewModel = viewModel as? AlbumViewModel
    self.navigator = navigator
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    
  }
  
  override func viewDidLoad() {
    setLeftBarButton(.close(sender: self))
    setRightBarButton(.text("확인"))
    super.viewDidLoad()
    self.prefersLargeTitles = false
    self.title = Constant.title
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    collectionView
      .add(to: self.view)
      .snp.makeConstraints {
        $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    guard let viewModel = viewModel else { return }
    
    // Input -->
    
    let datasource = RxCollectionViewSectionedReloadDataSource<AlbumOfSection>(
      configureCell: { (datasource, collectionView, indexPath, item) -> UICollectionViewCell in 
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: AlbumItemCell.reuseIdentifier, for: indexPath
          ) as? AlbumItemCell else { return UICollectionViewCell() }
        
        cell.configure(with: item)
        return cell
    })
    
    let viewWillAppearTrigger = rx.viewWillAppear.mapToVoid()
    
    let didTapCellSelected = Observable.zip(collectionView.rx.itemSelected,
                                            collectionView.rx.modelSelected(AlbumItem.self))
    
    let willDisplayCellTrigger = collectionView.rx.willDisplayCell.asObservable()
      .map { ($0, $1)}

    let prefetchItemsTrigger = collectionView.rx.prefetchItems.asObservable()
    
    let cancelPrefetchingTrigger = collectionView.rx.cancelPrefetchingForItems.asObservable()
    
    let input = AlbumViewModel.Input(
      viewWillAppearTrigger: viewWillAppearTrigger,
      didTapCellSelected: didTapCellSelected,
      willDisplayCellTrigger: willDisplayCellTrigger,
      prefetchItemsTrigger: prefetchItemsTrigger,
      cancelPrefetchingTrigger: cancelPrefetchingTrigger
    )
    
    // Output <--
    
    let output = viewModel.transform(input: input)
    
    output.fetchPhotoItems
      .drive()
      .disposed(by: rx.disposeBag)
    
    output.loadMore
      .drive()
      .disposed(by: rx.disposeBag)
    
    output.updateAlbumItemList
      .bind(to: collectionView.rx.items(dataSource: datasource))
      .disposed(by: rx.disposeBag)
    
    output.startCachingImages
      .drive()
      .disposed(by: rx.disposeBag)
    
    output.stopCachingImages
      .drive()
      .disposed(by: rx.disposeBag)
    
    output.selectedCell
      .drive()
      .disposed(by: rx.disposeBag)
    
  }
}

// MARK: - Methods

extension AlbumViewController {

}

// MARK: - CollectionView delegate

extension AlbumViewController: UICollectionViewDelegate {
  
}

extension AlbumViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let calculatedWidth = (view.frame.width - (Metric.lineSpacing * 2)) / Metric.collectionViewColumn
    return CGSize(width: calculatedWidth, height: calculatedWidth)
  }
  
  public func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             insetForSectionAt section: Int) -> UIEdgeInsets {
    return .zero
  }
  
  public func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return Metric.itemSpacing
  }
  
  public func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return Metric.lineSpacing
  }
  
}
