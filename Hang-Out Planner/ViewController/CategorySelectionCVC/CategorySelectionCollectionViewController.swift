//
//  CategorySelectionCollectionViewController.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-04-04.
//

import UIKit

class CategorySelectionCollectionViewController: UICollectionViewController {
  weak var delegate: AddEditItemDelegate?
  
  var snapshot: NSDiffableDataSourceSnapshot<Section, Item>!
  var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
  
  /// attach uuid to allow multiple same category in the snapshot.
  var editingItem : (id: UUID, val: Category)?
  var sections :[Section] = [.list]
  var categories: [Category] = [
    .amusement,
    .artAndGallery,
    .cafe,
    .fashion,
    .restaurantAndCafe
  ]
  
  init(_ editingItem: (id: UUID, val: Category)? = nil) {
    super.init(collectionViewLayout: UICollectionViewLayout())
    setUpEditingItem(editingItem)
    createCollectionViewLayout()
    createDiffableDataSource()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
