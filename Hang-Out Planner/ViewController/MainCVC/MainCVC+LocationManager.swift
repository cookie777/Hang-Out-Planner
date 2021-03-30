//
//  MainVC+LocationManager.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-29.
//

// MARK: - Location manager process.
// Here, we manage when to start and stop location manager.
// The first time is called in viewDid load.
import MapKit

extension MainCollectionViewController{

  override func viewWillAppear(_ animated: Bool) {

    // Whenever the view is shown, enaible goButton.
    goButton.isEnabled = true

    // Start updating location.
    // if already updating, need not to do.
    if UserLocationController.shared.isUpdatingLocation{return}

    UserLocationController.shared.start(completion: { [unowned self] in
      // Whenever user location is updated (or start updating), this closure is invoked.

      // Get current user locaiton
      guard let center = UserLocationController.shared.coordinatesMostRecent else {return}

      // Set region of the mapView using current location
      let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
      
      let headerView = self.collectionView.visibleSupplementaryViews(ofKind: Constants.Kind.sectionHeader).first as! MapHeaderCollectionReusableView
      let mapView = headerView.mapView
      let locationLabel = headerView.locationLabel
      
      mapView.setRegion(region, animated: false)
      mapView.showsUserLocation = true
      // Get address by using current location
      UserLocationController.shared.getCurrentAddress(){ address in
        // if you couldn't get address, use ip one.
        if address.count <= 1 {
          locationLabel.text = userCurrentLocation.address
          return
        }
        // update user location info
        userCurrentLocation.address = address
        // update location label
        locationLabel.text = address
      }
    })
  }

  override func viewWillDisappear(_ animated: Bool) {
    // Stop tracking user data.
    UserLocationController.shared.stop()
  }

}


