//
//  Functions.swift
//  Koray Birand Digital
//
//  Created by Koray Birand on 4/6/15.
//  Copyright (c) 2015 Koray Birand. All rights reserved.
//

import Foundation

extension OutputStream {
    
    /// Write String to outputStream
    ///
    /// :param: string                The string to write.
    /// :param: encoding              The NSStringEncoding to use when writing the string. This will default to UTF8.
    /// :param: allowLossyConversion  Whether to permit lossy conversion when writing the string.
    ///
    /// :returns:                     Return total number of bytes written upon success. Return -1 upon failure.
    
    func write(_ string: String, encoding: String.Encoding = String.Encoding.utf8, allowLossyConversion: Bool = true) -> Int {
        if let data = string.data(using: encoding, allowLossyConversion: allowLossyConversion) {
            var bytes = (data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count)
            var bytesRemaining = data.count
            var totalBytesWritten = 0
            
            while bytesRemaining > 0 {
                let bytesWritten = self.write(bytes, maxLength: bytesRemaining)
                if bytesWritten < 0 {
                    return -1
                }
                
                bytesRemaining -= bytesWritten
                bytes += bytesWritten
                totalBytesWritten += bytesWritten
            }
            
            return totalBytesWritten
        }
        
        return -1
    }
    
}

extension Date {
    
    // you can create a read-only computed property to return just the nanoseconds as Int
    var nanosecond: Int { return (Calendar.current as NSCalendar).component(.nanosecond,  from: self)   }
    
    // or an extension function to format your date
    func formattedWith(_ format:String)-> String {
        let formatter = DateFormatter()
        //formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)  // you can set GMT time
        formatter.timeZone = TimeZone.autoupdatingCurrent        // or as local time
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
}

class koray {
    
    class func listFilesFromDocumentsFolder() {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        var documentsDirectory : String;
        documentsDirectory = paths[0]
        let fileManager: FileManager = FileManager()
        
        var fileList : NSArray!
        do {
            fileList =  try fileManager.contentsOfDirectory(atPath: documentsDirectory) as NSArray
        } catch {
            print("Something went wrong")
            fileList = nil
        }
        
        
        
        let filesStr: NSMutableString = NSMutableString(string: "Files in Documents folder \n")
        for s in fileList {
            filesStr.appendFormat("%@", s as! String)
        }
        
        print(filesStr)
    }
    
    
    class func leftString(_ theString: String, charToGet: Int) ->String{
        
        var indexCount = 0
        let strLen = theString.count
        
        if charToGet > strLen { indexCount = strLen } else { indexCount = charToGet }
        if charToGet < 0 { indexCount = 0 }
        
        let index: String.Index = theString.index(theString.startIndex, offsetBy: indexCount)
        let mySubstring:String = String(theString[..<index])
        
        return mySubstring
        
    }
    
    class func rightString(_ theString: String, charToGet: Int) ->String{
        
        var indexCount = 0
        let strLen = theString.count
        let charToSkip = strLen - charToGet
        
        if charToSkip > strLen { indexCount = strLen } else { indexCount = charToSkip }
        if charToSkip < 0 { indexCount = 0 }
        let index: String.Index = theString.index(theString.startIndex, offsetBy: indexCount)
        let mySubstring:String = String(theString[index...])
        
        
        return mySubstring
    }
    
    class func midString(_ theString: String, startPos: Int, charToGet: Int) ->String{
        
        let strLen = theString.count
        let rightCharCount = strLen - startPos
        var mySubstring = koray.rightString(theString, charToGet: rightCharCount)
        mySubstring = koray.leftString(mySubstring, charToGet: charToGet)
        
        return mySubstring
        
    }
    
    
    
    
    

    
    
}
