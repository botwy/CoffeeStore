//
//  iCoffeeWidget.swift
//  iCoffeeWidget
//

import WidgetKit
import SwiftUI
import Intents
import Firebase

struct ProductEntry: TimelineEntry {
    let date = Date()
    let product: ProductPromotion
}

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> ProductEntry {
        ProductEntry(product: productPromotionMock)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ProductEntry) -> ()) {
        FirebaseReference(.Promotion).getDocuments { (snapshot, error) in
            let products: [ProductPromotion]? = snapshot?.decode()
            let product = products?.first ?? productPromotionMock
            completion(ProductEntry(product: product))
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        FirebaseReference(.Promotion).getDocuments { (snapshot, error) in
            let products: [ProductPromotion]? = snapshot?.decode()
            let product = products?.first ?? productPromotionMock
            let timeline = Timeline(entries: [ProductEntry(product: product)], policy: .never)
            completion(timeline)
        }
    }
}

struct iCoffeeWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ProductWidgetView(product: entry.product)
    }
}

@main
struct iCoffeeWidget: Widget {
    init() {
        FirebaseApp.configure()
    }
    
    let kind: String = "iCoffeeWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            iCoffeeWidgetEntryView(entry: entry)
        }
    }
}
