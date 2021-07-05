//
//  MainVC+Transition.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-29.
//

import UIKit

// MARK: - Transition

extension MainCollectionViewController {
  
  func transitWithDebugMode(_ selectCategories: [Category]) {
    let nextVC = PlanListCollectionViewController()
    navigationController?.pushViewController(nextVC, animated: true)

    User.allLocations = [User.userLocation] + Location.sampleLocations
    Planner.calculateAllRoutes()
    let plans = Planner.calculatePlans(categories: selectCategories)
    nextVC.plans = plans

    LocationController.shared.coordinatesOfLastTimeTappedGo = LocationController.shared.coordinatesOfMostRecent
  }
  
  func transitWithApiRequest(_ selectCategories: [Category]) {
    let nextVC = PlanListCollectionViewController()
    navigationController?.pushViewController(nextVC, animated: true)

    NetworkController.shared.createAllLocations {
      Planner.calculateAllRoutes()
      let plans = Planner.calculatePlans(categories: selectCategories)
      nextVC.plans = plans
      // update the previous coordinates
      LocationController.shared.coordinatesOfLastTimeTappedGo = LocationController.shared.coordinatesOfMostRecent
    }
  }
  
  func transitWithNoApiRequest(_ selectCategories: [Category]) {
    // If same place + only category has changed,
    // only execute `Planner.calculatePlans()`, don't do `createAllLocations`
    let nextVC = PlanListCollectionViewController()
    navigationController?.pushViewController(nextVC, animated: true)

    let plans = Planner.calculatePlans(categories: selectCategories)
    nextVC.plans = plans
  }
}
