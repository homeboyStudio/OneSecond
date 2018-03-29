//
//  OSColor.m
//  OneSecond
//
//  Created by JHR on 15/10/17.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSColor.h"

#pragma mark - Indicator shades

#define OSCOLORALPHA(name, hexValue, alphaValue) \
+ (UIColor *)name {\
return [self colorFromHex:hexValue alpha:alphaValue];\
}

#define OSCOLOR(name, hex) OSCOLORALPHA(name, hex, 1.0)

#define OSCOLORALIAS(alias, paletteName)\
+ (UIColor *)alias {\
return [self paletteName];\
}


@implementation OSColor

OSCOLOR(mintGreenColor, @"12CFA5");
OSCOLOR(skyBlueColor, @"49C6D8");     // NEXTDAY COLOR
OSCOLOR(specialGaryColor, @"707180");
OSCOLOR(specialorangColor, @"FF7152");  // FF7152  E04800
OSCOLOR(loveColor, @"C8C1B9");

OSCOLOR(specialRedColor, @"FF0D59");
OSCOLOR(grayDarkColor, @"191919");
OSCOLOR(pureWhiteColor, @"ffffff");
OSCOLOR(pureDarkColor, @"000000");
OSCOLOR(nextDayGaryColor, @"ACABAC");

OSCOLOR(navigationBarTitleColor, @"000000");

OSCOLOR(titleTextColor, @"ffffff");
OSCOLOR(detailTextColor, @"646464");

OSCOLOR(defaultBackgroundColor, @"f5f5f5");

OSCOLOR(navigationBarBackgroundColor, @"ffffff");


OSCOLOR(darkGreenColor, @"37d6cf");
OSCOLOR(lightGreenColor, @"86eaeb");

OSCOLOR(redColor, @"f34949");

OSCOLOR(specialDarkColor, @"36414D");


OSCOLOR(placeholderTextColor, @"c8c8c8");
OSCOLOR(lineColor, @"c8c8c8");

OSCOLOR(tableTitleTextColor, @"646464")  //  用于列表类的标题，或一些说明性的内容文字

#pragma mark - Private

+ (UIColor *)colorFromHex:(NSString *)hexValue alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[hexValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

#pragma mark ---------------------获得10种渐变颜色---------------------------------
static  NSMutableArray * __colorArray = nil;
+ (NSMutableArray *)getGrandColor
{
    if (__colorArray == nil) {
        __colorArray = [[NSMutableArray alloc] init];
        UIColor * color1 =   [UIColor colorWithRed:254/255.0f green:67/255.0f blue:102/255.0f alpha:1.0];
        UIColor * color2 =   [UIColor colorWithRed:251/255.0f green:158/255.0f blue:155/255.0f alpha:1.0];
        UIColor * color3 =   [UIColor colorWithRed:250/255.0f green:205/255.0f blue:176/255.0f alpha:1.0];
        UIColor * color4 =   [UIColor colorWithRed:244/255.0f green:210/255.0f blue:142/255.0f alpha:1.0];
        UIColor * color5 =   [UIColor colorWithRed:238/255.0f green:230/255.0f blue:145/255.0f alpha:1.0];
        UIColor * color6 =   [UIColor colorWithRed:201/255.0f green:201/255.0f blue:169/255.0f alpha:1.0];
        UIColor * color7 =   [UIColor colorWithRed:132/255.0f green:175/255.0f blue:155/255.0f alpha:1.0];
        UIColor * color8 =   [UIColor colorWithRed:101/255.0f green:170/255.0f blue:193/255.0f alpha:1.0];
        UIColor * color9 =   [UIColor colorWithRed:102/255.0f green:148/255.0f blue:216/255.0f alpha:1.0];
        UIColor * color10 =  [UIColor colorWithRed:158/255.0f green:143/255.0f blue:195/255.0f alpha:1.0];
        [__colorArray addObject:color1];
        [__colorArray addObject:color2];
        [__colorArray addObject:color3];
        [__colorArray addObject:color4];
        [__colorArray addObject:color5];
        [__colorArray addObject:color6];
        [__colorArray addObject:color7];
        [__colorArray addObject:color8];
        [__colorArray addObject:color9];
        [__colorArray addObject:color10];
    }
    
    return __colorArray;
}

+ (NSMutableArray *)getGrandColor:(int)count
{
    if (count < 10) {
        return [OSColor getGrandColor];
    }else{
        NSMutableArray *colorArray_count = [[NSMutableArray alloc] init];
        for (int i = 0; i < count; i ++) {
            if (i < 10) {
                [colorArray_count addObject:[[OSColor getGrandColor] objectAtIndex:i]];
            }else{
                int R_r = (arc4random() % 255) + 0;
                int G_r = (arc4random() % 255) + 0;
                int B_r = (arc4random() % 255) + 0;
                UIColor * color =   [UIColor colorWithRed:R_r/255.0f green:G_r/255.0f blue:B_r/255.0f alpha:1.0];
                [colorArray_count addObject:color];
            }
        }
        return colorArray_count;
    }
    
}

+ (UIColor *)deepPlaceholderTextColor
{
    return [[UIColor alloc] initWithWhite:1.0f alpha:0.3f];
}

/**
 *   用在深色按钮高亮状态下面的text颜色
 */
+ (UIColor *)buttonSelectedTextColor
{
    return [[UIColor alloc] initWithWhite:1.0f alpha:0.3f];
}

/**
 *  灰色文字颜色 alpha 0.3
 *  #9463b5
 */
+ (UIColor *)grayColor
{
    return OSColorHex(0x9463b5);
}

@end
