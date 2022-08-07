//
//  WeatherList.swift
//  Weather Demo
//
//  Created by Brijesh on 02/08/22.
//

import Foundation
import SwiftUI

struct WeatherList : View {
    
    //MARK: - Variable Declaration
    @StateObject private var viewModel: WeatherViewModel = WeatherViewModel()
    
    
    //MARK: - Main Body
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack {
                    headerView
                    SearchBar(searchText: $viewModel.searchText, placeholder: "Search for a location")
                        .padding()

                    if viewModel.searchText.isEmpty {
                        if(viewModel.state == .fetchingWeathersData) {
                            LoadingView()
                        }
                        else if (viewModel.weathersData.count > 0) {
                            placesListView
                        }
                        else if (viewModel.offlineData.count > 0 && viewModel.state != .fetchingWeathersData) {
                            VStack(spacing: 10) {
                                Image(systemName: "cloud.sun.bolt.fill")
                                    .font(.title)
                                Text("No data found")
                                    .font(.title2)
                                Spacer()
                            }
                            .offset(x: 0, y: 40)
                        }
                        else {
                            VStack(spacing: 10) {
                                Image(systemName: "plus.magnifyingglass")
                                    .font(.title)
                                Text("Please add location first from above search bar")
                                    .font(.title2)
                                Spacer()
                            }
                            .offset(x: 0, y: 40)
                            
                        }
                        
                    } else {
                        searchPlacesListView
                    }
                    Spacer()
                }
                .sheet(isPresented: $viewModel.weatherViewSheetPresented) {
                    
                    WeatherDetail(isSheet: true, canSave: !viewModel.currentPlaceIsSaved, addPlaceCallback: {
                        //
                        viewModel.searchText = ""
                        viewModel.addWeather(model: viewModel.weatherModel)
                    }, viewModel: WeatherDetailViewModel(wetherModel: viewModel.weatherModel))
                }
            }
            .navigationBarHidden(true)
            .background(Color.clear)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    //MARK: - Header View
    private var headerView: some View {
        return AnyView(
            ZStack {
                HStack {
                    Spacer()
                }
                VStack {
                    Text(AppConstants.appName)
                        .font(.system(size: 22, weight: .regular))
                }
                HStack {
                    Spacer()
                    if(viewModel.canEditPlaces || viewModel.state == .editingPlaces) && viewModel.searchText.isEmpty {
                        Button(action: {
                            if(viewModel.state == .editingPlaces) {
                                viewModel.doneEditingPlaces()
                            }
                            else {
                                viewModel.editPlaces()
                            }
                        }, label: {
                            if viewModel.state == .editingPlaces {
                                Text("Done")
                            } else {
                                Image(systemName: "pencil.circle")
                                    .font(.system(size: 22, weight: .regular))
                            }
                        })
                    }
                        
                }
            }.padding()
        )
    }
    
    //MARK: - Place List View
    private var placesListView: some View {
        return ScrollView(showsIndicators: false) {
            ForEach(viewModel.weathersData) { ( weatherData) in
                ZStack {
                    NavigationLink(destination: WeatherDetail(isSheet: false, canSave: false,viewModel: WeatherDetailViewModel(wetherModel: weatherData)), isActive: $viewModel.weatherViewPresented) { EmptyView() }
                    .frame(width: 0, height: 0)
                    .hidden()

                        HStack {
                            if viewModel.state == .editingPlaces {
                                Button(action: {
                                    viewModel.removeWeatherData(weatherData)
                                }, label: {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(ColorConstant.AccentColor)
                                })
                            }
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(weatherData.name ?? "") - \(weatherData.sys?.getCountryName() ?? "")")
                                    .fontWeight(.medium)
                                Spacer()
                                Text(weatherData.getWeather()?.main ?? "")
                                    .font(Font.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(weatherData.main?.getTemp() ?? "-")
                                    .fontWeight(.light)
                            Spacer()
                            Image(weatherData.getWeather()?.icon ?? "", bundle: nil)
                                .scaledToFit()
                                .frame(width: 30, height: 30, alignment: .center)
                                
                            Spacer()
                            Button(action: {
                                viewModel.openMap(model: weatherData)
                            }, label: {
                                Image(systemName: "map.circle")
                                    .font(.title)
                                    .foregroundColor(ColorConstant.AccentColor)
                            })
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                            .onTapGesture {
                                if viewModel.state == .editingPlaces {
                                    viewModel.removeWeatherData(weatherData)
                                } else {
                                    viewModel.weatherViewPresented = true
                                }
                            }
                        }
                    
                    }
                }
        }.padding()
    }

    //MARK: - Search Places View
    private var searchPlacesListView: some View {
        return AnyView(
            ZStack {
                if viewModel.state == .loadingLocation {
                    ProgressView()
                } else if !viewModel.searchResults.isEmpty {
                    List(viewModel.searchResults) { place in
                        HStack {
                            Button("\(place.name), \(place.state ?? ""), \(place.getCountryName())") {
                                viewModel.selectedPlace = place
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .onAppear {
                        UITableView.appearance().backgroundColor = UIColor.clear
                        UITableViewCell.appearance().backgroundColor = UIColor.clear
                    }
                    .offset(x: 0, y: -40)
                } else if (viewModel.state != .loadingLocation){
                    VStack {
                        Image(systemName: "magnifyingglass")
                            .font(.title)
                        Text("No search result found")
                            .font(.title2)
                        Spacer()
                    }
                }
            }
        )
    }
    
}

//MARK: - WeatherList Previews
struct WeatherList_Previews: PreviewProvider {
    static var previews: some View {
        WeatherList()
            .preferredColorScheme(.dark)
    }
}



