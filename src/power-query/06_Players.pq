// Players
let
    Source = StatusLog,
    Reg = Table.Group(Table.SelectRows(Source, each [Status] = "Pending Verification"),
            {"UserId"}, {{"RegistrationDateTime", each List.Min([ChangeDate]), type nullable datetime}}),
    Ver = Table.Group(Table.SelectRows(Source, each [Status] = "Active"),
            {"UserId"}, {{"VerificationDateTime", each List.Min([ChangeDate]), type nullable datetime}}),
    AllUsers = Table.Distinct(Table.SelectColumns(Source, {"UserId"})),
    J1 = Table.ExpandTableColumn(Table.NestedJoin(AllUsers, {"UserId"}, Reg, {"UserId"}, "r", JoinKind.LeftOuter),
            "r", {"RegistrationDateTime"}),
    J2 = Table.ExpandTableColumn(Table.NestedJoin(J1, {"UserId"}, Ver, {"UserId"}, "v", JoinKind.LeftOuter),
            "v", {"VerificationDateTime"}),
    FTD = Table.Group(Table.SelectRows(Deposits, each [Status] = "OK"),
            {"UserId"}, {{"FirstDepositDateTime", each List.Min([DepositDateTime]), type nullable datetime}}),
    J3 = Table.ExpandTableColumn(Table.NestedJoin(J2, {"UserId"}, FTD, {"UserId"}, "d", JoinKind.LeftOuter),
            "d", {"FirstDepositDateTime"}),
    J4 = Table.ExpandTableColumn(Table.NestedJoin(J3, {"UserId"}, PlayerAffiliate, {"UserId"}, "a", JoinKind.LeftOuter),
            "a", {"AffiliateId"}),
    Key = Table.AddColumn(J4, "AffiliateKey", each if [AffiliateId] = null or [AffiliateId] = "" then "ORGANIC" else [AffiliateId], type text),
    AddDates = Table.AddColumn(
        Table.AddColumn(
            Table.AddColumn(Key, "RegistrationDate", each Date.From([RegistrationDateTime]), type nullable date),
            "VerificationDate", each Date.From([VerificationDateTime]), type nullable date),
        "FirstDepositDate", each Date.From([FirstDepositDateTime]), type nullable date),
    Hours = Table.AddColumn(AddDates, "HoursToFTD",
        each if [FirstDepositDateTime] = null or [RegistrationDateTime] = null then null
             else Duration.TotalHours([FirstDepositDateTime] - [RegistrationDateTime]), type nullable number),
    Flags = Table.AddColumn(
        Table.AddColumn(
            Table.AddColumn(Hours, "IsRegistered", each if [RegistrationDateTime] <> null then 1 else 0, Int64.Type),
            "IsVerified", each if [VerificationDateTime] <> null then 1 else 0, Int64.Type),
        "IsDepositor", each if [FirstDepositDateTime] <> null then 1 else 0, Int64.Type),
    Final = Table.SelectColumns(Flags, {"UserId","AffiliateKey","RegistrationDateTime","RegistrationDate",
        "VerificationDateTime","VerificationDate","FirstDepositDateTime","FirstDepositDate",
        "HoursToFTD","IsRegistered","IsVerified","IsDepositor"})
in
    Final
