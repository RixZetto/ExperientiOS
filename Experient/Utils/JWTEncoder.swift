//
//  JWTEncoder.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//
import Foundation

class JWTEncoder {
    
    static func encode(header: [String: Any],
                       payload: [String: Any],
                       signature: String) -> String {
        func base64Encode(_ json: [String: Any]) -> String {
            let data = try! JSONSerialization.data(withJSONObject: json, options: [])
            return data.jwtBase64EncodedString()
        }
        
        let headerBase64 = base64Encode(header)
        let payloadBase64 = base64Encode(payload)
        
        return [headerBase64, payloadBase64, signature].joined(separator: ".")

    }
    
}
