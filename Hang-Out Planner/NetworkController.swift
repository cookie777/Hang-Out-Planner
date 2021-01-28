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

  
  /// fetch an image from imageURL, and set the image to the imageView
  /// - Parameters:
  ///   - urlString: String
  ///   - imageView: locationImage(thumbnail) at each cell in PlanDetailVC
  func fetchImage(urlString: String, imageView: UIImageView) {
    guard let url = URL(string: urlString) else {return}

    print("fetching")
    DispatchQueue.global().async { [weak self] in

      if let data = try? Data(contentsOf: url) {
        if let image = UIImage(data: data) {
          DispatchQueue.main.async {
            imageView.image = image
            print("loading finished")
            
          }
        }
      }
    }
  }


}




