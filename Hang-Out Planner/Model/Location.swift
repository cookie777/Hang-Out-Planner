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
  
  let longitude    : Double
  let latitude     : Double
  
  let title   : String
  let imageURL: String?
  let address : String
  
  let website : String?
  let rating  : Double?
  
  static var sampleStartPoint = Location(id: "-1", category: .other, longitude: 49.2825, latitude: -123.1186, title: "Vancouver City Centre Station", imageURL: nil, address: "702 W Georgia Street Vancouver, BC V6Z 2H7", website: nil, rating: 3.857142857)
  
  static var sampleLocations = [
    Location(id: "0", category: .cafe, longitude: 49.282964, latitude: -123.109865, title: "New Amsterdam Café", imageURL: nil, address: "301 W Hastings St, Vancouver, BC V6B 1H6", website: nil, rating: 4.5),
    Location(id: "1", category: .amusement, longitude: 49.262316, latitude: -123.097107, title: "Zero Latency Vancouver", imageURL: nil, address: "Kingsgate Mall, 370 E Broadway #101, Vancouver, BC V5T 4G5", website: nil, rating: 4.9),
    Location(id: "3", category: .park, longitude: 49.304258, latitude: -123.144252, title: "Stanley Park", imageURL: nil, address: "1166 Stanley Park Drive Vancouver, BC V6G", website: nil, rating: 4.7),
  ]

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
