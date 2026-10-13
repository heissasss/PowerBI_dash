// Dim_Date
let
    MinDate = List.Min({List.Min(Players[RegistrationDate]), List.Min(Deposits[DepositDate])}),
    MaxDate = List.Max({List.Max(Players[RegistrationDate]), List.Max(Deposits[DepositDate])}),
    Start = Date.StartOfYear(MinDate),
    Days = Duration.Days(Date.EndOfYear(MaxDate) - Start) + 1,
    Dates = List.Dates(Start, Days, #duration(1,0,0,0)),
    T = Table.FromList(Dates, Splitter.SplitByNothing(), {"Date"}),
    Typed = Table.TransformColumnTypes(T, {{"Date", type date}}),
    Add = Table.AddColumn(Table.AddColumn(Table.AddColumn(Table.AddColumn(Table.AddColumn(Table.AddColumn(Typed,
        "Year", each Date.Year([Date]), Int64.Type),
        "MonthNo", each Date.Month([Date]), Int64.Type),
        "Month", each Date.ToText([Date], "yyyy-MM"), type text),
        "MonthSort", each Date.Year([Date]) * 100 + Date.Month([Date]), Int64.Type),
        "YearQuarter", each Text.From(Date.Year([Date])) & "-Q" & Text.From(Date.QuarterOfYear([Date])), type text),
        "WeekStart", each Date.StartOfWeek([Date], Day.Monday), type date)
in
    Add
