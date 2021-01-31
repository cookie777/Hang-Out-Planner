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
  
  /// Success flag of yelp fetching. If this flag is
  var yelpFetchSucceeded : Bool = false
  
  /// fetch an image from imageURL, and return UIImage as completion handler
  /// - Parameters:
  ///   - urlString: String
  
  ///   - UIImage: locationImage(thumbnail) at each cell in PlanDetailVC
  func fetchImage(urlString: String?, completionHandler: @escaping (UIImage?) -> Void) {
    
    // check if imageURL is nil
    guard let urlString = urlString else {return}
    
    
    // check if its type is URL
    guard let url = URL(string: urlString) else {return}
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
      
      guard let data = data else{
        if let error = error { print(error.localizedDescription)}
        return
      }
      
      guard let image = UIImage(data: data) else {
        completionHandler(nil)
        return
      }
      
      completionHandler(image)
      
    }
    task.resume()
    
  }
  
}



