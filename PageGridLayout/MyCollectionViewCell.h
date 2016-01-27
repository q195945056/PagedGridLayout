//
//  MyCollectionViewCell.h
//  UserCenterCollectionView
//
//  Created by yanmingjun on 16/1/26.
//  Copyright © 2016年 youloft. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *identifier = @"MyCollectionViewCell";

@interface MyCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end
