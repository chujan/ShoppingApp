//
//  APICallers.swift
//  Shopping
//
//  Created by Jennifer Chukwuemeka on 06/12/2022.
//

import Foundation
class APICaller {
    static let shared = APICaller()
    
    func getCategory(completion: @escaping (Result<categoryResponse, Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/products") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(categoryResponse.self, from: data)
                completion(.success(results))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getFurniture(completion: @escaping (Result<NewArrivalResponse, Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/products/category/furniture") else  {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(NewArrivalResponse.self, from: data)
                completion(.success(results))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getTopItem(completion: @escaping (Result<TopItemResponse, Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/products/search?q=z") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TopItemResponse.self, from: data)
                completion(.success(results))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    func getSearch(completion: @escaping (Result<[TopItem], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/products/search?q=v") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TopItemResponse.self, from: data)
                completion(.success(results.products))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
                 
    }
    func getSearchResult(with query: String,completion: @escaping (Result<[TopItem], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/products/search?q=\(query)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TopItemResponse.self, from: data)
                completion(.success(results.products))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}
