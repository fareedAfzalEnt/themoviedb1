//
//  MovieService.swift
//  themoviedb
//
//  Created by Farid Afzal on 21/11/2023.
//

import Foundation
import Combine

protocol MovieServiceProtocol: AnyObject {
    func fetchTVShowData(params: [String: Any]) -> AnyPublisher<TVShowModel, ApiError>
    func fetchSeasonEpisodesData(showId: Int,seasonId: Int,params: [String: Any]) -> AnyPublisher<SeasonDetailModel, ApiError>
    func fetchTVShowDataWithID(showId: Int, params: [String: Any]) -> AnyPublisher<TVShowDetailModel, ApiError>
}

class MovieService: MovieServiceProtocol {
   
    
    init() {}
    
    func fetchTVShowData(params: [String: Any]) -> AnyPublisher<TVShowModel, ApiError> {
        let request = MovieProvider.popular(params: params)
        return NetworkManager.shared.request(request, decodingType: TVShowModel.self)
    }
    
    func fetchSeasonEpisodesData(showId: Int, seasonId: Int,params: [String: Any]) -> AnyPublisher<SeasonDetailModel, ApiError> {
        let request = MovieProvider.season(showId: showId, seasonId: seasonId, params: params)
        return NetworkManager.shared.request(request, decodingType: SeasonDetailModel.self)
    }
    
    func fetchTVShowDataWithID(showId: Int, params: [String: Any]) -> AnyPublisher<TVShowDetailModel, ApiError> {
        let request = MovieProvider.detail(showId: showId, params: params)
        return NetworkManager.shared.request(request, decodingType: TVShowDetailModel.self)
    }
}
