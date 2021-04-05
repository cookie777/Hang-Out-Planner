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
  
  var editingItem : (id: UUID, val: Category)?
  var sections :[Section] = [.list]
  var categories: [Item] = [
    .category((UUID(),.amusement)),
    .category((UUID(),.artAndGallery)),
    .category((UUID(),.cafe)),
    .category((UUID(),.fashion)),
    .category((UUID(),.restaurantAndCafe)),
  ]
  
  init() {
    super.init(collectionViewLayout: UICollectionViewLayout())
    createCollectionViewLayout()
    createDiffableDataSource()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
