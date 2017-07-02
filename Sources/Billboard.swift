import Foundation
import Kanna

public class Billboard {
  private var hot100Rows : XPathObject?
  public var htmlContents: String?
  public var returnedDocument: HTMLDocument?
  public init(uniformResourceLocator: String) {
    let url = URL(string: uniformResourceLocator)
    if let doc = HTML(url: url!, encoding: .utf8) {
      // returnedDocument = doc
      // htmlContents = doc.title
    }
  }
  
  public func listHot100() {
    if let doc = HTML(url: URL(string: "http://www.billboard.com/charts/hot-100")!, encoding: .utf8) {
      hot100Rows = doc.css(".chart-row")
      if let rows = hot100Rows {
        for row in rows {
          let songTitle = row.at_css(".chart-row__song")!.content!
          let songArtist = row.at_css(".chart-row__artist")!.content!
          let chartRank = row.at_css(".chart-row__current-week")!.content!
          print("\(chartRank) --- \(songTitle) | \(songArtist.trimmingCharacters(in: .whitespacesAndNewlines))")
        }
      }
    }
  }
}
