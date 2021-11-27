import UIKit
import SQLite3

final class DBManager: NSObject {
    
    var db: OpaquePointer?
    var fileURL : URL? = nil
    static let databaseVersion = 2
    static var isDatabaseUpdated = false

    static let shared = DBManager()

    private override init() {
        super.init()
        intializeOnce()
    }
    
    func intializeOnce() -> Void {
        createDatabase()
    }
    
    
    //MARK: - Create Database And Tables
    func createDatabase() {
        //print("DBManager.createDatabase()")
        
        fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("ExpenseTracker.sqlite")
        
        var isDatabaseAvailable = false
        if fileURL != nil {
            if FileManager.default.fileExists(atPath: fileURL!.path) {
                //Database Found
                print("Database Found")
                isDatabaseAvailable = true
            }
            else {
                //Database Not Found
                print("Database Not Found")
            }
        }
        
        print("Database Path: \(String(describing: fileURL))")
        if sqlite3_open(fileURL?.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        let databaseVersion = getUserVersion()
        print("Database Version: \(databaseVersion)")
        
        switch databaseVersion {
        case 0:
            //Existing User Before Database Versioning
            
            if isDatabaseAvailable == false {
                //Database not exist so Create now and generate Tables with newly added columns
                if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Transactions (transactions_id INTEGER, title TEXT, amount DOUBLE, date DATE, category TEXT, PRIMARY KEY('transactions_id'))", nil, nil, nil) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error creating table: \(errmsg)")
                }
                
                if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Category (category_id INTEGER, name TEXT, is_selected INTEGER, PRIMARY KEY('category_id'))", nil, nil, nil) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error creating table: \(errmsg)")
                }
            }
            else {
                //modify
            }
            fallthrough
        case 1:
            //New User With Database Versioning
            
            break
        default:
            break
        }
        setUserVersion(version: 1)
    }

    func dropTable(tableName: String) {
        let sSQL = "DROP TABLE IF EXISTS \(tableName)"
        if sqlite3_exec(db, sSQL, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error droping table: \(errmsg)")
        }
    }
    
    
    //MARK: - COMMON QUERY
    func getUserVersion() -> Int {
        // get current database version of schema
        var stmt:OpaquePointer?
        var databaseVersion: Int = 0

        if sqlite3_prepare(db, "PRAGMA user_version;", -1, &stmt, nil) == SQLITE_OK {
            while(sqlite3_step(stmt) == SQLITE_ROW) {
                databaseVersion = Int(sqlite3_column_int(stmt, 0))
                print("Databse Version \(databaseVersion)")
            }
            print("Databse Version After While Statement \(databaseVersion)")
        }
        else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
        sqlite3_finalize(stmt)
        return databaseVersion
    }
    
    func setUserVersion(version: Int) {
        // set new database version of schema
        var stmt:OpaquePointer?
        if sqlite3_prepare(db, "PRAGMA user_version = \(version)", -1, &stmt, nil) == SQLITE_OK {
            print("Databse Version Set")
        }
        else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }

        sqlite3_step(stmt)
        sqlite3_finalize(stmt)
    }
    
    func isColumnExist(in table: String, column name: String? = nil) -> Bool {
        var stmt:OpaquePointer?
        let query = "PRAGMA table_info('\(table)')"
        var isColumnFound = false
        if sqlite3_prepare_v2(db, query,-1,&stmt,nil) == SQLITE_OK {
            
            if name == nil {
                if (sqlite3_step(stmt) == SQLITE_ROW) {
                    isColumnFound = true
                }
            }
            else {
                while (sqlite3_step(stmt) == SQLITE_ROW) {
                    let queryResultCol1 = sqlite3_column_text(stmt, 1)
                    let currentColumnName = String(cString: queryResultCol1!)
                    
                    if currentColumnName == name {
                        isColumnFound = true
                        break
                    }
                }
            }
        }
        sqlite3_step(stmt)
        sqlite3_finalize(stmt)
        return isColumnFound
    }
    
    func getRecordCountForID(_ intID: Int? = nil,_ strID: String? = nil,_ field: String,from table: String) -> Int {
        var count = 0
        var stmt:OpaquePointer?
        if intID != nil {
            //This is used to prevent duplicate record entry for Int Field
            if sqlite3_prepare(db, "SELECT COUNT(*) FROM \(table) WHERE \(field) = \(intID!)", -1, &stmt, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return 0
            }
        }
        else if strID != nil {
            //This is used to prevent duplicate record entry for String Field
            if sqlite3_prepare(db, "SELECT COUNT(*) FROM \(table) WHERE \(field) = '\(strID!)'", -1, &stmt, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return 0
            }
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            count = Int(sqlite3_column_int(stmt, 0))
        }
//        sqlite3_reset(stmt)
//        sqlite3_close(db)
        sqlite3_finalize(stmt)

        return count
    }
    
    
    func deleteAll(from table: String) {
        var stmt:OpaquePointer?
        
        //1. Prepare the sql statement
        var result = sqlite3_prepare_v2(db, "DELETE FROM \(table)", -1, &stmt, nil)
        if(result != SQLITE_OK) {
            print("There's an error in the delete statement:\n%s", sqlite3_errmsg(db))
        }
        //2. Bind the method's parameter value to the sqlStatement's placeholder ?
        //sqlite3_bind_text(compiledStatement, 1, itemName, -1, NULL);
        
        //3. Execute the prepared statement
        result = sqlite3_step(stmt)
        
        if (result != SQLITE_DONE) {
            print("The deletePossession method error:\n%s", sqlite3_errmsg(db))
        }
        //4. Finalize the prepared statement
        sqlite3_finalize(stmt)
    }
    
    func deleteRecords(by strQuery: String) {
        var stmt:OpaquePointer?
        
        //1. Prepare the sql statement
        var result = sqlite3_prepare_v2(db, strQuery, -1, &stmt, nil)
        if(result != SQLITE_OK) {
            print("There's an error in the delete statement:\n%s", sqlite3_errmsg(db))
        }
        //2. Bind the method's parameter value to the sqlStatement's placeholder ?
        //sqlite3_bind_text(compiledStatement, 1, itemName, -1, NULL);
        
        //3. Execute the prepared statement
        result = sqlite3_step(stmt)
        
        if (result != SQLITE_DONE) {
            print("The deletePossession method error:\n%s", sqlite3_errmsg(db))
        }
        //4. Finalize the prepared statement
        sqlite3_finalize(stmt)
    }
    
    func getTotalRecordCount(_ strQuery: String) -> Int {
        if strQuery.isValid == false {
            return -1
        }
        
        var stmt:OpaquePointer?
        var records = 0
        if (sqlite3_open(fileURL?.path, &db) == SQLITE_OK) {
            
            if (sqlite3_prepare_v2(db, strQuery, -1, &stmt, nil) != SQLITE_OK){
                print("Error fetching setting")
                return -1
            }
            if(sqlite3_step(stmt) == SQLITE_ROW) {
                records = Int(sqlite3_column_int(stmt, 0))
                
                sqlite3_reset(stmt)
                sqlite3_close(db)
            }
            else {
                sqlite3_close(db)
            }
            sqlite3_close(db)
        }
        return records

    }
    

    //MARK: - TABLE: Categories
    func insertIntoTransaction(arrTransactions: [Transaction], table: String? = "Transactions") -> Bool {
        if arrTransactions.count == 0 {
            return false
        }
        
        //deleteAll(from: table!)
        //print("insertIntoCategory")
        
        if sqlite3_open(fileURL?.path, &db) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return false
        }
        
        for transaction in arrTransactions {
            
            var stmt: OpaquePointer?
            
            let id = Int32(transaction.ID ?? 0)
            let title = transaction.title ?? ""
            let amount = Double(transaction.amount ?? 0.0)
            let date = transaction.date ?? ""
            let category = transaction.category ?? ""

            if getRecordCountForID(transaction.ID, nil, "transactions_id", from: table!) == 0 {
                //ACTION: RECORD INSERT
                let insertSQL = "INSERT OR REPLACE INTO \(table!) (transactions_id, title, amount, date, category) VALUES ('\(id)', '\(title)', '\(amount)', '\(date)', '\(category)')"

                if sqlite3_open(fileURL?.path, &db) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error preparing insert: \(errmsg)")
                    return false
                }

                if sqlite3_prepare_v2(db, insertSQL, -1, &stmt , nil) != SQLITE_OK {
                    print("error preparing insert: ")
                    return false
                }


                if (sqlite3_step(stmt) == SQLITE_DONE)
                {
                    sqlite3_reset(stmt);
                }
            }
        }
        return true
    }

    func getRecordsFromTransactions(queryString: String? = "") -> [Transaction] {
        //print("getFromCategory")

        var strQuery = "SELECT * FROM Transactions"
        
        if queryString?.isValid == true {
            strQuery = queryString ?? ""
        }

        var arrResult: [Transaction] = []
        var stmt:OpaquePointer?

        if (sqlite3_open(fileURL?.path, &db) == SQLITE_OK) {
            
            if (sqlite3_prepare_v2(db, strQuery, -1, &stmt, nil) != SQLITE_OK){
                print("Error fetching setting")
                return []
            }
            if(sqlite3_step(stmt) == SQLITE_ROW) {
                
                repeat {
                    
                    let transaction = Transaction(dict: nil)

                    for i in 0..<sqlite3_column_count(stmt) {
                        
                        //Check the column type of retured data.
                        //let colType = sqlite3_column_type(stmt, i);

                        switch i {
                        case 0:
                            let id = Int(sqlite3_column_int(stmt, i))
                            transaction.ID = id
                            break
                        case 1:
                            let title = String(cString: sqlite3_column_text(stmt, i))
                            transaction.title = title
                            break
                        case 2:
                            let amount = Double(sqlite3_column_double(stmt, i))
                            transaction.amount = amount
                            break
                        case 3:
                            let date = String(cString: sqlite3_column_text(stmt, i))
                            transaction.date = date
                            break
                        case 4:
                            let category = String(cString: sqlite3_column_text(stmt, i))
                            transaction.category = category
                            break
                        default:
                            break
                        }
                    }
                    arrResult.append(transaction)
                    
                }   while (sqlite3_step(stmt) == SQLITE_ROW);
                
                sqlite3_reset(stmt)
                
                sqlite3_close(db)
            }
            else {
                sqlite3_close(db)
            }
            sqlite3_close(db)
        }
        return arrResult
    }
    //MARK: - TABLE: State
    
    func insertIntoCategory(arrCategory: [Categories]) -> Bool {
        if arrCategory.count == 0 {
            return false
        }

        if sqlite3_open(fileURL?.path, &db) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return false
        }
        
        for obj in arrCategory {
            
            var stmt: OpaquePointer?
            
            let id = obj.ID
            let name = obj.name
            let isSelected = obj.isSelected == true ? 1 : 0

            if getRecordCountForID(obj.ID, nil, "category_id", from: "Category") == 0 {
                let insertSQL = "INSERT OR REPLACE INTO Category (category_id, name, is_selected) VALUES ('\(id ?? 0)', '\(name ?? "")', '\(isSelected )')"

                if sqlite3_open(fileURL?.path, &db) != SQLITE_OK {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error preparing insert: \(errmsg)")
                    return false
                }

                if sqlite3_prepare_v2(db, insertSQL, -1, &stmt , nil) != SQLITE_OK {
                    print("error preparing insert: ")
                    return false
                }


                if (sqlite3_step(stmt) == SQLITE_DONE)
                {
                    sqlite3_reset(stmt);
                }
            }
        }
        return true
    }
    
    //Call This Method To Get All Records From Branch Table
    func getRecordsFromCategory(queryString: String? = "") -> [Categories] {
        //print("getRecordsFromState")
        var strQuery = "SELECT * FROM Category ORDER BY name"
        
        if queryString?.isValid == true {
            strQuery = queryString ?? ""
        }
        
        var arrResult: [Categories] = []
        var stmt:OpaquePointer?
        
        if (sqlite3_open(fileURL?.path, &db) == SQLITE_OK) {
            
            if (sqlite3_prepare_v2(db, strQuery, -1, &stmt, nil) != SQLITE_OK){
                print("Error fetching setting")
                return []
            }
            if(sqlite3_step(stmt) == SQLITE_ROW) {
                
                repeat {
                    let category = Categories(dict: nil)
                    
                    for i in 0..<sqlite3_column_count(stmt) {
                        
                        //Check the column type of retured data.
                        switch i {
                        case 0:
                            let id = Int(sqlite3_column_int(stmt, i))
                            category.ID = id
                            break
                        case 1:
                            let name = String(cString: sqlite3_column_text(stmt, i))
                            category.name = name
                            break
                        case 2:
                            let isSelected = Int(sqlite3_column_int(stmt, i))
                            category.isSelected = isSelected == 1
                            break
                        default:
                            break
                        }
                    }
                    arrResult.append(category)
                    
                }   while (sqlite3_step(stmt) == SQLITE_ROW);
                
                sqlite3_reset(stmt)
                
                sqlite3_close(db)
            }
            else {
                sqlite3_close(db)
            }
            sqlite3_close(db)
        }
        return arrResult
    }
}
