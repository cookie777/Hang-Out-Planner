//
//  LocationManager.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
  static let shared = LocationManager()
  private let locationManager : CLLocationManager
  private var afterLocationUpdated : (()->Void)?
  
  private override init() {
    // create only one locationManager
    locationManager = CLLocationManager()
    // make it more accurate
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
    super.init()
    locationManager.delegate = self
  }
  
  /// Start updating(tacking) user location
  /// - Parameter completion: an action you want to do when the user location is updated.
  func start(completion : @escaping(()->Void)) {
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
    self.afterLocationUpdated = completion
  }
  
  /// Stop Start updating(tacking) user location
  func stop() {
    locationManager.stopUpdatingLocation()
  }
  
  // While `start` && user location is updated, this func is called.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    // If you can get current location, update it
    guard let currentLocation = locations.last else {return}
    userCurrentCoordinates = (currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
    
    // If you have a completion handler, call it.
    guard let completion = self.afterLocationUpdated else {return}
    completion()
    
  }
  
  
  
  
  // Error handling. This will be called when unable to retrieve a location value.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
    locationManager.stopUpdatingLocation()
  }
  
  // If user denied using their location, we set some default location.
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    
    let status = manager.authorizationStatus
    if status == .denied || status == .restricted || status == .notDetermined{
      userCurrentCoordinates = (
        Location.sampleStartPoint.latitude,
        Location.sampleStartPoint.longitude
      )
    }
    
  }
  
}
