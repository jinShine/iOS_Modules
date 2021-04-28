//
//  AppDelegate+Push.swift
//  PushManagerModule
//
//  Created by buzz on 2021/04/28.
//

import Common
import UIKit

extension AppDelegate {

  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Application.shared.pushManager.remoteNotificationDidRegister(deviceToken: deviceToken)
  }

  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    Application.shared.pushManager.remoteNotification(
      application,
      didReceiveRemoteNotification: userInfo
    )
    completionHandler(UIBackgroundFetchResult.newData)
  }

  func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    log.debug(error)
    Application.shared.pushManager.remoteNotificationDidFailToRegister()
  }
}
