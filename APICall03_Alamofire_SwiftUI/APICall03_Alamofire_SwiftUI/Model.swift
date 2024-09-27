//
//  Model.swift
//  APICall03_Alamofire_SwiftUI
//
//  Created by wonyoul heo on 9/27/24.
//

import Foundation

struct User: Codable {
    let login: String
    let avatar_url: URL
    let bio: String?
}

struct Repository: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
}
