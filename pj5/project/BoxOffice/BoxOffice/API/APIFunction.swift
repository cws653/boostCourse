//
//  Function.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/09/04.
//  Copyright © 2020 최원석. All rights reserved.
//

import Foundation

class MovieService {
    
    var baseURL: String {
        return "http://connect-boxoffice.run.goorm.io/"
    }
    
    func getJsonFromUrlWithFilter(filterType: filteringMethod,  completion:@escaping ([Movies]) -> Void) {
        let baseWithFilterTypeURL = baseURL + "movies?order_type=" + "\(filterType.rawValue)"
        guard let url = URL(string: baseWithFilterTypeURL) else {return}
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) {(datas, response, error) in
            if error != nil {
                print("Network Error")
            }
            guard let data = datas else {return}
            
            do {
                let order = try JSONDecoder().decode(MovieList.self, from: data)
                completion(order.movies)
            } catch {
                print("JSON Parising Error")
            }
        }
        dataTask.resume()
    }
    
    func getJsonFromUrlMovieDetail(movieId: String, completion:@escaping ([DetailContents]) -> Void) {
        let baseWithFilterTypeURL = baseURL+"movie?id="+"\(movieId)"
        guard let url = URL(string: baseWithFilterTypeURL) else {return}
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) {(datas, response, error) in
            if error != nil {
                print("Network Error")
            }
            guard let data = datas else {return}
            
            do {
                let order = try JSONDecoder().decode(DetailContents.self, from: data)
                completion([order])
            } catch {
                print("JSON Parising Error")
            }
        }
        dataTask.resume()
    }
    
    
    func getJsonFromUrlWithMoiveId(movieId: String, completion:@escaping (CommentList?) -> Void) {
        let baseWithFilterTypeURL = baseURL+"comments?movie_id="+"\(movieId)"
        
        guard let url = URL(string: baseWithFilterTypeURL) else {return}
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) {(datas, response, error) in
            if error != nil {
                print("Network Error")
            }
            guard let data = datas else {return}
            do {
                let order = try JSONDecoder().decode(CommentList.self, from: data)
                
                completion(order)
            } catch {
                print("JSON Parising Error")
            }
        }
        dataTask.resume()
    }
}
