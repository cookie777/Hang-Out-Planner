//
//  MainVC+DataSource.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-29.
//

import UIKit

// MARK: - DataSource config

extension MainCollectionViewController {
  
  /// Delete all items of snapshot
  private func resetSnapshot() {
    snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    snapshot.deleteAllItems()
    snapshot.appendSections([.list])
  }
  
  private func register(){
    // cell
    collectionView.register(
      CategoryCardCVCell.self,
      forCellWithReuseIdentifier: CategoryCardCVCell.identifier
    )
    // supplementary (header)
    collectionView.register(
      MainMapCollectionReusableView.self,
      forSupplementaryViewOfKind: Constants.Kind.sectionHeader,
      withReuseIdentifier: MainMapCollectionReusableView.identifier
    )
    // supplementary (group header)
    collectionView.register(
      GeneticLabelCollectionReusableView.self,
      forSupplementaryViewOfKind: Constants.Kind.groupHeader,
      withReuseIdentifier: GeneticLabelCollectionReusableView.identifier
    )
  }
  
  /// Define Diffable Data source
  func createDiffableDataSource(){
    resetSnapshot()
    register()
    snapshot.appendItems(Item.wrapCategory(items: [.cafe, .amusement, .artAndGallery]), toSection: .list)
    
    dataSource = UICollectionViewDiffableDataSource<Section, Item>(
      collectionView: collectionView,
      cellProvider:
        { [unowned self] (collectionView, indexPath, item) -> UICollectionViewCell? in
          
          switch self.sections[indexPath.section] {
          case .list:
            let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: CategoryCardCVCell.identifier,
              for: indexPath
            ) as! CategoryCardCVCell
         
            cell.category = item.category
            cell.delegate = self //swipe
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
          withReuseIdentifier: MainMapCollectionReusableView.identifier,
          for: indexPath
        ) as? MainMapCollectionReusableView {
          // config view
          switch self.sections[indexPath.section] {
          case .list:
            headerView.configure()
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
          withReuseIdentifier: GeneticLabelCollectionReusableView.identifier,
          for: indexPath
        ) as? GeneticLabelCollectionReusableView {
          // config view
          let headerText = "Location: " + String(indexPath.row + 1)
          headerView.configure(lb: TextLabel(text: headerText))
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
    dataSource.reorderingHandlers.didReorder = { [unowned self] transaction in
      self.snapshot = transaction.finalSnapshot
    }
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}
