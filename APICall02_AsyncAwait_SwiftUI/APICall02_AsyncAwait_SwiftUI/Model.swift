//
//  Model.swift
//  APICall02_AsyncAwait_SwiftUI
//
//  Created by wonyoul heo on 9/26/24.
//

import Foundation


struct User: Codable {
    let login: String
    let avatarUrl: URL
    let bio: String?
}

struct Repository: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
}
