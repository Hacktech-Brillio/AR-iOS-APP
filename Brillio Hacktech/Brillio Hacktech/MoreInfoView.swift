//
//  MoreInfoView.swift
//  Brillio Hacktech
//
//  Created by Vlad Marian on 26.10.2024.
//

import SwiftUI

struct MoreInfoView: View {
    let product: ProductInfo

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Product Title
                if let title = product.properties.title.first {
                    Text(title)
                        .font(.title)
                        .bold()
                        .padding(.bottom, 8)
                }

                // Brand and Manufacturer
                Group {
                    if let brand = product.properties.brand {
                        InfoRow(icon: "tag", label: "Brand", value: brand)
                    }
                    if let manufacturer = product.properties.manufacturer {
                        InfoRow(icon: "building.2", label: "Manufacturer", value: manufacturer)
                    }
                    if let mpn = product.properties.mpn {
                        InfoRow(icon: "number", label: "MPN", value: mpn)
                    }
                }

                // Size and Weight
                Group {
                    if let size = product.properties.size {
                        InfoRow(icon: "ruler", label: "Size", value: size)
                    }
                    if let itemWeight = product.properties.itemWeight {
                        InfoRow(icon: "scalemass", label: "Item Weight", value: itemWeight)
                    }
                }

                // Features
                if let features = product.properties.features, !features.isEmpty {
                    Text("Features")
                        .font(.headline)
                        .padding(.top, 8)
                    ForEach(features, id: \.self) { feature in
                        Text("• \(feature)")
                            .font(.body)
                    }
                }

                // Description
                if let description = product.properties.description?.first {
                    Text("Description")
                        .font(.headline)
                        .padding(.top, 8)
                    Text(description)
                        .font(.body)
                }

                // Additional Properties
                Group {
                    if let ingredients = product.properties.ingredients {
                        Text("Ingredients")
                            .font(.headline)
                            .padding(.top, 8)
                        Text(ingredients)
                            .font(.body)
                    }
                    if let directions = product.properties.directions {
                        Text("Directions")
                            .font(.headline)
                            .padding(.top, 8)
                        Text(directions)
                            .font(.body)
                    }
                    if let warning = product.properties.warning {
                        Text("Warning")
                            .font(.headline)
                            .padding(.top, 8)
                        Text(warning)
                            .font(.body)
                            .foregroundColor(.red)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Product Details")
    }
}
#Preview {
    MoreInfoView(product: ProductInfo(
        gtin: "0000000000000", // Replace with actual GTIN if available
        properties: ProductProperties(
            title: [
                "Neutrogena 23187 Norwegian Formula Lip Moisturizer LSF4",
                "Neutrogena Lips Stick 4.8g. Shipping Is Free",
                "Neutrogena Lip balm LSF 4 / IP 4 / SPF 4 For dry and cracked lips - Norwegian formula",
                "Neutrogena Lips Stick 4.8g",
                "Neutrogena Balzam na pery SPF 4 v blistri (Lippen) 4,8 g",
                "Neutrogena Balsam de buze SPF 4 în blister (Lippen) 4,8 g",
                "Neutrogena Stick Lèvres 4,8",
                "Neutrogena Norweg.formel Lippenschutz LSF 4 4.8 G",
                "Neutrogena labios cacao protección spf5 4,8 g",
                "NEUTROGENA Stick Lèvres (4,8 g) - Accessoire beauté",
                "Neutrogena® Norwegische Formel Lippenpflegestift Classic 4,8 g Stifte",
                "Varios - NEUTROGENA PROTECTOR LABIAL SPF5",
                "Neutrogena Lips Stick 4.8g Lip Balm Lip Butter",
                "Neutrogena Labbra Stick Idratante 4 8 G"
            ],
            description: [
                "The stick Neutrogena lips hydrates durably and effectively protects the lips desiccated by the extreme conditions (cold, wind, dryness of the air,...).",
                "Balzam na pery s vysokým obsahom glycerínu chráni vaše pery proti nepriaznivým vplyvom prostredia.",
                "Balsam de buze cu un continut ridicat de glicerina protejeaza buzele de medii dure.",
                "Protector Labial Se trata de un stick de uso diario que hidrata, protege del frío y previene las fisuras. Es transparente y de uso familiar (mujeres, hombres y niños), siendo además una perfecta base bajo la barra de labios. Su cómodo formato en stick permite tenerlo a mano en cualquier situación, convirtiéndose en un práctico remedio para decir adiós a los labios secos, cortados y agrietados.",
                "This moisture-rich formula soothes and improves dry, chapped lips"
            ],
            brand: "Neutrogena",
            manufacturer: "Neutrogena",
            mpn: "2042724",
            features: [
                "Fragrance-free",
                "Helps prevent the appearance of lip eruptions",
                "Developed with Dermatologist",
                "Lip Moisturizer softens, smoothes and protects dry, chapped lips with no waxy feel",
                "Leaves lips soft, smooth and moisturized",
                "Farblos"
            ],
            itemWeight: nil,
            partNumber: nil,
            size: "4.8g",
            ingredients: nil,
            directions: nil,
            warning: nil,
            label: "Johnson & Johnson GmbH",
            distributorAddress: "Limmatstrasse 152, CH-8031 Zürich",
            distributorName: "Migros-Genossenschafts-Bund",
            gender: "female",
            formulation: nil,
            usage: nil,
            spf: nil,
            volume: "Standard"
        ),
        stores: [
            StoreInfo(
                store: "Amazon UK",
                image: "https://images-eu.ssl-images-amazon.com/images/I/419OD-xWs2L.jpg",
                url: "https://www.amazon.co.uk/dp/B000VJXIVI",
                categories: ["Beauty", "Personal Care"],
                price: Price(
                    list: "3.33",
                    sale: nil,
                    currency: "GBP",
                    perUnit: nil,
                    price: nil
                ),
                asin: "B000VJXIVI",
                sku: nil
            ),
            StoreInfo(
                store: "eBay Australia",
                image: "https://i.ebayimg.com/images/i/114397668912-0-1/s-l500.jpg",
                url: "https://www.ebay.com.au/itm/114397668912",
                categories: ["Health & Beauty", "Makeup", "Face"],
                price: nil,
                asin: nil,
                sku: nil
            ),
            StoreInfo(
                store: "Migros",
                image: "https://image.migros.ch/mo-boxed/v-w-420-h-420/8a708aea4a18b4c2f3c1923b1c8bf5575f95b23b/neutrogena-lippenpflege-spf-4.jpg",
                url: "https://www.migros.ch/en/product/513333700000",
                categories: nil,
                price: Price(
                    list: nil,
                    sale: nil,
                    currency: "CHF",
                    perUnit: "57.30/100g",
                    price: nil
                ),
                asin: nil,
                sku: nil
            ),
            StoreInfo(
                store: "Amazon",
                image: "https://images-na.ssl-images-amazon.com/images/I/31E1ct854gL.jpg",
                url: "https://www.amazon.com/dp/B000VJXIVI",
                categories: ["Health And Beauty"],
                price: Price(
                    list: "9.40",
                    sale: nil,
                    currency: "USD",
                    perUnit: nil,
                    price: nil
                ),
                asin: "B000VJXIVI",
                sku: nil
            ),
            StoreInfo(
                store: "Vivantis Slovakia",
                image: "https://img.vivantis.net/feedphotos/w800_h650_fN/k/_orig/NE/balzam-na-rty-s-blistrem-spf-4-4-8g_14345105.jpg",
                url: "https://www.vivantis.sk/kozmetika/balzam-na-pery-s-blistrom-spf-4-4-8g.html",
                categories: [],
                price: nil,
                asin: nil,
                sku: "kneu009"
            ),
            StoreInfo(
                store: "Vivantis Romania",
                image: "https://img.vivantis.net/feedphotos/w800_h650_fN/k/_orig/NE/balzam-na-rty-s-blistrem-spf-4-4-8g_14345105.jpg",
                url: "https://www.vivantis.ro/cosmetice/balsam-de-buze-spf-4-n-blister-lippen-4-8-g.html",
                categories: [],
                price: nil,
                asin: nil,
                sku: "kneu009"
            ),
            StoreInfo(
                store: "eBay France",
                image: "https://i.ebayimg.com/images/i/392914585567-0-1/s-l500.jpg",
                url: "https://www.ebay.fr/itm/392914585567",
                categories: ["Beauté, bien-être, parfums", "Soins du visage", "Soins des lèvres"],
                price: nil,
                asin: nil,
                sku: nil
            ),
            StoreInfo(
                store: "eBay Germany",
                image: "https://i.ebayimg.com/images/g/7WgAAOSwQ7haxTU1/s-l1600.jpg",
                url: "https://www.ebay.de/p/1319901297",
                categories: nil,
                price: nil,
                asin: nil,
                sku: nil
            ),
            StoreInfo(
                store: "Rakuten.es",
                image: "https://tshop.r10s.com/c58/772/04fa/2253/e017/c9dd/7539/11cee5bcb7005056ae3866.jpg",
                url: "https://www.rakuten.es/tienda/boticadigital/producto/4312/",
                categories: ["Salud, Belleza", "Maquillaje"],
                price: Price(
                    list: nil,
                    sale: "5.95",
                    currency: "EUR",
                    perUnit: nil,
                    price: nil
                ),
                asin: nil,
                sku: "2-26050"
            ),
            StoreInfo(
                store: "fnac marketplace",
                image: "https://d4.cnnx.io/image/obj/8380223493;sq=400",
                url: "https://www.fnac.com/mp24340240/NEUTROGENA-Stick-Levres-4-8-g/w-4",
                categories: nil,
                price: nil,
                asin: nil,
                sku: nil
            ),
            StoreInfo(
                store: "SHOP APOTHEKE",
                image: "https://d2.cnnx.io/image/obj/9091710366;sq=400",
                url: "https://www.shop-apotheke.com/beauty/4102571/neutrogena-norwegische-formel-lippenpflegestift-classic.htm",
                categories: nil,
                price: nil,
                asin: nil,
                sku: nil
            ),
            StoreInfo(
                store: "Amazon Canada",
                image: "https://images-na.ssl-images-amazon.com/images/I/419OD-xWs2L.jpg",
                url: "https://www.amazon.ca/dp/B000VJXIVI",
                categories: ["Beauty", "Health And Beauty"],
                price: nil,
                asin: "B000VJXIVI",
                sku: nil
            ),
            StoreInfo(
                store: "eBay",
                image: "https://i.ebayimg.com/images/i/113299053072-0-1/s-l500.jpg",
                url: "https://www.ebay.com/itm/113299053072",
                categories: ["Health & Beauty", "Skin Care", "Lip Balm & Treatments"],
                price: nil,
                asin: nil,
                sku: nil
            ),
            StoreInfo(
                store: "eBay Italy",
                image: "https://i.ebayimg.com/images/g/7WgAAOSwQ7haxTU1/s-l1600.jpg",
                url: "https://www.ebay.it/p/1239946861",
                categories: nil,
                price: nil,
                asin: nil,
                sku: nil
            )
        ]
    ))
}
