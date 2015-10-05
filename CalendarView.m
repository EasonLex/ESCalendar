//
//  CalendarView.m
//  ihergoApp
//
//  Created by motephyr on 2015/6/22.
//  Copyright (c) 2015年 ihergo. All rights reserved.
//

#import "CalendarView.h"
@interface CalendarView ()
{
    UILabel *selectedMonthLabel;
    UIButton *dayButton[42];
    NSDate *baseDate;
    NSDate *today;
    NSInteger baseDayCount;
    NSMutableArray *dateArray;

}
@end

@implementation CalendarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    //    CalendarView *calendarView = [[CalendarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 20, 147.5+6*(buttonWidth+2)+2)];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        
        NSInteger buttonWidth = (self.frame.size.width - (48+12))/7;
        
        UIView *roundBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 20, 147.5+6*(buttonWidth+2)+2)];
        [roundBackground setCenter:self.center];
        [roundBackground setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1]];
        [roundBackground.layer setCornerRadius:10];
        [self addSubview:roundBackground];
        
        UIView *headDateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 62)];
        [headDateView setBackgroundColor:[UIColor clearColor]];
        
        UIButton *prevButton = [[UIButton alloc] initWithFrame:CGRectMake(14, 10, 39, 42)];
        [prevButton setTag:1];
        [prevButton setBackgroundImage:[UIImage imageNamed:@"month_prev"] forState:UIControlStateNormal];
        [prevButton addTarget:self action:@selector(monthSelect:) forControlEvents:UIControlEventTouchUpInside];
        [headDateView addSubview:prevButton];
        
        UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(roundBackground.frame.size.width - (14+39), 10, 39, 42)];
        [nextButton setTag:2];
        [nextButton setBackgroundImage:[UIImage imageNamed:@"month_next"] forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(monthSelect:) forControlEvents:UIControlEventTouchUpInside];
        [headDateView addSubview:nextButton];
        
        selectedMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 10, roundBackground.frame.size.width - 106, 42)];
        [selectedMonthLabel setTextColor:[UIColor colorWithString:@"#4B4B4B"]];
        [selectedMonthLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [selectedMonthLabel setTextAlignment:NSTextAlignmentCenter];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy 年 MM 月"];
        [selectedMonthLabel setText:[dateFormatter stringFromDate:[NSDate date]]];
        [headDateView addSubview:selectedMonthLabel];
        
        [roundBackground addSubview:headDateView];
        
        // Get base date
        NSCalendar *todayCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *todayComp = [todayCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
        [todayComp setHour:0];
        [todayComp setMinute:0];
        [todayComp setSecond:0];
        today = [todayCalendar dateFromComponents:todayComp];
//        if (!self.selectedDay) {
//            self.selectedDay = [todayCalendar dateFromComponents:todayComp];
//        }
        
        [todayComp setDay:1];
        baseDate = [todayCalendar dateFromComponents:todayComp];
        
        NSRange baseDayRange = [todayCalendar rangeOfUnit:NSCalendarUnitDay
                                                   inUnit:NSCalendarUnitMonth
                                                  forDate:[todayCalendar dateFromComponents:todayComp]];
        baseDayCount = baseDayRange.length;

        UIView *whiteBackground = [[UIView alloc] initWithFrame:CGRectMake(10, headDateView.frame.origin.y + headDateView.frame.size.height, roundBackground.frame.size.width - 20, roundBackground.frame.size.height - 122 + 2)];
        [whiteBackground setBackgroundColor:[UIColor whiteColor]];
        [roundBackground addSubview:whiteBackground];
        
        buttonWidth = (whiteBackground.frame.size.width - (2*6 + 4*2))/7;
        
        for (int i = 0; i < 42; i++) {
            NSInteger xCount = i % 7;
            NSInteger yCount = i / 7;
            dayButton[i] = [[UIButton alloc] initWithFrame:CGRectMake(4 + (buttonWidth+2)*xCount, 25.5 + (buttonWidth+2)*yCount, buttonWidth, buttonWidth)];
//            [dayButton[i] setTitleEdgeInsets:UIEdgeInsetsMake(-6, 0, 0, 0)];
            [dayButton[i] setTag:i];
            [dayButton[i] addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventTouchUpInside];
            [whiteBackground addSubview:dayButton[i]];
        }

        [self fillUpDayButton];
        
        for (int i = 0; i < 7; i++) {
            UILabel *weekDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(4 + (buttonWidth+2)*i, 0, buttonWidth, 25.5)];
            [weekDayLabel setTextAlignment:NSTextAlignmentCenter];
            [weekDayLabel setFont:[UIFont systemFontOfSize:12]];
            if (i == 0) {
                [weekDayLabel setTextColor:[UIColor colorWithString:@"#CB4646"]];
            }
            else if(i == 6){
                [weekDayLabel setTextColor:[UIColor colorWithString:@"#4BB04F"]];
            }
            else {
                [weekDayLabel setTextColor:[UIColor colorWithString:@"#5B5B5B"]];
            }
            
            NSDate *buttonDate = [((NSDictionary *)[dateArray objectAtIndex:i]) objectForKey:@"date"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEE" options:0 locale:[NSLocale currentLocale]];
            [weekDayLabel setText:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:buttonDate]]];
            
            [whiteBackground addSubview:weekDayLabel];
        }
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, whiteBackground.frame.origin.y + whiteBackground.frame.size.height , self.frame.size.width/2, 60)];
        [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithRed:26.0/255.0 green:146.0/255.0 blue:215.0/255.0 alpha:1] forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [roundBackground addSubview:cancelButton];
        
        UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2, whiteBackground.frame.origin.y + whiteBackground.frame.size.height , self.frame.size.width/2, 60)];
        [okButton addTarget:self action:@selector(okButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [okButton setTitle:@"確定" forState:UIControlStateNormal];
        [okButton setTitleColor:[UIColor colorWithRed:26.0/255.0 green:146.0/255.0 blue:215.0/255.0 alpha:1] forState:UIControlStateNormal];
        [okButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [roundBackground addSubview:okButton];

    }
    
    return self;
}

- (void)setSelectableDictionary:(NSDictionary *)selectableDictionary
{
//    self.selectableDictionary = selectableDictionary;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    for (int i = 0; i < 42; i++) {
        NSMutableDictionary *tmpDic = [dateArray objectAtIndex:i];
        NSDate *tmpDate = tmpDic[@"date"];
        tmpDic[@"isSelectable"] = selectableDictionary[[formatter stringFromDate:tmpDate]];
    }
    [self fillUpButtonComponent];
}

- (void)fillUpDateArray
{
    if (!dateArray)
        dateArray = [[NSMutableArray alloc] init];
    if (dateArray.count > 0)
        [dateArray removeAllObjects];
    
    NSCalendar *baseCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *baseComps = [baseCal components:NSWeekdayCalendarUnit fromDate:baseDate];
    long prevMonthCount = [baseComps weekday] - 1;
    long nextMonthCount = 42 - (baseDayCount + prevMonthCount);
    
    for (long i = prevMonthCount; i > 0; i--) {
        NSDate *tmpDate = [baseDate dateByAddingTimeInterval:-(86400*i)];
        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
        tmpDic[@"date"] = tmpDate;
        tmpDic[@"isMainMonth"] = @"0";
        [dateArray addObject:tmpDic];
    }
    
    for (int i = 0; i < baseDayCount; i++) {
        NSDate *tmpDate = [baseDate dateByAddingTimeInterval:86400*i];
        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
        tmpDic[@"date"] = tmpDate;
        tmpDic[@"isMainMonth"] = @"1";
        [dateArray addObject:tmpDic];
    }
    
    for (long i = 0; i < nextMonthCount; i++) {
        NSDate *tmpDate = [baseDate dateByAddingTimeInterval:86400*(baseDayCount+i)];
        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
        tmpDic[@"date"] = tmpDate;
        tmpDic[@"isMainMonth"] = @"0";
        [dateArray addObject:tmpDic];
    }
    
    self.firstDate = ((NSDictionary*)[dateArray objectAtIndex:0])[@"date"];
    self.lastDate = ((NSDictionary*)[dateArray objectAtIndex:41])[@"date"];
}

- (void)fillUpDayButton
{
    [self fillUpDateArray];
    
    [self fillUpButtonComponent];
}

- (void)fillUpButtonComponent
{
    for (int i = 0; i < 42; i++) {
        NSInteger xCount = i % 7;
        UIColor *stringColor;
//        if (xCount == 0 || xCount == 6) {
//            [dayButton[i] setBackgroundColor:[UIColor colorWithString:@"#F6E1E0"]];
//            if (xCount == 0) {
//                stringColor = [UIColor colorWithString:@"#CB4646"];
//            }
//            if (xCount == 6) {
//                stringColor = [UIColor colorWithString:@"#4BB04F"];
//            }
//            
//        }
//        else {
//            [dayButton[i] setBackgroundColor:[UIColor colorWithString:@"#F3F3F3"]];
//            stringColor = [UIColor colorWithString:@"#5B5B5B"];
//        }
        
        if ([[((NSDictionary *)[dateArray objectAtIndex:i]) objectForKey:@"isMainMonth"] intValue] == 0) {
            [dayButton[i] setHidden:YES];
        }
        else {
            [dayButton[i] setHidden:NO];
        }
        
        NSDate *buttonDate = [((NSDictionary *)[dateArray objectAtIndex:i]) objectForKey:@"date"];
        NSCalendar *dateCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *dateComps = [dateCal components:NSDayCalendarUnit fromDate:buttonDate];
        [dayButton[i] setTitle:[NSString stringWithFormat:@"%ld", (long)dateComps.day] forState:UIControlStateNormal];
        
        if ([[((NSDictionary *)[dateArray objectAtIndex:i]) objectForKey:@"isSelectable"] intValue] == 0) {
            [dayButton[i] setBackgroundColor:[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1]];
            stringColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1];
            [dayButton[i] setUserInteractionEnabled:NO];
        }
        else {
            [dayButton[i] setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1]];
            stringColor = [UIColor colorWithRed:83.0/255.0 green:88.0/255.0 blue:91.0/255.0 alpha:1];
            [dayButton[i] setUserInteractionEnabled:YES];
        }
        
        if ([buttonDate isEqualToDate:self.selectedDay]) {
            [dayButton[i] setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:190.0/255.0 blue:0.0/255.0 alpha:1]];
            stringColor = [UIColor colorWithString:@"#5B5B5B"];
        }
        
        NSDictionary *stringAttribute;
        if ([buttonDate isEqualToDate:today]) {
            stringAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                NSForegroundColorAttributeName:stringColor};
        }
        else {
            stringAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone),
                                NSForegroundColorAttributeName:stringColor};
        }
        [dayButton[i] setAttributedTitle:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)dateComps.day] attributes:stringAttribute] forState:UIControlStateNormal];
    }
}

#pragma mark --
#pragma mark Button Action
- (void)monthSelect:(id)sender
{
    UIButton *selectedButton = (UIButton *)sender;
    switch (selectedButton.tag) {
        case 1:
            //prev
            baseDate = [baseDate dateByAddingTimeInterval:-86400];
            break;
        case 2:
            //next
            baseDate = [baseDate dateByAddingTimeInterval:(86400*baseDayCount)];
        default:
            break;
    }
    
    NSCalendar *todayCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *todayComp = [todayCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:baseDate];
    [todayComp setDay:1];
    baseDate = [todayCalendar dateFromComponents:todayComp];
//    self.selectedDay = [todayCalendar dateFromComponents:todayComp];
    
    NSRange baseDayRange = [todayCalendar rangeOfUnit:NSCalendarUnitDay
                                               inUnit:NSCalendarUnitMonth
                                              forDate:[todayCalendar dateFromComponents:todayComp]];
    baseDayCount = baseDayRange.length;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy 年 MM 月"];
    [selectedMonthLabel setText:[dateFormatter stringFromDate:baseDate]];
    
    [self fillUpDayButton];
    [self.delegate updateCalendarView:self];
}

- (void)dateSelected:(id)sender
{
    UIButton *selectedButton = (UIButton *)sender;
    self.selectedDay = [((NSDictionary *)[dateArray objectAtIndex:selectedButton.tag]) objectForKey:@"date"];
    
    [self fillUpButtonComponent];
}

- (void)cancelButtonAction
{
    [self.delegate cancelCalendarView:self];
}

- (void)okButtonAction
{
    [self.delegate calendarView:self doneWithDate:self.selectedDay];
}

@end
