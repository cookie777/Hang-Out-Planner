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
  
  let rating: Double? // Double. Value ranges from 1, 1.5, ... 4.5, 5. Higher is better.
  let reviewCount: Int?
  let priceLevel: Int? // // Price level of the business. Value is one of 1, 2, 3 and 4. 1 means low cost, whereas 4 mean high cost.
  let popularity: Int? = nil // The best Mach order from yelp api. not absolute, might not use
  
  // later discard.
  static var sampleStartPoint = Location(
    id: 0,
    apiId: "mNK0w1qq-Z4bC5ZXdwFn2Q",
    category: .other,
    latitude: 49.2824177568294,
    longitude: -123.118500128488,
    title: "Vancouver City Centre Station",
    imageURL: "https://s3-media2.fl.yelpcdn.com/bphoto/ueRHTFxfTw0VE6lOioctRg/o.jpg",
    address: "702 W Georgia Street Vancouver, BC V6Z 2H7",
    website: "https://www.yelp.com/biz/vancouver-city-centre-station-vancouver?adjust_creative=pww_RAT4PrkpchawZzKB7g&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=pww_RAT4PrkpchawZzKB7g",
    rating: 4.0,
    reviewCount: 7,
    priceLevel: nil
  )
  
  
  static var sampleLocations = [
    Location(
      id: 1,
      apiId: "-i9Y463tpAdh2sDAzvd7BQ",
      category: .cafe,
      latitude: 49.283004,
      longitude: -123.110008,
      title: "New Amsterdam Café",
      imageURL: "https://s3-media2.fl.yelpcdn.com/bphoto/RZZOQT2x09vIcuI8PF1ENw/o.jpg",
      address: "301 W Hastings St, Vancouver, BC V6B 1H6",
      website: "https://www.yelp.com/biz/new-amsterdam-caf%C3%A9-vancouver-2?adjust_creative=pww_RAT4PrkpchawZzKB7g&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=pww_RAT4PrkpchawZzKB7g",
      rating: 4.0,
      reviewCount: 52,
      priceLevel: 1
    ),
    Location(
      id: 2,
      apiId: "rVd781B1hA20gJchgqlx9w",
      category: .cafe,
      latitude:  49.2664944122145,
      longitude:  -123.14075578449,
      title: "Beaucoup Bakery & Cafe",
      imageURL: "https://s3-media2.fl.yelpcdn.com/bphoto/YkzKY0yrTT90sf8Rq8gRkg/o.jpg",
      address: "2150 Fir Street Vancouver, BC V6J 3B5",
      website: "https://www.yelp.com/biz/beaucoup-bakery-and-cafe-vancouver?adjust_creative=pww_RAT4PrkpchawZzKB7g&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=pww_RAT4PrkpchawZzKB7g",
      rating: 4.0,
      reviewCount: 294,
      priceLevel: 2
    ),
    Location(
      id: 3,
      apiId: "VPqWLp9kMiZEbctCebIZUA",
      category: .cafe,
      latitude: 49.2804429972571,
      longitude:  -123.117036269849,
      title: "Medina Cafe",
      imageURL: "https://s3-media1.fl.yelpcdn.com/bphoto/9avnAPBgEVN9WJFu1ttg9w/o.jpg",
      address: "780 Richards Street Vancouver, BC V6B 3A4",
      website: "https://www.yelp.com/biz/medina-cafe-vancouver?adjust_creative=pww_RAT4PrkpchawZzKB7g&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=pww_RAT4PrkpchawZzKB7g",
      rating: 4.0,
      reviewCount: 2304,
      priceLevel: 2
    ),
    Location(
      id: 4,
      apiId: "LjdbthVdtLYKSi7iVAFl0g",
      category: .cafe,
      latitude: 49.2802586,
      longitude:   -123.1096376,
      title: "Jam Cafe on Beatty",
      imageURL: "https://s3-media4.fl.yelpcdn.com/bphoto/kEA-7srl5BDA-Si4ZM1PHA/o.jpg",
      address: "556 Beatty St, Vancouver, BC V6B 2L3",
      website: "https://www.yelp.com/biz/jam-cafe-on-beatty-vancouver?adjust_creative=pww_RAT4PrkpchawZzKB7g&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=pww_RAT4PrkpchawZzKB7g",
      rating: 4.5,
      reviewCount: 1095,
      priceLevel: 2
    ),
    Location(
      id: 5,
      apiId: "ZDcCaLnP-33BC_ge2kon3A",
      category: .amusement,
      latitude: 49.27338,
      longitude: -123.103836,
      title: "Science World",
      imageURL: "https://s3-media4.fl.yelpcdn.com/bphoto/B-IG3pWWz3Xt1R7i1Eb4sg/o.jpg",
      address: "1455 Quebec St, Vancouver, BC V6A 3Z7",
      website: "https://www.yelp.com/biz/science-world-vancouver-2?adjust_creative=pww_RAT4PrkpchawZzKB7g&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=pww_RAT4PrkpchawZzKB7g",
      rating: 3.5,
      reviewCount: 171,
      priceLevel: nil
    ),
    Location(
      id: 6,
      apiId: "LxCbFLe7YTKxJG0zecmORA",
      category: .amusement,
      latitude: 49.280667985637,
      longitude:  -123.106372430921,
      title: "Find and Seek Puzzle Adventure Escape Rooms",
      imageURL: "https://s3-media2.fl.yelpcdn.com/bphoto/FWV47v9CBUt-Pc7sE2sGfA/o.jpg",
      address: "88 W Pender St #2075, Vancouver, BC V6B 6N9",
      website: "https://www.yelp.com/biz/find-and-seek-puzzle-adventure-escape-rooms-vancouver-2?adjust_creative=pww_RAT4PrkpchawZzKB7g&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=pww_RAT4PrkpchawZzKB7g",
      rating: 5.0,
      reviewCount: 89,
      priceLevel: nil
    ),
    Location(
      id: 7,
      apiId: "t39MUI3Zg4matAvDieOGXg",
      category: .amusement,
      latitude: 49.278,
      longitude:  -123.12551,
      title: "i-Exit",
      imageURL: "https://s3-media3.fl.yelpcdn.com/bphoto/2-0sDpbE4iqReQNctYpn3g/o.jpg",
      address: "1129 Granville St, Vancouver, BC V6Z 1M1",
      website: "https://www.yelp.com/biz/i-exit-vancouver-3?adjust_creative=pww_RAT4PrkpchawZzKB7g&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=pww_RAT4PrkpchawZzKB7g",
      rating: 4.5,
      reviewCount: 42,
      priceLevel: nil
    ),
    Location(
      id: 8,
      apiId: "kajMc2fkWKdzKJ1M4pm47Q",
      category: .park,
      latitude: 49.2978842,
      longitude: -123.1308093,
      title: "Stanley Park",
      imageURL: "https://s3-media3.fl.yelpcdn.com/bphoto/btlGaHzREY8dTJaU2B6-PQ/o.jpg",
      address: "1166 Stanley Park Drive Vancouver, BC V6G",
      website: "https://www.yelp.com/biz/stanley-park-vancouver-4?adjust_creative=pww_RAT4PrkpchawZzKB7g&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=pww_RAT4PrkpchawZzKB7g",
      rating: 5.0,
      reviewCount: 938,
      priceLevel: nil
    ),
    Location(
      id: 9,
      apiId: "QZMDi6zSshZPxSwoyF3lvw",
      category: .park,
      latitude: 49.2388979593086,
      longitude: -123.110358343689,
      title: "Queen Elizabeth Park",
      imageURL: "https://s3-media2.fl.yelpcdn.com/bphoto/nF-2BIMNpQ-7mxz-Z7mNdw/o.jpg",
      address: "Cambie Street & W 33rd Avenue Vancouver, BC V6J 5L1",
      website: "https://www.yelp.com/biz/queen-elizabeth-park-vancouver?adjust_creative=pww_RAT4PrkpchawZzKB7g&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=pww_RAT4PrkpchawZzKB7g",
      rating: 4.5,
      reviewCount: 152,
      priceLevel: nil
    ),
    Location(
      id: 10,
      apiId: "5nWnESoN_ZS4OPMi6PaLXA",
      category: .park,
      latitude: 49.2736605,
      longitude: -123.2418804,
      title: "Pacific Spirit Regional Park",
      imageURL: "https://s3-media2.fl.yelpcdn.com/bphoto/h2hyxjs_bgg8CLS9mEZKiw/o.jpg",
      address: "5495 Chancellor Blvd Vancouver, BC V6T 1E4",
      website: "https://www.yelp.com/biz/pacific-spirit-regional-park-vancouver?adjust_creative=pww_RAT4PrkpchawZzKB7g&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=pww_RAT4PrkpchawZzKB7g",
      rating: 4.5,
      reviewCount: 46,
      priceLevel: nil
    ),
    Location(
      id: 11,
      apiId: "oB4GzgURuu6HGBEDECHWRw",
      category: .restaurant,
      latitude: 49.22841,
      longitude: -123.00276,
      title: "Cactus Club Cafe Station Square",
      imageURL: "https://s3-media1.fl.yelpcdn.com/bphoto/YcSGl2i-HZJgvrt74eLCBg/o.jpg",
      address: "6090 Silver Drive Burnaby, BC V5H 4L7",
      website: "https://www.yelp.com/biz/cactus-club-cafe-station-square-burnaby?adjust_creative=pww_RAT4PrkpchawZzKB7g&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=pww_RAT4PrkpchawZzKB7g",
      rating: 4.0,
      reviewCount: 80,
      priceLevel: 2
    ),
    Location(
      id: 12,
      apiId: "NdEPf2Ls5Ql3_nkwjqKvXA",
      category: .restaurant,
      latitude: 49.27501,
      longitude: -123.122,
      title: "The Flying Pig - Yaletown",
      imageURL: "https://s3-media1.fl.yelpcdn.com/bphoto/A12vKckXPkrVAF9mXs9AbA/o.jpg",
      address: "1168 Hamilton Street Unit 104 Vancouver, BC V6B 2S2",
      website: "https://www.yelp.com/biz/the-flying-pig-yaletown-vancouver?adjust_creative=pww_RAT4PrkpchawZzKB7g&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=pww_RAT4PrkpchawZzKB7g",
      rating: 4.0,
      reviewCount: 1092,
      priceLevel: 2
    ),
    Location(
      id: 13,
      apiId: "vXTo69v2bGEyuBdT0X1hrw",
      category: .restaurant,
      latitude: 49.282912,
      longitude: -123.110593,
      title: "La Taqueria Pinche Taco Shop",
      imageURL: "https://s3-media3.fl.yelpcdn.com/bphoto/tevD3sS3_E-uiw9NEdmrOA/o.jpg",
      address: "2450 Yukon Street Vancouver, BC V5Z 3V6",
      website: "https://www.yelp.com/biz/la-taqueria-pinche-taco-shop-vancouver-2?adjust_creative=pww_RAT4PrkpchawZzKB7g&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=pww_RAT4PrkpchawZzKB7g",
      rating: 4.5,
      reviewCount: 473,
      priceLevel: 2
    ),
    Location(
      id: 14,
      apiId: "MaZuSyl_Cgozm3bWbZUk4w",
      category: .clothes,
      latitude: 49.2817016,
      longitude: -123.1190082,
      title: "Vans",
      imageURL: "https://s3-media3.fl.yelpcdn.com/bphoto/q7SJtak2v-KVJA4wJvDtlw/o.jpg",
      address: "772 Granville St Vancouver, BC V6Z 1A1",
      website: "https://www.yelp.com/biz/vans-vancouver-4?adjust_creative=pww_RAT4PrkpchawZzKB7g&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=pww_RAT4PrkpchawZzKB7g",
      rating: 4.5,
      reviewCount: 9,
      priceLevel: 2
    ),
    Location(
      id: 15,
      apiId: "zdNGQarK1bDPQhknUTb24A",
      category: .clothes,
      latitude: 49.225957,
      longitude: -122.99923,
      title: "UNIQLO",
      imageURL: "https://s3-media1.fl.yelpcdn.com/bphoto/ZDpbGPxta_5KcR7UWMT29Q/o.jpg",
      address: "4800 Kingsway Lower Level & P2 Burnaby, BC V5H 4J2 Metrotown",
      website: "https://www.yelp.com/biz/uniqlo-burnaby?adjust_creative=pww_RAT4PrkpchawZzKB7g&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=pww_RAT4PrkpchawZzKB7g",
      rating: 3.5,
      reviewCount: 20,
      priceLevel: 2
    ),
    Location(
      id: 16,
      apiId: "z7wNFWEBKSoEN5BTDodUBA",
      category: .clothes,
      latitude: 49.2834,
      longitude: -123.11775,
      title: "H&M",
      imageURL: "https://s3-media4.fl.yelpcdn.com/bphoto/OEiWfZmSZPJWBiwg8kErMg/o.jpg",
      address: "609 Granville Street Unit 100-201A Vancouver, BC V7Y 1G5",
      website: "https://www.yelp.com/biz/h-and-m-vancouver?adjust_creative=pww_RAT4PrkpchawZzKB7g&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=pww_RAT4PrkpchawZzKB7g",
      rating: 2.5,
      reviewCount: 87,
      priceLevel: 2
      
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
