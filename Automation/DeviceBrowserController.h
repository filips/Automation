//
//  DeviceBrowserController.h
//  Automation
//
//  Created by Filip Sandborg-Olsen on 20/01/16.
//  Copyright © 2016 Sandborg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface DeviceBrowserController : UITableViewController <NSNetServiceBrowserDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray* servers;
}

@property (strong) NSNetServiceBrowser* nb;

-(IBAction) performRefresh:(id)sender;

@end

