//
//  Restaraunt.swift
//  FavPlaces
//
//  Created by Magzhan Zhumaly on 24.11.2022.
//


import CoreData

public class Restaurant: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
    }

    @NSManaged public var name: String
    @NSManaged public var type: String
    @NSManaged public var location: String
    @NSManaged public var phones: String

    @NSManaged public var summary: String
    @NSManaged public var image: Data
    @NSManaged public var ratingText: String?
    @NSManaged public var isFavorite: Bool
    
    @NSManaged public var city: String
    
    @NSManaged public var instagram: String?
    @NSManaged public var whatsapp: String?
    @NSManaged public var emails: String?
    @NSManaged public var url: String?
    
    @NSManaged public var likesCount: Int
    @NSManaged public var dislikesCount: Int
    @NSManaged public var wasLiked: Bool
    @NSManaged public var wasDisliked: Bool
    @NSManaged public var ratingPercent: Double

    
//    @NSManaged public var type: String?
//    @NSManaged public var summary: String?
    //title;phones;city;address;instagram;whatsapp;e-mails;url

    /*
    @NSManaged public var city: String
    
    @NSManaged public var instagram: String?
    @NSManaged public var whatsapp: String?
    @NSManaged public var emails: String?
    @NSManaged public var url: String?
    
    @NSManaged public var type: String?
    @NSManaged public var summary: String?
*/
    
//    var id = UUID()

    /*
    init(raw: [String]) {
        self.name = raw[0]
        self.type = raw[1]
        self.location = raw[2]
        self.phone = raw[3]
        self.summary = raw[4]
        if let imageData =  UIImage(named: raw[5])!.pngData() {
            self.image = imageData
        }
        self.ratingText = raw[6]
        self.isFavorite = false
    }*/
}
/*
func loadCSV(from csvName: String) -> [Restaurant] {
    var csvToStruct = [Restaurant]()
    
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
    let columnCount = rows.first?.components(separatedBy: ",").count
    rows.removeFirst()
    
    // now loop around each row and split into columns
    for row in rows {
        let csvColumns = row.components(separatedBy: ",")
        if csvColumns.count == columnCount {
            let restaurantStruct = Restaurant.init(raw: csvColumns)
            csvToStruct.append(restaurantStruct)
        }
    }
    
    return csvToStruct
}
*/
//public class Restaurant: NSManagedObject {
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
//        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
//    }
// 
//    @NSManaged public var name: String
//    @NSManaged public var type: String
//    @NSManaged public var location: String
//    @NSManaged public var phone: String
//    @NSManaged public var summary: String
//    @NSManaged public var image: Data
//    @NSManaged public var ratingText: String?
//    @NSManaged public var isFavorite: Bool
//}

extension Restaurant {
 
    enum Rating: String {
        case awesome
        case good
        case okay
        case bad
        case terrible
 
        var image: String {
            switch self {
            case .awesome: return "love"
            case .good: return "cool"
            case .okay: return "happy"
            case .bad: return "sad"
            case .terrible: return "angry"
            }
        }
    }
 
    var rating: Rating? {
        get {
            guard let ratingText = ratingText else {
                return nil
            }
 
            return Rating(rawValue: ratingText)
        }
 
        set {
            self.ratingText = newValue?.rawValue
        }
    }
}



/* old way
struct Restaurant: Hashable {
    var name: String = ""
    var type: String = ""
    var location: String = ""
    var phone: String = ""
    var description: String = ""
    var image: String = ""
    var isFavorite: Bool = false
    var rating: Rating?
 
    enum Rating: String {
        case awesome
        case good
        case okay
        case bad
        case terrible
        
        var image: String {
            switch self {
            case .awesome: return "love"
            case .good: return "cool"
            case .okay: return "happy"
            case .bad: return "sad"
            case .terrible: return "angry"
            }
        }
    }

    init(name: String, type: String, location: String, phone: String, description: String, image: String, isFavorite: Bool) {
        self.name = name
        self.type = type
        self.location = location
        self.phone = phone
        self.description = description
        self.image = image
        self.isFavorite = isFavorite
    }
 
    init() {
        self.init(name: "", type: "", location: "", phone: "", description: "", image: "", isFavorite: false)
    }
}
*/
