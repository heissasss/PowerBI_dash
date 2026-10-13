// PlayerAffiliate
let
    Source = Csv.Document(
        File.Contents(FolderPath & "partner_union_players.csv"),
        [Delimiter=";", Columns=2, Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    Headers = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    Typed = Table.TransformColumnTypes(Headers, {{"Affiliate ID", type text}, {"Player ID", type text}}),
    Renamed = Table.RenameColumns(Typed, {{"Affiliate ID","AffiliateId"}, {"Player ID","UserId"}}),
    Trimmed = Table.TransformColumns(Renamed, {{"AffiliateId", Text.Trim, type text}, {"UserId", Text.Trim, type text}}),
    Dedup = Table.Distinct(Trimmed, {"UserId"})
in
    Dedup
