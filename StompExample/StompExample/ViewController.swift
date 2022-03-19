//
//  ViewController.swift
//  StompExample
//
//  Created by buzz on 2021/11/02.
//

import UIKit
import StompClientLib

class ViewController: UIViewController {


  // qa
  let urlString = "ws://qa-acquisition.socket.lific.net/acquisition-ws-stomp/websocket"

  // dev
//  let urlString = "ws://dev-acquisition.socket.lific.net/acquisition-ws-stomp/websocket"

  let intervalSec = 1.0
  let socketClient = StompClientLib()


  override func viewDidLoad() {
    super.viewDidLoad()

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
//    registerSocket()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    registerSocket()
  }

  func registerSocket() {
    let url = NSURL(string: urlString)

//    if socketClient.isConnected() {
//      socketClient.disconnect()
//    }


    socketClient.openSocketWithURLRequest(
      request: NSURLRequest(url: url! as URL),
      delegate: self,
      connectionHeaders: [
        "Lific-Api-Version" : "consumer",
        "Lific-Access-Token" : "eyJ0eXAiOiJKV1QiLCJtZW1iZXJUeXBlIjoiQ09OU1VNRVIiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlblBvbGljeVZlcnNpb24iOiJ2MSIsImV4cGlyZWRBdCI6IjIwMjItMDMtMTdUMTU6NDU6MDQiLCJtZW1iZXJVaWQiOjI3NSwibWVtYmVySWQiOiJna3RtZHdsczEzNDZAaWNsb3VkLmNvbSJ9.8Cmn6G_vGB4MEkBeCcbuIZIm0spZfXf81u5OSQF_jY0",
        "Lific-Refresh-Token" : "eyJ0eXAiOiJKV1QiLCJtZW1iZXJUeXBlIjoiQ09OU1VNRVIiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlblBvbGljeVZlcnNpb24iOiJ2MSIsImV4cGlyZWRBdCI6IjIwMjItMDMtMjRUMTU6MDg6NDEiLCJtZW1iZXJVaWQiOjI3NSwibWVtYmVySWQiOiJna3RtZHdsczEzNDZAaWNsb3VkLmNvbSJ9.TPfHjXHhceYYKjrZo1suKUG311YdWK7IYVT1bSY91vQ",
      ]
    )
  }

  func subscribe() {
    socketClient.subscribe(destination: "/acquisition/queue/reservation/badge/consumer/1")
  }
}

extension ViewController: StompClientLibDelegate {
  func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
    print("DESTIONATION : \(destination)")
    print("JSON BODY : \(String(describing: jsonBody))")
    print("STRING BODY : \(stringBody ?? "nil")")
  }

  func serverDidSendPing() {
    print("serverDidSendPing")
  }

  func stompClientDidDisconnect(client: StompClientLib!) {
    print("stompClientDidDisconnect")
  }

  func stompClientDidConnect(client: StompClientLib!) {
    print("stompClientDidConnect")
    subscribe()
  }

  func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
    print("Receipt : \(receiptId)")
  }

  func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
    print("Error Send : \(String(describing: message))")
    print("Error Send : \(String(describing: description))")
    print("Error Send : \(String(describing: client.description))")
//    if !soketClient.isConnected() {
//      reconnect()
//    }

//    socketClient.disconnect()
//    socketClient = nil
//    registerSocket()
  }
}

