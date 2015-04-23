//
//  CustomCell.m
//  MyToDoList
//
//  Created by DmitrJuga on 22.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

#import "CustomCell.h"
#import "AppConstants.h"


@implementation CustomCell

// настройка вида ячейки для напоминания
- (void)setupCellForEvent: (UILocalNotification *) event {
    self.labelEventName.text = event.alertTitle;
    
    // визуализируем важность
    NSNumber * priority = [event.userInfo valueForKey:KEY_PRIORITY];
    NSArray * arrayPriorityStr = [NSArray arrayWithObjects:@"o", @"!", @"!!", @"!!!", nil];
    self.labelEventPriority.text = [arrayPriorityStr objectAtIndex:priority.integerValue];
    
    // форматируем дату
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = EVENT_DATE_FORMAT;
    self.labelEventDate.text = [formater stringFromDate:event.fireDate];
}

@end
