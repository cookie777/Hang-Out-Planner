//
//  PlanDetailCVC+DataSource.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-31.
//

import UIKit

extension PlanDetailCollectionViewController {
  
  /// Delete all items of snapshot
  private func resetSnapshot() {
    snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    snapshot.deleteAllItems()
    snapshot.appendSections([.list])
  }
  
  private func initSnapshot() {
    resetSnapshot()
    var source: [Item] = []
    for route in plan.routes {
      let location = allLocations.first { $0.id == route.startLocationId }
      source.append(Item.location(location!))
      source.append(Item.route(route))
    }
    snapshot.appendItems(source, toSection: .list)
  }
  
  private func register() {
    // cell
    collectionView.register(
      LocationCardCVCell.self,
      forCellWithReuseIdentifier: Constants.Identifier.Cell.list
    )
    collectionView.register(
      DistanceCardCVCell.self,
      forCellWithReuseIdentifier: DistanceCardCVCell.identifier
    )
    // supplementary (header)
    collectionView.register(
      PlanDetailMapCollectionReusableView.self,
      forSupplementaryViewOfKind: Constants.Kind.sectionHeader,
      withReuseIdentifier: Constants.Identifier.SupplementaryView.planDetailMap
    )
    // supplementary (group header)
    collectionView.register(
      GeneticLabelCollectionReusableView.self,
      forSupplementaryViewOfKind: Constants.Kind.groupHeader,
      withReuseIdentifier: Constants.Identifier.SupplementaryView.geneticLabel
    )
  }
  
  /// Define Diffable Data source
  func createDiffableDataSource() {
    initSnapshot()
    register()
    
    dataSource = UICollectionViewDiffableDataSource<Section, Item>(
      collectionView: collectionView,
      cellProvider:
        { [unowned self] (collectionView, indexPath, item) -> UICollectionViewCell? in
          
          switch self.sections[indexPath.section] {
          case .list:
            
            if let location = item.location {
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constants.Identifier.Cell.list,
                for: indexPath
              ) as! LocationCardCVCell
              cell.update(with: indexPath.row/2, and: location, and: fetchedImages)
              return cell
            }
            
            if let route = item.route {
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DistanceCardCVCell.identifier,
                for: indexPath
              ) as! DistanceCardCVCell
              cell.update(with: route)
              return cell
            }
            
          default:
            return nil
          }
          
          return nil
        }
    )
    
    dataSource.supplementaryViewProvider = {
      [unowned self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
      
      if kind == Constants.Kind.sectionHeader {
        // if ReusableSupplementaryView is for section header
        if let headerView = self.collectionView.dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: Constants.Identifier.SupplementaryView.planDetailMap,
          for: indexPath
        ) as? PlanDetailMapCollectionReusableView {
          // config view
          switch self.sections[indexPath.section] {
            case .list:
              headerView.config(with: plan, and: fetchedImages)
            default:
              return nil
          }
          return headerView
        }
      }
      
      if kind == Constants.Kind.groupHeader {
        // if ReusableSupplementaryView is for group header
        if let headerView = self.collectionView.dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: Constants.Identifier.SupplementaryView.geneticLabel,
          for: indexPath
        ) as? GeneticLabelCollectionReusableView {
          // config view
          let text = indexPath.row == 0 ? "Start" : "Location: " + String(indexPath.row)
          headerView.configure(lb: TextLabel(text: text))
          return headerView
        }
      }
      
      return nil
    }
    
    // Allow every item to be reordered
    dataSource.reorderingHandlers.canReorderItem = { item in
      print(item)
      return item.category != nil
    }
    // Update snapshot after reorder
    dataSource.reorderingHandlers.didReorder = { [weak self] transaction in
      guard let self = self else { return }
      self.snapshot = transaction.finalSnapshot
    }
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}
