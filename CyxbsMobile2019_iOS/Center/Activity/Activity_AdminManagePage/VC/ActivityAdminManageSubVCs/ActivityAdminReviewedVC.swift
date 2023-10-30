//
//  ActivityAdminReviewedVC.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/9/23.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import JXSegmentedView

class ActivityAdminReviewedVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var activities: [Activity] = []
    var titleParagraphStyle = NSMutableParagraphStyle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestReviewingActivities()
        titleParagraphStyle.lineHeightMultiple = 0.85
        view.addSubview(tableView)
        self.tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    //活动展示tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(ActivityReviewedTableViewCell.self, forCellReuseIdentifier: "reviewedCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // UITableViewDataSource方法
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewedCell", for: indexPath) as! ActivityReviewedTableViewCell
        cell.titleLabel.attributedText = NSMutableAttributedString(string: activities[indexPath.item].activityTitle, attributes: [NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        cell.startTimeLabel.text = DateConvert.dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(activities[indexPath.item].activityStartAt)))
        switch activities[indexPath.item].activityType {
        case "culture": cell.typeView.contentLabel.text = "文娱活动"
        case "sports": cell.typeView.contentLabel.text = "体育活动"
        case "education": cell.typeView.contentLabel.text = "教育活动"
        default: break
        }
        cell.phoneView.contentLabel.text = activities[indexPath.item].phone
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 131
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    // UITableViewDelegate方法
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击了cell")
        let detailVC = ActivityDetailVC()
        detailVC.activity = activities[indexPath.row]
        detailVC.wantToWatchButton.removeFromSuperview()
        detailVC.numOfIndexPath = indexPath.row
        self.navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    struct DateConvert {
        static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "zh_CN")
            formatter.dateFormat = "yyyy.MM.dd"
            return formatter
        }()
    }
    
    func requestReviewingActivities() {
        activities = []
        ActivityClient.shared.request(url: "magipoke-ufield/activity/list/examined/",
                                      method: .get,
                                      headers: nil,
                                      parameters: nil) { responseData in
            print(responseData as Any)
            if let dataDict = responseData as? [String: Any],
            let jsonData = try? JSONSerialization.data(withJSONObject: dataDict),
            let reviewingActivityResponseData = try? JSONDecoder().decode(SearchActivityResponse.self, from: jsonData) {
                for activity in reviewingActivityResponseData.data {
                    self.activities.append(activity)
                }
                print("已审核活动数量\(self.activities.count)")
                self.tableView.reloadData()
                if self.activities.count == 0 {
                    ActivityHUD.shared.addProgressHUDView(width: 138,
                                                                height: 36,
                                                                text: "暂无更多内容",
                                                                font: UIFont(name: PingFangSCMedium, size: 13)!,
                                                                textColor: .white,
                                                                delay: 2,
                                                                view: self.view,
                                                                backGroundColor: UIColor(hexString: "#2a4e84"),
                                                                cornerRadius: 18,
                                                                yOffset: Float(-UIScreen.main.bounds.height * 0.5 + UIApplication.shared.statusBarFrame.height) + 90)
                }
            } else {
                print("Invalid response data")
                print(responseData)
            }
        }
    }
}
// MARK: - JXSegmentedListContainerViewListDelegate，返回containerView展示的视图
extension ActivityAdminReviewedVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
