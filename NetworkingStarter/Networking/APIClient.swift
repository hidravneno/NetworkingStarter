//
//  APIClient.swift
//  NetworkingStarter
//
//  Created by francisco eduardo aramburo reyes on 21/10/25.
//

import Foundation

struct APIClient {
    var baseURL: URL = URL(string: "https://jsonplaceholder.typicode.com")!

    func fetchPosts(userID: Int?) async throws -> [Post] {
        var components = URLComponents(url: baseURL.appendingPathComponent("posts"), resolvingAgainstBaseURL: false)!
        if let userID = userID {
            components.queryItems = [URLQueryItem(name: "userId", value: String(userID))]
        }
        // https://jsonplaceholder.typicode.com/posts?userId=1
        let url = components.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 15

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([Post].self, from: data)
    }
}
