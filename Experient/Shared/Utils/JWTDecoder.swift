//
//  JWTDecoder.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//
import Foundation

class JWTDecoder {
    
    /**
    This method will parse the token and get the expiration date
     */
    func decodeJWTExpiration(from token: String) -> Date? {
        let segments = token.split(separator: ".")
        guard segments.count == 3 else { return nil }
        
        guard let data = String(segments[1]).jwtBase64URLDecodedData(),
              let payload = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let exp = payload["exp"] as? TimeInterval else {
            return nil
        }
        
        return Date(timeIntervalSince1970: exp)
    }
    
}
