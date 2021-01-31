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
    
    setBackButton()
    setMainStackView()
    updateValues()
    setYelpLink()
    
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
    backButton.layer.zPosition = 1
    backButton.layer.shadowColor = UIColor.white.cgColor
    backButton.layer.shadowOffset = CGSize(width: 0, height: -1)
    backButton.layer.shadowRadius = 6
    backButton.layer.shadowOpacity = 0.6

  }
  
  func setMainStackView() {
    view.addSubview(imageView)
    imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: 0).isActive = true
    imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.96).isActive = true
    imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
    imageView.centerXin(view)
    
    let mainStackView = VerticalStackView(
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
    mainStackView.setCustomSpacing(8, after: nameLabel)
    mainStackView.setCustomSpacing(8, after: categoryLabel)
    mainStackView.setCustomSpacing(24, after: ratingLabelWrapper)
    mainStackView.setCustomSpacing(8, after: addressTitle)
    mainStackView.setCustomSpacing(24, after: addressLabel)
    mainStackView.setCustomSpacing(8, after: phoneTitle)
    mainStackView.setCustomSpacing(16, after: phoneLabel)
    
    view.addSubview(mainStackView)
    mainStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32*2).isActive = true
    mainStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24).isActive = true
    mainStackView.centerXin(view)
  }
  
  func updateValues() {
    let boderView = UIView()
    boderView.layer.borderWidth = 3
    boderView.layer.borderColor = Categories.color(location.category).withAlphaComponent(0.7).cgColor
    view.addSubview(boderView)
    boderView.matchParent()
 
   imageView.layer.borderWidth = 0
   imageView.layer.borderColor = Categories.color(location.category).withAlphaComponent(0.7).cgColor


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
  
  func setYelpLink() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(goToYelp))
    yelpLink.isUserInteractionEnabled = true
    yelpLink.addGestureRecognizer(tap)
    yelpLink.setContentHuggingPriority(.required, for: .horizontal)
    yelpLink.textColor = .systemBlue
    yelpLinkLabel.textAlignment = .right
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


//    nameLabel.translatesAutoresizingMaskIntoConstraints = false
//    nameLabel.text = location.title
//    nameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
//    nameLabel.numberOfLines = 0
//    nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
//    nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//    nameLabel.constraintWidth(equalToConstant: 300)
//
//    view.addSubview(categoryLabel)
//    categoryLabel.translatesAutoresizingMaskIntoConstraints = false
//    categoryLabel.text = location.category.rawValue
//    categoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
//    categoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//
//    view.addSubview(ratingLabel)
//    ratingLabel.translatesAutoresizingMaskIntoConstraints = false
//    ratingLabel.text = "★ \(String(location.rating!))(\(String(location.reviewCount!)))"
//    ratingLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10).isActive = true
//    ratingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//
//    view.addSubview(ratingLabel2)
//    ratingLabel2.translatesAutoresizingMaskIntoConstraints = false
//    ratingLabel2.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10).isActive = true
//    ratingLabel2.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 5).isActive = true
//
//    view.addSubview(addressTitle)
//    addressTitle.translatesAutoresizingMaskIntoConstraints = false
//    addressTitle.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 20).isActive = true
//    addressTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//
//    view.addSubview(addressLabel)
//    addressLabel.translatesAutoresizingMaskIntoConstraints = false
//    addressLabel.text = location.address
//    addressLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
//    addressLabel.numberOfLines = 0
//    addressLabel.constraintWidth(equalToConstant: 300)
//    addressLabel.topAnchor.constraint(equalTo: addressTitle.bottomAnchor, constant: 10).isActive = true
//    addressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//
//    view.addSubview(phoneTitle)
//    phoneTitle.translatesAutoresizingMaskIntoConstraints = false
//    phoneTitle.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 20).isActive = true
//    phoneTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//
//    view.addSubview(phoneLabel)
//    phoneLabel.translatesAutoresizingMaskIntoConstraints = false
//    phoneLabel.text = location.phone
//    phoneLabel.topAnchor.constraint(equalTo: phoneTitle.bottomAnchor, constant: 10).isActive = true
//    phoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//
//    view.addSubview(findMoreTitle)
//    findMoreTitle.translatesAutoresizingMaskIntoConstraints = false
//    findMoreTitle.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
//    findMoreTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 200).isActive = true
//
//    view.addSubview(yelpTitle)
//    yelpTitle.translatesAutoresizingMaskIntoConstraints = false
//    yelpTitle.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
//    yelpTitle.leadingAnchor.constraint(equalTo: findMoreTitle.trailingAnchor, constant: 5).isActive = true
//    let tap = UITapGestureRecognizer(target: self, action: #selector(goToYelp))
//        yelpTitle.isUserInteractionEnabled = true
//        yelpTitle.addGestureRecognizer(tap)
//
