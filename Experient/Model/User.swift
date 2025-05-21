//
//  User.swift
//  Experient
//
//  Created by Ricardo Rodríguez on 21/05/25.
//

import Foundation

struct User: Decodable {
    let username: String
    let active: Bool
    let roleId: Int
    let dateCreated: String
    let dateModified: String
    let lastName: String
    let firstName: String
    let displayName: String
    let jiraUsername: String
    let intacctUserId: String
    let userId: Int
    let emailAddress: String
    let openAtCurWeeksTimesheet: Bool
    let activeInterviewer: Bool
    let createIntacctTimesheet: Bool
    let roleName: String
}
