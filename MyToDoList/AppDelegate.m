//
//  AppDelegate.m
//  MyToDoList
//
//  Created by DmitrJuga on 22.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

#import "AppConstants.h"
#import "AppDelegate.h"
#import "ListViewController.h"
#import "EventViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // регистрация для получения нотификаций
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    // если получена нотификация - обработать
    UILocalNotification *notification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification) {
        [self application:application didReceiveLocalNotification:notification];
    }
    
    return YES;
}

// обработка полученой нотификации
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    application.applicationIconBadgeNumber = 0;
    if (application.applicationState == UIApplicationStateActive) {
        // из активного состояния - с алертом
        [self showAlertForNotification:notification];
    } else {
        // из неактивного состояния (без алерта) - сразу открываем напоминание на просмотр
        [self showEventForNotification:notification];
    }
}

// сообщаем о приходе нотификации
- (void)showAlertForNotification:(UILocalNotification *)notification {
    if ([self.window.rootViewController.presentedViewController isKindOfClass:[UIAlertController class]]) {
        // уже отображается UIAlertController - повторим вызов себя через 5 сек.
        [self performSelector:@selector(showAlertForNotification:) withObject:notification afterDelay:5];
        return;
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:notification.alertTitle
                                                                   message:notification.alertBody
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // не открываем напоминание, просто обновляем список
        UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
        [(ListViewController *)navController.viewControllers[0] reloadEvents];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Открыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // открываем напоминание на просмотр
        [self showEventForNotification:notification];
    }]];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

// открываем напоминание на просмотр
- (void)showEventForNotification:(UILocalNotification *)notification {
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    EventViewController *vc = [navController.storyboard instantiateViewControllerWithIdentifier:EVENT_VC_ID];
    vc.event = notification;
    vc.isFired = YES;
    [navController pushViewController:vc animated:YES];
}


@end
