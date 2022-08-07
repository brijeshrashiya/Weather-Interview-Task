//
//  WeatherViewModel.swift
//  Weather Interview Task
//
//  Created by Brijesh on 05/08/22.
//

import SwiftUI
import Combine
import Foundation
import MapKit

class WeatherViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var state: MainViewState = .none {
        didSet {
            print("new state \(state)")
        }
    }
    
    @Published var searchText: String = ""
    @Published private(set) var searchResults = [LocationModel]()
    @Published var weatherViewPresented : Bool = false
    @Published var weatherViewSheetPresented : Bool = false
    @Published var weathersData : [WeatherModel] = [WeatherModel]()
    @Published var weatherModel : WeatherModel = WeatherModel()
    @AppStorage("offline") var offlineData : [Int] = []
    
    // MARK: - Constructor
    init() {
        $searchText
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue(label: "placesSearch", qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue:  searchForPlaces(forLocation:))
            .store(in: &cancellables)
        
        if(offlineData.count > 0) {
            fetchWeathers(for: offlineData)
        }
    }
    
    var selectedPlace: LocationModel? {
        didSet {
            guard let selectedPlace = selectedPlace else { return }
            fetchWeather(for: selectedPlace)
        }
    }
    
    var canEditPlaces: Bool {
        !weathersData.isEmpty
    }
    
    func openMap(model:WeatherModel) {
        if  let latitude: CLLocationDegrees = model.coord?.lat,let longitude: CLLocationDegrees = model.coord?.lon {
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = model.name ?? ""
            mapItem.openInMaps(launchOptions: options)
        }
        else {
            print("Error")
        }
        
    }
    
    var currentPlaceIsSaved: Bool {
        return weathersData.contains { $0.id == weatherModel.id }
    }
    
    private func fetchWeather(for place: LocationModel) {
       
        state = .fethcingWeatherForPlace(place: place)
        Task {
            do {
                let model = try await WeatherManager().getCurrentWeather(latitude: place.lat, longitude: place.lon)
                DispatchQueue.main.async {
                    self.weatherModel = model
                    self.weatherViewSheetPresented = true
                    self.state = .none
                    // Show the Weather view as sheet if its a search result
                    if self.searchText.isEmpty {
                        self.weatherViewPresented = true
                    } else {
                        self.weatherViewSheetPresented = true
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.state = .none
                }
                print("Error getting weather: \(error)")
            }
        }
    }
    
    func editPlaces() {
        self.state = .editingPlaces
    }

    func doneEditingPlaces() {
        self.state = .none
    }
    
    func addWeather(model: WeatherModel) {
        searchText = ""
        weathersData.append(model)
        offlineData.append(model.id)
    }

    private func searchForPlaces(forLocation location: String) {
        guard location.count > 1 else { return }
       searchResults = []
        state = .loadingLocation
        
        Task {
            do {
                
                let arr = try await WeatherManager().getLocation(query: searchText)
                DispatchQueue.main.async {
                    self.searchResults = arr
                    self.state = .none
                  }
                
            } catch {
                DispatchQueue.main.async {
                    self.state = .none
                  }
                print("Error getting weather: \(error)")
            }
        }
    }
    
    func removeWeatherData(_ data: WeatherModel) {
       if let index = weathersData.firstIndex(where: {$0.id == data.id}){
            weathersData.remove(at: index)
        }
        if let index = offlineData.firstIndex(where: {$0 == data.id}){
            offlineData.remove(at: index)
        }
    }
    
    private func fetchWeathers(for offlineData: [Int]) {
        state = .fetchingWeathersData
        
        Task {
            do {
                let model = try await WeatherManager().getMultipleCurrentWeather(groupIds: offlineData)
                DispatchQueue.main.async {
                    self.weathersData = model.list
                    self.state = .none
                }
                
            } catch {
                DispatchQueue.main.async {
                    self.state = .none
                }
                print("Error getting weather: \(error)")
            }
        }
    }
    
}

enum MainViewState: Equatable {
    case none
    case loadingLocation
    case fetchingWeatherForLocation
    case fethcingWeatherForPlace(place: LocationModel)
    case fetchingWeathersData
    case editingPlaces

    static func == (lhs: MainViewState, rhs: MainViewState) -> Bool {
        switch (lhs, rhs) {
            case (.none, .none):
                return true
            case (.loadingLocation, .loadingLocation):
                return true
            case (.fetchingWeathersData, .fetchingWeathersData):
                return true
            case (.editingPlaces, .editingPlaces):
                return true
        case (.fetchingWeatherForLocation, .fetchingWeatherForLocation):
            return true
            case (.fethcingWeatherForPlace(let lhsPlace), .fethcingWeatherForPlace(let rhsPlace)):
            return lhsPlace.id == rhsPlace.id
            default:
                return false
        }
    }
}
