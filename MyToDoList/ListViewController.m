//
//  ListViewController.m
//  MyToDoList
//
//  Created by DmitrJuga on 22.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

#import "ListViewController.h"
#import "EventViewController.h"
#import "CustomCell.h"
#import "AppConstants.h"

@interface ListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayEvents;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    // подписываемся на внутренние нотификации
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadEvents) name:NOTIF_RELOAD object:nil];
    [self reloadEvents];
}

// загрузка списка напоминаний
- (void)reloadEvents {
    self.arrayEvents = [[UIApplication sharedApplication] scheduledLocalNotifications];
    [self reloadUI];
}

// перезагрузка UI таблицы
- (void)reloadUI {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    });
}

// кнопка [+] - добавление нового напоминания
- (IBAction)btnAddPressed:(id)sender {
    EventViewController * eventVC = [self.storyboard instantiateViewControllerWithIdentifier:EVENT_VC_ID];
    eventVC.isNew = YES;
    [self.navigationController pushViewController:eventVC animated:YES];
}

// отписываемся от внутренних нотификаций
- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark: - UITableViewDataSource

// кол-во строк в списке
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayEvents.count;
}

// настройка вида ячейки
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell * cell = [tableView dequeueReusableCellWithIdentifier:EVENT_CELL_ID];
    [cell setupCellForEvent:[self.arrayEvents objectAtIndex:indexPath.row]];
    return cell;
}

// разрешаем удалять
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// удаление напоминания
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UILocalNotification * event = [self.arrayEvents objectAtIndex:indexPath.row];
        [[UIApplication sharedApplication] cancelLocalNotification:event];
        [self reloadEvents];
    }
}


#pragma mark: - UITableViewDelegate

// переход на просмотр напоминания
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EventViewController * eventVC = [self.storyboard instantiateViewControllerWithIdentifier:EVENT_VC_ID];
    eventVC.isNew = NO;
    eventVC.event = [self.arrayEvents objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:eventVC animated:YES];
}

@end
