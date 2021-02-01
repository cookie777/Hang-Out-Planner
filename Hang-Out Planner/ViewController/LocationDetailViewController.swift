//
//  LocationDetailViewController.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit
import SafariServices

///  This vc is to display location detail when user select at PlanDetailViewController.Priority is Low.
class LocationDetailViewController: UIViewController,UITextViewDelegate {
  
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
    
    
    setMainScrollView()
    updateValues()
    
    // Adding button or gestureRec has to be later than scroll bar.
    setYelpLink()
    setBackButton()
    
    // This has to be last. Because layoutifneeded has to be done, after every element has added.
    setContentSize()
  }
  

  func setMainScrollView() {
    
    // Set scroll view
    view.addSubview(mainScrollView)
    mainScrollView.matchParent()
    mainScrollView.addSubview(imageView)
    mainScrollView.isScrollEnabled = true
    
    // Set image view
    imageView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor, multiplier: 1, constant: 0).isActive = true
    imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1).isActive = true
    //    imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
    imageView.centerXin(mainScrollView)
    
    // Set stackview
    lowerStackView.setCustomSpacing(8, after: nameLabel)
    lowerStackView.setCustomSpacing(8, after: categoryLabel)
    lowerStackView.setCustomSpacing(24, after: ratingLabelWrapper)
    lowerStackView.setCustomSpacing(8, after: addressTitle)
    lowerStackView.setCustomSpacing(24, after: addressLabel)
    lowerStackView.setCustomSpacing(8, after: phoneTitle)
    lowerStackView.setCustomSpacing(16, after: phoneLabel)
    
    mainScrollView.addSubview(lowerStackView)
    lowerStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor, constant: -32*2).isActive = true
    lowerStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24).isActive = true
    lowerStackView.centerXin(mainScrollView)
    

    
  }
  
  
  func updateValues() {

    
    nameLabel.text = location.title
    categoryLabel.text = location.category.rawValue
    categoryLabel.textColor = Categories.color(location.category)
    
    var rating = " "
    var reviewCount = " "
    if let ra = (location.rating){rating = "\(ra)"}
    if let re = (location.reviewCount){reviewCount = "\(re)"}
    ratingLabelLeft.text = "★ \(rating)(\(reviewCount))"
    ratingLabelLeft.textColor = .systemOrange
    ratingLabelLeft.setContentHuggingPriority(.required, for: .horizontal)
    
    addressLabel.text = location.address
    phoneLabel.text = location.phone ?? " "
  }
  
  func setBackButton() {
    
    // Set Back button. Independent to other views
    view.addSubview(backButton)
    backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
    backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
    backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    backButton.setTitle("Close", for: .normal)
    backButton.setTitleColor(.systemBlue, for: .normal)
    backButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
    backButton.layer.zPosition = 2
    backButton.layer.shadowColor = UIColor.white.cgColor
    backButton.layer.shadowOffset = CGSize(width: 0, height: -1)
    backButton.layer.shadowRadius = 6
    backButton.layer.shadowOpacity = 0.6
    
  }
  
  
  func setYelpLink() {
    yelpLink.setContentHuggingPriority(.required, for: .horizontal)
    yelpLink.textColor = .systemBlue
    yelpLinkLabel.textAlignment = .right
    let tap = UITapGestureRecognizer(target: self, action: #selector(goToYelp))
    yelpLink.isUserInteractionEnabled = true
    yelpLink.addGestureRecognizer(tap)
    yelpLink.layer.zPosition = 2
  }
  
  // When you want to set dynamic scroll view height depends on content, you must set content size.
  func setContentSize() {
    imageView.layoutIfNeeded()
    lowerStackView.layoutIfNeeded()
    mainScrollView.contentSize = CGSize(
      width: self.view.frame.width,
      height: imageView.frame.height + 24 + lowerStackView.frame.height + 48
    )
  }
  
  @objc func backAction() {
    self.dismiss(animated: true, completion: nil)
  }
  //  if you tap Yelp Label, you can go to the website.
  @objc func goToYelp() {
    let vc = SFSafariViewController(url: URL(string: location.website!)!)
    present(vc, animated: true)
  }
}




