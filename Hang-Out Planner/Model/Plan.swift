//
//  Plan.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import Foundation

/// var plans : [Plan]
struct Plan{
  let routes    : [Route]
  let destinationList: [Int] // id of location. The Order == where to go next
  
  let totalDistance   : Double //meter
  
  let totalTimeByWalk : Int? // second
  let totalTimeByCar  : Int? // second
 

  static var samplePlan = Plan(routes: Route.sampleRoutes, destinationList: [0,1,2,3,0], totalDistance: Route.sampleRoutes.reduce(0, {$0+$1.distance}), totalTimeByWalk: Route.sampleRoutes.reduce(0, {$0+$1.timeToReachByWalk!}),totalTimeByCar: nil)
}
