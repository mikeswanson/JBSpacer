//
//  JBSpacer.m
//
//  Created by Mike Swanson on 9/1/14.
//  Copyright (c) 2014 Mike Swanson. All rights reserved.
//  http://blog.mikeswanson.com
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "JBSpacer.h"

// This scale value is used to lower the precision of final calculations for screen display
static const CGFloat JBLowPrecisionScale = 1000.0f;

#pragma mark - JBSpacing

const JBSpacing JBSpacingZero = { 0, 0.0f, 0.0f, 0.0f };

BOOL JBSpacingEqualToSpacing(JBSpacing spacing1, JBSpacing spacing2)
{
    return (spacing1.itemCount == spacing2.itemCount &&
            spacing1.margin == spacing2.margin &&
            spacing1.gutter == spacing2.gutter &&
            spacing1.extra == spacing2.extra);
}

NSString *NSStringFromJBSpacing(JBSpacing spacing)
{
    return [NSString stringWithFormat:@"{ itemCount: %lu, margin: %.1f, gutter: %.1f, extra: %.1f }",
            (unsigned long)spacing.itemCount, spacing.margin, spacing.gutter, spacing.extra];
}

CGFloat JBSnapFloatToScale(CGFloat value, CGFloat scale)
{
    return (floorf(value * scale) / scale);
}

@interface JBSpacer ()

@property (nonatomic, readwrite, assign)    JBSpacing       spacing;
@property (nonatomic, readwrite, assign)    BOOL            spacingNeedsUpdate;

@end

@implementation JBSpacer

#pragma mark - Class methods

+ (JBSpacer *)spacer
{
    return [[JBSpacer alloc] init];
}

+ (JBSpacer *)spacerWithOption:(JBSpacerOption *)option
{
    return [[JBSpacer alloc] initWithOption:option];
}

#pragma mark - Instance methods

- (instancetype)init
{
    return [self initWithOption:nil];
}

- (instancetype)initWithOption:(JBSpacerOption *)option
{
    self = [super init];
    if (self) {
        
        _option = option;
        [self observeOption];
        
        _screenScale = 0.0f;
        _spacing = JBSpacingZero;
        _spacingNeedsUpdate = YES;
    }
    return self;
}

- (void)dealloc
{
    [self unObserveOption];
}

#pragma mark - Properties

- (void)setOption:(JBSpacerOption *)option
{
    if (option != _option) {
        
        [self unObserveOption];
        
        _option = option;
        
        [self observeOption];
        
        [self setSpacingNeedsUpdate];
    }
}

- (void)setScreenScale:(CGFloat)screenScale
{
    NSCParameterAssert(screenScale >= 0.0f);
    
    if (screenScale != _screenScale) {
        
        _screenScale = screenScale;
        [self setSpacingNeedsUpdate];
    }
}

- (JBSpacing)spacing
{
    [self updateSpacingIfNecessary];
    
    return _spacing;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setSpacingNeedsUpdate];
}

- (void)observeOption
{
    if (_option) {
        
        [_option addObserver:self forKeyPath:@"itemSize" options:0 context:NULL];
        [_option addObserver:self forKeyPath:@"minimumGutter" options:0 context:NULL];
        [_option addObserver:self forKeyPath:@"gutterToMarginRatio" options:0 context:NULL];
        [_option addObserver:self forKeyPath:@"availableSize" options:0 context:NULL];
        [_option addObserver:self forKeyPath:@"distributeExtraToMargins" options:0 context:NULL];
    }
}

- (void)unObserveOption
{
    if (_option) {
        
        [_option removeObserver:self forKeyPath:@"itemSize"];
        [_option removeObserver:self forKeyPath:@"minimumGutter"];
        [_option removeObserver:self forKeyPath:@"gutterToMarginRatio"];
        [_option removeObserver:self forKeyPath:@"availableSize"];
        [_option removeObserver:self forKeyPath:@"distributeExtraToMargins"];
    }
}

#pragma mark - Spacing calculations

- (void)setSpacingNeedsUpdate
{
    _spacingNeedsUpdate = YES;
}

- (void)updateSpacingIfNecessary
{
    if (!_spacingNeedsUpdate) { return; }
    
    _spacing = JBSpacingZero;
    
    if (!_option || _option.itemSize == 0.0f || _option.availableSize == 0.0f) { return; }
    
    CGFloat minimumMargin = _option.minimumGutter * _option.gutterToMarginRatio;
    CGFloat maximumContentWidth = _option.availableSize - (minimumMargin * 2.0f);
    NSUInteger itemCount = (maximumContentWidth / _option.itemSize);
    CGFloat neededContentWidth = FLT_MAX;
    
    // Any items to consider?
    if (itemCount > 0) {
        
        // Determine item count
        while (itemCount > 0 &&
               neededContentWidth > maximumContentWidth) {
            
            neededContentWidth = (itemCount * _option.itemSize) + ((itemCount - 1) * _option.minimumGutter);
            
            itemCount--;
        };
        
        // Did we find a solution?
        if (neededContentWidth <= maximumContentWidth) {
            
            _spacing.itemCount = itemCount + 1;
            
            CGFloat idealGutter = ((_option.availableSize - (_spacing.itemCount * _option.itemSize)) /
                                   (_spacing.itemCount + (2.0f * _option.gutterToMarginRatio) - 1.0f));
            
            // Snap values to screen scale
            CGFloat screenScale = (_screenScale == 0.0f ? [UIScreen mainScreen].scale : _screenScale);
            _spacing.margin = JBSnapFloatToScale(idealGutter * _option.gutterToMarginRatio, screenScale);
            _spacing.gutter = JBSnapFloatToScale(idealGutter, screenScale);
            
            _spacing.extra = (_option.availableSize -
                              ((_spacing.margin * 2.0f) + (_spacing.itemCount * _option.itemSize) + ((_spacing.itemCount - 1) * _spacing.gutter)));
            
            // Distribute extra to the margins?
            if (_option.distributeExtraToMargins &&
                (_spacing.extra >= (2.0f / screenScale))) {
                
                CGFloat extraToDistribute = JBSnapFloatToScale(_spacing.extra * 0.5f, screenScale);
                _spacing.margin += extraToDistribute;
                _spacing.extra -= (extraToDistribute * 2.0f);
            }
            
            // Special attention for potential float/zero issues
            if (fabs(_spacing.extra) < 0.0001f) {
                
                _spacing.extra = 0.0f;
            }
        }
    }
    
    _spacingNeedsUpdate = NO;
}

- (BOOL)findBestSpacingWithOptions:(NSArray *)options
{
    NSParameterAssert(options);
    NSParameterAssert(options.count > 0);
    
    BOOL foundBestSpacing = NO;
    
    // Use a copy, so we don't needlessly mutate our own values until we're done
    JBSpacer *spacer = [self copy];
    
    JBSpacerOption *bestOption = nil;
    JBSpacing bestSpacing = JBSpacingZero;
    bestSpacing.gutter = FLT_MAX;
    bestSpacing.extra = FLT_MAX;
    
    for (JBSpacerOption *option in options) {
        
        spacer.option = option;
        
        if (spacer.spacing.itemCount > 0 &&
            (spacer.spacing.gutter < bestSpacing.gutter ||
             (spacer.spacing.gutter == bestSpacing.gutter && spacer.spacing.extra < bestSpacing.extra))) {
                
                bestOption = option;
                bestSpacing = spacer.spacing;
                foundBestSpacing = YES;
            }
        
        // If we've found an optimal solution, no need to continue
        if (bestSpacing.gutter == option.minimumGutter &&
            bestSpacing.extra == 0.0f) {
            
            break;
        }
    }
    
    // Update ourselves
    self.option = bestOption;
    self.spacing = (foundBestSpacing ? bestSpacing : JBSpacingZero);
    self.spacingNeedsUpdate = NO;
    
    return foundBestSpacing;
}

- (CGRect)frameForItemAtIndex:(NSUInteger)index
{
    NSUInteger row = index / self.spacing.itemCount;
    NSUInteger column = index % self.spacing.itemCount;
    
    CGFloat screenScale = (_screenScale == 0.0f ? [UIScreen mainScreen].scale : _screenScale);
    CGFloat x = JBSnapFloatToScale(self.spacing.margin + (column * self.option.itemSize) + (column * self.spacing.gutter), screenScale);
    CGFloat y = JBSnapFloatToScale(self.spacing.margin + (row * self.option.itemSize) + (row * self.spacing.gutter), screenScale);
    
    // Lower precision
    x = JBSnapFloatToScale(x, JBLowPrecisionScale);
    y = JBSnapFloatToScale(y, JBLowPrecisionScale);
    
    return CGRectMake(x, y, self.option.itemSize, self.option.itemSize);
}

- (void)applySpacingToCollectionViewFlowLayout:(UICollectionViewFlowLayout *)flowLayout
{
    NSParameterAssert(flowLayout);
    
    // Lower precision
    CGFloat gutter = JBSnapFloatToScale(self.spacing.gutter, JBLowPrecisionScale);
    CGFloat margin = JBSnapFloatToScale(self.spacing.margin, JBLowPrecisionScale);
    CGFloat marginExtra = JBSnapFloatToScale(self.spacing.margin + self.spacing.extra, JBLowPrecisionScale);
    
    flowLayout.minimumLineSpacing = gutter;
    flowLayout.minimumInteritemSpacing = gutter;
    flowLayout.itemSize = CGSizeMake(self.option.itemSize, self.option.itemSize);
    flowLayout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, marginExtra);    // Apply extra to right margin
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    
    JBSpacer *spacerCopy = [[[self class] allocWithZone:zone] init];
    
    spacerCopy.option = [_option copy];
    spacerCopy.screenScale = _screenScale;
    spacerCopy.spacing = _spacing;
    spacerCopy.spacingNeedsUpdate = _spacingNeedsUpdate;
    
    return spacerCopy;
}

@end
