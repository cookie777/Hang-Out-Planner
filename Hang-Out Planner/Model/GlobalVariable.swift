//
//  GlobalVariable.swift
//  test
//
//  Created by Takayuki Yamaguchi on 2021-01-19.
//

import Foundation

//store GPS data (lat,long)
var userCurrentCoordinates : (Double, Double)? = (Location.sampleStartPoint.latitude,Location.sampleStartPoint.longitude)

var userCurrentLocation : Location = Location(
  id: 0,
  apiId: nil,
  category: .other,
  latitude: userCurrentCoordinates!.0,
  longitude: userCurrentCoordinates!.1,
  title: "",
  imageURL: nil,
  address: Location.sampleStartPoint.address,
  website: nil,
  rating: nil
)

var allLocations  = [userCurrentLocation] + Location.sampleLocations

// Store all routes between every locations.
var allRoutes : [[Double?]] = {
  // create allRoutes data wit nil
  var twoDArr  = Array(
    repeating: Array<Double?>(repeating: nil, count: allLocations.count), count: allLocations.count
  )
  return twoDArr
}()
