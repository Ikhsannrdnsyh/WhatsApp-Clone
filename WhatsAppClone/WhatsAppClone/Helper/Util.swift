//
//  Util.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 18/08/24.
//

import Foundation

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
