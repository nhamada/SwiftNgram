//
//  SwiftNgram.swift
//  SwiftNgram
//
//  Created by Naohiro Hamada on 2016/10/13.
//
//

import Foundation

public struct SwiftNgram {
    func parse(filepath: String, length: Int) -> [String] {
        guard FileManager.default.fileExists(atPath: filepath) else {
            print("File \"\(filepath)\" does not exist.")
            return []
        }
        let url = URL(fileURLWithPath: filepath)
        guard let contents = try? String(contentsOf: url) else {
            fatalError()
        }
        return parse(contents, length: length)
    }
    
    func parse(_ string: String, length: Int) -> [String] {
        var words = [String]()
        let characters = string.characters
        for index in 0..<(characters.count - length) {
            let start = string.index(string.startIndex, offsetBy: index)
            let end = string.index(start, offsetBy: length)
            let word = string.substring(with: Range(uncheckedBounds: (start, end)))
            words.append(word)
        }
        return words
    }
}
