//
//  PlanListCollectionViewController.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-29.
//

import UIKit


class PlanListCollectionViewController: UICollectionViewController {
  
  lazy var plans: [Plan] = [] {// [Plan] you receive from planner model
    didSet {
      resetSnapshot()
      snapshot.appendItems(Item.wrapPlan(items: plans), toSection: .list)
      dataSource.apply(snapshot, animatingDifferences: true)
    }
  }
  let sections: [Section] = [.list]
  
  var snapshot: NSDiffableDataSourceSnapshot<Section, Item>!
  var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
  
  init() {
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
    createCollectionViewLayout()
    createDiffableDataSource()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let planDetailVC = PlanDetailViewController(plan: plans[indexPath.row])
    navigationController?.pushViewController(planDetailVC, animated: true)
  }
  
}

