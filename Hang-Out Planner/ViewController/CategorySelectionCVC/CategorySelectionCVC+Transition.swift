//
//  CategorySelectionCVC+transition.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-04-04.
//

import UIKit

protocol AddEditItemDelegate: class{
  func edit(_ newItem: (id: UUID, val: Category), _ oldItem: (id: UUID, val: Category))
  func addCategory(_ category: Category)
}

extension CategorySelectionCollectionViewController {
  @objc func dismissViewController() {
    dismiss(animated: true, completion: nil)
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // get new category
    guard let newCategory = snapshot.itemIdentifiers(inSection: .list)[indexPath.row].category else { return }
    
    // if you get old item (== editing , not adding), try to update.
    if let oldItem = editingItem {
      let newItem = (oldItem.id, newCategory)
      // if new and old is same, do nothing
      if newItem != oldItem {
        delegate?.edit(newItem, oldItem)
      }
    } else {
    // adding
      delegate?.addCategory(newCategory)
    }
    
    dismissViewController()
  }
}
