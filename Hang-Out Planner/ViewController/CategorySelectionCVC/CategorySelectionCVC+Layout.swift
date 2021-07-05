//
//  CategorySelectionCVC.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-04-04.
//

import UIKit

extension CategorySelectionCollectionViewController {
  func createCollectionViewLayout() {
    view.backgroundColor = UIColor.Custom.forBackground
    collectionView.backgroundColor = UIColor.Custom.forBackground
    // close button
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
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
  
  private func createSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(Constants.UI.categoryCellHeight)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: itemSize.heightDimension
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    group.contentInsets = .init(top: 32, leading: 0, bottom: 32, trailing: 0)
    
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 24
    section.contentInsets = .init(top: 16, leading: 32, bottom: 0, trailing: 32)
    section.boundarySupplementaryItems = [createHeader(Constants.Kind.sectionHeader)]
    return section
  }
  
  /// create group header used in section
  private func createHeader(
    _ kindOf: String = "",
    _ height: CGFloat = 0
  ) -> NSCollectionLayoutBoundarySupplementaryItem {
    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0*0.98),
      heightDimension: .estimated(height)
    )
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: kindOf,
      alignment: .top
    )
    return header
  }
  
}
