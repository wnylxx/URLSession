//
//  ViewModel.swift
//  APICall03_Alamofire_SwiftUI
//
//  Created by wonyoul heo on 9/27/24.
//

import Foundation
import Alamofire



@MainActor
class GithubViewModel: ObservableObject {
    @Published var user: User?
    @Published var error: Error?
    
    let githubService = GithubService()
    
    func fetchData(username: String) async {
        do {
            async let fetchUser = githubService.fetchUser(username: username)
            
            user = try await fetchUser
        } catch {
            self.error = GithubServiceError.failtoFetchData
        }
    }
}



actor GithubService {
    
    func fetchUser(username: String) async throws -> User {
        let endPoint = "https://api.github.com/users/\(username)"
        
        let response = await AF.request(endPoint)
            .validate(statusCode: 200..<300)
            .serializingDecodable(User.self)
            .response
        
        switch response.result {
        case .success(let user):
            
            return user
            
        case .failure(let error):
            print("API request failed with error: \(error)")
            throw GitHubAPIError.invalidResponse
        }
    }
    
}




enum GitHubAPIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

enum GithubServiceError: Error {
    case failtoFetchData
}
