//
//  Category.swift
//  ExpenseTracker
//
//  Created by Mahavir Makwana on 27/11/21.
//

import Foundation

import UIKit

class Categories: NSObject {

    private struct Key {
        static let kCategoryID       = "category_id"
        static let kCategoryName       = "name"
        static let kCategoryIsSelected  = "is_selected"
    }

    var ID      : Int! = 0
    var name   : String! = ""
    var isSelected  : Bool! = false

    public class func modelsFromDictionaryArray(array:Array<Any>) -> [Categories]
    {
        var models:[Categories] = []
        for item in array
        {
            models.append(Categories(dict: item as? Dictionary<String, Any>))
        }

        return models
    }

    public init(dict : [String : Any]?) {
        self.ID       = dict?[Key.kCategoryID] as? Int ?? 0
        self.name    = dict?[Key.kCategoryName] as? String ?? ""
        self.isSelected   = dict?[Key.kCategoryIsSelected] as? Bool ?? false
    }
}
