//
//  BanosAccesiblesTableViewController.h
//  CampusAccesibleApp
//
//  Created by Ana on 11/9/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BanosAccesiblesTableViewController : UITableViewController

@property (strong, nonatomic) id edificio1;
- (IBAction)atras:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *lbAtras;

@end
