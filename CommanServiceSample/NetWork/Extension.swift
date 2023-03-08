//
//  Extensions.swift
//  sampleCommanService
//
//  Created by MacBook on 2023-03-08.
//

import Foundation
import SwiftUI


private let characterEntities : [ Substring : Character ] = [
    // XML predefined entities:
    "&quot;"    : "\"",
    "&amp;"     : "&",
    "&apos;"    : "'",
    "&lt;"      : "<",
    "&gt;"      : ">",

    // HTML character entity references:
    "&nbsp;"    : "\u{00a0}",
    // ...
    "&diams;"   : "♦",
]
extension Dictionary {
    func encoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}
extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
extension String {
    public var removeHTML: String {
        let string: String = self
        let decoded = string.stringByDecodingHTMLEntities
        let summary = decoded.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return summary.replacingOccurrences(of: "&", with: "-")
    }
    
    public var removeXML: String {
        
        
        
        let greeting = "Hello World"
        
        let strData: String = self
        var startIndex:Range<String.Index>? = nil
        var endIndex:Range<String.Index>? = nil
        if strData.contains("</string>") {
             startIndex = strData.range(of: "<string xmlns=\"http://tempuri1.org/\">")
             endIndex = strData.range(of: "</string>")
        } else if strData.contains("</int>") {
             startIndex = strData.range(of: "<int xmlns=\"http://tempuri1.org/\">")
             endIndex = strData.range(of: "</int>")
        } else {
            return strData
        }
        
        let sub = strData[(startIndex?.upperBound ?? greeting.startIndex)..<endIndex!.lowerBound]
        return String(sub)
    }
    
    
    
   
    /// Returns a new string made by replacing in the `String`
    /// all HTML character entity references with the corresponding
    /// character.
    var stringByDecodingHTMLEntities : String {


        func decodeNumeric(_ string : Substring, base : Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }

        func decode(_ entity : Substring) -> Character? {

            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X") {
                return decodeNumeric(entity.dropFirst(3).dropLast(), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.dropFirst(2).dropLast(), base: 10)
            } else {
                return characterEntities[entity]
            }
        }

        // ===== Method starts here =====

        var result = ""
        var position = startIndex

        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self[position...].range(of: "&") {
            result.append(contentsOf: self[position ..< ampRange.lowerBound])
            position = ampRange.lowerBound

            // Find the next ';' and copy everything from '&' to ';' into `entity`
            guard let semiRange = self[position...].range(of: ";") else {
                // No matching ';'.
                break
            }
            let entity = self[position ..< semiRange.upperBound]
            position = semiRange.upperBound

            if let decoded = decode(entity) {
                // Replace by decoded character:
                result.append(decoded)
            } else {
                // Invalid entity, copy verbatim:
                result.append(contentsOf: entity)
            }
        }
        // Copy remaining characters to `result`:
        result.append(contentsOf: self[position...])
        return result
    }
}
public struct ZiksaError: Error {
    let msg: String

}

extension ZiksaError: LocalizedError {
    public var errorDescription: String? {
            return NSLocalizedString(msg, comment: "")
    }
}
extension View {
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        NavigationView {
            ZStack {
                self
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                   
                NavigationLink(
                    destination: view
                        .navigationBarTitle("")
                        .navigationBarHidden(true),
                    isActive: binding
                ) {
                    EmptyView()
                }
            }
        } .navigationViewStyle(StackNavigationViewStyle())
    }
}
