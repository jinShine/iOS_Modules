//
//  ViewController.swift
//  CodeSnippets
//
//  Created by buzz on 2021/03/07.
//

import RxCocoa
import RxSwift
import UIKit
import Common

final class <#ViewController#>: ViewController {

  // MARK: - Constant

  typealias ViewModelType = <#ViewModel#>Bindable

  // MARK: - UI Properties

  // MARK: - Properties

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
    super.setupUI()
  }

  override func setupConstraints() {
    super.setupConstraints()
  }

  // MARK: - Binding methods

  override func inputBinding() {
    super.inputBinding()
  }

  override func outputBinding() {
    super.outputBinding()
  }
}

// MARK: - Helper methods

extension <#ViewController#> { }
