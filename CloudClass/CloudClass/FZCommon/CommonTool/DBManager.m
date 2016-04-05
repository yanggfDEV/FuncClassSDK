

#import "DBManager.h"
#import <sqlite3.h>


@interface DBManager()

{
    dispatch_queue_t queue;
}

@property (nonatomic, strong) NSString *documentsDirectory;

@property (nonatomic, strong) NSString *databaseFilename;

@property (nonatomic, strong) NSMutableArray *arrResults;


-(void)copyDatabaseIntoDocumentsDirectory;

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

@end

@implementation DBManager

#pragma mark - Initialization

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename{
    self = [super init];
    if (self) {
        // Set the documents directory path to the documentsDirectory property.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [NSString  stringWithFormat:@"%@%@",[paths objectAtIndex:0],@"/Database"];
        // Keep the database filename.
        NSLog(@"DBmanageer path  %@",self.documentsDirectory);
        BOOL isDir = NO;
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.documentsDirectory isDirectory:&isDir])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:self.documentsDirectory withIntermediateDirectories:NO attributes:nil error:nil];
        }
        self.databaseFilename = dbFilename;
        // Copy the database file into the documents directory if necessary.
        [self copyDatabaseIntoDocumentsDirectory];
      //  How do I check in SQLite whether a table exists?
        NSString *query = [NSString  stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='groupMessgeTable'"];
        if ([self loadDataFromDB:query].count<1) {
            NSLog(@"需要建立一张 名为 groupMessgeTable  的表 来存储  群聊信息");
            [self createGroupChatMessagetable];
            
        }
        
        
        [self addColumn];
    }
    
    if (!queue) {
        queue = dispatch_queue_create("com.qupeiyin.MyQueue", DISPATCH_QUEUE_SERIAL); // or NULL as last parameter if prior to
    }
    return self;
}


#pragma mark - Private method implementation
-(void)copyDatabaseIntoDocumentsDirectory{
    
    NSLog(@"000copyDatabaseIntoDocumentsDirectory");
    // Check if the database file exists in the documents directory.
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        
        NSLog(@"111copyDatabaseIntoDocumentsDirectory %@",destinationPath);
        //兼容！  如果本地有一个老的聊天数据库文件 那么从老的地方复制到新的地方！
        //NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
        NSString  *old_destinationPath =[CachesDirectory stringByAppendingPathComponent:self.databaseFilename];
        if ([[NSFileManager defaultManager] fileExistsAtPath:old_destinationPath]) {
            
            NSError *error;
            [[NSFileManager defaultManager] copyItemAtPath:old_destinationPath toPath:destinationPath error:&error];
            if (error != nil) {
                NSLog(@"222copyDatabaseIntoDocumentsDirectory   _old_destinationPath %@", [error localizedDescription]);
            }
        }else{
            // The database file does not exist in the documents directory, so copy it from the main bundle now.
            NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
            NSError *error;
            [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
            // Check if any error occurred during copying and display it.
            if (error != nil) {
                NSLog(@"222copyDatabaseIntoDocumentsDirectory  %@", [error localizedDescription]);
            }
        }
        
    }
}

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable{
    
    
    
    if (!queue) {
        queue = dispatch_queue_create("com.qupeiyin.MyQueue", DISPATCH_QUEUE_SERIAL); // or NULL as last parameter if prior to
    }
    dispatch_sync(queue, ^{
        NSLog(@"*******************************************************%@  %@  %s",[NSThread  currentThread],queue,query);
        // Create a sqlite object.
        sqlite3 *sqlite3Database;
        
        // Set the database file path.
        NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
        
        // Initialize the results array.
        if (self.arrResults != nil && self.arrResults.count>0) {
            [self.arrResults removeAllObjects];
            self.arrResults = nil;
        }
        
        self.arrResults = [[NSMutableArray alloc] init];
        
        // Initialize the column names array.
        if (self.arrColumnNames != nil && self.arrResults.count>0) {
            [self.arrColumnNames removeAllObjects];
            self.arrColumnNames = nil;
        }
        self.arrColumnNames = [[NSMutableArray alloc] init];
        
        
        // Open the database.
        BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
        if(openDatabaseResult == SQLITE_OK) {
            // Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement.
            sqlite3_stmt *compiledStatement;
            
            // Load all data from database to memory.
            BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
            if(prepareStatementResult == SQLITE_OK) {
                // Check if the query is non-executable.
                if (!queryExecutable){
                    // In this case data must be loaded from the database.
                    
                    // Declare an array to keep the data for each fetched row.
                    NSMutableArray *arrDataRow;
                    
                    // Loop through the results and add them to the results array row by row.
                    while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                        // Initialize the mutable array that will contain the data of a fetched row.
                        arrDataRow = [[NSMutableArray alloc] init];
                        
                        // Get the total number of columns.
                        int totalColumns = sqlite3_column_count(compiledStatement);
                        
                        // Go through all columns and fetch each column data.
                        for (int i=0; i<totalColumns; i++){
                            // Convert the column data to text (characters).
                            char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                            
                            // If there are contents in the currenct column (field) then add them to the current row array.
                            if (dbDataAsChars != NULL) {
                                // Convert the characters to string.
                                [arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
                            }else{
                                [arrDataRow addObject:@""];
                            }
                            
                            // Keep the current column name.
                            if (self.arrColumnNames.count != totalColumns) {
                                dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                                [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                            }
                        }
                        
                        // Store each fetched data row in the results array, but first check if there is actually data.
                        if (arrDataRow.count > 0) {
                            [self.arrResults addObject:arrDataRow];
                        }
                    }
                }
                else {
                    // This is the case of an executable query (insert, update, ...).
                    
                    // Execute the query.
                    int executeQueryResults = sqlite3_step(compiledStatement);
                    NSLog(@"keller   %d",executeQueryResults);
                    if (executeQueryResults == SQLITE_DONE) {
                        // Keep the affected rows.
                        self.affectedRows = sqlite3_changes(sqlite3Database);
                        if (self.affectedRows>0) {
                            [self   dataBaseChanged];
                        }
                        
                        // Keep the last inserted row ID.
                        self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                    }
                    else {
                        // If could not execute the query show the error message on the debugger.
                        NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                        NSLog(@"keller   手机错误！！");
                        
                    }
                }
            }
            else {
                // In the database cannot be opened then show the error message on the debugger.
                NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
            }
            
            // Release the compiled statement from memory.
            sqlite3_finalize(compiledStatement);
            
        }
        
        // Close the database.
        sqlite3_close(sqlite3Database);
        

    });
    
    
    
}


#pragma mark - Public method implementation

-(NSArray *)loadDataFromDB:(NSString *)query{
    // Run the query and indicate that is not executable.
    // The query string is converted to a char* object.
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    // Returned the loaded results.
    return (NSArray *)self.arrResults;
}


-(void)executeQuery:(NSString *)query{
    // Run the query and indicate that is executable.
    // Check if the database file exists in the documents directory.
    
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {

        [[[UIAlertView alloc] initWithTitle:@"提示"
                                    message:@"数据库错误，未找的数据库文件，是否重新初始化？"
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
        }]
                           otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
            [self  copyDatabaseIntoDocumentsDirectory];
        }], nil] show];
    }else{
        [self runQuery:[query UTF8String] isQueryExecutable:YES];
    }
    
}

-(void)createGroupChatMessagetable{
    
    NSLog(@"createGroupChatMessagetable");
    // Create a sqlite object.
    sqlite3 *sqlite3Database;
    // Set the database file path.
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    // Open the database.
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    
    NSLog(@"sqlite3Database  %d  ",openDatabaseResult);
    
    /*字段
     id INTEGER PRIMARY KEY AUTOINCREMENT
     type TEXT
     jsonData TEXT
     fromId TEXT
     toId TEXT
     timeStamp TEXT
     sendStadus TEXT
     readStadus TEXT
     hash_jsonData TEXT
     hash_allMessage TEXT
     */
    if(openDatabaseResult == SQLITE_OK) {
        char *errMsg;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS groupMessgeTable(id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT, jsonData TEXT, fromId TEXT, toId TEXT, timeStamp TEXT, sendStadus TEXT, readStadus TEXT, hash_jsonData TEXT, hash_allMessage TEXT)";
        if (sqlite3_exec(sqlite3Database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            NSLog(@"createGroupChatMessagetable   erro");
        }else{
            NSLog(@"createGroupChatMessagetable   Ok");
        }
    }else{
        NSLog(@"createGroupChatMessagetable   openDatabaseResult not SQLITE_OK");
    }
    // Close the database.
    sqlite3_close(sqlite3Database);
    NSLog(@"sqlite3Database   ");
}

-(void)dataBaseChanged{
    //[[NSNotificationCenter defaultCenter] postNotificationName:Notice_Tag_DBmanager_dataBaseUpdated object:nil userInfo:nil];
}



-(void)addColumn{
    
    
    NSLog(@"addColumnaddColumnaddColumn");
     // Create a sqlite object.
    sqlite3 *sqlite3Database;
     // Set the database file path.
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
     // Open the database.
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
        //db open code
    
    if(openDatabaseResult == SQLITE_OK) {
        
        sqlite3_stmt *statement;
        BOOL columnExists = NO;
        sqlite3_stmt *selectStmt;
        const char *sqlStatement = "select audioReadStadus from groupMessgeTable";
        if(sqlite3_prepare_v2(sqlite3Database, sqlStatement, -1, &selectStmt, NULL) == SQLITE_OK)
            columnExists = YES;
        
        BOOL checkColumn = columnExists;
        if (checkColumn==YES) {
            NSLog(@"Column alredy added");
            
        }
        else
        {
            
            NSLog(@"Column  add");

            NSString *updateSQL = [NSString stringWithFormat: @"ALTER TABLE groupMessgeTable ADD COLUMN audioReadStadus TEXT"];
            const char *update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(sqlite3Database, update_stmt, -1, &statement, NULL);
            if(sqlite3_step(statement)==SQLITE_DONE)
            {
                NSLog(@"Column added");
                
            }
            else
            {
                NSLog(@"Column not added");
                NSLog(@"Error %s while preparing statement", sqlite3_errmsg(sqlite3Database));
            }
        }
        

    }else{
        NSLog(@"addColumn   openDatabaseResult not SQLITE_OK");
    }

         // Close the database.
         sqlite3_close(sqlite3Database);
}





@end
