//
//  ViewController.m
//  UserCenterCollectionView
//
//  Created by yanmingjun on 16/1/26.
//  Copyright © 2016年 youloft. All rights reserved.
//

#import "ViewController.h"
#import "MyCollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *leadingConstrant;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic) NSInteger itemCount;
@end


#define PixelWidth (1 / [UIScreen mainScreen].scale)
static NSUInteger columnCount = 4;
static NSUInteger maxRowCount = 3;

@implementation ViewController


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat lineWidth = PixelWidth;
    self.leadingConstrant.constant = -PixelWidth;
    self.itemCount = 27;
    NSInteger rowCount = MIN(maxRowCount, self.itemCount / columnCount + (self.itemCount % columnCount ? 1 : 0));
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width + lineWidth) / 4 - lineWidth;
    self.heightConstraint.constant = rowCount * itemWidth + (rowCount + 1) * lineWidth;
    NSInteger pageCount = columnCount * maxRowCount;
    NSUInteger numberOfPage = self.itemCount / pageCount + (self.itemCount % pageCount ? 1 : 0);
    self.pageControl.numberOfPages = numberOfPage;
    self.pageControl.pageIndicatorTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    self.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Data Souce Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld", (long)(indexPath.item + 1)];
    return cell;
}

#pragma mark - UIScrollView Delegate Methods
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self updatePageControlWithScrollView:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updatePageControlWithScrollView:scrollView];
}

#pragma mark - Private Method
- (void)updatePageControlWithScrollView:(UIScrollView *)scrollView {
    NSUInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.pageControl.currentPage = page;
}

@end
