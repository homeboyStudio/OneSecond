//
//  OSFont.m
//  OneSecond
//
//  Created by JunhuaRao on 2020/07/01.
//  Copyright © 2020年 com.homeboy. All rights reserved.
//

#import "OSFont.h"

//#define CUSTOM_FONTNAME         @"ProximaNova-Light"
//#define CUSTOM_FONTNAME_BOLD    @"ProximaNova-Regular"

/** Avenir*/
//#define CUSTOM_FONTNAME         @"Avenir"
//#define CUSTOM_FONTNAME_BOLD    @"Avenir-Heavy"

/** zendesk字体*/
//#define CUSTOM_FONTNAME         @"Whitney-Book"
//#define CUSTOM_FONTNAME_BOLD    @"Whitney-Medium"

/** 系统字体*/
//#define CUSTOM_FONTNAME         @"San Francisco"
//#define CUSTOM_FONTNAME_BOLD    @"San Francisco-Bold"
//#define NUMBER_FONTNAME         @"San Francisco"

/** NextDay字体 */     //  Avenir Next  AvenirNextW01ThinRegular
#define CUSTOM_FONTNAME         @"Avenir Next"
#define CUSTOM_FONTNAME_BOLD    @"AvenirNext-UltraLight"
#define NUMBER_FONTNAME         @"Avenir Next"

// AvenirNext-UltraLight   AvenirNextW01ThinRegular

/** 杂志字体*/
//#define CUSTOM_FONTNAME         @"Geomanist-Regular"
//#define CUSTOM_FONTNAME_BOLD    @"Geomanist-Regular"

/** Robinhood字体 */
//#define CUSTOM_FONTNAME         @"DINPro-Regular"
//#define CUSTOM_FONTNAME_BOLD    @"DINPro-Medium"

/** Airbnb字体 */
//#define CUSTOM_FONTNAME         @"CircularAir-Book"
//#define CUSTOM_FONTNAME_BOLD    @"CircularAir-Bold"

@implementation OSFont

+ (UIFont *)navigationBarTitleFont
{
//    static UIFont *sNavigationBarTitleFont;
//    return [self fontWithCache:sNavigationBarTitleFont
//                          name:CUSTOM_FONTNAME
//                          size:ButtonNavFontSize];
    return [OSFont nextDayFontWithSize:ButtonNavFontSize];
}

+ (UIFont *)customFontWithSize:(CGFloat)size
{
//    static UIFont *sCustomFont;
//    return [self fontWithCache:sCustomFont
//                          name:CUSTOM_FONTNAME
//                          size:size];
    return [OSFont nextDayFontWithSize:size];
}

+ (UIFont *)customBoldFontWithSize:(CGFloat)size
{
//    static UIFont *sCustomFont;
//    return [self fontWithCache:sCustomFont
//                          name:CUSTOM_FONTNAME_BOLD
//                          size:size];
    return [UIFont boldSystemFontOfSize:size];
}

+ (UIFont *)customNumberFontWithSize:(CGFloat)size
{
//    static UIFont *sCustomFont;
//    return [self fontWithCache:sCustomFont
//                          name:NUMBER_FONTNAME
//                          size:size];
    return [UIFont systemFontOfSize:size];
}

#pragma mark -------------- NextDay Font --------------------

+ (UIFont *)nextDayThinFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:CUSTOM_FONTNAME_BOLD size:size];
}

+ (UIFont *)nextDayFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:CUSTOM_FONTNAME size:size];
}

#pragma mark - Private
/*!
 *  Create or reuse a font
 *
 *  @param cachedFont Static variable for caching.
 *  @param name Name of the font.
 *  @param size Size of the font.
 *
 *  @return The font.
 */
+ (UIFont *)fontWithCache:(UIFont *)cachedFont
                     name:(NSString *)name
                     size:(CGFloat)size
{
    if (!cachedFont) {
        
//        for(NSString *fontfamilyname in [UIFont familyNames])
//        {
//            DLog(@"family:'%@'",fontfamilyname);
//            for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
//            {
//                DLog(@"\tfont:'%@'",fontName);
//            }
//            DLog(@"-------------");
//        }
        
//        cachedFont = [UIFont fontWithName:name size:size];
        cachedFont = [UIFont systemFontOfSize:size];
    }
    
    // Font family
    //    NSArray *familyNames =[[NSArray alloc]initWithArray:[UIFont familyNames]];
    //    NSArray *fontNames;
    //    NSInteger indFamily, indFont;
    //    DLog(@"[familyNames count]===%d",[familyNames count]);
    //    for(indFamily=0;indFamily<[familyNames count];++indFamily) {
    //        DLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
    //        fontNames =[[NSArray alloc]initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
    //
    //        for(indFont=0; indFont<[fontNames count]; ++indFont) {
    //            DLog(@"Font name: %@",[fontNames objectAtIndex:indFont]);
    //        }
    //    }
    return cachedFont;
}

@end
