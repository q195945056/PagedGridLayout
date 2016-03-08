//
//  PagedGridLayout.m
//  UserCenterCollectionView
//
//  Created by yanmingjun on 16/1/26.
//  Copyright © 2016年 youloft. All rights reserved.
//

#import "PagedGridLayout.h"



static NSString *decorationKind = @"lineDecoration";

@interface LineDecorationView : UICollectionReusableView

@end

@implementation LineDecorationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

@end

@interface PagedGridLayout ()

@property (nonatomic, strong) NSMutableArray *itemAttributes;
@property (nonatomic, strong) NSMutableDictionary *decorationAttributes;

@property (nonatomic) NSUInteger numberOfPage;
@property (nonatomic) NSUInteger actualRowCount;

@end

@implementation PagedGridLayout

#pragma mark - Init
- (void)commonInit
{
    _columnCount = 3;
    _maxRowCount = 3;
    _seperatorLineWidth = 1 / [UIScreen mainScreen].scale;
    [self registerClass:[LineDecorationView class] forDecorationViewOfKind:decorationKind];
}

- (id)init
{
    if (self = [super init])
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self commonInit];
    }
    return self;
}

- (void)setColumnCount:(NSUInteger)columnCount {
    if (_columnCount != columnCount) {
        _columnCount = columnCount;
        [self invalidateLayout];
    }
}

- (void)setMaxRowCount:(NSUInteger)maxRowCount {
    if (_maxRowCount != maxRowCount) {
        _maxRowCount = maxRowCount;
        [self invalidateLayout];
    }
}

- (void)setSeperatorLineWidth:(CGFloat)seperatorLineWidth {
    if (_seperatorLineWidth != seperatorLineWidth) {
        _seperatorLineWidth = seperatorLineWidth;
        [self invalidateLayout];
    }
}

- (NSMutableArray *)itemAttributes {
    if (!_itemAttributes) {
        _itemAttributes = [[NSMutableArray alloc] init];
    }
    return _itemAttributes;
}

- (NSMutableDictionary *)decorationAttributes {
    if (!_decorationAttributes) {
        _decorationAttributes = [[NSMutableDictionary alloc] init];
    }
    return _decorationAttributes;
}

- (NSUInteger)seperatorLineOriginXForColumnNumber:(NSUInteger)columnNumber {
    NSUInteger totalWidth = CGRectGetWidth(self.collectionView.frame) - self.columnCount * self.seperatorLineWidth;
    NSUInteger minWidth = totalWidth / self.columnCount;
    NSUInteger left = totalWidth % self.columnCount;
    NSInteger minWidthCount = columnNumber - left;
    
    NSUInteger result = MIN(left, columnNumber) * (minWidth + 1) + (minWidthCount > 0 ? minWidthCount * minWidth:0) + columnNumber * self.seperatorLineWidth;
    return result;
}

- (NSUInteger)widthForColumnNumber:(NSUInteger)columnNumber {
    NSUInteger totalWidth = CGRectGetWidth(self.collectionView.frame) - self.columnCount * self.seperatorLineWidth;
    NSUInteger left = totalWidth % self.columnCount;
    NSUInteger result = totalWidth / self.columnCount;
    if (columnNumber < left) {
        result++;
    }
    return result;
}

#pragma mark - Override Methods
- (void)prepareLayout {
    [super prepareLayout];
    [self.itemAttributes removeAllObjects];
    [self.decorationAttributes removeAllObjects];
    
    CGRect frame = self.collectionView.bounds;
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    NSInteger pageCount = self.columnCount * self.maxRowCount;
    self.numberOfPage = itemCount / pageCount + (itemCount % pageCount ? 1 : 0);
    self.actualRowCount = MIN(self.maxRowCount, itemCount / self.columnCount + (itemCount % self.columnCount ? 1 : 0));
    if (self.actualRowCount == 0) {
        return;
    }
    
    
    CGFloat itemHeight = (CGRectGetHeight(frame) - (self.actualRowCount + 1) * self.seperatorLineWidth) / self.actualRowCount;
    
    if (CGRectGetHeight(frame) == 0) return;
    for (NSInteger i = 0; i != itemCount; ++i) {
        NSInteger pageNumber = i / pageCount;
        NSInteger indexInPage = i % pageCount;
        NSInteger columnNumber = indexInPage % self.columnCount;
        NSInteger rowNumber = indexInPage / self.columnCount;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        
        CGFloat x = [self seperatorLineOriginXForColumnNumber:columnNumber] + self.seperatorLineWidth + pageNumber * CGRectGetWidth(frame);
        CGFloat y = rowNumber * (itemHeight + self.seperatorLineWidth) + self.seperatorLineWidth;
        CGFloat width = [self widthForColumnNumber:columnNumber];
        attributes.frame = CGRectMake(x, y, width, itemHeight);
        [self.itemAttributes addObject:attributes];
    }
    
    // Add horizontal seperator lines
    for (NSInteger i = 0; i != self.actualRowCount + 1; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemCount + i inSection:0];
        UICollectionViewLayoutAttributes *decorationAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationKind withIndexPath:indexPath];
        CGFloat y = i * (itemHeight + self.seperatorLineWidth);
        decorationAttributes.frame = CGRectMake(0, y, self.collectionView.frame.size.width * self.numberOfPage, self.seperatorLineWidth);
        decorationAttributes.zIndex = 2;
        self.decorationAttributes[indexPath] = decorationAttributes;
    }
    
    // Add vertical seperator lines
    for (NSInteger i = 1; i != self.numberOfPage * self.columnCount; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.actualRowCount + i + itemCount inSection:0];
        UICollectionViewLayoutAttributes *decorationAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationKind withIndexPath:indexPath];
        NSInteger page = i / self.columnCount;
        NSInteger column = i % self.columnCount;
        CGFloat x = [self seperatorLineOriginXForColumnNumber:column] + page * CGRectGetWidth(self.collectionView.frame);
        decorationAttributes.frame = CGRectMake(x, 0, self.seperatorLineWidth, self.collectionView.frame.size.height);
        decorationAttributes.zIndex = 2;
        self.decorationAttributes[indexPath] = decorationAttributes;
    }
}

- (CGSize)collectionViewContentSize {
    CGSize result = CGSizeMake(self.numberOfPage * CGRectGetWidth(self.collectionView.frame), CGRectGetHeight(self.collectionView.frame));
    return result;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self.itemAttributes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UICollectionViewLayoutAttributes *attribute = obj;
        CGRect frame = attribute.frame;
        if (CGRectIntersectsRect(frame, rect)) {
            [result addObject:attribute];
        }
    }];
    
    [self.decorationAttributes enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        UICollectionViewLayoutAttributes *attribute = obj;
        CGRect frame = attribute.frame;
        if (CGRectIntersectsRect(frame, rect)) {
            [result addObject:attribute];
        }
    }];
    
    return result;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemAttributes[indexPath.item];
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return self.decorationAttributes[indexPath];
}

@end
