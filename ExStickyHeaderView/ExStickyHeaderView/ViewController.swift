//
//  ViewController.swift
//  ExStickyHeaderView
//
//  Created by buzz on 2022/02/13.
//

import UIKit

class ViewController: UIViewController {

  enum Metric {
    static let headerViewMaxHeight: CGFloat = 200
    static let headerViewMinHeight: CGFloat = 50
  }

  @IBOutlet var tableView: UITableView!
  @IBOutlet var headerView: UIView!
  @IBOutlet var hidableView: UIView!
  @IBOutlet var headerViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet var headerViewTopConstraint: NSLayoutConstraint!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
  }

  private func setupTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.contentInset = .init(top: Metric.headerViewMaxHeight, left: 0, bottom: 0, right: 0)
    tableView.scrollIndicatorInsets = tableView.contentInset
  }

  /// headerView의 height constraints를 이용
  private func stickyHeader1(_ scrollView: UIScrollView) {
    let offset = -scrollView.contentOffset.y
    let alphaPercentage = (offset - 100) / 50
    hidableView.alpha = alphaPercentage

    if scrollView.contentOffset.y < 0 {
      headerViewHeightConstraint.constant = max(abs(scrollView.contentOffset.y), Metric.headerViewMinHeight)
    } else {
      headerViewHeightConstraint.constant = Metric.headerViewMinHeight
    }
  }

  /// headerView의 top constraints를 이용
  private func stickyHeader2(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y < 0 {
      headerViewTopConstraint.constant = -(scrollView.contentOffset.y + Metric.headerViewMaxHeight)
    } else {
      headerViewTopConstraint.constant = -Metric.headerViewMaxHeight
    }
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 30
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")

    return cell
  }
}

extension ViewController: UITableViewDelegate {

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    stickyHeader1(scrollView)
//    stickyHeader2(scrollView)
  }
}
