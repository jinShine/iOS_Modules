//
//  LocationManager.swift
//  LocationModule
//
//  Created by buzz on 2021/07/13.
//

import CoreLocation
import Foundation
import RxCocoa
import RxSwift

public typealias CoreLocation = CLLocation

// MARK: - Possible Errors

enum LocationError: Error {
  case authorizationDenied
}

public class LocationManager: NSObject {

  /// Singleton
  public static let shared = LocationManager()

  // MARK: - Properties

  private let locationManager = CLLocationManager()

  public var running = BehaviorRelay<Bool>(value: false)
  public var didUpdateLocation = PublishSubject<(location: CLLocation?, error: Error?)>()

  // MARK: - Initialize

  override private init() {
    super.init()
  }

  deinit {
    stopUpdates()
  }
}

// MARK: - Helper methods

public extension LocationManager {

  func grantPermission() {
    let status = CLLocationManager.authorizationStatus()

    switch status {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
      startUpdates()
    case .restricted, .denied:
      didUpdateLocation.onNext((nil, LocationError.authorizationDenied))
    case .authorizedWhenInUse, .authorizedAlways:
      startUpdates()
    @unknown default:
      fatalError("LocationManager unknown error")
    }
  }

  func startUpdates() {
    locationManager.delegate = self
    locationManager.startUpdatingLocation()
    locationManager.pausesLocationUpdatesAutomatically = true
    locationManager.allowsBackgroundLocationUpdates = true
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.distanceFilter = kCLDistanceFilterNone
    running.accept(true)
  }

  func stopUpdates() {
    locationManager.delegate = nil
    locationManager.stopUpdatingLocation()
    locationManager.allowsBackgroundLocationUpdates = false
    running.accept(false)
  }

  func isAuthorizedPermission() -> Bool {
    let status = CLLocationManager.authorizationStatus()

    switch status {
    case .authorizedWhenInUse, .authorizedAlways:
      return true
    default:
      return false
    }
  }
}

// MARK: - Location manager delegate

extension LocationManager: CLLocationManagerDelegate {

  public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      running.accept(true)
      locationManager.startUpdatingLocation()
    default:
      running.accept(false)
      didUpdateLocation.onNext((nil, LocationError.authorizationDenied))
      locationManager.stopUpdatingLocation()
    }
  }

  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations.last
    didUpdateLocation.onNext((location, nil))
    log.debug(location ?? CLLocation())
  }

  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    didUpdateLocation.onNext((nil, error))
    log.error(error)
  }
}
