//
//  PlanListCVC+DataSource.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-30.
//

import UIKit


extension PlanListCollectionViewController {
  /// Delete all items of snapshot
  func resetSnapshot() {
    snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    snapshot.deleteAllItems()
    snapshot.appendSections([.list])
  }
  private func register() {
    // cell
    collectionView.register(
      PlanCardCVCell.self,
      forCellWithReuseIdentifier: PlanCardCVCell.identifier
    )
    // supplementary (header)
    collectionView.register(
      GeneticLabelCollectionReusableView.self,
      forSupplementaryViewOfKind: Constants.Kind.sectionHeader,
      withReuseIdentifier: GeneticLabelCollectionReusableView.identifier
    )
  }
  
  /// Define Diffable Data source
  func createDiffableDataSource(){
    resetSnapshot()
    register()
    snapshot.appendItems(Item.wrapPlan(items: plans), toSection: .list)
    
    dataSource = UICollectionViewDiffableDataSource<Section, Item>(
      collectionView: collectionView,
      cellProvider:
        { [unowned self] (collectionView, indexPath, item) -> UICollectionViewCell? in
          
          switch self.sections[indexPath.section] {
            case .list:
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PlanCardCVCell.identifier,
                for: indexPath
              ) as! PlanCardCVCell
              if let plan = item.plan {
                cell.configure(with: plan, planIndex: indexPath.row)
              }
              
              return cell
            default:
              return nil
          }
        }
    )
    
    dataSource.supplementaryViewProvider = {
      [unowned self] (collectionView, kind, indexPath) -> UICollectionReusableView? in

      
      if let headerView = self.collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: GeneticLabelCollectionReusableView.identifier,
        for: indexPath
      ) as? GeneticLabelCollectionReusableView {
        // config view
        switch self.sections[indexPath.section] {
          case .list:
            headerView.configure(lb: LargeHeaderLabel(text: "Title"))
          default:
            return nil
        }
        return headerView
      }
      
      
      return nil
    }
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}
