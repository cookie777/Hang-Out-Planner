//
//  User.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-04-05.
//

import Foundation

struct User {
  static var userLocation : Location = Location(
    id: 0,
    apiId: nil,
    category: .other,
    latitude: (LocationController.shared.coordinatesOfMostRecent?.latitude ?? 0) as Double,
    longitude: (LocationController.shared.coordinatesOfMostRecent?.longitude ?? 0) as Double,
    title: "Start",
    imageURL: nil,
    address: "",
    website: nil,
    rating: nil,
    reviewCount: nil,
    priceLevel: nil
  )
  
  /// All locations based on categories on user choice are stored here.
  /// There are top N locations for each category.
  /// This variable will reset when condition as follows.
  /// - When user changes the order or number of categories
  /// - When user's location has changed
  /// - App is closed.
  static var allLocations : [Location]  = []
  
  /// All routes (distances) between `allLocations` are stored here.
  static var allRoutes : [[Double?]] = {
    // create allRoutes data wit nil
    var arr  = Array(
      repeating: Array<Double?>(repeating: nil, count: allLocations.count), count: allLocations.count
    )
    return arr
  }()

}
