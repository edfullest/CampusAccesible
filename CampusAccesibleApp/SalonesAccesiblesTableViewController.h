//
//  SalonesAccesiblesTableViewController.h
//  CampusAccesibleApp
//
//  Created by Eduardo Jesus Serna L on 10/17/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalonesAccesiblesTableViewController : UITableViewController

@property (strong, nonatomic) id edificio1;

- (IBAction)atras:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *lbAtras;


@end
