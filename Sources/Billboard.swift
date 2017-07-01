import Foundation
import Kanna

public class Billboard {
  var htmlContents: String?
  init(uniformResourceLocator: String) {
    let url = URL(string: uniformResourceLocator)
    if let doc = HTML(url: url!, encoding: .utf8) {
      print(doc)
    }
  }
}
