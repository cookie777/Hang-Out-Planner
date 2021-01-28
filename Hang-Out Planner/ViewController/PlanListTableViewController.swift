//
//  PlanListTableViewController.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import UIKit

///  Screen which display list of plan `[Plan]`.
///  Receive `[Plan]` from Planner.
///  If user select one of `Plan`, it will move to next VC.
class PlanListTableViewController: UITableViewController {
  
  // [Plan] you receive from planner model
  let plans: [Plan]
  var cellId = "planCardCell"
  let headerTitle = LargeHeaderLabel(text: "Where Do You \nWant To Go?")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = bgColor

//    view.backgroundColor = .systemBackground
    tableView.register(PlanCardTVCell.self, forCellReuseIdentifier: cellId)
    
    

    // Set upper view as `tableHeaderView` of the table view.
    headerTitle.constraintHeight(equalToConstant: headerTitle.intrinsicContentSize.height + 24)
    let thv = headerTitle
    tableView.tableHeaderView = thv
    thv.translatesAutoresizingMaskIntoConstraints = false
    tableView.tableHeaderView?.anchors(
      topAnchor: nil,
      leadingAnchor: tableView.layoutMarginsGuide.leadingAnchor,
      trailingAnchor: nil,
      bottomAnchor: nil,
      padding: .init(top: nil, left: 12, right: 0, bottom: 0)
    )

    // We need to set layout of header at this time. Otherwise (if we do it later), it will Overflow!
    tableView.tableHeaderView?.setNeedsLayout()
    tableView.tableHeaderView?.layoutIfNeeded()
    tableView.directionalLayoutMargins =  NSDirectionalEdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32)

  }
  
  init(plans: [Plan]) {
    self.plans = plans
    super.init(style: .insetGrouped)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->    Int {
    return plans.count
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PlanCardTVCell
    let plan = plans[indexPath.row]
    cell.update(with: plan, planIndex: indexPath.row)

    
    return cell
  }
  
  // Cell Select -> move to PlanDetailVC
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let planDetailVC = PlanDetailViewController(plan: plans[indexPath.section])
    navigationController?.pushViewController(planDetailVC, animated: true)
  }
  
  
}
