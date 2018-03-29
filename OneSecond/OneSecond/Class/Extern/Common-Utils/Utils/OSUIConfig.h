//
//  PIRConfig.h
//  OneSecond
//
//  Created by JHR on 15/10/17.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSDevice.h"

#ifndef OSUIConfig_h
#define OSUIConfig_h

/**
 * 全局控制按钮高度和文字字体大小
 */
#pragma mark -------- 文字的大小 ------------------------
#pragma mark - 重要 -

// ([OSDevice isDeviceIPhone6Plus] ? 18 : 18)

#define ButtonNavFontSize    18     // 用在少数的重要标题、重要操作按钮等（如导航栏，按钮等）

#define TableTitleFontSize   16     // 粗体，用在列表类标题、tab标题(如银行列表、inbox标题)
#define HighlightFontSize    22     // 用于一些需要突出的文字或较为重要的的内容文字
#define TableTextFontSize    18     //  用在列表类内容上的字体
//
//#pragma mark - 一般 -
//
#define AuxiliaryFontSize    12     // 用于辅助性文字(如申请信用review info上面的小标题)
#define ExplanatoryFontSize  15     // 用于大多数内容个文字，说明性文字
//
#define HighlightMoneyFontSzie  28  // 粗体，用于需要强调的金额类文字
#define HighlightNumberFontSize 50  // 粗体，用于需要强调的数字，通常页面没有其他内容
//
//#pragma mark ------- 按钮的高度 ------------------------
//
//#define  BottomButtonHeight ([PIRDevice isDeviceIPhone6Plus] ? 60 : 60)   // 吸附在页面底部或者键盘上方的按钮
//#define  GeneralButtonHight 50                                            // 一般按钮，在页面内容的下方，圆角，不贯通页面
//#define  GeneralButtonCornerRadius  5                                     // 圆角半径
//#define  GeneralButtonBorderWidth   1.5                                   // 描边大小
//
//#pragma mark -------  TableView的高度 ----------------------------
//
//#define GeneralListHeight  60                // 普通列表，通常只有一行内容，如balance，profile，purchase，statement页面等
//#define SpecialListHeight  70                // 通常有两行内容的，有用线条区隔的或者留白区隔，如contacts，review info，make payment等
//#define MinoListHeight     90.0f
//
//#define OtherListHeight    80                // 例如bank list当
//
//#define GeneralLabelHeight  50               // 普通显示文字的的Label高度
//
//#define GeneralListSectionHeight  25         // 普通tableView的Section高度
//
//#pragma mark ------ 按钮不可用时titleLabel的alpha值 ----------------
//
//#define ButtonTitleAlpha  0.3
//
//#pragma mark -------------------- 其他 ---------------------------
//
//#define TextFieldFitHeight  ([PIRDevice isDeviceIPhone5] ? 40 : 50) // 适配用，透明textField或者label可以使用
//
//#pragma mark -------------------- 文字间距 -------------------------
//
//#define TextLineSpacing  5.0f
//#define TextMinimumScale 0.8f    // 字体缩小比例
#endif
