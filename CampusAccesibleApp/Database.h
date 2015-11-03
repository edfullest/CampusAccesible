//
//  Database.h
//  CampusAccesibleApp
//
//  Created by Ana on 11/2/15.
//  Copyright © 2015 ITESM. All rights reserved.
//
//
//  This is a helper class to handle all of the interaction with our sqlite3 database.
//  http://www.raywenderlich.com/913/sqlite-tutorial-for-ios-making-our-app
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>                 // Header file for sqlite3

@interface Database : NSObject {
    sqlite3 *_database;
}

+ (Database*)database;          // Static function to return the singleton instance of our Database object
- (NSArray *)verticeInfo;       // Method to return an array of all of the FailedBankInfos from our database.

@end
