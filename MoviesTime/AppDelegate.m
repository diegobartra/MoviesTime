//
//  AppDelegate.m
//  MoviesTime
//
//  Created by Diego Bartra on 10/27/16.
//  Copyright © 2016 ArcTouch. All rights reserved.
//

#import "AppDelegate.h"
#import "ServerConfiguration.h"
#import "GenreStore.h"
#import "DataLoadingManager.h"
#import "UIViewController+MovieContent.h"
#import "EmptyViewController.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ServerConfiguration *config = [ServerConfiguration defaultConfiguration];
    GenreStore *genres = [GenreStore sharedStore];
    [[DataLoadingManager sharedManager] subscribeObject:config];
    [[DataLoadingManager sharedManager] subscribeObject:genres];
    [config fetch];
    [genres fetchGenres];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    splitViewController.delegate = self;
    
    return YES;
}

#pragma mark - Split view controller delegate

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    
    if (![secondaryViewController _containsMovie]) {
        return YES;
    }
    
    return NO;
}

- (UIViewController *)splitViewController:(UISplitViewController *)splitViewController separateSecondaryViewControllerFromPrimaryViewController:(UIViewController *)primaryViewController {

    if ([primaryViewController _containsMovie]) {
        return nil;
    }
    
    return [[UINavigationController alloc] initWithRootViewController:[[EmptyViewController alloc] init]];
}

@end
