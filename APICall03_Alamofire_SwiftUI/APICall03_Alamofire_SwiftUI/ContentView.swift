//
//  ContentView.swift
//  APICall03_Alamofire_SwiftUI
//
//  Created by wonyoul heo on 9/27/24.
//

import SwiftUI

struct ContentView: View {
    @State private var userName = "wnylxx"
    @StateObject private var viewModel = GithubViewModel()
    
    var body: some View {
        VStack {
            TextField("Github username: ", text: $userName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Fetch Data") {
                viewModel.error = nil
                Task.detached {
                    await viewModel.fetchData(username: userName)
                }
            }
            
            if let user = viewModel.user {
                AsyncImage(url: user.avatar_url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                
                Text(user.login)
                    .font(.title2)
                
                Text(user.bio ?? "No bio")
                    .font(.title3)
            }
            
            if let error = viewModel.error {
                Text("Error: \(error)")
                    .foregroundStyle(.red)
            }
            
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
