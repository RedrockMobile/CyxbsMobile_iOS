//
//  InstallBuildTableViewCell.h
//  Query
//
//  Created by hzl on 2017/3/9.
//  Copyright © 2017年 c. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstallBuildTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *buildLabel;

+ (instancetype)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
