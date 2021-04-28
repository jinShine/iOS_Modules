//
//  PushManager.swift
//  PushManagerModule
//
//  Created by buzz on 2021/04/28.
//

import FirebaseMessaging
import UIKit
import UserNotifications

public class PushManager: NSObject {

  /// singleton
  public static let shared = PushManager()

  private var messaging: Messaging {
    return Messaging.messaging()
  }

  public var deviceToken: String?

  public func setup() {
    messaging.delegate = self
    let option: UNAuthorizationOptions = [.alert, .badge, .sound]
    let center = UNUserNotificationCenter.current()

    center.delegate = self
    center.requestAuthorization(options: option) { granted, error in
      if granted && error == nil {
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
    }
  }

  public func remoteNotificationDidRegister(deviceToken: Data) {
    messaging.apnsToken = deviceToken
    // Firebase를 사용중이기 때문에 Pass
    // self.deviceToken = deviceToken.map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
  }

  public func remoteNotificationDidFailToRegister() {
    deviceToken = nil
  }

  public func remoteNotification(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any]
  ) {
    didReceive(userInfo)
  }

  private func didReceive(_ userInfo: [AnyHashable: Any]) {
    log.debug(userInfo)
  }
}

extension PushManager: MessagingDelegate {

  public func messaging(
    _ messaging: Messaging,
    didReceiveRegistrationToken fcmToken: String?
  ) {
    log.debug("💸 Firebase registration token: \(fcmToken ?? "")")
    deviceToken = fcmToken
  }
}

extension PushManager: UNUserNotificationCenterDelegate {

  public func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    didReceive(notification.request.content.userInfo)
    completionHandler([.alert, .badge, .sound])
  }

  public func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    didReceive(response.notification.request.content.userInfo)
    completionHandler()
  }
}
