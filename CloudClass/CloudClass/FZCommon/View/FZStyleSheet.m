//
//  FZStyleSheet.m
//
//
//  Created by CyonLeuPro on 15/6/15.
//
//

#import "FZStyleSheet.h"


@implementation NIEStyleSheetDummyObject

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.firstHelper respondsToSelector:aSelector]) {
        return self.firstHelper;
    } else if ([self.secondHelper respondsToSelector:aSelector]) {
        return self.secondHelper;
    } else {
        return [super forwardingTargetForSelector:aSelector];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [self.firstHelper respondsToSelector:aSelector] || [self.secondHelper respondsToSelector:aSelector] || [super respondsToSelector:aSelector];
}

@end

@implementation FZStyleSheet

+ (instancetype)defaultStyleSheet {
    static dispatch_once_t DispatchOnce;
    static NSMutableDictionary *StyleSheets;
    dispatch_once(&DispatchOnce, ^{
        StyleSheets = [NSMutableDictionary dictionary];
    });
    @synchronized(self) {
        if (![StyleSheets objectForKey:self]) {
            NIEStyleSheetDummyObject *dummy = [[NIEStyleSheetDummyObject alloc] init];
            if ([[self superclass] respondsToSelector:@selector(defaultStyleSheet)]) {
                dummy.firstHelper = [[self superclass] defaultStyleSheet];
            } else {
                dummy.firstHelper = nil;
            }
            dummy.secondHelper = [[self alloc] init];
            [StyleSheets setObject:dummy forKey:(id<NSCopying>)self];
        }
    }
    return StyleSheets[self];
}

+ (instancetype)currentStyleSheet {
    return [self defaultStyleSheet];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.colorOfMainTint = [UIColor colorWithHex:0x89ca30];
        self.colorOfOrange = [UIColor colorWithHex:0xfc504d];
        self.colorOfNavigationBackground = [UIColor colorWithHex:0xf8f8f8 withAlpha:0.97];
        
        self.colorOfBackground = [UIColor colorWithHex:0xefefef];
        self.colorOfSectionTitleBackground = [UIColor colorWithHex:0xE5E6E8];
        self.colorOfListOrCardBackground = [UIColor colorWithHex:0xFAFAFA];
        
        self.colorOfListTitle = [UIColor colorWithHex:0x333333];
        self.colorOfListSubtitle = [UIColor colorWithHex:0x888888];
        
        self.colorOfHighlightedSectionHeader = [UIColor colorWithHex:0xCCCCCC withAlpha:0.6];
        //        self.colorOfSeperatorOnDarkBackground = [[UIColor whiteColor] colorWithAlphaComponent:0.1f];;
        self.colorOfSeperatorOnLightBackground = [UIColor colorWithHex:0xd6d6d6];
        
        self.colorOfLighterText = [UIColor whiteColor];
        self.colorOfLessLightText = [[UIColor whiteColor] colorWithAlphaComponent:0.3f];
        self.colorOfLightText = [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
        
        self.colorOfDarkerText = [UIColor colorWithHex:0x101317];
        self.colorOfDarkText = [[UIColor colorWithHex:0x101317] colorWithAlphaComponent:0.6f];
        self.colorOfLessDarkText = [[UIColor colorWithHex:0x101317] colorWithAlphaComponent:0.3f];
        
        self.colorOfGreenButtonNormal = [UIColor colorWithHex:0x89ca30];
        self.colorOfGreenButtonHightlighted = [UIColor colorWithHex:0x18ba6e];
        self.colorOfBlueButtonHightlighted = [UIColor colorWithHex:0x84d4b1];
        self.colorOfGreenButtonDisabled = [UIColor colorWithHex:0xcbcbcb];
        self.colorOfCode = [UIColor colorWithHex:0xd2d2d4];
        
        self.colorOfBlackMask = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        
        self.lengthOfGlobalLeftRightMargin = P2P(32.0f);
        self.fontOfH1 = [UIFont systemFontOfSize:P2P(38.0f)];
        self.fontOfH2 = [UIFont systemFontOfSize:P2P(34.0f)];
        self.fontOfH3 = [UIFont systemFontOfSize:P2P(28.0f)];
        self.fontOfH4 = [UIFont systemFontOfSize:P2P(24.0f)];
        self.fontOfH5 = [UIFont systemFontOfSize:P2P(22.0f)];
        self.fontOfH6 = [UIFont systemFontOfSize:P2P(20.0f)];
        self.fontOfH7 = [UIFont systemFontOfSize:P2P(32.0f)];
        self.fontOfH8 = [UIFont systemFontOfSize:P2P(30.0f)];
        
        self.fontOfBoldH1 = [UIFont boldSystemFontOfSize:P2P(38.0f)];
        self.fontOfBoldH2 = [UIFont boldSystemFontOfSize:P2P(34.0f)];
        self.fontOfBoldH3 = [UIFont boldSystemFontOfSize:P2P(28.0f)];
        self.fontOfBoldH4 = [UIFont boldSystemFontOfSize:P2P(24.0f)];
        self.fontOfBoldH5 = [UIFont boldSystemFontOfSize:P2P(22.0f)];
        self.fontOfBoldH6 = [UIFont boldSystemFontOfSize:P2P(20.0f)];
        self.fontOfBoldH7 = [UIFont boldSystemFontOfSize:P2P(32.0f)];
        
        self.lengthOfRoundedLabelCornerRadius = P2PSZ(16.0f);
        
        self.textFieldHeight = P2PSZ(80.0f);
        self.textFieldPadding = UIEdgeInsetsMake(P2PSZ(16.0f), 0.0f, P2PSZ(16.0f), 0.0f);
        
        self.currentSectionBackgroundColor = [UIColor whiteColor];
        self.currentSectionTextColor = [UIColor blackColor];
        self.sectionSegmentedTextColor = [UIColor whiteColor];
        
        self.textFieldUnderlineWidth = P2PSZ(4.0f);
        
        self.sectionSegmentedControlSize = CGSizeMake(P2PSZ(468.0f), P2PSZ(66.0f));
        self.sectionSegmentedControlCornerRadius = P2PSZ(8.0f);
        
        self.solidButtonDisabledBackgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        self.solidButtonDisabledTitleColor = [self.colorOfDarkText colorWithAlphaComponent:0.2];
        self.buttonCornerRadius = P2P(8.0f);
        
        self.defaultPlaceholderBlackBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1f];
        self.defaultPlaceholderBlackForegroundColor = [[UIColor colorWithHex:0x9B9B9B] colorWithAlphaComponent:0.4f];
        self.defaultPlaceholderLightBackgroundColor = [UIColor colorWithHex:0xE6E6E6];
        self.defaultPlaceholderLightForegroundColor = [UIColor colorWithHex:0xD1D1D1];
        
        self.borderedButtonTitleColor = [UIColor colorWithHex:0x2ba4e2];
        self.borderedButtonBorderColor = [UIColor colorWithHex:0x2ba4e2 withAlpha:0.3];
        self.borderedButtonBorderCornerRadius = 4;
        self.borderedButtonBorderWidth = 1;
        self.borderedButtonHighlightedBackgroundColor = self.borderedButtonBorderColor;
        self.lengthOf1px = 1.0f / [UIScreen mainScreen].scale;
        
        self.navigationBackArrowColor = [UIColor whiteColor];
        self.tabBarTextColor = [UIColor colorWithHex:0x70788c];
        self.tabBarSelectedTextColor = [UIColor colorWithHex:0x18ba6e];
        self.tabBarBackgroundColor = [UIColor colorWithHex:0xFFFFFF withAlpha:1];
        self.tabBarShadowColor = [UIColor colorWithHex:0xd6d6d6];
        
        self.colorOfWhiteMask = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        
        self.color_1 = [UIColor colorWithHex:0x89ca30];
        self.color_2 = [UIColor colorWithHex:0x89ca30];
        self.color_3 = [UIColor colorWithHex:0x333333];
        self.color_4 = [UIColor colorWithHex:0x888888];
        self.color_5 = [UIColor colorWithHex:0xcbcbcb];
        self.color_6 = [UIColor colorWithHex:0xefefef];
        self.color_7 = [UIColor colorWithHex:0xf8f8f8];
        self.color_8 = [UIColor colorWithHex:0xfc504d];
        self.color_9 = [UIColor colorWithHex:0xec6a00];
        
        self.colorLine = [UIColor colorWithHex:0xebebeb];
        
        /**
         * @guangfu yang 16-1-29
         * 针对趣课堂按钮
         **/
        
        self.courseBtnOfSignUp = [UIColor colorWithHex:0x18ba6e];
        self.courseBtnOfWait = [UIColor colorWithHex:0xffb42d];
        self.courseBtnOfTimeOver = [UIColor colorWithHex:0x888888];
        
        self.funClassMainColor  = [UIColor colorWithHex:0x18ba6e];
        self.funClassRedBtnColor = [UIColor colorWithHex:0xff6b00];
    }
    return self;
}

@end
