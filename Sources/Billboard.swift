import Foundation
import Kanna

public class Billboard {
  private var hot100Rows : XPathObject?
  private var hot100 = [BillboardEntry]()
  public var htmlContents: String?
  public var returnedDocument: HTMLDocument?
  public init(uniformResourceLocator: String) {
    /* let url = URL(string: uniformResourceLocator)
    if let doc = HTML(url: url!, encoding: .utf8) {
      // returnedDocument = doc
      // htmlContents = doc.title
    } */
  }
  
  public func fetchHot100() {
    if let doc = HTML(url: URL(string: "http://www.billboard.com/charts/hot-100")!, encoding: .utf8) {
      if let rows = doc.css(".chart-row") as XPathObject? {
        for row in rows {
          let songTitle = row.at_css(".chart-row__song")!.content!
          let artistName = row.at_css(".chart-row__artist")!.content!
          let currentRank = row.at_css(".chart-row__current-week")!.content!
          let previousRank = row.at_css(".chart-row__last-week")!.content!
          
          hot100.append(BillboardEntry(songTitle: songTitle, artistName: artistName.trimmingCharacters(in: .whitespacesAndNewlines), currentRank: currentRank, previousRank: previousRank.characters.last!))
        }
      }
    }
  }
  
  public func listHot100() {
    for row in hot100 {
      print("\(row.currentRank) --- \(row.songTitle) | \(row.artistName)")
    }
  }
}
