//
//  APICaller.swift
//  NewsAPI
//
//  Created by Saruar on 06.03.2023.
//

import Foundation


final class APICaller{
    
    static let shared = APICaller()
    
    
    struct Constants{
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=8897129d6fc84f1f9378b45f46b539fc")
        
        static let topHeadlinesPublishedURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=8897129d6fc84f1f9378b45f46b539fc&sortBy=published")
        
        static let searchURL =  "https://newsapi.org/v2/everything?sortBy=popularity&apiKey=8897129d6fc84f1f9378b45f46b539fc&q="
        
        static let searchURLPublished = "https://newsapi.org/v2/everything?sortBy=publishedAt&apiKey=8897129d6fc84f1f9378b45f46b539fc&q="
    }
    
    private init(){}
    
    public func getTopStories(completion: @escaping(Result<[Article], Error>) -> Void){
        guard let url = Constants.topHeadlinesURL else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }
            else if let data = data{
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
        
                    completion(.success(result.articles))
                }catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func getTopStoriesPublished(completion: @escaping(Result<[Article], Error>) -> Void){
        guard let url = Constants.topHeadlinesPublishedURL else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }
            else if let data = data{
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
        
                    completion(.success(result.articles))
                }catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    
    
    public func searchStoriesSortByPublished(with query: String, completion: @escaping(Result<[Article], Error>) -> Void){
        
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        let urlstring = Constants.searchURLPublished + query
        
        guard let url = URL(string: urlstring) else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }
            else if let data = data{
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                }catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    
    
    public func searchStories(with query: String, completion: @escaping(Result<[Article], Error>) -> Void){
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        let urlstring = Constants.searchURL + query
        
        guard let url = URL(string: urlstring) else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }
            else if let data = data{
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
        
                    completion(.success(result.articles))
                }catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    
    
}


struct APIResponse: Codable{
    let articles: [Article]
}

struct Article: Codable{
    let source: Source
    let title: String
    let author: String?
    let description: String?
    let urlToImage: String?
    let url: String?
    let publishedAt: String?
}

struct Source: Codable{
    let id: String?
    let name: String?
}
