//
//  JBSpacer.h
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

#import <UIKit/UIKit.h>
#import "JBSpacerOption.h"

#pragma mark - JBSpacing

/**
 *  @struct     JBSpacing
 *  @abstract   The result of a spacing calculation.
 */
typedef struct {
    
    /** Number of items that fit or 0 if spacing is invalid. */
    NSUInteger  itemCount;
    
    /** Outer margin size (in points). */
    CGFloat     margin;
    
    /** Inner gutter size (in points). */
    CGFloat     gutter;
    
    /** Extra space that doesn't fit. */
    CGFloat     extra;
    
} JBSpacing;

/** A spacing constant with an itemCount, margin, gutter, and extra equal to 0. */
FOUNDATION_EXPORT const     JBSpacing JBSpacingZero;

/**
 *  Returns whether two spacing results are equal.
 *
 *  @param  spacing1        The first spacing result to examine.
 *
 *  @param  spacing2        The second spacing result to examine.
 *
 *  @return                 @p YES if the two spacing results are equal or @p NO if
 *                          they're different.
 */
FOUNDATION_EXPORT BOOL      JBSpacingEqualToSpacing(JBSpacing spacing1, JBSpacing spacing2);

/**
 *  Returns a string formatted to contain the data from a spacing result.
 *
 *  @param  spacing         The spacing result.
 *
 *  @return                 A string that represents the spacing result.
 */
FOUNDATION_EXPORT NSString  *NSStringFromJBSpacing(JBSpacing spacing);

/**
 *  @class  JBSpacer
 *
 *  @brief  The @p JBSpacer class calculates optimal spacing for a set of items based on
 *          configurable options and a specified screen scale.
 */
@interface JBSpacer : NSObject <NSCopying>

#pragma mark - Properties

/** The option used to calculate spacing. */
@property (nonatomic, readwrite, strong)    JBSpacerOption  *option;

/** The screen scale factor to use to calculate spacing. Specifying 0.0 will automatically
 *  use the scale of the main screen. */
@property (nonatomic, readwrite, assign)    CGFloat         screenScale;

/* The result of the spacing calculation. */
@property (nonatomic, readonly, assign)     JBSpacing       spacing;

#pragma mark - Class methods

/**
 *  Creates a spacer with a default option.
 *
 *  @return                 A new spacer.
 */
+ (JBSpacer *)spacer;

/**
 *  Creates a spacer with the specified option.
 *
 *  @param  option          An option that describe how to calculate spacing.
 *
 *  @return                 A new spacer configured with the specified option.
 */
+ (JBSpacer *)spacerWithOption:(JBSpacerOption *)option;

#pragma mark - Instance methods

/**
 *  Finds the best (tightest) spacing in an array of options.
 *
 *  @param  options         An array of @p JBSpacerOption instances that each describe how
 *                          to calculate spacing.
 *
 *  @return                 @p YES if valid spacing was found or @p NO if none of the
 *                          solutions were valid.
 */
- (BOOL)findBestSpacingWithOptions:(NSArray *)options;

/**
 *  Returns a frame for an item at the specified index using current spacing and assuming a
 *  regularly-spaced grid.
 *
 *  @param  index           Index of the item.
 *
 *  @return                 @p CGRect for the frame at the specified index.
 */
- (CGRect)frameForItemAtIndex:(NSUInteger)index;

/**
 *  Applies the current spacing to an instance of @p UICollectionViewFlowLayout to produce a
 *  regularly-spaced grid.
 *
 *  @param  flowLayout      The @p UICollectionViewFlowLayout to configure.
 */
- (void)applySpacingToCollectionViewFlowLayout:(UICollectionViewFlowLayout *)flowLayout;

@end
