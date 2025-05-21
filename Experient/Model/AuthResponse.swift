//
//  AuthResponse.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//

struct AuthResponse: Decodable {
    let user: User
    let accessToken: String
    let refreshToken: String
}
