//
//  ID3FrameContentParser.swift
//
//  Created by Fabrizio Duroni on 23/02/2018.
//  2018 Fabrizio Duroni.
//

import Foundation

class ID3FrameContentParser: FrameContentParser {
    private let frameContentParsingOperations: [FrameType : FrameContentParsingOperation]
    private var id3FrameConfiguration: ID3FrameConfiguration

    init(frameContentParsingOperations: [FrameType : FrameContentParsingOperation],
         id3FrameConfiguration: ID3FrameConfiguration) {
        self.frameContentParsingOperations = frameContentParsingOperations
        self.id3FrameConfiguration = id3FrameConfiguration
    }

    func parse(frame: Data, id3Tag: ID3Tag) {
        let frameType = getFrameTypeFrom(frame: frame, version: id3Tag.properties.version)
        if (isAValid(frameType: frameType)) {
            frameContentParsingOperations[frameType]?.parse(frame: frame, id3Tag: id3Tag)
        }
        // parse any tags
        let frameIdentifier = getFrameIdentifierFrom(frame: frame, version: id3Tag.properties.version)
        let NonStringIdentifiers = ["APIC"]
        if !NonStringIdentifiers.contains(frameIdentifier) {
            let parser = ID3FrameStringContentParsingOperationFactory.make() { (id3Tag: ID3Tag, content: String) in
                id3Tag.tags[frameIdentifier] = content
            }
            parser.parse(frame: frame, id3Tag: id3Tag)
        }
    }
    
    private func getFrameIdentifierFrom(frame: Data, version: ID3Version) -> String {
        let frameIdentifierSize = id3FrameConfiguration.identifierSizeFor(version: version)
        let frameIdentifierData = [UInt8](frame.subdata(in: Range(0...frameIdentifierSize - 1)))
        return toString(frameIdentifier: frameIdentifierData)
    }

    private func getFrameTypeFrom(frame: Data, version: ID3Version) -> FrameType {
        let frameIdentifier = getFrameIdentifierFrom(frame: frame, version: version)
        let frameType = id3FrameConfiguration.frameTypeFor(identifier: frameIdentifier, version: version)
        return frameType
    }

    private func isAValid(frameType: FrameType) -> Bool {
        return frameType != .Invalid
    }

    private func toString(frameIdentifier: [UInt8]) -> String {
        return frameIdentifier.reduce("") { (convertedString, byte) -> String in
            return convertedString + String(Character(UnicodeScalar(byte)))
        }
    }
}
