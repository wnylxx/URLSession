//
//  ViewModel.swift
//  APICall02_AsyncAwait_SwiftUI
//
//  Created by wonyoul heo on 9/26/24.
//

import Foundation

@MainActor
class GithubViewModel: ObservableObject {
    @Published var user: User?
    @Published var repositories: [Repository] = []
    @Published var error: Error?
    
    let githubService = GithubService()
    
    func fetchData(username: String) async {
        do {
            async let fetchUser = githubService.fetchUser(username: username)
            async let fetchRepos = githubService.fetchRepositories(username: username)
            
            user = try await fetchUser
            repositories = try await fetchRepos
        } catch {
            self.error = GithubServiceError.failtoFetchData
        }
    }
    
}


actor GithubService {
    func fetchUser(username: String) async throws -> User {
        let endPoint = "https://api.github.com/users/\(username)"
        
        guard let url = URL(string: endPoint) else {
            throw GitHubAPIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GitHubAPIError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            return try decoder.decode(User.self, from: data)
        } catch {
            throw GitHubAPIError.invalidData
        }
    }
    
    func fetchRepositories(username: String) async throws -> [Repository] {
        let endPoint = "https://api.github.com/users/\(username)/repos"
        
        guard let url = URL(string: endPoint) else {
            throw GitHubAPIError.invalidURL
        }
        
        let (data,response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GitHubAPIError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            
            return try decoder.decode([Repository].self, from: data)
        } catch {
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
