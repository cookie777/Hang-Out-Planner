//
//  MKMapView+TakeSnapshot.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-04-02.
//

import MapKit

extension MKMapView {
  
  /// Take the snapshot of the map at the location
  /// - Parameters:
  ///   - location: the center location of the map
  ///   - completion: handler that after taking snapshot. `MKMapSnapshotter.Snapshot?`: The image data that was generated or nil if an error occurred, `Error?`: The error that occurred or nil if the snapshot was generated successfully. [Reference](https://developer.apple.com/documentation/mapkit/mkmapsnapshotter/completionhandler)
  func takeSnapshot(at location:CLLocationCoordinate2D, completion: @escaping (MKMapSnapshotter.Snapshot?, Error?) -> Void){
    let mapSnapshotOptions = MKMapSnapshotter.Options()

    // Set the region of the map
    let region = MKCoordinateRegion(center: location, latitudinalMeters: 1800, longitudinalMeters: 1800)
    mapSnapshotOptions.region = region

    // Set the scale of the image.
    // We'll just use the scale of the current device, which is 2x scale on Retina screens.
    mapSnapshotOptions.scale = UIScreen.main.scale

    // Set the size of the image output.
    mapSnapshotOptions.size = CGSize(width: 400, height: 400*0.618)

    // Take a snapshot of the map using options
    let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
    snapShotter.start(completionHandler: completion)
  }
}

//     let location = UserLocationController.shared.coordinatesLastTimeYouTappedGo!
//
//snapShotter.start(completionHandler: { (snapshot, error) -> Void in
//  if error == nil {
//    self.fetchedImages[0] = snapshot!.image
//    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
//    //        self.tableView.reloadData()
//  } else {
//    print("error")
//  }
//})
