//
//  ScheduleCustomViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/1/18.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleCustomViewController.h"

#import "ScheduleCustomEditView.h"

#import "TransitioningDelegate.h"
#import "HttpTool.h"

@interface ScheduleCustomViewController () <
    ScheduleCustomEditViewDelegate
>

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIImageView *bkImgView;

@property (nonatomic, strong) ScheduleCustomEditView *editView;

@end

@implementation ScheduleCustomViewController

- (instancetype)initWithAppendingInSection:(NSUInteger)section week:(NSUInteger)week location:(NSUInteger)location {
    self = [super init];
    if (self) {
        _courseIfNeeded = [[ScheduleCourse alloc] init];
        self.courseIfNeeded.type = @"事务";
        self.courseIfNeeded.inSections = (section == 0 ? [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 12)] : [NSIndexSet indexSetWithIndex:section]);
        self.courseIfNeeded.inWeek = week;
        self.courseIfNeeded.period = NSMakeRange(location, 1);
        self.courseIfNeeded.inWeek = week;
    }
    return self;
}

- (instancetype)initWithEditingWithCourse:(ScheduleCourse *)course {
    self = [super init];
    if (self) {
        _courseIfNeeded = course;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.bkImgView];
    [self.view addSubview:self.editView];
    [self.view addSubview:self.backBtn];
    
//    [self test];
    self.courseIfNeeded = self.courseIfNeeded;
}

#pragma mark - Method

- (void)setCourseIfNeeded:(ScheduleCourse *)courseIfNeeded {
    if (_editView) {
        self.editView.title = courseIfNeeded.course;
        self.editView.content = courseIfNeeded.classRoom;
        self.editView.period = courseIfNeeded.period;
        self.editView.sections = courseIfNeeded.inSections;
        self.editView.inWeek = courseIfNeeded.inWeek;
    }
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

- (UIImageView *)bkImgView {
    if (_bkImgView == nil) {
        _bkImgView = [[UIImageView alloc] initWithFrame:self.view.SuperFrame];
        _bkImgView.image = [UIImage imageNamed:@"schedule.custom.bk"];
    }
    return _bkImgView;
}

- (ScheduleCustomEditView *)editView {
    if (_editView == nil) {
        CGFloat top = self.backBtn.top;
        _editView = [[ScheduleCustomEditView alloc] initWithFrame:CGRectMake(0, top, self.view.width, self.view.height - top)];
        _editView.delegate = self;
    }
    return _editView;
}

#pragma mark - <ScheduleCustomEditViewDelegate>

- (void)scheduleCustomEditViewDidFinishEditing:(ScheduleCustomEditView *)view {
    [self _dismissWithAppending:YES];
}

#pragma mark - private

- (void)_cancel:(UIButton *)btn {
    [self _dismissWithAppending:NO];
}

- (void)_dismissWithAppending:(BOOL)append {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scheduleCustomViewController:finishingWithAppending:)]) {
        [self.delegate scheduleCustomViewController:self finishingWithAppending:append];
    }
    TransitioningDelegate *delegate = [[TransitioningDelegate alloc] init];
    delegate.transitionDurationIfNeeded = 0.3;
    self.transitioningDelegate = delegate;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)test {
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://be-prod.redrock.cqupt.edu.cn/magipoke/token"]
       cachePolicy:NSURLRequestUseProtocolCachePolicy
       timeoutInterval:10.0];
    NSDictionary *headers = @{
       @"Content-Type": @"application/json"
    };

    [request setAllHTTPHeaderFields:headers];
    NSData *postData = [[NSData alloc] initWithData:[@"{\"stuNum\":\"oNgyg$\",\"idNum\":\"B^z1xS]\"\n}" dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postData];

    [request setHTTPMethod:@"POST"];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       if (error) {
          NSLog(@"%@", error);
          dispatch_semaphore_signal(sema);
       } else {
          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
          NSError *parseError = nil;
          NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
          NSLog(@"%@",responseDictionary);
          dispatch_semaphore_signal(sema);
       }
    }];
    [dataTask resume];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

@end
