//
//  JBSpacerOption.m
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

#import "JBSpacerOption.h"

@implementation JBSpacerOption

#pragma mark - Class methods

+ (JBSpacerOption *)optionWithItemSize:(CGFloat)itemSize
                         minimumGutter:(CGFloat)minimumGutter
                   gutterToMarginRatio:(CGFloat)gutterToMarginRatio
                         availableSize:(CGFloat)availableSize
              distributeExtraToMargins:(BOOL)distributeExtraToMargins
{
    JBSpacerOption *option = [[JBSpacerOption alloc] init];
    
    option.itemSize = itemSize;
    option.minimumGutter = minimumGutter;
    option.gutterToMarginRatio = gutterToMarginRatio;
    option.availableSize = availableSize;
    option.distributeExtraToMargins = distributeExtraToMargins;
    
    return option;
}

#pragma mark - Instance methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _itemSize = 0.0f;
        _minimumGutter = 0.0f;
        _gutterToMarginRatio = 0.0f;
        _availableSize = 0.0f;
        _distributeExtraToMargins = YES;
    }
    return self;
}

#pragma mark - Properties

- (void)setItemSize:(CGFloat)itemSize
{
    NSCParameterAssert(itemSize >= 0.0f);
    
    if (itemSize != _itemSize) {
        
        _itemSize = itemSize;
    }
}

- (void)setMinimumGutter:(CGFloat)minimumGutter
{
    NSCParameterAssert(minimumGutter >= 0.0f);
    
    if (minimumGutter != _minimumGutter) {
        
        _minimumGutter = minimumGutter;
    }
}

- (void)setGutterToMarginRatio:(CGFloat)gutterToMarginRatio
{
    NSCParameterAssert(gutterToMarginRatio >= 0.0f);
    
    if (gutterToMarginRatio != _gutterToMarginRatio) {
        
        _gutterToMarginRatio = gutterToMarginRatio;
    }
}

- (void)setAvailableSize:(CGFloat)availableSize
{
    NSCParameterAssert(availableSize >= 0.0f);
    
    if (availableSize != _availableSize) {
        
        _availableSize = availableSize;
    }
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    
    JBSpacerOption *optionCopy = [[[self class] allocWithZone:zone] init];
    
    optionCopy.itemSize = _itemSize;
    optionCopy.minimumGutter = _minimumGutter;
    optionCopy.gutterToMarginRatio = _gutterToMarginRatio;
    optionCopy.availableSize = _availableSize;
    optionCopy.distributeExtraToMargins = _distributeExtraToMargins;
    
    return optionCopy;
}

@end