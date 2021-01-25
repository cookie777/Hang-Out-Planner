//
//  NetworkController+fetchLocations.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-24.
//

import Foundation


extension NetworkController{
  // Getting the apiKey from plist
  private func getAPIKey()->String{
    var apiKey: String {
      get {
        guard let filePath = Bundle.main.path(forResource: "yelp-Info", ofType: "plist") else {
          fatalError("Couldn't find file 'yelp-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
          fatalError("Couldn't find key 'API_KEY' in 'yelp-Info.plist'.")
        }
        return value
      }
    }
    return apiKey
  }
  
//  func printAPI(){
//    print(getAPIKey())
//  }

}
