//
//  ActivityHitTableViewCell.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/9/6.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class ActivityHitTableViewCell: UITableViewCell {
    lazy var coverImgView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 59, y: 17, width: 42, height: 42))
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 106, y: 25, width: 146, height: 25))
        label.textColor = UIColor(red: 0.067, green: 0.173, blue: 0.329, alpha: 1)
        label.font = UIFont(name: PingFangSCMedium, size: 18)
        return label
    }()
    
    lazy var wantToWatchNum: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.29, green: 0.267, blue: 0.894, alpha: 1)
        label.font = UIFont(name: PingFangSCMedium, size: 18)
        label.textAlignment = .right
        return label
    }()
    
    lazy var rankingLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 15, y: 25, width: 26, height: 28))
        label.font = UIFont(name: PingFangSCSemibold, size: 20)
        label.textColor = UIColor(red: 0.29, green: 0.267, blue: 0.894, alpha: 0.6)
        label.textAlignment = .center
        return label
    }()
    
    lazy var hotImgView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "hot"))
        imageView.size = CGSize(width: 14.36, height: 16)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var rankingImgView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 16, y: 23, width: 24, height: 29))
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(coverImgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(wantToWatchNum)
        contentView.addSubview(rankingLabel)
        self.wantToWatchNum.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(25)
            make.height.equalTo(25)
        }
    }
    
    func addHotImg() {
        contentView.addSubview(hotImgView)
        hotImgView.trailingAnchor.constraint(equalTo: wantToWatchNum.leadingAnchor, constant: -6).isActive = true
        hotImgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 29).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
