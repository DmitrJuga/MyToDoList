//
//  EventViewController.m
//  MyToDoList
//
//  Created by DmitrJuga on 22.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

#import "EventViewController.h"
#import "AppConstants.h"


@interface EventViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentPriority;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveDelete;

@end

@implementation EventViewController

- (void)viewDidLoad {
    [self setupUI];
}

// настройка отображения UI элементов
- (void)setupUI {
    if (self.isNew) {
        self.title = @"Новое напоминание";
        [self.btnSaveDelete setTitle: @"Сохранить" forState:UIControlStateNormal];
        self.btnSaveDelete.backgroundColor = self.view.tintColor;
        
        self.datePicker.minimumDate = [NSDate date];
        [self.textFieldName becomeFirstResponder];
    } else {
        self.title = @"Напоминание";
        [self.btnSaveDelete setTitle: @"Удалить" forState:UIControlStateNormal];
        self.btnSaveDelete.backgroundColor = [UIColor redColor];
        
        self.textFieldName.userInteractionEnabled = NO;
        self.textFieldName.text = self.event.alertTitle;
        
        self.segmentPriority.userInteractionEnabled = NO;
        NSNumber * priority = [self.event.userInfo valueForKey:KEY_PRIORITY];
        self.segmentPriority.selectedSegmentIndex = priority.integerValue;
        
        [self performSelector:@selector(setDate:) withObject:self.event.fireDate afterDelay:0.5];
        self.datePicker.userInteractionEnabled = NO;
    }
}

// анимированная установка даты
- (void)setDate: (NSDate *) date {
    [self.datePicker setDate:date animated:YES];
}


// добавление напоминания (нотификации)
- (void)addNewEvent {
    UILocalNotification * event = [[UILocalNotification alloc]init];
    
    event.fireDate = self.datePicker.date;
    event.alertTitle = @"Напоминаю!";
    event.alertBody = self.textFieldName.text;
    event.soundName = UILocalNotificationDefaultSoundName;
    event.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    
    NSNumber * priority = [NSNumber numberWithInteger:self.segmentPriority.selectedSegmentIndex];
    NSDictionary * userInfo = [NSDictionary dictionaryWithObject:priority forKey:KEY_PRIORITY];
    event.userInfo = userInfo;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:event];
}

// нажатие кнопки [Сохранить] / [Удалить]
- (IBAction)btnSaveDeletePressed:(id)sender {
    if (self.isNew) {
        // если новое напоминание - хотим сохранить
        if (self.textFieldName.hasText) {
            if ([self.datePicker.date compare:[NSDate date]] == NSOrderedDescending)  {
                // всё ок! сохраняем напоминание и уходим
                [self addNewEvent];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_RELOAD object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                // выбрана дата <= текущей
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Внимание!" message:@"Дата и время напоминания должны быть больше текущей!" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"ОК" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    NSDate * date = [NSDate date];
                    [self.datePicker setDate:date animated:YES];
                    self.datePicker.minimumDate = date;
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        } else {
            // не заполнен заголовок
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Внимание!" message:@"Необходимо указать текст напоминания!" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"ОК" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self.textFieldName becomeFirstResponder];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else {
        // если НЕ новое напоминание - хотим удалить
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Удаление" message:@"Напоминание будет удалено безвозвратно!" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"Удалить" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            // удаляем и уходим
            [[UIApplication sharedApplication] cancelLocalNotification:self.event];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_RELOAD object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark - UITextFieldDelegate

// нажатие Return
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
