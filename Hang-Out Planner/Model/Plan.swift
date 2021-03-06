//
//  Plan.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import Foundation

/// var plans : [Plan]
struct Plan {
  let routes    : [Route]
  let destinationIdList: [Int] // id of location. The Order == where to go next
  
  let totalDistance   : Double //meter
  
  // These two time will be estimated not from api, but just from simple calculate using average speed.
  // Ideally, we can get from mapkit but there is an api limitation. So this time, don't use it.
  let totalTimeByWalk : Int? // second
  let totalTimeByCar  : Int? // second
  
  // every thing is average in all location in the plan. (except current user point.)
  let averageRating: Double
  let averageReviewCount: Double
  let averagePriceLevel: Double
  let averageRecommendation: Double? // not absolute, might not use
}

extension Plan: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(routes)
    hasher.combine(destinationIdList)
  }
  
  static func == (lhs: Plan, rhs: Plan) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}



// MARK: - Sample data

extension Plan {
  //  static var samplePlan = Plan(routes: Route.sampleRoutes, destinationList: [0,1,2,3,0], totalDistance: Route.sampleRoutes.reduce(0, {$0+$1.distance}), totalTimeByWalk: Route.sampleRoutes.reduce(0, {$0+$1.timeToReachByWalk!}),totalTimeByCar: nil)
}
