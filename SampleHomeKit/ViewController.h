//
//  ViewController.h
//  SampleHomeKit
//
//  Created by Porwal, Animesh on 7/2/14.
//  Copyright (c) 2014 AP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

@interface ViewController : UIViewController<HMHomeManagerDelegate, HMHomeDelegate, HMAccessoryDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) HMHomeManager *homeManager;
@property (nonatomic, strong) HMHome *primaryHome;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addHomeButton;

- (IBAction)addHome:(id)sender;


@end

