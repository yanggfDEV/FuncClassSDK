//
//  FZStyleSheet.h
//
//
//  Created by CyonLeuPro on 15/6/15.
//
//

#import <Foundation/Foundation.h>

@interface NIEStyleSheetDummyObject : NSObject

@property (strong, nonatomic) id firstHelper;
@property (strong, nonatomic) id secondHelper;

@end

@interface FZStyleSheet : NSObject

+ (instancetype)defaultStyleSheet;
+ (instancetype)currentStyleSheet;

#pragma mark - Main Color

/**
 *  #89ca30 //green color
 */
@property (strong, nonatomic) UIColor *colorOfMainTint;

/**
 *  #fc504d
 */
@property (strong, nonatomic) UIColor *colorOfOrange;

/**
 *  #f8f8f8
 */
@property (strong, nonatomic) UIColor *colorOfNavigationBackground;


/**
 *  #efefef
 */
@property (strong, nonatomic) UIColor *colorOfBackground;

/**
 *  #E5E6E8
 */
@property (strong, nonatomic) UIColor *colorOfSectionTitleBackground;

/**
 *  #FAFAFA
 */
@property (strong, nonatomic) UIColor *colorOfListOrCardBackground;

/**
 *  #333333
 */
@property (strong, nonatomic) UIColor *colorOfListTitle;

/**
 *  #888888
 */
@property (strong, nonatomic) UIColor *colorOfListSubtitle;

/**
 *  #CCCCCC 60%
 */
@property (strong, nonatomic) UIColor *colorOfHighlightedSectionHeader;


/**
 *  #d6d6d6
 */
@property (strong, nonatomic) UIColor *colorOfSeperatorOnLightBackground;

/**
 *  white 10%
 */
//@property (strong, nonatomic) UIColor *colorOfSeperatorOnDarkBackground;

/**
 * #ebebeb 趣课堂描边
 * guangfu yang 16-3-28
 **/
@property (strong, nonatomic) UIColor *colorLine;


/**
 *  white 70%
 */
@property (strong, nonatomic) UIColor *colorOfWhiteMask;


/**
 *  white
 */
@property (strong, nonatomic) UIColor *colorOfLighterText;

/**
 *  white 30%
 */
@property (strong, nonatomic) UIColor *colorOfLessLightText;

/**
 *  white 60%
 */
@property (strong, nonatomic) UIColor *colorOfLightText;

/**
 *  black 50%
 */
@property (strong, nonatomic) UIColor *colorOfBlackMask;

/**
 *  #101317
 */
@property (strong, nonatomic) UIColor *colorOfDarkerText;

/**
 *  #101317 60%
 */
@property (strong, nonatomic) UIColor *colorOfDarkText;

/**
 *  #101317 30%
 */
@property (strong, nonatomic) UIColor *colorOfLessDarkText;

/**
 *  #2bc329
 */
@property (strong, nonatomic) UIColor *colorOfGreenButtonNormal;

/**
 *  #1a8e1a
 */
@property (strong, nonatomic) UIColor *colorOfGreenButtonHightlighted;
@property (strong, nonatomic) UIColor *colorOfBlueButtonHightlighted;

/**
 *  #cbcbcb
 */
@property (strong, nonatomic) UIColor *colorOfGreenButtonDisabled;

/**
 * #d2d2d4
 */
@property (strong, nonatomic) UIColor *colorOfCode;

/**
 *  32px
 */
@property (assign, nonatomic) CGFloat lengthOfGlobalLeftRightMargin;

/**
 *  38px
 */
@property (strong, nonatomic) UIFont *fontOfBoldH1;

/**
 *  34px
 */
@property (strong, nonatomic) UIFont *fontOfBoldH2;

/**
 *  28px
 */
@property (strong, nonatomic) UIFont *fontOfBoldH3;

/**
 *  24px
 */
@property (strong, nonatomic) UIFont *fontOfBoldH4;

/**
 *  22px
 */
@property (strong, nonatomic) UIFont *fontOfBoldH5;

/**
 *  20px
 */
@property (strong, nonatomic) UIFont *fontOfBoldH6;

/**
 *  32px
 */
@property (strong, nonatomic) UIFont *fontOfBoldH7;

/**
 *  38px
 */
@property (strong, nonatomic) UIFont *fontOfH1;

/**
 *  34px
 */
@property (strong, nonatomic) UIFont *fontOfH2;

/**
 *  28px
 */
@property (strong, nonatomic) UIFont *fontOfH3;

/**
 *  24px
 */
@property (strong, nonatomic) UIFont *fontOfH4;

/**
 *  22px
 */
@property (strong, nonatomic) UIFont *fontOfH5;

/**
 *  20px
 */
@property (strong, nonatomic) UIFont *fontOfH6;

/**
 * 32px
 */
@property (strong, nonatomic) UIFont *fontOfH7;

/**
 * 30px
 */
@property (strong, nonatomic) UIFont *fontOfH8;

@property (assign, nonatomic) CGFloat lengthOfRoundedLabelCornerRadius;

@property (assign, nonatomic) CGFloat lengthOf1px;
// text field / text view
@property (assign, nonatomic) CGFloat textFieldUnderlineWidth;
@property (assign, nonatomic) CGFloat textFieldHeight;
@property (assign, nonatomic) UIEdgeInsets textFieldPadding;

// segmented view controller.
@property (assign, nonatomic) CGSize sectionSegmentedControlSize;
@property (assign, nonatomic) CGFloat sectionSegmentedControlCornerRadius;
@property (strong, nonatomic) UIColor *currentSectionBackgroundColor;
@property (strong, nonatomic) UIColor *currentSectionTextColor;
@property (strong, nonatomic) UIColor *sectionSegmentedTextColor;

// solid button
@property (strong, nonatomic) UIColor *solidButtonDisabledBackgroundColor;
@property (strong, nonatomic) UIColor *solidButtonDisabledTitleColor;
@property (assign, nonatomic) CGFloat buttonCornerRadius;

// bordered button 带有边框，蓝色的按钮
@property (strong, nonatomic) UIColor *borderedButtonBorderColor;
@property (assign, nonatomic) CGFloat borderedButtonBorderCornerRadius;
@property (assign, nonatomic) CGFloat borderedButtonBorderWidth;
@property (strong, nonatomic) UIColor *borderedButtonTitleColor;
@property (strong, nonatomic) UIColor *borderedButtonHighlightedBackgroundColor;


// default placeholder
@property (strong, nonatomic) UIColor *defaultPlaceholderBlackBackgroundColor;
@property (strong, nonatomic) UIColor *defaultPlaceholderBlackForegroundColor;
@property (strong, nonatomic) UIColor *defaultPlaceholderLightBackgroundColor;
@property (strong, nonatomic) UIColor *defaultPlaceholderLightForegroundColor;

@property (strong, nonatomic) UIColor *navigationBackArrowColor;

@property (strong, nonatomic) UIColor *tabBarSelectedTextColor;
@property (strong, nonatomic) UIColor *tabBarBackgroundColor;
@property (strong, nonatomic) UIColor *tabBarTextColor;
@property (strong, nonatomic) UIColor *tabBarShadowColor;

/**
 * @guangfu yang 16-1-29
 * 针对趣课堂按钮
 **/
@property (nonatomic, strong) UIColor *courseBtnOfSignUp;//报名 进入课堂
@property (nonatomic, strong) UIColor *courseBtnOfWait;//等待上课
@property (nonatomic, strong) UIColor *courseBtnOfTimeOver;//结束报名

/**
 *  #2ea457
 */
//@property (strong, nonatomic) UIColor *greenButtonColor;


/**
 *  #89ca30 品牌色，用于主要icon,button和链接文字
 */
@property(strong, nonatomic) UIColor *color_1;

/**
 *  #1a8e1a 用于品牌色button的点击效果
 */
@property(strong, nonatomic) UIColor *color_2;

/**
 *  #333333 用于重要文字(标题，名称等)
 */
@property(strong, nonatomic) UIColor *color_3;

/**
 *  #888888 用于普通文字（辅助信息等）；链接文字不可点击效果，次要icon
 */
@property(strong, nonatomic) UIColor *color_4;

/**
 *  #cbcbcb 用于分隔线;列表点击效果，提示文字 button不可点击效果
 */
@property(strong, nonatomic) UIColor *color_5;

/**
 *  #efefef 背景色
 */
@property(strong, nonatomic) UIColor *color_6;

/**
 *  #f8f8f8 navbar和bottombar的背景
 */
@property(strong, nonatomic) UIColor *color_7;

/**
 *  #fc504d 提示红点&重要信息
 */
@property(strong, nonatomic) UIColor *color_8;

/**
 *  #ec6a00 次要信息
 */
@property(strong, nonatomic) UIColor *color_9;

/**
 *  趣课堂主题色
 */
@property (strong, nonatomic) UIColor *funClassMainColor;
/**
 *  趣课堂背景色
 */

/*
 * 趣课堂按钮的颜色
 *
 */
@property (strong, nonatomic ) UIColor *funClassRedBtnColor;

@end
