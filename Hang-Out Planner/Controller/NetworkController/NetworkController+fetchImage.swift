//
//  NetworkController+fetchImage.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-04-05.
//

import UIKit

extension NetworkController {
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
