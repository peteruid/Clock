import SwiftUI

struct Theme: Identifiable, Equatable {
    let id: String
    let name: String
    let cardColor: Color
    let textColor: Color
    let separatorColor: Color

    static let all: [Theme] = [
        Theme(id: "classic",  name: "Classic",  cardColor: Color(red: 0.14, green: 0.14, blue: 0.16), textColor: .white,                                    separatorColor: Color(red: 0.08, green: 0.08, blue: 0.10)),
        Theme(id: "midnight", name: "Midnight", cardColor: Color(red: 0.05, green: 0.05, blue: 0.05), textColor: Color(red: 0.94, green: 0.94, blue: 0.94), separatorColor: .black),
        Theme(id: "retro",    name: "Retro",    cardColor: Color(red: 0.24, green: 0.17, blue: 0.11), textColor: Color(red: 0.96, green: 0.90, blue: 0.78), separatorColor: Color(red: 0.18, green: 0.11, blue: 0.05)),
        Theme(id: "terminal", name: "Terminal", cardColor: Color(red: 0.04, green: 0.10, blue: 0.04), textColor: Color(red: 0.20, green: 1.00, blue: 0.20), separatorColor: .black),
        Theme(id: "ocean",    name: "Ocean",    cardColor: Color(red: 0.04, green: 0.10, blue: 0.16), textColor: Color(red: 0.31, green: 0.76, blue: 0.97), separatorColor: Color(red: 0.03, green: 0.07, blue: 0.13)),
        Theme(id: "sunset",   name: "Sunset",   cardColor: Color(red: 0.10, green: 0.04, blue: 0.00), textColor: Color(red: 1.00, green: 0.60, blue: 0.00), separatorColor: Color(red: 0.05, green: 0.02, blue: 0.00)),
        Theme(id: "snow",     name: "Snow",     cardColor: Color(red: 0.91, green: 0.91, blue: 0.91), textColor: Color(red: 0.10, green: 0.10, blue: 0.10), separatorColor: Color(red: 0.82, green: 0.82, blue: 0.82)),
        Theme(id: "rose",     name: "Rose",     cardColor: Color(red: 0.10, green: 0.04, blue: 0.06), textColor: Color(red: 1.00, green: 0.42, blue: 0.62), separatorColor: Color(red: 0.05, green: 0.02, blue: 0.03)),
        Theme(id: "cream",    name: "Cream",    cardColor: Color(red: 0.96, green: 0.93, blue: 0.87), textColor: Color(red: 0.30, green: 0.22, blue: 0.14), separatorColor: Color(red: 0.90, green: 0.86, blue: 0.80)),
        // Mindmap-inspired themes
        Theme(id: "cappuccino",  name: "Cappuccino",  cardColor: Color(red: 0.94, green: 0.85, blue: 0.70), textColor: Color(red: 0.40, green: 0.28, blue: 0.16), separatorColor: Color(red: 0.86, green: 0.76, blue: 0.60)),
        Theme(id: "blackboard",  name: "Blackboard",  cardColor: Color(red: 0.08, green: 0.12, blue: 0.08), textColor: Color(red: 0.98, green: 0.84, blue: 0.41), separatorColor: Color(red: 0.04, green: 0.07, blue: 0.04)),
        Theme(id: "darkneon",    name: "Dark Neon",   cardColor: Color(red: 0.08, green: 0.08, blue: 0.15), textColor: Color(red: 0.00, green: 0.90, blue: 0.80), separatorColor: Color(red: 0.05, green: 0.05, blue: 0.10)),
        Theme(id: "hotcocoa",    name: "Hot Cocoa",   cardColor: Color(red: 0.18, green: 0.13, blue: 0.10), textColor: Color(red: 0.96, green: 0.82, blue: 0.65), separatorColor: Color(red: 0.12, green: 0.08, blue: 0.05)),
        Theme(id: "sprout",      name: "Sprout",      cardColor: Color(red: 0.90, green: 0.96, blue: 0.88), textColor: Color(red: 0.11, green: 0.34, blue: 0.28), separatorColor: Color(red: 0.82, green: 0.90, blue: 0.80)),
        Theme(id: "vintage",     name: "Vintage",     cardColor: Color(red: 0.97, green: 0.95, blue: 0.92), textColor: Color(red: 0.76, green: 0.26, blue: 0.11), separatorColor: Color(red: 0.90, green: 0.88, blue: 0.84)),
        Theme(id: "delight",     name: "Delight",     cardColor: Color(red: 0.12, green: 0.06, blue: 0.16), textColor: Color(red: 0.69, green: 0.22, blue: 0.95), separatorColor: Color(red: 0.07, green: 0.03, blue: 0.10)),
        Theme(id: "elegant",     name: "Elegant",     cardColor: Color(red: 0.04, green: 0.08, blue: 0.14), textColor: Color(red: 0.15, green: 0.73, blue: 0.82), separatorColor: Color(red: 0.02, green: 0.05, blue: 0.10)),
        Theme(id: "fresh",       name: "Fresh",       cardColor: Color(red: 0.04, green: 0.12, blue: 0.10), textColor: Color(red: 0.28, green: 0.69, blue: 0.30), separatorColor: Color(red: 0.02, green: 0.07, blue: 0.06)),
        Theme(id: "sandbox",     name: "Sandbox",     cardColor: Color(red: 0.96, green: 0.92, blue: 0.82), textColor: Color(red: 0.80, green: 0.50, blue: 0.00), separatorColor: Color(red: 0.90, green: 0.85, blue: 0.74)),
        Theme(id: "candyland",   name: "Candyland",   cardColor: Color(red: 0.97, green: 0.95, blue: 0.96), textColor: Color(red: 0.23, green: 0.75, blue: 0.74), separatorColor: Color(red: 0.90, green: 0.88, blue: 0.89)),
        Theme(id: "modern",      name: "Modern",      cardColor: Color(red: 0.10, green: 0.04, blue: 0.14), textColor: Color(red: 0.47, green: 0.00, blue: 0.85), separatorColor: Color(red: 0.06, green: 0.02, blue: 0.08)),
        Theme(id: "classiclight", name: "Classic Light", cardColor: Color(red: 0.92, green: 0.95, blue: 1.00), textColor: Color(red: 0.30, green: 0.50, blue: 0.80), separatorColor: Color(red: 0.84, green: 0.88, blue: 0.94)),
        Theme(id: "spruce",      name: "Spruce",      cardColor: Color(red: 0.06, green: 0.10, blue: 0.06), textColor: Color(red: 0.70, green: 0.88, blue: 0.65), separatorColor: Color(red: 0.03, green: 0.06, blue: 0.03)),
        Theme(id: "coffee",      name: "Coffee",      cardColor: Color(red: 0.11, green: 0.10, blue: 0.09), textColor: Color(red: 1.00, green: 1.00, blue: 0.88), separatorColor: Color(red: 0.07, green: 0.06, blue: 0.05)),
        Theme(id: "greyscale",   name: "Greyscale",   cardColor: Color(red: 0.95, green: 0.95, blue: 0.95), textColor: Color(red: 0.20, green: 0.20, blue: 0.20), separatorColor: Color(red: 0.85, green: 0.85, blue: 0.85)),
        Theme(id: "printing",    name: "Printing",    cardColor: Color(red: 1.00, green: 1.00, blue: 1.00), textColor: Color(red: 0.06, green: 0.06, blue: 0.06), separatorColor: Color(red: 0.90, green: 0.90, blue: 0.90)),
        Theme(id: "liberty",     name: "Liberty",     cardColor: Color(red: 0.176, green: 0.176, blue: 0.176), textColor: .white, separatorColor: Color(red: 0.12, green: 0.12, blue: 0.12)),
        Theme(id: "widget",      name: "Widget",      cardColor: Color(.displayP3, red: 38/255, green: 47/255, blue: 51/255), textColor: .white, separatorColor: Color(.displayP3, red: 26/255, green: 33/255, blue: 36/255)),
    ]

    static let `default` = all[0]

    static func named(_ id: String) -> Theme {
        all.first { $0.id == id } ?? .default
    }
}
