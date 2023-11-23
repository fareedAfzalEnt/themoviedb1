//
//  TVShowsHomeView.swift
//  themoviedb
//
//  Created by Farid Afzal on 22/11/2023.
//

import SwiftUI

struct TVShowsHomeView: View {
    
    @StateObject private var tvShowsVM: TvShowViewModel = TvShowViewModel()
    
    var body: some View {
        NavigationView {
            ZStack{
                ScrollView(.vertical, showsIndicators: false){
                    if !tvShowsVM.tvShows.isEmpty{
                        LazyVStack(alignment:.leading){
                            TopShowsView(topShowsList: tvShowsVM.toptvShows)
                            ForEach(0..<tvShowsVM.arrSections.count, id: \.self){ index in
                                VStack(alignment:.leading,spacing: 0){
                                    HeaderView(title: tvShowsVM.arrSections[index].rawValue)
                                    ScrollView(.horizontal,showsIndicators: false){
                                        
                                        HStack{
                                            
                                            ForEach(0..<tvShowsVM.tvShows.count, id: \.self){ index in
                                                NavigationLink(destination: ShowDetailView(showsModel: tvShowsVM.tvShows[index]).navigationBarBackButtonHidden()){
                                                    ShowsView(showsModel: tvShowsVM.tvShows[index])
                                                }
                                            }
                                        }
                                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
                                    }
                                }
                                
                            }
                            
                            Spacer()
                        }
                    }
                }
                .ignoresSafeArea(.all)
                .background(.white)
                .preferredColorScheme(.dark)
                CustomLoader(showIndicator: $tvShowsVM.isLoading)
            }
            .task {
                tvShowsVM.fetchTVShowData(page: 1)
                
            }
            
        }
    }
    init() {
        for familyName in UIFont.familyNames {
            print(familyName)
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print("---\(fontName)")
            }
        }
    }
}


#Preview{
    TVShowsHomeView()
}

struct ShowsView: View {
    let showsModel : Result
    var body: some View {
        RemoteImageView(strURL: showsModel.posterPath ?? "", isPosterPath: false)
            .frame(width: 130, height: 180)
            .cornerRadius(15)
    }
}

struct HeaderView: View {
    
    let title : String
    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundStyle(Color.black)
            .padding(15)

    }
}



struct TopShowsView: View {
    
    let topShowsList : [Result]
    @State var selectedIndex : Int = 0

    var body: some View {
        ZStack(alignment: .bottomLeading){
            TabView(selection: self.$selectedIndex){
                ForEach(0..<topShowsList.count, id: \.self){ index in
                    NavigationLink(destination: ShowDetailView(showsModel: topShowsList[index]).navigationBarBackButtonHidden()) {
                        
                        ZStack(alignment: .bottomLeading){
                            RemoteImageView(strURL: topShowsList[index].backdropPath ?? "", isPosterPath: false)
                                .frame(width: UIScreen.main.bounds.size.width)
                                .clipped()
                            Rectangle()
                                .foregroundColor(.clear)
                                .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))
                            
                            Text(topShowsList[index].name ?? "")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.white)
                                .padding(15)
                                .padding(.bottom,15)
                        }
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.size.width, height: 350)
            .tabViewStyle(PageTabViewStyle())
        }
    }
}


