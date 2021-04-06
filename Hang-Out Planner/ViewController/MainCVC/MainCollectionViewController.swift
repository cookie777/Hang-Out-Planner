//
//  MainViewController.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit


// MARK: - Basics

class MainCollectionViewController : UICollectionViewController {
  let sections: [Section] = [.list]
  
  var snapshot: NSDiffableDataSourceSnapshot<Section, Item>!
  var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
  
  var goButton = GoButton()
  var addButton = AddButton()
  
  init() {
    super.init(collectionViewLayout: UICollectionViewLayout())
    
    createCollectionViewLayout()
    createDiffableDataSource()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
