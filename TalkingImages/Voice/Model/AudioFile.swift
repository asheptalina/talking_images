struct AudioFile: Identifiable {
    var id: UUID
    var name: String
    var url: URL
    var selected: Bool
    var playing: Bool

    init(name: String, fileName: String, type: String) {
        self.id = UUID()
        self.name = name
        let path = Bundle.main.path(forResource: fileName, ofType: type)!
        self.url = URL(fileURLWithPath: path)
        self.selected = false
        self.playing = false
    }
}
