//
//  GlobalVariable.swift
//  test
//
//  Created by Takayuki Yamaguchi on 2021-01-19.
//

import Foundation

// ↓ This variable moves to UserLocationController.swift
//   This is to let UserLocationController keeps any info about user current coordinates data
//
//store GPS data (lat,long)
//var userCurrentCoordinates : (Double, Double)? = (
//  Location.sampleStartPoint.latitude,
//  Location.sampleStartPoint.longitude
//)

var userCurrentLocation : Location = Location(
  id: 0,
  apiId: nil,
  category: .other,
  latitude: UserLocationController.shared.coordinatesMostRecent!.latitude as Double,
  longitude: UserLocationController.shared.coordinatesMostRecent!.longitude as Double,
  title: "Your current location",
  imageURL: nil,
  address: "fill dynamic address",
  website: nil,
  rating: nil,
  reviewCount: nil,
  priceLevel: nil
)

var allLocations : [Location]  = []

// Store all routes between every locations.
var allRoutes : [[Double?]] = {
  // create allRoutes data wit nil
  var twoDArr  = Array(
    repeating: Array<Double?>(repeating: nil, count: allLocations.count), count: allLocations.count
  )
  return twoDArr
}()
