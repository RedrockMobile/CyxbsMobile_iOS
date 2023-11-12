//
//  RYLoginViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/22.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import ProgressHUD

class RYLoginViewController: BaseTextFiledViewController {
    
    static let agreementURL = Bundle.main.url(forResource: "掌上重邮用户协议", withExtension: "md")!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.addSubview(titleLab)
        contentView.addSubview(contentLab)
        contentView.addSubview(snoTextField)
        contentView.addSubview(pwdTextField)
        
        contentView.addSubview(forgotBtn)
        contentView.addSubview(tipLab)
        contentView.addSubview(sureBtn)
        contentView.addSubview(agreementView)
        
        setupUI()
        updateFrame()
        showAgreementIfNeeded()
    }
    
    // MARK: lazy
    
    lazy var snoTextField: UITextField = {
        let textField = createLoginTypeTextFiled(placeholder: "请输入学号", leftImgName: "login_sno_large")
        textField.keyboardType = .asciiCapable
        return textField
    }()
    
    lazy var pwdTextField: UITextField = {
        let textField = createLoginTypeTextFiled(placeholder: "身份证/统一认证码后6位", leftImgName: "login_authentication")
        textField.keyboardType = .asciiCapable
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var forgotBtn: UIButton = {
        let btn = createDetailBtn(title: "找回密码", touchUpInsideAction: #selector(touchUpInside(forgotBtn:)))
        return btn
    }()
    
    lazy var tipLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .ry(light: "#8B8B8B", dark: "#C2C2C2")
        lab.font = .systemFont(ofSize: 11, weight: .medium)
        lab.numberOfLines = 0
        lab.textAlignment = .left
        lab.text = "2020级及以后学生默认密码为统一认证码后六位，其余同学默认密码为身份证后六位。"
        return lab
    }()
    
    lazy var sureBtn: UIButton = {
        let btn = createSureButton(size: CGSize(width: 280, height: 52), title: "登 录", touchUpInside: #selector(clickSureBtn(btn:)))
        btn.isEnabled = false
        return btn
    }()
    
    lazy var agreementView: RYAgreementView = {
        let url = RYLoginViewController.agreementURL
        let agreementView = RYAgreementView()
        agreementView.frame.origin = CGPoint(x: 10, y: 80)
        agreementView.add(normalTip: "请阅读并同意")
        agreementView.add(urlTip: "《掌上重邮用户协议》", url: url)
        agreementView.checkoutControl.frame.size = CGSize(width: 15, height: 15)
        agreementView.checkoutControl.center.y = agreementView.bounds.height / 2
        agreementView.sizeToFit()
        agreementView.delegate = self
        return agreementView
    }()
}

// MARK: update

extension RYLoginViewController {
    
    func setupUI() {
        titleLab.text = "登录"
        titleLab.sizeToFit()
        
        contentLab.text = "你好，欢迎来到掌上重邮！"
        contentLab.sizeToFit()
    }
    
    func updateFrame() {
        titleLab.frame.origin = CGPoint(x: 15, y: 80 + Constants.statusBarHeight)
        
        contentLab.frame.origin = CGPoint(x: titleLab.frame.minX, y: titleLab.frame.maxY + 8)
        
        snoTextField.frame.origin.y = contentLab.frame.maxY + 32
        
        pwdTextField.frame.origin.y = snoTextField.frame.maxY + 32
        
        tipLab.frame.size.width = pwdTextField.bounds.width
        tipLab.sizeToFit()
        tipLab.frame.origin = CGPoint(x: pwdTextField.frame.minX, y: pwdTextField.frame.maxY + 14)
        
        forgotBtn.frame.origin = CGPoint(x: pwdTextField.frame.maxY - forgotBtn.bounds.width - 10, y: tipLab.frame.maxY + 17)
        
        agreementView.frame.origin.y = view.bounds.height - agreementView.bounds.height - 53
        agreementView.center.x = view.bounds.width / 2
        
        sureBtn.frame.origin.y = agreementView.frame.minY - sureBtn.bounds.height - 72
        sureBtn.center.x = view.bounds.width / 2
    }
}

// MARK: interactive

extension RYLoginViewController {
    
    @objc
    func clickSureBtn(btn: UIButton) {
        loginIfNeeded()
    }
    
    @objc
    func touchUpInside(forgotBtn: UIButton) {
        forgotPassword()
    }
    
    // login
    
    func loginIfNeeded() {
        guard let snoText = snoTextField.text, snoText.count > 2,
        let pwdText = pwdTextField.text, pwdText.count > 0
        else {
            ProgressHUD.showFailed("需要同时填写账号/密码")
            return
        }
        
        ProgressHUD.show("正在登录...")
        HttpManager.shared.magipoke_token(stuNum: snoText, idNum: pwdText).ry_JSON { response in
            switch response {
            case .success(let model):
                let status = model["status"].intValue
                if status == 10000 {
                    
                    let token = model["data"]["token"].stringValue
                    let refreshToken = model["data"]["refreshToken"].stringValue
                    
                    UserModel.defualt.setingTokenToOC(token: TokenModel(token: token, refreshToken: refreshToken))
                    
                    ProgressHUD.showSucceed("登录成功")
                    
                    self.checktoutEmailBiding()
                    
                } else { // status == "20004"
                    ProgressHUD.showError("账号或密码出错")
                }
                
            case .failure(_):
                ProgressHUD.showFailed("网络异常，请检查您网络")
            }
        }
    }
    
    func checktoutEmailBiding() {
        EmailBidingViewController.isBiding { response in
            if let response, !response.email {
                let vc = EmailBidingViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.dismiss(animated: true) {
                    self.dismissAction?(false, nil)
                }
            }
        }
    }
    
    // agreement
    
    func showAgreementIfNeeded() {
        guard let didRead = UserDefaultsManager.shared.didReadUserAgreementBefore, didRead else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.showAgreement()
            }
            return
        }
    }
    
    func showAgreement(url: URL? = nil) {
//        let vc = MarkDownViewController()
        let vc = WebAllowController()
        vc.delegate = self
//        vc.url = url ?? RYLoginViewController.agreementURL
        vc.url = URL(string: "https://fe-prod.redrock.cqupt.edu.cn/privacy-policy/")
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    // forgot
    
    func forgotPassword() {
        let vc = UIAlertController(title: "忘记密码？", message: "输入你的学号，找回你的密码！", preferredStyle: .alert)
        vc.addTextField { textField in
            textField.keyboardType = .asciiCapable
            textField.placeholder = "输入你的学号"
            textField.text = self.snoTextField.text
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel)
        let sure = UIAlertAction(title: "确定", style: .default) { _ in
            let text = vc.textFields?.first?.text
            self.requestToForgot(sno: text)
        }
        vc.addAction(cancel)
        vc.addAction(sure)
        present(vc, animated: true)
    }
    
    func requestToForgot(sno: String?) {
        ProgressHUD.show("正在查找学号")
        EmailBidingViewController.isBiding(sno: sno) { bidingType in
            guard let bidingType else {
                ProgressHUD.showError("学号有误！！！")
                return
            }
            
            if bidingType.email == false && bidingType.question == false {
                ProgressHUD.dismiss()
                self.askToQQGroup()
                return
            }
            
            ProgressHUD.dismiss()
            let vc = ForgotViewController(sno: sno, bidingType: bidingType)
            if !bidingType.email {
                vc.retrieveWay = .question
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: BaseAgreementViewDelegate

extension RYLoginViewController: RYAgreementViewDelegate {
    
    func agreementView(_ agreementView: RYAgreementView, interactWith URL: URL, interaction: UITextItemInteraction) {
        showAgreement(url: URL)
    }
    
    func agreementView(_ agreementView: RYAgreementView, didToggle control: UIControl) {
        guard let didRead = UserDefaultsManager.shared.didReadUserAgreementBefore, didRead else {
            self.showAgreement()
            return
        }
        
        if control.isSelected {
            sureBtn.isEnabled = true
            sureBtn.backgroundColor = .hex("#4A45DC")
        } else {
            sureBtn.isEnabled = false
            sureBtn.backgroundColor = .ry(light: "#C2CBFE", dark: "#AFBAD6")
        }
    }
}

// MARK: MarkDownViewControllerDelegate

extension RYLoginViewController: MarkDownViewControllerDelegate {
    
    func mdViewControllerDidCancel(_ controller: MarkDownViewController) {
        controller.dismiss(animated: true)
        UserDefaultsManager.shared.didReadUserAgreementBefore = false
    }
    
    func mdViewControllerDidDown(_ controller: MarkDownViewController) {
        controller.dismiss(animated: true)
        UserDefaultsManager.shared.didReadUserAgreementBefore = true
        if !agreementView.isSelected {
            agreementView.toggleControl()
        }
    }
}

extension RYLoginViewController: WebAllowControllerDelegate{
    func webAllowControllerDidCancel(_ controller: WebAllowController) {
        controller.dismiss(animated: true)
        UserDefaultsManager.shared.didReadUserAgreementBefore = false
    }
    
    func webAllowControllerDidConfirm(_ controller: WebAllowController) {
        controller.dismiss(animated: true)
        UserDefaultsManager.shared.didReadUserAgreementBefore = true
        if !agreementView.isSelected {
            agreementView.toggleControl()
        }
    }
}


// MARK: static

extension RYLoginViewController {
    
    static func check(action: @escaping DismissAction) {
        
        #if DEBUG
        
//            如果想强制刷token，取消注释这两行
//            afterCallAction(showVC: true, action: action)
//            return
        
        #endif
        
        if let tokenModel = UserModel.defualt.token {
            if let didRead = UserDefaultsManager.shared.didReadUserAgreementBefore, didRead {
                if (Date().timeIntervalSince1970 - tokenModel.iat) <= (tokenModel.exp - tokenModel.iat) / 2 {
                    
                    afterCallAction(showVC: false, action: action)
                    return
                }
                
                requestNewToken(refreshToken: tokenModel.refreshToken) { isSuccess in
                    afterCallAction(showVC: !isSuccess, action: action)
                    return
                }
                return
            }
        }
        
        afterCallAction(showVC: true, action: action)
    }
    
    static func requestNewToken(refreshToken: String, success: @escaping (Bool) -> ()) {
        HttpManager.shared.magipoke_token_refresh(refreshToken: refreshToken).ry_JSON { response in
            
            if case .success(let model) = response, model["status"].intValue == 10000 {
                let token = model["data"]["token"].stringValue
                let refreshToken = model["data"]["refreshToken"].stringValue
                
                UserModel.defualt.setingTokenToOC(token: TokenModel(token: token, refreshToken: refreshToken))
                
                success(true)
                
            } else {
                if let old = UserModel.defualt.token, old.isTokenExpired {
                    success(true)
                    return
                }
                
                let alertVC = UIAlertController.normalType(title: "登录故障", content: "重新登录可以使得登录信息刷新，取消则会在下次打开App时再次询问", cancelText: "取消本次登录", sureText: "重新登录") { action in
                    
                    if action.title == "取消本次登录" {
                        success(true)
                    } else {
                        success(false)
                    }
                }
                
                Constants.keyWindow?.rootViewController?.present(alertVC, animated: true)
            }
        }
    }
}
