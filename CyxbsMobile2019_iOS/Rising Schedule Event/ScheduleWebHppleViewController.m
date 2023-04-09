//
//  ScheduleWebHppleViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/4/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleWebHppleViewController.h"

#import "ScheduleCombineItemSupport.h"
#import "ScheduleCourse.h"
#import "ScheduleWidgetCache.h"

#import <WebKit/WebKit.h>
#import <hpple/TFHpple.h>

@interface ScheduleWebHppleViewController () <
    WKNavigationDelegate
>

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIButton *reloadBtn;

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ScheduleWebHppleViewController

- (instancetype)initWithKey:(ScheduleIdentifier *)key forName:(ScheduleWidgetCacheKeyName)name {
    self = [super init];
    if (self) {
        _key = key;
        _name = name;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor =
    [UIColor Light:UIColorHex(#FFFFFF)
              Dark:UIColorHex(#1D1D1D)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.reloadBtn];
    [self.view addSubview:self.webView];
    [self _reloadRequest];
}

#pragma mark - Lazy

- (UIButton *)backBtn {
    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, StatusBarHeight() + 10, 60, 40)];
        _backBtn.right = self.view.width - 17;
        [_backBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_backBtn setTitleColor:UIColorHex(#4841E2) forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(_cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)reloadBtn {
    if (_reloadBtn == nil) {
        _reloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.backBtn.top, 60, 40)];
        _reloadBtn.right = self.backBtn.left - 10;
        [_reloadBtn setTitle:@"重查" forState:UIControlStateNormal];
        [_reloadBtn setTitleColor:UIColorHex(#4841E2) forState:UIControlStateNormal];
        [_reloadBtn addTarget:self action:@selector(_reloadRequest) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadBtn;
}

- (WKWebView *)webView {
    if (_webView == nil) {
        CGFloat top = self.backBtn.bottom + 10;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, top, self.view.width, self.view.height - top)];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

#pragma mark - private

- (void)_cancel:(UIButton *)btn {
    [self _callDelegateWithMsg:@"未查询到相关信息"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)_reloadRequest {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://jwzx.cqupt.edu.cn/kebiao/kb_stu.php?xh=%@", self.key.sno]]]];
}

- (void)_callDelegateWithMsg:(NSString *)msg {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:dismissError:)]) {
        [self.delegate viewController:self dismissError:msg];
    }
}

#pragma mark - <WKNavigationDelegate>

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    if ([url.path isEqualToString:@"/rump_frontend/login"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"未连接内网" message:@"请连接内网后再次尝试" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self _reloadRequest];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self _cancel:self.backBtn];
        }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // !!!: regexSearch(正则, 原文)
    NSString *(^regexSearch)(NSString *, NSString *) = ^NSString *(NSString *pattern, NSString *searchText) {
        if (!searchText) { return @""; }
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
        NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, searchText.length)];
        return [searchText substringWithRange:result.range];
    };
    // !!!: locationSearch(xx节)
    NSInteger (^locationSearch)(NSString *) = ^NSInteger (NSString *searchText) {
        NSDictionary <NSString *, NSNumber *> *dic = @{
            @"1、2节" : @(1),
            @"3、4节" : @(3),
            @"中午间歇" : @(0), // todo
            @"5、6节" : @(5),
            @"7、8节" : @(7),
            @"下午间歇" : @(0), // todo
            @"9、10节" : @(9),
            @"11、12节": @(11)
        };
        NSNumber *num = [dic objectForKey:searchText];
        if (!num) { num = @(0); }
        return num.integerValue;
    };
    // !!!: subStrSearch(原字符串, 在after之后, 在before之前)
    NSString *(^subStrSearch)(NSString *, NSString *, NSString *) = ^NSString *(NSString *org, NSString *after, NSString *before) {
        NSRange range = [org rangeOfString:after];
        NSRange endRange = [org rangeOfString:before];
        NSRange extractRange = NSMakeRange(NSMaxRange(range), endRange.location - NSMaxRange(range));
        return [org substringWithRange:extractRange];
    };
    
    [self.webView evaluateJavaScript:@"document.body.innerHTML" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (error) {
            [self _callDelegateWithMsg:@"获取HTML错误"];
            return;
        }
        
        ScheduleIdentifier *key = self.key.copy;
        NSMutableArray <ScheduleCourse *> *valueAry = NSMutableArray.array;
        
        NSString *http = (NSString *)result;
        NSData *data = [http dataUsingEncoding:NSUTF8StringEncoding];
        TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:data];
        
        // @"今天是第 7 周 星期 3"
        TFHppleElement *weekHpple = ((TFHppleElement *)[hpple peekAtSearchWithXPathQuery:@"//div[@id='head']"].children[1]).children[3];
        NSInteger week = regexSearch(@"(?<=第 )[0-9]{1,2}(?= 周)", weekHpple.text).integerValue;
        [key setExpWithNowWeek:week]; // NODE: now week
        
        TFHppleElement *stuPanelHpple = ((TFHppleElement *)[hpple peekAtSearchWithXPathQuery:@"//div[@id='stuPanel']"].children[2]).children[1];
        // 按"节"来循环，[1, 2], [3, 4]...
        for (TFHppleElement *perHpple in stuPanelHpple.children) {
            // 第0个<td>标签: @"1、2节"
            TFHppleElement *locationHpple = perHpple.children[0];
            NSInteger location = locationSearch(locationHpple.text);
            // 每个<td>为一周
            for (NSInteger inWeek = 1; inWeek < perHpple.children.count; inWeek++) {
                TFHppleElement *weekHpple = perHpple.children[inWeek];
                // 每个<div class="kbTd"... 为一节课
                for (TFHppleElement *courseHpple in weekHpple.children) {
                    ScheduleCourse *course = [[ScheduleCourse alloc] init]; // NODE: course
                    course.inWeek = inWeek;
                    
                    // zc是所占周 @"01111111111111000000"
                    NSString *zcStr = courseHpple.attributes[@"zc"];
                    NSMutableIndexSet *zcIdxSet = NSMutableIndexSet.indexSet;
                    for (NSInteger inSection = 1; zcStr && zcStr.length != 0; inSection++) {
                        if ([zcStr substringToIndex:1].boolValue) {
                            [zcIdxSet addIndex:inSection];
                        }
                        zcStr = [zcStr substringFromIndex:1];
                    }
                    course.inSections = zcIdxSet.copy;
                    
                    // @"A13222A1110140001-"
                    NSString *courseID = courseHpple.firstChild.content;
                    course.courseID = courseID;
                    
                    NSString *courseName = ((TFHppleElement *)courseHpple.children[2]).content;
                    course.course = [courseName substringFromIndex:NSMaxRange([courseName rangeOfString:@"-"])];
                    
                    NSString *coursePlaceHole = ((TFHppleElement *)courseHpple.children[4]).content;
                    NSString *coursePlace = subStrSearch(coursePlaceHole, @"地点：", @" \n");
                    course.classRoom = coursePlace;
                    
                    NSString *courseRawWeek = ((TFHppleElement *)courseHpple.children[6]).content;
                    course.rawWeek = courseRawWeek;
                    
                    NSString *peroidLenthStr = ((TFHppleElement *)courseHpple.children[7]).text;
                    NSInteger periodLen = 2;
                    if (peroidLenthStr) {
                        periodLen = regexSearch(@"[1-9](?=节连上)", peroidLenthStr).integerValue;
                    }
                    course.period = NSMakeRange(location, periodLen);
                    
                    NSString *lessonStr = [NSString stringWithFormat:@"%ld-%ld节", location, location + periodLen - 1];
                    course.lesson = lessonStr;
                    
                    NSString *content = ((TFHppleElement *)courseHpple.children[9]).text;
                    NSArray <NSString *> *contentStrs = [content componentsSeparatedByString:@" "];
                    NSString *teacher = contentStrs[0];
                    NSString *type = contentStrs[1];
                    course.teacher = teacher;
                    course.type = type;
                    
                    [valueAry addObject:course];
                }
            }
        }
        
        ScheduleCombineItem *finItem = [ScheduleCombineItem combineItemWithIdentifier:key value:valueAry.copy];
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:didHppleItem:)]) {
            [self.delegate viewController:self didHppleItem:finItem];
        }
        [ScheduleShareCache.shareCache cacheItem:finItem];
        if (self.name) {
            [ScheduleWidgetCache.shareCache setKey:finItem.identifier withKeyName:self.name usingSupport:YES];
        }
    }];
}

@end
