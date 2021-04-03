//
//  PlanListCVC+Layout.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-30.
//

import UIKit

extension PlanListCollectionViewController {
 
  func createCollectionViewLayout() {
    collectionView.backgroundColor = UIColor.Custom.forBackground
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
      heightDimension: .estimated(160)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: itemSize.heightDimension
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitem: item,
      count: 1
    )
    group.contentInsets = .init(top: 32, leading: 8, bottom: 32, trailing: 16)
    
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 48
    section.contentInsets = .init(top: 16, leading: 32, bottom: 0, trailing: 32)
    section.boundarySupplementaryItems = [createHeader(0, Constants.Kind.sectionHeader)]
    
    return section
  }
  
  /// create group header used in section
  private func createHeader(
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

}
