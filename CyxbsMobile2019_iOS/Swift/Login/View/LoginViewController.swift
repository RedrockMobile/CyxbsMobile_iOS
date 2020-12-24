//
//  LoginViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/10/5.
//  Copyright © 2020 Redrock. All rights reserved.
//

import UIKit
import SwiftyJSON


private enum LoginState {
    case lackAccount
    case lackPassword
    case lackAccountAndPassword
    case didNotAcceptProtocol
    case OK
}

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var stuNumTextField: UITextField!
    
    @IBOutlet private weak var idNumTextField: UITextField!
    
    @IBOutlet private weak var protocolCheckButton: UIButton!
    
    @IBOutlet private weak var loginTitleLabel: UILabel!
    
    @IBOutlet private weak var loginSubTitleLabel: UILabel!

    private weak var hud: MBProgressHUD!
    
    private var loginCheck: LoginState {
        
        if (idNumTextField.text == nil || idNumTextField.text == "") && (stuNumTextField.text == nil || idNumTextField.text == "") {
            return .lackAccountAndPassword
        }
        else if idNumTextField.text == nil || idNumTextField.text == "" {
            return .lackPassword
        }
        else if stuNumTextField.text == nil || idNumTextField.text == "" {
            return .lackAccount
        }
        else if (!protocolCheckButton.isSelected) {
            return .didNotAcceptProtocol
        }
        else {
            return .OK
        }
        
    }
    
    
    // MARK: - 构造器、生命周期
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true

        protocolCheckButton.backgroundColor = UIColor.clear
        protocolCheckButton.layer.cornerRadius = 8
        protocolCheckButton.clipsToBounds = true
        protocolCheckButton.layer.borderWidth = 1
        protocolCheckButton.layer.borderColor = UIColor(hexString: "4B44E4")?.cgColor
        
        if #available(iOS 11.0, *) {
            self.loginTitleLabel.textColor = UIColor(named: "LoginTitleColor")
            self.loginSubTitleLabel.textColor = UIColor(named: "LoginTitleColor")
            self.loginSubTitleLabel.alpha = 0.6;
            self.view.backgroundColor = UIColor(named: "LoginBackgroundColor")
            self.stuNumTextField.textColor = UIColor(named: "LoginTextFieldColor")
            self.idNumTextField.textColor = UIColor(named: "LoginTextFieldColor")
        } else {
            self.loginTitleLabel.textColor = UIColor(red: 21/255.0, green: 49/255.0, blue: 91/255.0, alpha: 1)
            self.loginSubTitleLabel.textColor = UIColor(red: 21/255.0, green: 49/255.0, blue: 91/255.0, alpha: 1)
            self.loginSubTitleLabel.alpha = 0.6;
            self.view.backgroundColor = UIColor(red: 248/255.0, green: 249/255.0, blue: 252/255.0, alpha: 1)
            self.stuNumTextField.textColor = UIColor(red: 28/255.0, green: 48/255.0, blue: 88/255.0, alpha: 1)
            self.idNumTextField.textColor = UIColor(red: 28/255.0, green: 48/255.0, blue: 88/255.0, alpha: 1)
        }

        
    }
    
    
    // MARK: - 按钮
    @IBAction private func loginButtonClicked(_ sender: UIButton) {
        
        switch loginCheck {
            case .OK:
                showHud("登录中...")
                LoginModel.loginWith(stuNum: stuNumTextField.text!, idNum: idNumTextField.text!) {
                    (UIApplication.shared.delegate?.window!?.rootViewController as! UITabBarController).selectedIndex = 0
                    self.hideHud()
                    self.dismiss(animated: true, completion: nil)
                } failed: {
                    self.dismiss(animated: true, completion: nil)
                    self.showHud("账号或密码错误", time: 1)
                }
                
            case .lackAccount:
                showHud("请输入账号", time: 1)
                
            case .lackPassword:
                showHud("请输入密码", time: 1)
                
            case .lackAccountAndPassword:
                showHud("请输入账号和密码", time: 1)
                
            case .didNotAcceptProtocol:
                showHud("请阅读并同意《掌上重邮用户协议》", time: 1)

        }
        
    }
    
    @IBAction private func protocolButtonClicked(_ sender: UIButton) {
        self.present(UserProtocolViewController(), animated: true, completion: nil)
    }
    
    @IBAction private func protocolCheckButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
//        let findPasswordView = FindPasswordView(frame: self.view.bounds)
//        view.addSubview(findPasswordView)
//        self.navigationController ?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
        let getVC = YYZGetIdVC()
        self.navigationController?.pushViewController(getVC, animated: true)
    }
    
    
    // MARK: - HUD
    func showHud(_ text: String, time: TimeInterval) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.mode = MBProgressHUDMode.text
        hud?.labelText = text
        hud?.hide(true, afterDelay: time)
    }
    
    func showHud(_ text: String) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.mode = MBProgressHUDMode.text
        hud?.labelText = text
        self.hud = hud
    }
    
    func hideHud() {
        self.hud.hide(true)
    }
    
}
