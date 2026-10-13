// Deposits
let
    Source = Csv.Document(
        File.Contents(FolderPath & "Deposit_history.csv"),
        [Delimiter=";", Columns=5, Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    Headers = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    Typed = Table.TransformColumnTypes(Headers, {
        {"Transaction", type text},
        {"User Id", type text},
        {"Date", type datetime},
        {"Amount", type number},
        {"Status", type text}
    }, "en-US"),
    Trimmed = Table.TransformColumns(Typed, {
        {"User Id", Text.Trim, type text},
        {"Transaction", Text.Trim, type text},
        {"Status", Text.Trim, type text}
    }),
    Dedup = Table.Distinct(Trimmed, {"Transaction"}),
    AddFlag = Table.AddColumn(Dedup, "IsSuccess", each if [Status] = "OK" then 1 else 0, Int64.Type),
    AddDate = Table.AddColumn(AddFlag, "DepositDate", each DateTime.Date([Date]), type date),
    Renamed = Table.RenameColumns(AddDate, {{"User Id", "UserId"}, {"Date", "DepositDateTime"}})
in
    Renamed
