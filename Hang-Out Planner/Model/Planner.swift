//
//  Planner.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import Foundation
import MapKit


class Planner {
  
  // MARK: - Server-side pre-calculation
  // These process should be server-side beforehand, but right now I temporarily do it at here.
  // Calculate every routes between locations, except user's current location.
  
  
  /// Calculate all Routes between location, except user stating point.
  /// This should be done in server before hand. Now I do this temporarily at app side.
  static func calculateRoutesAtServer(){
    
    let numOfLocations = allLocations.count
    
    // fill all routes without starting point
    // TODO: fix this algorithm, prepare own all Locations and calDistance
    for si in 1..<numOfLocations{
      for ei in 1..<numOfLocations{
        // I can reduce here.
        allRoutes[si][ei] = calculateDistance(startId: si, endId: ei)
      }
    }
  }

  
  
  
  

  // MARK: - App-side pre-calculation.
  // We calculate each routes between current user location and every locations.
  
  ///Calculate distance between start-end. it will return meter.
  static func calculateDistance(startId: Int, endId: Int)->Double{
    let start = allLocations[startId]
    let end = allLocations[endId]
    let coordinateStart = CLLocation(latitude: start.latitude, longitude: start.longitude)
    let coordinateEnd = CLLocation(latitude: end.latitude, longitude: end.longitude)
    let distanceInMeters = coordinateStart.distance(from: coordinateEnd)
    return distanceInMeters
  }
  
  /// Calculate and store routes between user and every location.
  static func calculateRoutesBetweenUser(){
    // create allRoutes data wit nil
    let numOfLocations = allLocations.count
    
    // calculate from user-current-location to each locations.
    for i in 0..<numOfLocations{
      let distance = calculateDistance(startId: 0, endId: i)
      allRoutes[0][i] = distance
      allRoutes[i][0] = distance
    }
  }
  

  
  
  // MARK: - App-side plan generating
  static func calculatePlans(categories: [Categories]) -> [Plan]{
    
    var locationCandidates : [[Int]] = []
    for category in categories{
      let l = (allLocations.filter {$0.category == category}).map {$0.id}
      locationCandidates.append(l)
    }

    let planCandidates = generatePlanCandidates(locationCandidates)
//    print(planCandidates)
    let topNPlans =  selectTopNPlans(plans: planCandidates)
    return topNPlans
  }
  
  
  /*
   [[0, 5, 1, 9, 0], [0, 5, 1, 10, 0], [0, 5, 2, 9, 0], [0, 5, 2, 10, 0], [0, 5, 3, 9, 0], [0, 5, 3, 10, 0], [0, 5, 4, 9, 0], [0, 5, 4, 10, 0], [0, 7, 1, 9, 0], [0, 7, 1, 10, 0], [0, 7, 2, 9, 0], [0, 7, 2, 10, 0], [0, 7, 3, 9, 0], [0, 7, 3, 10, 0], [0, 7, 4, 9, 0], [0, 7, 4, 10, 0]]
   */
  static func generatePlanCandidates(_ locationCandidates:[[Int]]) -> [[Int]]{
    var currentPlan = [[0]] // 0 as first location
    
    for nextLocation in locationCandidates{
      currentPlan = generatePairs(start: currentPlan, end: nextLocation)
    }

    currentPlan = currentPlan.map{$0 + [0]} // add 0(as last location)
    return currentPlan
  }
  

  /*
   creates pare like [[5],[7]] * [1,2,3,4] -> [[5, 1], [5, 2], [5, 3], [5, 4], [7, 1], [7, 2], [7, 3], [7, 4]]
   
   if there is a duplicate, don' add. [[5],[7]] * [3,5] -> [[5,3], [7,3],[7,5]]
   */
  static func generatePairs(start:[[Int]], end:[Int])->[[Int]]{
    
    var r:[[Int]] = []
    for s in start{ // [5,7]   in [[5,7],[5,1]]
      for e in end{ // 2 in [1 ,2]
        var s = s
        if s.filter({$0 == e}).count == 0 {
          s.append(e) // [5,7] + [2]
          r.append(s) //  [ [5,7,1] ]  +  [5,7,2]
        }
      }
    }
    
    return r
  }
  
  
  static func selectTopNPlans(plans: [[Int]])->[Plan]{
  
    var returnPlans : [Plan] = []
    
    var topNPlans : [[Int]:Double] = [:]
    var worstPlan :[Int] = []
    let topN = 10
    
    for plan in plans {
      
      var totalDistance : Double = 0
      for i in 0...plan.count-2 {
        let start = plan[i]
        let end = plan[i+1]
        totalDistance += allRoutes[start][end] ?? Double.infinity
      }
      
      
      //If plans is not full, you can add any plans. But after that, update worst plan.
      if topNPlans.count < topN{
        topNPlans[plan] = totalDistance
        
        // if current plan is worse(longer) than worstPlan, the update it.
        if totalDistance > topNPlans[worstPlan] ?? 0 {
          worstPlan = plan
        }
        
      // If current plan is better(shorter) than worst plan, exchange it.
        // After that, update worst plan.
      }else if totalDistance < topNPlans[worstPlan]!{
        topNPlans.removeValue(forKey: worstPlan)
        topNPlans[plan] = totalDistance
        worstPlan = topNPlans.max { a, b in a.value < b.value }!.key
      }
    }
    
    
    // create plan objects
    for plan in topNPlans{
      
      var routes : [Route] = []
      var currentPlan : Plan
      
      for i in 0...plan.key.count-2{
        let start = plan.key[i]
        let end = plan.key[i+1]
        
        let route = Route(
          startLocationId: start,
          nextLocationId: end,
          distance: allRoutes[start][end]!,
          timeToReachByWalk: nil,
          timeToReachByCar: nil
        )
        routes.append(route)
      }

      currentPlan = Plan(routes: routes, destinationList: plan.key, totalDistance: plan.value, totalTimeByWalk: nil, totalTimeByCar: nil)
      returnPlans.append(currentPlan)
      
    }
    
    returnPlans.sort { $0.totalDistance < $1.totalDistance}
   
//    print(topNPlans.map({$0.value}).sorted())
    //    print(topNPlans)
    //
    
    return returnPlans

  }
  
  

  
  
}
