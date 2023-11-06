//
//  TabBarHeaderView.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/3.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import RYAngelWalker

class TabBarHeaderView: UIView {
    
    var spaceForItems: CGFloat { 16 }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLab)
        addSubview(timeImgView)
        addSubview(timeLab)
        addSubview(placeImgView)
        addSubview(placeLab)
        addSubview(bar)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        stop()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    // MARK: Method
    
    func stop() {
        titleLab.stop()
        placeLab.stop()
    }
    
    func handle_viewWillAppear() {
        titleLab.walk()
        placeLab.walk()
    }
    
    func updateData(title: String?, time: String?, place: String?) {
        titleLab.stop()
        titleLab.removeAll()
        titleLab.add(title)
        titleLab.walk()
        
        timeLab.text = time
        
        placeLab.stop()
        placeLab.removeAll()
        placeLab.add(place)
        placeLab.walk()
        
        updateUI()
    }
    
    // - 4 - 3 - 3 -
    func updateUI() {
        let widthParForTitle: CGFloat = 4
        let widthParForOther: CGFloat = 3
        let widthForFullPar = widthParForTitle + 2 * widthParForOther
        
        titleLab.frame.origin.x = spaceForItems
        titleLab.center.y = bounds.height / 2
        titleLab.frame.size.width = bounds.width / widthForFullPar * widthParForTitle - 2 * spaceForItems
        
        timeImgView.frame.origin.x = bounds.width / widthForFullPar * widthParForTitle
        timeImgView.center.y = bounds.height / 2
        
        timeLab.frame.origin.x = timeImgView.frame.maxX + 3
        timeLab.center.y = bounds.height / 2
        timeLab.frame.size.width = bounds.width / widthForFullPar * widthParForOther - timeImgView.frame.width -  spaceForItems
        
        placeImgView.frame.origin.x = bounds.width / widthForFullPar * (widthParForTitle + widthParForOther)
        placeImgView.center.y = bounds.height / 2
        
        placeLab.frame.origin.x = placeImgView.frame.maxX + 3
        placeLab.center.y = bounds.height / 2
        placeLab.frame.size.width = bounds.width / widthForFullPar * widthParForOther - placeImgView.frame.width - spaceForItems
    }
    
    // MARK: lazy
    
    lazy var bar: UIView = {
        let bar = UIView()
        bar.frame = CGRect(x: 0, y: 4, width: 27, height: 5)
        bar.center.x = bounds.width / 2
        bar.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        bar.backgroundColor = .ry(light: "#E2EDFB", dark: "#1D1D1D")
        bar.layer.cornerRadius = bar.bounds.height / 2;
        bar.clipsToBounds = true
        return bar
    }()
    
    lazy var titleLab: TrotingLabel = {
        let lab = TrotingLabel(frame: CGRect(x: spaceForItems, y: 16, width: bounds.width / 2 - 2 * spaceForItems, height: 22))
        lab.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        lab.font = .systemFont(ofSize: 18, weight: .bold)
        lab.textColor = .ry(light: "#15315B", dark: "#F0F0F2")
        lab.pause = 2
        lab.add("查找课表中...")
        return lab
    }()
    
    lazy var timeImgView: UIImageView = {
        let imgView = createImgView(imageName: "TabBar_place")
        imgView.frame.origin.x = bounds.width / 3 + spaceForItems
        return imgView
    }()
    
    lazy var timeLab: UILabel = {
        let lab = UILabel()
        lab.text = "课程时间..."
        lab.textColor = .ry(light: "#15315B", dark: "#FFFFFF")
        lab.font = .systemFont(ofSize: 12)
        lab.sizeToFit()
        lab.frame.origin.x = timeImgView.frame.minX + 3
        lab.center.y = bounds.height / 2
        lab.frame.size.width = bounds.width / 3 * 2 - lab.frame.minX - spaceForItems
        lab.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        return lab
    }()
    
    lazy var placeImgView: UIImageView = {
        let imgView = createImgView(imageName: "TabBar_time")
        imgView.frame.origin.x = bounds.width / 3 * 2 + spaceForItems
        return imgView
    }()
    
    lazy var placeLab: TrotingLabel = {
        let x = placeImgView.frame.maxX + 3
        let width = bounds.width - x - spaceForItems
        let lab = TrotingLabel(frame: CGRect(x: x, y: 0, width: width, height: timeLab.bounds.height))
        lab.center.y = bounds.height / 2
        lab.font = .systemFont(ofSize: 12)
        lab.textColor = .ry(light: "#15315B", dark: "#FFFFFF")
        lab.add("课程地点...")
        return lab
    }()
    
    func createImgView(imageName: String) -> UIImageView {
        let imgView = UIImageView()
        imgView.frame.size = CGSize(width: 11, height: 11)
        imgView.center.y = bounds.height / 2
        imgView.contentMode = .center
        imgView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        let image = UIImage(named: imageName)?.scaled(toHeight: 11)?.withRenderingMode(.alwaysOriginal)
        imgView.image = image
        return imgView
    }
}
