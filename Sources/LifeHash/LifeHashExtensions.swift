//
//  LifeHashExtensions.swift
//  LifeHash
//
//  Copyright © 2020 by Blockchain Commons, LLC
//  Licensed under the "BSD-2-Clause Plus Patent License"
//
//  Created by Wolf McNally on 7/6/20.
//

import Foundation
import UIKit
import Combine
import SwiftUI

@objc private class DigestKey: NSObject {
    let digest: Data

    init(_ digest: Data) { self.digest = digest }

    override var hash: Int {
        return digest.hashValue
    }

    override func isEqual(_ object: Any?) -> Bool {
        return digest == (object as! DigestKey).digest
    }
}

extension LifeHashGenerator {
    private static let cache = NSCache<DigestKey, UIImage>()
    private typealias Promise = (Result<UIImage, Never>) -> Void
    private static var promises: [DigestKey: [Promise]] = [:]
    private static let serializer = DispatchQueue(label: "LifeHash serializer")
    private static var cancellables: [DigestKey: AnyCancellable] = [:]

    public static func image(for fingerprint: Fingerprint) -> AnyPublisher<Image, Never> {
        getCachedImage(fingerprint).map { image in
            Image(uiImage: image).interpolation(.none)
        }.eraseToAnyPublisher()
    }

    public static func getCachedImage(_ obj: Fingerprintable) -> Future<UIImage, Never> {
        getCachedImage(obj.fingerprint)
    }

    public static func getCachedImage(_ fingerprint: Fingerprint) -> Future<UIImage, Never> {
        /// Additional requests for the same LifeHash image while one is already in progress are recorded,
        /// and all are responded to when the image is done. This is so almost-simultaneous requests for the
        /// same data don't trigger duplicate work.
        func recordPromise(_ promise: @escaping Promise, for digestKey: DigestKey) -> Bool {
            var result: Bool!
            serializer.sync {
                if let digestPromises = promises[digestKey] {
                    var p = digestPromises
                    p.append(promise)
                    promises[digestKey] = p
                    result = false
                } else {
                    promises[digestKey] = [promise]
                    result = true
                }
            }
            return result
        }

        func succeedPromises(for digestKey: DigestKey, with image: UIImage) {
            serializer.sync {
                guard let digestPromises = promises[digestKey] else { return }
                promises.removeValue(forKey: digestKey)
                for promise in digestPromises {
                    promise(.success(image))
                }
            }
        }

        return Future { promise in
            let digestKey = DigestKey(fingerprint.digest)
            if recordPromise(promise, for: digestKey) {
                if let image = cache.object(forKey: digestKey) {
                    //print("HIT")
                    succeedPromises(for: digestKey, with: image)
                } else {
                    //print("MISS")
                    let cancellable = LifeHashGenerator.generate(fingerprint).sink { image in
                        serializer.sync {
                            cancellables[digestKey] = nil
                        }
                        cache.setObject(image, forKey: digestKey)
                        succeedPromises(for: digestKey, with: image)
                    }
                    serializer.sync {
                        cancellables[digestKey] = cancellable
                    }
                }
            }
        }
    }
}
