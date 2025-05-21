//
//  Data+Base64URL.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//
import Foundation

extension Data {
    
    func jwtBase64EncodedString() -> String {
        return self.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

}
