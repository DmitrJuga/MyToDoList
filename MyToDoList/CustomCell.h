//
//  CustomCell.h
//  MyToDoList
//
//  Created by DmitrJuga on 22.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

- (void)setupCellForEvent: (UILocalNotification *) event;

@end
