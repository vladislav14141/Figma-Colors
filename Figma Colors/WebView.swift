//
//  WebView.swift
//  Figma Colors
//
//  Created by Владислав Миронов on 17.03.2021.
//

import SwiftUI
import WebKit
import HTMLKit
class WebViewModel: ObservableObject {
    @Published var link: String
    @Published var didFinishLoading: Bool = false
    @Published var pageTitle: String
    
    init (link: String) {
        self.link = link
        self.pageTitle = ""
    }
}

struct SwiftUIWebView: NSViewRepresentable {
    
    public typealias NSViewType = WKWebView
    @ObservedObject var viewModel: WebViewModel

    private let webView: WKWebView = {
        let pref = WKPreferences()
        pref.javaEnabled = true
        let config = WKWebViewConfiguration()
        config.applicationNameForUserAgent = "Version/8.0.2 Safari/600.2.5"

        config.preferences = pref
        return WKWebView(frame: .infinite, configuration: config)
    }()
    
    init(viewModel: WebViewModel) {
        self.viewModel = viewModel
    }
    
    public func makeNSView(context: NSViewRepresentableContext<SwiftUIWebView>) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator as? WKUIDelegate
        webView.load(URLRequest(url: URL(string: viewModel.link)!))
        return webView
    }

    public func updateNSView(_ nsView: WKWebView, context: NSViewRepresentableContext<SwiftUIWebView>) {
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(viewModel)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        private var viewModel: WebViewModel

        init(_ viewModel: WebViewModel) {
           //Initialise the WebViewModel
           self.viewModel = viewModel
        }
        
        public func webView(_: WKWebView, didFail: WKNavigation!, withError: Error) { }

        public func webView(_: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) { }

        //After the webpage is loaded, assign the data in WebViewModel class
        public func webView(_ web: WKWebView, didFinish: WKNavigation!) {
            self.viewModel.pageTitle = web.title!
            self.viewModel.link = web.url?.absoluteString ?? ""
            self.viewModel.didFinishLoading = true
            web.evaluateJavaScript("document.body.innerHTML", completionHandler: { (value, err) in
                guard let html = value else {
                    print("err:",err)
                    return
                }
                print("html:", html)
                print("--------------------")

                let doc = HTMLDocument(string: html as! String)
                let images: [String] = doc.querySelectorAll("div").compactMap({ element in
                    guard let src = element.attributes["data-tooltip-style-description"] as? String else {
                        return nil
                    }
                    return src
                })
                
                print("value:", images)

            })
        }

        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) { }

        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(.allow)
        }

    }

}

struct WebView : NSViewRepresentable {
    
    let request: URLRequest
    
    func makeNSView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateNSView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
    
}

#if DEBUG
struct WebView_Previews : PreviewProvider {
    static var previews: some View {
        WebView(request: URLRequest(url: URL(string: "https://www.apple.com")!))
    }
}
#endif
