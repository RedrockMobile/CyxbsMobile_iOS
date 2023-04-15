//
//  SearchPersonTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/16.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SearchPersonTableViewCell.h"

NSString *SearchPersonTableViewCellReuseIdentifier = @"SearchPersonTableViewCell";

#pragma mark - SearchPersonTableViewCell ()

@interface SearchPersonTableViewCell ()

@property (nonatomic, strong) UILabel *nameLab;

@property (nonatomic, strong) UILabel *classLab;

@property (nonatomic, strong) UILabel *snoLab;

@property (nonatomic, strong) UIImageView *addImgView;

@end

#pragma mark - SearchPersonTableViewCell

@implementation SearchPersonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.classLab];
        [self.contentView addSubview:self.snoLab];
        [self.contentView addSubview:self.addImgView];
    }
    return self;
}

- (void)layoutSubviews {
    self.nameLab.frame = CGRectMake(16, 14, 100, 20);
    
    [self.classLab sizeToFit];
    self.classLab.left = self.nameLab.left;
    self.classLab.top = self.nameLab.bottom + 8;
    
    [self.snoLab sizeToFit];
    self.snoLab.right = self.contentView.width - 16;
    
    self.addImgView.size = CGSizeMake(16, 16);
    self.addImgView.top = self.snoLab.bottom + 12;
    self.addImgView.right = self.snoLab.right;
}

#pragma mark - Lazy

- (UILabel *)nameLab {
    if (_nameLab == nil) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont fontWithName:FontName.PingFangSC.Semibold size:14];
        _nameLab.textColor = [UIColor Light:UIColorHex(#112C54) Dark:UIColorHex(#F0F0F2)];
    }
    return _nameLab;
}

- (UILabel *)classLab {
    if (_classLab == nil) {
        _classLab = [[UILabel alloc] init];
        _classLab.font = [UIFont fontWithName:FontName.PingFangSC.Medium size:14];
        _classLab.textColor = [UIColor Light:UIColorHex(#112C54) Dark:UIColorHex(#F0F0F2)];
    }
    return _classLab;
}

- (UILabel *)snoLab {
    if (_snoLab == nil) {
        _snoLab = [[UILabel alloc] init];
        _snoLab.font = [UIFont fontWithName:FontName.PingFangSC.Medium size:14];
        _snoLab.textColor = [UIColor Light:UIColorHex(#112C54) Dark:UIColorHex(#F0F0F2)];
    }
    return _snoLab;
}

- (UIImageView *)addImgView {
    if (_addImgView == nil) {
        _addImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"schedule.people.add"]];
    }
    return _addImgView;
}

#pragma mark - Getter

- (NSString *)name {
    return self.nameLab.text.copy;
}

- (NSString *)inClass {
    return self.classLab.text.copy;
}

- (NSString *)sno {
    return self.snoLab.text.copy;
}

#pragma mark - Setter

- (void)setName:(NSString *)name {
    self.nameLab.text = name;
}

- (void)setInClass:(NSString *)inClass {
    self.classLab.text = inClass;
}

- (void)setSno:(NSString *)sno {
    self.snoLab.text = sno;
}

- (void)setAdding:(BOOL)adding {
    _adding = adding;
    if (_adding) {
        self.addImgView.image = [UIImage imageNamed:@"schedule.people.right"];
    } else {
        self.addImgView.image = [UIImage imageNamed:@"schedule.people.add"];
    }
}

@end
