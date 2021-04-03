//
//  LocationCardCVCell.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-31.
//

import UIKit

class LocationCardCVCell: BasicCardCollectionViewCell {
  var locationTitleLabel = SmallHeaderLabel(text: "")
  var addressLabel = SubTextLabel(text: "")
  
  lazy var locationImageView : UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "tempImage")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.constraintWidth(equalToConstant: (frame.size.width - 32*2)*0.4)
    imageView.constraintHeight(equalToConstant: (frame.size.width - 32*2)*0.4*0.76)
    imageView.contentMode = .scaleAspectFill
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = 16
    
    return imageView
  }()

  
  lazy var locationStackView = VerticalStackView(
    arrangedSubviews: [locationTitleLabel, addressLabel],
    spacing: 8,
    alignment: .leading,
    distribution: .fill
  )
  
  lazy var mainStackView = HorizontalStackView(
    arrangedSubviews: [locationStackView, locationImageView],
    spacing: 16,
    alignment: .top
  )
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // Set margin of Stack vew
    mainStackView.isLayoutMarginsRelativeArrangement = true
    mainStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    
    contentView.addSubview(mainStackView)
    mainStackView.matchParent()

    locationTitleLabel.numberOfLines = 2
    addressLabel.numberOfLines = 2
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func update(with index: Int, and location: Location, and fetchedImages: FetchedImages ) {
    // set cell color based on location's category
    let color = Category.color(location.category)
    // set location title
    locationTitleLabel.text = location.title
    // set grey color if starting point
    locationTitleLabel.textColor = location.id == 0 ? .systemGray : color
    // set location address
    addressLabel.text = location.address
    mainBackground.layer.borderColor = color.withAlphaComponent(0.6).cgColor
    
    fetchAndApplyImage(index, location.imageURL, fetchedImages)
  }
  
  func fetchAndApplyImage(_ index: Int, _ url: String?, _ fetchedImages: FetchedImages) {
    // If some image has already existed, avoid fetching
    if let image = fetchedImages.source![index] {
      locationImageView.image = image
      return
    }

    // if there is no image, and imageURL is available
    NetworkController.shared.fetchImage(urlString: url) { (image) in
      guard let image = image else {return}
      fetchedImages.source![index] = image
      DispatchQueue.main.async {
        self.locationImageView.image = fetchedImages.source![index]
      }
    }
  }
}
