//
//  ScheduleCustomEditView.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/2/28.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleCustomEditView.h"

#import "ScheduleCustomEditCollectionViewCell.h"

#import "ScheduleNeedsSupport.h"

#pragma mark - ScheduleCustomEditView ()

@interface ScheduleCustomEditView () <
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource,

    UIPickerViewDelegate,
    UIPickerViewDataSource,

    UIGestureRecognizerDelegate,

    UITextFieldDelegate
>

@property (nonatomic, strong) UILabel *topLab;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UITextField *titleTextField;

@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UITextField *contentTextField;

@property (nonatomic, strong) UILabel *sectionLab;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UILabel *periodLab;
@property (nonatomic, strong) UIPickerView *periodPicker;

@property (nonatomic, strong) UIButton *finBtn;

@property (nonatomic, copy) NSIndexPath *l_idx;

@end

#pragma mark - ScheduleCustomEditView

@implementation ScheduleCustomEditView {
    NSMutableIndexSet *_mutiIdxSet;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self addSubview:self.topLab];
        
        [self addSubview:self.titleLab];
        [self addSubview:self.titleTextField];
        
        [self addSubview:self.contentLab];
        [self addSubview:self.contentTextField];
        
        [self addSubview:self.sectionLab];
        [self addSubview:self.collectionView];
        
        [self addSubview:self.periodLab];
        [self addSubview:self.periodPicker];
        
        [self addSubview:self.finBtn];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_endEdit:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        _period = NSMakeRange(1, 1);
        _mutiIdxSet = NSMutableIndexSet.indexSet;
    }
    return self;
}

#pragma mark - Method

// title

- (void)setTitle:(NSString *)title {
    if ([title isEqualToString:@""]) {
        title = nil;
    }
    self.titleTextField.text = title;
}

- (NSString *)title {
    return self.titleTextField.text.copy;
}

// content

- (void)setContent:(NSString *)content {
    if ([content isEqualToString:@""]) {
        content = nil;
    }
    self.contentTextField.text = content;
}

- (NSString *)content {
    return self.contentTextField.text.copy;
}

// sections

- (void)setSections:(NSIndexSet *)sections {
    _mutiIdxSet = sections ? sections.mutableCopy : NSMutableIndexSet.indexSet;
    if (_collectionView) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * __unused stop) {
            NSIndexPath *idxPath = [NSIndexPath indexPathForItem:(idx - 1) % 8 inSection:(idx - 1) / 8];
            [self.collectionView selectItemAtIndexPath:idxPath animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
        }];
    }
}

- (NSIndexSet *)sections {
    return _mutiIdxSet.copy;
}

// inWeek

- (void)setInWeek:(NSInteger)inWeek {
    if (inWeek < 1 || inWeek > 7) {
        inWeek = 0;
    }
    [self.periodPicker selectRow:inWeek - 1 inComponent:0 animated:YES];
}

- (NSInteger)inWeek {
    return [self.periodPicker selectedRowInComponent:0] + 1;
}

// period

- (void)setPeriod:(NSRange)period {
    if (period.location < 1 || period.location > 12) {
        period.location = 1;
        period.length = 1;
    }
    _period = period;
    [self.periodPicker selectRow:period.location - 1 inComponent:1 animated:YES];
    [self.periodPicker reloadComponent:2];
    [self.periodPicker selectRow:period.length - 1 inComponent:2 animated:YES];
}

#pragma mark - Lazy

- (UILabel *)topLab {
    if (_topLab == nil) {
        _topLab = self._lab;
        _topLab.text = @"为你的行程添加";
        [_topLab sizeToFit];
        _topLab.left = 18;
        _topLab.top = 0;
    }
    return _topLab;
}

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = self._lab;
        _titleLab.text = @"一个标题";
        [_titleLab sizeToFit];
        _titleLab.left = self.topLab.left;
        _titleLab.top = self.topLab.bottom;
    }
    return _titleLab;
}

- (UITextField *)titleTextField {
    if (_titleTextField == nil) {
        _titleTextField = self._textField;
        _titleTextField.frame = CGRectMake(self.titleLab.left, self.titleLab.bottom + 5, self.width - 2 * 16, 50);
        _titleTextField.placeholder = @"标题";
    }
    return _titleTextField;
}

- (UILabel *)contentLab {
    if (_contentLab == nil) {
        _contentLab = self._lab;
        _contentLab.text = @"具体内容";
        [_contentLab sizeToFit];
        _contentLab.left = self.titleTextField.left;
        _contentLab.top = self.titleTextField.bottom + 20;
    }
    return _contentLab;
}

- (UITextField *)contentTextField {
    if (_contentTextField == nil) {
        _contentTextField = self._textField;
        _contentTextField.frame = CGRectMake(self.contentLab.left, self.contentLab.bottom + 5, self.width - 2 * 16, 50);
        _contentTextField.placeholder = @"内容";
    }
    return _contentTextField;
}

- (UILabel *)sectionLab {
    if (_sectionLab == nil) {
        _sectionLab = self._lab;
        _sectionLab.text = @"选择周数";
        [_sectionLab sizeToFit];
        _sectionLab.left = self.contentTextField.left;
        _sectionLab.top = self.contentTextField.bottom + 20;
    }
    return _sectionLab;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 2;
        layout.sectionInset = UIEdgeInsetsMake(3, 0, 3, 0);
        
        CGFloat left = self.sectionLab.left;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(left, self.sectionLab.bottom + 5, self.width - 2 * left, 105) collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.allowsMultipleSelection = YES;
        [_collectionView registerClass:ScheduleCustomEditCollectionViewCell.class forCellWithReuseIdentifier:ScheduleCustomEditCollectionViewCellReuseIdentifier];
    }
    return _collectionView;
}

- (UILabel *)periodLab {
    if (_periodLab == nil) {
        _periodLab = self._lab;
        _periodLab.text = @"确定时间";
        [_periodLab sizeToFit];
        _periodLab.top = self.collectionView.bottom + 15;
        _periodLab.left = self.collectionView.left;
    }
    return _periodLab;
}

- (UIPickerView *)periodPicker {
    if (_periodPicker == nil) {
        CGFloat left = self.periodLab.left;
        _periodPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(left, self.periodLab.bottom - 20, self.width - 2 * left, 216)];
        _periodPicker.delegate = self;
        _periodPicker.dataSource = self;
    }
    return _periodPicker;
}

- (UIButton *)finBtn {
    if (_finBtn == nil) {
        _finBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 66)];
        _finBtn.centerX = self.width / 2;
        _finBtn.centerY = (self.periodPicker.bottom + self.height) / 2;
        _finBtn.layer.cornerRadius = 20;
        _finBtn.backgroundColor = UIColorHex(#AABBFF);
        _finBtn.enabled = NO;
        
        [_finBtn setImage:[UIImage imageNamed:@"nextpage"] forState:UIControlStateNormal];
        _finBtn.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
        
        [_finBtn addTarget:self action:@selector(_tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finBtn;
}

#pragma mark - Private

- (void)_endEdit:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self endEditing:YES];
        [self _checkBtn];
    }
}

- (void)_tapBtn:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scheduleCustomEditViewDidFinishEditing:)]) {
        [self.delegate scheduleCustomEditViewDidFinishEditing:self];
    }
}

- (void)_checkBtn {
    if (self.title && self.content && _mutiIdxSet.count != 0) {
        self.finBtn.enabled = YES;
        self.finBtn.backgroundColor = UIColorHex(#4841E2);
    } else {
        self.finBtn.enabled = NO;
        self.finBtn.backgroundColor = UIColorHex(#AABBFF);
    }
}

#pragma mark - <UITextFieldDelegate>

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self _checkBtn];
}

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self];
    if (CGRectContainsPoint(self.collectionView.frame, point)) {
        return NO;
    }
    if (CGRectContainsPoint(self.finBtn.frame, point)) {
        return NO;
    }
    return YES;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_mutiIdxSet addIndex:indexPath.section * 8 + indexPath.item + 1];
    [self _checkBtn];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_mutiIdxSet removeIndex:indexPath.section * 8 + indexPath.item + 1];
    [self _checkBtn];
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = collectionView.width / 8 - 2;
    return CGSizeMake(width, width * 0.62);
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section  {
    return 8;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleCustomEditCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ScheduleCustomEditCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    
    NSUInteger week = indexPath.section * 8 + indexPath.item + 1;
    cell.title = [NSString stringWithFormat:@"第%ld周", week];
    
    return cell;
}

#pragma mark - <UIPickerViewDataSource>

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 7;
    }
    if (component == 1) {
        return 12;
    }
    if (component == 2) {
        return 13 - self.period.location;
    }
    return 0;
}

#pragma mark - <UIPickerViewDelegate>

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *str = @"";
    if (component == 0) {
        switch (row) {
            case 0: str = @"星期一"; break;
            case 1: str = @"星期二"; break;
            case 2: str = @"星期三"; break;
            case 3: str = @"星期四"; break;
            case 4: str = @"星期五"; break;
            case 5: str = @"星期六"; break;
            case 6: str = @"星期天"; break;
            default: return nil;
        }
    }
    if (component == 1) {
        str = [NSString stringWithFormat:@"从第%ld节", row + 1];
    }
    if (component == 2) {
        str = [NSString stringWithFormat:@"到第%ld节", self.period.location + row];
    }
    return [[NSAttributedString alloc] initWithString:str attributes:@{
        NSFontAttributeName: [UIFont fontWithName:FontName.PingFangSC.Medium size:18],
        NSForegroundColorAttributeName: [UIColor Light:UIColorHex(#15315B) Dark:UIColorHex(#F0F0F2)]
    }];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 1) {
        _period = NSMakeRange(row + 1, [pickerView selectedRowInComponent:2] + 1);
        [pickerView reloadComponent:2];
    }
    if (component == 2) {
        _period.length = [pickerView selectedRowInComponent:2] + 1;
    }
}

#pragma mark - Factory

- (UILabel *)_lab {
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [UIFont fontWithName:FontName.PingFangSC.Semibold size:28];
    lab.textColor = [UIColor Light:UIColorHex(#122D55) Dark:UIColorHex(#F0F0F2)];
    return lab;
}

- (UITextField *)_textField {
    UITextField *_tf = [[UITextField alloc] init];
    _tf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 17, 0)];
    _tf.leftViewMode = UITextFieldViewModeAlways;
    _tf.font = [UIFont fontWithName:FontName.PingFangSC.Semibold size:18];
    _tf.textColor = [UIColor Light:UIColorHex(#15315B) Dark:UIColorHex(#F0F0F2)];
    _tf.backgroundColor = [UIColor Light:UIColorHex(#F2F3F7) Dark:UIColorHex(#2D2D2D)];
    _tf.layer.cornerRadius = 17;
    return _tf;
}

@end
