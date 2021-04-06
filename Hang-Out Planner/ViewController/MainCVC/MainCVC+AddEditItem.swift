//
//  MainVC+AddEditItem.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-29.
//

import UIKit


// MARK: - AddEdit delegate func

extension MainCollectionViewController: AddEditItemDelegate {
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
      at: IndexPath(item: snapshot.numberOfItems(inSection: .list) - 1, section: sections.firstIndex(of: .list) ?? 0),
      at: .bottom,
      animated: true
    )
  }
}


// MARK: - AddEdit config

extension MainCollectionViewController {
  // when item is selected
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let editingItem = snapshot.itemIdentifiers(inSection: .list)[indexPath.row]
    
    let editVC = CategorySelectionCollectionViewController(
      (editingItem.categoryId!,editingItem.category!)
    )
    editVC.delegate = self
    let nextVC = UINavigationController(rootViewController: editVC)
    nextVC.clearNavigationBar(with: UIColor.Custom.forBackground)
    present(nextVC, animated: true, completion: nil)
  }

  //when add button is tapped
  @objc func addButtonTapped(){
    let addVC = CategorySelectionCollectionViewController()
    addVC.delegate = self
    let nextVC = UINavigationController(rootViewController: addVC)
    nextVC.clearNavigationBar(with: UIColor.Custom.forBackground)
    present(nextVC, animated: true, completion: nil)
  }

  // when go button is tapped
  @objc func goButtonTapped(){
    // If no user location, stop going next
    guard let _ = LocationController.shared.coordinatesOfMostRecent else {
      print("no user location, try it again!")
      return
    }
    // This is to avoid pushing many times. We will enable it at view will appear.
    // this will be true in will apear
    goButton.isEnabled = false
    
    let selectCategories = snapshot.itemIdentifiers(inSection: .list).map {$0.category!}
    
    if Constants.Debug.noMoreAPI { // Debug mode. If true, it will only use sample data.
      transitWithDebugMode(selectCategories)
      return
    }
    
    // If user has moved or if there is no locations data,
    // then re-create(request, and calculate) all data
    if LocationController.shared.hasUserMoved() || User.allLocations.count <= 21 {
      transitWithApiRequest(selectCategories)
    }else{
    // otherwise reuse calc data.
      transitWithNoApiRequest(selectCategories)
    }
  }
}
