//
//  MainVC+AddEditItem.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-29.
//

import UIKit

// MARK: - AddEdit config

extension MainCollectionViewController: AddEditCategoryDelegate {
  // When edit is finished
  func edit(_ newItem: (id: UUID, val: Category), _ oldItem: (id: UUID, val: Category)) {
    snapshot.insertItems([Item.category(newItem)], afterItem: Item.category(oldItem))
    snapshot.deleteItems([Item.category(oldItem)])
      dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
  }
  // When add is finished
  func addCategory(_ category: Category) {
    let newItem = Item.category((UUID(), category))
    snapshot.appendItems([newItem], toSection: .list)
    dataSource.apply(snapshot, animatingDifferences: true)
    
    updateAddButtonState()
    updateGoButtonState()
    
    collectionView.scrollToItem(
      at: IndexPath(item: snapshot.numberOfItems(inSection: .list) - 1,
                    section: sections.firstIndex(of: .list) ?? 0),
      at: .bottom,
      animated: true
    )
  }
  // when item is selected
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let didSelectItem = snapshot.itemIdentifiers(inSection: .list)[indexPath.row]
    
    let addEditVC = CategorySelectViewController()
    addEditVC.editingItem = (didSelectItem.categoryId!, didSelectItem.category!)
    addEditVC.delegate = self
    let addToDoVC = UINavigationController(rootViewController: addEditVC)
    addToDoVC.hideBarBackground() // hide nv bar background.
    present(addToDoVC, animated: true, completion: nil)
  }

  @objc func addButtonTapped(){
    let addEditVC = CategorySelectViewController()
    addEditVC.delegate = self
    let addToDoVC = UINavigationController(rootViewController: addEditVC)
    addToDoVC.hideBarBackground() // hide nv bar background.
    present(addToDoVC, animated: true, completion: nil)
  }

  @objc func goButtonTapped(){
    // If no user location, stop going next
    guard let _ = UserLocationController.shared.coordinatesMostRecent else {
      print("no user location, try it again!")
      return
    }
    // This is to avoid pushing many times. We will enable it at view will appear.
    // this will be true in will apear
    goButton.isEnabled = false
    
    let selectCategories = snapshot.itemIdentifiers(inSection: .list).map {$0.category!}
    
    if noMoreAPI { // Debug mode. If true, it will only use sample data.
      transitWithDebugMode(selectCategories)
      return
    }
    
    // If user has moved or if there is no locations data,
    // then re-create(request, and calculate) all data
    if UserLocationController.shared.hasUserMoved() || allLocations.count <= 21 {
      transitWithApiRequest(selectCategories)
    }else{
    // otherwise reuse calc data.
      transitWithNoApiRequest(selectCategories)
    }
  }
}
