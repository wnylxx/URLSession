//
//  ContentView.swift
//  APICall_AsyncAwait_SwiftUI
//
//  Created by wonyoul heo on 9/25/24.
//

import SwiftUI

struct ContentView: View {
    @State private var user: GitHubUser?
    
    var body: some View {
        VStack(spacing: 20) {
            
            AsyncImage(url: URL(string: user?.avatarUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .foregroundStyle(.secondary)
            }
            .frame(width: 120, height: 120)
            
            Text(user?.login ?? "No Login")
                .bold()
                .font(.title3)
            
            Text(user?.bio ?? "Please enter the valid ID")
                .padding()
            Spacer()
        }
        .padding()
        .task {
            do {
                user = try await getUser()
            } catch {
                switch error {
                case GitHubAPIError.invalidURL:
                    print("invalid URL")
                case GitHubAPIError.invalidResponse:
                    print("invalid Response")
                case GitHubAPIError.invalidData:
                    print("invalid Data")
                default:
                    print("unexpected error")
                }
            }
            
        }
    }
    
    
    func getUser() async throws -> GitHubUser {
        let endpoint = "https://api.github.com/users/wnylxx"
        
        guard let url = URL(string: endpoint) else {
            throw GitHubAPIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GitHubAPIError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            // avatarUrl의 경우 camel case 로 우리가 설정했는데 실제로 JSON으로 받는 데이터는 snake case 이다.
            return try decoder.decode(GitHubUser.self, from: data)
        } catch {
            throw GitHubAPIError.invalidData
        }
    }
    
}



struct GitHubUser: Codable {
    // 데이터를 받아오는 작업만 할 것이라 Decodable 써도 상관 없음
    let login: String
    let avatarUrl: String
    let bio: String
}




enum GitHubAPIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}



#Preview {
    ContentView()
}
