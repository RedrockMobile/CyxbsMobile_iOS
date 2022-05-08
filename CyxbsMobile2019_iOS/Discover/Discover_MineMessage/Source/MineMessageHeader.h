//
//  MineMessageHeader.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/17.
//  Copyright © 2022 Redrock. All rights reserved.
//

#ifndef MineMessageHeader_h
#define MineMessageHeader_h

#pragma mark - UserDefault

/// 是否设置了（默认没设置）
#define MineMessage_hadSettle_BOOL @"MineMessage_hadSettle"

/// 是否需要活动消息提醒（默认不需要）（静默？）
#define MineMessage_needMsgWarn_BOOL @"MineMessage_needMsgWarn"

/// 是否需要签到提醒（默认不需要）（本地）
#define MineMessage_needSignWarn_BOOL @"MineMessage_needSignWarn"

/// 签到的本地通知 identifier
#define MineMessage_notificationRequest_identifier @"MineMessage_notificationRequest"

#endif /* MineMessageHeader_h */
