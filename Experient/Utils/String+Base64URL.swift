//
//  String+Base64URL.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//
import Foundation

extension String {

    /// Converts a part of JWT Base64URL-encoded string into Data (standard Base64 format)
    func jwtBase64URLDecodedData() -> Data? {
        var base64 = self
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let paddingLength = 4 - (base64.count % 4)
        if paddingLength < 4 {
            base64 += String(repeating: "=", count: paddingLength)
        }
        
        return Data(base64Encoded: base64)
    }
}
