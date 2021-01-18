//
//  Route.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import Foundation

struct Route{
  let startLocationId : String
  let nextLocationId: String //Last location points to the first location.
  
  // time(minutes) cost (by walk) to go the next location.
  // if we can get time by bike or car, we will add more variables here
  let timeToReachByWalk       : Int

  static var sampleRoutes : [Route] = [
    Route(
      startLocationId: Location.sampleStartPoint.id,
      nextLocationId: Location.sampleLocations[0].id,
      timeToReachByWalk: 15
    ),
    Route(
      startLocationId: Location.sampleLocations[0].id,
      nextLocationId: Location.sampleLocations[1].id,
      timeToReachByWalk: 22
    ),
    Route(
      startLocationId: Location.sampleLocations[1].id,
      nextLocationId: Location.sampleLocations[2].id,
      timeToReachByWalk: 19
    ),
    Route(
      startLocationId: Location.sampleLocations[2].id,
      nextLocationId: Location.sampleStartPoint.id,
      timeToReachByWalk: 7
    ),
  ]
}
