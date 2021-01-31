//
//  SpeedCalculator.swift
//  Hang-Out Planner
//
//  Created by Yumi Machino on 2021/01/31.
//

import Foundation

/// calculate speed on plan, route to display on PlanCardTVCell and DistanceCardTVCell
struct SpeedCalculator {
  
  static func meterTokm(distanceInMeter: Double) -> Double {
    let distanceInKm = distanceInMeter * 0.001
    return round(distanceInKm * 10) / 10
  }
  
  /// average human: 5km per hour, 85m per minute
  static func calcWalkingSpeed(distance: Double) -> String{
    let walkingSpeedInMinute = distance / 85
    let minOnFoot = round(walkingSpeedInMinute * 10)/10
    if minOnFoot <= 1 {
      return "\(Int(minOnFoot)) min"
    } else if minOnFoot < 60 {
      return  "\(Int(minOnFoot)) mins"
    } else {
      let walkingSpeedInHour = meterTokm(distanceInMeter: distance) / 5
      let hourOnFoot = round(walkingSpeedInHour * 10)/10
      return "\(hourOnFoot) h"
    }
  }
  
  /// average car: 40km per hour
  static func calcCarSpeedInHour(distance: Double) -> Double {
    let carSpped = meterTokm(distanceInMeter: distance) / 40
    let hourByCar = round(carSpped * 10)/10
    return hourByCar
  }
  
  /// average car: 666 meter per minute
  static func calcCarSpeedInMinute(distance: Double) -> Int {
    let minuteByCar = round(distance / 666)
    return Int(minuteByCar)
  }
}
