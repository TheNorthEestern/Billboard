//
//  BillboardEntry.swift
//  Billboard
//
//  Created by Kacy James on 7/4/17.
//
//

import Foundation

public struct BillboardEntry {
  public let songTitle : String
  public let artistName : String
  public let currentRank : String
  public let previousRank : Character
  public var entryContent : String {
    return "\(currentRank) -- \(songTitle) -- \(artistName)"
  }
  
  init(songTitle: String, artistName: String, currentRank: String, previousRank: Character) {
    self.songTitle = songTitle
    self.artistName = artistName
    self.currentRank = currentRank
    self.previousRank = previousRank
  }
}
