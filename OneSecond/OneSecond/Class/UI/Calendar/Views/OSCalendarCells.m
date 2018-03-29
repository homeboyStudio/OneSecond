//
//  OSCalendarCells.m
//  OneSecond
//
//  Created by JunhuaRao on 15/11/2.
//  Copyright © 2015年 com.homeboy. All rights reserved.
//

#import "OSCalendarCells.h"
#import "JTCalendar.h"
#import "OSDateUtil.h"
#import "NSString+Check.h"
#import "THLabel.h"

@implementation OSCalendarModel

@end

@implementation OSCalendarCells

- (void)updateCell:(OSCalendarModel *)model index:(NSIndexPath *)indexPath
{

}

// 禁止高亮状态和选中状态
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:NO animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:animated];
}

@end


@interface OSCalendarHeaderCell()

@property (nonatomic, weak) IBOutlet THLabel *dateLabel;

@end

@implementation OSCalendarHeaderCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 初始化
//    [_dateLabel setTextColor:[OSColor pureWhiteColor]];
    [_dateLabel setFont:[OSFont nextDayFontWithSize:HighlightFontSize]];
    [_dateLabel setText:[OSDateUtil getMonthAndYearStringWithDate:[OSDateUtil getStringDate:[OSDateUtil getCurrentDate] formatType:SIMPLEFORMATTYPE6]]];
    _dateLabel.shadowColor = [OSColor colorFromHex:@"#000000" alpha:0.4];
    _dateLabel.shadowOffset = CGSizeMake(0.5, 1.3);
    _dateLabel.shadowBlur = 2.0f;
}

- (void)updateDateWith:(NSString *)month
{
    [_dateLabel setText:month];
    //  更新动画
    _dateLabel.alpha = 0;
    [UIView animateWithDuration:.6 animations:^{
        _dateLabel.alpha = 1;
    } completion:^(BOOL finished) {

    }];
}

- (void)setLabelAlpha:(CGFloat)degree
{
    [_dateLabel setAlpha:degree];
}

- (void)updateCell:(OSCalendarModel *)model index:(NSIndexPath *)indexPath
{
    
}

@end



@interface OSCalendarDateCell()<JTCalendarDelegate>
{
    NSDictionary *_eventsByDate;
    
    NSDate *_dateSelected;   // 选择的时间
    NSDate *_todayDate;      // 本机时间
    NSDate *_minDate;
    NSDate *_maxDate;
}

@property (nonatomic, weak) IBOutlet JTHorizontalCalendarView *calendarContentView;  //  显示日期

@property (nonatomic, strong) JTCalendarManager *calendarManager;
@property (nonatomic, weak) IBOutlet UIButton *backButton;     // 回到今天
@property (nonatomic, weak) IBOutlet UIButton *homeButton;     // 返回菜单
@property (nonatomic, weak) IBOutlet UIButton *playButton;     // 播放按钮

@property (nonatomic, weak) IBOutlet UILabel *homeLabel;
@property (nonatomic, weak) IBOutlet UILabel *playLabel;
@property (nonatomic, weak) IBOutlet UILabel *backLabel;

@end

@implementation OSCalendarDateCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_homeLabel setTextColor:[OSColor specialGaryColor]];
    [_homeLabel setFont:[OSFont nextDayFontWithSize:AuxiliaryFontSize]];
    
    [_playLabel setTextColor:[OSColor specialGaryColor]];
    [_playLabel setFont:[OSFont nextDayFontWithSize:AuxiliaryFontSize]];
    
    [_backLabel setTextColor:[OSColor specialGaryColor]];
    [_backLabel setFont:[OSFont nextDayFontWithSize:AuxiliaryFontSize]];
    
//    self.contentView.backgroundColor = [OSColor skyBlueColor];
    _calendarManager = [[JTCalendarManager alloc] init];
    _calendarManager.delegate = self;
    
    // Generate random events sort by date using a dateformatter for the demonstration
//    [self createRandomEvents];
    
    // Create a min and max date for limit the calendar, optional
    [self createMinAndMaxDate];
    
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];
}

- (void)updateCell:(OSCalendarModel *)model index:(NSIndexPath *)indexPath
{
    _eventsByDate = model.dateModelDic;
    [_calendarManager reload];
}

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    // 如果日期View来自显示月份的其他月则隐藏
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }else {
        dayView.hidden = NO;

      // Another day of the current month
        NSString *key = [OSDateUtil getStringDate:dayView.date formatType:SIMPLEFORMATTYPE6];
        
        if ([[_eventsByDate allKeys] containsObject:key]) {
            // 设置image
            if (dayView.screenImageView.image == nil) {
                OSDateModel *dateModel = [_eventsByDate objectForKey:key];
                
                if (![NSString emptyOrNull:dateModel.image_url]) {
                    // 耗时操作
                    // 子线程加载图片
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[OSFileUtil getFilePathURLWithDocument:dateModel.image_url]]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [dayView.screenImageView setImage:image];
                        });
                    });
                }
            }
            dayView.userInteractionEnabled = YES;
            dayView.circleView.hidden = NO;
            dayView.textLabel.textColor = [OSColor pureWhiteColor];
        }else {
            // 今天的日期
            if([_calendarManager.dateHelper date:_todayDate isTheSameDayThan:dayView.date]){
                dayView.circleView.hidden = NO;
                dayView.circleView.backgroundColor = [OSColor skyBlueColor];
                dayView.textLabel.textColor = [OSColor pureWhiteColor];
                dayView.userInteractionEnabled = NO;
            }else {
                dayView.circleView.hidden = YES;
                dayView.textLabel.textColor = [OSColor pureDarkColor];
                dayView.userInteractionEnabled = NO;
            }
        }
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
   NSString *key = [OSDateUtil getStringDate:dayView.date formatType:SIMPLEFORMATTYPE6];
    
    // 通知代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedEventDayWithDateModel:)]) {
        [self.delegate didSelectedEventDayWithDateModel:[_eventsByDate objectForKey:key]];
    }
    
    
    // Animation for the circleView
//    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
//    [UIView transitionWithView:dayView
//                      duration:.3
//                       options:0
//                    animations:^{
//                        dayView.circleView.transform = CGAffineTransformIdentity;
//                        [_calendarManager reload];
//                    } completion:nil];
    
    
    // Load the previous or next page if touch a day from another month
    
//    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
//        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
//            [_calendarContentView loadNextPageWithAnimation];
//        }
//        else{
//            [_calendarContentView loadPreviousPageWithAnimation];
//        }
//    }
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSlideCalendarChangeWithDate:)]) {
        [self.delegate didSlideCalendarChangeWithDate:calendar.contentView.date];
    }
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSlideCalendarChangeWithDate:)]) {
        [self.delegate didSlideCalendarChangeWithDate:calendar.contentView.date];
    }
}

#pragma mark - Fake data

- (void)createMinAndMaxDate
{
    _todayDate = [OSDateUtil getCurrentDate];
    
    // Min date will be 2 month before today
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-36];
    
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:12];
}

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
//        dateFormatter.dateFormat = @"dd-MM-yyyy";
        dateFormatter.dateFormat = @"yyyyMMdd";
    }
    
    return dateFormatter;
}

#pragma mark ------------ 按钮事件 ------------
- (IBAction)homeButtonAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickBackHomeButtonAction)]) {
        [self.delegate didClickBackHomeButtonAction];
    }
}

- (IBAction)playButtonAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPlayMovieButtonAction)]) {
        [self.delegate didClickPlayMovieButtonAction];
    }
}

- (IBAction)backTodayButtonAction:(UIButton *)sender
{
    [_calendarManager setDate:_todayDate];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickBackTodayButtonActionWithDate:)]) {
        [self.delegate didClickBackTodayButtonActionWithDate:_todayDate];
    }
}

@end
