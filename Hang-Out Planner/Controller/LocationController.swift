//
//  LocationManager.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-23.
//

import CoreLocation
import GLKit


// MARK: - Basics

/// This class manages user's location. Singleton.  Please use `shared`
class LocationController: NSObject, CLLocationManagerDelegate {
  static let shared = LocationController()
  
  // This is the core variable that keeps user's location
  let locationManager : CLLocationManager
  // function that is invoked whenever user's location has changed.
  var completionDidLocationUpdated : (()->Void)?
  
  // These vars are for reducing api-request.
  // If both are same == user hasn't moved, we don;t do fetch location data,
  // and instead, we just use previous `allLocations`
  var coordinatesOfLastTimeTappedGo : CLLocationCoordinate2D?
  var coordinatesOfMostRecent: CLLocationCoordinate2D? {
    // Whenever user's coordinates has changed, automatically update userLocations
    didSet{
      //ignore if same coordinates, or you couldn't get any coordinates.
      if !hasUserMoved(){return}
      guard let lat = coordinatesOfMostRecent?.latitude,
            let long = coordinatesOfMostRecent?.longitude else {return}

      User.userLocation.latitude = lat
      User.userLocation.longitude = long
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
}


// MARK: - User tracking (Fetching location by CoreLocation)

extension LocationController {
  /// Start updating(tacking) user location
  /// - Parameter completion: an action you want to do when the user location is updated.
  func start(completion : @escaping(()->Void)) {
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
    isUpdatingLocation = true
    self.completionDidLocationUpdated = completion
  }
  
  /// Stop "updating(tacking) user location"
  func stop() {
    // if nothing started, do nothing. This is important. Without this, it will cause an error at scene dissapper.
    if !isUpdatingLocation{return}
    locationManager.stopUpdatingLocation()
    isUpdatingLocation = false
  }
  
  // `didUpdateLocations`. This func is called when user location is updated.
  // The detail timing is as follow
  // - when `startUpdatingLocation()` is called
  // - or after that, whenever user location is updated
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // If you can get current location, update it
    guard let currentLocation = locations.last else {
      print("Error: Failed to get user location")
      return
    }
    coordinatesOfMostRecent = currentLocation.coordinate
    
    // If you have a completion handler, call it.
    guard let completion = self.completionDidLocationUpdated else {return}
    completion()
  }
}


// MARK: - Error and denial handling

extension LocationController {
  // Error handling. This will be called when unable to retrieve a location value.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    updateLocationByIpAddress(manager, error: error)
  }
  // When authorization is changed, this function is called.
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    updateLocationByIpAddress(manager, error: nil)
  }
}


// MARK: - Fetching location by IP

extension LocationController {
  struct ipLocation: Codable{
    var latitude : Double
    var longitude: Double
    var country_name : String
    var region : String
    var city : String
    var postal : String
  }
  
  /// Try to fetch user location (coordinates) by IP address
  /// - Parameter completion: what you want to do after fetching
  private func fetchUserLocationsByIP(completion: @escaping ((Result<ipLocation, Error>) -> Void)) {
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
  
  /// Try to update location(coordinate) by IP address if user denies or remained answering
  /// - Parameters:
  ///   - manager: location manager
  ///   - error:
  private func updateLocationByIpAddress(_ manager: CLLocationManager, error: Error?) {
    let status = manager.authorizationStatus
    if status == .denied || status == .restricted || status == .notDetermined{
      fetchUserLocationsByIP(completion: { [weak self] result in
        switch result{
          case .success(let location):
            self?.coordinatesOfMostRecent =  CLLocationCoordinate2D(latitude:  location.latitude, longitude: location.longitude)
            
            User.userLocation.address = "\(location.country_name) \(location.region) \(location.city) \(location.postal)"
            // After succeeding fetching location && `afterLocationUpdated` is prepared,　invoke it == update map and address.
            guard let completionDidLocationUpdated = self?.completionDidLocationUpdated else {return}
            DispatchQueue.main.async {
              completionDidLocationUpdated()
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
}


// MARK: - Helper functions

extension LocationController {
  /// Generate address from most recent coordinate.
  /// - Parameter completion: Generated address will be passed as `String` argument of completion.
  func generateRecentAddress(completion: @escaping ((String) -> Void)){
    var address = ""
    // Try to use `coordinatesMostRecent` instead of `location manager.location`
    // this is because it also gets coordinates fetched by IP
    guard let coordinates = coordinatesOfMostRecent else {return}
    let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
    //  Display current address
    CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
      guard
        let placemark = placemarks?.first, error == nil
      else {
        completion(" ")
        return
      }
      //      let postalCode = placemark.postalCode ?? ""
      let administrativeArea = placemark.administrativeArea ?? ""
      let locality = placemark.locality ?? ""
      let thoroughfare = placemark.thoroughfare ?? ""
      let subThoroughfare = placemark.subThoroughfare ?? ""
      //      let name = placemark.name ?? ""
      
      address = "\(subThoroughfare) \(thoroughfare), \(locality), \(administrativeArea)"
      completion(address)
      return
    }
  }
  
  /// Return if user has moved (user's coordinates has changed)
  /// - Returns: true -> moved, false -> same place
  func hasUserMoved() -> Bool {
    
    // First time, coordinatesLastTimeYouTappedGo is nil
    guard let cA = coordinatesOfLastTimeTappedGo,
          let cB = coordinatesOfMostRecent else { return true}
    
    if cA.latitude != cB.latitude {return true}
    if cA.longitude != cB.longitude {return true}
    
    return false
  }
  
  /// Calculate the center point of multiple coordinate-pairs.
  /// [Contributed by](https://github.com/ppoh71/playgounds/blob/master/centerLocationPoint.playground/Contents.swift)
  /// - Parameter LocationPoints: array of coordinates.
  /// - Returns: center of coordinates
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
}
