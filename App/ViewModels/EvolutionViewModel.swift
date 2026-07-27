import Foundation
import SwiftData

@Observable
final class EvolutionViewModel {
    private var dataService: DataService

    var photos: [ProgressPhoto] = []
    var selectedPhoto: ProgressPhoto?
    var comparePhoto: ProgressPhoto?
    var showComparison = false

    init(dataService: DataService) {
        self.dataService = dataService
        loadPhotos()
    }

    func loadPhotos() {
        photos = dataService.fetchProgressPhotos()
    }

    func addPhoto(front: Data?, back: Data?, side: Data?, weight: Double, bodyFat: Double?, notes: String) {
        let photo = ProgressPhoto(frontPhotoData: front, backPhotoData: back, sidePhotoData: side,
                                  bodyWeight: weight, bodyFat: bodyFat, notes: notes)
        dataService.addProgressPhoto(photo: photo)
        loadPhotos()
    }

    func deletePhoto(_ photo: ProgressPhoto) {
        dataService.deleteProgressPhoto(photo)
        loadPhotos()
    }

    func selectForComparison(_ photo: ProgressPhoto) {
        if comparePhoto == nil {
            comparePhoto = photo
        } else if selectedPhoto == nil {
            selectedPhoto = photo
            showComparison = true
        }
    }

    func clearComparison() {
        selectedPhoto = nil
        comparePhoto = nil
        showComparison = false
    }
}
