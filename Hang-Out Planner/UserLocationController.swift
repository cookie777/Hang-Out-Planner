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
  let locationManager : CLLocationManager
  var afterLocationUpdated : (()->Void)?
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
    }else{
      print("fatal error: \(error)")
    }
  }
  
  // If user denied using their location, we set some default location.
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    
    let status = manager.authorizationStatus
    if status == .denied || status == .restricted || status == .notDetermined{
      
      coordinatesMostRecent = CLLocationCoordinate2D(latitude: Location.sampleStartPoint.latitude, longitude: Location.sampleStartPoint.longitude)
    }
    
  }
  
  func hasUserMoved() -> Bool {
    
    guard let cA = coordinatesLastTimeYouTappedGo,
          let cB = coordinatesMostRecent else { return true}
    
    if cA.latitude != cB.latitude {return true}
    if cA.longitude != cB.longitude {return true}

    return false
  }
  
}
