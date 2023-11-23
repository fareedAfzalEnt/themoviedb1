//
//  ShowDetailView.swift
//  themoviedb
//
//  Created by Farid Afzal on 22/11/2023.
//

import SwiftUI

struct ShowDetailView: View {
    
    @StateObject private var showDetailVM: ShowDetailViewModel = ShowDetailViewModel()
    let showsModel : Result
    @State var isClicked = false
    @State var selectedSeason : Int = 1
    @State  var seasonList : [SeasonsTapModel] = [SeasonsTapModel(id: 1, name: "Overview")]
    
    var body: some View {
        ZStack{
            VStack{

                ScrollView(.vertical,showsIndicators: false){
                    DetailsTopView(showsModel: showsModel)
                   // Spacer()
                    ShowDescriptionView(showDetailVM: showDetailVM, showsModel: showsModel, isClicked: $isClicked)
                        .padding(.top, -60)
                    TabPagerView(selection : self.$selectedSeason, menuList: self.$seasonList)
                        .padding(.top, 30)
                        .onChange(of: self.selectedSeason) { newValue in
                            //showDetailVM.isLoading = false
                        }
                    
                    if self.showDetailVM.tvShowDetail.seasons != nil && !self.showDetailVM.tvShowDetail.seasons!.isEmpty{
                        EpisodeView(showDetailVM: self.showDetailVM, selectedSeason: self.$selectedSeason, seasonNumber: self.showDetailVM.tvShowDetail.id!)
                    }
                }
                

            }
            CustomLoader(showIndicator: $showDetailVM.isLoading)
        }
        .ignoresSafeArea()
        .background(Color("dark_1A1A1C"))
        .task {
            showDetailVM.fetchTVShowData(showId: self.showsModel.id ?? 219109)
        }
        .onReceive(self.showDetailVM.$seasonList) { list in
            self.seasonList =  list
        }
    }
}



#Preview {
    ShowDetailView(showsModel: Result())
}




struct DetailsTopView: View {
    
    @Environment (\.presentationMode) var presentationMode: Binding<PresentationMode>
    let showsModel : Result

    var body: some View {
        ZStack{
            RemoteImageView(strURL: showsModel.backdropPath ?? "", isPosterPath: true)
                .frame(width: UIScreen.main.bounds.size.width)
                .clipped()
            
            Rectangle()
                .foregroundColor(.clear)
                .background(LinearGradient(gradient: Gradient(colors: [.gray, .clear]), startPoint: .top, endPoint: .bottom))
            Rectangle()
                .foregroundColor(.clear)
                .background(LinearGradient(gradient: Gradient(colors: [Color("dark_1A1A1C"), .clear]), startPoint: .bottom, endPoint: .top))

            HStack{
                Image(systemName: Constants.ImageConstants.arrowLeft)
                    .resizable()
                    .frame(width: 25, height: 20, alignment: .center)
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                Spacer()
                Image(systemName:Constants.ImageConstants.search)
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
            }
            .bold()
            .foregroundColor(.white)
            .padding(.leading,15)
            .padding(.trailing,15)
            .padding(.bottom,130)
        }
        .frame(width: UIScreen.main.bounds.width, height: 260)
        .clipped()
    }
}

struct ShowDescriptionView: View {
    
    @ObservedObject  var showDetailVM: ShowDetailViewModel
    let showsModel : Result
    @State private var showFullOverview = false
    @Binding var isClicked : Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            HStack{
                Text(showsModel.originalName ?? "")
                    .customFont(weight: .medium, size: 25)
                    .foregroundColor(Color.white)
                Spacer()
            }
            HStack{
                Text(showsModel.firstAirDate?.getYearFromDate(showsModel.firstAirDate ?? "2017") ?? "2017")
                    .customFont(weight: .bold, size: 14)
                    .foregroundColor(.gray)
                
                Rectangle().fill(Color.gray).frame(width: 1)
                
                Text(showDetailVM.tvShowDetail.numberOfSeasons?.description ?? "")
                    .customFont(weight: .bold, size: 14)
                    .foregroundColor(.gray)
                
                Rectangle().fill(Color.gray).frame(width: 1)
                
                Text(Constants.LabelConstants.r)
                    .customFont(weight: .bold, size: 14)
                    .foregroundColor(.gray)
            }
            .frame(width: UIScreen.main.bounds.width/2, height: 12, alignment: .leading)
            HStack{
                ZStack{
                    NavigationLink(destination: VideoPlayerView(), isActive: $isClicked){
                        Button {
                            self.isClicked = true
                        } label: {
                            HStack{
                                Spacer()
                                Image(systemName:Constants.ImageConstants.playFill)
                                    .foregroundColor(.white)
                                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                                Text(Constants.ButtonConstants.play)
                                    .customFont(weight: .semibold, size: 15)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width*0.45, height: 45, alignment: .center)
                    .background(Color("orange_color"))
                    .cornerRadius(3)
                }
                Spacer()
                
                ZStack{
                    Button {
                    } label: {
                        HStack{
                            Spacer()
                            Image(systemName:Constants.ImageConstants.playRectangle)
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                            Text(Constants.ButtonConstants.trailer)
                                .customFont(weight: .semibold, size: 15)
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width*0.45, height: 45, alignment: .center)
                .background(Color("dark_gray_color"))
                .cornerRadius(3)
                
            }
            let numberOfLines = calculateNumberOfLines(text: showDetailVM.tvShowDetail.overview ?? "")
            if let overview = showDetailVM.tvShowDetail.overview {
                Text(overview)
                    .customFont(weight: .medium, size: 12)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
                    .lineLimit(showFullOverview ? nil : 2)
                    .padding(.top, 10)
                    .background(GeometryReader { geometry in
                        Color.clear.onAppear {
                            let lines = Int(geometry.size.height / UIFont.systemFont(ofSize: 12).lineHeight)
                            showFullOverview = lines > 2
                        }
                    })
                if(numberOfLines > 2) {
                    Button(action: {
                        withAnimation {
                            showFullOverview.toggle()
                        }
                    }) {
                        Text(showFullOverview ? Constants.LabelConstants.less : Constants.LabelConstants.read)
                            .customFont(weight: .medium, size: 12)
                            .foregroundColor(Color("orange_color"))
                    }
                }
            }
            
            HStack(spacing:20){
                
                ForEach(0..<showDetailVM.btnList.count, id: \.self){ index in
                    VStack(spacing:8){
                        ZStack{
                            Image(systemName: showDetailVM.btnList[index].image)
                                .resizable()
                                .frame(width: 15, height: 15, alignment: .center)
                                .foregroundColor(Color.white)
                        }
                        .frame(width: 40, height: 40, alignment: .center)
                        .background(Color("dark_gray_color"))
                        .clipShape(Circle())
                        
                        
                        Text(showDetailVM.btnList[index].name)
                            .customFont(weight: .regular, size: 12)
                            .foregroundColor(.gray)
                        
                    }
                }
                Spacer()
            }
         
        }
        .padding(10)
        
    }
    
    func calculateNumberOfLines(text: String) -> Int {
        let boundingRect = NSString(string: text)
            .boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 16, height: .greatestFiniteMagnitude),
                          options: .usesLineFragmentOrigin,
                          attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)],
                          context: nil)
        let numberOfLines = Int(ceil(boundingRect.size.height / UIFont.systemFont(ofSize: 12).lineHeight))
        return numberOfLines
    }
}
