JBSpacer
========

By [Mike Swanson](http://blog.mikeswanson.com/)

As the number of iOS screen sizes continues to increase, it becomes more and more difficult to design a regular grid of items that appears balanced at any size. JBSpacer calculates optimal spacing for a grid of items while maintaining a specified ratio between inner gutter and outer margin sizes.

Here's an example from the included project that first shows standard _UICollectionViewFlowLayout_ behavior when the width increases, and _JBSpacer_ behavior after the _Calculations_ switch is enabled and the width decreases:

![JBSpacer Example](http://www.mikeswanson.com/files/JBSpacer/JBSpacer.gif)

JBSpacer can be configured with specific settings, or it can choose the best/tightest spacing from multiple options.

The spacer automatically snaps to pixel (not point) boundaries for fine control, and it has been tested at @1x, @2x, and @3x resolutions. It is currently being used in [Halftone 2](http://www.juicybitssoftware.com/halftone2/) and [Layout](http://www.juicybitssoftware.com/layout/).

Two convenience methods make it easy to apply the calculated spacing:

* _frameForItemAtIndex:_ provides a frame for an item at the specified index.
* _applySpacingToCollectionViewFlowLayout:_ configures a _UICollectionViewFlowLayout_ instance to produce a regularly-spaced grid.

Of course, the raw spacing results can also be used for custom layout.

## Requirements

JBSpacer has been built and tested for iOS 8, though it should work with iOS 6 and later. Also, while JBSpacer may work for Mac development with slight modification (for example, to accomodate _NSCollectionView_), I have not tried this myself.

## Usage

Add JBSpacer.h/.m and JBSpacerOption.h/.m to your project. Then:

    #import "JBSpacer.h"

To configure an option:

    JBSpacerOption *option = [JBSpacerOption optionWithItemSize:50.0f
                                                  minimumGutter:2.0f
                                            gutterToMarginRatio:1.0f
                                                  availableSize:320.0f
                                       distributeExtraToMargins:YES]];

The spacer performs its calculations in a single dimension, assuming that the second dimension (for example, in a _UICollectionView_) will scroll. In this example, both the _itemSize_ and _availableSize_ parameters represent widths, though they could just as easily be used as heights in other layout scenarios.

The _gutterToMarginRatio_ parameter is a factor that represents the acceptable margin size as it relates to the gutter size. In this example, the _minimumGutter_ parameter is set to 2.0, so the minimum margin size would be 2.0 x 1.0 = 2.0. If the final gutter size was 3.5, the margin size would also be 3.5, and so on.

The _distributeExtraToMargins_ parameter controls whether any extra space should be distributed into the margins. Not all calculations result in perfect solutions, and this is a way to hide the extra space while maintaining a pleasant balance. Because calculations are performed at the pixel (not point) level, there is typically very little extra space to account for, and it can easily hide in the margins without significantly impacting the _gutterToMarginRatio_.

To calculate spacing, create a _JBSpacer_ with the specified option:

    JBSpacer *spacer = [JBSpacer spacerWithOption:option];

The _spacing_ property of the spacer contains the results of the calculation.

To consider multiple options, call _findBestSpacingWithOptions:_. This provides the spacer with more than one acceptable solution, and it will find the solution with the tightest presentation:

    BOOL success = [spacer findBestSpacingWithOptions:
                    @[[JBSpacerOption optionWithItemSize:78.5f
                                           minimumGutter:2.0f
                                     gutterToMarginRatio:0.0f
                                           availableSize:320.0f
                                distributeExtraToMargins:YES],
                      [JBSpacerOption optionWithItemSize:78.5f
                                           minimumGutter:2.0f
                                     gutterToMarginRatio:1.0f
                                           availableSize:320.0f
                                distributeExtraToMargins:YES]]];

To use the optimal spacing with a _UICollectionView_, apply the results to an instance of _UICollectionViewFlowLayout_:

	[spacer applySpacingToCollectionViewFlowLayout:flowLayout];

And that's it. Enjoy!
