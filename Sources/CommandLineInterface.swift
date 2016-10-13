//
//  CommandLineInterface.swift
//  SwiftNgram
//
//  Created by Naohiro Hamada on 2016/10/13.
//
//

import Foundation

struct SwiftNgramOption {
    let wordCount: Int
    let filepath: String
}

private protocol ExecutableOption {
    var shortName: String { get }
    var longName: String { get }
    var help: String { get }
    var value: String { get set }
}

private struct SwiftNgramCommandLineOption: ExecutableOption {
    let shortName: String
    let longName: String
    let help: String
    var value: String
    
    init(shortName: String, longName: String, help: String) {
        self.shortName = shortName
        self.longName = longName
        self.help = help
        self.value = ""
    }
}

func parseCommandLine() -> SwiftNgramOption {
    let availableOptions = [
        SwiftNgramCommandLineOption(shortName: "-n", longName: "--number", help: ""),
        SwiftNgramCommandLineOption(shortName: "", longName: "", help: ""),
        ]
    
    let options: [SwiftNgramCommandLineOption] = Array(CommandLine.arguments.dropFirst()).map {
        for opt in availableOptions {
            if opt.shortName.isEmpty {
                var ret = opt
                ret.value = $0
                return ret
            }
            switch $0 {
            case let x where x.hasPrefix(opt.shortName) || x.hasPrefix(opt.longName):
                let components = x.components(separatedBy: "=")
                guard components.count == 2 else {
                    print("Invalid format '\(components[0])'")
                    abort()
                }
                var ret = opt
                ret.value = components[1]
                return ret
            default:
                break
            }
        }
        print("Invalid options.")
        abort()
    }
    let wordCount: Int = options.reduce(2) {
        if $0.1.shortName == "-n" {
            guard let count = Int.init($0.1.value) else {
                print("Option '-n' did not a number.")
                abort()
            }
            return count
        } else {
            return $0.0
        }
    }
    let filepath = options.reduce("") {
        return $0.1.shortName.isEmpty ? $0.1.value : $0.0
    }
    return SwiftNgramOption(wordCount: wordCount, filepath: filepath)
}

extension SwiftNgram {
    func run() {
        let option = parseCommandLine()
        let words = parse(filepath: option.filepath, length: option.wordCount)
        for w in words {
            print(w)
        }
    }
}
