//
//  File.swift
//  DessertBook
//
//  Created by Cobra Curtis on 6/20/24.
//

import Foundation

/**
 An enumeration representing various network errors that can occur during API calls.
 
 - invalidURL: Indicates that the URL provided is invalid.
 - invalidResponse: Indicates that the server returned an invalid response.
 - badRequest: Indicates that the request was invalid or cannot be served.
 - invalidData: Indicates that the data received was invalid.
 - decodingError: Indicates that there was an error decoding the data.
 - unsupportedURL: Indicates that the URL is not supported.
 - imageDownloadError: Indicates that there was an error downloading the image.
 - unknown: Represents an unknown error with an associated error message.
 */
enum NetworkError: Error, Identifiable, CustomStringConvertible {
    case invalidURL
    case invalidResponse
    case badRequest
    case invalidData
    case decodingError
    case unsupportedURL
    case imageDownloadError
    case notConnected
    case unknown(Error)

    /// A unique identifier for the error, using its localized description.
    var id: String { localizedDescription }

    /// A human-readable description of the error.
    var description: String {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .invalidResponse:
            return "The server returned an invalid response."
        case .badRequest:
            return "The request was invalid or cannot be served."
        case .invalidData:
            return "The data received was invalid."
        case .decodingError:
            return "There was an error decoding the data."
        case .unsupportedURL:
            return "The URL is not supported."
        case .imageDownloadError:
            return "The image did not download."
        case .notConnected:
            return "The device is not connected to the internet"
        case .unknown(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }

    /// A localized description of the error, suitable for presenting to the user.
    var localizedDescription: String {
        return description
    }
}

