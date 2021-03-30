//
//  MainViewController.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit


// MARK: - Basics

class MainViewController : UICollectionViewController {
  enum Section: Hashable {
    case list
  }

  enum Item: Hashable{
    case category((id: UUID, val: Category))
    
    var id: UUID? {
      if case let .category(c) = self {
        return c.id
      } else {
        return nil
      }
    }// wrapper -> associate value
    var category: Category? {
      if case let .category(c) = self {
        return c.val
      } else {
        return nil
      }
    }
    
    // associate value -> wrapper
    static func wrapCategory(items: [Category]) -> [Item] {
      return items.map {Item.category((UUID(), $0))}
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(self.id)
      hasher.combine(self.category)
    }
    static func == (lhs: Item, rhs: Item) -> Bool {
      return lhs.hashValue == rhs.hashValue
    }
  }
  
  let sections: [Section] = [.list]
  
  var snapshot: NSDiffableDataSourceSnapshot<Section, Item>!
  var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
  
  var goButton = GoButton()
  var addButton = AddButton()
  
  override func viewDidLoad() {
    createViewControllerLayout()
    createCollectionViewLayout()
    createDiffableDataSource()
  }
}



// move later
// MARK: - Model
import SwipeCellKit

class CardCVCell: SwipeCollectionViewCell {
  let location = SmallHeaderLabel(text: "aaa")
  let category = SmallHeaderLabel(text: "list")
  lazy var stackView = VerticalStackView(arrangedSubviews: [location, category])
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.backgroundColor = .cyan
    contentView.addSubview(stackView)
    stackView.matchParent()
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var c: Category? = nil
  func config(c: Category) {
    self.c = c
  }
}
