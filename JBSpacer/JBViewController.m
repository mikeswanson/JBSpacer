//
//  JBViewController.m
//  JBSpacer
//
//  Created by Michael Swanson on 9/1/14.
//  Copyright (c) 2014 Juicy Bits. All rights reserved.
//

#import "JBViewController.h"
#import "JBSpacer.h"

@interface JBViewController () <UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *availableWidthLabel;
@property (strong, nonatomic) IBOutlet UIStepper *availableWidthStepper;
@property (strong, nonatomic) IBOutlet UILabel *itemSizeLabel;
@property (strong, nonatomic) IBOutlet UIStepper *itemSizeStepper;
@property (strong, nonatomic) IBOutlet UILabel *minimumGutterLabel;
@property (strong, nonatomic) IBOutlet UIStepper *minimumGutterStepper;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidthConstraint;
@property (strong, nonatomic) IBOutlet UISwitch *calculationsSwitch;
@property (strong, nonatomic) IBOutlet UILabel *itemCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *marginLabel;
@property (strong, nonatomic) IBOutlet UILabel *gutterLabel;
@property (strong, nonatomic) IBOutlet UILabel *extraLabel;
@property (strong, nonatomic) IBOutlet UILabel *gutterToMarginRatioLabel;

@end

@implementation JBViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.itemSizeStepper.value = self.collectionViewFlowLayout.itemSize.width;
    
    [self updateTextFields];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self calculateAndApplyBestSpacing];
}

- (IBAction)calculationsSwitchValueChanged:(UISwitch *)sender {
    
    [self calculateAndApplyBestSpacing];
}

- (void)updateTextFields
{
    self.availableWidthLabel.text = [NSString stringWithFormat:@"%.0f", self.availableWidthStepper.value];
    self.itemSizeLabel.text = [NSString stringWithFormat:@"%.0f", self.itemSizeStepper.value];
    self.minimumGutterLabel.text = [NSString stringWithFormat:@"%.0f", self.minimumGutterStepper.value];
}

- (IBAction)availableWidthStepperChanged:(UIStepper *)sender {
    
    self.collectionViewWidthConstraint.constant = sender.value;
    
    [self updateTextFields];
    
    [self calculateAndApplyBestSpacing];
}

- (IBAction)itemSizeStepperChanged:(UIStepper *)sender {
    
    self.collectionViewFlowLayout.itemSize = CGSizeMake(sender.value, sender.value);
    
    [self updateTextFields];
    
    [self calculateAndApplyBestSpacing];
}

- (IBAction)minimumGutterStepperChanged:(UIStepper *)sender {
    
    [self updateTextFields];
    
    [self calculateAndApplyBestSpacing];
}

- (void)calculateAndApplyBestSpacing
{
    CGFloat availableSize = self.collectionViewWidthConstraint.constant;
    CGFloat itemSize = self.collectionViewFlowLayout.itemSize.width;
    CGFloat minimumGutter = self.minimumGutterStepper.value;
    
    BOOL success = NO;
    
    if (self.calculationsSwitch.isOn) {
        
        JBSpacer *spacer = [JBSpacer spacer];
        
        success = [spacer findBestSpacingWithOptions:@[[JBSpacerOption optionWithItemSize:itemSize
                                                                            minimumGutter:minimumGutter
                                                                      gutterToMarginRatio:0.0f
                                                                            availableSize:availableSize
                                                                 distributeExtraToMargins:YES],
                                                       [JBSpacerOption optionWithItemSize:itemSize
                                                                            minimumGutter:minimumGutter
                                                                      gutterToMarginRatio:1.0f
                                                                            availableSize:availableSize
                                                                 distributeExtraToMargins:YES]]];
        
        if (success) {
            
            [spacer applySpacingToCollectionViewFlowLayout:self.collectionViewFlowLayout];
            
            self.itemCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)spacer.spacing.itemCount];
            self.marginLabel.text = [NSString stringWithFormat:@"%.2f", spacer.spacing.margin];
            self.gutterLabel.text = [NSString stringWithFormat:@"%.2f", spacer.spacing.gutter];
            self.extraLabel.text = [NSString stringWithFormat:@"%.2f", spacer.spacing.extra];
            self.gutterToMarginRatioLabel.text = [NSString stringWithFormat:@"%.2f", spacer.option.gutterToMarginRatio];
        }
    }
    else {
        
        // No calcuations, so just apply settings
        self.collectionViewFlowLayout.minimumLineSpacing = minimumGutter;
        self.collectionViewFlowLayout.minimumInteritemSpacing = minimumGutter;
        self.collectionViewFlowLayout.itemSize = CGSizeMake(itemSize, itemSize);
        self.collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(minimumGutter, minimumGutter, minimumGutter, minimumGutter);
    }
    
    if (!success) {
        
        self.itemCountLabel.text = @"n/a";
        self.marginLabel.text = @"n/a";
        self.gutterLabel.text = @"n/a";
        self.extraLabel.text = @"n/a";
        self.gutterToMarginRatioLabel.text = @"n/a";
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 500;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                           forIndexPath:indexPath];
    
    return cell;
}

@end
