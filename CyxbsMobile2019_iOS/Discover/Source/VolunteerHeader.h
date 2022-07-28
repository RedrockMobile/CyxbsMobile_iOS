//
//  VolunteerHeader.h
//  CyxbsMobile2019_iOS
//
//  Created by 小艾同学 on 2022/7/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

#ifndef VolunteerHeader_h
#define VolunteerHeader_h

#pragma mark - API
/// 志愿查询
#define Discover_POST_volunteerBind_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"volunteer-message/binding"]

#define Discover_POST_volunteerRequest_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"volunteer-message/select"]

#define Discover_POST_volunteerBinding_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"volunteer-message/unbinding"]

#define Discover_GET_volunteerActivity_API [CyxbsMobileBaseURL_1 stringByAppendingString:@"/cyb-volunteer/volunteer/activity/info/new"]


#endif /* VolunteerHeader_h */
