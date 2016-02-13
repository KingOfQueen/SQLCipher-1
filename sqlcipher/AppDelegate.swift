//
//  AppDelegate.swift
//  sqlcipher
//
//  Created by leeey on 16/2/13.
//  Copyright © 2016年 leeey. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let db = DBUserManager.sharedInstance.openUserDB()!
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let name = "name" + String(Int(NSDate().timeIntervalSince1970))
        let insertSql = "insert into mytable (name)values('\(name)')" //param暂时为空，稍后处理
        self.db.executeStatements(insertSql)
        let sqlParks = "select * from mytable "
        let rs = db.executeQuery(sqlParks,withArgumentsInArray:nil)!
        while (rs.next() != false){
            print(rs.stringForColumn("name"))
        }
        // Override point for customization after application launch.
        return true
    }
    
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}




class DBUserManager: NSObject {
    var database: FMDatabase?
    let fm = NSFileManager.defaultManager()
    static let sharedInstance = DBUserManager()
    private override init() {}
    func openUserDB() -> FMDatabase? {
        let db = "data.db"
        let docPath = NSURL( fileURLWithPath: (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] )).URLByAppendingPathComponent(db).path!
        print("数据库地址："+docPath)
        database = FMDatabase(path:docPath)
        if (fm.fileExistsAtPath(docPath)) {
            if database!.open() {
                return database!
            }else{
                print("无法打开数据库")
                database = nil
            }
        }else{ //初始化数据库，建表
            database!.open()
            let sql = "CREATE TABLE mytable (id integer PRIMARY KEY NOT NULL,name char(128));"
            database?.executeStatements(sql)
            return database!
        }
        return database
    }
    
    func closeDB() {
        if let db = database {
            db.close()
            database = nil
        }
    }
    
    deinit {
        closeDB()
    }
}

