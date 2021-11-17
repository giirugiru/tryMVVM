//
//  Networking.swift
//  tryMVVM
//
//  Created by Gilang Sinawang on 17/11/21.
//

import Foundation
import Alamofire

enum ErrorResult: Error, Equatable {
  case generalError(message: String?)
  case noInternet
  case dataNil
  case parsingFailure
}

class Networking {
  static let shareInstance = Networking()
  
  func getRequest<T: Codable>(urlString: String, completion: ((_ result: Result<T, ErrorResult>) -> Void)? = nil) {
    guard let url = URL(string: urlString) else { return }
    
    AF.request(url, method: .get).responseJSON { response in
      
      // Data nil validation
      guard let data = response.data, response.error == nil else {
        completion?(.failure(ErrorResult.dataNil))
        return
      }
      
      // Logging
#if DEBUG
      self.log(data: data, url: urlString)
#endif
      
      // Decoder
      do {
        let APIData = try JSONDecoder().decode(T.self, from: data)
        completion?(.success(APIData))
      } catch {
        completion?(.failure(ErrorResult.parsingFailure))
      }
    }
  }
  
  func postRequest<T: Codable>(urlString: String, parameters: Parameters, completion: ((_ result: Result<T, ErrorResult>) -> Void)? = nil) {
    guard let url = URL(string: urlString) else { return }
    
    AF.request(url, method: .post, parameters: parameters, headers: .default).responseJSON { response in
      
      // Data nil validation
      guard let data = response.data, response.error == nil else {
        completion?(.failure(ErrorResult.dataNil))
        return
      }
      
      // Logging
#if DEBUG
      self.log(data: data, url: urlString)
#endif
      
      // Decoder
      do {
        let APIData = try JSONDecoder().decode(T.self, from: data)
        completion?(.success(APIData))
      } catch {
        completion?(.failure(ErrorResult.parsingFailure))
      }
    }
  }
  
  func log(data: Data, url: String) {
    print("[RESPONSE] -> \(url)")
    guard let object = try? JSONSerialization.jsonObject(with: data, options: []),
          let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
          let prettyString = String(data: data, encoding: .utf8) else {
            return
          }
    print(prettyString)
  }
}

// REFERENCE
//
//class BaseAPIService {
//  func getRequest<T: Codable>(urlString: String, completion: ((_ result: Result<T, ErrorResult>) -> Void)? = nil) {
//
//    let url = URL(string: urlString)!
//    var request = URLRequest(url: url)
//    request.httpMethod = HTTPMethod.GET.value
//
//    URLSession.shared.dataTask(with: request){ (data, response, error) in
//      guard let data = data, error == nil else {
//        completion?(.failure(ErrorResult.dataNil))
//        return
//      }
//
//      #if DEBUG
//      self.log(data: data, url: urlString)
//      #endif
//
//      do {
//        let results = try JSONDecoder().decode(T.self, from: data)
//        completion?(.success(results))
//      } catch let decodingError {
//        completion?(.failure(ErrorResult.generalError(message: decodingError.localizedDescription)))
//      }
//
//    }.resume()
//  }
//
//  func postRequest<T: Codable>(urlString: String, parameters: [String: Any], completion: ((_ result: Result<T, ErrorResult>) -> Void)? = nil) {
//
//    let url = URL(string: urlString)!
//    var request = URLRequest(url: url)
//    request.httpMethod = HTTPMethod.POST.value
//
//    URLSession.shared.dataTask(with: request){ (data, response, error) in
//      guard let data = data, error == nil else {
//        completion?(.failure(ErrorResult.dataNil))
//        return
//      }
//
//      #if DEBUG
//      self.log(data: data, url: urlString)
//      #endif
//
//      do {
//        let results = try JSONDecoder().decode(T.self, from: data)
//        completion?(.success(results))
//      } catch let decodingError {
//        completion?(.failure(ErrorResult.generalError(message: decodingError.localizedDescription)))
//      }
//
//    }.resume()
//  }
//
//  func log(data: Data, url: String) {
//    print("[RESPONSE] -> \(url)")
//    guard let object = try? JSONSerialization.jsonObject(with: data, options: []),
//          let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
//          let prettyString = String(data: data, encoding: .utf8) else {
//            return
//          }
//    print(prettyString)
//  }
//}
