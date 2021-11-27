//
//  Transaction.swift
//  ExpenseTracker
//
//  Created by Mahavir Makwana on 27/11/21.
//

import Foundation

import UIKit

class Transaction: NSObject {

    private struct Key {
        static let kTransactionID       = "transactions_id"
        static let kTransactionTitle       = "title"
        static let kTransactionAmount       = "amount"
        static let kTransactionDate       = "date"
        static let kTransactionCategory       = "category"
    }

    var ID      : Int! = 0
    var title   : String! = ""
    var amount  : Double! = 0.0
    var date    : String! = ""
    var category: String! = ""

    public class func modelsFromDictionaryArray(array:Array<Any>) -> [Transaction]
    {
        var models:[Transaction] = []
        for item in array
        {
            models.append(Transaction(dict: item as? Dictionary<String, Any>))
        }

        return models
    }

    public init(dict : [String : Any]?) {
        self.ID       = dict?[Key.kTransactionID] as? Int ?? 0
        self.title    = dict?[Key.kTransactionTitle] as? String ?? ""
        self.amount   = dict?[Key.kTransactionAmount] as? Double ?? 0.0
        self.date     = dict?[Key.kTransactionDate] as? String ?? ""
        self.category = dict?[Key.kTransactionCategory] as? String ?? ""
    }
}
