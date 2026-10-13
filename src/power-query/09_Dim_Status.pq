// Dim_Status
let
    S = Table.Distinct(Table.SelectColumns(Deposits, {"Status"})),
    Add = Table.AddColumn(S, "IsSuccessStatus", each if [Status]="OK" then "Успешные" else "Неуспешные", type text)
in
    Add
