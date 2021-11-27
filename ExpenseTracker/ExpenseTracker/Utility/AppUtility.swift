//
//  AppUtility.swift
//  ExpenseTracker
//
//  Created by Mahavir Makwana on 27/11/21.
//

import Foundation
import UIKit

final class AppUtility: NSObject {

    static let shared  = AppUtility()
    public static var sharedAppDel : AppDelegate! {
        return UIApplication.shared.delegate as? AppDelegate
    }

    var loginNavController : UINavigationController?
    var homeNavController : UITabBarController?


    class func STORY_BOARD() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }

    class func SCREEN_WIDTH() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }

    class func SCREEN_HEIGHT() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }

    var arrCategory: [Categories] = []

    //MARK: -
    private override init() {
        super.init()
        print("Initialize shared Utility")
        intializeOnce()
    }


    func intializeOnce() -> Void {
        arrCategory = [
            Categories(dict: ["category_id": 1, "name" : "Food","is_selected" : false]),
            Categories(dict: ["category_id": 2, "name" : "Gifts","is_selected" : false]),
            Categories(dict: ["category_id": 3, "name" : "Cloths","is_selected" : false]),
            Categories(dict: ["category_id": 4, "name" : "Fuel","is_selected" : false]),
            Categories(dict: ["category_id": 5, "name" : "Kids","is_selected" : false]),
            Categories(dict: ["category_id": 6, "name" : "Sports","is_selected" : false]),
            Categories(dict: ["category_id": 7, "name" : "Travel","is_selected" : false])
        ]
    }

}
