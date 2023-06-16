report 57000 "Staff Wise Sales - APH"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './R57000_StaffWiseSalesAPH.rdl';

    dataset
    {
        dataitem("LSC Trans. Sales Entry"; "LSC Trans. Sales Entry")
        {
            RequestFilterFields = "Created by Staff ID", Date, "Item No.";
            column(CompInfo_Name; CompInfo.Name) { }
            column(CompInfo_Picture; CompInfo.Picture) { }
            column(CurrDate; Today) { }
            column(CurrTime; Time) { }
            column(Filters; GETFILTERS) { }
            column(StaffNo; "Created by Staff ID") { }
            column(StaffName; StaffName) { }
            column(NoOfTransaction; NoOfTransaction) { }
            column(NoOfCovers; NoOfCovers) { }
            column(Item_No_; "Item No.") { }
            column(ItemName; ItemName) { }
            column(Quantity; Quantity) { }
            column(AmountIncVAT; "Net Amount" + "VAT Amount") { }
            column(Discount_Amount; "Discount Amount") { }

            trigger OnAfterGetRecord()
            begin
                if Staff.Get("Created by Staff ID") then
                    StaffName := Staff."First Name" + ' ' + Staff."Last Name";
                if Item.Get("Item No.") then
                    ItemName := Item.Description;
                if PrevStaff <> "Created by Staff ID" then begin
                    NoOfTransaction := 0;
                    NoOfCovers := 0;
                end;
                if PrevRcptNo <> "Receipt No." then begin
                    NoOfTransaction += 1;
                    if TransHdr.Get("Store No.", "POS Terminal No.", "Transaction No.") then
                        NoOfCovers += TransHdr."No. of Covers";
                end;
                PrevStaff := "Created by Staff ID";
                PrevRcptNo := "Receipt No.";
            end;

            trigger OnPreDataItem()
            begin
                if GETFILTER(Date) = '' then
                    Error('Please provide Date Filter.');
                SetCurrentKey("Created by Staff ID", "Receipt No.", Date, "Item No.");
            end;
        }
    }

    trigger OnPreReport()
    begin
        CompInfo.Get();
        CompInfo.CalcFields(Picture);
    end;

    var
        CompInfo: Record "Company Information";
        Staff: Record "LSC Staff";
        StaffName: Text;
        Item: Record Item;
        ItemName: Text;
        NoOfTransaction: Integer;
        NoOfCovers: Integer;
        PrevStaff: Code[20];
        PrevRcptNo: Text[20];
        TransHdr: Record "LSC Transaction Header";
}