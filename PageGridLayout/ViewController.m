//
//  ViewController.m
//  UserCenterCollectionView
//
//  Created by yanmingjun on 16/1/26.
//  Copyright © 2016年 youloft. All rights reserved.
//

#import "ViewController.h"
#import "MyCollectionViewCell.h"

#define PixelWidth (1 / [UIScreen mainScreen].scale)
static NSUInteger columnCount = 4;
static NSUInteger maxRowCount = 3;

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *leadingConstrant;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic) NSInteger itemCount;
@end

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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *message = [NSString stringWithFormat:@"您点击了第%ld个item", (long)(indexPath.item + 1)];
    if ([UIAlertController class]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
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
