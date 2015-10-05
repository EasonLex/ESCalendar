# ESCalendar

Easy to initialize:
CalendarView myCalendarView = [[CalendarView alloc] initWithFrame:selfFrame];
 
You can set selected day:
myCalendarView.selectedDay = [NSDate date];

Set selectable date:
[myCalendarView setSelectableDictionary:selectedDic];

Dictionary formate:
Use date string as key(YYYY-MM-dd), NSNumber 1 as value.

Three delegations:

@required
- (void)calendarView:(CalendarView*)calendarView doneWithDate:(NSDate*)selectedDate;

@optional
- (void)updateCalendarView:(CalendarView*)calendarView;
- (void)cancelCalendarView:(CalendarView*)calendarView;
