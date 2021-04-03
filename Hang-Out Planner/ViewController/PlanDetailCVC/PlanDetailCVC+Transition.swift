//
//  PlanDetailCVC+Transition.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-04-02.
//

import UIKit

extension PlanDetailCollectionViewController {
  
  /// Set observer for annotation tapped. If tapped -> transit to detail VC.
  func setObserverAnnotationTapped() {
    NotificationCenter.default.addObserver(self, selector: #selector(annotationTapped), name: Constants.Notification.annotationTapped, object: nil)
  }
  @objc private func annotationTapped(_ notification: Notification) {
    guard let id = notification.object as? Int else { return }
    transitLocationDetailVC(locationId: id)
  }
  
  /// Transit(present) to Next VC with selected location
  func transitLocationDetailVC(locationId: Int){
    // Pass selected Location
    let nextVC = LocationDetailViewController(location: allLocations[locationId])
    
    // Get and Pass selected Location's image (reusing fetched image)
    // lcoaiton id : 11
    // dest list [0, 12, 11, 5, 0]
    // imageId == 2
    // fetched image [0, image, "image" ,image]
    guard let imageId = plan.destinationList.firstIndex(where: {$0 == locationId}) else { return }
    if let locationImage = fetchedImages.source?[imageId]  {
      nextVC.imageView.image = locationImage
    }
    
    present(nextVC, animated: true, completion: nil)
  }
  
  /// Behaviour if cell is tapped.
  /// If it is location cell (not distance cell), go to next detail VC.
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    guard case let .location(location) = snapshot.itemIdentifiers(inSection: .list)[indexPath.row] else {
      return
    }
    
    let selectedLocationId = location.id
    transitLocationDetailVC(locationId: selectedLocationId)
  }
}
