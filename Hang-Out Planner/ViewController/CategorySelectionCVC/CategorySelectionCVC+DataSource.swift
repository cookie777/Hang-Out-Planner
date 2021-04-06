//
//  CategorySelectionCVC+DataSource.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-04-04.
//

import UIKit

extension CategorySelectionCollectionViewController {
  
  
  /// If there is an editing Item, set it and bring the category to first
  /// - Parameter editingItem: the item(category) using is editing
  func setUpEditingItem(_ editingItem: (id: UUID, val: Category)?) {
    guard let editingItem = editingItem else { return }
    guard let editingCategoryIndex = categories.firstIndex(of: editingItem.val) else { return }
    
    self.editingItem = editingItem
    categories.remove(at: editingCategoryIndex)
    categories.insert(editingItem.val, at: 0)
  }
  
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
    snapshot.appendItems(Item.wrapCategory(items: categories), toSection: .list)
    
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
              
              // display check mark if the cell is editing category
              if editingItem?.val == item.category {
                cell.checkmark.isHidden = false
              }
              
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
