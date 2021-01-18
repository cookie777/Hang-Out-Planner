//
//  Plan.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import Foundation

/*
 
 eg. var plans : [Plan]
 */
struct Plan{
  let routes    : [Route] = []
  let totalTimeByWalk : Int = 0
  
  static var samplePlan : [Route] = [
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
