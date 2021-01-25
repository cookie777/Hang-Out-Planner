//
//  LocationManager.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-23.
//

import Foundation
import CoreLocation


/// This class manages user's location. Singleton.  Please use `shared`
class UserLocationController: NSObject, CLLocationManagerDelegate {
  static let shared = UserLocationController()
  
  // This is the core variable that keeps user's location
  let locationManager : CLLocationManager
  // function that is invoked whenever user's location has changed.
  var afterLocationUpdated : (()->Void)?
  
  // These vars are for reducing api-request.
  // If both are same == user hasn't moved, we don;t do fetch location data,
  // and instead, we just use previous `allLocations`
  var coordinatesLastTimeYouTappedGo : CLLocationCoordinate2D?
  var coordinatesMostRecent: CLLocationCoordinate2D?

  
  
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
    //    locationManager.requestWhenInUseAuthorization()
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
    coordinatesMostRecent = currentLocation.coordinate
    
    // If you have a completion handler, call it.
    guard let completion = self.afterLocationUpdated else {return}
    completion()
    
  }
  
  // Error handling. This will be called when unable to retrieve a location value.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    let status = manager.authorizationStatus
    if status == .denied || status == .restricted || status == .notDetermined{
      print("This message is shown when user haven't allow using location data. So the current location might be nil. Don't worry")
      
      // set default location. fix better one later.
        coordinatesMostRecent = CLLocationCoordinate2D(latitude: Location.sampleStartPoint.latitude, longitude: Location.sampleStartPoint.longitude)
    }else{
      print("fatal error: \(error)")
    }
  }
  
//  // If user denied using their location, we set some default location.
//  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//
//    let status = manager.authorizationStatus
//    if status == .denied || status == .restricted || status == .notDetermined{
//
//      coordinatesMostRecent = CLLocationCoordinate2D(latitude: Location.sampleStartPoint.latitude, longitude: Location.sampleStartPoint.longitude)
//    }
//
//  }
  
  
  /// Return if user has moved (user's coordinates has changed)
  /// - Returns: true -> moved, false -> same place
  func hasUserMoved() -> Bool {
    
    // First time, coordinatesLastTimeYouTappedGo is nil
    guard let cA = coordinatesLastTimeYouTappedGo,
          let cB = coordinatesMostRecent else { return true}
    
    if cA.latitude != cB.latitude {return true}
    if cA.longitude != cB.longitude {return true}

    return false
  }
  
}
