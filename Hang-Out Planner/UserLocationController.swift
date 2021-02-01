//
//  LocationManager.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-23.
//

import Foundation
import CoreLocation
import GLKit


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
  var coordinatesMostRecent: CLLocationCoordinate2D? {
    
    // Whenever user's coordinates has changed, automatically update userLocations
    didSet{
      //ignore if same coordinates, or you couldn't get any coordinates.
      if !hasUserMoved(){return}
      guard let lat = coordinatesMostRecent?.latitude,
            let long = coordinatesMostRecent?.longitude else {return}
      
      userCurrentLocation.latitude = lat
      userCurrentLocation.longitude = long
    }
  }
  
  // This is for avoiding duplicates of updating. If true, try no to update gain.
  var isUpdatingLocation: Bool = false
  
  
  
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
    isUpdatingLocation = true
    self.afterLocationUpdated = completion
    
  }
  
  /// Stop Start updating(tacking) user location
  func stop() {
    // if nothing started, do nothing. This is important. Without this, it will cause an error at scene dissapper.
    if !isUpdatingLocation{return}
    locationManager.stopUpdatingLocation()
    isUpdatingLocation = false
  }
  
  // Whenever `startUpdatingLocation()` gets active
  // or after that, whenever user location is updated, this func is called.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    // If you can get current location, update it
    guard let currentLocation = locations.last else {
      print("couldn't!!!")
      return
      
    }
    coordinatesMostRecent = currentLocation.coordinate
    
    // If you have a completion handler, call it.
    guard let completion = self.afterLocationUpdated else {return}
    completion()
    
    
  }
  
  // Error handling. This will be called when unable to retrieve a location value.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    alterFetchLocaition(manager, error: error)
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    alterFetchLocaition(manager, error: nil)
  }
  
  func alterFetchLocaition(_ manager: CLLocationManager, error: Error?) {
    let status = manager.authorizationStatus
    if status == .denied || status == .restricted || status == .notDetermined{
      
      //If user denies or remained answering, try to get location by ip address
      fetchUserLocationsFromIP(completion: { [weak self] result in
        switch result{
        case .success(let location):
          
          self?.coordinatesMostRecent =  CLLocationCoordinate2D(latitude:  location.latitude, longitude: location.longitude)
          
          userCurrentLocation.address = "\(location.country_name) \(location.region) \(location.city) \(location.postal)"
          // After succeeding fetching location && `afterLocationUpdated` is prepared,
          // invoke it == update map and address.
          guard let afterLocationUpdated = self?.afterLocationUpdated else {return}
          DispatchQueue.main.async {
            afterLocationUpdated()
          }
        case .failure(let error):
          print(error)
        }
      })
    }else{
      if let error = error{
        print("fatal error: \(error)")
      }
    }
  }
  
  
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
  
  
  func getCurrentAddress(completion: @escaping ((String) -> Void)){
    var address = ""
    
    // Use coordinatesMostRecent instead of location manager.location
    // this is because it also has coordinates fetched by IP
    guard let coordinates = coordinatesMostRecent else {return}
    let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
    //      show current address
    CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
      
      guard
        let placemark = placemarks?.first, error == nil,
        let administrativeArea = placemark.administrativeArea,
        let locality = placemark.locality,
        let thoroughfare = placemark.thoroughfare,
        let subThoroughfare = placemark.subThoroughfare
      else {
        completion(" ")
        return
      }
      address = "\(administrativeArea) \(locality) \(thoroughfare) \(subThoroughfare)"
      completion(address)
      
      return
    }
    
  }
  
  
  /*
   * calculate the center point of multiple latitude longitude coordinate-pairs
   contributed by `https://github.com/ppoh71/playgounds/blob/master/centerLocationPoint.playground/Contents.swift`
   */
  // center func
  func getCenterCoord( LocationPoints: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D{
    
    var x:Float = 0.0
    var y:Float = 0.0
    var z:Float = 0.0
    
    for points in LocationPoints {
      
      let lat = GLKMathDegreesToRadians(Float(points.latitude))
      let long = GLKMathDegreesToRadians(Float(points.longitude))
      
      x += cos(lat) * cos(long)
      y += cos(lat) * sin(long)
      z += sin(lat)
    }
    
    x = x / Float(LocationPoints.count)
    y = y / Float(LocationPoints.count)
    z = z / Float(LocationPoints.count)
    
    let resultLong = atan2(y, x)
    let resultHyp = sqrt(x * x + y * y)
    let resultLat = atan2(z, resultHyp)
    
    let result = CLLocationCoordinate2D(latitude: CLLocationDegrees(GLKMathRadiansToDegrees(Float(resultLat))), longitude: CLLocationDegrees(GLKMathRadiansToDegrees(Float(resultLong))))
    
    return result
    
    
  }
  
  
  
  
  
  func fetchUserLocationsFromIP(completion: @escaping ((Result<ipLocation, Error>) -> Void)) {
    
    // Prepare base url
    let baseURL = URL(string: "https://ipapi.co/json/")!
    
    // Create request from url
    var request = URLRequest(url: baseURL)
    
    // Attach header info
    request.httpMethod = "GET"
    
    
    // This is async. Send request and pass respond to completion func.
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      
      // Error handling. If you couldn't get data and find error, pass to completion.
      guard let data = data else{
        if let error = error{ completion(.failure(error))}
        return
      }
      
      // Parse JSON into `[YelpLocation]` and send it completion.
      let jsonDecoder = JSONDecoder()
      do {
        let res = try jsonDecoder.decode(ipLocation.self, from: data)
        completion(.success(res))
      }catch{
        completion(.failure(error))
      }
      
    }.resume()
  }
  
  
  struct ipLocation: Codable{
    var latitude : Double
    var longitude: Double
    var country_name : String
    var region : String
    var city : String
    var postal : String
  }
  
  
  
  
  
}


