//
//  ZWTMacro.h
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#ifndef ZWTMacro_h
#define ZWTMacro_h

#define Bar_H (STATUSBARHEIGHT + 44)

#define COLLECTIONHEADER_H  65

#pragma mark - 邮票中心(新积分商城) 接口
///TOKEN
#define TOKEN @"eyJEYXRhIjp7ImdlbmRlciI6IueUtyIsInN0dV9udW0iOiIyMDIwMjE0ODMwIn0sIkRvbWFpbiI6Im1hZ2lwb2tlIiwiUmVkaWQiOiJjODcyYzFlMDI2MTA2YmY3NGE3ZTkwODNhNDRhZjEwZjBmOTc0OWI2IiwiZXhwIjoiNzM5OTMzMTI2OCIsImlhdCI6IjE2Mjk1MjAwMTUiLCJzdWIiOiJ3ZWIifQ==.pk+Zb/VX1Ap7E8BRWWwqt8gGG6m2DdUAxL7WG7mVRdDCn4uLGs0mAb9xCVn+0/JvSj9X9IVI7mai0iYqTnCxh4dKTa5NtcibDXMxXA/BKV5kvE8zvkbc46r9DezdZSMHdMv+HOtOpOZAia3HWJIBj81WbxwyBr0E5QUhca5kJeo0h2TbRWo5Xda/AliPsce0Vq7zM/zEIgnjkmDJ2SC7H25fl384Bzws8mf9TfTn6Iulq6sZ4WE9xbSGnGkazh/gxvY0Xkun5BLSTgLgtKJUqF6SqP327vBY6lfpfrvwFwRs6oeJxS1lHA3Jrdp4zyaRm/JRGnyMd5Sq3jygn7Sbig=="
///NewBase URL
#define NewBaseURL @"https://be-dev.redrock.cqupt.edu.cn/"

///首页 API
#define MAIN_PAGE_API [NewBaseURL stringByAppendingString:@"magipoke-intergral/User/info"]

///任务 API
#define TASK_API [NewBaseURL stringByAppendingString:@"magipoke-intergral/Integral/progress"]

#endif /* ZWTMacro_h */
