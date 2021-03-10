//
//  RemarkParseModel.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/9.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RemarkParseModel : NSObject
@property(nonatomic,copy)NSString *avatar;
@property(nonatomic,copy)NSString *comment_id;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *from_nickname;
@property(nonatomic,copy)NSString *has_more_reply;
@property(nonatomic,copy)NSString *is_praised;
@property(nonatomic,copy)NSString *is_self;
@property(nonatomic,copy)NSString *nick_name;
@property(nonatomic,copy)NSString *pics;
@property(nonatomic,copy)NSString *post_id;
@property(nonatomic,copy)NSString *praise_count;
@property(nonatomic,copy)NSString *publish_time;
@property(nonatomic,copy)NSString *reply_id;
@property(nonatomic,copy)NSString *reply_list;
@property(nonatomic,copy)NSString *uid;
@property(nonatomic,copy)NSString *from;
- (instancetype)initWithDict:(NSDictionary*)dict;
@end

NS_ASSUME_NONNULL_END
/*
 {                                                                                  ˙
comment =             {                                                                ˙
  = "";                                                                       ˙
 "" = 5103;                                                               ˙
  = test;                                                                    ˙
 "" = "";                                                              ˙
 "" = 0;                                                              ˙
 "" = 0;                                                                  ˙
 "" = 0;                                                                     ˙
 "" = "";                                                                  ˙
  = "<null>";                                                                   ˙
 "" = 2811;                                                                  ˙
 "" = 0;                                                                ˙
 "" = 1614734936;                                                       ˙
 "" = 2801;                                                                 ˙
 "" = "<null>";                                                           ˙
  = 8bfcc512ee0befb0f19575cc4ef8937d8349a1bd;                                    ˙
};                                                                                     ˙
 = NSObject;                                                                       ˙
},
 */
