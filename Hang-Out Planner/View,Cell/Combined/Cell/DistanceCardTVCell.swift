//
//  DistanceCardTVCell.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

class DistanceCardTVCell: CardTVCell {
  
  var arrowEmoji = SubTextLabel(text: "⇣")
  var timeToReach = SubTextLabel(text: "")
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    arrowEmoji.textAlignment = .right
    let hStackView = HorizontalStackView(arrangedSubviews: [arrowEmoji, timeToReach], spacing: 8, alignment: .center, distribution: .equalCentering)
    contentView.addSubview(hStackView)
    hStackView.matchParent()
    self.backgroundColor = bgColor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func update(with route: Route) {
    let minuteToTake = totalMinOnFoot(distance: route.distance)
    timeToReach.text = "\(minuteToTake) mins on foot 🚶‍♀️"
  }
  
  // meter -> how many minutes (1.4m/sec)
  func totalMinOnFoot(distance: Double) -> Double {
    let totalMin = (distance / 1.4) / 60
    return round(totalMin)
  }
  
}
