//
//  ViewController.swift
//  WebKitModule
//
//  Created by buzz on 2021/04/19.
//

import UIKit
import WebKit

open class WebViewController: UIViewController {

  // MARK: - UI Properties

  public lazy var webView: WKWebView = {
    let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    return webView
  }()

  public lazy var activityIndicatorView: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView(style: .medium)
    view.sizeToFit()
    return view
  }()

  // MARK: - Properties

  var messageHandler: ((WKScriptMessage) -> Void)?

  // MARK: - Initialize

  public init() {
    super.init(nibName: nil, bundle: nil)
  }

  public required convenience init?(coder: NSCoder) {
    self.init()
  }

  // MARK: - Life cycle

  override public func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupConstraints()
    inputBinding()
    outputBinding()
  }

  deinit {
    log.debug("\(type(of: self)): Deinited")
  }

  open func setupUI() {
    view.backgroundColor = .white
    view.addSubview(webView)
    webView.addSubview(activityIndicatorView)
  }

  open func setupConstraints() {
    webView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    activityIndicatorView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }

  // MARK: - Binding methods

  open func inputBinding() {}

  open func outputBinding() {}
}

// MARK: - Helper methods

public extension WebViewController {

  func loadWebView(request: URLRequest) {
    webView.load(request)
  }

  func register(names: [String], messageHandler: @escaping ((WKScriptMessage) -> Void)) {
    names.forEach {
      webView.configuration.userContentController.add(self, name: $0)
    }

    self.messageHandler = { messageHandler($0) }
  }

  func register(name: String, messageHandler: @escaping ((WKScriptMessage) -> Void)) {
    webView.configuration.userContentController.add(self, name: name)
    self.messageHandler = { messageHandler($0) }
  }

  func startLoading() {
    activityIndicatorView.startAnimating()
  }

  func stopLoading() {
    activityIndicatorView.stopAnimating()
  }
}

// MARK: - WKScriptMessageHandler

extension WebViewController: WKScriptMessageHandler {

  public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    messageHandler?(message)
  }
}


