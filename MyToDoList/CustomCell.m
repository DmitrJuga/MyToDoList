//
//  CustomCell.m
//  MyToDoList
//
//  Created by DmitrJuga on 22.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

#import "AppConstants.h"
#import "CustomCell.h"

@interface CustomCell()

@property (weak, nonatomic) IBOutlet UILabel *labelEventName;
@property (weak, nonatomic) IBOutlet UILabel *labelEventDate;
@property (weak, nonatomic) IBOutlet UILabel *labelEventPriority;

@end

@implementation CustomCell

// настройка вида ячейки для напоминания
- (void)setupCellForEvent:(UILocalNotification *)event {
    self.labelEventName.text = event.alertBody;
    
    // визуализируем важность
    NSNumber *priority = [event.userInfo valueForKey:KEY_PRIORITY];
    NSArray *arrayPriorityStr = @[ @"o", @"!", @"!!", @"!!!" ];
    self.labelEventPriority.text = arrayPriorityStr[priority.integerValue];
    
    // форматируем дату
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = EVENT_DATE_FORMAT;
    self.labelEventDate.text = [formater stringFromDate:event.fireDate];
}

@end
