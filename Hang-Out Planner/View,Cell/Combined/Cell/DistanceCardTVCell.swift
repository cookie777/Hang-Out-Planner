//
//  DistanceCardTVCell.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

class DistanceCardTVCell: CardTVCell {
  
  //  var arrowEmoji = SubTextLabel(text: "⇣")
  var arrowEmoji = UIImageView(image: UIImage(systemName: "arrowtriangle.down.fill")?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal))
  var timeToReachByWalk = SubTextLabel(text: "")
  var timeToReachByCar = SubTextLabel(text: "")

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    //    arrowEmoji.textAlignment = .right
    contentView.addSubview(arrowEmoji)
    arrowEmoji.centerXin(contentView)
//    let hStackView = HorizontalStackView(arrangedSubviews: [timeToReachByCar, arrowEmoji, timeToReachByWalk], spacing: 8, alignment: .center, distribution: .equalCentering)
//    contentView.addSubview(hStackView)
//    hStackView.matchParent()
    self.backgroundColor = bgColor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func update(with route: Route) {
    let minuteToCar = totalMinOnCar(distance: route.distance)
    let minuteToTake = totalMinOnFoot(distance: route.distance)
    timeToReachByCar.text = "\(minuteToCar) mins 🚗"
    timeToReachByWalk.text = "\(minuteToTake) mins 🚶‍♀️"
  }
  
  // meter -> how many minutes (1.4m/sec)
  func totalMinOnFoot(distance: Double) -> Double {
    let totalMin = (distance / 1.4) / 60
    return round(totalMin)
  }
  func totalMinOnCar(distance: Double) -> Double {
    let totalMin = (distance / 1.4) / 60 / 8
    return round(totalMin)
  }

}
