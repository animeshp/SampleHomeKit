//
//  AddNewAccesoryViewController.h
//  SampleHomeKit
//
//  Created by Porwal, Animesh on 7/3/14.
//  Copyright (c) 2014 AP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

@interface AddNewAccesoryViewController : UIViewController<HMAccessoryBrowserDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) HMHomeManager *homeManager;
@property (weak, nonatomic) IBOutlet UITableView *accessoryTableView;

@end
