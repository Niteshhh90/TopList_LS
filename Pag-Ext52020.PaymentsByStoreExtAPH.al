page 52020 "LSC Payments by Store APH"
{
    ApplicationArea = All;
    Caption = 'Payments by Stores APH';
    DeleteAllowed = false;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "LSC Tender Type Setup";
    UsageCategory = ReportsAndAnalysis;

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(DateFilter; DateFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Date Filter';

                    trigger OnValidate()
                    begin
                        ApplicationManagement.MakeDateFilter(DateFilter);
                        SetFilter("Date Filter", DateFilter);
                        DateFilter := GetFilter("Date Filter");
                        DateFilterOnAfterValidate;
                    end;
                }
                field(RoundingFactor; RoundingFactor)
                {
                    ApplicationArea = All;
                    Caption = 'Rounding Factor';
                    OptionCaption = 'None,1,1000,1000000';

                    trigger OnValidate()
                    begin
                        RoundingFactorOnAfterValidate;
                    end;
                }
                field(DisplayOption; DisplayOption)
                {
                    ApplicationArea = All;
                    Caption = 'Analysis Option';
                    OptionCaption = 'Amount,No. of Payments,Average';

                    trigger OnValidate()
                    begin
                        DisplayOptionOnAfterValidate;
                    end;
                }
                field(PeriodType; PeriodType)
                {
                    ApplicationArea = All;
                    Caption = 'View by';
                    OptionCaption = 'Day,Week,Month,Quarter,Year,Accounting Period';
                    ToolTip = 'Day';

                    trigger OnValidate()
                    begin
                        if PeriodType = PeriodType::"Accounting Period" then
                            AccountingPerioPeriodTypeOnVal;
                        if PeriodType = PeriodType::Year then
                            YearPeriodTypeOnValidate;
                        if PeriodType = PeriodType::Quarter then
                            QuarterPeriodTypeOnValidate;
                        if PeriodType = PeriodType::Month then
                            MonthPeriodTypeOnValidate;
                        if PeriodType = PeriodType::Week then
                            WeekPeriodTypeOnValidate;
                        if PeriodType = PeriodType::Day then
                            DayPeriodTypeOnValidate;
                    end;
                }
                field(AmountType; AmountType)
                {
                    ApplicationArea = All;
                    Caption = 'View as';
                    OptionCaption = 'Net Change,Balance at Date';
                    ToolTip = 'Net Change';

                    trigger OnValidate()
                    begin
                        if AmountType = AmountType::"Balance at Date" then
                            BalanceatDateAmountTypeOnValid;
                        if AmountType = AmountType::"Net Change" then
                            NetChangeAmountTypeOnValidate;
                    end;
                }
            }
            repeater(Control1100409000)
            {
                Editable = false;
                ShowCaption = false;
                field("Code"; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Col1; CellValue[1])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = LoadCaption(1);
                    Editable = Col1Editable;

                    trigger OnDrillDown()
                    begin
                        DrillDownCell(1);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        SetCellSelection(1);
                    end;
                }
                field(Col2; CellValue[2])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = LoadCaption(2);
                    Editable = Col2Editable;

                    trigger OnDrillDown()
                    begin
                        DrillDownCell(2);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        SetCellSelection(2);
                    end;
                }
                field(Col3; CellValue[3])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = LoadCaption(3);
                    Editable = Col3Editable;

                    trigger OnDrillDown()
                    begin
                        DrillDownCell(3);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        SetCellSelection(3);
                    end;
                }
                field(Col4; CellValue[4])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = LoadCaption(4);
                    Editable = Col4Editable;

                    trigger OnDrillDown()
                    begin
                        DrillDownCell(4);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        SetCellSelection(4);
                    end;
                }
                field(Col5; CellValue[5])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = LoadCaption(5);
                    Editable = Col5Editable;

                    trigger OnDrillDown()
                    begin
                        DrillDownCell(5);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        SetCellSelection(5);
                    end;
                }
                field(Col6; CellValue[6])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = LoadCaption(6);
                    Editable = Col6Editable;

                    trigger OnDrillDown()
                    begin
                        DrillDownCell(6);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        SetCellSelection(6);
                    end;
                }
                field(Col7; CellValue[7])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = LoadCaption(7);
                    Editable = Col7Editable;

                    trigger OnDrillDown()
                    begin
                        DrillDownCell(7);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        SetCellSelection(7);
                    end;
                }
                field(Col8; CellValue[8])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = LoadCaption(8);
                    Editable = Col8Editable;

                    trigger OnDrillDown()
                    begin
                        DrillDownCell(8);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        SetCellSelection(8);
                    end;
                }
                field(Col9; CellValue[9])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = LoadCaption(9);
                    Editable = Col9Editable;

                    trigger OnDrillDown()
                    begin
                        DrillDownCell(9);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        SetCellSelection(9);
                    end;
                }
                field(Col10; CellValue[10])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = LoadCaption(10);
                    Editable = Col10Editable;

                    trigger OnDrillDown()
                    begin
                        DrillDownCell(10);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        SetCellSelection(10);
                    end;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Payments")
            {
                Caption = '&Payments';
                action("Tender Type Card")
                {
                    ApplicationArea = All;
                    Caption = 'Tender Type Card';
                    Image = CashFlowSetup;
                    RunObject = Page "LSC Tender Type List";
                    RunPageLink = Code = FIELD(Code),
                                  "Store No." = FIELD("Store Filter");
                    ShortCutKey = 'Shift+Ctrl+C';
                }
                action("Payment by Period")
                {
                    ApplicationArea = All;
                    Caption = 'Payment by Period';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        TenderType: Record "LSC Tender Type";
                        PaymentsByPeriod: Page "LSC Payments by Period";
                    begin
                        Clear(PaymentsByPeriod);
                        TenderType.Reset;
                        TenderType.SetRange("Store Filter", SelectedStoreNo);
                        PaymentsByPeriod.SetTableView(TenderType);
                        PaymentsByPeriod.Run;
                    end;
                }
            }
        }
        area(processing)
        {
            action("Previous Period")
            {
                ApplicationArea = All;
                Caption = 'Previous Period';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Previous Period';

                trigger OnAction()
                begin
                    FindPeriod('<=');
                end;
            }
            action("Next Period")
            {
                ApplicationArea = All;
                Caption = 'Next Period';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Next Period';

                trigger OnAction()
                begin
                    FindPeriod('>=');
                end;
            }
            action("Previous Set")
            {
                ApplicationArea = All;
                Caption = 'Previous Set';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Next Set';

                trigger OnAction()
                begin
                    if MatrixUtility.PrevCol(MaxMatrixBuffer, MatrixBufferCol) then begin
                        CurrPage.Update(false);
                    end;
                end;
            }
            action("Next Set")
            {
                ApplicationArea = All;
                Caption = 'Next Set';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Next Set';

                trigger OnAction()
                begin
                    if MatrixUtility.NextCol(MaxMatrixBuffer, MatrixBufferCol) then begin
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        LoadMatrix;
        CellValue1OnFormat(Format(CellValue[1]));
        CellValue2OnFormat(Format(CellValue[2]));
        CellValue3OnFormat(Format(CellValue[3]));
        CellValue4OnFormat(Format(CellValue[4]));
        CellValue5OnFormat(Format(CellValue[5]));
        CellValue6OnFormat(Format(CellValue[6]));
        CellValue7OnFormat(Format(CellValue[7]));
        CellValue8OnFormat(Format(CellValue[8]));
        CellValue9OnFormat(Format(CellValue[9]));
        CellValue10OnFormat(Format(CellValue[10]));
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        DateFilter := GetFilter("Date Filter");

        SkipLoad := true;
        LoadColVisible;
        SkipLoad := false;
        exit(Find(Which));
    end;

    trigger OnInit()
    begin
        Col10Editable := true;
        Col9Editable := true;
        Col8Editable := true;
        Col7Editable := true;
        Col6Editable := true;
        Col5Editable := true;
        Col4Editable := true;
        Col3Editable := true;
        Col2Editable := true;
        Col1Editable := true;
    end;

    trigger OnOpenPage()
    begin
        StoreType := 'All';
        PopulateMatrixBox;
    end;

    var
        RoundingFactor: Option "None","1","1000","1000000";
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        AmountType: Option "Net Change","Balance at Date";
        DisplayOption: Option Amount,"No. of Payments","Average";
        StoreType: Code[10];
        Calendar: Record Date;
        RecRef: RecordRef;
        MatrixBufferCol: Record "LSC Matrix Column Buffer" temporary;
        MatrixUtility: Codeunit "LSC Matrix Utility";
        MaxMatrixBuffer: Integer;
        CellValue: array[32] of Decimal;
        SkipLoad: Boolean;
        RecRefCol: RecordRef;
        FieldRefCol: FieldRef;
        Text020: Label 'Column %1 is out of range';
        ApplicationManagement: Codeunit "Filter Tokens";
        DateFilter: Text[30];
        SelectedStoreNo: Code[20];
        [InDataSet]
        Col1Editable: Boolean;
        [InDataSet]
        Col2Editable: Boolean;
        [InDataSet]
        Col3Editable: Boolean;
        [InDataSet]
        Col4Editable: Boolean;
        [InDataSet]
        Col5Editable: Boolean;
        [InDataSet]
        Col6Editable: Boolean;
        [InDataSet]
        Col7Editable: Boolean;
        [InDataSet]
        Col8Editable: Boolean;
        [InDataSet]
        Col9Editable: Boolean;
        [InDataSet]
        Col10Editable: Boolean;

    local procedure FormatAmount(var Text: Text[250]; var Amount: Decimal)
    begin
        if (Text = '') or (RoundingFactor = RoundingFactor::None) then
            exit;
        Evaluate(Amount, Text);
        case RoundingFactor of
            RoundingFactor::"1":
                Amount := Round(Amount, 1);
            RoundingFactor::"1000":
                Amount := Round(Amount / 1000, 0.1);
            RoundingFactor::"1000000":
                Amount := Round(Amount / 1000000, 0.1);
        end;
        if Amount = 0 then
            Text := ''
        else
            case RoundingFactor of
                RoundingFactor::"1":
                    Text := Format(Amount);
                RoundingFactor::"1000", RoundingFactor::"1000000":
                    Text := Format(Amount, 0, '<Sign><Integer Thousand><Decimals,2>');
            end;
    end;

    local procedure FindPeriod(SearchText: Code[10])
    var
        PeriodFormManagement: Codeunit PeriodFormManagement;
    begin
        if GetFilter("Date Filter") <> '' then begin
            Calendar.SetFilter("Period Start", GetFilter("Date Filter"));
            if not PeriodFormManagement.FindDate('+', Calendar, PeriodType) then
                PeriodFormManagement.FindDate('+', Calendar, PeriodType::Day);
            Calendar.SetRange("Period Start");
        end;
        PeriodFormManagement.FindDate(SearchText, Calendar, PeriodType);
        if AmountType = AmountType::"Net Change" then begin
            SetRange("Date Filter", Calendar."Period Start", Calendar."Period End");
            if GetRangeMin("Date Filter") = GetRangeMax("Date Filter") then
                SetRange("Date Filter", GetRangeMin("Date Filter"));
        end else
            SetRange("Date Filter", 0D, Calendar."Period End");
    end;

    [Scope('OnPrem')]
    procedure PopulateMatrixBox()
    var
        MatrixStore: Record "LSC Store";
    begin
        MaxMatrixBuffer := 10;
        MatrixStore.Reset;
        RecRef.GetTable(MatrixStore);
        MatrixUtility.InitCol(RecRef, MatrixStore.FieldNo("No."), MaxMatrixBuffer, MatrixBufferCol);
        Refresh;
    end;

    [Scope('OnPrem')]
    procedure Refresh()
    begin
        CurrPage.Update(false);
    end;

    [Scope('OnPrem')]
    procedure LoadCaption(pFieldNo: Integer): Text[80]
    begin
        if MatrixBufferCol.Get(pFieldNo) then
            exit('3,' + MatrixBufferCol."Column Caption")
        else
            exit('3, ');
    end;

    [Scope('OnPrem')]
    procedure LoadColVisible()
    begin
        Col1Editable := false;
        Col2Editable := false;
        Col3Editable := false;
        Col4Editable := false;
        Col5Editable := false;
        Col6Editable := false;
        Col7Editable := false;
        Col8Editable := false;
        Col9Editable := false;
        Col10Editable := false;
    end;

    [Scope('OnPrem')]
    procedure LoadMatrix()
    var
        CodeValue: Code[20];
    begin
        Clear(CellValue);

        if SkipLoad then
            exit;

        MatrixBufferCol.Reset;
        if MatrixBufferCol.FindSet then begin
            RecRefCol.Open(MatrixBufferCol."Column Table No.");
                                            repeat
                                                RecRefCol.SetPosition(MatrixBufferCol."Column RecordID");
                                                FieldRefCol := RecRefCol.Field(MatrixBufferCol."Column Field No.");
                                                CodeValue := FieldRefCol.Value;

                                                SetFilter("Store Filter", CodeValue);
                                                /* case DisplayOption of
                                                    DisplayOption::Amount:
                                                        CalcFields(Payments);
                                                    DisplayOption::"No. of Payments":
                                                        begin
                                                            CalcFields("No. of Payments");
                                                            Payments := "No. of Payments";
                                                        end;
                                                    DisplayOption::Average:
                                                        begin
                                                            CalcFields(Payments, "No. of Payments");
                                                            if "No. of Payments" = 0 then
                                                                Payments := 0
                                                            else
                                                                Payments := Payments / "No. of Payments";
                                                        end;
                                                end; */
                                                case DisplayOption of
                                                    DisplayOption::Amount:
                                                        CalcFields(PaymentsAPH);
                                                    DisplayOption::"No. of Payments":
                                                        begin
                                                            CalcFields("No. of Payments APH");
                                                            PaymentsAPH := "No. of Payments APH";
                                                        end;
                                                    DisplayOption::Average:
                                                        begin
                                                            CalcFields(PaymentsAPH, "No. of Payments APH");
                                                            if "No. of Payments APH" = 0 then
                                                                PaymentsAPH := 0
                                                            else
                                                                PaymentsAPH := PaymentsAPH / "No. of Payments APH";
                                                        end;
                                                end;
                                                CellValue[MatrixBufferCol."Column No."] := PaymentsAPH;

                                            until MatrixBufferCol.Next = 0;
            RecRefCol.Close;
        end;
    end;

    [Scope('OnPrem')]
    procedure ValidateCell(pColumnNo: Integer)
    var
        CodeValue: Code[20];
    begin
        if not MatrixBufferCol.Get(pColumnNo) then begin
            Error(Text020, pColumnNo);
        end else begin
            RecRefCol.Open(MatrixBufferCol."Column Table No.");
            RecRefCol.SetPosition(MatrixBufferCol."Column RecordID");
            FieldRefCol := RecRefCol.Field(MatrixBufferCol."Column Field No.");
            CodeValue := FieldRefCol.Value;
            RecRefCol.Close;

        end;
    end;

    [Scope('OnPrem')]
    procedure DrillDownCell(pColumnNo: Integer)
    var
        CodeValue: Code[20];
        TransPaymentEntry: Record "LSC Trans. Payment Entry";
    begin

        if MatrixBufferCol.Get(pColumnNo) then begin
            RecRefCol.Open(MatrixBufferCol."Column Table No.");
            RecRefCol.SetPosition(MatrixBufferCol."Column RecordID");
            FieldRefCol := RecRefCol.Field(MatrixBufferCol."Column Field No.");
            CodeValue := FieldRefCol.Value;
            RecRefCol.Close;

            TransPaymentEntry.Reset;
            TransPaymentEntry.SetCurrentKey(Date, "Tender Type");
            TransPaymentEntry.SetRange("Tender Type", Code);
            TransPaymentEntry.SetRange("Transaction Type APH", TransPaymentEntry."Transaction Type APH"::Sales);
            TransPaymentEntry.SetRange("Store No.", CodeValue);
            CopyFilter("Date Filter", TransPaymentEntry.Date);
            PAGE.RunModal(0, TransPaymentEntry, TransPaymentEntry."Amount Tendered");
        end;
    end;

    [Scope('OnPrem')]
    procedure SetCellSelection(pColumnNo: Integer)
    var
        CodeValue: Code[20];
    begin

        if MatrixBufferCol.Get(pColumnNo) then begin
            RecRefCol.Open(MatrixBufferCol."Column Table No.");
            RecRefCol.SetPosition(MatrixBufferCol."Column RecordID");
            FieldRefCol := RecRefCol.Field(MatrixBufferCol."Column Field No.");
            CodeValue := FieldRefCol.Value;
            RecRefCol.Close;

            SelectedStoreNo := CodeValue;
        end;
    end;

    local procedure RoundingFactorOnAfterValidate()
    begin
        Refresh;
    end;

    local procedure DateFilterOnAfterValidate()
    begin
        Refresh;
    end;

    local procedure DisplayOptionOnAfterValidate()
    begin
        Refresh;
    end;

    local procedure BalanceatDateAmountTypeOnAfter()
    begin
        Refresh;
    end;

    local procedure NetChangeAmountTypeOnAfterVali()
    begin
        Refresh;
    end;

    local procedure AccountingPerioPeriodTypeOnAft()
    begin
        Refresh;
    end;

    local procedure YearPeriodTypeOnAfterValidate()
    begin
        Refresh;
    end;

    local procedure QuarterPeriodTypeOnAfterValida()
    begin
        Refresh;
    end;

    local procedure MonthPeriodTypeOnAfterValidate()
    begin
        Refresh;
    end;

    local procedure WeekPeriodTypeOnAfterValidate()
    begin
        Refresh;
    end;

    local procedure DayPeriodTypeOnAfterValidate()
    begin
        Refresh;
    end;

    local procedure YearPeriodTypeOnPush()
    begin
        FindPeriod('>=');
    end;

    local procedure QuarterPeriodTypeOnPush()
    begin
        FindPeriod('>=');
    end;

    local procedure MonthPeriodTypeOnPush()
    begin
        FindPeriod('>=');
    end;

    local procedure WeekPeriodTypeOnPush()
    begin
        FindPeriod('>=');
    end;

    local procedure DayPeriodTypeOnPush()
    begin
        FindPeriod('>=');
    end;

    local procedure CellValue1OnFormat(Text: Text[1024])
    begin
        FormatAmount(Text, CellValue[1]);
    end;

    local procedure CellValue2OnFormat(Text: Text[1024])
    begin
        FormatAmount(Text, CellValue[2]);
    end;

    local procedure CellValue3OnFormat(Text: Text[1024])
    begin
        FormatAmount(Text, CellValue[3]);
    end;

    local procedure CellValue4OnFormat(Text: Text[1024])
    begin
        FormatAmount(Text, CellValue[4]);
    end;

    local procedure CellValue5OnFormat(Text: Text[1024])
    begin
        FormatAmount(Text, CellValue[5]);
    end;

    local procedure CellValue6OnFormat(Text: Text[1024])
    begin
        FormatAmount(Text, CellValue[6]);
    end;

    local procedure CellValue7OnFormat(Text: Text[1024])
    begin
        FormatAmount(Text, CellValue[7]);
    end;

    local procedure CellValue8OnFormat(Text: Text[1024])
    begin
        FormatAmount(Text, CellValue[8]);
    end;

    local procedure CellValue9OnFormat(Text: Text[1024])
    begin
        FormatAmount(Text, CellValue[9]);
    end;

    local procedure CellValue10OnFormat(Text: Text[1024])
    begin
        FormatAmount(Text, CellValue[10]);
    end;

    local procedure DayPeriodTypeOnValidate()
    begin
        DayPeriodTypeOnPush;
        DayPeriodTypeOnAfterValidate;
    end;

    local procedure WeekPeriodTypeOnValidate()
    begin
        WeekPeriodTypeOnPush;
        WeekPeriodTypeOnAfterValidate;
    end;

    local procedure MonthPeriodTypeOnValidate()
    begin
        MonthPeriodTypeOnPush;
        MonthPeriodTypeOnAfterValidate;
    end;

    local procedure QuarterPeriodTypeOnValidate()
    begin
        QuarterPeriodTypeOnPush;
        QuarterPeriodTypeOnAfterValida;
    end;

    local procedure YearPeriodTypeOnValidate()
    begin
        YearPeriodTypeOnPush;
        YearPeriodTypeOnAfterValidate;
    end;

    local procedure AccountingPerioPeriodTypeOnVal()
    begin
        AccountingPerioPeriodTypeOnAft;
    end;

    local procedure NetChangeAmountTypeOnValidate()
    begin
        NetChangeAmountTypeOnAfterVali;
    end;

    local procedure BalanceatDateAmountTypeOnValid()
    begin
        BalanceatDateAmountTypeOnAfter;
    end;
}

