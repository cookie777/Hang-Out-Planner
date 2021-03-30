//
//  MainVC+DataSource.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-29.
//

import UIKit

// MARK: - DataSource config

extension MainViewController {
  
  /// Delete all items of snapshot
  private func resetSnapshot() {
    snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    snapshot.deleteAllItems()
    snapshot.appendSections([.list])
  }
  
  /// Define Diffable Data source
  func createDiffableDataSource(){
    resetSnapshot()
    snapshot.appendItems(Item.wrapCategory(items: [.cafe, .amusement, .artAndGallery]), toSection: .list)
    
    dataSource = UICollectionViewDiffableDataSource<Section, Item>(
      collectionView: collectionView,
      cellProvider:
        { [unowned self] (collectionView, indexPath, item) -> UICollectionViewCell? in
          
          switch self.sections[indexPath.section] {
            case .list:
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constants.Identifier.Cell.list,
                for: indexPath
              ) as! CardCVCell
              
              // cell.location.text = String(indexPath.row)
              cell.location.text = item.category?.rawValue
              cell.delegate = self
              return cell
          }
        }
    )
    
    
    dataSource.supplementaryViewProvider = {
      [unowned self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
      
      if kind == Constants.Kind.sectionHeader {
        // if ReusableSupplementaryView is for section header
        if let headerView = self.collectionView.dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: Constants.Identifier.SupplementaryView.mapSection,
          for: indexPath
        ) as? MapHeaderCollectionReusableView {
          // config view
          switch self.sections[indexPath.section] {
            case .list:
              headerView.configure()
          }
          return headerView
        }
      }
      
      if kind == Constants.Kind.groupHeader {
        // if ReusableSupplementaryView is for group header
        if let headerView = self.collectionView.dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: Constants.Identifier.SupplementaryView.header,
          for: indexPath
        ) as? HeaderCollectionReusableView {
          // config view
          headerView.configure(lb: SmallHeaderLabel(text: String(indexPath.row)))
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
