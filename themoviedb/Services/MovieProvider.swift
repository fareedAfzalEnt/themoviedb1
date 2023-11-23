//
//  MovieProvider.swift
//  themoviedb
//
//  Created by Farid Afzal on 21/11/2023.
//

import Foundation

enum MovieProvider {
    case popular(params: Parameters)
    case season(showId:Int,seasonId:Int,params: Parameters)
    case detail(showId: Int, params: Parameters)
}

extension MovieProvider: ApiRequest {
    
    var baseUrl: String {
        Constants.APIEnvionment.apiBaseURL
    }
    
    var endPoint: String {
        switch self {
        case .popular:
            return "popular"
        case .season(let showId,let seasonId,_):
            return "\(showId)/season/\(seasonId)"
        case .detail(let showId, _):
            return "\(showId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .popular, .season, .detail:
                .GET
//        default:
//                .POST
        }
    }
    
    var params: [String : Any]? {
        switch self {
        case .popular(let params):
            return params
        case .season(_,_, let params):
            return params
        case .detail(_, let params):
            return params
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
}
