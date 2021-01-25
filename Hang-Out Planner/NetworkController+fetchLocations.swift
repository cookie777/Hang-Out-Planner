//
//  NetworkController+fetchLocations.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-24.
//

import Foundation


extension NetworkController{
  // Getting the apiKey from plist
  private func getAPIKey()->String{
    var apiKey: String {
      get {
        guard let filePath = Bundle.main.path(forResource: "yelp-Info", ofType: "plist") else {
          fatalError("Couldn't find file 'yelp-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
          fatalError("Couldn't find key 'API_KEY' in 'yelp-Info.plist'.")
        }
        return value
      }
    }
    return apiKey
  }
  
  
  
  /// Create all locations by fetching yelp-api.
  /// - Created data will be store as `allLocations`
  /// - Parameter completion: after created, what do want to do?
  func createAllLocations(completion: @escaping () -> Void ){
    
    // This is to execute calculating routes and plans after "all fetch are done"
    let group = DispatchGroup()
    
    // Delete all cache
    NetworkController.shared.tempAllLocations.removeAll()
    
    //Fetch TopN locations in each(five) category
    group.enter()
    NetworkController.shared.fetchLocations(
      group : group,
      category:CategoriesForAPI.amusement,
      completion: NetworkController.shared.convertAndStoreLocation
    )
    group.enter()
    NetworkController.shared.fetchLocations(
      group : group,
      category:CategoriesForAPI.cafe,
      completion: NetworkController.shared.convertAndStoreLocation
    )
    group.enter()
    NetworkController.shared.fetchLocations(
      group : group,
      category:CategoriesForAPI.clothes,
      completion: NetworkController.shared.convertAndStoreLocation
    )
    group.enter()
    NetworkController.shared.fetchLocations(
      group : group,
      category:CategoriesForAPI.artAndGallery,
      completion: NetworkController.shared.convertAndStoreLocation
    )
    group.enter()
    NetworkController.shared.fetchLocations(
      group : group,
      category:CategoriesForAPI.park,
      completion: NetworkController.shared.convertAndStoreLocation
    )
    
    
    // This is executed after "all fetch are done"
    group.notify(queue: .main) {
      
      // Creating final locations with adding user location and assigning id.
      allLocations = [userCurrentLocation] + NetworkController.shared.tempAllLocations
      (0..<allLocations.count).forEach{allLocations[$0].id = $0}
      // Remove temp data for memory saving.
      NetworkController.shared.tempAllLocations.removeAll()
      
      completion()
      
    }
  }
  
  

  
  
  /// Fetch locations from yelp API.
  /// ## Flow overview :
  /// Fetch locations data from yelp -> pass respond `[yelpLocation]` to completion -> parse data into `[Location]` -> store it to `tempLocations` -> add user location and set all id -> store to `allLocations` -> rest `tempLocations`
  /// - Parameters:
  ///   - group: Dispatch group to await fetch is finished
  ///   - category: what category do you want to fetch?
  ///   - completion: pass respond to this. Inside, it will parse and store data to `tempLocations`
  func fetchLocations(group : DispatchGroup, category : CategoriesForAPI, completion: @escaping ((Result<[YelpLocation], Error>, CategoriesForAPI) -> Void)) {
    
    let apiKey = getAPIKey()
    
    // Prepare base url
    let baseURL = URL(string: "https://api.yelp.com/v3/businesses/search")!
    
    // Create url component so that you can easily attach your query
    var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
    
    // Query parameters. This will be like ? key0=value0 & key1=value1 ...
    // Use user coordinates fetched from GPS
    let lat =  UserLocationController.shared.coordinatesMostRecent!.latitude as Double// later fix. set some default coordinate
    let long = UserLocationController.shared.coordinatesMostRecent!.longitude as Double// later fix.
    // Search area n meter from coordinates.
    let radius = 10_000
    let queryParameters = [
      "latitude": "\(lat)",
      "longitude": "\(long)",
      "radius" : "\(radius)",
      "categories" : category.rawValue,
      //      "price": "1,2,3,4"  later option. if user select price, use this.
    ]
    
    // Set parameters to url component
    urlComponents.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    
    // get final url for request from url component
    let requestURL = urlComponents.url!
    
    // Create request from url
    var request = URLRequest(url: requestURL)
    // Attach header info, apiKey, method...
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "GET"
    
    
    // This is async. Send request and pass respond to completion func.
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      
      // Error handling. If you couldn't get data and find error, pass to completion.
      guard let data = data else{
        if let error = error{ completion(.failure(error),category)}
        return
      }
      
      // Parse JSON into `[YelpLocation]` and send it completion.
      let jsonDecoder = JSONDecoder()
      do {
        let yelpResponse = try jsonDecoder.decode(YelpFields.self, from: data)
        completion(.success(yelpResponse.businesses), category)
      }catch{
        completion(.failure(error),category)
      }
      
      // Tell DispatchGroup that I'm done.
      group.leave()
    }.resume()
  }
  
  
  /// Completion handler. Convert `[YelpLocation]` into `[Location]`
  /// Usually, it's closure but it's large so I defined as func.
  /// - Parameters:
  ///   - result: from `fetchLocations`. If success, [YelpLocation] will come.
  ///   - category: To set `Locations` category.
  func convertAndStoreLocation(result: Result<[YelpLocation],Error>, category: CategoriesForAPI) {
    switch result{
    case .success(let yelpLocations):
      convertAndStoreLocationHelper(yelpLocations, category)
    case .failure(let error):
      print(error)
    }
  }
  
  
  func convertAndStoreLocationHelper(_ yelpLocations: [YelpLocation],_ category: CategoriesForAPI) {
    
    var topNLocations: [Location] = []
    var yelpLocations = yelpLocations // waste of memory?
    
    while (topNLocations.count < 5 && yelpLocations.count > 0) {
      let yl = yelpLocations.removeFirst()
      
      // Filter: not to add
      // 1. the location is closed permanently
      // 2. the location is already exits in stored data
      if yl.isClosed{continue}
      if tempAllLocations.contains(where: {$0.apiId == yl.apiId}){continue}
      
      let l : Location = Location(
        id: -1,
        apiId: yl.apiId,
        category: {
          switch category{
          case .amusement     : return .amusement
          case .artAndGallery : return .restaurant
          case .cafe          : return .cafe
          case .park          : return .park
          case .clothes       : return .clothes
          }
        }(),
        latitude: yl.coordinates.latitude,
        longitude: yl.coordinates.longitude,
        title: yl.title,
        imageURL: yl.imageURL,
        address: yl.address?.display_address.joined(separator: ", ") ?? "",
        website: yl.website,
        rating: yl.rating,
        reviewCount: yl.reviewCount,
        priceLevel: {
          switch yl.priceLevel{
          case "$": return 1
          case "$$": return 2
          case "$$$": return 3
          case "$$$$": return 4
          default: return nil
          }
        }()
      )
      topNLocations.append(l)
    }
    
    tempAllLocations.append(contentsOf: topNLocations)
    
  }
  
  
  // MARK: - Decode struct for JSON parsing.
  struct YelpFields: Codable {
    var businesses : [YelpLocation]
    
  }
  struct YelpLocation: Codable {
    var title    : String
    var apiId      : String
    var isClosed    : Bool
    var coordinates : coordinates
    var imageURL : String
    var rating  : Double?
    var reviewCount : Int
    var priceLevel   : String?
    var website     : String
    var address : Address?
    
    struct coordinates : Codable {
      var latitude: Double
      var longitude: Double
    }
    
    struct Address: Codable {
      var display_address : [String]
    }
    
    enum CodingKeys: String, CodingKey {
      case title          = "name"
      case apiId          = "id"
      case isClosed       = "is_closed"
      case coordinates
      case imageURL       = "image_url"
      case rating
      case reviewCount    = "review_count"
      case priceLevel     = "price"
      case website        = "url"
      case address        = "location"
    }
    
  }
}



// Func for debug, printing
extension NetworkController{
  
  // print `[Location]`
  func printLocations(locations: [Location]) {
    
    for l in locations{
      print("""

        apiId      : \(l.id)
        latitude: \(l.latitude)
        longitude: \(l.longitude)
        name    : \(l.title)
        image_url : \(l.imageURL ?? "")
        web_url     : \(l.website ?? "")
        rating  : \(String(describing: l.rating))
        review_count : \(String(describing: l.reviewCount))
        priceLevel   : \(String(describing: l.priceLevel))
        category   : \(l.category)
        address: \(l.address)

      """)
    }
  }
  
  
  // print `[Location]`
  func printPlans(plans: [Plan]) {

    for l in plans{
      print("""

      Plan info -------------

        TotalDistance : \(l.totalDistance)
        TotalDistance : \(l.totalDistance)
        AveRating     : \(l.averageRating)
        AveReviewCount: \(l.averageReviewCount)
        AvePriceLevel : \(l.averagePriceLevel)
      """)
      l.routes.forEach { (route) in
        print("""

              [ Route   :
                StartId : \(route.startLocationId) <----> NextId  : \(route.nextLocationId)
                Distance is : \(route.distance) m ]

        """)
      }
      print("""
        ------------------------




      """)
    }
  }

  
}
