// Dim_Status
let
    S = Table.Distinct(Table.SelectColumns(Deposits, {"Status"})),
    Add = Table.AddColumn(S, "IsSuccessStatus", each if [Status]="OK" then "Successful" else "Failed", type text)
in
    Add
