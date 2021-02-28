//
//  segmentTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "segmentTableViewCell.h"
#import "ActivityView.h"

#define sliderHeight SCREEN_HEIGHT * 0.0603

@interface segmentTableViewCell()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) VolunteerItem *item;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *index;



@end

@implementation segmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithVolunteerItem:(VolunteerItem *)volunteer Andindex:(NSString *)index{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.volunteer = volunteer;
        self.index = index;
        self.contentView.frame = CGRectInset(self.bounds, 16, 16);
        self.contentView.clipsToBounds = YES;
        [self.contentView addSubview:self.scrollView];
    }
    return self;
}

- (void)setVC:(UIViewController *)VC{
    _VC=VC;
    [self configScrollView];
}

- (void)configScrollView{
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSString *currentYear = [formatter stringFromDate:date];
    if ([self.index isEqual:@"全部"]) self.index = [NSString stringWithFormat:@"%d",0];
    if ([self.index isEqual:currentYear]) self.index = [NSString stringWithFormat:@"%d",1];
    if ([self.index isEqualToString:[NSString stringWithFormat:@"%d",[currentYear intValue]-1]]) self.index = [NSString stringWithFormat:@"%d",2];
    if ([self.index isEqualToString:[NSString stringWithFormat:@"%d",[currentYear intValue]-2]]) self.index = [NSString stringWithFormat:@"%d",3];
    if ([self.index isEqualToString:[NSString stringWithFormat:@"%d",[currentYear intValue]-3]]) self.index = [NSString stringWithFormat:@"%d",4];
    _timeVC = [[TimeTableViewController alloc] initWithVolunteer:self.volunteer andYearIndex:[self.index intValue]];
    _timeVC.VC = _VC;
    
    _activityVC = [[ActivityTableViewController alloc] init];
    _activityVC.VC = _VC;
    
    [self.scrollView addSubview:_timeVC.view];
    [self.scrollView addSubview:_activityVC.view];
    
    _timeVC.view.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WINDOW_HEIGHT-sliderHeight);
    _activityVC.view.frame=CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_WINDOW_HEIGHT-sliderHeight);
   
}



- (void)BuildActivityDetailView {
    ActivityView *activityDetailView = [[ActivityView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.scrollView addSubview:activityDetailView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isSelectIndex = NO;
}

// 横向滑动的时候，外层的tableView不动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.isSelectIndex) {
        if (scrollView == self.scrollView) {
            if ([self.delegate respondsToSelector:@selector(segmentScrollViewDidScroll:)]) {
                [self.delegate segmentScrollViewDidScroll:scrollView];
            }
        }
    }
}

// 横向滑动完后，跳到相应的controller，滑条移动到相应的位置
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        if ([self.delegate respondsToSelector:@selector(segmentScrollViewDidEndDecelerating:)]) {
            [self.delegate segmentScrollViewDidEndDecelerating:scrollView];
        }
    }
}


#pragma mark - Init Views
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WINDOW_HEIGHT-sliderHeight)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 2, _scrollView.frame.size.height);
    }
    return _scrollView;
}

- (void)setObjectCanScroll:(BOOL)objectCanScroll {
    _objectCanScroll = objectCanScroll;
    
    self.timeVC.vcCanScroll = objectCanScroll;
    self.activityVC.vcCanScroll = objectCanScroll;
    
    if (!objectCanScroll) {
        [self.timeVC.tableView setContentOffset:CGPointZero animated:YES];
        [self.activityVC.tableView setContentOffset:CGPointZero animated:YES];
        
    }
}


@end
