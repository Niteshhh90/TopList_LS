tableextension 52000 "Toplist Work Table Ext TTT" extends "LSC Toplist Work Table"
{
    fields
    {
        field(52000; "Sales Type Filter"; Code[30])
        {
            FieldClass = FlowFilter;
            Caption = 'Sales Type';
            TableRelation = "LSC Sales Type";
        }
        field(52001; "Line No. Of Transactions"; Integer)
        {
            Caption = 'No. Of Transactions';
            DataClassification = CustomerContent;
        }
        field(52002; IPC; Decimal)
        {
            Caption = 'IPC';
            DataClassification = CustomerContent;
        }
        field(52003; ATV; Decimal)
        {
            Caption = 'ATV';
            DataClassification = CustomerContent;
        }
        field(52004; "Guest Count"; Integer)
        {
            Caption = 'Guest Count';
            DataClassification = CustomerContent;
        }
    }
}