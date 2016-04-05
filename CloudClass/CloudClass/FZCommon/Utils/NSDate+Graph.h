//
//  NSDate+Graph.h
//

#import <Foundation/Foundation.h>

@interface NSDate (Graph)
//获取两个日期之间的数量（type:1天数，2:周数，3:月数, 4:年数）
+ (NSInteger)countBetweenDateByType:(NSDate *)startDate endDate:(NSDate *)endDate type:(int)type;
//两个日期之间的年数
+ (NSInteger)yearsBetweenDate:(NSDate *)startDate endDate:(NSDate *)endDate;
//两个日期之间的月数
+ (NSInteger)monthsBetweenDate:(NSDate *)startDate endDate:(NSDate *)endDate;
//两个日期之间的周
+ (NSInteger)weeksBetweenDate:(NSDate *)startDate endDate:(NSDate *)endDate;
+ (NSInteger)daysBetweenDate:(NSDate *)startDate endDate:(NSDate *)endDate;
+ (NSInteger)hoursBetweenDate:(NSDate *)startDate endDate:(NSDate *)endDate;
+ (NSInteger)secondsBetweenDate:(NSDate *)startDate endDate:(NSDate *)endDate;
- (NSDate *)nextDay;
- (NSDate *)previousDay;
- (NSDate*)previousHalfHour;
- (NSDate *)nextHour;
- (NSDate *)previousHour;
- (NSDate*)nextWeek;
- (NSDate*)nextMonth;
- (NSDate*)nextYear;
- (NSDate *)dateWithDaysAhead:(NSInteger)days;
- (NSString *)dateFormatYYYYMMDDEEEEAAHHMM;//转化日期:2013年9月9日 星期日 上午11:45
- (NSString *)dateFormatYYMMDDEEEAAHHMM;//转化日期:13/9/9周日 上午11:45
- (BOOL)isSameDay:(NSDate*)otherDate;//判断两个日期是否是同一天
- (NSInteger)compareTo:(NSDate*)otherDate;//比较两个日期的大小(0相等，-1当前日期较小，1当前日期较大)
- (NSInteger)compareHHmmTo:(NSDate *)otherDate;//比较两个日期的小时和分钟的大小(0相等，-1当前日期较小，1当前日期较大)
+ (NSInteger) getTimeIntervalSince1970:(NSDate*)date;
//获取指定日期的年，月，周(一年中的第几周) firstWeekDayValueIs2:一周的开始是否为周一
+ (NSMutableArray*) getYearMonthWeekForDate:(NSDate*)curDate firstWeekDayValueIs2:(BOOL)firstWeekDayValueIs2;
//获取指定日期的年，月，周(一年中的第几周)，日(一年中的第几日) firstWeekDayValueIs2:一周的开始是否为周一
+ (NSMutableArray*) getYearMonthWeekForTime:(long long)time firstWeekDayValueIs2:(BOOL)firstWeekDayValueIs2;
//获取日期(只有年月日)
+ (NSString*) getYMDByDate:(NSDate*) date;//2013-09-10
//根据NSdate返回格式的时间字符串
+ (NSString*) getFormatDate:(NSDate*) date;
@end
