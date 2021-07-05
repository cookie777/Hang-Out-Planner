//
//  NetworkController.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

/*
 Controller for using API.
 Fetch image, location data by using this class.
 
 Singleton.
 */
class NetworkController {
  static let shared = NetworkController()
  private init(){}
  
  // We store fetched locations data here, temporary.
  // This doesn't include user's location nor id.
  // After return final data, it should be all deleted from memory save.
  var tempAllLocations : [Location] = []
}



