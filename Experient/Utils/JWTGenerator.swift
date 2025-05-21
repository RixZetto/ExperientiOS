//
//  JWTGenerator.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//
import Foundation

class JWTGenerator {
    
    static func generate(name: String, expirationInSeconds: TimeInterval) -> String {
        let expirationDate = Date().addingTimeInterval(expirationInSeconds)
        let header = ["alg": "HS256", "typ": "JWT"]
        let payload: [String: Any] = [
            "sub": UUID().uuidString,
            "name": name,
            "iat": Int(Date().timeIntervalSince1970),
            "exp": Int(expirationDate.timeIntervalSince1970)]
        
        let jwt = JWTEncoder.encode(header: header, payload: payload, signature: "demo_fake_signature")
        return jwt
    }
    
}
