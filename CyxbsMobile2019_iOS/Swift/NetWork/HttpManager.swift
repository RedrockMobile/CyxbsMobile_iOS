//
//  HttpManager.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Alamofire

struct HttpManager {
    
    static var shared = HttpManager()
    
    private init() { }
    
    func excludeOptionalParameter(_ dic: [String: Any?]) -> [String: Any] {
        var parameters = [String: Any]()
        for para in dic {
            if let value = para.value {
                parameters[para.key] = value
            }
        }
        return parameters
    }
}

/* 接口模版
 
/// <#接口的作用#>
@discardableResult
func <#接口的简写#>(<#接口参数名列表1#>: <#接口参数类型列表1#> <#, ...#>) -> DataRequest {
    let parameters: [String: Any] = [
        "<#接口参数名列表1#>": <#接口参数类型列表1#>
    ]
    return SessionManager.shared.ry_request(APIConfig.current.api("<#接口#>"), method: .<#请求方式#>, parameters: parameters)
}
 
 */

extension HttpManager {
    
    /// 获取课表
    @discardableResult
    func magipoke_jwzx_kebiao(stu_num: String) -> DataRequest {
        let parameters: [String: Any] = [
            "stu_num": stu_num
        ]
        return SessionManager.shared.ry_request(APIConfig.current.api("/magipoke-jwzx/kebiao"), method: .post, parameters: parameters)
    }
    
    /// 查询同学信息
    @discardableResult
    func magipoke_text_search_people(stu: String) -> DataRequest {
        let parameters: [String: Any] = [
            "stu": stu
        ]
        return SessionManager.shared.ry_request(APIConfig.current.api("/magipoke-text/search/people"), parameters: parameters)
    }
    
    /// 获取token
    @discardableResult
    func magipoke_token(stuNum: String, idNum: String) -> DataRequest {
        let parameters: [String: Any] = [
            "stuNum": stuNum,
            "idNum": idNum
        ]
        return SessionManager.shared.ry_request(APIConfig.current.api("/magipoke/token"), method: .post, parameters: parameters, encoding: JSONEncoding())
    }
    
    /// 刷新token
    @discardableResult
    func magipoke_token_refresh(refreshToken: String) -> DataRequest {
        let parameters: [String: Any] = [
            "refreshToken": refreshToken
        ]
        return SessionManager.shared.ry_request(APIConfig.current.api("/magipoke/token/refresh"), method: .post, parameters: parameters)
    }
    
    /// 查询是否有未读消息
    @discardableResult
    func message_system_user_msgHasRead() -> DataRequest {
         return SessionManager.shared.ry_request(APIConfig.current.api("/message-system/user/msgHasRead"), method: .get)
    }
    
    /// 获取banner
    @discardableResult
    func magipoke_text_banner_get() -> DataRequest {
        return SessionManager.shared.ry_request(APIConfig.current.api("/magipoke-text/banner/get"), method: .get)
    }
    
    /// 查找个人信息
    @discardableResult
    func magipoke_Person_Search(stuNum: String? = nil, idNum: String? = nil) -> DataRequest {
        let parameters: [String: Any?] = [
            "stuNum": stuNum,
            "idNum": idNum
        ]
        return SessionManager.shared.ry_request(APIConfig.current.api("/magipoke/Person/Search"), method: .post, parameters: excludeOptionalParameter(parameters))
    }
    
    /// 获取中心登录天数
    @discardableResult
    func magipoke_playground_center_days() -> DataRequest {
        return SessionManager.shared.ry_request(APIConfig.current.api("/magipoke-playground/center/days"), method: .get)
    }
    
    /// 添加事项（TODO）
    @discardableResult
    func magipoke_reminder_Person_addTransaction(begin_lesson: Int, period: Int, day: Int, week: [Int], time: String = "5", title: String, content: String) -> DataRequest {
        let dateItem: [String: Any] = [
            "begin_lesson": begin_lesson,
            "period": period,
            "day": day,
            "week": week
        ]
        
        let dateData = (try? JSONSerialization.data(withJSONObject: dateItem)) ?? Data()
        let dateItemStr = "[" + (String(data: dateData, encoding: .utf8) ?? "") + "]"
        
        let parameters: [String: Any] = [
            "date": dateItemStr,
            "time": time,
            "title": title,
            "content": content
        ]
        return SessionManager.shared.ry_request(APIConfig.current.api("/magipoke-reminder/Person/addTransaction"), method: .post, parameters: parameters, headers: [.appViersion("74")])
    }
    
    /// 获得事项
    @discardableResult
    func magipoke_reminder_Person_getTransaction() -> DataRequest {
        return SessionManager.shared.ry_request(APIConfig.current.api("/magipoke-reminder/Person/getTransaction"), method: .post, headers: [.appViersion("74")])
    }
    
    /// 删除事项
    @discardableResult
    func magipoke_reminder_Person_deleteTransaction(id: Int) -> DataRequest {
        let parameters: [String: Any] = [
            "id": id
        ]
        return SessionManager.shared.ry_request(APIConfig.current.api("/magipoke-reminder/Person/deleteTransaction"), method: .post, parameters: parameters)
    }
    
    /// 修改事项（TODO）
    @discardableResult
    func magipoke_reminder_Person_editTransaction(begin_lesson: Int, period: Int, day: Int, week: [Int], id: Int, time: String = "5", title: String, content: String) -> DataRequest {
        let dateItem: [String: Any] = [
            "begin_lesson": begin_lesson,
            "period": period,
            "day": day,
            "week": week
        ]
        
        let dateData = (try? JSONSerialization.data(withJSONObject: dateItem)) ?? Data()
        let dateItemStr = "[" + (String(data: dateData, encoding: .utf8) ?? "") + "]"
        
        let parameters: [String: Any] = [
            "date": dateItemStr,
            "id": id,
            "time": time,
            "title": title,
            "content": content
        ]
        return SessionManager.shared.ry_request(APIConfig.current.api("/magipoke-reminder/Person/editTransaction"), method: .post, parameters: parameters)
    }
    
    /// 是否绑定密保&邮箱信息
    @discardableResult
    func user_secret_user_bind_is(stu_num: String) -> DataRequest {
        let parameters: [String: Any] = [
            "stu_num": stu_num
        ]
        return SessionManager.shared.ry_request(APIConfig.current.api("/user-secret/user/bind/is"), method: .post, parameters: parameters)
    }
    
    /// 获取Email验证码（此接口用于绑定邮箱时向此邮箱发送验证码）
    @discardableResult
    func user_secret_user_bind_email_code(email: String) -> DataRequest {
        let parameters: [String: Any] = [
            "email": email
        ]
        return SessionManager.shared.ry_request(APIConfig.current.api("/user-secret/user/bind/email/code"), method: .post, parameters: parameters)
    }
    
    /// 验证Email验证码（此接口用于绑定邮箱时验证验证码是否正确）
    @discardableResult
    func user_secret_user_bind_email(email: String, code: String) -> DataRequest {
        let parameters: [String: Any] = [
            "email": email,
            "code": code
        ]
        return SessionManager.shared.ry_request(APIConfig.current.api("/user-secret/user/bind/email"), method: .post, parameters: parameters)
    }
    
    /// 获取学生邮箱信息
    @discardableResult
    func user_secret_user_bind_email_detail(stu_num: String) -> DataRequest {
        let parameters: [String: Any] = [
            "stu_num": stu_num
        ]
        return SessionManager.shared.ry_request(APIConfig.current.api("/user-secret/user/bind/email/detail"), method: .post, parameters: parameters)
    }
    
    /// 获取所有保密问题
    @discardableResult
    func user_secret_user_question() -> DataRequest {
        return SessionManager.shared.ry_request(APIConfig.current.api("/user-secret/user/question"), method: .get)
    }
    
    /// 学生获取绑定的密保信息
    @discardableResult
    func user_secret_user_bind_question_detail(stu_num: String) -> DataRequest {
        let parameters: [String: Any] = [
            "stu_num": stu_num
        ]
        return SessionManager.shared.ry_request(APIConfig.current.api("/user-secret/user/bind/question/detail"), method: .post, parameters: parameters)
    }
    
    /// 向绑定的邮箱发送找回密码用的验证码
    @discardableResult
    func user_secret_user_valid_email_code(stu_num: String) -> DataRequest {
        let parameters: [String: Any] = [
            "stu_num": stu_num
        ]
        return SessionManager.shared.ry_request(APIConfig.current.api("/user-secret/user/valid/email/code"), method: .post, parameters: parameters)
    }
    
    /// 向绑定的邮箱发送找回密码用的验证码
    @discardableResult
    func user_secret_user_valid_question(question_id: String, content: String, stu_num: String) -> DataRequest {
        let parameters: [String: Any] = [
            "question_id": question_id,
            "content": content,
            "stu_num": stu_num
        ]
        return SessionManager.shared.ry_request(APIConfig.current.api("/user-secret/user/valid/question"), method: .post, parameters: parameters)
    }
    
    /// 验证邮箱验证码是否正确
    @discardableResult
    func user_secret_user_valid_email(code: String, email: String, stu_num: String) -> DataRequest {
        let parameters: [String: Any] = [
            "code": code,
            "email": email,
            "stu_num": stu_num
        ]
        return SessionManager.shared.ry_request(APIConfig.current.api("/user-secret/user/valid/email"), method: .post, parameters: parameters)
    }
    
    /// 修改密码/找回密码（需要验证码）
    @discardableResult
    func user_secret_user_password_valid(new_password: String, code: String, stu_num: String) -> DataRequest {
        let parameters: [String: Any] = [
            "new_password": new_password,
            "code": code,
            "stu_num": stu_num
        ]
        return SessionManager.shared.ry_request(APIConfig.current.api("/user-secret/user/password/valid"), method: .post, parameters: parameters)
    }
    
    /// 活动布告栏
    @discardableResult
    func magipoke_ufield_activity_list_all(activity_type: String? = nil) -> DataRequest {
        let parameters: [String: Any?] = [
            "activity_type": activity_type
        ]
        return SessionManager.shared.ry_request(APIConfig.current.api("/magipoke-ufield/activity/list/all/"), method: .get, parameters: excludeOptionalParameter(parameters))
    }
    
    /// 搜索活动/活动排行榜
    @discardableResult
    func magipoke_ufield_activity_search(activity_type: String, activity_num: Int, activity_create_timestamp_range: String? = nil, activity_start_timestamp_range: String? = nil, order_by: String, contain_keyword: String? = nil) -> DataRequest {
        let parameters: [String: Any?] = [
            "activity_type": activity_type,
            "activity_num": activity_num,
            "activity_create_timestamp_range": activity_create_timestamp_range,
            "activity_start_timestamp_range": activity_start_timestamp_range,
            "order_by": order_by,
            "contain_keyword": contain_keyword
        ]
        return SessionManager.shared.ry_request(APIConfig.current.api("/magipoke-ufield/activity/search/"), method: .get, parameters: excludeOptionalParameter(parameters))
    }
}

