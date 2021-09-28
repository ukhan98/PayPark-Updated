//
//  Formatter.swift
//  PayPark
//
//  Created by mac owner on 2020-11-24.
//

import Foundation

struct Formatter{
    
    func simplifiedDateDormatter(date: Date) -> String{
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        dateFormatter.locale = Locale(identifier: "en_US")
//        dateFormatter.locale = Locale(identifier: "fr_FR")

        return dateFormatter.string(from: date)
    }
}
