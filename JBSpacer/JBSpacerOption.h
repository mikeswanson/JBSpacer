//
//  JBSpacerOption.h
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

/**
 *  @class  JBSpacerOption
 *
 *  @brief  The @p JBSpacerOption class contains configurable settings for a @p JBSpacer.
 */
@interface JBSpacerOption : NSObject <NSCopying>

#pragma mark - Properties

/** The size of each item (in points). */
@property (nonatomic, readwrite, assign)    CGFloat         itemSize;

/** The minimum spacing to use between items (in points). */
@property (nonatomic, readwrite, assign)    CGFloat         minimumGutter;

/** The desired ratio of the gutter size to the margin size. */
@property (nonatomic, readwrite, assign)    CGFloat         gutterToMarginRatio;

/** The available size to fill (in points). */
@property (nonatomic, readwrite, assign)    CGFloat         availableSize;

/** A Boolean value that controls whether extra space should be distributed to the margins. */
@property (nonatomic, readwrite, assign)    BOOL            distributeExtraToMargins;

#pragma mark - Class methods

/**
 *  Creates a spacer option with the specified settings.
 *
 *  @param  itemSize                    The size of each item (in points).
 *
 *  @param  minimumGutter               The minimum spacing to use between items (in points).
 *
 *  @param  gutterToMarginRatio         The desired ratio of the gutter size to the margin size.
 *
 *  @param  availableSize               The available size to fill (in points).
 *
 *  @param  distributeExtraToMargins    A Boolean value that controls whether extra space should
 *                                      be distributed to the margins.
 *
 *  @return                             New spacer option with the specified settings.
 */
+ (JBSpacerOption *)optionWithItemSize:(CGFloat)itemSize
                         minimumGutter:(CGFloat)minimumGutter
                   gutterToMarginRatio:(CGFloat)gutterToMarginRatio
                         availableSize:(CGFloat)availableSize
              distributeExtraToMargins:(BOOL)distributeExtraToMargins;

@end
