// Dim_Affiliate
let
    FromPlayers = Table.Distinct(Table.SelectColumns(PlayerAffiliate, {"AffiliateId"})),
    FromDict = Table.Distinct(Table.SelectColumns(Dictionary, {"AffiliateId"})),
    AllAff = Table.Distinct(Table.Combine({FromPlayers, FromDict})),
    Joined = Table.ExpandTableColumn(
        Table.NestedJoin(AllAff, {"AffiliateId"}, Dictionary, {"AffiliateId"}, "d", JoinKind.LeftOuter),
        "d", {"Traffic"}),
    FillTraffic = Table.TransformColumns(Joined, {{"Traffic", each if _ = null or _ = "" then "Unknown" else _, type text}}),
    Keyed = Table.AddColumn(FillTraffic, "AffiliateKey", each [AffiliateId], type text),
    Named = Table.AddColumn(Keyed, "AffiliateName", each "Affiliate " & [AffiliateId], type text),
    Organic = Table.FromRecords({[AffiliateId = null, Traffic = "Organic", AffiliateKey = "ORGANIC", AffiliateName = "Organic"]},
        type table [AffiliateId = nullable text, Traffic = text, AffiliateKey = text, AffiliateName = text]),
    Result = Table.Combine({Table.SelectColumns(Named, {"AffiliateId","Traffic","AffiliateKey","AffiliateName"}), Organic}),
    Group = Table.AddColumn(Result, "TrafficGroup", each if [Traffic] = "Organic" then "Organic" else "Affiliate", type text)
in
    Group
