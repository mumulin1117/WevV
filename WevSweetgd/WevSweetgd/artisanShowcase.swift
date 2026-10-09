import Foundation

struct artisanShowcase {
    let donutPinKey: String
    let rainbowSprinkleDesign: String
    let pastelPalettePattern: String
}

struct tastingPassportPage {
    let sprinkleJarKey: String
    let tastingJournalEntry: String
    let flavorSpectrumInsight: String
    let crumbScoreNote: String
    let textureContrastNotes: String
    let sugarPearlGarnish: String
    let donutFrameAsset: String?

    init(
        sprinkleJarKey: String,
        tastingJournalEntry: String,
        flavorSpectrumInsight: String,
        crumbScoreNote: String,
        textureContrastNotes: String,
        sugarPearlGarnish: String,
        donutFrameAsset: String? = nil
    ) {
        self.sprinkleJarKey = sprinkleJarKey
        self.tastingJournalEntry = tastingJournalEntry
        self.flavorSpectrumInsight = flavorSpectrumInsight
        self.crumbScoreNote = crumbScoreNote
        self.textureContrastNotes = textureContrastNotes
        self.sugarPearlGarnish = sugarPearlGarnish
        self.donutFrameAsset = donutFrameAsset
    }
}

struct shopWindowCollection {
    let flavorLibraryEdition: String
    let pastryDisplayShowcase: String
    let bakeryTrailLine: String
    let crumbScoreNote: String
    let coverAsset: String
}

struct bakeryCollectionFolio {
    let donutPinKey: String
    let sweetShowcaseMap: String
    let flavorMenuGuide: String
    let glazeGalleryGuide: String
    let crumbScoreNote: String
    let tastingSequenceInsight: String
    let bakeryTrailLine: String
    let seasonalMenuCollection: [artisanShowcase]
    let tastingMemoryCollection: [tastingPassportPage]
    let shopHoppingTrail: [shopWindowCollection]
}
