//
//  Route.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import Foundation

struct Route{
  let startLocationId : Int
  let nextLocationId  : Int

  let distance          : Double // meter
  
  // time(second) cost to go the next location.
  let timeToReachByWalk : Int?
  let timeToReachByCar  : Int?
  

  static var sampleRoutes : [Route] = [
    Route(
      startLocationId: Location.sampleStartPoint.id,
      nextLocationId: Location.sampleLocations[0].id,
      distance : 513, timeToReachByWalk: 15*60,
      timeToReachByCar: nil
    ),
    Route(
      startLocationId: Location.sampleLocations[0].id,
      nextLocationId: Location.sampleLocations[1].id,
      distance: 678, timeToReachByWalk: 22*60,
      timeToReachByCar: nil
    ),
    Route(
      startLocationId: Location.sampleLocations[1].id,
      nextLocationId: Location.sampleLocations[2].id,
      distance: 578, timeToReachByWalk: 19*60,
      timeToReachByCar: nil
    ),
    Route(
      startLocationId: Location.sampleLocations[2].id,
      nextLocationId: Location.sampleStartPoint.id,
      distance: 329, timeToReachByWalk: 7*60,
      timeToReachByCar: nil
    ),
  ]
}
