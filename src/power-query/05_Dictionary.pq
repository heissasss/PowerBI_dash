// Dictionary
let
    Source = Csv.Document(
        File.Contents(FolderPath & "Dictionary Traffic.csv"),
        [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    #"Разделить столбец по разделителю" = Table.SplitColumn(Source, "Column1", Splitter.SplitTextByDelimiter(";", QuoteStyle.Csv), {"Column1.1", "Column1.2", "Column1.3", "Column1.4", "Column1.5", "Column1.6", "Column1.7", "Column1.8", "Column1.9", "Column1.10", "Column1.11"}),
    #"Другие удаленные столбцы" = Table.SelectColumns(#"Разделить столбец по разделителю",{"Column1.1", "Column1.2"}),
    Headers = Table.PromoteHeaders(#"Другие удаленные столбцы", [PromoteAllScalars=true]),
    Typed = Table.TransformColumnTypes(Headers, {{"Affiliate ID", type text}, {"Traffic", type text}}),
    Renamed = Table.RenameColumns(Typed, {{"Affiliate ID","AffiliateId"}}),
    Cleaned = Table.SelectRows(Table.TransformColumns(Renamed,
        {{"AffiliateId", each Text.Trim(_ ?? ""), type text}, {"Traffic", each Text.Trim(_ ?? ""), type text}}),
        each [AffiliateId] <> "" and [Traffic] <> ""),
    Dedup = Table.Distinct(Cleaned, {"AffiliateId"})
in
    Dedup
