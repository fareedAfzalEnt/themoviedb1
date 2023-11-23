//
//  CustomLoader.swift
//  themoviedb
//
//  Created by Farid Afzal on 23/11/2023.
//

import Foundation
import SwiftUI
public struct CustomLoader: View {
    
    public enum IndicatorType {
        case rotatingDots
    }
    
    
    @Binding public var showIndicator: Bool
    var type: IndicatorType
    
    
    public init(showIndicator: Binding<Bool>, type: IndicatorType = .rotatingDots) {
        _showIndicator = showIndicator
        self.type = type
    }
    public var body: some View {
        if showIndicator {
            indicator
        } else {
            EmptyView()
        }
    }
    
    // MARK: - Private
    
    private var indicator: some View {
        ZStack {
            Color.black
                .opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            switch type {
            case .rotatingDots:
                RotatingDotsIndicatorView(count: 5)
                    .frame(width: 50,height: 50)
                    .foregroundColor(.orange)
            }
        }
    }
}

struct RotatingDotsIndicatorView: View {

    let count: Int

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<count, id: \.self) { index in
                RotatingDotsIndicatorItemView(index: index, size: geometry.size)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct RotatingDotsIndicatorItemView: View {

    let index: Int
    let size: CGSize

    @State private var scale: CGFloat = 0
    @State private var rotation: Double = 0

    var body: some View {
        let animation = Animation
            .timingCurve(0.5, 0.15 + Double(index) / 5, 0.25, 1, duration: 1.5)
            .repeatForever(autoreverses: false)

        return Circle()
            .frame(width: size.width / 5, height: size.height / 5)
            .scaleEffect(scale)
            .offset(y: size.width / 10 - size.height / 2)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                rotation = 0
                scale = (5 - CGFloat(index)) / 5
                withAnimation(animation) {
                    rotation = 360
                    scale = (1 + CGFloat(index)) / 5
                }
            }
    }
}
