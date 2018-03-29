//
//  JTCalendarDayView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarDayView.h"
#import "JTCalendarManager.h"
#import "OSFont.h"

@implementation JTCalendarDayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    {
        _circleView = [UIView new];
        _screenImageView = [[UIImageView alloc] init];
        _textLabel = [UILabel new];
    }

    self.clipsToBounds = YES;
    
    _circleRatio = .9;
    _dotRatio = 1. / 9.;
    
    {
        [self addSubview:_circleView];
        
        _circleView.backgroundColor = [OSColor skyBlueColor];
        _circleView.hidden = YES;

        _circleView.layer.masksToBounds = YES;
        _circleView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _circleView.layer.shouldRasterize = YES;
//        _circleView.layer.borderColor = [OSColor pureDarkColor].CGColor;
//        _circleView.layer.borderWidth = 1.f;
    }
    
    {
        [_circleView addSubview:_screenImageView];
    }
    
    {
        [self addSubview:_textLabel];
        
//        _textLabel.textColor = [UIColor blackColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
//        _textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        _textLabel.font = [OSFont nextDayFontWithSize:ExplanatoryFontSize];
    }
    
    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch)];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:gesture];
    }
}

- (void)layoutSubviews
{
    _textLabel.frame = self.bounds;
    
    CGFloat sizeCircle = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat sizeDot = sizeCircle;
    
    sizeCircle = sizeCircle * _circleRatio;
    sizeDot = sizeDot * _dotRatio;
    
    sizeCircle = roundf(sizeCircle);
    sizeDot = roundf(sizeDot);
    
    _circleView.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
    _circleView.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
    _circleView.layer.cornerRadius = sizeCircle/2;
    
    _screenImageView.frame =  CGRectMake(0, 0, sizeCircle, sizeCircle);
}

- (void)setDate:(NSDate *)date
{
    NSAssert(date != nil, @"date cannot be nil");
    NSAssert(_manager != nil, @"manager cannot be nil");
    
    self->_date = date;
    [self reload];
}

- (void)reload
{
    static NSDateFormatter *dateFormatter = nil;
    if(!dateFormatter){
        dateFormatter = [_manager.dateHelper createDateFormatter];
        [dateFormatter setDateFormat:@"dd"];
    }
    
    _textLabel.text = [dateFormatter stringFromDate:_date];
        
    [_manager.delegateManager prepareDayView:self];
}

- (void)didTouch
{
    [_manager.delegateManager didTouchDayView:self];
}

@end
