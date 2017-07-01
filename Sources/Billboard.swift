import Foundation
import Kanna

public class Billboard {
  var htmlContents: String?
  public init() {}
  public init(uniformResourceLocator: String) {
    let url = URL(string: uniformResourceLocator)
    if let doc = HTML(url: url!, encoding: .utf8) {
      print(doc)
    }
  }
}
