//
//  MainVC+Transition.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-29.
//

import UIKit

// MARK: - Transition

extension MainViewController {
  
  func transitWithDebugMode(_ selectCategories: [Category]) {
    let nextVC = PlanListTableViewController()
    navigationController?.pushViewController(nextVC, animated: true)

    allLocations = [userCurrentLocation] + Location.sampleLocations
    Planner.calculateAllRoutes()
    let plans = Planner.calculatePlans(categories: selectCategories)
    nextVC.plans = plans
    nextVC.tableView.reloadData()

    UserLocationController.shared.coordinatesLastTimeYouTappedGo = UserLocationController.shared.coordinatesMostRecent
  }
  
  func transitWithApiRequest(_ selectCategories: [Category]) {
    let nextVC = PlanListTableViewController()
    navigationController?.pushViewController(nextVC, animated: true)

    NetworkController.shared.createAllLocations {
      Planner.calculateAllRoutes()
      let plans = Planner.calculatePlans(categories: selectCategories)
      nextVC.plans = plans

      DispatchQueue.main.async {
        nextVC.tableView.reloadData()
      }
      // update the previous coordinates
      UserLocationController.shared.coordinatesLastTimeYouTappedGo = UserLocationController.shared.coordinatesMostRecent
    }
  }
  
  func transitWithNoApiRequest(_ selectCategories: [Category]) {
    // If same place + only category has changed,
    // only execute `Planner.calculatePlans()`, don't do `createAllLocations`
    let nextVC = PlanListTableViewController()
    navigationController?.pushViewController(nextVC, animated: true)

    let plans = Planner.calculatePlans(categories: selectCategories)
    nextVC.plans = plans
    nextVC.tableView.reloadData()
  }
}
