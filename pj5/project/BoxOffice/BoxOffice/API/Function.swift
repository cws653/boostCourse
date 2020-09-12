//
//  Function.swift
//  BoxOffice
//
//  Created by 최원석 on 2020/09/04.
//  Copyright © 2020 최원석. All rights reserved.
//

import Foundation

/*
 open - 전부허용
 public - 상속 X
 ------ 프레임워크
 internal - 다른프레임워크 접근불가, 현재 프레임워크에선 전부 접근가능
 private -
 fileprivate - 현재파일에서만 접근
 */

//protocol SendDataDeleagate {
//    func sendData(data: [Movies])
//}


class MovieService {
    
//    let DidReceiveMoviesNotification: Notification.Name = Notification.Name("DidReceiveMovies")
    
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
            }catch{
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
            }catch{
                print("JSON Parising Error")
            }
        }
        dataTask.resume()
    }
}

    

//    private func sendRequest(_ url: URL, completion: @escaping ([Movies]) -> Void) {
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        let session: URLSession = URLSession(configuration: .default)
//
//        let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
//
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//
//            guard let data = data else { return }
//
//            do {
//                let apiResponse: APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
//                completion(apiResponse.movies)
//
//                //NotificationCenter.default.post(name: DidReceiveMoviesNotification, object: nil, userInfo: ["movies": apiResponse.movies] )
//            } catch(let err) {
//                print(err.localizedDescription)
//            }
//        }
//        dataTask.resume()
//    }
//
//    internal func requestMovies(urlInt: Int?, completion: @escaping ([Movies]) -> Void) {
//
//        var components = URLComponents(string: "https://connect-boxoffice.run.goorm.io/movies")
//
//        guard let urlInt = urlInt else {
//            if let url: URL = components?.url {
//                self.sendRequest(url) { movies in
//                    completion(movies)
//                }
//            }
//            return
//        }
//
//        let orderType = URLQueryItem(name: "order_type", value: "\(urlInt)")
//        components?.queryItems = [orderType]
//
//        guard let url: URL = components?.url else {
//            return
//        }
//        self.sendRequest(url) { movies in
//            completion(movies)
//
//        }
//    }
    
//    private func sendRequestDetail(_ url: URL, completion: @escaping ([DetailContents]) -> Void) {
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        let session: URLSession = URLSession(configuration: .default)
//
//        let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
//
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//
//            guard let data = data else { return }
//
//            do {
//                let apiResponse: SecondAPIResponse = try JSONDecoder().decode(SecondAPIResponse.self, from: data)
//                completion(apiResponse.movies2)
//
//                //NotificationCenter.default.post(name: DidReceiveMoviesNotification, object: nil, userInfo: ["movies": apiResponse.movies] )
//            } catch(let err) {
//                print(err.localizedDescription)
//            }
//        }
//        dataTask.resume()
//    }
//
//    internal func requestDetailContents(urlId: String?, completion: @escaping ([DetailContents]) -> Void) {
//
//        var components = URLComponents(string: "https://connect-boxoffice.run.goorm.io/movies")
//
//        guard let urlId = urlId else {
//            if let url: URL = components?.url {
//                self.sendRequestDetail(url) { movies2 in
//                    completion(movies2)
//                }
//            }
//            return
//        }
//
//        let orderType = URLQueryItem(name: "id", value: "\(urlId)")
//        components?.queryItems = [orderType]
//
//        guard let url: URL = components?.url else {
//            return
//        }
//        self.sendRequestDetail(url) { movies2 in
//            completion(movies2)
//
//        }
//    }
//
//}



//func makeURLAlertAction (urlstring: Int) {
//    
//    var components = URLComponents(string: "https://connect-boxoffice.run.goorm.io/movies")
//    let orderType = URLQueryItem(name: "order_type", value: "\(urlstring)")
//    components?.queryItems = [orderType]
//    guard let url: URL = components?.url else {
//        return
//    }
//    
//    var request = URLRequest(url: url)
//    request.httpMethod = "GET"
//    let session: URLSession = URLSession(configuration: .default)
//    
//    let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
//        
//        if let error = error {
//            print(error.localizedDescription)
//            return
//        }
//        
//        guard let data = data else { return }
//        
//        do {
//            let apiResponse: APIResponse = try JSONDecoder().decode(APIResponse.self, from: data)
//            self.arryMovies = apiResponse.movies
//            
//            DispatchQueue.main.async {
//                self.tableView?.reloadData()
//            }
//            
//        } catch(let err) {
//            print(err.localizedDescription)
//        }
//    }
//    
//    dataTask.resume()
//}
