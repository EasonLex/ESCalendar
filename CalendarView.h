//
//  CalendarView.h
//  ihergoApp
//
//  Created by motephyr on 2015/6/22.
//  Copyright (c) 2015年 ihergo. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CalendarViewDelegate;

@interface CalendarView : UIView
@property (strong, nonatomic) id<CalendarViewDelegate> delegate;
@property (strong, nonatomic) NSDate *selectedDay;
@property (strong, nonatomic) NSDate *firstDate;
@property (strong, nonatomic) NSDate *lastDate;
@property (strong, nonatomic) NSDictionary *selectableDictionary;
@end

@protocol CalendarViewDelegate
@required
- (void)calendarView:(CalendarView*)calendarView doneWithDate:(NSDate*)selectedDate;

@optional
- (void)updateCalendarView:(CalendarView*)calendarView;
- (void)cancelCalendarView:(CalendarView*)calendarView;
@end