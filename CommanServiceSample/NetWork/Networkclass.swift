//
//  Network.swift
//  sampleCommanService
//
//  Created by MacBook on 2023-03-08.
//

import Foundation
import UIKit



enum NetworkError: Error {
    case domainError
    case decodingError
    case noDataError
}
enum RequestType: String {
    case GET
    case POST
}
struct RequestModel  {
    let url : URL
    var typeObj : RequestType = .GET
    var httpBody : [String:Any]? = nil
    var param : [String:Any]? = nil
    var allHTTPHeaderFields :[String:Any]? = nil
    
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .millisecondsSince1970
    }
    return decoder
}

struct ErrorFromService: Codable {
    let errorID: Int
    let errorMessage: String
    let recordState: Bool

    enum CodingKeys: String, CodingKey {
        case errorID = "ErrorId"
        case errorMessage = "ErrorMessage"
        case recordState = "RecordState"
    }
}

extension URLSession {
    
    static func postAction<T:Decodable>(_ requestModel:RequestModel,
                                        _ modelType: T.Type,
                                        completion: @escaping (Result<T,ZiksaError>) -> Void) {
        let session = URLSession.shared
        var serviceUrl = URLComponents(string: requestModel.url.description)
        guard let componentURL = serviceUrl?.url else { return }
        var request = URLRequest(url: componentURL)
        request.httpMethod = requestModel.typeObj.rawValue
//        if (requestModel.allHTTPHeaderFields != nil){
//            request.allHTTPHeaderFields = requestModel.allHTTPHeaderFields as! [String : String]
//        }
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        if let parameterDictionary = requestModel.httpBody  {
            guard let httpBody = requestModel.httpBody?.encoded()else {
                        return
                    }
            request.httpBody = httpBody
        }
        
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            
            if let data = data {
                let response = NSString(data: data, encoding:  String.Encoding.utf8.rawValue)! as String
                do {
                    print("response \(response.removeXML)")
                    let jsonString = response.removeXML
                    
                    let trimmedString = jsonString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    let str = "{"
                    var mySet = CharacterSet()
                    mySet.insert(charactersIn: jsonString ?? "")
                    guard let jsonData = trimmedString.data(using: .utf8) else {return}
//                    if (str.rangeOfCharacter(from: mySet) != nil) {
                        
                        let jsonResponse = try newJSONDecoder().decode(T.self, from: jsonData)
                        
                        print("jsonData : \(jsonData)")
    
                        print("jsonResponse : \(jsonResponse)")
                        completion(.success(jsonResponse))
//                    }else{
//
//                        let encoder = JSONEncoder()
//                        if let DataEncoder = try? encoder.encode(jsonString) {
//                            if let StringEncoder = String(data: DataEncoder, encoding: .utf8) {
//                                print(StringEncoder)
//                                guard let jsonDataEncoder = StringEncoder.data(using: .utf8) else {return}
//                                let jsonResponse = try newJSONDecoder().decode(T.self, from: jsonDataEncoder)
//
//                                print("jsonData : \(jsonData)")
//            //                    guard let jsonResponse = (try? JSONSerialization.jsonObject(with: jsonData)) as? T else {return}
//
//                                print("jsonResponse : \(jsonResponse)")
//                                completion(.success(jsonResponse))
//                            }
//                        }
//
//
//
//
//                    }
                    
                   
                    
                }catch let DecodingError.dataCorrupted(context) {
                        print(context)
                    completion(.failure(ZiksaError(msg:  "\(context)")))
                } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        completion(.failure(ZiksaError(msg:"\(context.codingPath)")))
                } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        completion(.failure(ZiksaError(msg: "Value '\(value)' not found: \(context.debugDescription)")))
                } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                        completion(.failure(ZiksaError(msg: "Unknown Error")))
                    
                                       
                } catch {
//
                    
                        let error = try? JSONDecoder().decode(ErrorFromService.self, from: response.description.removeXML.data(using: .utf8)!)
                    
//                    type of failure
                      completion(.failure(ZiksaError(msg: error?.errorMessage ?? "Unknown Error")))
                       print(error)
                }
            } else {
                
                completion(.failure(ZiksaError(msg: error?.localizedDescription ?? "Failed to retrieved data from")))
//                Functions.printdetails(msg: "Failed to retrieved data from \(request.url?.absoluteString ?? "") error is \(error)")
//                completion(.failure(ZiksaError(msg: error as? String ?? "Unknown Error")))
            }
        }.resume()
    }
    
    
    
    
    
    //MARK: - URL

    
    
}
extension URL {
//http://mbcapps.mstudio.live:8081/mStudioServicev1/mStudioMobileWebService.asmx/GetHomeInfo?accessToken=@aCCess$321tOKeN@987&channelId=1&userId=0&languageId=2
    
    init?(method: String) {
        let baseUrl = "http://mbcapps.mstudio.live:8081/mStudioServicev1/mStudioMobileWebService.asmx/"
//        "http://mbcapps.mstudio.live:8081/mStudioServicev1/mStudioMobileWebService.asmx/"
        let url = "\(baseUrl)\(method)?accessToken=@aCCess$321tOKeN@987&channelId=1&userId=0&languageId=2"
        
//                url = "\(loggedUser.tenantURL)/webservice/lmsservice.asmx/\(method)"
            
            self.init(string: url)
        
    }
}

