//
//  DataFactory.swift
//  FavPlaces
//
//  Created by Magzhan Zhumaly on 18.12.2022.
//

import UIKit
import CoreData

//title;phones;city;address;instagram;whatsapp;e-mails;url
//
//struct  {}

protocol CSVLoadable {
    init?(raw: [String] )
}

struct RestaurantStruct: Identifiable, CSVLoadable {
    
    var title: String = ""
    var phones: String = ""
    var city: String = ""
    var address: String = ""
    var instagram: String = ""
    var whatsapp: String = ""
    var emails: String = ""
    var url: String = ""
    
    var type: String = ""
    var summary: String = ""
    var image: String = ""
    var ratingText: String?
    var isFavorite: Bool = false
    
    var likesCount: Int = 0
    var dislikesCount: Int = 0
    var wasLiked: Bool = false
    var wasDisliked: Bool = false
    
    var id = UUID()
    
    init?(raw: [String]) {
        self.title = raw[0]
        self.phones = raw[1]
        self.city = raw[2]
        self.address = raw[3]
        self.instagram = raw[4]
        self.whatsapp = raw[5]
        self.emails = raw[6]
        self.url = raw[7]
        self.type = "Кафе"
        self.summary = ""
        self.image = raw[0]
        self.isFavorite = false
        self.likesCount = 0
        self.dislikesCount = 0
        self.wasLiked = false
        self.wasDisliked = false
    }
    
}

extension CSVLoadable {
    
    static func loadCSV(from csvName: String) -> [Self] {
        var csvToStruct = [Self]()
        
        // locate the csv file
        guard let filePath = Bundle.main.path(forResource: csvName, ofType: "csv") else {
            return []
        }
        
        // convert the contents of the file to into one very long string
        var data = ""
        do {
            data = try String(contentsOfFile: filePath)
        } catch {
            print(error)
            return []
        }
        
        // split the long string into an array of "rows" of data. Each row is a string
        var rows = data.components(separatedBy: "\n")
        
        // remove header rows
        // count the number of header columns before removing
        let columnCount = rows.first?.components(separatedBy: ";").count
        rows.removeFirst()
        
        // now loop around each row and split into columns
        for row in rows {
            let csvColumns = row.components(separatedBy: ";")
            if csvColumns.count == columnCount {
                let genericStruct = Self.init(raw: csvColumns)
                csvToStruct.append(genericStruct!)
            }
        }
        
        return csvToStruct
    }

}


