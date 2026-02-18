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
    ]

    static let `default` = all[0]

    static func named(_ id: String) -> Theme {
        all.first { $0.id == id } ?? .default
    }
}
