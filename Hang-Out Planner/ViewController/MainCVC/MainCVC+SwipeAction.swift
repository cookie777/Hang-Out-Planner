//
//  MainVC+SwipeAction.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-29.
//
import SwipeCellKit


extension MainCollectionViewController: SwipeCollectionViewCellDelegate {
  func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else { return nil }
    
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [unowned self ]action, indexPath in
      // handle action by updating model with deletion
      let item = snapshot.itemIdentifiers(inSection: .list)[indexPath.row]
      snapshot.deleteItems([item])
      dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
      updateAddButtonState()
      updateGoButtonState()
    }
    
    // customize the action appearance
    deleteAction.image = UIImage(systemName: "heart.fill")
    
    return [deleteAction]
  }
}
