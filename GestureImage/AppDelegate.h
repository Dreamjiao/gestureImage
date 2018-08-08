//
//  AppDelegate.h
//  GestureImage
//
//  Created by dadousmart on 2018/8/8.
//  Copyright © 2018年 Jackjiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

