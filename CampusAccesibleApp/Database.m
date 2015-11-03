//
//  Database.m
//  CampusAccesibleApp
//
//  Created by Ana on 11/2/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import "Database.h"
#include "Vertice.h"        // Header of the data wanted

@implementation Database

// Standard code to create a singleton instance of FailedBankDatabase for ease of access.
static Database *_database;

+ (Database*)database {
    if (_database == nil) {
        _database = [[Database alloc] init];
    }
    return _database;
}

// Initialize object and construct a path to our database file.
- (id)init {
    if ((self = [super init])) {
        // We’re storing the database in our application’s bundle, so we use the pathForResource method to obtain the path.
        // The database is "myData.sqlite"
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"myData"
                                                             ofType:@"sqlite"];
        
        if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}

- (void)dealloc {
    sqlite3_close(_database);
    [super dealloc];
}

// Retrieving the data from the database
- (NSArray *)verticeInfo {
    NSMutableArray *retval = [[[NSMutableArray alloc] init] autorelease];
    NSString *query = @"SELECT * FROM vertice";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int idVertice = sqlite3_column_int(statement, 0);
            int iLongitud = sqlite3_column_int(statement, 1);
            int iLatitud = sqlite3_column_int(statement, 2);
            char *cNombreMapa = (char *) sqlite3_column_text(statement, 3);

            NSInteger longitud = iLongitud;
            NSInteger latitud = iLatitud;
            NSString *nombre = [[NSString alloc] initWithUTF8String:cNombreMapa];
            Vertice *info = [[Vertice alloc]
                             initWithIdVertice: idVertice
                             withLongitud: longitud
                             withLatitud: latitud
                             withNombreMapa: nombre];
            [retval addObject:info];
            [nombre release];
            [info release];
        }
        sqlite3_finalize(statement);
    }
    return retval;
    
}

@end
