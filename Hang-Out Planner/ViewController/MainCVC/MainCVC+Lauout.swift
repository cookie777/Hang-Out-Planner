//
//  MainVC+Lauout.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-29.
//

import UIKit

// MARK: - Layout config

extension MainCollectionViewController {
  
  private func createGoButton() {
    //    Add goButton to view (you can modify this)
    view.addSubview(goButton)
    let goButtonSize = goButton.intrinsicContentSize.width
    goButton.translatesAutoresizingMaskIntoConstraints = false
    goButton.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
    goButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: goButtonSize + 16).isActive = true
    goButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
  }
  
  private func createAddButton() {
    view.addSubview(addButton)
    let addButtonSize = addButton.intrinsicContentSize.width
    addButton.translatesAutoresizingMaskIntoConstraints = false
    addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    addButton.centerXAnchor.constraint(
      equalTo: view.centerXAnchor,
      constant:  -1*(16 + addButtonSize)
    ).isActive = true
    addButton.bottomAnchor.constraint(
      equalTo: view.bottomAnchor,
      constant: -40
    ).isActive = true
  }
  
  func createCollectionViewLayout() {
    collectionView.backgroundColor = UIColor.Custom.forBackground
    createGoButton()
    createAddButton()
  
    // compositionalLayout
    collectionView.setCollectionViewLayout(createCompositionalLayout(), animated: false)
  }
  
  private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout
    { [unowned self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
      switch self.sections[sectionIndex] {
        case .list:
          return createSection()
        default:
          return nil
      }
    }
  }
  
  ///Dynamic: 0...number of location are displayed.
  private func createSection() -> NSCollectionLayoutSection {
    
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(60)
    )
    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: groupSize,
      subitem: item,
      count: 1
    )
    group.supplementaryItems = [createGroupHeader()]
    
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 60
    section.contentInsets = .init(top: 24, leading: 32, bottom: 0, trailing: 32)
    section.boundarySupplementaryItems = [createMapSectionHeader(48, Constants.Kind.sectionHeader)]
    
    return section
  }
  
  /// Create layout of header
  private func createMapSectionHeader(
    _ height: CGFloat = 40,
    _ kindOf: String = ""
  ) -> NSCollectionLayoutBoundarySupplementaryItem {
    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(height)
    )
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: kindOf,
      alignment: .top
    )
    return header
  }
  
  /// create group header used in section
  private func createGroupHeader() -> NSCollectionLayoutSupplementaryItem{
    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(0)
    )
    let anchor = NSCollectionLayoutAnchor(edges: [.top], absoluteOffset: CGPoint(x: 0.0, y: -24))
    let groupHeader = NSCollectionLayoutSupplementaryItem(
      layoutSize: headerSize,
      elementKind: Constants.Kind.groupHeader,
      containerAnchor: anchor
    )
    return groupHeader
  }
    
  func updateAddButtonState() {
    addButton.isHidden = snapshot.itemIdentifiers(inSection: .list).count >= 5
  }
  func updateGoButtonState() {
    goButton.isHidden = snapshot.itemIdentifiers(inSection: .list).count == 0
  }

}
