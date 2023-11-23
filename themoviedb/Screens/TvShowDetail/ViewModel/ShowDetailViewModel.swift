//
//  ShowDetailViewModel.swift
//  themoviedb
//
//  Created by Farid Afzal on 21/11/2023.
//

import Foundation
import Combine


class ShowDetailViewModel : ObservableObject{
    private let service: MovieServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isLoading = false
    @Published var tvShowDetail: TVShowDetailModel = TVShowDetailModel()
    
    @Published var seasonDetail = SeasonDetailModel()

    @Published var isAlreadySelected = true
    
    @Published var seasonList = [SeasonsTapModel]()

    let btnList = [OptionsModel(name: "Watchlist", image: "plus"),OptionsModel(name: "I like it", image: "hand.thumbsup"),OptionsModel(name: "I don't like it", image: "hand.thumbsdown")]
    init(service: MovieServiceProtocol = MovieService()) {
        self.service = service
    }
    
    func fetchTVShowData(showId: Int){
        isLoading = true
        let params = ["api_key": Constants.APIEnvionment.apiKey]
        
        self.service.fetchTVShowDataWithID(showId: showId, params: params)
            .receive(on: DispatchQueue.main)
            .sink {[weak self] result in
            switch result {
            case .failure(let error):
                print("Error in request: \(error)")
                //DispatchQueue.main.async {
                    self?.isLoading = false
                //}
                
            case .finished:
                print("api process complete")
            }
        } receiveValue: {[weak self] response in
            self?.isLoading = false
                self?.tvShowDetail = response
                self?.getSeasonsList(fromShowData: response)

        }.store(in: &cancellables)

    }
    
    func fetchSeasonData(_ ShowID:Int, _ SeasonID: Int){
        self.isAlreadySelected = false
        isLoading = true

        let params = ["api_key": Constants.APIEnvionment.apiKey]
        
        self.service.fetchSeasonEpisodesData(showId: ShowID, seasonId: SeasonID, params: params)
            .receive(on: DispatchQueue.main)
            .sink {[weak self] result in
            switch result {
            case .failure(let error):
                print("Error in request: \(error)")
                self?.isLoading = false
            case .finished:
                print("api process complete")
            }
        } receiveValue: {[weak self] response in
            self?.isLoading = false
            self?.seasonDetail = response
            
        }.store(in: &cancellables)

    }
    
    func getSeasonsList(fromShowData showData : TVShowDetailModel?){
        self.seasonList = []
        if showData != nil && showData?.seasons != nil && !showData!.seasons!.isEmpty{
            
            for season in showData!.seasons!{
                if (season.seasonNumber != nil) && season.name != nil{
                    if season.seasonNumber! != 0{
                        
                        self.seasonList.append(SeasonsTapModel(id: season.seasonNumber!, name: "SEASON \(season.seasonNumber!)"))
                    }
                }
            }
        }
    }
}
