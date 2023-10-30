//
//  ActivityAdminReviewingVC.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/9/21.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import JXSegmentedView

class ActivityAdminReviewingVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
        tableView.register(ActivityReviewingTableViewCell.self, forCellReuseIdentifier: "reviewingCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // UITableViewDataSource方法
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewingCell", for: indexPath) as! ActivityReviewingTableViewCell
        cell.titleLabel.attributedText = NSMutableAttributedString(string: activities[indexPath.item].activityTitle, attributes: [NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        cell.startTimeLabel.text = DateConvert.dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(activities[indexPath.item].activityStartAt)))
        switch activities[indexPath.item].activityType {
        case "culture": cell.typeView.contentLabel.text = "文娱活动"
        case "sports": cell.typeView.contentLabel.text = "体育活动"
        case "education": cell.typeView.contentLabel.text = "教育活动"
        default: break
        }
        cell.creatorView.contentLabel.text = activities[indexPath.item].activityCreator
        cell.phoneView.contentLabel.text = activities[indexPath.item].phone
        cell.activityId = activities[indexPath.item].activityId
        cell.agreeButton.addTarget(self, action: #selector(refreshReviewingActivities), for: .touchUpInside)
        cell.agreeButtonTappedHandler = { [weak self] activityId in
            self?.agreeButtonTapped(activityId: activityId)
        }
        cell.rejectButtonTappedHandler = { [weak self] activityId in
            self?.rejectButtonTapped(activityId: activityId)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 202
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    // UITableViewDelegate方法
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击了cell")
        let detailVC = ActivityDetailVC()
        detailVC.activity = activities[indexPath.row]
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
        ActivityClient.shared.request(url: "magipoke-ufield/activity/list/tobe-examine/",
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
                print("待审核活动数量\(self.activities.count)")
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
                                                          yOffset: Float(-UIScreen.main.bounds.width + UIApplication.shared.statusBarFrame.height) + 78)
                }
            } else {
                print("Invalid response data")
                print(responseData)
            }
        }
    }
    
    @objc func refreshReviewingActivities() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.requestReviewingActivities()
        }
    }
    
    func agreeButtonTapped(activityId: Int) {
        var hudText: String = ""
        //审核活动“同意”网络请求
        ActivityClient.shared.request(url:"magipoke-ufield/activity/action/examine/?activity_id=\(activityId)&decision=pass",
                                      method: .put,
                                      headers: nil,
                                      parameters: nil) { responseData in
            if let dataDict = responseData as? [String: Any],
               let jsonData = try? JSONSerialization.data(withJSONObject: dataDict),
               let examineResponseData = try? JSONDecoder().decode(StandardResponse.self, from: jsonData) {
                print(examineResponseData)
                if (examineResponseData.status == 10000) {
                    hudText = "审核成功"
                } else {
                    hudText = examineResponseData.info
                }
                if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                    ActivityHUD.shared.addProgressHUDView(width: TextManager.shared.calculateTextWidth(text: hudText, font: UIFont(name: PingFangSCMedium, size: 13)!)+40,
                                                                height: 36,
                                                                text: hudText,
                                                                font: UIFont(name: PingFangSCMedium, size: 13)!,
                                                                textColor: .white,
                                                                delay: 2,
                                                                view: window,
                                                                backGroundColor: UIColor(hexString: "#2a4e84"),
                                                                cornerRadius: 18,
                                                                yOffset: Float(-UIScreen.main.bounds.height * 0.5 + UIApplication.shared.statusBarFrame.height) + 90)
                }
                self.requestReviewingActivities()
            }
        } failure: { responseData in
            print(responseData)
        }
    }
    
    func rejectButtonTapped(activityId: Int) {
        let vc = ActivityAdminRejectVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.activityId = activityId
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}
// MARK: - JXSegmentedListContainerViewListDelegate，返回containerView展示的视图
extension ActivityAdminReviewingVC: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
