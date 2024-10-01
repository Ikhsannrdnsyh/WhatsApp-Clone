//
//  Util.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 18/08/24.
//

import Foundation

//MARK: - File utils

func fileNameFrom(_ url: String) -> String{
    let fileName = ((url.components(separatedBy: "_").last)?.components(separatedBy: "?").first)?.components(separatedBy: ".").first
    return fileName ?? ""
}


func fileExistAtPath(_ fileName: String) -> Bool {
    return FileManager.default.fileExists(atPath: fileDocumentsDirectory(fileName: fileName))
}

func fileDocumentsDirectory(fileName: String) -> String {
    return getDocumentsUrl().appendingPathComponent(fileName).path
}

func getDocumentsUrl() -> URL{
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}

//MARK: - Date Utils


func timeElapse(date: Date) -> String {
    let seconds = Date().timeIntervalSince(date)
    
    var elapsed = ""
    if seconds < 60 {
        elapsed = "Just now"
    } else if seconds < 60 * 60 {
        let minutes = Int(seconds/60)
        let minText = minutes > 1 ? "mins" : "min"
        elapsed = "\(minutes) \(minText)"
    } else if seconds < 24 * 60 * 60 {
        let hours = Int(seconds/(60 * 60))
        let hoursText = hours > 1 ? "hours" : "hour"
        elapsed = "\(hours) \(hoursText)"
    } else{
        elapsed = date.longDate()
    }
    return elapsed
}
