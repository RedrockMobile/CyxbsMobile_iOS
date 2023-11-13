//
//  NetworkException.swift
//  CyxbsMobile2019_iOS
//
//  Created by coin on 2023/11/13.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class NetworkException: NSObject {
    
    static func showNetworkErrorPrompt(to view: UIView, frame: CGRect) {
        let label = UILabel(frame: frame)
        label.text = "网络异常, 请检查网络"
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        label.layer.cornerRadius = 18
        label.clipsToBounds = true
        label.textColor = .white
        label.backgroundColor = UIColor(.dm, light: UIColor(hexString: "#2D4D80", alpha: 1), dark: UIColor(hexString: "#2D4D80", alpha: 1))
        view.addSubview(label)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            label.removeFromSuperview()
        }
    }
}
