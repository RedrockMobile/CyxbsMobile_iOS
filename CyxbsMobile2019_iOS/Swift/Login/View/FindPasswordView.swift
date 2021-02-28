//
//  FindPassWordView.swift
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/10/30.
//  Copyright © 2020 Redrock. All rights reserved.
//

import UIKit
import SnapKit

class FindPasswordView: UIView {
    @objc var id2 = " "
    
//    var setid2 :(String) {
//        get{
//            return id2
//        }
//        set(str){
//            id2 = str
//        }
//    }
    
    lazy private var buttonBoard: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 8
        view.alpha = 0
        
        return view
    }()
    
    lazy private var findByEmailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("邮箱找回", for: .normal)
        button.setTitleColor(UIColor(red: 42/255.0, green: 78/255.0, blue: 132/255.0, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFang SC", size: 18)
        button.addTarget(self, action: #selector(findByEmail), for: .touchUpInside)
        
        return button
    }()
    
    lazy private var findByQuestionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("密保找回", for: .normal)
        button.setTitleColor(UIColor(red: 42/255.0, green: 78/255.0, blue: 132/255.0, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFang SC", size: 18)
        button.addTarget(self, action: #selector(findByQuestion), for: .touchUpInside)
        
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
        self.backgroundColor = UIColor(red: 0, green: 15/255.0, blue: 37/255.0, alpha: 0)
        
        self.addSubview(buttonBoard)
        buttonBoard.addSubview(findByEmailButton)
        buttonBoard.addSubview(findByQuestionButton)
        
        self.buttonBoard.layer.transformScale = 1.3
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.backgroundColor = UIColor(red: 0, green: 15/255.0, blue: 37/255.0, alpha: 0.14)
            self.buttonBoard.layer.transformScale = 1
            self.buttonBoard.alpha = 1
        }, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.buttonBoard.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-25)
            make.height.equalTo(141)
            make.width.equalTo(255)
        }
        
        self.findByEmailButton.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalTo(self.buttonBoard)
            make.height.equalTo(findByQuestionButton)
        }
        
        self.findByQuestionButton.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalTo(self.buttonBoard)
            make.top.equalTo(findByEmailButton.snp_bottomMargin)
        }
    }
    
    override func removeFromSuperview() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
        } completion: { (_) in
            super.removeFromSuperview()
        }
    }
    
    
    @objc func findByQuestion() {
        let bywordVC = ByWordViewController()
        bywordVC.idString = id2
        self.viewController?.navigationController?.pushViewController(bywordVC, animated: true)
        
    }
    
    @objc func findByEmail() {
        let bypassVC = ByPasswordViewController()
        bypassVC.idString = id2
        self.viewController?.navigationController?.pushViewController(bypassVC, animated: true)

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.removeFromSuperview()
    }

}
