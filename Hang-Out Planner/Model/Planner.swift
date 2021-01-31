//
//  Planner.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import Foundation
import MapKit


class Planner {

  /*
   # Ideal:(TODO later if I have time.)
   ## calc priority
   - change to price or review.
   
   ## cache
    - if no location change -> use same `allRoutes`.  No yelp-api, no routes calc
    - and if no category change -> use same `plans`. No plan calc
   
   ## route cals
   -  N^2 -> N^N/2.
  */
  
  
  
  // MARK: - Pre-Calc. Creates `allRoutes`.
  ///  Calculate every routes between locations including user's current location.
  static func calculateAllRoutes(){
    let numOfLocations = allLocations.count
    
    // Calculate and store all routes
    for si in 0..<numOfLocations{
      for ei in 0..<numOfLocations{
        // I can reduce here. N^2 -> N^N/2. Fix later
        allRoutes[si][ei] = calculateDistance(startId: si, endId: ei)
      }
    }
  }

  /// Calculate distance between start-end. it will return meter.
  /// - Parameters:
  ///   - startId: start id of location in `allLocations`
  ///   - endId: end id of location in `allLocations`
  /// - Returns: Simple straight distance (Euclidean distance?), without using api.
  static func calculateDistance(startId: Int, endId: Int)->Double{
    let start = allLocations[startId]
    let end = allLocations[endId]
    let coordinateStart = CLLocation(latitude: start.latitude, longitude: start.longitude)
    let coordinateEnd = CLLocation(latitude: end.latitude, longitude: end.longitude)
    let distanceInMeters = coordinateStart.distance(from: coordinateEnd)
    return distanceInMeters
  }


  
  // MARK: - Generates Plans with using pre-calc `allRoutes`

  /// Calc best plan by distance
  /// - Parameter categories: category of location(order) that user wants to go.
  /// - Returns: TopN best plan.
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
      let theNumOfLocation = plan.key.count-2
      
      for i in 0...theNumOfLocation{
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
      
      // Creating all ave values. I can integrate this into previous for loop and it's better. But to make it readable, I split.
      var aveRating = 0.0
      var aveRatingNil = 0 // if rating is nil, don't count. This is to record it.
      
      var aveReviewCount = 0.0
      var avePriceLevel = 0.0
      
      var aveRanking = 0.0 // Ranking is just an order of Best in yelp-api. if you get topN item at each category, it will be 0..<N
  
      for i in 1...theNumOfLocation{
        let currentLocation = allLocations[plan.key[i]]
        
        // recored rating. if nil, don't count
        if let r = currentLocation.rating{
          aveRating += r
        }else{
          aveRatingNil += 1
        }
        
        // record review count.
        if let rc = currentLocation.reviewCount{
          aveReviewCount += Double(rc)
        }
        
        // record price level.
        if let p = currentLocation.priceLevel{
          avePriceLevel += Double(p)
        }else if currentLocation.category != .artAndGallery{
          // if nil -> set average priceLevel 2, but as for park, set 0.
          avePriceLevel += 2
        }
        
        // record ranking
        if let r = currentLocation.ranking{
          aveRanking += Double(r)
        }
      }
      
      aveRating =  aveRating / Double(theNumOfLocation - aveRatingNil)
      aveReviewCount = aveReviewCount / Double(theNumOfLocation)
      avePriceLevel = avePriceLevel / Double(theNumOfLocation)
      aveRanking = aveRanking / Double(theNumOfLocation)


      currentPlan = Plan(
        routes: routes,
        destinationList: plan.key,
        totalDistance: plan.value * 1.5, // adjusting to real way
        totalTimeByWalk: nil,
        totalTimeByCar: nil,
        averageRating: aveRating,
        averageReviewCount: aveReviewCount,
        averagePriceLevel: avePriceLevel,
        averageRanking: aveRanking
      )
      returnPlans.append(currentPlan)
      
    }
    
    returnPlans.sort { $0.totalDistance < $1.totalDistance}
   
//    print(topNPlans.map({$0.value}).sorted())
    //    print(topNPlans)
    //
    
    return returnPlans

  }
  
  

  
  
}
