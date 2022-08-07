//
//  WeatherDetail.swift
//  Weather Demo
//
//  Created by Brijesh on 03/08/22.
//


import SwiftUI

struct WeatherDetail: View {
    
    //MARK: - Variable Declaration
    var isSheet: Bool
    var canSave: Bool
    var addPlaceCallback: (() -> Void)?
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: WeatherDetailViewModel

    //MARK: - Main Body
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                if isSheet {
                    sheetActionsView
                } else {
                    dismissButtonView
                }
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        currentWeatherView
                        currentSummaryView
                    }
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }

    //MARK: - Current Weather View
    private var currentWeatherView: some View {
        return AnyView(
            HStack {
                VStack(spacing: 4) {
                    Text(viewModel.cityName)
                        .font(.title)
                        .fontWeight(.medium)
                    HStack {
                        Image(viewModel.weatherImage, bundle: nil)
                        .scaledToFit()
                        .frame(width: 30, height: 30, alignment: .center)
                        .padding()
                        Text(viewModel.currentTemp)
                            .fontWeight(.semibold)
                    }.font(.system(size: 54))
                        .frame(maxWidth: .infinity)
                    Text(viewModel.weatherDescription)
                        .foregroundColor(.secondary)
                }
            }
        )
    }

    //MARK: - Current Summary View
    private var currentSummaryView: some View {
        return AnyView(
            
            VStack(alignment: .center, spacing: 0, content: {
                
                MainSectionView(text: "Temp", childView: {
                    VStack(alignment: .leading, spacing: 16, content: {
                       
                        HStack {
                            keyValueView(image: .init(systemName: "sun.max.fill"),caption: "High", value:viewModel.maxTemp)
                            Spacer()
                            keyValueView(image: .init(systemName: "sun.min"),caption: "Low", value:viewModel.minTemp)

                        }
                        .padding(.leading, 16)
                        .padding(.trailing, 16)

                    })
                })
                
                MainSectionView(text: "Sun", childView: {
                    VStack(alignment: .leading, spacing: 16, content: {
                        HStack {
                            keyValueView(image: .init(systemName: "sunrise"), caption: "Sunrise", value: viewModel.sunrise)
                             Spacer()
                            keyValueView(image: .init(systemName: "sunset"), caption: "Sunset", value: viewModel.sunset)

                         }
                         .padding(.leading, 16)
                         .padding(.trailing, 16)

                    })
                })
                
                MainSectionView(text: "Wind", childView: {
                    VStack(alignment: .leading, spacing: 16, content: {
                       HStack {
                           keyValueView(image: .init(systemName: "wind"),caption: "Speed", value:viewModel.windSpeed)
                            Spacer()
                           keyValueView(image: .init(systemName: "arrow.up.right.circle"),caption: "Degree", value:viewModel.windDegree)

                        }
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                    })
                })
                
                MainSectionView(text: "Other", childView: {
                    VStack(alignment: .leading, spacing: 16, content: {

                        HStack {
                            keyValueView(image: .init(systemName: "gauge"),caption: "Pressure", value: viewModel.pressure)
                            Spacer()
                            keyValueView(image: .init(systemName: "humidity"),caption: "Humidity", value: viewModel.humidity)

                        }
                        .padding(.leading, 16)
                        .padding(.trailing, 16)

                        HStack {
                            keyValueView(image: .init(systemName: "eye.fill"),caption: "Visibility", value: viewModel.visibility )
                            Spacer()
                            keyValueView(image: .init(systemName: "thermometer"),caption: "Feels Like", value: viewModel.feelsLike)
                        }
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                        
                    })
                })
            })
            
            
            
        )
    }

    //MARK: - Sheet Action View
    private var sheetActionsView: some View {
        return AnyView(
            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                if canSave {
                    Button("Add") {
                        addPlaceCallback?()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }.padding())
    }

    //MARK: - Dismiss Button View
    private var dismissButtonView: some View {
        return AnyView(
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "list.star")
                        .foregroundColor(.white)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                })

                Spacer()
            }.padding([.top, .leading])
        )
    }

    //MARK: - Key Value View
    private func keyValueView(image: Image, caption: String, value: String) -> some View {
        VStack(alignment: .center, spacing: 8) {
            HStack(alignment: .center, spacing: 4)  {
                image
                    .imageScale(.large)
                    .foregroundColor(ColorConstant.AccentColor)
                Text(caption)
                    .font(.body)
            }
            
            Text(value)
                .font(.title)
        }
        .padding()
        .frame(width: abs(UIScreen.main.bounds.size.width/2)-40, height: 100, alignment: .center)
        .background(.black)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.5), radius: 6, x: 1.0, y: 1.1)
    }
    
    
}

//MARK: - Main Section View
struct MainSectionView<Content: View>: View {

    //MARK: - Main Section Variable Declaration
    var text:String = ""
    @ViewBuilder var childView: Content

    //MARK: - Main Section Body
    var body: some View {
        VStack(alignment: .leading, spacing: 6, content: {
            Text(text)
                .font(.headline)
                .padding()
            
            childView
                .padding(.bottom, 16)
        })
        .background(.black)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.5), radius: 8, x: 1.0, y: 1.1)
        .padding(.leading, 16)
        .padding(.trailing, 16)
        .padding(.bottom, 8)
        .padding(.top, 8)
    }


}
