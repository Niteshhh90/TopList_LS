report 52000 "Toplist APH"
{
    DefaultLayout = RDLC;
    RDLCLayout = './R52000_ToplistAPH.rdl';

    Caption = 'Toplist APH';

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number);
            column(USERID; USERID)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(ListType; ListType)
            {
            }
            column(SortType; SortType)
            {
            }
            column("Order"; Order)
            {
            }
            column(TopListTmp__No__; TopListTmp."No.")
            {
            }
            column(TopListTmp_Description; TopListTmp.Description)
            {
            }
            column(TopListTmp__Qty__; TopListTmp."Qty.")
            {
            }
            column(TopListTmp_Amount; TopListTmp.Amount)
            {
            }
            column(TopListTmp_Profit; TopListTmp.Profit)
            {
            }
            column(TopListTmp__Discount_Amount_; TopListTmp."Discount Amount")
            {
            }
            column(TopListTmp__No_Of_Trans; TopListTmp."Line No. Of Transactions")
            {
            }
            column(TopListTmp__IPC; TopListTmp.IPC)
            {
            }
            column(TopListTmp__ATV; TopListTmp.ATV)
            {
            }
            column(Integer_Number; Number)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Top_Sales_ListCaption; Top_Sales_ListCaptionLbl)
            {
            }
            column(TypeCaption; TypeCaptionLbl)
            {
            }
            column(No_Caption; No_CaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(Qty_Caption; Qty_CaptionLbl)
            {
            }
            column(AmountCaption; AmountCaptionLbl)
            {
            }
            column(ProfitCaption; ProfitCaptionLbl)
            {
            }
            column(Discount_AmountCaption; Discount_AmountCaptionLbl)
            {
            }
            column(RankCaption; RankCaptionLbl)
            {
            }
            column(Sorted_ByCaption; Sorted_ByCaptionLbl)
            {
            }
            column(Ordered_ByCaption; Ordered_ByCaptionLbl)
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF Number = 1 THEN
                    TopListTmp.FIND('-')
                ELSE
                    IF TopListTmp.NEXT = 0 THEN
                        CurrReport.BREAK;
            end;

            trigger OnPreDataItem();
            begin
                //ADS
                //SETFILTER(Number,'>%1',0);
                SetRange(Number, 1, NumberOfLinesToPrint);
                //ADS
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(NumberOfLinesToPrint; NumberOfLinesToPrint)
                {
                    ApplicationArea = All;
                    Caption = 'Number of Lines to Print';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        NumberOfLinesToPrint := 100;
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TopListTmp: Record "LSC Toplist Work Table" temporary;
        ListType: Text[30];
        SortType: Text[250];
        "Order": Text[30];
        Asc: Label 'Ascending';
        Desc: Label 'Descending';
        NumberOfLinesToPrint: Integer;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Top_Sales_ListCaptionLbl: Label 'Top Sales List';
        TypeCaptionLbl: Label 'Type';
        No_CaptionLbl: Label 'No.';
        DescriptionCaptionLbl: Label 'Description';
        Qty_CaptionLbl: Label 'Qty.';
        AmountCaptionLbl: Label 'Amount';
        ProfitCaptionLbl: Label 'Profit';
        Discount_AmountCaptionLbl: Label 'Discount Amount';
        RankCaptionLbl: Label 'Rank';
        Sorted_ByCaptionLbl: Label 'Sorted By';
        Ordered_ByCaptionLbl: Label 'Ordered By';

    procedure SetData(var TopList: Record "LSC Toplist Work Table"; RecCurrentKey: Text[250]; SortOrder: Boolean);
    var
        Counter: Integer;
    begin
        IF TopList.FIND('-') THEN
            REPEAT
                Counter += 1;
                TopListTmp := TopList;
                TopListTmp."Sorting Key" := Counter;
                TopListTmp.INSERT;
            UNTIL TopList.NEXT = 0;

        CASE RecCurrentKey OF
            TopList.FIELDCAPTION("Qty."):
                TopListTmp.SETCURRENTKEY("Qty.");
            TopList.FIELDCAPTION(Amount):
                TopListTmp.SETCURRENTKEY(Amount);
            TopList.FIELDCAPTION("Discount Amount"):
                TopListTmp.SETCURRENTKEY("Discount Amount");
            TopList.FIELDCAPTION(Profit):
                TopListTmp.SETCURRENTKEY(Profit);
            TopList.FIELDCAPTION(Type) + ',' + TopList.FIELDCAPTION("No."):
                TopListTmp.SETCURRENTKEY(Type, "No.");
            '':
                RecCurrentKey := 'Type,No.';
        END;

        TopListTmp.ASCENDING(SortOrder);
        ListType := FORMAT(TopListTmp.Type);
        SortType := RecCurrentKey;
        IF SortOrder THEN
            Order := Asc
        ELSE
            Order := Desc;
    end;
}

