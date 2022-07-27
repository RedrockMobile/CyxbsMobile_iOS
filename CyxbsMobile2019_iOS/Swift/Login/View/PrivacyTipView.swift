//
//  PrivacyTipView.swift
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2022/6/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

import UIKit


protocol PrivacyTipViewDelegate {
    /// 点击后弹出 "《掌上重邮用户协议》" 的具体内容
    func showPrivacyPolicy(_ view: PrivacyTipView)
    /// 点击 “同意” 按钮后调用
    func allowBtnClik(_ view: PrivacyTipView)
    /// 点击 “不同意” 按钮后调用
    func notAllowBtnClik(_ view: PrivacyTipView)
}

/// 隐私政策提醒
final class PrivacyTipView: UIView, UITextViewDelegate {
    /// 白色窗口
    private let containView = UIView.init()
    
    /// 显示 “隐私政策更新” 的标题
    private let titleLbl = UILabel.init()
    
    /// 主体内容
    private let textView = UITextView.init()
    
    /// 同意按钮
    private let allowBtn = UIButton.init(type: .custom)
    
    /// 不同意按钮
    private let notAllowBtn = UIButton.init(type: .custom)
    
    /// 屏幕高度
    private let SH = UIScreen.main.bounds.size.height
    
    /// 屏幕宽度
    private let SW = UIScreen.main.bounds.size.width
    
    /// 主体内容中 “《掌上重邮用户协议》” 富文本对应的 URL
    private let privacyKey = "PrivacyPolicy"
    
    /// 代理
    var delegate: PrivacyTipViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        config()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        config()
    }
    
    // 配置属性、UI
    func config() {
        self.backgroundColor = UIColor.init(_colorLiteralRed: 0.3, green: 0.3, blue: 0.3, alpha: 0.3)
        self.frame = UIScreen.main.bounds
        addContainView()
    }
    
    //MARK: - 配置子控件
    func addContainView() {
        let view = containView
        self.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.top.equalTo(self).offset(0.23988006 * SH)
            make.left.equalTo(self).offset(0.1253333333 * SW)
            make.bottom.equalTo(self).offset(-0.2788605697 * SH)
            make.right.equalTo(self).offset(-0.1253333333 * SW)
        }
        
        view.backgroundColor = UIColor(.dm ,light: UIColor(hexString: "#F8F8FB")!, dark: UIColor(hexString: "#2C2C2C")!)
        view.layer.cornerRadius = 23
        addTitleLbl()
        addTextField()
        addAllowBtn()
        addNotAllowBtn()
    }
    
    func addTitleLbl() {
        let lbl = titleLbl
        containView.addSubview(lbl)
        
        lbl.snp.makeConstraints { make in
            make.left.equalTo(containView).offset(0.2466666667 * SW)
            make.top.equalTo(containView).offset(0.0299850075 * SH)
        }
        
        lbl.text = "隐私政策更新"
        lbl.textColor = UIColor(.dm ,light: UIColor(hexString: "#15315B")!, dark: UIColor(hexString: "#F0F0F2")!)
        lbl.font = UIFont.init(name: PingFangSCSemibold, size: 18)
    }
    
    func addTextField() {
        let txtView = textView
        containView.addSubview(txtView)
        txtView.snp.makeConstraints { make in
            make.top.equalTo(containView).offset(0.08245877061 * SH)
            make.left.equalTo(containView).offset(0.02666666667 * SW)
            make.right.equalTo(containView).offset(-0.02666666667 * SW)
            make.bottom.equalTo(containView).offset(-0.1011994003 * SH)
        }
        
        txtView.isEditable = false
        txtView.backgroundColor = UIColor(.dm ,light: UIColor(hexString: "#F8F8FB")!, dark: UIColor(hexString: "#2C2C2C")!)
        let str =
        """
            根据最近的法律和监管要求，我们更新了《掌上重邮用户协议》，以下是更新内容，请您查阅：
            1.我们进一步明确了获取的用户信息及使用目的和使用范围；
            2.我们对部分概括性和模糊性的文案做了进一步的修改，使其更加明确；
            3.我们列举了所使用的第三方的SDK信息；我们会采取风险最低的安全措施保护您的个人信息，未经您的授权不会把您的信息授权给第三方使用，感谢您的理解与支持！您可以点击《掌上重邮用户协议》查看全部内容；
        """
        let matchStr = "《掌上重邮用户协议》"
        let attStr = NSMutableAttributedString.init(string: str)
        var searchRange = str.startIndex..<str.endIndex
        repeat {
            let range = str.range(of: matchStr, options: .regularExpression, range: searchRange, locale: nil)
            print("searchRange = \(searchRange)")
            if range != nil {
                let rng = NSRange.init(range!, in: str)
                searchRange = str.index(str.startIndex, offsetBy: rng.location + rng.length) ..< str.endIndex
                attStr.addAttributes([.link: privacyKey], range: rng)
            }else {
                break
            }
        } while (true)
        attStr.color = UIColor(.dm ,light: UIColor(hexString: "#15315B")!, dark: UIColor(hexString: "#F0F0F2")!)
        txtView.delegate = self
        txtView.attributedText = attStr
        txtView.font = UIFont.init(name: PingFangSCMedium, size: 16)
    }
    
    func addAllowBtn() -> Void {
        let btn = allowBtn
        containView.addSubview(btn)
        
        btn.snp.makeConstraints { make in
            make.right.equalTo(containView).offset(-0.07 * SW);
            make.bottom.equalTo(containView).offset(-0.0299850075 * SH)
            make.width.equalTo(0.245 * SW)
            make.height.equalTo(0.095 * SW)
        }
        
        btn.backgroundColor = UIColor.init(red: 87/255.0, green: 86/255.0, blue: 242/255.0, alpha: 1)
        btn.layer.cornerRadius = 0.0473 * SW;
        btn.addTarget(self, action: #selector(allowBtnDidClicked), for: .touchUpInside)
        btn.setTitle("同意", for: .normal)
        btn.setTitleColor(.white, for: .normal)
    }
    
    func addNotAllowBtn() {
        let btn = notAllowBtn
        containView.addSubview(btn)
        
        btn.snp.makeConstraints { make in
            make.left.equalTo(containView).offset(0.07 * SW);
            make.bottom.equalTo(containView).offset(-0.0299850075 * SH)
            make.width.equalTo(0.245 * SW)
            make.height.equalTo(0.095 * SW)
        }
        
        btn.backgroundColor = UIColor.init(red: 169.0/255, green: 184.0/255, blue: 213.0/255, alpha: 1)
        btn.layer.cornerRadius = 0.0473*SW;
        btn.addTarget(self, action: #selector(notAllowBtnDidClicked), for: .touchUpInside)
        btn.setTitle("不同意", for: .normal)
        btn.setTitleColor(.white, for: .normal)
    }
    
    
    // MARK: - 按钮点击事件
    /// 同意按钮点击事件
    @objc func allowBtnDidClicked() {
        self.removeFromSuperview()
        self.delegate?.allowBtnClik(self)
    }
    
    /// 不同意按钮点击事件
    @objc func notAllowBtnDidClicked() {
        self.removeFromSuperview()
        self.delegate?.notAllowBtnClik(self)
    }
    
    // MARK: - 富文本的代理方法
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if url.absoluteString == privacyKey {
            print("xxxxx")
            self.delegate?.showPrivacyPolicy(self)
            return false
        }else {
            return true
        }
    }
    
}
