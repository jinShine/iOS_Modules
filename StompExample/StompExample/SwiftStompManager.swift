//
//  SwiftStompManager.swift
//  StompExample
//
//  Created by buzz on 2022/03/18.
//

import RxCocoa
import RxSwift
import SwiftStomp
import UIKit

// MARK: - StompSocketManaging

public protocol StompSocketManaging {
  var receiveMessage: PublishRelay<Data> { get }

  func registerObservers()
  func registerSocket(url: URL?, header: [String: String]?, topics: [String])
  func enableAutoPing(interval: TimeInterval)
  func enableLogging(_ isEnabled: Bool)
  func connect()
  func disconnect()
  func send(body: String, to destination: String, receiptId: String?, headers: [String: String]?)
}

// MARK: - StompSocketManager

public class StompSocketManager: NSObject, StompSocketManaging {

  private var swiftStomp: SwiftStomp!
  private var url: URL?
  private var topics: [String] = []
  private var header: [String: String]?

  public let receiveMessage = PublishRelay<Data>()

  override public init() {
    super.init()
  }

  public func registerObservers() {
    NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        if !self.swiftStomp.isConnected {
          self.swiftStomp.connect()
        }
      }).disposed(by: rx.disposeBag)

    NotificationCenter.default.rx.notification(UIApplication.willResignActiveNotification)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        if self.swiftStomp.isConnected {
          self.swiftStomp.disconnect(force: true)
        }
      }).disposed(by: rx.disposeBag)
  }

  public func registerSocket(url: URL?, header: [String: String]?, topics: [String]) {
    guard swiftStomp == nil else { return }
    guard let url = url else { fatalError("need to url") }
    self.url = url
    self.topics = topics

    swiftStomp = SwiftStomp(host: url, headers: header)
    swiftStomp.delegate = self
    swiftStomp.autoReconnect = true

    connect()
  }

  public func connect() {
    if !swiftStomp.isConnected {
      swiftStomp.connect()
    }
  }

  public func disconnect() {
    guard swiftStomp != nil else { return }

    if swiftStomp.isConnected {
      swiftStomp.disconnect()
    }
  }

  public func enableAutoPing(interval: TimeInterval) {
    swiftStomp.enableAutoPing(pingInterval: interval)
  }

  public func enableLogging(_ isEnabled: Bool) {
    swiftStomp.enableLogging = isEnabled
  }

  public func send(body: String, to destination: String, receiptId: String? = nil, headers: [String: String]? = nil) {
    swiftStomp.send(body: body, to: destination, receiptId: receiptId, headers: headers)
  }
}

// MARK: SwiftStompDelegate

extension StompSocketManager: SwiftStompDelegate {

  public func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
    if connectType == .toStomp {
      log.info("🔌 Connected to stomp")

      topics.forEach {
        swiftStomp.subscribe(to: $0)
      }
    }
  }

  public func onDisconnect(swiftStomp: SwiftStomp, disconnectType: StompDisconnectType) {
    if disconnectType == .fromStomp {
      log.info("🔌 Client disconnected from stomp but socket is still connected!")
    }
  }

  public func onMessageReceived(swiftStomp: SwiftStomp, message: Any?, messageId: String, destination: String, headers: [String: String]) {
    log.info("🔌  Message with id `\(messageId)` received at destination `\(destination)`:\n\(message ?? "empty")")

    if let message = message as? String,
       let data = message.components(separatedBy: "\n").last?.data(using: .utf8) {
      receiveMessage.accept(data)
    }
  }

  public func onReceipt(swiftStomp: SwiftStomp, receiptId: String) {
    log.info("🔌 Receipt with id `\(receiptId)` received")
  }

  public func onError(swiftStomp: SwiftStomp, briefDescription: String, fullDescription: String?, receiptId: String?, type: StompErrorType) {
    if type == .fromStomp {
      log.info("🔌 Stomp error occurred! [\(briefDescription)] : \(String(describing: fullDescription))")
    } else {
      log.info("🔌 Unknown error occured!")
    }
  }

  public func onSocketEvent(eventName: String, description: String) {
    log.info("🔌 Socket event occured: \(eventName) => \(description)")
  }
}
