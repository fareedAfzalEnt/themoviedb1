//
//  TvShowViewModel.swift
//  themoviedb
//
//  Created by Farid Afzal on 21/11/2023.
//

import Foundation
import Combine
enum category : String{
    case popular = "Popular"
    case trending = "Trending"
    case favorite = "Favorites"
}
final class TvShowViewModel:ObservableObject {
    private let service: MovieServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isLoading = false
    @Published var tvShows: [Result] = [Result]()
    @Published var toptvShows: [Result] = [Result]()
    var arrSections : [category] = [.popular,.trending,.favorite]
    init(service: MovieServiceProtocol = MovieService()) {
        self.service = service
    }
    
     func fetchTVShowData(page:Int = 1) {
         isLoading = true
         
         let params = ["api_key": Constants.APIEnvionment.apiKey,
                       "language": "en-US",
                       "page": "\(page)"]

        self.service.fetchTVShowData(params: params)
            .receive(on: DispatchQueue.main)
            .sink {[weak self] result in
                switch result {
                case .failure(let error):
                    print("Error in request: \(error)")
                    self?.isLoading = false
                case .finished:
                    print(" api process complete")
                }
            } receiveValue: {[weak self] response in
                self?.isLoading = false
                //print("ressss",response.results)
                if let movies = response.results {
                    self?.tvShows = movies
                    if let shows = self?.tvShows{
                        self?.toptvShows =  shows.count > 5 ? Array(shows.prefix(5)) : shows
                    }
                }
            }.store(in: &cancellables)
    }
}
