// StatusLog
let
    Source = Csv.Document(
        File.Contents(FolderPath & "Customer_status_change_report.csv"),
        [Delimiter=";", Columns=4, Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    Headers = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    Typed = Table.TransformColumnTypes(Headers, {
        {"User Id", type text},
        {"Change date", type datetime},
        {"Removed date", type datetime},
        {"Status", type text}
    }, "en-US"),
    Renamed = Table.RenameColumns(Typed, {
        {"User Id","UserId"}, {"Change date","ChangeDate"}, {"Removed date","RemovedDate"}}),
    Trimmed = Table.TransformColumns(Renamed, {{"UserId", Text.Trim, type text}, {"Status", Text.Trim, type text}}),
    Dedup = Table.Distinct(Trimmed)
in
    Dedup
