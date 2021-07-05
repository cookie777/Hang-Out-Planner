//
//  LocationDetailViewController.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit
///  This vc is to display location detail when user select at PlanDetailViewController.Priority is Low.
class LocationDetailViewController: UIViewController {
  
  // A location selected at `PlanDetailViewController`
  let location: Location
  
  init(location: Location) {
    self.location = location
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  let backButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let imageView :UIImageView = {
    let imageV = UIImageView()
    imageV.layer.cornerRadius = 8
    imageV.image = nil // later, fill
    imageV.translatesAutoresizingMaskIntoConstraints = false
    imageV.contentMode = .scaleAspectFill
    imageV.layer.masksToBounds = true
    imageV.layer.zPosition = 1
    return imageV
  }()
  
  let nameLabel = LargeHeaderLabel(text:" ")
  let categoryLabel = TextLabel(text: " ")
  
  let ratingLabelLeft = TextLabel(text: " ")
  let ratingLabelRight = TextLabel(text: " on Yelp")
  lazy var ratingLabelWrapper = HorizontalStackView(arrangedSubviews: [ratingLabelLeft, ratingLabelRight])
  
  let addressTitle = SmallHeaderLabel(text: "Address")
  let addressLabel = SubTextLabel(text: " ")
  let phoneTitle = SmallHeaderLabel(text: "Phone")
  let phoneLabel = SubTextLabel(text: " ")
  
  let yelpLinkLabel = SubTextLabel(text: "Find more on")
  let yelpLink = TextLabel(text: "  Yelp")
  lazy var yelpLinkWrapper = HorizontalStackView(arrangedSubviews: [yelpLinkLabel, yelpLink])
  
  lazy var lowerStackView = VerticalStackView(
    arrangedSubviews: [
      nameLabel,
      categoryLabel,
      ratingLabelWrapper,
      addressTitle,
      addressLabel,
      phoneTitle,
      phoneLabel,
      yelpLinkWrapper
    ])
  
  let mainScrollView = UIScrollView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    // If there is no image, try fetch.
    if imageView.image == nil {
      let locationUrl = location.imageURL
      NetworkController.shared.fetchImage(urlString: locationUrl) { (fetchedimage) in
        guard let fetchedImage = fetchedimage else {return}
        DispatchQueue.main.async {
          self.imageView.image = fetchedImage
        }
      }
    }
    
    // config basic layout
    configMainScrollView()
    configLabel()
    
    // config links. Adding button or gestureRec has to be later than scroll bar.
    configYelpLink()
    configBackButton()
    
    // This has to be last. Because layoutifneeded has to be done, after every element has added.
    configContentSize()
  }
}




