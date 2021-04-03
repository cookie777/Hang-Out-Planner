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
  func register() {
    // cell
    collectionView.register(
      PlanCardCVCell.self,
      forCellWithReuseIdentifier: Constants.Identifier.Cell.list
    )
    // supplementary (header)
    collectionView.register(
      GeneticLabelCollectionReusableView.self,
      forSupplementaryViewOfKind: Constants.Kind.sectionHeader,
      withReuseIdentifier: Constants.Identifier.SupplementaryView.geneticLabel
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
                withReuseIdentifier: Constants.Identifier.Cell.list,
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

      if kind == Constants.Kind.sectionHeader {
        // if ReusableSupplementaryView is for section header
        if let headerView = self.collectionView.dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: Constants.Identifier.SupplementaryView.geneticLabel,
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
      }

      return nil
    }
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}
