//
//  MKMapView.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-04-02.
//

import MapKit

extension MKMapView {
  /// Helper function for MKMapView. It will auto zoom the map so that all existing annotation views can be displayed.
  ///[Reference](https://stackoverflow.com/questions/39747957/mapview-to-show-all-annotations-and-zoom-in-as-much-as-possible-of-the-map)
  func zoomCapturingAllAnnotations() {
    var zoomRect = MKMapRect.null;
    for annotation in annotations {
      let annotationPoint = MKMapPoint(annotation.coordinate)
      let pointRect = MKMapRect(
        x: annotationPoint.x,
        y: annotationPoint.y,
        width: 0.01,
        height: 0.01
      )
      zoomRect = zoomRect.union(pointRect)
    }
    setVisibleMapRect(
      zoomRect,
      edgePadding: UIEdgeInsets(top: 56, left: 56, bottom: 56, right: 56),
      animated: false
    )
    zoomRect = MKMapRect.null;
  }
}

