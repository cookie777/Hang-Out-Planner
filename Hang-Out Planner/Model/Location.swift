//
//  Location.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import Foundation


struct Location{
  
  // Have to change all optional except id and category
  let id      : Int // used for app calculation
  let apiId   : String?// used for api call
  let category: Categories
  
  let latitude    : Double
  let longitude   : Double
  
  let title   : String
  let imageURL: String?
  let address : String
  
  let website : String?
  let rating  : Double?
  
  // later discard.
  static var sampleStartPoint = Location(id: 0, apiId: nil, category: .other, latitude: 49.2825, longitude: -123.1186, title: "Vancouver City Centre Station", imageURL: nil, address: "702 W Georgia Street Vancouver, BC V6Z 2H7", website: nil, rating: 3.857142857)
  

  static var sampleLocations = [
    Location(id: 1,
             apiId: nil,
             category: .cafe,
             latitude: 49.28307385271972,
             longitude: -123.10997501761302,
             title: "New Amsterdam Café",
             imageURL: nil,
             address: "301 W Hastings St, Vancouver, BC V6B 1H6",
             website: nil,
             rating: 4.5
    ),
    Location(id: 2,
             apiId: nil,
             category: .cafe,
             latitude:  49.26657429750753,
             longitude:  123.14069664460278,
             title: "Beaucoup Bakery & Cafe",
             imageURL: nil,
             address: "2150 Fir Street Vancouver, BC V6J 3B5",
             website: nil,
             rating: 4.3
    ),
    Location(id: 3,
             apiId: nil,
             category: .cafe,
             latitude: 49.280687751666775,
             longitude:  -123.11699897528322,
             title: "Medina Cafe",
             imageURL: nil,
             address: "780 Richards Street Vancouver, BC V6B 3A4",
             website: nil,
             rating: 3.9
    ),
    Location(id: 4,
             apiId: nil,
             category: .cafe,
             latitude: 49.28139330213119,
             longitude:   -123.10989661879631,
             title: "Jam Cafe",
             imageURL: nil,
             address: "556 Beatty St, Vancouver, BC V6B 2L3",
             website: nil,
             rating: 4.6
    ),
    Location(id: 5,
             apiId: nil,
             category: .amusement,
             latitude: 49.273348,
             longitude:  -123.103195,
             title: "Science World",
             imageURL: nil,
             address: "1455 Quebec St, Vancouver, BC V6A 3Z7",
             website: nil,
             rating: 4.8
    ),
    Location(id: 6,
             apiId: nil,
             category: .amusement,
             latitude: 49.280754,
             longitude:  -123.107315,
             title: "Find and Seek Puzzle Adventure Escape Room",
             imageURL: nil,
             address: "88 W Pender St #2075, Vancouver, BC V6B 6N9",
             website: nil,
             rating: 3.8
    ),
    Location(id: 7,
             apiId: nil,
             category: .amusement,
             latitude: 49.278010,
             longitude: -123.125499,
             title: "i-Exit Vancouver",
             imageURL: nil,
             address: "1129 Granville St, Vancouver, BC V6Z 1M1",
             website: nil,
             rating: 4.1
    ),
    Location(id: 8,
             apiId: nil,
             category: .park,
             latitude: 49.304258,
             longitude: -123.144252,
             title: "Stanley Park",
             imageURL: nil,
             address: "1166 Stanley Park Drive Vancouver, BC V6G",
             website: nil,
             rating: 4.25
    ),
    Location(id: 9,
             apiId: nil,
             category: .park,
             latitude: 49.241757,
             longitude: -123.114808,
             title: "Queen Elizabeth Park",
             imageURL: nil,
             address: "Cambie Street & W 33rd Avenue Vancouver, BC V6J 5L1",
             website: nil,
             rating: 4.2
    ),
    Location(id: 10,
             apiId: nil,
             category: .park,
             latitude: 49.253286,
             longitude: -123.217791,
             title: "Pacific Spirit Regional Park",
             imageURL: nil,
             address: "5495 Chancellor Blvd Vancouver, BC V6T 1E4",
             website: nil,
             rating: 4.7
    ),
    Location(id: 11,
             apiId: nil,
             category: .restaurant,
             latitude: 49.227605,
             longitude: -123.005502,
             title: "Cactus Club Cafe Station Square",
             imageURL: nil,
             address: "6090 Silver Drive Burnaby, BC V5H 4L7",
             website: nil,
             rating: 4.2
    ),
    Location(id: 12,
             apiId: nil,
             category: .restaurant,
             latitude: 49.2751715,
             longitude: -123.122095,
             title: "The Flying Pig - Yaletown",
             imageURL: nil,
             address: "1168 Hamilton Street Unit 104 Vancouver, BC V6B 2S2",
             website: nil,
             rating: 4.3
    ),
    Location(id: 13,
             apiId: nil,
             category: .restaurant,
             latitude: 49.280540,
             longitude: -123.124980,
             title: "La Taqueria Pinche Taco Shop",
             imageURL: nil,
             address: "2450 Yukon Street Vancouver, BC V5Z 3V6",
             website: nil,
             rating: 3.9
    ),
    Location(id: 14,
             apiId: nil,
             category: .clothes,
             latitude: 49.245871,
             longitude: -123.200052,
             title: "Vans",
             imageURL: nil,
             address: "772 Granville St Vancouver, BC V6Z 1A1",
             website: nil,
             rating: 4.4
    ),
    Location(id: 15,
             apiId: nil,
             category: .clothes,
             latitude: 49.2286570514542,
             longitude: -122.99931298706157,
             title: "Uniqlo",
             imageURL: nil,
             address: "4800 Kingsway Lower Level & P2 Burnaby, BC V5H 4J2 Metrotown",
             website: nil,
             rating: 4.7
    ),
    Location(id: 16,
             apiId: nil,
             category: .clothes,
             latitude: 49.283189,
             longitude: -123.117738,
             title: "H&M",
             imageURL: nil,
             address: "609 Granville Street Unit 100-201A Vancouver, BC V7Y 1G5",
             website: nil,
             rating: 4.4
    ),
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
