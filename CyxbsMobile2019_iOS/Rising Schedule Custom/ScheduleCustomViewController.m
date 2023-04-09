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

#pragma mark - ScheduleCustomViewController ()

@interface ScheduleCustomViewController () <
    ScheduleCustomEditViewDelegate
>

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) UIImageView *bkImgView;

@property (nonatomic, strong) ScheduleCustomEditView *editView;

@end

#pragma mark - ScheduleCustomViewController

@implementation ScheduleCustomViewController {
    BOOL _isAdding;
}

- (instancetype)initWithAppendingInSection:(NSUInteger)section week:(NSUInteger)week location:(NSUInteger)location {
    self = [super init];
    if (self) {
        _courseIfNeeded = [[ScheduleCourse alloc] init];
        _courseIfNeeded.type = @"事务";
        _courseIfNeeded.inSections = (section == 0 ? [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 24)] : [NSIndexSet indexSetWithIndex:section]);
        _courseIfNeeded.inWeek = week;
        _courseIfNeeded.period = NSMakeRange(location, 1);
        _courseIfNeeded.inWeek = week;
        _isAdding = YES;
    }
    return self;
}

- (instancetype)initWithEditingWithCourse:(ScheduleCourse *)course {
    self = [super init];
    if (self) {
        if (course == nil) {
            course = [[ScheduleCourse alloc] init];
            course.inSections = NSIndexSet.indexSet;
            _isAdding = NO;
        }
        _courseIfNeeded = course;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.bkImgView];
    [self.view addSubview:self.editView];
    [self.view addSubview:self.backBtn];
    if (!_isAdding) {
        [self.view addSubview:self.deleteBtn];
    }
    
    self.courseIfNeeded = _courseIfNeeded;
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

- (UIButton *)deleteBtn {
    if (_deleteBtn == nil) {
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.backBtn.top, 60, 40)];
        _deleteBtn.right = self.backBtn.left - 10;
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:UIColorHex(#4841E2) forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(_delete:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
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
    self.courseIfNeeded.course = view.title;
    self.courseIfNeeded.classRoom = view.content;
    self.courseIfNeeded.period = view.period;
    self.courseIfNeeded.inSections = view.sections;
    self.editView.inWeek = view.inWeek;
    self.courseIfNeeded.teacher = @"自定义";
    self.courseIfNeeded.type = @"事务";
    NSString *string = view.sections.description;
    NSLog(@"descrip %@", string);
    NSRange range = [string rangeOfString:@"indexes: ("];
    NSRange endRange = [string rangeOfString:@")]"];
    NSRange extractRange = NSMakeRange(NSMaxRange(range), endRange.location - NSMaxRange(range));
    self.courseIfNeeded.rawWeek = [NSString stringWithFormat:@"%@周", [string substringWithRange:extractRange]];
    
    if (self.delegate) {
        if (_isAdding && [self.delegate respondsToSelector:@selector(viewController:appended:)]) {
            [self.delegate viewController:self appended:YES];
        } else if (!_isAdding && [self.delegate respondsToSelector:@selector(viewController:edited:)]) {
            [self.delegate viewController:self edited:YES];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private

- (void)_cancel:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)_delete:(UIButton *)btn {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除事务警告" message:@"若删除该事务，整个周期的事务将全部删除" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"继续修改事务" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"删除该项事务" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:deleted:)]) {
            [self.delegate viewController:self deleted:YES];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
