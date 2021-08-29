//
//  ZWTMacro.h
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#ifndef ZWTMacro_h
#define ZWTMacro_h

#define HEADER_H 259   //303-44

#define Bar_H (STATUSBARHEIGHT + 44)

#define COLLECTIONHEADER_H 65

#define SCALE_VALUE 160
#define ALPHA_VALUE 139

#pragma mark - 邮票中心(新积分商城) 接口
///TOKEN
#define TOKEN @"eyJEYXRhIjp7ImdlbmRlciI6IueUtyIsInN0dV9udW0iOiIyMDIwMjE0ODMwIn0sIkRvbWFpbiI6Im1hZ2lwb2tlIiwiUmVkaWQiOiJjODcyYzFlMDI2MTA2YmY3NGE3ZTkwODNhNDRhZjEwZjBmOTc0OWI2IiwiZXhwIjoiNzM5ODkyMzc4MyIsImlhdCI6IjE2MjkxMTI1MzAiLCJzdWIiOiJ3ZWIifQ==.PYqpM3xu4bmAItANVYNBZg3GrWpjBqKEN01JDFOgz3wf7Cs6Yb2ia9i767UjsGyBP7VV4NBTDGT/dtP2vCSoCO0wSA7wnMdKmsrdJTTbVPJkYg1pStGUG+KkkBge9707atIve/17dvte/Hgl44uH+mNiS+DuBchp9eOBrXb1CZqZhzuOd1U8B0VDRTSgRwttopcnq/1FkWETb0HAZORoMrTT2sQKszbHTSWbxk5xOFYWYu9WatouzXOggDdlgjxoU1lw53lp/WS0WrxkxSggoKOjLFLHuCNtNBcet3pYbBZfRG8Ccdlg5r60+7GM6E3ASytrIzgnQKQO8WpigPbKxw=="
///NewBase URL
#define NewBaseURL @"https://be-dev.redrock.cqupt.edu.cn/"

///首页 API
#define MAIN_PAGE_API [NewBaseURL stringByAppendingString:@"magipoke-intergral/User/info"]

#endif /* ZWTMacro_h */
