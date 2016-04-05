//
//  NIETabControl.m
//  NIESpider
//
//  Created by Liuyong on 15-1-4.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//


#import "FZTabControl.h"

#define kSelectedColor [UIColor colorWithRed:142./255 green:196./255 blue:56./255 alpha:1]


@interface FZTabControl ()

@end

@implementation FZTabControl


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithSectionTitles:(NSArray *)sectiontitles {
    self = [super initWithSectionTitles:sectiontitles];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithSectionImages:(NSArray *)sectionImages sectionSelectedImages:(NSArray *)sectionSelectedImages {
    self = [super initWithSectionImages:sectionImages sectionSelectedImages:sectionSelectedImages];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithSectionImages:(NSArray *)sectionImages sectionSelectedImages:(NSArray *)sectionSelectedImages titlesForSections:(NSArray *)sectiontitles {
    self = [super initWithSectionImages:sectionImages sectionSelectedImages:sectionSelectedImages titlesForSections:sectiontitles];
    if (self) {
        [self customInit];
    }
    return self;
}

/**
 *  整个应该默认自定义tab样式，统一封装
 */
- (void)customInit {
    HMSegmentedControl *tabControl = self;
    [tabControl setSelectedSegmentIndex:0 animated:NO];
    tabControl.backgroundColor = [UIColor whiteColor];

    FZStyleSheet *css = [FZStyleSheet currentStyleSheet];
    tabControl.shouldAnimateUserSelection = YES;
    tabControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    tabControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    tabControl.selectionIndicatorBoxOpacity = 0.0f;
    tabControl.selectionIndicatorColor = css.colorOfMainTint;
    tabControl.selectionIndicatorHeight = 2;
    tabControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    
    tabControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName: [UIFont systemFontOfSize:17]};
    tabControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : css.colorOfMainTint, NSFontAttributeName: [UIFont boldSystemFontOfSize:17]};
    self.prevSelectedSegmentIndex = -1;
}

@end
