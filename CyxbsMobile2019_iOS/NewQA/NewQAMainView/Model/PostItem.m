//
//  PostItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "PostItem.h"

@implementation PostItem

- (instancetype)initWithDic:(NSDictionary *)dict {
    if ([super init]) {
        self.post_id = dict[@"post_id"];
        self.avatar = dict[@"avatar"];
        self.nick_name = dict[@"nickname"];
        self.publish_time = dict[@"publish_time"];
        self.content = dict[@"content"];
        self.pics = dict[@"pics"];
        self.topic = dict[@"topic"];
        self.uid = dict[@"uid"];
        self.is_self = dict[@"is_self"];
        self.praise_count = [NSNumber numberWithInt:[dict[@"praise_count"] intValue]];
        self.comment_count = [NSNumber numberWithInt:[dict[@"comment_count"] intValue]];
        self.is_follow_topic = dict[@"is_follow_topic"];
        self.is_praised = dict[@"is_praised"];
        self.initHeight = SCREEN_WIDTH * (0.1486 + 0.0427 * 101.5/16  + 0.2707 * 25.5/101.5);
    }
    return self;
}

///
- (CGFloat)getDetailLabelHeight {
    NSString *fiveString = @"1\n1\n1\n1\n1";
    NSMutableAttributedString *fiveStr = [[NSMutableAttributedString alloc] initWithString:fiveString];
    NSRange fiveRange = [fiveString rangeOfString:fiveString];
    [fiveStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:PingFangSCRegular size:16] range:fiveRange];
    [fiveStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]range:fiveRange];
    NSStringDrawingOptions fiveOptions =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        // 获取label的最大宽度
    CGRect fiveRect = [fiveStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH * 0.9, CGFLOAT_MAX)options:fiveOptions context:nil];
    return fiveRect.size.height;
}
@end
