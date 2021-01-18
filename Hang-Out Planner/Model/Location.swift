//
//  Location.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import Foundation

struct Location{
  let id      : String //id from api or UUID
  let category: Categories
  
  let long    : Double
  let lat     : Double
  
  let title   : String
  let imageURL: String
  let address : String
  
  let website : String?
  let rating  : String?
}


/*
 Usage example
 
 var locations : [Categories: [Location]] =
 
 [
    amusement: [location0, location1, location2...] ,
    restaurant: [location0, location1, location2...] ,
     ...
  ]

*/
