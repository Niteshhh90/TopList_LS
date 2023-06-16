tableextension 52020 TenderTypeSetupExtAPH extends "LSC Tender Type Setup"
{
    fields
    {
        field(52002; PaymentsAPH; Decimal)
        {
            CalcFormula = Sum("LSC Trans. Payment Entry"."Amount Tendered" WHERE("Tender Type" = FIELD(Code),
                                                                              "Staff ID" = FIELD("Staff Filter"),
                                                                              "POS Terminal No." = FIELD("POS Filter"),
                                                                              Date = FIELD("Date Filter"),
                                                                              "Store No." = FIELD("Store Filter"),
                                                                              "Transaction Type APH" = const(Sales)));
            Caption = 'PaymentsAPH';
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(52003; "No. of Payments APH"; Decimal)
        {
            CalcFormula = Sum("LSC Trans. Payment Entry".Counter WHERE("Tender Type" = FIELD(Code),
                                                                    "Staff ID" = FIELD("Staff Filter"),
                                                                    "POS Terminal No." = FIELD("POS Filter"),
                                                                    Date = FIELD("Date Filter"),
                                                                    "Store No." = FIELD("Store Filter"),
                                                                    "Transaction Type APH" = const(Sales)));
            Caption = 'No. of PaymentsAPH';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
