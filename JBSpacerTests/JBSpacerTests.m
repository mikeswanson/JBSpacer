//
//  JBSpacerTests.m
//  JBSpacerTests
//
//  Created by Michael Swanson on 9/1/14.
//  Copyright (c) 2014 Juicy Bits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "JBSpacer.h"

@interface JBSpacerTests : XCTestCase

@end

@implementation JBSpacerTests

- (void)setUp {
    
    [super setUp];
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testSpacerInit {
    
    JBSpacer *spacer = [[JBSpacer alloc] init];
    XCTAssert(spacer, @"Spacer failed init");
    XCTAssert(spacer.screenScale == 0.0f, @"Default screen scale should be 0.0f");
    
    spacer = [JBSpacer spacer];
    XCTAssert(spacer, @"Spacer failed init");
    
    JBSpacerOption *option = [JBSpacerOption optionWithItemSize:20.0f
                                                  minimumGutter:2.0f
                                            gutterToMarginRatio:1.0f
                                                  availableSize:320.0f
                                       distributeExtraToMargins:YES];
    
    spacer = [JBSpacer spacerWithOption:option];
    XCTAssert(spacer, @"Spacer failed init");
    XCTAssert(spacer.option == option, @"Missing option");
}

- (void)testSpacerProperties {
    
    JBSpacer *spacer = [[JBSpacer alloc] init];
    
    // spacing
    XCTAssert(JBSpacingEqualToSpacing(spacer.spacing, JBSpacingZero), @"Invalid default spacing");
    
    // option
    JBSpacerOption *option = [JBSpacerOption optionWithItemSize:20.0f
                                                  minimumGutter:2.0f
                                            gutterToMarginRatio:1.0f
                                                  availableSize:320.0f
                                       distributeExtraToMargins:YES];
    
    spacer.option = option;
    XCTAssert(spacer.option == option, @"Option not set correctly");
    
    // nil option
    spacer.option = nil;
    XCTAssert(!spacer.option, @"Spacer should allow nil option");
    
    // screenScale
    XCTAssertThrows(spacer.screenScale = -1.0f, @"Screen scale cannot be negative");
    spacer.screenScale = 3.0f;
    XCTAssert(spacer.screenScale == 3.0f, @"Screen scale not set correctly");
}

- (void)testSpacerOptionInit {
    
    JBSpacerOption *option = [[JBSpacerOption alloc] init];
    
    XCTAssert(option, @"Spacer option failed init");
    XCTAssert(option.itemSize == 0.0f, @"Default item size should be 0.0f");
    XCTAssert(option.minimumGutter == 0.0f, @"Default minimum gutter should be 0.0f");
    XCTAssert(option.gutterToMarginRatio == 0.0f, @"Default gutter to margin ratio should be 0.0f");
    XCTAssert(option.availableSize == 0.0f, @"Default available size should be 0.0f");
    
    option = [JBSpacerOption optionWithItemSize:20.0f
                                  minimumGutter:2.0f
                            gutterToMarginRatio:1.0f
                                  availableSize:320.0f
                       distributeExtraToMargins:YES];
    
    XCTAssert(option, @"Spacer option failed init");
    XCTAssert(option.itemSize == 20.0f, @"Incorrect item size");
    XCTAssert(option.minimumGutter == 2.0f, @"Incorrect minimum gutter");
    XCTAssert(option.gutterToMarginRatio == 1.0f, @"Incorrect gutter to margin ratio");
    XCTAssert(option.availableSize == 320.0f, @"Incorrect available size");
}

- (void)testSpacerOptionProperties {
    
    JBSpacerOption *option = [[JBSpacerOption alloc] init];
    
    // itemSize
    XCTAssertThrows(option.itemSize = -20.0f, @"Item size cannot be negative");
    option.itemSize = 20.0f;
    XCTAssert(option.itemSize == 20.0f, @"Item size not set correctly");
    
    // minimumGutter
    XCTAssertThrows(option.minimumGutter = -2.0f, @"Minimum gutter cannot be negative");
    option.minimumGutter = 2.0f;
    XCTAssert(option.minimumGutter == 2.0f, @"Minimum gutter not set correctly");
    
    // gutterToMarginRatio
    XCTAssertThrows(option.gutterToMarginRatio = -1.0f, @"Gutter to margin ratio cannot be negative");
    option.gutterToMarginRatio = 1.0f;
    XCTAssert(option.gutterToMarginRatio == 1.0f, @"Gutter to margin ratio not set correctly");
    
    // availableSize
    XCTAssertThrows(option.availableSize = -320.0f, @"Available size cannot be negative");
    option.availableSize = 320.0f;
    XCTAssert(option.availableSize == 320.0f, @"Available size not set correctly");
}

- (void)testSpacingCalculations {
    
    JBSpacerOption *option = [JBSpacerOption optionWithItemSize:20.0f
                                                  minimumGutter:2.0f
                                            gutterToMarginRatio:1.0f
                                                  availableSize:320.0f
                                       distributeExtraToMargins:YES];
    
    JBSpacer *spacer = [JBSpacer spacerWithOption:option];
    
    // Force screen scale, regardless of testing device
    spacer.screenScale = 2.0f;
    
    JBSpacing correctSpacing = { 14, 3.5f, 2.5f, 0.5f };
    XCTAssert(JBSpacingEqualToSpacing(spacer.spacing, correctSpacing), @"Calculation is incorrect");
    
    // Test complete option change
    JBSpacerOption *newOption = [JBSpacerOption optionWithItemSize:78.5f
                                                     minimumGutter:2.0f
                                               gutterToMarginRatio:2.0f
                                                     availableSize:320.0f
                                          distributeExtraToMargins:YES];
    spacer.option = newOption;
    JBSpacing newCorrectSpacing = { 3, 28.0f, 14.0f, 0.5f };
    
    XCTAssert(JBSpacingEqualToSpacing(spacer.spacing, newCorrectSpacing), @"Calculation is incorrect");
    
    // Mutate item size
    newOption.itemSize = 60.0f;
    JBSpacing correctItemSizeSpacing = { 5, 5.0f, 2.5f, 0.0f };
    XCTAssert(JBSpacingEqualToSpacing(spacer.spacing, correctItemSizeSpacing), @"Item size mutation caused incorrect calculation");
    
    // Mutate minimum gutter
    newOption.minimumGutter = 10.0f;
    JBSpacing correctMinimumGutterSpacing = { 4, 23.5f, 11.0f, 0.0f };
    XCTAssert(JBSpacingEqualToSpacing(spacer.spacing, correctMinimumGutterSpacing), @"Minimum gutter mutation caused incorrect calculation");
    
    // Mutate gutter to margin ratio
    newOption.gutterToMarginRatio = 1.5f;
    JBSpacing correctGutterToMarginRatioSpacing = { 4, 20.5f, 13.0f, 0.0f };
    XCTAssert(JBSpacingEqualToSpacing(spacer.spacing, correctGutterToMarginRatioSpacing), @"Gutter to margin ratio mutation caused incorrect calculation");
    
    // Mutate available size
    newOption.availableSize = 480.0f;
    JBSpacing correctAvailableSizeSpacing = { 6, 22.5f, 15.0f, 0.0f };
    XCTAssert(JBSpacingEqualToSpacing(spacer.spacing, correctAvailableSizeSpacing), @"Available size mutation caused incorrect calculation");
    
    // Test barely fit
    newOption.itemSize = 60.0f;
    newOption.minimumGutter = 10.0f;
    newOption.gutterToMarginRatio = 2.0f;
    newOption.availableSize = 100.0f;
    JBSpacing correctBarelyFitSpacing = { 1, 20.0f, 10.0f, 0.0f };
    XCTAssert(JBSpacingEqualToSpacing(spacer.spacing, correctBarelyFitSpacing), @"Calculation should fit into available size");
    
    // Test won't fit
    newOption.availableSize = 99.5f;
    XCTAssert(JBSpacingEqualToSpacing(spacer.spacing, JBSpacingZero), @"Calculation shouldn't fit into available size");
    
    // Test distribute to margins
    option = [JBSpacerOption optionWithItemSize:50.0f
                                  minimumGutter:2.0
                            gutterToMarginRatio:0.0f
                                  availableSize:312.0f
                       distributeExtraToMargins:NO];
    spacer = [JBSpacer spacerWithOption:option];
    
    // Force screen scale, regardless of testing device
    spacer.screenScale = 2.0f;
    
    JBSpacing correctNoDistributeSpacing = { 6, 0.0f, 2.0f, 2.0f };
    XCTAssert(JBSpacingEqualToSpacing(spacer.spacing, correctNoDistributeSpacing), @"Distribution to margins calculation is incorrect");
    
    option.distributeExtraToMargins = YES;
    JBSpacing correctDistributeSpacing = { 6, 1.0f, 2.0f, 0.0f };
    XCTAssert(JBSpacingEqualToSpacing(spacer.spacing, correctDistributeSpacing), @"Distribution to margins calculation is incorrect");
    
    // Test odd 3x screen scale calculations
    spacer.screenScale = 3.0f;
    
    XCTAssert(spacer.spacing.itemCount == 6, @"Calculation incorrect after screen scale change");
    XCTAssert(spacer.spacing.margin == 0.0f, @"Calculation incorrect after screen scale change");
    XCTAssert(fabs(spacer.spacing.gutter) - 2.3333f < 0.0001f, @"Calculation incorrect after screen scale change");
    XCTAssert(fabs(spacer.spacing.extra) - 0.3333f < 0.0001f, @"Calculation incorrect after screen scale change");
}

- (void)testBestSpacingCalculations {
    
    JBSpacer *spacer = [JBSpacer spacer];
    
    // Force screen scale, regardless of testing device
    spacer.screenScale = 2.0f;
    
    BOOL success = [spacer findBestSpacingWithOptions:@[ [JBSpacerOption optionWithItemSize:78.5f
                                                                              minimumGutter:2.0f
                                                                        gutterToMarginRatio:0.0f
                                                                              availableSize:320.0f
                                                                   distributeExtraToMargins:YES],
                                                         [JBSpacerOption optionWithItemSize:78.5f
                                                                              minimumGutter:2.0f
                                                                        gutterToMarginRatio:1.0f
                                                                              availableSize:320.0f
                                                                   distributeExtraToMargins:YES]]];
    XCTAssert(success, @"Should have found a best spacing solution");
    JBSpacing correctBestSpacing = { 4, 0.0f, 2.0f, 0.0f };
    XCTAssert(JBSpacingEqualToSpacing(spacer.spacing, correctBestSpacing), @"Calculation is incorrect");
    
    // Test no valid answers
    success = [spacer findBestSpacingWithOptions:@[ [JBSpacerOption optionWithItemSize:60.0f
                                                                         minimumGutter:10.0f
                                                                   gutterToMarginRatio:2.0f
                                                                         availableSize:99.5f
                                                              distributeExtraToMargins:YES],
                                                    [JBSpacerOption optionWithItemSize:78.5f
                                                                         minimumGutter:2.0f
                                                                   gutterToMarginRatio:1.0f
                                                                         availableSize:82.0f
                                                              distributeExtraToMargins:YES]]];
    XCTAssert(!success, @"Shouldn't have found a best spacing solution");
    XCTAssert(JBSpacingEqualToSpacing(spacer.spacing, JBSpacingZero), @"Should represent invalid result");
}

- (void)testFlowLayoutCalculations {
    
    JBSpacerOption *option = [JBSpacerOption optionWithItemSize:50.0f
                                                  minimumGutter:2.0f
                                            gutterToMarginRatio:1.0f
                                                  availableSize:320.0f
                                       distributeExtraToMargins:YES];
    
    JBSpacer *spacer = [JBSpacer spacerWithOption:option];
    
    // Force screen scale, regardless of testing device
    spacer.screenScale = 2.0f;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    [spacer applySpacingToCollectionViewFlowLayout:flowLayout];
    
    XCTAssert(flowLayout.minimumLineSpacing == 2.5f, @"Incorrect minimum line spacing");
    XCTAssert(flowLayout.minimumInteritemSpacing == 2.5f, @"Incorrect minimum inter-item spacing");
    XCTAssert(UIEdgeInsetsEqualToEdgeInsets(flowLayout.sectionInset,
                                            UIEdgeInsetsMake(3.5f, 3.5f, 3.5f, 4.0f)), @"Incorrect section inset");
}

- (void)testFrameCalculations {
    
    JBSpacerOption *option = [JBSpacerOption optionWithItemSize:50.0f
                                                  minimumGutter:2.0f
                                            gutterToMarginRatio:1.0f
                                                  availableSize:320.0f
                                       distributeExtraToMargins:YES];
    
    JBSpacer *spacer = [JBSpacer spacerWithOption:option];
    
    // Force screen scale, regardless of testing device
    spacer.screenScale = 2.0f;
    
    XCTAssert(CGRectEqualToRect([spacer frameForItemAtIndex:0],
                                CGRectMake(3.5f, 3.5f, 50.0f, 50.0f)), @"Incorrect frame");
    
    XCTAssert(CGRectEqualToRect([spacer frameForItemAtIndex:5],
                                CGRectMake(266.0f, 3.5f, 50.0f, 50.0f)), @"Incorrect frame");
    
    XCTAssert(CGRectEqualToRect([spacer frameForItemAtIndex:53],
                                CGRectMake(266.0f, 423.5f, 50.0f, 50.0f)), @"Incorrect frame");
}

@end
