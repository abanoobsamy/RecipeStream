//
//  RecipeRouter.swift
//  RecipeStream
//
//  Created by Abanoob Samy on 20/03/2026.
//


import Foundation
import Alamofire

enum RecipeRouter: URLRequestConvertible {

    // Endpoints func
    case getAllRecipes(parameters: Parameters?)
    case getRecipeDetails(id: Int)
    case createRecipe(parameters: Parameters?)
    case searchRecipes(parameters: Parameters?)
    
    var baseURL: URL {
        return URL(string: "https://dummyjson.com")!
    }
    
    // Endpoints path
    var path: String {
        switch self {
        case .getAllRecipes:
            return "/recipes"
        case .getRecipeDetails(let id):
            return "/recipes/\(id)"
        case .searchRecipes:
            return "/recipes/search"
        case .createRecipe(parameters: let parameters):
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllRecipes, .getRecipeDetails, .searchRecipes:
            return .get
        case .createRecipe:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getAllRecipes(let params), .searchRecipes(let params), .createRecipe(let params):
            return params
        case .getRecipeDetails:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default // Query Parameters
        default:
            return JSONEncoding.default // Body Parameters
        }
    }
    
    var headers: HTTPHeaders? {
        return [
            "Content-Type": "application/json",
//            "Authorization": "Bearer ACCESS_TOKEN"
        ]
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        
        request.method = method
        request.headers = headers ?? []
        
        if let parameters = parameters {
            request = try encoding.encode(request, with: parameters)
        }
        
        return request
    }
}
