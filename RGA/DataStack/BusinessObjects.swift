//
//  FOContract.swift
//  TestA
//
//  Created by Tancrède on 9/14/16.
//  Copyright © 2016 William Vasconcelos. All rights reserved.
//

import UIKit
import Result
import Realm
import RealmSwift




// MARK: - Data model
/*
 */
typealias JsonDictionary = Dictionary<String, AnyObject>
typealias RGAContactList = Array<RGAContact>




/*
 */
class RGAContact: Object {
    
    
    //
    dynamic var uid: String = NSUUID().UUIDString
    dynamic var name: String = "Tell us your name"
    dynamic var email: String = "you@mail.com"
    dynamic var birthDate: NSDate = NSDate()
    dynamic var bio: String = "What have you been doing recently?"
    dynamic var imageURL: String = ""
    dynamic var imageData: NSData = RGAContactImageSerializer.toData( UIImage.init(named: "user-profile")!)
    
    var image: UIImage {
        get {
            return RGAContactImageSerializer.toUIImage(imageData)
        }
    }
    
    
    
    /*
     */
    convenience init( name: String, email: String, birthDate: NSDate, bio: String, imageURL: String, image: UIImage?){
        self.init()
        
        self.name = name
        self.email = email
        self.birthDate = birthDate
        self.bio = bio
        self.imageURL = imageURL
        
        if image != nil {
            self.imageData = RGAContactImageSerializer.toData( image!)
        }
        
    }
    
    
    
    /*
    */
    override static func primaryKey() -> String? {
        return "uid"
    }

    
}




// MARK: - Tool Kit

/*
 (De)Serializes images into NSData
 No error treatment !!!
 */
struct RGAContactImageSerializer {
    static func toData( image: UIImage) -> NSData {
        return UIImagePNGRepresentation( image)!
    }
    static func toUIImage( data: NSData) -> UIImage {
        return UIImage(data: data)!
    }
}




/*
 Reads the json file and intanciates Contacts
*/
struct RGAContactListJsonParser {
    
    
    // Store the json
    let json: [JsonDictionary]
    
    
    // Date formatter
    let dateFormatter = { (_) -> NSDateFormatter in
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    
    /*
     Keys of the json file
     */
    enum JsonKeys: String {
        case Name = "name"
        case Email = "email"
        case BirthDate = "born"
        case Bio = "bio"
        case PhotoURL = "photo"
    }
    
    
    
    /*
    */
    func parse() -> Result < RGAContactList, RGAParserError>{
        
        
        var contactList = RGAContactList()
        
        
        //
        guard let jsonArray = json as? Array<JsonDictionary> else {
            return .Failure( RGAParserError())
        }
        
        
        // Instanciates ContractList from data in Json
        for jsonItem in jsonArray {
            
            do {
                
                
                // reading the Json
                let name = jsonItem[.Name] as! String
                let email = jsonItem[.Email] as! String
                let birthDate = dateFormatter.dateFromString( jsonItem[.BirthDate] as! String)
                
                if (birthDate == nil) {
                    print("Unable to parse date: \(jsonItem[.BirthDate])")
                    throw RGAParserError(message: "Unable to parse date: \(jsonItem[.BirthDate])")
                }
                
                let bio = jsonItem[.Bio] as! String
                let photoURL = jsonItem[.PhotoURL] as! String
                
                
                // New Contact
                let contract = RGAContact(
                    name: name,
                    email: email,
                    birthDate: birthDate!,
                    bio: bio,
                    imageURL: photoURL,
                    image: nil)
                
                
                //
                contactList.append(contract)
                
                
            } catch let error as NSError {
                
                
                // Warning
                NSLog("Unable to parse Json item: \(jsonItem)")
                NSLog("\(error)")
                
                
            }
            
        }
        
        
        return .Success(contactList)
        
    }
    
}




/*
 Overload Subscript of JsonDictionary to accept a RGAJsonKeys as Index
 */
extension Dictionary where Key: StringLiteralConvertible, Value: AnyObject {
    
    subscript(index: RGAContactListJsonParser.JsonKeys) -> AnyObject {
        get {
            return self[ index.rawValue as! Key] as! AnyObject
        }
    }
    
}




// MARK: - Errors
/*
 */
class RGAError: ErrorType {
    
    var message: String?
    var rootError: ErrorType?
    
    init( message: String? = nil, rootError: ErrorType? = nil){
        self.message = message
        self.rootError = rootError
    }
}
class RGADataStackError: RGAError {}
class RGAGetImageError: RGADataStackError {}
class RGAGetJsonError: RGADataStackError {}
class RGASaveError: RGADataStackError {}
class RGAParserError: RGADataStackError {}
class RGACoreImageError: RGAError {}




// MARK: - NoResult
class NoResult {}




// MARK: - NSDate
/*
 */
extension NSDate {
    
    
    /*
     */
    func yearsTillNow() -> Int {
        
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.Year]
            , fromDate: self
            , toDate: NSDate()
            , options: .WrapComponents)
        
        return dateComponents.year
    }
    
}