tableextension 52021 TransPaymentEntriesExt extends "LSC Trans. Payment Entry"
{
    fields
    {
        field(52002; "Transaction Type APH"; Option)
        {
            Caption = 'Transaction Type';
            FieldClass = FlowField;
            CalcFormula = lookup("LSC Transaction Header"."Transaction Type" where(
                                "Store No." = field("Store No."),
                                "POS Terminal No." = field("POS Terminal No."),
                                "Transaction No." = field("Transaction No.")));
            OptionCaption = 'Logoff,Logon,Sales,Payment,Remove Tender,Float Entry,Change Tender,Tender Decl.,Voided,Open Drawer,NegAdj,PhysInv,Collect,Cancelation';
            OptionMembers = Logoff,Logon,Sales,Payment,"Remove Tender","Float Entry","Change Tender","Tender Decl.",Voided,"Open Drawer",NegAdj,PhysInv,Collect,Cancelation;
        }
    }
}
