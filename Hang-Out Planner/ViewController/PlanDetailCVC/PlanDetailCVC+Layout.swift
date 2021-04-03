//
//  PlanDetailCVC+Layout.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-31.
//

import UIKit

extension PlanDetailCollectionViewController {
  
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
  
  ///Dynamic: 0...number of location are displayed.
  private func createSection() -> NSCollectionLayoutSection {
    
    let locationHeight: CGFloat = 104
    let distanceHeight: CGFloat = 96
    
    
    let locationItemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(locationHeight)
    )
    let locationItem = NSCollectionLayoutItem(layoutSize: locationItemSize)
    
    let distanceItemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(distanceHeight)
    )
    let distanceItem = NSCollectionLayoutItem(layoutSize: distanceItemSize)

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(locationHeight + distanceHeight)
    )
    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: groupSize,
      subitems: [locationItem, distanceItem]
    )
    group.supplementaryItems = [createGroupHeader()]
    
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 16
    section.contentInsets = .init(top: 40, leading: 32, bottom: 0, trailing: 32)
    section.boundarySupplementaryItems = [createMapSectionHeader(400, Constants.Kind.sectionHeader)]
    
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
    


}
