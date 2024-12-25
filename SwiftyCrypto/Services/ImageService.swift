//
//  ImageService.swift
//  SwiftyCrypto
//
//  Created by Bharat Lal on 25/12/24.
//

import Foundation
import Combine
import SwiftUI

final class ImageService {
    @Published var image: UIImage? = nil

    private var imageSubscription: AnyCancellable?
    private var urlString: String
    private let imageName: String
    private let cacheManager = CacheManager.shared
    private let folderName = "coin_images"

    init(id: String, urlString: String) {
        self.imageName = id
        self.urlString = urlString
        getImage()
    }

    private func getImage() {
        if let savedImage = cacheManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            downloadImage()
        }
    }

    private func downloadImage() {
        guard let url = URL(string: urlString) else {
            print("invalid url for image: ", imageName, urlString)
            return
        }
        imageSubscription = NetworkManager.execute(url)
            .tryMap({ data in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] image in
                guard let self = self, let downloadedImage = image else { return }
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.cacheManager.saveImage(image: downloadedImage, imageName: imageName, folderName: folderName)
            })
    }
}
