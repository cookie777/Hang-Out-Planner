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
  
}
