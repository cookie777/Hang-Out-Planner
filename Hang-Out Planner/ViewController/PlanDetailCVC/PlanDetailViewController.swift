//
//  PlanDetailViewController.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit
import MapKit

class PlanDetailCollectionViewController: UICollectionViewController {
  
  let sections: [Section] = [.list]
  var snapshot: NSDiffableDataSourceSnapshot<Section, Item>!
  var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

  /// variable to store fetched images
  let fetchedImages = FetchedImages()

  /// A plan selected at `PlanListTableViewController`
  let plan: Plan
  
  init(_ plan: Plan) {
    self.plan = plan
    super.init(collectionViewLayout: UICollectionViewLayout())
    
    fetchedImages.source = [UIImage?](
      repeating: nil,
      count: plan.destinationList.count - 1
    )

    createCollectionViewLayout()
    createDiffableDataSource()
    setObserverAnnotationTapped()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}


/// This is a wrapper class for storing fetched images. Array is value type and we can't use `inout` in async closure so this class wrapper is needed.
class FetchedImages {
  /// - if nil -> haven't started fetching
  /// - if placeHolder image -> "fetching now" or "can't fetch so avoid fetching"
  /// - if other images -> avoid fetching
  var source: [UIImage?]?
}
