//
//  SceneDelegate.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit
import MapKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    guard let scene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: scene)
    window?.makeKeyAndVisible()
    let nv = UINavigationController(rootViewController: MainCollectionViewController())
    
    // Hiding navigationBar color and border. Extension func
    nv.clearNavigationBar(with: UIColor.Custom.forBackground)
    
    
    window?.rootViewController = nv
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
    
    // if current VC is main VC, then start updating.
    

//    // Start updating location.
//    // if already updating, need not to do.
//    if UserLocationController.shared.isUpdatingLocation{return}
//    
//    
//    UserLocationController.shared.start(completion: { [weak self] in
//      
//      guard let nv = self?.window?.rootViewController as? UINavigationController,
//            let mainVC = nv.topViewController as? MainViewController else{return}
//      
//      
//      // Whenever user location is updated (or start updating), this closure is invoked.
//      
//      // Get current user locaiton
//      guard let center = UserLocationController.shared.coordinatesMostRecent else {return}
//      // Set region of the mapView using current location
//      let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//     
//      mainVC.mapView.setRegion(region, animated: false)
//      mainVC.mapView.showsUserLocation = true
//    
//      // Get address by using current location
//      UserLocationController.shared.getCurrentAddress(){ address in
//        
//        // if you couldn't get address, use ip one.
//        if address.count <= 1 {
//          mainVC.locationLabel.text = userCurrentLocation.address
//          return
//        }
//        // update user location info
//        userCurrentLocation.address = address
//        // update location label
//        mainVC.locationLabel.text = address
//      }
//    })
  }
   

  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    
    // Whenever the screen gets background, stop tracking
    LocationController.shared.stop()
  }
  
  
}

