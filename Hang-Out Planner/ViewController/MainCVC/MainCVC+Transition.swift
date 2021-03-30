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

    allLocations = [userCurrentLocation] + Location.sampleLocations
    Planner.calculateAllRoutes()
    let plans = Planner.calculatePlans(categories: selectCategories)
    nextVC.plans = plans

    UserLocationController.shared.coordinatesLastTimeYouTappedGo = UserLocationController.shared.coordinatesMostRecent
  }
  
  func transitWithApiRequest(_ selectCategories: [Category]) {
    let nextVC = PlanListCollectionViewController()
    navigationController?.pushViewController(nextVC, animated: true)

    NetworkController.shared.createAllLocations {
      Planner.calculateAllRoutes()
      let plans = Planner.calculatePlans(categories: selectCategories)
      nextVC.plans = plans
      // update the previous coordinates
      UserLocationController.shared.coordinatesLastTimeYouTappedGo = UserLocationController.shared.coordinatesMostRecent
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
