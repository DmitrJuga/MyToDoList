//
//  ListViewController.m
//  MyToDoList
//
//  Created by DmitrJuga on 22.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

#import "AppConstants.h"
#import "ListViewController.h"
#import "EventViewController.h"
#import "CustomCell.h"

@interface ListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayEvents;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadEvents];
}

// загрузка списка напоминаний
- (void)reloadEvents {
    self.arrayEvents = [[UIApplication sharedApplication] scheduledLocalNotifications];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

// кнопка - добавление нового напоминания
- (IBAction)btnAddPressed:(id)sender {
    EventViewController * eventVC = [self.storyboard instantiateViewControllerWithIdentifier:EVENT_VC_ID];
    [self.navigationController pushViewController:eventVC animated:YES];
}

// кнопка Refresh
- (IBAction)btnRefreshPressed:(id)sender {
    [self reloadEvents];
}


#pragma mark: - UITableViewDataSource

// кол-во строк
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayEvents.count;
}

// настройка вида ячейки
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell * cell = [tableView dequeueReusableCellWithIdentifier:EVENT_CELL_ID];
    [cell setupCellForEvent:[self.arrayEvents objectAtIndex:indexPath.row]];
    return cell;
}

// разрешаем удалять
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EventViewController * eventVC = [self.storyboard instantiateViewControllerWithIdentifier:EVENT_VC_ID];
    eventVC.event = [self.arrayEvents objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:eventVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
