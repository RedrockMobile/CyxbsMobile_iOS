//
//  ActivityViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/8/13.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import JXSegmentedView
import ProgressHUD

class ActivityMainViewController: UIViewController {
    
    private var collectionViewControllers: [ActivityCollectionVC] = []
    private var segmentedDataSource: JXSegmentedActivityCustomDataSource!
    private var segmentedView: JXSegmentedView!
    private var listContainerView: JXSegmentedListContainerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            view.backgroundColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#FFFFFF")!, darkColor: UIColor(hexString: "#FFFFFF")!, alpha: 1)
        }
        else {
            view.backgroundColor = UIColor(hexString: "#FFFFFF"	)
        }
        addTopView()
        isAdmin()
        initVCs()
        addSegmentView()
    }
    
    // MARK: - 懒加载
    //顶部视图
    lazy var topView: ActivityTopView = {
        let topView = ActivityTopView(frame: CGRectMake(0, 0, view.bounds.width, 112+UIApplication.shared.statusBarFrame.height))
        topView.backButton.addTarget(self, action: #selector(popController), for: .touchUpInside)
        topView.searchButton.addTarget(self, action: #selector(pushSearchVC), for: .touchUpInside)
        topView.addActivityButton.addTarget(self, action: #selector(pushAddVC), for: .touchUpInside)
        topView.activityHitButton.addTarget(self, action: #selector(pushHitVC), for: .touchUpInside)
        topView.adminButton.addTarget(self, action: #selector(pushAdminVC), for: .touchUpInside)
        return topView
    }()
    //返回上一个VC
    @objc func popController() {
        self.navigationController?.popViewController(animated: true)
    }
    //跳转添加活动页面
    @objc func pushAddVC() {
        let addVC = ActivityAddVC()
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    //跳转排行榜页面
    @objc func pushHitVC() {
        let hitVC = ActivityRankingListVC()
        self.navigationController?.pushViewController(hitVC, animated: true)
    }
    //跳转搜索活动页面
    @objc func pushSearchVC() {
        let searchVC = ActivitySearchVC()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    //跳转管理员页面
    @objc func pushAdminVC() {
        let adminVC = ActivityAdminManageMainVC()
        self.navigationController?.pushViewController(adminVC, animated: true)
    }
    
    // 添加顶部视图
    func addTopView() {
        view.addSubview(topView)
        // 创建圆角路径，将左下角和右下角设置为圆角
        let cornerRadius: CGFloat = 20
        let shadowPath = UIBezierPath(roundedRect: topView.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        // 创建阴影图层
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = shadowPath.cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        // 设置阴影属性
        shadowLayer.shadowColor = UIColor.gray.cgColor
        shadowLayer.shadowOpacity = 0.1
        shadowLayer.shadowOffset = CGSize(width: 0, height: 2)
        shadowLayer.shadowRadius = 4
        // 将阴影图层插入到顶部视图的图层中，使阴影位于底部
        topView.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func isAdmin() {
        ActivityClient.shared.request(url:"magipoke-ufield//isadmin/",
                                      method: .get,
                                      headers: nil,
                                      parameters: nil) { responseData in
            if let dataDict = responseData as? [String: Any],
               let jsonData = try? JSONSerialization.data(withJSONObject: dataDict),
               let adminResponseData = try? JSONDecoder().decode(AdminResponseData.self, from: jsonData) {
                if (adminResponseData.data.admin) {
                    self.topView.adAdminButton()
                }
            } else {
                print("Invalid response data")
            }
        }
    }
    
    func addSegmentView() {
        //初始化segmentedView
        segmentedView = JXSegmentedView()
        segmentedDataSource = JXSegmentedActivityCustomDataSource()
        segmentedDataSource.titles = ["全部","文娱活动","体育活动","教育活动"]
        segmentedDataSource.titleNormalFont = UIFont(name: PingFangSCMedium, size: 14)!
        segmentedDataSource.titleNormalColor = UIColor(red: 0.165, green: 0.306, blue: 0.518, alpha: 0.5)
        segmentedDataSource.titleSelectedColor = UIColor(red: 0.31, green: 0.29, blue: 0.914, alpha: 1)
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedDataSource.isBackGroundColorGradientEnabled = true
        segmentedDataSource.isItemSpacingAverageEnabled = true
        segmentedDataSource.itemWidthIncrement = 28
        segmentedDataSource.itemSpacing = 12
        segmentedDataSource.cornerRadius = 15
        segmentedDataSource.backGroundNormalColor = UIColor(red: 0.37, green: 0.48, blue: 0.64, alpha: 0.05)
        segmentedDataSource.backGroundSelectedColor = UIColor(red: 0.32, green: 0.305, blue: 0.93, alpha: 0.1)
        segmentedView.delegate = self
        segmentedView.dataSource = segmentedDataSource
        //不需要配置指示器，这里仅改变backgroundcolor
        view.addSubview(segmentedView)
        listContainerView = JXSegmentedListContainerView(dataSource: self)
        view.addSubview(listContainerView)
        segmentedView.listContainer = listContainerView
        //布局子控件
        segmentedView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(30)
            make.top.equalTo(135+UIApplication.shared.statusBarFrame.height)
        }
        listContainerView.snp.makeConstraints { (make) in
            //可以滑动的容器,在tab的下面,宽度屏幕宽,底部在安全区的最下边
            make.top.equalTo(segmentedView.snp.bottom).offset(14)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    func initVCs() {
        let allVC = ActivityCollectionVC(activityType: .all)
        allVC.title = "全部"
        addChild(allVC)
        collectionViewControllers.append(allVC)
        
        let cultureVC = ActivityCollectionVC(activityType: .culture)
        cultureVC.title = "文娱活动"
        addChild(cultureVC)
        collectionViewControllers.append(cultureVC)
        
        let sportsVC = ActivityCollectionVC(activityType: .sports)
        sportsVC.title = "体育活动"
        addChild(sportsVC)
        collectionViewControllers.append(sportsVC)
        
        let educationVC = ActivityCollectionVC(activityType: .education)
        educationVC.title = "教育活动"
        addChild(educationVC)
        collectionViewControllers.append(educationVC)
    }
}

extension ActivityMainViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if (self.collectionViewControllers[index].activitiesModel.activities.count == 0){
                ActivityHUD.shared.addProgressHUDView(width: 138,
                                                            height: 36,
                                                            text: "暂无更多内容",
                                                            font: UIFont(name: PingFangSCMedium, size: 13)!,
                                                            textColor: .white,
                                                            delay: 2,
                                                            backGroundColor: UIColor(hexString: "#2a4e84"),
                                                            cornerRadius: 18,
                                                            yOffset: Float(-UIScreen.main.bounds.height * 0.5 + UIApplication.shared.statusBarFrame.height) + 90)
            }
        }
    }
}

extension ActivityMainViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return 4
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return collectionViewControllers[index]
    }
}
