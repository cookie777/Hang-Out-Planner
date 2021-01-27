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
  
  let image :UIImageView = {
    let image = UIImageView()
    image.image = UIImage(named: "tempImage")
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()
  
  let nameLabel = LargeHeaderLabel(text:"")
  let categoryLabel = TextLabel(text: "")
  let ratingLabel = TextLabel(text: "")
  let ratingLabel2 = TextLabel(text: "on Yelp")
  let addressTitle = SmallHeaderLabel(text: "Address")
  let addressLabel = SubTextLabel(text: "")
  let phoneTitle = SmallHeaderLabel(text: "Phone")
  let phoneLabel = SubTextLabel(text: "")
  let findMoreTitle = SmallHeaderLabel(text: "Find more on")
  let yelpTitle = SmallHeaderLabel(text: "Yelp")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    view.addSubview(backButton)
    backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
    backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    backButton.setTitle("Back", for: .normal)
    backButton.setTitleColor(.systemBlue, for: .normal)
    backButton.constraintWidth(equalToConstant: 40)
    backButton.constraintHeight(equalToConstant: 40)
    
    view.addSubview(image)
    image.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
    image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    image.constraintHeight(equalToConstant: 300)
    
    view.addSubview(nameLabel)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.text = location.title
    nameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
    nameLabel.numberOfLines = 0
    nameLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10).isActive = true
    nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    nameLabel.constraintWidth(equalToConstant: 300)
    
    view.addSubview(categoryLabel)
    categoryLabel.translatesAutoresizingMaskIntoConstraints = false
    categoryLabel.text = location.category.rawValue
    categoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
    categoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    
    view.addSubview(ratingLabel)
    ratingLabel.translatesAutoresizingMaskIntoConstraints = false
    ratingLabel.text = "★ \(String(location.rating!))(\(String(location.reviewCount!)))"
    ratingLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10).isActive = true
    ratingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    
    view.addSubview(ratingLabel2)
    ratingLabel2.translatesAutoresizingMaskIntoConstraints = false
    ratingLabel2.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10).isActive = true
    ratingLabel2.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 5).isActive = true
    
    view.addSubview(addressTitle)
    addressTitle.translatesAutoresizingMaskIntoConstraints = false
    addressTitle.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 20).isActive = true
    addressTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    
    view.addSubview(addressLabel)
    addressLabel.translatesAutoresizingMaskIntoConstraints = false
    addressLabel.text = location.address
    addressLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
    addressLabel.numberOfLines = 0
    addressLabel.constraintWidth(equalToConstant: 300)
    addressLabel.topAnchor.constraint(equalTo: addressTitle.bottomAnchor, constant: 10).isActive = true
    addressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    
    view.addSubview(phoneTitle)
    phoneTitle.translatesAutoresizingMaskIntoConstraints = false
    phoneTitle.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 20).isActive = true
    phoneTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    
    view.addSubview(phoneLabel)
    phoneLabel.translatesAutoresizingMaskIntoConstraints = false
    phoneLabel.text = location.phone
    phoneLabel.topAnchor.constraint(equalTo: phoneTitle.bottomAnchor, constant: 10).isActive = true
    phoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    
    view.addSubview(findMoreTitle)
    findMoreTitle.translatesAutoresizingMaskIntoConstraints = false
    findMoreTitle.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    findMoreTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 200).isActive = true
    
    view.addSubview(yelpTitle)
    yelpTitle.translatesAutoresizingMaskIntoConstraints = false
    yelpTitle.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    yelpTitle.leadingAnchor.constraint(equalTo: findMoreTitle.trailingAnchor, constant: 5).isActive = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(goToYelp))
        yelpTitle.isUserInteractionEnabled = true
        yelpTitle.addGestureRecognizer(tap)
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
