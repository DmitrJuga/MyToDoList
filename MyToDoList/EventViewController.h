//
//  EventViewController.h
//  MyToDoList
//
//  Created by DmitrJuga on 22.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (assign, nonatomic) BOOL isNew;
@property (strong, nonatomic) UILocalNotification *event;

@end
