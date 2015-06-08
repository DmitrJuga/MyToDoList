//
//  EventViewController.m
//  MyToDoList
//
//  Created by DmitrJuga on 22.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

#import "AppConstants.h"
#import "EventViewController.h"

@interface EventViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentPriority;
@property (weak, nonatomic) IBOutlet UITextView *textViewNotes;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (assign, nonatomic) BOOL editMode;

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // обработчик нажатий (чтобы убирать клавиатуру при нажатии вне полей)
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [self.view addGestureRecognizer:tap];
    // инициализация UI
    self.editMode = (self.event == nil);
    [self setupUI];
}

// первоначальная настройка UI
- (void)setupUI {
    // если передан event = > заполняем поля
    if (self.event) {
        self.title = @"Напоминание";
        self.textFieldName.text = self.event.alertBody;
        NSNumber * priority = [self.event.userInfo valueForKey:KEY_PRIORITY];
        self.segmentPriority.selectedSegmentIndex = priority.integerValue;
        self.textViewNotes.text = [self.event.userInfo valueForKey:KEY_NOTES];
        [self performSelector:@selector(setDate:) withObject:self.event.fireDate afterDelay:0.5];
        self.btnDelete.layer.cornerRadius = 6;
        self.btnDelete.hidden = self.isFired;
    } else {
        self.title = @"Новое напоминание";
        self.btnDelete.hidden = YES;
        self.datePicker.date = [NSDate dateWithTimeIntervalSinceNow:60];
    }
    self.textViewNotes.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textViewNotes.layer.borderWidth = 0.5;
    self.textViewNotes.layer.cornerRadius = 6;
    [self setupUIForEditMode];
}

// настройка UI для режима редактирования
- (void)setupUIForEditMode {
    NSString *rightButtonTitle;
    if (self.editMode) {
        self.textFieldName.userInteractionEnabled = YES;
        self.segmentPriority.userInteractionEnabled = YES;
        self.textViewNotes.editable = YES;
        self.datePicker.userInteractionEnabled = YES;
        self.textFieldName.textColor = [UIColor blackColor];
        self.textViewNotes.textColor = [UIColor blackColor];
        rightButtonTitle = (!self.event || self.isFired) ? @"Готово" : @"Сохранить";
        self.datePicker.minimumDate = [NSDate date];
        [self.textFieldName becomeFirstResponder];
    } else {
        self.textFieldName.textColor = [UIColor darkGrayColor];
        self.textViewNotes.textColor = [UIColor darkGrayColor];
        self.textFieldName.userInteractionEnabled = NO;
        self.segmentPriority.userInteractionEnabled = NO;
        self.textViewNotes.editable = NO;
        self.datePicker.userInteractionEnabled = NO;
        rightButtonTitle = @"Изменить";
    }
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:rightButtonTitle
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(btnEditSavePressed:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

// анимированная установка даты
- (void)setDate:(NSDate *)date {
    [self.datePicker setDate:date animated:YES];
}

// сохранение напоминания (нотификации)
- (BOOL)saveEvent {
    // сначала проверяем поля и предупреждаем пользователя
    if (!self.textFieldName.hasText) {
        NSString *msg = @"Необходимо указать текст напоминания!";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"ОК" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:^{
            [self.textFieldName becomeFirstResponder];
        }];
        return NO;
    } else if ([self.datePicker.date compare:[NSDate date]] == NSOrderedAscending) {
        NSString *msg = @"Дата и время напоминания должны быть больше текущей!";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"ОК" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:^{
            NSDate * date = [NSDate date];
            [self.datePicker setDate:date animated:YES];
            self.datePicker.minimumDate = date;
        }];
        return NO;
    }

    // теперь сохраняем
    if (!self.event) {
        self.event = [[UILocalNotification alloc] init]; // новое
    } else if (!self.isFired) {
        [[UIApplication sharedApplication] cancelLocalNotification:self.event]; // изменение
    }
    self.event.fireDate = self.datePicker.date;
    self.event.timeZone = [NSTimeZone defaultTimeZone];
    self.event.alertTitle = @"Напоминаю!";
    self.event.alertBody = self.textFieldName.text;
    self.event.soundName = UILocalNotificationDefaultSoundName;
    self.event.applicationIconBadgeNumber = 1; //[UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    NSNumber *priority = @(self.segmentPriority.selectedSegmentIndex);
    NSDictionary * userInfo = @{ KEY_PRIORITY: priority,
                               KEY_NOTES: self.textViewNotes.text };
    self.event.userInfo = userInfo;
    [[UIApplication sharedApplication] scheduleLocalNotification:self.event];
    return YES;
}

// удаление текущего напоминания (нотификации)
- (void)deleteEvent {
    // предупреждаем пользователя
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE
                                                                   message:@"Напоминание будет удалено безвозвратно!"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Удалить"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction *action) {
        // удаляем
        [[UIApplication sharedApplication] cancelLocalNotification:self.event];
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Actions Handlers

// обработчик нажатия кнопки сохранить
- (void)btnEditSavePressed:(id)sender {
    if (self.editMode) {
        // кнопка "Сохранить"
        BOOL isNewEvent = (self.event == nil);
        if ([self saveEvent]) {
            if (isNewEvent || self.isFired) {
                // если создали новый event - выходим
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                // если не новый - выключаем режим редактирования
                self.editMode = NO;
                [self setupUIForEditMode];
            }
        }
    } else {
        // кнопка "Редактировать"
        self.editMode = YES;
        [self setupUIForEditMode];
    }
}

// обработчик нажатия - убрать клавиатуру при нажатии вне полей
- (void)tapHandler:(id)sender {
    [self.textFieldName resignFirstResponder];
    [self.textViewNotes resignFirstResponder];
}

// обработчик нажатия кнопки удалить
- (IBAction)btnDeletePressed:(id)sender {
    [self deleteEvent];
}


#pragma mark - UITableViewDelegate

// высота ячеек
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return (self.event) ? tableView.frame.size.height - 474 : 0;
    }
    NSArray *cellHeights = @[ @64, @38, @112, @188 ];
    return [cellHeights[indexPath.row] floatValue];
}


#pragma mark - UITextFieldDelegate

// нажатие Return
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
