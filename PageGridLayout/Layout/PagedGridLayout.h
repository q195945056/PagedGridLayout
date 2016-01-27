//
//  PagedGridLayout.h
//  UserCenterCollectionView
//
//  Created by yanmingjun on 16/1/26.
//  Copyright © 2016年 youloft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagedGridLayout : UICollectionViewLayout

@property (nonatomic, readwrite) IBInspectable NSUInteger columnCount;//列数
@property (nonatomic, readwrite) IBInspectable NSUInteger maxRowCount;//行数
@property (nonatomic, readwrite) IBInspectable CGFloat seperatorLineWidth;

@end
