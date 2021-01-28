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

  
  
  /// fetch an image from imageURL, and return UIImage as completion handler
  /// - Parameters:
  ///   - urlString: String
  ///   - UIImage: locationImage(thumbnail) at each cell in PlanDetailVC
  func fetchImage(urlString: String?, completionHandler: @escaping (UIImage?, Error?) -> Void) {
    // check if imageURL is nil
    if let urlString = urlString {
      // check if its type is URL
      guard let url = URL(string: urlString) else {return}
      
      let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        if let data = data {
          do {
            if let image = UIImage(data: data) {
                completionHandler(image, nil)
            }
          } catch {
            print(error.localizedDescription)
            completionHandler(nil, error)
          }
        } else if let error = error {
          print(error.localizedDescription)
        }
      }
      task.resume()
    }
    
    }
    
}



