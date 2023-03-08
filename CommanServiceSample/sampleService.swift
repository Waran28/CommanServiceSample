//
//  InduvidualViewService.swift
//  sampleCommanService
//
//  Created by MacBook on 2023-03-08.
//

import Foundation
protocol sampleService{
    
    func getdata(authToken: String,completion: @escaping(Result<DataResult,ZiksaError>)->())
    
}
class IndividualService:sampleService {
    
    
    func getdata(authToken: String,completion: @escaping(Result<DataResult,ZiksaError>)->()){
        
        let parameters: [String : Any] = [
            "accessToken" : authToken,
            "channelId" : 1,
            "userId" : 0,
            "languageId" : 2
        ]
//        accessToken=&channelId=1&userId=0&languageId=2
        let request = RequestModel(url: URL(method: "GetHomeInfo")!, typeObj: .GET)
        let task = URLSession.postAction(request, DataResult.self,completion: { res in
            switch res {
                 
            case .success(let data):
                print(data)
                    DispatchQueue.main.async {
                        completion(.success(data))
                    }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(ZiksaError(msg: "\(error)")))
                }
            }
            
        
        })
    
    }
    
    
    
}
// MARK: - Result
struct DataResult: Codable {
    let programs: [Program]
    let error: ErrorRe
    let resultStatus: Int

    enum CodingKeys: String, CodingKey {
        case programs = "Programs"
        case error = "Error"
        case resultStatus = "ResultStatus"
    }
}

// MARK: - Error
struct ErrorRe: Codable {
    let errorID: Int
    let errorDescription: JSONNull?

    enum CodingKeys: String, CodingKey {
        case errorID = "ErrorId"
        case errorDescription = "ErrorDescription"
    }
}

// MARK: - Program
struct Program: Codable {
    let djList: [DjList]
    let programImageURLList: [String]
    let status: Int
    let statusDescription: String
    let noOfFollowers: Int
    let noOfFollowersDescription: String
    let followingStatus, ratingStatus: Bool
    let programRating, programID: Int
    let programTitle, startTime, endTime, period: String
    let djs: String
    let nextSongAvailabilityStatus, nextSongAvailabilityDuration: Int
    let descriptionBackgroundImageList: [String]

    enum CodingKeys: String, CodingKey {
        case djList = "DjList"
        case programImageURLList = "ProgramImageUrlList"
        case status = "Status"
        case statusDescription = "StatusDescription"
        case noOfFollowers = "NoOfFollowers"
        case noOfFollowersDescription = "NoOfFollowersDescription"
        case followingStatus = "FollowingStatus"
        case ratingStatus = "RatingStatus"
        case programRating = "ProgramRating"
        case programID = "ProgramId"
        case programTitle = "ProgramTitle"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case period = "Period"
        case djs = "Djs"
        case nextSongAvailabilityStatus = "NextSongAvailabilityStatus"
        case nextSongAvailabilityDuration = "NextSongAvailabilityDuration"
        case descriptionBackgroundImageList = "DescriptionBackgroundImageList"
    }
}

// MARK: - DjList
struct DjList: Codable {
    let djID: Int
    let djName, djShowName: String
    let djImageURL: String

    enum CodingKeys: String, CodingKey {
        case djID = "DjId"
        case djName = "DjName"
        case djShowName = "DjShowName"
        case djImageURL = "DjImageUrl"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
