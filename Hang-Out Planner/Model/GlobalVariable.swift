//
//  GlobalVariable.swift
//  test
//
//  Created by Takayuki Yamaguchi on 2021-01-19.
//

import Foundation
import UIKit


// This is a debug switcher. if you turn on, it will use only sample data
var noMoreAPI = true

//var bgColor = UIColor.init(displayP3Red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
var bgColor = UIColor.systemBackground

var userCurrentLocation : Location = Location(
  id: 0,
  apiId: nil,
  category: .other,
  latitude: UserLocationController.shared.coordinatesMostRecent!.latitude as Double,
  longitude: UserLocationController.shared.coordinatesMostRecent!.longitude as Double,
  title: "Start",
  imageURL: nil,
  address: "",
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
