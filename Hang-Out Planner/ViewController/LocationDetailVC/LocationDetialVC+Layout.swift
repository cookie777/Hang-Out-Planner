//
//  LocationDetialVC.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-04-02.
//

import UIKit

extension LocationDetailViewController {
  func configMainScrollView() {
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
  
  func configLabel() {
    nameLabel.text = location.title
    categoryLabel.text = location.category.rawValue
    categoryLabel.textColor = Category.color(location.category)
    
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
  
  func configBackButton() {
    // Set Back button. Independent to other views
    view.addSubview(backButton)
    backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
    backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
    backButton.addTarget(self, action: #selector(backActionTapped), for: .touchUpInside)
    backButton.setTitle("Close", for: .normal)
    backButton.setTitleColor(.systemBlue, for: .normal)
    backButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
    backButton.layer.zPosition = 2
    backButton.layer.shadowColor = UIColor.white.cgColor
    backButton.layer.shadowOffset = CGSize(width: 0, height: -1)
    backButton.layer.shadowRadius = 6
    backButton.layer.shadowOpacity = 0.6
  }
  
  func configYelpLink() {
    yelpLink.setContentHuggingPriority(.required, for: .horizontal)
    yelpLink.textColor = .systemBlue
    yelpLinkLabel.textAlignment = .right
    let tap = UITapGestureRecognizer(target: self, action: #selector(goToYelpTapped))
    yelpLink.isUserInteractionEnabled = true
    yelpLink.addGestureRecognizer(tap)
    yelpLink.layer.zPosition = 2
  }
  
  // When you want to set dynamic scroll view height depends on content, you must set content size.
  func configContentSize() {
    imageView.layoutIfNeeded()
    lowerStackView.layoutIfNeeded()
    mainScrollView.contentSize = CGSize(
      width: self.view.frame.width,
      height: imageView.frame.height + 24 + lowerStackView.frame.height + 48
    )
  }
}


import SafariServices
extension LocationDetailViewController {
  @objc func backActionTapped() {
    self.dismiss(animated: true, completion: nil)
  }
  //  if you tap Yelp Label, you can go to the website.
  @objc func goToYelpTapped() {
    let vc = SFSafariViewController(url: URL(string: location.website!)!)
    present(vc, animated: true)
  }
}
