//
//  NetworkLogger.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 19/03/2026.
//


import Foundation

class NetworkLogger {
    
    // MARK: - Intercept Request
    static func log(request: URLRequest) {
        print("\n================ 🚀 OUTGOING REQUEST 🚀 ================")
        print("URL: \(request.url?.absoluteString ?? "N/A")")
        print("Method: \(request.httpMethod ?? "N/A")")
        
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("Headers: \(headers)")
        }
        
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
        print("========================================================\n")
    }
    
    // MARK: - Intercept Response
    static func log<T>(response: URLResponse?, data: T?, error: Error?) {
        print("\n================ 🛑 INCOMING RESPONSE 🛑 ================")
        
        if let httpResponse = response as? HTTPURLResponse {
            let statusCode = httpResponse.statusCode
            let icon = (200...299).contains(statusCode) ? "✅" : "❌"
            print("Status Code: \(statusCode) \(icon)")
            print("URL: \(httpResponse.url?.absoluteString ?? "N/A")")
        }
        
        if let error = error {
            print("Error: \(error.localizedDescription)")
        }
        
        if let data = data {
            if let rawData = data as? Data {
                if let jsonObject = try? JSONSerialization.jsonObject(with: rawData, options: .mutableContainers),
                   let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                   let prettyString = String(data: prettyData, encoding: .utf8) {
                    print("JSON Response: \n\(prettyString)")
                } else {
                    print("Raw Data: \(String(data: rawData, encoding: .utf8) ?? "N/A")")
                }
            }
            else {
                print("Parsed Object of type [\(type(of: data))]:")
                dump(data)
            }
        }
        print("=========================================================\n")
    }
}
