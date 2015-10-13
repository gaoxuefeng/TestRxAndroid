//
//  FMDBTool.m
//  RecordTime
//
//  Created by sen on 9/4/15.
//  Copyright (c) 2015 sen. All rights reserved.
//

#import "FMDBTool.h"
#import <FMDB.h>
#import "Header.h"

@implementation FMDBTool
static FMDatabaseQueue *queue;
//static NSDateFormatter *dateFormatter;

+ (void)initialize
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlitePath = [docPath stringByAppendingPathComponent:@"markdate.sqlite"];
    
    queue = [FMDatabaseQueue databaseQueueWithPath:sqlitePath];
    
    [queue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_datepoints (id integer PRIMARY KEY AUTOINCREMENT, date TimeStamp NOT NULL DEFAULT (datetime('now','localtime')), date_type integer NOT NULL);"];
        if (result) {
//            RTLog(@"创表成功");
        }else
        {
            RTLog(@"创表失败");
        }
    }];
    
//    dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
}

+ (void)insertDatePointWithType:(RTDatePointType)datePointType
{
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"INSERT INTO t_datepoints(date_type) VALUES (?)",@(datePointType)];
    }];
}

+ (NSArray *)queryAllDatePoint
{
    return [self queryDatePointsFromDate:[NSDate dateWithTimeIntervalSince1970:0.0] toDate:[NSDate date] withDatePointType:RTDatePointTypeEnterCompany | RTDatePointTypeEnterHome | RTDatePointTypeExitHome | RTDatePointTypeExitCompany];
}


+ (NSArray *)queryDatePointsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate withDatePointType:(RTDatePointType)datePointType
{
    NSMutableArray *datePoints = [NSMutableArray array];
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *fromDateStr = [[RTDateTool dateFormatter] stringFromDate:fromDate];
        NSString *toDateStr = [[RTDateTool dateFormatter] stringFromDate:toDate];
        FMResultSet *resultSet = nil;
        if (datePointType == (RTDatePointTypeEnterCompany | RTDatePointTypeEnterHome | RTDatePointTypeExitHome | RTDatePointTypeExitCompany)) {
            resultSet = [db executeQuery:@"SELECT * FROM t_datepoints t WHERE t.date >= datetime(?) and t.date < datetime(?)",fromDateStr, toDateStr];
        }else if (datePointType == (RTDatePointTypeEnterCompany | RTDatePointTypeExitCompany))
        {
            resultSet = [db executeQuery:@"SELECT * FROM t_datepoints t WHERE t.date >= datetime(?) and t.date < datetime(?) and (date_type = ? or date_type = ?)",fromDateStr, toDateStr,@(RTDatePointTypeEnterCompany),@(RTDatePointTypeExitCompany)];
        }else if (datePointType == (RTDatePointTypeEnterHome | RTDatePointTypeExitHome))
        {
            resultSet = [db executeQuery:@"SELECT * FROM t_datepoints t WHERE t.date >= datetime(?) and t.date < datetime(?) and (date_type = ? or date_type = ?)",fromDateStr, toDateStr,@(RTDatePointTypeEnterHome),@(RTDatePointTypeExitHome)];
        }
        while (resultSet.next) {
            RTDatePointModel *datePoint = [[RTDatePointModel alloc] init];
            NSString *dateStr = [resultSet stringForColumn:@"date"];
            datePoint.date = [[RTDateTool dateFormatter] dateFromString:dateStr];
            datePoint.dateType = [resultSet intForColumn:@"date_type"];
            [datePoints addObject:datePoint];
        }
    }];
    return datePoints;
}

@end
