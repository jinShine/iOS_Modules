//
//  StompClientManager.swift
//  StompExample
//
//  Created by buzz on 2022/03/18.
//

import RxCocoa
import RxSwift
import SwiftStomp
import UIKit

// MARK: - StompSocketManaging

// MARK: - StompSocketManaging

 public protocol StompSocketManaging {
  var reconnectTimeout: Double? { get set }

  func registerObservers()
  func registerSocket(url: URL?, header: [String: String]?, topic: String)
 }

// MARK: - StompSocketManager

 public class StompSocketManager: NSObject, StompSocketManaging {

  public var reconnectTimeout: Double?
  private let socketClient: StompClientLib
  private var url: URL?
  private var topic: String = ""
  private var header: [String: String]?
  private var pingTimer: Timer?
  private var pingTimerInterval: TimeInterval = 10
  private var autoPingEnabled = false

  override public init() {
    socketClient = StompClientLib()
    super.init()
  }

  public func registerObservers() {
    NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        if !self.socketClient.isConnected() {
          self.reconnect()
        }
      }).disposed(by: rx.disposeBag)

    NotificationCenter.default.rx.notification(UIApplication.willResignActiveNotification)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        if self.socketClient.isConnected() {
          self.socketClient.disconnect()
        }
      }).disposed(by: rx.disposeBag)
  }

  public func registerSocket(url: URL?, header: [String: String]?, topic: String) {
    guard let url = url else { return }
    self.url = url
    self.topic = topic

    socketClient.openSocketWithURLRequest(
      request: NSURLRequest(url: url),
      delegate: self,
      connectionHeaders: header
    )
  }

  public func enableAutoPing(pingTimerInterval: TimeInterval = 10) {
    self.pingTimerInterval = pingTimerInterval
    self.autoPingEnabled = true

    resetPingTimer()
  }

  func disableAutoPing(){
      self.autoPingEnabled = false
      self.pingTimer?.invalidate()
  }


  private func subscribe() {
    if socketClient.isConnected() {
      socketClient.subscribe(destination: topic)
    }
  }

  private func disconnect() {
    if socketClient.isConnected() {
      socketClient.disconnect()
    }
  }

  private func reconnect() {
    guard let url = url, let header = header else { return }

    if let timeout = reconnectTimeout {
      socketClient.reconnect(
        request: NSURLRequest(url: url),
        delegate: self,
        connectionHeaders: header,
        time: timeout
      )
    } else {
      disconnect()
      log.info("↔️ Stomp socket reconnecting...")
      registerSocket(url: url, header: header, topic: topic)
    }
  }
 }

// MARK: Ping

 extension StompSocketManager: StompClientLibDelegate {

  private func resetPingTimer() {
    guard autoPingEnabled else { return }

    if let timer = self.pingTimer, timer.isValid{
      timer.invalidate()
    }

    self.pingTimer = Timer.scheduledTimer(withTimeInterval: self.pingTimerInterval, repeats: true, block: { [weak self] _ in
        self?.ping()
    })
  }

  func ping(data: Data = Data(), completion: (() -> Void)? = nil) {
    guard socketClient.connection else {
      log.info("Unable to send `ping`. Socket is not connected")
      return
    }

    if socketClient.connection {

      socketClient.sendFrame(command: <#T##String?#>, header: <#T##[String : String]?#>, body: <#T##AnyObject?#>)
      socketClient.sendJSONForDict(dict: <#T##AnyObject#>, toDestination: <#T##String#>)
      self.socket.write(ping: data, completion: completion)

      log.info("Ping...")

      self.resetPingTimer()
    }
  }
 }

// MARK: StompClientLibDelegate

 extension StompSocketManager: StompClientLibDelegate {

  public func stompClient(
    client: StompClientLib,
    didReceiveMessageWithJSONBody jsonBody: AnyObject?,
    akaStringBody stringBody: String?,
    withHeader header: [String: String]?,
    withDestination destination: String
  ) {
    log.info("↔️ destination : \(destination)")
    log.info("↔️ json body : \(String(describing: jsonBody))")
    log.info("↔️ string body : \(stringBody ?? "nil")")
  }

  /// Unsubscribe Topic
  public func stompClientDidDisconnect(client: StompClientLib) {
    log.info("↔️ Stomp socket is disconnected")
  }

  /// Subscribe Topic after Connection
  public func stompClientDidConnect(client: StompClientLib) {
    log.info("↔️ Stomp socket is connected")
    subscribe()
  }

  public func serverDidSendReceipt(client: StompClientLib, withReceiptId receiptId: String) {
    log.info("↔️ Did send receipt : \(receiptId)")
  }

  /// Error - disconnect and reconnect socket
  public func serverDidSendError(client: StompClientLib, withErrorMessage description: String, detailedErrorMessage message: String?) {
    log.info("↔️ Error send: \(description)")
    reconnect()
  }

  public func serverDidSendPing() {
    log.info("↔️ Server ping...")
  }
 }
