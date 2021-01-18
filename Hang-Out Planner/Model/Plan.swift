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
  let totalTimeByWalk : Int
  
  static var samplePlan = Plan(routes: Route.sampleRoutes, totalTimeByWalk: Route.sampleRoutes.reduce(0, {$0+$1.timeToReachByWalk}))
}
