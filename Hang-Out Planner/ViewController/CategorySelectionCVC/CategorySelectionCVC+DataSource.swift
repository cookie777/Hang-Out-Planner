//
//  CategorySelectionCVC+DataSource.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-04-04.
//

import UIKit

extension CategorySelectionCollectionViewController {
  func resetSnapshot() {
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
    // supplementary (top header)
    collectionView.register(
      CategorySelectionCollectionReusableView.self,
      forSupplementaryViewOfKind: Constants.Kind.sectionHeader,
      withReuseIdentifier: CategorySelectionCollectionReusableView.identifier
    )
    // supplementary (other header)
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
    snapshot.appendItems(categories, toSection: .list)
    
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
              return cell
            default:
              return nil
          }
        }
    )
    
    dataSource.supplementaryViewProvider = {
      [unowned self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
      
      // if ReusableSupplementaryView is for section header
      if let headerView = self.collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: CategorySelectionCollectionReusableView.identifier,
        for: indexPath
      ) as? CategorySelectionCollectionReusableView {
        return headerView
      }
      return nil
    }
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}




//  override func numberOfSections(in collectionView: UICollectionView) -> Int {
//    return sections.count
//  }
//
//  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    switch sections[section] {
//      case .list:
//        return items.count
//      default:
//        return 0
//    }
//  }
//
//  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCardCVCell.identifier, for: indexPath) as? CategoryCardCVCell else { return UICollectionViewCell() }
//
//    cell.category = items[indexPath.row].category
//
//    return cell
//  }
