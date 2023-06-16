page 52000 "Toplist Card APH"
{
    ApplicationArea = All;
    Caption = 'Toplist APH';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "LSC Toplist Work Table";
    UsageCategory = ReportsAndAnalysis;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(StoreFilter; StoreFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Store Filter';
                    TableRelation = "LSC Store";

                    trigger OnValidate()
                    begin
                        Rec.SetFilter("Store Filter", StoreFilter);
                        StoreFilterOnAfterValidate;
                    end;
                }
                field(DateFilter; DateFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Date Filter';

                    trigger OnValidate()
                    var
                        ApplicationManagement: Codeunit "Filter Tokens";
                    begin
                        ApplicationManagement.MakeDateFilter(DateFilter);
                        Rec.SetFilter("Date Filter", DateFilter);
                        DateFilter := Rec.GetFilter("Date Filter");
                        DateFilterOnAfterValidate;
                    end;
                }
                field(TimeFilter; TimeFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Time Filter';

                    trigger OnValidate()
                    var
                        ApplicationManagement: Codeunit "Filter Tokens";
                    begin
                        ApplicationManagement.MakeTimeFilter(TimeFilter);
                        Rec.SetFilter("Time Filter", TimeFilter);
                        TimeFilter := Rec.GetFilter("Time Filter");
                        TimeFilterOnAfterValidate;
                    end;
                }
                //TTT <<
                field(SalesTypeFilter; SalesTypeFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Type Filter';
                    TableRelation = "LSC Sales Type";
                    trigger OnValidate()
                    begin
                        Rec.SetFilter("Sales Type Filter", SalesTypeFilter);
                        StoreFilterOnAfterValidate;
                    end;
                }
                //TTT >>
                field(Refreshbox; RefreshText)
                {
                    ApplicationArea = All;
                    Caption = 'Refresh Status';
                    Editable = false;
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field("No. of Transactions"; Rec."No. of Transactions")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total Sales"; Rec."Total Sales")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            repeater(Control1200070000)
            {
                Editable = false;
                ShowCaption = false;
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Qty."; Rec."Qty.")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;

                    trigger OnDrillDown()
                    begin
                        DoDrillDown;
                    end;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        DoDrillDown;
                    end;
                }
                field(Profit; Rec.Profit)
                {
                    ApplicationArea = All;
                    Visible = false;
                    trigger OnDrillDown()
                    begin
                        DoDrillDown;
                    end;
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    ApplicationArea = All;
                }
                field("Line No. Of Transactions"; Rec."Line No. Of Transactions")
                {
                    ApplicationArea = All;
                    Visible = LineTransVisible;
                }
                field(IPC; Rec.IPC)
                {
                    ApplicationArea = All;
                    Visible = IPCVisible;
                }
                field(ATV; Rec.ATV)
                {
                    ApplicationArea = All;
                    Visible = ATVVisible;
                }
                field("Guest Count"; Rec."Guest Count")
                {
                    ApplicationArea = All;
                    Visible = GuestVisible;
                }
            }
            field(PeriodType; PeriodType)
            {
                ApplicationArea = All;
                OptionCaption = 'Day,Week,Month,Quarter,Year';
                ShowCaption = false;
                ToolTip = 'Day';

                trigger OnValidate()
                begin
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
            group(Control1902923501)
            {
                ShowCaption = false;
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
        }
    }

    actions
    {
        area(processing)
        {
            action(SortCode)
            {
                ApplicationArea = All;
                Caption = 'Sort by No.';
                Image = CreateInteraction;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    TopList.SetCurrentKey(Type, "No.");
                    Sort;
                end;
            }
            action(SortQty)
            {
                ApplicationArea = All;
                Caption = 'Sort by Qty.';
                Image = CreateInteraction;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    TopList.SetCurrentKey("Qty.");
                    Sort;
                end;
            }
            action(SortAmount)
            {
                ApplicationArea = All;
                Caption = 'Sort by Amount';
                Image = CreateInteraction;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    TopList.SetCurrentKey(Amount);
                    Sort;
                end;
            }
            action(SortProfit)
            {
                ApplicationArea = All;
                Caption = 'Sort by Profit';
                Image = CreateInteraction;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    TopList.SetCurrentKey(Profit);
                    Sort;
                end;
            }
            action(SortDiscount)
            {
                ApplicationArea = All;
                Caption = 'Sort by Disc. Amount';
                Image = CreateInteraction;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    TopList.SetCurrentKey("Discount Amount");
                    Sort;
                end;
            }
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
            action("Trans.")
            {
                ApplicationArea = All;
                Caption = 'Trans.';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CalcTransOrCust(ViewType::Trans);
                end;
            }
            action(Customer)
            {
                ApplicationArea = All;
                Caption = 'Customer';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CalcTransOrCust(ViewType::Cust);
                end;
            }
            action(Item)
            {
                ApplicationArea = All;
                Caption = 'Item';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CalcItem;
                end;
            }
            action(Division)
            {
                ApplicationArea = All;
                Caption = 'Division';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CalcDiv;
                end;
            }
            action(Cat)
            {
                ApplicationArea = All;
                Caption = 'Category';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CalcCat;
                end;
            }
            action(Prod)
            {
                ApplicationArea = All;
                Caption = 'ProdGrp';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    calcProd;
                end;
            }
            action(Staff)
            {
                ApplicationArea = All;
                Caption = 'Staff';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CalcStaff();
                end;
            }
            //TTT <<
            action("Sales Type")
            {
                ApplicationArea = All;
                Caption = 'Sales Type';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CalcSalesType();
                end;
            }
            //TTT >>

            action(VoidedTrans)
            {
                ApplicationArea = All;
                Caption = 'Voided Transactions';
                Image = VoidAllChecks;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    CalcVoidedTrans();
                end;
            }
            action(VoidedLines)
            {
                ApplicationArea = All;
                Caption = 'Voided Lines';
                Image = VoidCheck;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Line voided after sending to kitchen';
                trigger OnAction()
                begin
                    CalcVoidedLines();
                end;
            }
            action(CancelledLines)
            {
                ApplicationArea = All;
                Caption = 'Cancelled Lines';
                Image = CancelAllLines;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Line voided before sending to kitchen';
                trigger OnAction()
                begin
                    CalcCancelledLines();
                end;
            }
            action(DiscCode)
            {
                ApplicationArea = All;
                Caption = 'Disc. Code';
                Image = Discount;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CalcDiscCode();
                end;
            }
            action(PushPrint)
            {
                ApplicationArea = All;
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    //TopListReport: Report "LSC Toplist";
                    TopListReport: Report "Toplist APH";    //TTT
                begin
                    Clear(TopListReport);
                    TopListReport.SetData(TopList, TopListCurrentKey, SortOrder);
                    TopListReport.Run;
                end;
            }
            action(Chart)
            {
                ApplicationArea = All;
                Caption = 'Chart';
                Image = BarChart;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    TopListChart: Page "LSC Toplist Pie Chart";
                begin
                    Clear(TopListChart);
                    TopListChart.LoadData(TopList, DateFilter, TimeFilter);
                    TopListChart.RunModal;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("No. of Transactions", "Total Sales");
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        DateFilter := Rec.GetFilter("Date Filter");
        TimeFilter := Rec.GetFilter("Time Filter");
        StoreFilter := Rec.GetFilter("Store Filter");
        SalesTypeFilter := GETFILTER("Sales Type Filter");      //TTT
        TopList := Rec;
        if not TopList.Find(Which) then
            exit(false);
        Rec := TopList;
        exit(true);
    end;

    trigger OnInit()
    begin
        TopList.Type := TopList.Type::Transaction;
        TopList.Insert;
        SortOrder := true;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    var
        CurrentSteps: Integer;
    begin
        TopList := Rec;
        CurrentSteps := TopList.Next(Steps);
        if CurrentSteps <> 0 then
            Rec := TopList;
        exit(CurrentSteps);
    end;

    trigger OnOpenPage()
    begin
        Rec.CalcFields("No. of Transactions", "Total Sales");
        FilterChange := true;
        RefreshText := Refresh;
    end;

    var
        TopList: Record "LSC Toplist Work Table" temporary;
        Transaction: Record "LSC Transaction Header";
        SalesEntry: Record "LSC Trans. Sales Entry";
        DiscEntry: Record "LSC Trans. Discount Entry";
        Calendar: Record Date;
        Window: Dialog;
        TopListCurrentKey: Text[205];
        DateFilter: Text[30];
        TimeFilter: Text[30];
        StoreFilter: Text[30];
        SalesTypeFilter: Text[30];     //TTT
        RefreshText: Text[30];
        TransCounter: Integer;
        CustCounter: Integer;
        ItemCounter: Integer;
        DivCounter: Integer;
        CatCounter: Integer;
        ProdCounter: Integer;
        StaffCounter: Integer;
        SalesTypeCounter: Integer;    //TTT
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        AmountType: Option "Net Change","Balance at Date";
        ViewType: Option Trans,Cust;
        SortOrder: Boolean;
        FilterChange: Boolean;
        Refresh: Label 'Refresh Needed';
        NoData: Label 'There is no data within the selected period';
        TotalRecTxt: Label 'Number of Records';
        CounterTxt: Label 'Counter';
        IPCVisible: Boolean;
        ATVVisible: Boolean;
        GuestVisible: Boolean;
        LineTransVisible: Boolean;
        VoidLineCounter: Integer;
        VoidTransCounter: Integer;
        VoidedTrans: Record "LSC POS Voided Transaction";
        Text001: Label 'Receipt';
        VoidedLines: Record "LSC POS Voided Trans. Line";
        CanLineCounter: Integer;
        DiscCodeCounter: Integer;

    [Scope('OnPrem')]
    procedure CalcTransOrCust(Type: Option Trans,Cust)
    var
        Customer: Record Customer;
        Counter: Integer;
        Text001: Label 'Receipt ';
        TransSalesEntry: Record "LSC Trans. Sales Entry";
    begin
        IPCVisible := FALSE;
        ATVVisible := FALSE;
        GuestVisible := true;
        LineTransVisible := false;
        if FilterChange then begin
            TopList.Reset;
            TopList.DeleteAll;
            TransCounter := 0;
            CustCounter := 0;
            ItemCounter := 0;
            DivCounter := 0;
            CatCounter := 0;
            ProdCounter := 0;
            StaffCounter := 0;
        end else begin
            if Type = Type::Trans then begin
                if TransCounter <> 0 then begin
                    TopList.SetRange(Type, TopList.Type::Transaction);
                    TopList.FindSet();
                    Rec := TopList;
                    exit;
                end;
            end;
            if Type = Type::Cust then begin
                if CustCounter <> 0 then begin
                    TopList.SetRange(Type, TopList.Type::Customer);
                    TopList.Findset();
                    Rec := TopList;
                    exit;
                end
            end;
        end;

        Window.Open(CounterTxt + '          ' + ' #1########\' + TotalRecTxt + ' #2########');
        Window.Update(2, Rec."No. of Transactions");

        Transaction.SetCurrentKey("Entry Status", Date);
        Transaction.SetFilter("Entry Status", '%1|%2', Transaction."Entry Status"::" ", Transaction."Entry Status"::Posted);
        Transaction.SetFilter(Date, Rec.GetFilter("Date Filter"));
        Transaction.SetFilter(Time, Rec.GetFilter("Time Filter"));
        Transaction.SetFilter("Store No.", Rec.GetFilter("Store Filter"));
        Transaction.SETFILTER("Sales Type", Rec.GETFILTER("Sales Type Filter"));      //TTT
        OnAfterFilterTransaction(Rec, Transaction);

        if Transaction.FindSet() then
                repeat
                    if Transaction."Transaction Type" = Transaction."Transaction Type"::Sales then begin
                        Counter += 1;
                        if (Counter mod 100) = 0 then
                            Window.Update(1, Counter);
                        if Type = Type::Trans then begin
                            if not TopList.Get(TopList.Type::Transaction, Format(Transaction."Transaction No.")) then begin
                                TopList.Init;
                                TopList.Type := TopList.Type::Transaction;
                                TopList."Store No." := Transaction."Store No.";
                                TopList."POS Terminal No." := Transaction."POS Terminal No.";
                                TopList."No." := Format(Transaction."Transaction No.");
                                TopList.Insert;
                            end;
                        end;
                        if Type = Type::Cust then begin
                            if not TopList.Get(
                              TopList.Type::Customer, '', '', Format(Transaction."Customer No."))
                            then begin
                                TopList.Init;
                                TopList.Type := TopList.Type::Customer;
                                TopList."Store No." := '';
                                TopList."POS Terminal No." := '';
                                TopList."No." := Transaction."Customer No.";
                                TopList.Insert;
                            end;
                        end;

                        if Type = Type::Trans then
                            TopList.Description := Text001 + Format(Transaction."Receipt No.");
                        if Type = Type::Cust then begin
                            if Customer.Get(TopList."No.") then
                                TopList.Description := Customer.Name
                            else
                                Clear(TopList.Description);
                        end;
                        //TTT-VS    14Mar2022   -->>
                        TransSalesEntry.Reset();
                        TransSalesEntry.SetRange("Store No.", Transaction."Store No.");
                        TransSalesEntry.SetRange("POS Terminal No.", Transaction."POS Terminal No.");
                        TransSalesEntry.SetRange("Transaction No.", Transaction."Transaction No.");
                        TransSalesEntry.SetRange("Parent Line No.", 0);
                        TransSalesEntry.CalcSums(Quantity);
                        TopList."Qty." := TopList."Qty." + ABS(TransSalesEntry.Quantity);
                        //TopList."Qty." := TopList."Qty." + Transaction."No. of Items";
                        TopList."Guest Count" += Transaction."No. of Covers";
                        //TTT-VS    14Mar2022   <<--
                        TopList.Amount := TopList.Amount - Transaction."Net Amount";
                        TopList."Discount Amount" := TopList."Discount Amount" + Transaction."Discount Amount";
                        TopList."Cost Amount" := TopList."Cost Amount" + Transaction."Cost Amount";
                        TopList.Profit := TopList.Amount + TopList."Cost Amount";
                        OnBeforeTopListModifyInTransaction(TopList, Transaction);
                        TopList.Modify;
                    end;
                until Transaction.Next = 0;

        Window.Close;
        FilterChange := false;
        RefreshText := '';

        if TopList.Type = TopList.Type::Transaction then begin
            TransCounter := Counter;
            TopList.SetRange(Type, TopList.Type::Transaction);
        end else begin
            CustCounter := Counter;
            TopList.SetRange(Type, TopList.Type::Customer);
        end;

        if not TopList.FindSet() then
            Error(NoData)
        else
            Rec := TopList;
    end;

    [Scope('OnPrem')]
    procedure CalcItem()
    var
        Counter: Integer;
        Item: Record Item;
    begin
        if FilterChange then begin
            TopList.Reset;
            TopList.DeleteAll;
            TransCounter := 0;
            CustCounter := 0;
            ItemCounter := 0;
            DivCounter := 0;
            CatCounter := 0;
            ProdCounter := 0;
            StaffCounter := 0;
            VoidLineCounter := 0;
            VoidTransCounter := 0;
            CanLineCounter := 0;
        end else begin
            if ItemCounter <> 0 then begin
                TopList.SetRange(Type, TopList.Type::Items);
                TopList.FindSet();
                Rec := TopList;
                exit;
            end;
        end;

        Window.Open(CounterTxt + '          ' + ' #1########\' + TotalRecTxt + ' #2########');

        SalesEntry.SetCurrentKey(Date);
        SalesEntry.SetFilter(Date, Rec.GetFilter("Date Filter"));
        SalesEntry.SetFilter(Time, Rec.GetFilter("Time Filter"));
        SalesEntry.SetFilter("Store No.", Rec.GetFilter("Store Filter"));
        SalesEntry.SETFILTER("Sales Type", GETFILTER("Sales Type Filter"));      //TTT
        OnAfterFilterSalesEntry(Rec, SalesEntry);
        Window.Update(2, SalesEntry.Count);

        if SalesEntry.FindSet() then
                repeat
                    Counter += 1;
                    if (Counter mod 100) = 0 then
                        Window.Update(1, Counter);

                    if not TopList.Get(TopList.Type::Items, '', '', Format(SalesEntry."Item No.")) then begin
                        TopList.Init;
                        TopList."Store No." := '';
                        TopList."POS Terminal No." := '';
                        TopList.Type := TopList.Type::Items;
                        TopList."No." := SalesEntry."Item No.";
                        TopList.Insert;
                    end;
                    if Item.Get(SalesEntry."Item No.") then
                        TopList.Description := Item.Description;
                    //TTT-VS    14Mar2022   -->>    
                    IF (SalesEntry."Parent Line No." <> 0) THEN
                        TopList."Qty." := TopList."Qty." + SalesEntry."Infocode Selected Qty."
                    ELSE
                        //TTT-VS    14Mar2022   <<--
                        TopList."Qty." := TopList."Qty." - SalesEntry.Quantity;
                    TopList.Amount := TopList.Amount - SalesEntry."Net Amount";
                    TopList."Discount Amount" := TopList."Discount Amount" + SalesEntry."Discount Amount";
                    TopList."Cost Amount" := TopList."Cost Amount" + SalesEntry."Cost Amount";
                    TopList.Profit := TopList.Amount + TopList."Cost Amount";
                    OnBeforeTopListModifyInSalesEntry(TopList, SalesEntry);
                    TopList.Modify;
                until SalesEntry.Next = 0;


        Window.Close;
        FilterChange := false;
        RefreshText := '';

        ItemCounter := Counter;
        TopList.SetRange(Type, TopList.Type::Items);

        if not TopList.FindSet() then
            Error(NoData)
        else
            Rec := TopList;
    end;

    local procedure FindPeriod(SearchText: Code[10])
    var
        PeriodFormManagement: Codeunit PeriodFormManagement;
    begin
        FilterChange := true;
        if Rec.GetFilter("Date Filter") <> '' then begin
            Calendar.SetFilter("Period Start", Rec.GetFilter("Date Filter"));
            if not PeriodFormManagement.FindDate('+', Calendar, PeriodType) then
                PeriodFormManagement.FindDate('+', Calendar, PeriodType::Day);
            Calendar.SetRange("Period Start");
        end;
        PeriodFormManagement.FindDate(SearchText, Calendar, PeriodType);
        if AmountType = AmountType::"Net Change" then begin
            Rec.SetRange("Date Filter", Calendar."Period Start", Calendar."Period End");
            if Rec.GetRangeMin("Date Filter") = Rec.GetRangeMax("Date Filter") then
                Rec.SetRange("Date Filter", Rec.GetRangeMin("Date Filter"));
        end else
            Rec.SetRange("Date Filter", 0D, Calendar."Period End");
        RefreshText := Refresh;
    end;

    [Scope('OnPrem')]
    procedure Sort()
    begin
        SortOrder := not TopList.Ascending;
        TopListCurrentKey := TopList.CurrentKey;
        TopList.Ascending(SortOrder);
        TopList.FindSet();
        Rec := TopList;
        CurrPage.Update(false);
    end;

    [Scope('OnPrem')]
    procedure DoDrillDown()
    var
        ProductGroup: Record "LSC Retail Product Group";
        Staff: Record "LSC Staff";
        TransNo: Integer;
        IsHandled: Boolean;
    begin
        case Rec.Type of
            Rec.Type::Transaction:
                begin
                    Transaction.Reset;
                    Evaluate(TransNo, Rec."No.");
                    Transaction.SetRange("Store No.", Rec."Store No.");
                    Transaction.SetRange("POS Terminal No.", Rec."POS Terminal No.");
                    Transaction.SetRange("Transaction No.", TransNo);
                    OnAfterFilterTransaction(Rec, Transaction);
                    PAGE.Run(0, Transaction);
                    Transaction.Reset;
                end;
            Rec.Type::Customer:
                begin
                    Transaction.Reset;
                    Transaction.SetCurrentKey("Customer No.", Date);
                    Transaction.SetFilter("Entry Status", '%1|%2', Transaction."Entry Status"::Posted, Transaction."Entry Status"::" ");
                    Transaction.SetFilter(Date, Rec.GetFilter("Date Filter"));
                    Transaction.SetFilter(Time, Rec.GetFilter("Time Filter"));
                    Transaction.SetRange("Customer No.", Rec."No.");
                    Transaction.SetFilter("Store No.", Rec.GetFilter("Store Filter"));
                    Transaction.SETFILTER("Sales Type", Rec.GETFILTER("Sales Type Filter"));
                    OnAfterFilterTransaction(Rec, Transaction);
                    PAGE.Run(0, Transaction);
                    Transaction.Reset;
                end;
            Rec.Type::Items:
                begin
                    SalesEntry.Reset;
                    SalesEntry.SetCurrentKey("Item No.", "Variant Code", Date);
                    SalesEntry.SetRange("Item No.", Rec."No.");
                    SalesEntry.SetFilter(Date, Rec.GetFilter("Date Filter"));
                    SalesEntry.SetFilter(Time, Rec.GetFilter("Time Filter"));
                    SalesEntry.SetFilter("Store No.", Rec.GetFilter("Store Filter"));
                    SalesEntry.SETFILTER("Sales Type", Rec.GETFILTER("Sales Type Filter"));
                    OnAfterFilterSalesEntry(Rec, SalesEntry);
                    PAGE.Run(0, SalesEntry);
                    SalesEntry.Reset;
                end;
            Rec.Type::Category:
                begin
                    SalesEntry.Reset;
                    SalesEntry.SetCurrentKey("Item Category Code", "Retail Product Code", Date);
                    SalesEntry.SetRange("Item Category Code", Rec."No.");
                    SalesEntry.SetFilter(Date, Rec.GetFilter("Date Filter"));
                    SalesEntry.SetFilter(Time, Rec.GetFilter("Time Filter"));
                    SalesEntry.SETFILTER("Sales Type", Rec.GETFILTER("Sales Type Filter"));
                    SalesEntry.SetFilter("Store No.", Rec.GetFilter("Store Filter"));
                    OnAfterFilterSalesEntry(Rec, SalesEntry);
                    PAGE.Run(0, SalesEntry);
                    SalesEntry.Reset;
                end;
            Rec.Type::"Product Group":
                begin
                    SalesEntry.Reset;
                    SalesEntry.SetCurrentKey("Item Category Code", "Retail Product Code", Date);
                    ProductGroup.SetRange(Code, "No.");
                    if ProductGroup.FindFirst then
                        SalesEntry.SetRange("Item Category Code", ProductGroup."Item Category Code");
                    SalesEntry.SetRange("Retail Product Code", Rec."No.");
                    SalesEntry.SetFilter("Store No.", Rec.GetFilter("Store Filter"));
                    SalesEntry.SetFilter(Date, Rec.GetFilter("Date Filter"));
                    SalesEntry.SetFilter(Time, Rec.GetFilter("Time Filter"));
                    SalesEntry.SETFILTER("Sales Type", Rec.GETFILTER("Sales Type Filter"));
                    OnAfterFilterSalesEntry(Rec, SalesEntry);
                    PAGE.Run(0, SalesEntry);
                    SalesEntry.Reset;
                end;
            Rec.Type::Staff:
                begin
                    OnBeforeFilterTransaction(SalesEntry, Rec, Transaction, IsHandled);
                    if IsHandled then
                        exit;
                    Transaction.Reset;
                    Transaction.SetCurrentKey("Store No.", "Staff ID", "Transaction Type", Date, "Entry Status");
                    if Staff.Get(Rec."No.") then
                        Transaction.SetRange("Store No.", Staff."Store No.");
                    Transaction.SetRange("Staff ID", Rec."No.");
                    Transaction.SetFilter(Date, Rec.GetFilter("Date Filter"));
                    Transaction.SetFilter(Time, Rec.GetFilter("Time Filter"));
                    Transaction.SetFilter("Entry Status", '%1|%2', Transaction."Entry Status"::Posted, Transaction."Entry Status"::" ");
                    Transaction.SETFILTER("Sales Type", Rec.GETFILTER("Sales Type Filter"));
                    OnAfterFilterTransaction(Rec, Transaction);
                    PAGE.Run(0, Transaction);
                    Transaction.Reset;
                end;
            Rec.Type::Division:
                begin
                    SalesEntry.Reset;
                    SalesEntry.SetRange("Division Code", Rec."No.");
                    SalesEntry.SetFilter("Store No.", Rec.GetFilter("Store Filter"));
                    SalesEntry.SetFilter(Date, Rec.GetFilter("Date Filter"));
                    SalesEntry.SetFilter(Time, Rec.GetFilter("Time Filter"));
                    SalesEntry.SETFILTER("Sales Type", Rec.GETFILTER("Sales Type Filter"));
                    OnAfterFilterSalesEntry(Rec, SalesEntry);
                    PAGE.Run(0, SalesEntry);
                    SalesEntry.Reset;
                end;
            //TTT-VS    14Mar2022   -->>
            Rec.Type::"Cancelled Lines":
                begin
                    VoidedLines.Reset();
                    VoidedLines.SetRange("Receipt No.", Rec."No.");
                    VoidedLines.SetRange("Sent To Kitchen", false);
                    Page.Run(99008991, VoidedLines);
                    VoidedLines.Reset();
                end;
            Rec.Type::"Voided Lines":
                begin
                    VoidedLines.Reset();
                    VoidedLines.SetRange("Receipt No.", Rec."No.");
                    VoidedLines.SetRange("Sent To Kitchen", true);
                    Page.Run(99008991, VoidedLines);
                    VoidedLines.Reset();
                end;
            Rec.Type::"Sales Type":
                begin
                    Transaction.Reset;
                    Transaction.SetCurrentKey("Sales Type");
                    Transaction.SetRange("Sales Type", Rec."No.");
                    Transaction.SetFilter("Entry Status", '%1|%2', Transaction."Entry Status"::Posted, Transaction."Entry Status"::" ");
                    Transaction.SetFilter(Date, Rec.GetFilter("Date Filter"));
                    Transaction.SetFilter(Time, Rec.GetFilter("Time Filter"));
                    Transaction.SetFilter("Store No.", Rec.GetFilter("Store Filter"));
                    OnAfterFilterTransaction(Rec, Transaction);
                    PAGE.Run(0, Transaction);
                    Transaction.Reset;
                end;
            Rec.Type::"Disc. Code":
                begin

                end;
            //TTT-VS    14Mar2022   <<--
            else begin

            end;
        end;
    end;

    [Scope('OnPrem')]
    procedure CalcDiv()
    var
        Division: Record "LSC Division";
        Counter: Integer;
    begin
        if FilterChange then begin
            TopList.Reset;
            TopList.DeleteAll;
            TransCounter := 0;
            CustCounter := 0;
            ItemCounter := 0;
            DivCounter := 0;
            CatCounter := 0;
            ProdCounter := 0;
            StaffCounter := 0;
            VoidLineCounter := 0;
            VoidTransCounter := 0;
            CanLineCounter := 0;
        end else begin
            if DivCounter <> 0 then begin
                TopList.SetRange(Type, TopList.Type::Division);
                TopList.FindSet();
                Rec := TopList;
                exit;
            end;
        end;

        Window.Open(CounterTxt + '          ' + ' #1########\' + TotalRecTxt + ' #2########');

        SalesEntry.SetCurrentKey(Date);
        SalesEntry.SetFilter(Date, Rec.GetFilter("Date Filter"));
        SalesEntry.SetFilter(Time, Rec.GetFilter("Time Filter"));
        SalesEntry.SetFilter("Store No.", Rec.GetFilter("Store Filter"));
        SalesEntry.SETFILTER("Sales Type", Rec.GETFILTER("Sales Type Filter"));     //TTT
        OnAfterFilterSalesEntry(Rec, SalesEntry);
        Window.Update(2, SalesEntry.Count);

        if SalesEntry.FindSet() then
            repeat
                    Counter += 1;
                if (Counter mod 100) = 0 then
                    Window.Update(1, Counter);

                if not TopList.Get(TopList.Type::Division, '', '', Format(SalesEntry."Division Code")) then begin
                    TopList.Init;
                    TopList."Store No." := '';
                    TopList."POS Terminal No." := '';
                    TopList.Type := TopList.Type::Division;
                    TopList."No." := SalesEntry."Division Code";
                    TopList.Insert;
                end;
                if Division.Get(SalesEntry."Division Code") then
                    TopList.Description := Division.Description;
                //TTT-VS    14Mar2022   -->>    
                IF (SalesEntry."Parent Line No." <> 0) THEN
                    TopList."Qty." := TopList."Qty." + SalesEntry."Infocode Selected Qty."
                ELSE
                    //TTT-VS    14Mar2022   <<--
                TopList."Qty." := TopList."Qty." - SalesEntry.Quantity;
                TopList.Amount := TopList.Amount - SalesEntry."Net Amount";
                TopList."Discount Amount" := TopList."Discount Amount" + SalesEntry."Discount Amount";
                TopList."Cost Amount" := TopList."Cost Amount" + SalesEntry."Cost Amount";
                TopList.Profit := TopList.Amount + TopList."Cost Amount";
                OnBeforeTopListModifyInSalesEntry(TopList, SalesEntry);
                TopList.Modify;
            until SalesEntry.Next = 0;

        Window.Close;
        FilterChange := false;
        RefreshText := '';

        DivCounter := Counter;
        TopList.SetRange(Type, TopList.Type::Division);

        if not TopList.FindSet() then
            Error(NoData)
        else
            Rec := TopList;
    end;

    [Scope('OnPrem')]
    procedure CalcCat()
    var
        Cat: Record "Item Category";
        Counter: Integer;
    begin
        if FilterChange then begin
            TopList.Reset;
            TopList.DeleteAll;
            TransCounter := 0;
            CustCounter := 0;
            ItemCounter := 0;
            DivCounter := 0;
            CatCounter := 0;
            ProdCounter := 0;
            StaffCounter := 0;
            VoidLineCounter := 0;
            VoidTransCounter := 0;
            CanLineCounter := 0;
        end else begin
            if CatCounter <> 0 then begin
                TopList.SetRange(Type, TopList.Type::Category);
                TopList.FindSet();
                Rec := TopList;
                exit;
            end;
        end;

        Window.Open(CounterTxt + '          ' + ' #1########\' + TotalRecTxt + ' #2########');

        SalesEntry.SetCurrentKey(Date);
        SalesEntry.SetFilter(Date, Rec.GetFilter("Date Filter"));
        SalesEntry.SetFilter(Time, Rec.GetFilter("Time Filter"));
        SalesEntry.SetFilter("Store No.", Rec.GetFilter("Store Filter"));
        SalesEntry.SETFILTER("Sales Type", Rec.GETFILTER("Sales Type Filter"));     //TTT
        OnAfterFilterSalesEntry(Rec, SalesEntry);
        Window.Update(2, SalesEntry.Count);

        if SalesEntry.FindSet() then
                repeat
                    Counter += 1;
                    if (Counter mod 100) = 0 then
                        Window.Update(1, Counter);

                    if not TopList.Get(TopList.Type::Category, '', '', Format(SalesEntry."Item Category Code")) then begin
                        TopList.Init;
                        TopList."Store No." := '';
                        TopList."POS Terminal No." := '';
                        TopList.Type := TopList.Type::Category;
                        TopList."No." := SalesEntry."Item Category Code";
                        TopList.Insert;
                    end;
                    if Cat.Get(SalesEntry."Item Category Code") then
                        TopList.Description := Cat.Description;
                    //TTT-VS    14Mar2022   -->>    
                    IF (SalesEntry."Parent Line No." <> 0) THEN
                        TopList."Qty." := TopList."Qty." + SalesEntry."Infocode Selected Qty."
                    ELSE
                        //TTT-VS    14Mar2022   <<--
                        TopList."Qty." := TopList."Qty." - SalesEntry.Quantity;
                    TopList.Amount := TopList.Amount - SalesEntry."Net Amount";
                    TopList."Discount Amount" := TopList."Discount Amount" + SalesEntry."Discount Amount";
                    TopList."Cost Amount" := TopList."Cost Amount" + SalesEntry."Cost Amount";
                    TopList.Profit := TopList.Amount + TopList."Cost Amount";
                    OnBeforeTopListModifyInSalesEntry(TopList, SalesEntry);
                    TopList.Modify;
                until SalesEntry.Next = 0;

        Window.Close;
        FilterChange := false;
        RefreshText := '';

        CatCounter := Counter;
        TopList.SetRange(Type, TopList.Type::Category);

        if not TopList.FindSet() then
            Error(NoData)
        else
            Rec := TopList;
    end;

    [Scope('OnPrem')]
    procedure calcProd()
    var
        Prod: Record "LSC Retail Product Group";
        Counter: Integer;
    begin
        if FilterChange then begin
            TopList.Reset;
            TopList.DeleteAll;
            TransCounter := 0;
            CustCounter := 0;
            ItemCounter := 0;
            DivCounter := 0;
            CatCounter := 0;
            ProdCounter := 0;
            StaffCounter := 0;
            VoidLineCounter := 0;
            VoidTransCounter := 0;
            CanLineCounter := 0;
        end else begin
            if ProdCounter <> 0 then begin
                TopList.SetRange(Type, TopList.Type::"Product Group");
                TopList.FindSet();
                Rec := TopList;
                exit;
            end;
        end;

        Window.Open(CounterTxt + '          ' + ' #1########\' + TotalRecTxt + ' #2########');

        SalesEntry.SetCurrentKey(Date);
        SalesEntry.SetFilter(Date, Rec.GetFilter("Date Filter"));
        SalesEntry.SetFilter(Time, Rec.GetFilter("Time Filter"));
        SalesEntry.SetFilter("Store No.", Rec.GetFilter("Store Filter"));
        SalesEntry.SETFILTER("Sales Type", Rec.GETFILTER("Sales Type Filter"));     //TTT
        OnAfterFilterSalesEntry(Rec, SalesEntry);
        Window.Update(2, SalesEntry.Count);

        if SalesEntry.FindSet() then
            repeat
                    Counter += 1;
                if (Counter mod 100) = 0 then
                    Window.Update(1, Counter);

                if not TopList.Get(TopList.Type::"Product Group", '', '', Format(SalesEntry."Retail Product Code")) then begin
                    TopList.Init;
                    TopList."Store No." := '';
                    TopList."POS Terminal No." := '';
                    TopList.Type := TopList.Type::"Product Group";
                    TopList."No." := SalesEntry."Retail Product Code";
                    TopList.Insert;
                end;
                if Prod.Get(SalesEntry."Item Category Code", SalesEntry."Retail Product Code") then
                    TopList.Description := Prod.Description;
                //TTT-VS    14Mar2022   -->>    
                IF (SalesEntry."Parent Line No." <> 0) THEN
                    TopList."Qty." := TopList."Qty." + SalesEntry."Infocode Selected Qty."
                ELSE
                    //TTT-VS    14Mar2022   <<--
                TopList."Qty." := TopList."Qty." - SalesEntry.Quantity;
                TopList.Amount := TopList.Amount - SalesEntry."Net Amount";
                TopList."Discount Amount" := TopList."Discount Amount" + SalesEntry."Discount Amount";
                TopList."Cost Amount" := TopList."Cost Amount" + SalesEntry."Cost Amount";
                TopList.Profit := TopList.Amount + TopList."Cost Amount";
                OnBeforeTopListModifyInSalesEntry(TopList, SalesEntry);
                TopList.Modify;
            until SalesEntry.Next = 0;

        Window.Close;
        FilterChange := false;
        RefreshText := '';

        ProdCounter := Counter;
        TopList.SetRange(Type, TopList.Type::"Product Group");

        if not TopList.FindSet() then
            Error(NoData)
        else
            Rec := TopList;
    end;

    [Scope('OnPrem')]
    procedure CalcStaff()
    var
        Staff: Record "LSC Staff";
        Counter: Integer;
    begin
        if FilterChange then begin
            TopList.Reset;
            TopList.DeleteAll;
            TransCounter := 0;
            CustCounter := 0;
            ItemCounter := 0;
            DivCounter := 0;
            CatCounter := 0;
            ProdCounter := 0;
            StaffCounter := 0;
            VoidLineCounter := 0;
            VoidTransCounter := 0;
            CanLineCounter := 0;
        end else begin
            if StaffCounter <> 0 then begin
                TopList.SetRange(Type, TopList.Type::Staff);
                TopList.FindSet();
                Rec := TopList;
                exit;
            end;
        end;

        Window.Open(CounterTxt + '          ' + ' #1########\' + TotalRecTxt + ' #2########');

        SalesEntry.SetCurrentKey(Date);
        SalesEntry.SetFilter(Date, Rec.GetFilter("Date Filter"));
        SalesEntry.SetFilter(Time, Rec.GetFilter("Time Filter"));
        SalesEntry.SetFilter("Store No.", Rec.GetFilter("Store Filter"));
        SalesEntry.SETFILTER("Sales Type", Rec.GETFILTER("Sales Type Filter"));     //TTT
        OnAfterFilterSalesEntry(Rec, SalesEntry);
        Window.Update(2, SalesEntry.Count);

        if SalesEntry.FindSet() then
                repeat
                    Counter += 1;
                    if (Counter mod 100) = 0 then
                        Window.Update(1, Counter);

                    if not TopList.Get(TopList.Type::Staff, '', '', Format(SalesEntry."Staff ID")) then begin
                        TopList.Init;
                        TopList."Store No." := '';
                        TopList."POS Terminal No." := '';
                        TopList.Type := TopList.Type::Staff;
                        TopList."No." := SalesEntry."Staff ID";
                        TopList.Insert;
                    end;
                    if Staff.Get(SalesEntry."Staff ID") then
                        TopList.Description := Staff."Name on Receipt";
                    //TTT-VS    14Mar2022   -->>    
                    IF (SalesEntry."Parent Line No." <> 0) THEN
                        TopList."Qty." := TopList."Qty." + SalesEntry."Infocode Selected Qty."
                    ELSE
                        //TTT-VS    14Mar2022   <<--
                        TopList."Qty." := TopList."Qty." - SalesEntry.Quantity;
                    TopList.Amount := TopList.Amount - SalesEntry."Net Amount";
                    TopList."Discount Amount" := TopList."Discount Amount" + SalesEntry."Discount Amount";
                    TopList."Cost Amount" := TopList."Cost Amount" + SalesEntry."Cost Amount";
                    TopList.Profit := TopList.Amount + TopList."Cost Amount";
                    OnBeforeTopListModifyInSalesEntry(TopList, SalesEntry);
                    TopList.Modify;
                until SalesEntry.Next = 0;

        Window.Close;
        FilterChange := false;
        RefreshText := '';

        StaffCounter := Counter;
        TopList.SetRange(Type, TopList.Type::Staff);

        if not TopList.FindSet() then
            Error(NoData)
        else
            Rec := TopList;
    end;

    local procedure StoreFilterOnAfterValidate()
    begin
        FilterChange := true;
        RefreshText := Refresh;
    end;

    local procedure DateFilterOnAfterValidate()
    begin
        FilterChange := true;
        RefreshText := Refresh;
    end;


    local procedure TimeFilterOnAfterValidate()
    begin
        FilterChange := true;
        RefreshText := Refresh;
    end;

    local procedure YearPeriodTypeOnPush()
    begin
        FindPeriod('');
    end;

    local procedure QuarterPeriodTypeOnPush()
    begin
        FindPeriod('');
    end;

    local procedure MonthPeriodTypeOnPush()
    begin
        FindPeriod('');
    end;

    local procedure WeekPeriodTypeOnPush()
    begin
        FindPeriod('');
    end;

    local procedure DayPeriodTypeOnPush()
    begin
        FindPeriod('');
    end;

    local procedure BalanceatDateAmountTypeOnPush()
    begin
        FindPeriod('');
    end;

    local procedure NetChangeAmountTypeOnPush()
    begin
        FindPeriod('');
    end;

    local procedure DayPeriodTypeOnValidate()
    begin
        DayPeriodTypeOnPush;
    end;

    local procedure WeekPeriodTypeOnValidate()
    begin
        WeekPeriodTypeOnPush;
    end;

    local procedure MonthPeriodTypeOnValidate()
    begin
        MonthPeriodTypeOnPush;
    end;

    local procedure QuarterPeriodTypeOnValidate()
    begin
        QuarterPeriodTypeOnPush;
    end;

    local procedure YearPeriodTypeOnValidate()
    begin
        YearPeriodTypeOnPush;
    end;

    local procedure NetChangeAmountTypeOnValidate()
    begin
        NetChangeAmountTypeOnPush;
    end;

    local procedure BalanceatDateAmountTypeOnValid()
    begin
        BalanceatDateAmountTypeOnPush;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFilterSalesEntry(TopList: Record "LSC Toplist Work Table"; var SalesEntry: Record "LSC Trans. Sales Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTopListModifyInSalesEntry(var TopList: Record "LSC Toplist Work Table"; SalesEntry: Record "LSC Trans. Sales Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFilterTransaction(TopList: Record "LSC Toplist Work Table"; var Transaction: Record "LSC Transaction Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTopListModifyInTransaction(var TopList: Record "LSC Toplist Work Table"; Transaction: Record "LSC Transaction Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFilterTransaction(SalesEntry: Record "LSC Trans. Sales Entry"; Rec: Record "LSC Toplist Work Table"; Transaction: Record "LSC Transaction Header"; var IsHandled: Boolean)
    begin
    end;

    //TTT <<
    local procedure CalcSalesType()
    var
        Counter: Integer;
        TransHeader: Record "LSC Transaction Header";
        SalesTypeRec: Record "LSC Sales Type";
        TransSalesEntry: Record "LSC Trans. Sales Entry";
    begin
        IPCVisible := TRUE;
        ATVVisible := TRUE;
        GuestVisible := TRUE;
        LineTransVisible := TRUE;
        IF FilterChange THEN BEGIN
            TopList.RESET;
            TopList.DELETEALL;
            TransCounter := 0;
            CustCounter := 0;
            ItemCounter := 0;
            catcounter := 0;
            prodcounter := 0;
            StaffCounter := 0;
            SalesTypeCounter := 0;
            VoidLineCounter := 0;
            VoidTransCounter := 0;
            DivCounter := 0;
            CanLineCounter := 0;
            DiscCodeCounter := 0;
        END ELSE BEGIN
            IF SalesTypeCounter <> 0 THEN BEGIN
                TopList.SETRANGE(Type, TopList.Type::"Sales Type");
                TopList.FIND('-');
                Rec := TopList;
                EXIT;
            END;
        END;

        Window.OPEN(CounterTxt + '          ' + ' #1########\' + TotalRecTxt + ' #2########');
        Window.UPDATE(2, "No. of Transactions");

        Transaction.SETCURRENTKEY("Entry Status", Date);
        Transaction.SETFILTER("Entry Status", '%1|%2', Transaction."Entry Status"::" ", Transaction."Entry Status"::Posted);
        Transaction.SETFILTER(Date, Rec.GETFILTER("Date Filter"));
        Transaction.SETFILTER(Time, Rec.GETFILTER("Time Filter"));  //TTT-VS
        Transaction.SETFILTER("Store No.", Rec.GETFILTER("Store Filter"));
        Transaction.SETFILTER("Sales Type", Rec.GETFILTER("Sales Type Filter"));

        IF Transaction.FIND('-') THEN
            REPEAT
                    IF Transaction."Transaction Type" = Transaction."Transaction Type"::Sales THEN BEGIN
                        Counter += 1;
                        IF (Counter MOD 100) = 0 THEN
                            Window.UPDATE(1, Counter);
                        IF NOT TopList.GET(TopList.Type::"Sales Type", '', '', Transaction."Sales Type") THEN BEGIN
                            TopList.INIT;
                            TopList.Type := TopList.Type::"Sales Type";
                            TopList."Store No." := '';
                            TopList."POS Terminal No." := '';
                            TopList."No." := Transaction."Sales Type";

                            TransHeader.RESET;
                            TransHeader.COPYFILTERS(Transaction);
                            TransHeader.SETRANGE(TransHeader."Entry Status", 0);
                            TransHeader.SETRANGE("Transaction Type", TransHeader."Transaction Type"::Sales);
                            TransHeader.SETRANGE("Sales Type", Transaction."Sales Type");
                            TopList."Line No. Of Transactions" := TransHeader.COUNT;
                            TopList.INSERT;
                        END;

                        IF SalesTypeRec.GET(SalesEntry."Sales Type") THEN
                            TopList.Description := SalesTypeRec.Description
                        ELSE
                            TopList.Description := '';
                        //TTT-VS    14Mar2022   -->>
                        TransSalesEntry.Reset();
                        TransSalesEntry.SetRange("Store No.", Transaction."Store No.");
                        TransSalesEntry.SetRange("POS Terminal No.", Transaction."POS Terminal No.");
                        TransSalesEntry.SetRange("Transaction No.", Transaction."Transaction No.");
                        TransSalesEntry.SetRange("Parent Line No.", 0);
                        TransSalesEntry.CalcSums(Quantity);
                        TopList."Qty." := TopList."Qty." + ABS(TransSalesEntry.Quantity);
                        //TopList."Qty." := TopList."Qty." + Transaction."No. of Items";
                        //TTT-VS    14Mar2022   <<--
                        TopList.Amount := TopList.Amount - Transaction."Net Amount";
                        TopList."Discount Amount" := TopList."Discount Amount" + Transaction."Discount Amount";
                        TopList."Cost Amount" := TopList."Cost Amount" + Transaction."Cost Amount";
                        TopList.Profit := TopList.Amount + TopList."Cost Amount";
                        TopList."Guest Count" := TopList."Guest Count" + Transaction."No. of Covers";

                        IF TopList."Line No. Of Transactions" <> 0 THEN BEGIN
                            TopList.IPC := ROUND(TopList."Qty." / TopList."Line No. Of Transactions");
                            TopList.ATV := ROUND(TopList.Amount / TopList."Line No. Of Transactions");
                        END;
                        TopList.MODIFY;
                    END;
            UNTIL Transaction.NEXT = 0;

        Window.CLOSE;
        FilterChange := FALSE;
        RefreshText := '';

        SalesTypeCounter := Counter;
        TopList.SETRANGE(Type, TopList.Type::"Sales Type");

        IF NOT TopList.FIND('-') THEN
            ERROR(NoData)
        ELSE
            Rec := TopList;

    end;

    procedure CalcVoidedTrans()
    var
        Counter: Integer;
        TransHeader: Record "LSC Transaction Header";
    begin
        IF FilterChange THEN BEGIN
            TopList.RESET;
            TopList.DELETEALL;
            TransCounter := 0;
            CustCounter := 0;
            ItemCounter := 0;
            catcounter := 0;
            prodcounter := 0;
            StaffCounter := 0;
            SalesTypeCounter := 0;
            VoidLineCounter := 0;
            VoidTransCounter := 0;
            DivCounter := 0;
            CanLineCounter := 0;

        END ELSE BEGIN
            IF VoidTransCounter <> 0 THEN BEGIN
                TopList.SETRANGE(Type, TopList.Type::"Voided Transactions");
                TopList.FIND('-');
                Rec := TopList;
                EXIT;
            END;
        END;

        Window.OPEN(
          CounterTxt + '          ' + ' #1########\' +
          TotalRecTxt + ' #2########');
        Window.UPDATE(2, "No. of Transactions");

        VoidedTrans.RESET;
        VoidedTrans.SETCURRENTKEY("Receipt No.");
        VoidedTrans.SETFILTER("Entry Status", '%1', VoidedTrans."Entry Status"::Voided);
        VoidedTrans.SETFILTER("Trans. Date", Rec.GETFILTER("Date Filter"));
        VoidedTrans.SETFILTER("Trans. Time", Rec.GETFILTER("Time Filter")); //TTT-VS
        VoidedTrans.SETFILTER("Store No.", Rec.GETFILTER("Store Filter"));
        VoidedTrans.SETFILTER("Sales Type", Rec.GETFILTER("Sales Type Filter"));

        IF VoidedTrans.FIND('-') THEN
            REPEAT
                    IF VoidedTrans."Transaction Type" = VoidedTrans."Transaction Type"::Sales THEN BEGIN
                        VoidedTrans.CALCFIELDS("Line Discount", "Total Discount", "Net Amount");
                        Counter += 1;
                        IF (Counter MOD 100) = 0 THEN
                            Window.UPDATE(1, Counter);

                        IF NOT TopList.GET(TopList.Type::"Voided Transactions", VoidedTrans."Store No.", VoidedTrans."POS Terminal No.", FORMAT(VoidedTrans."Receipt No.")) THEN BEGIN
                            TopList.INIT;
                            TopList.Type := TopList.Type::"Voided Transactions";
                            TopList."Store No." := VoidedTrans."Store No.";
                            TopList."POS Terminal No." := VoidedTrans."POS Terminal No.";
                            TopList."No." := FORMAT(VoidedTrans."Receipt No.");
                            TopList."Line No. Of Transactions" := 1;
                            TopList.INSERT;
                        END;

                        TopList.Description := Text001 + FORMAT(VoidedTrans."Receipt No.");

                        TopList."Qty." := TopList."Qty." + VoidedTrans."No. of Items";
                        TopList.Amount := TopList.Amount + VoidedTrans."Net Amount";
                        TopList."Discount Amount" := TopList."Discount Amount" + VoidedTrans."Line Discount" + VoidedTrans."Total Discount";
                        //TopList."Cost Amount" := TopList."Cost Amount" + VoidedTrans."Cost Amount";
                        //TopList.Profit := TopList.Amount + TopList."Cost Amount";
                        TopList."Guest Count" := TopList."Guest Count" + VoidedTrans."No. of Covers";
                        TopList.MODIFY;
                    END;
            UNTIL VoidedTrans.NEXT = 0;

        Window.CLOSE;
        FilterChange := FALSE;
        RefreshText := '';

        VoidTransCounter := Counter;
        TopList.SETRANGE(Type, TopList.Type::"Voided Transactions");

        IF NOT TopList.FIND('-') THEN
            ERROR(NoData)
        ELSE
            Rec := TopList;

        IPCVisible := FALSE;
        ATVVisible := FALSE;
        GuestVisible := TRUE;
        LineTransVisible := FALSE;
    end;

    procedure CalcVoidedLines()
    var
        Counter: Integer;
    begin
        IF FilterChange THEN BEGIN
            TopList.RESET;
            TopList.DELETEALL;
            TransCounter := 0;
            CustCounter := 0;
            ItemCounter := 0;
            catcounter := 0;
            prodcounter := 0;
            StaffCounter := 0;
            SalesTypeCounter := 0;
            VoidLineCounter := 0;
            VoidTransCounter := 0;
            DivCounter := 0;
            CanLineCounter := 0;

        END ELSE BEGIN
            IF VoidLineCounter <> 0 THEN BEGIN
                TopList.SETRANGE(Type, TopList.Type::"Voided Lines");
                TopList.FIND('-');
                Rec := TopList;
                EXIT;
            END;
        END;

        Window.OPEN(
          CounterTxt + '          ' + ' #1########\' +
          TotalRecTxt + ' #2########');

        VoidedLines.SETCURRENTKEY("Trans. Date");
        VoidedLines.SETFILTER("Trans. Date", Rec.GETFILTER("Date Filter"));
        VoidedTrans.SETFILTER("Trans. Time", Rec.GETFILTER("Time Filter")); //TTT-VS
        VoidedLines.SETFILTER("Store No.", Rec.GETFILTER("Store Filter"));
        VoidedLines.SETFILTER("Sales Type", Rec.GETFILTER("Sales Type Filter"));
        VoidedLines.SETRANGE("Sent To Kitchen", true);
        Window.UPDATE(2, VoidedLines.COUNT);

        IF VoidedLines.FIND('-') THEN
                REPEAT
                    Counter += 1;
                    IF (Counter MOD 100) = 0 THEN
                        Window.UPDATE(1, Counter);

                    IF NOT TopList.GET(TopList.Type::"Voided Lines", VoidedLines."Store No.", FORMAT(VoidedLines."Line No."), FORMAT(VoidedLines."Receipt No.")) THEN BEGIN
                        TopList.INIT;
                        TopList."Store No." := VoidedLines."Store No.";
                        TopList."POS Terminal No." := FORMAT(VoidedLines."Line No.");
                        TopList.Type := TopList.Type::"Voided Lines";
                        TopList."No." := FORMAT(VoidedLines."Receipt No.");
                        TopList.INSERT;
                    END;

                    TopList.Description := Text001 + FORMAT(VoidedLines."Receipt No.");
                    //TTT-VS    14Mar2022   -->>
                    If VoidedLines."Parent Line" <> 0 THEN
                        TopList."Qty." := TopList."Qty." + VoidedLines."Infocode Selected Qty."
                    else
                        //TTT-VS    14Mar2022   <<--
                        TopList."Qty." := TopList."Qty." + VoidedLines.Quantity;
                    TopList.Amount := TopList.Amount + VoidedLines."Net Amount";
                    TopList."Discount Amount" := TopList."Discount Amount" + VoidedLines."Discount Amount";
                    TopList."Cost Amount" := TopList."Cost Amount" + VoidedLines."Cost Amount";
                    TopList.Profit := TopList.Amount + TopList."Cost Amount";
                    TopList.MODIFY;
                UNTIL VoidedLines.NEXT = 0;

        Window.CLOSE;
        FilterChange := FALSE;
        RefreshText := '';

        VoidLineCounter := Counter;
        TopList.SETRANGE(Type, TopList.Type::"Voided Lines");

        IF NOT TopList.FIND('-') THEN
            ERROR(NoData)
        ELSE
            Rec := TopList;

        IPCVisible := FALSE;
        ATVVisible := FALSE;
        GuestVisible := FALSE;
        LineTransVisible := FALSE;
    end;

    procedure CalcCancelledLines()
    var
        Counter: Integer;
    begin
        IF FilterChange THEN BEGIN
            TopList.RESET;
            TopList.DELETEALL;
            TransCounter := 0;
            CustCounter := 0;
            ItemCounter := 0;
            catcounter := 0;
            prodcounter := 0;
            StaffCounter := 0;
            SalesTypeCounter := 0;
            VoidLineCounter := 0;
            VoidTransCounter := 0;
            DivCounter := 0;
            CanLineCounter := 0;

        END ELSE BEGIN
            IF CanLineCounter <> 0 THEN BEGIN
                TopList.SETRANGE(Type, TopList.Type::"Cancelled Lines");
                TopList.FIND('-');
                Rec := TopList;
                EXIT;
            END;
        END;

        Window.OPEN(
          CounterTxt + '          ' + ' #1########\' +
          TotalRecTxt + ' #2########');

        VoidedLines.SETCURRENTKEY("Trans. Date");
        VoidedLines.SETFILTER("Trans. Date", Rec.GETFILTER("Date Filter"));
        VoidedLines.SETFILTER("Store No.", Rec.GETFILTER("Store Filter"));
        VoidedLines.SETFILTER("Sales Type", Rec.GETFILTER("Sales Type Filter"));
        VoidedLines.SETRANGE("Sent To Kitchen", false);
        Window.UPDATE(2, VoidedLines.COUNT);

        IF VoidedLines.FIND('-') THEN
            REPEAT
                    Counter += 1;
                IF (Counter MOD 100) = 0 THEN
                    Window.UPDATE(1, Counter);

                IF NOT TopList.GET(TopList.Type::"Cancelled Lines", VoidedLines."Store No.", FORMAT(VoidedLines."Line No."), FORMAT(VoidedLines."Receipt No.")) THEN BEGIN
                    TopList.INIT;
                    TopList."Store No." := VoidedLines."Store No.";
                    TopList."POS Terminal No." := FORMAT(VoidedLines."Line No.");
                    TopList.Type := TopList.Type::"Cancelled Lines";
                    TopList."No." := FORMAT(VoidedLines."Receipt No.");
                    TopList.INSERT;
                END;

                TopList.Description := Text001 + FORMAT(VoidedLines."Receipt No.");
                //TTT-VS    14Mar2022   -->>
                If VoidedLines."Parent Line" <> 0 THEN
                    TopList."Qty." := TopList."Qty." + VoidedLines."Infocode Selected Qty."
                else
                    //TTT-VS    14Mar2022   <<--
                TopList."Qty." := TopList."Qty." + VoidedLines.Quantity;
                TopList.Amount := TopList.Amount + VoidedLines."Net Amount";
                TopList."Discount Amount" := TopList."Discount Amount" + VoidedLines."Discount Amount";
                TopList."Cost Amount" := TopList."Cost Amount" + VoidedLines."Cost Amount";
                TopList.Profit := TopList.Amount + TopList."Cost Amount";
                TopList.MODIFY;
            UNTIL VoidedLines.NEXT = 0;

        Window.CLOSE;
        FilterChange := FALSE;
        RefreshText := '';

        CanLineCounter := Counter;
        TopList.SETRANGE(Type, TopList.Type::"Cancelled Lines");

        IF NOT TopList.FIND('-') THEN
            ERROR(NoData)
        ELSE
            Rec := TopList;

        IPCVisible := FALSE;
        ATVVisible := FALSE;
        GuestVisible := FALSE;
        LineTransVisible := FALSE;
    end;

    //Disc. Code
    procedure CalcDiscCode()
    var
        ManualDiscCode: Record "Manual Discount Codes";
        TransHeader: Record "LSC Transaction Header";
        Counter: Integer;
    begin
        IPCVisible := FALSE;
        ATVVisible := FALSE;
        GuestVisible := FALSE;
        LineTransVisible := false;
        if FilterChange then begin
            TopList.Reset;
            TopList.DeleteAll;
            TransCounter := 0;
            CustCounter := 0;
            ItemCounter := 0;
            DivCounter := 0;
            CatCounter := 0;
            ProdCounter := 0;
            StaffCounter := 0;
            VoidLineCounter := 0;
            VoidTransCounter := 0;
            CanLineCounter := 0;
            DiscCodeCounter := 0;
        end else begin
            if DiscCodeCounter <> 0 then begin
                TopList.SetRange(Type, TopList.Type::"Disc. Code");
                TopList.FindSet();
                Rec := TopList;
                exit;
            end;
        end;

        Window.Open(CounterTxt + '          ' + ' #1########\' + TotalRecTxt + ' #2########');

        SalesEntry.SetCurrentKey(Date);
        SalesEntry.SETFILTER(Date, Rec.GetFilter("Date Filter"));
        SalesEntry.SETFILTER(Time, Rec.GetFilter("Time Filter"));
        SalesEntry.SETFILTER("Store No.", Rec.GetFilter("Store Filter"));
        SalesEntry.SETFILTER("Sales Type", Rec.GetFilter("Sales Type Filter"));     //TTT
        OnAfterFilterSalesEntry(Rec, SalesEntry);
        Window.Update(2, SalesEntry.Count);

        if SalesEntry.FindSet() then
                repeat
                    DiscEntry.Reset();
                    DiscEntry.SetRange("Transaction No.", SalesEntry."Transaction No.");
                    DiscEntry.SetRange("POS Terminal No.", SalesEntry."POS Terminal No.");
                    DiscEntry.SetRange("Store No.", SalesEntry."Store No.");
                    DiscEntry.SetRange("Line No.", SalesEntry."Line No.");
                    //DiscEntry.SetFilter("Discount Code", '%1|%2|%3', 'ENTERTAINER', 'TALABAT', 'ZOMATO');
                    if DiscEntry.FindFirst() then begin
                        //Message('TN:%1..LN:%2..DA:%3', DiscEntry."Transaction No.", DiscEntry."Line No.", DiscEntry."Discount Amount");
                        Counter += 1;
                        if (Counter mod 100) = 0 then
                            Window.Update(1, Counter);

                        if not TopList.Get(TopList.Type::"Disc. Code", '', '', Format(DiscEntry."Discount Code")) then begin
                            TopList.Init;
                            TopList."Store No." := '';
                            TopList."POS Terminal No." := '';
                            TopList.Type := TopList.Type::"Disc. Code";
                            TopList."No." := DiscEntry."Discount Code";
                            TopList.Insert;
                        end;
                        if ManualDiscCode.Get(DiscEntry."Discount Code") then
                            TopList.Description := ManualDiscCode.Description;
                        //TTT-VS    14Mar2022   -->>    
                        IF (SalesEntry."Parent Line No." <> 0) THEN
                            TopList."Qty." := TopList."Qty." + SalesEntry."Infocode Selected Qty."
                        ELSE
                            //TTT-VS    14Mar2022   <<--
                            TopList."Qty." := TopList."Qty." - SalesEntry.Quantity;
                        TopList.Amount := TopList.Amount - SalesEntry."Net Amount";
                        TopList."Discount Amount" := TopList."Discount Amount" + SalesEntry."Discount Amount";
                        TopList."Cost Amount" := TopList."Cost Amount" + SalesEntry."Cost Amount";
                        TopList.Profit := TopList.Amount + TopList."Cost Amount";
                        /*
                                            TransHeader.RESET;
                                            TransHeader.SetRange("Transaction No.", SalesEntry."Transaction No.");
                                            TransHeader.SetRange("POS Terminal No.", SalesEntry."POS Terminal No.");
                                            TransHeader.SetRange("Store No.", SalesEntry."Store No.");
                                            //TransHeader.SETFILTER("Entry Status", '%1|%2', TransHeader."Entry Status"::" ", TransHeader."Entry Status"::Posted);
                                            TransHeader.SETRANGE("Transaction Type", TransHeader."Transaction Type"::Sales);
                                            TopList."Line No. Of Transactions" := TopList."Line No. Of Transactions" + TransHeader.COUNT;
                        */
                        OnBeforeTopListModifyInSalesEntry(TopList, SalesEntry);
                        TopList.Modify;
                    end;
                until SalesEntry.Next = 0;

        Window.Close;
        FilterChange := false;
        RefreshText := '';

        DiscCodeCounter := Counter;
        TopList.SetRange(Type, TopList.Type::"Disc. Code");

        if not TopList.FindSet() then
            Error(NoData)
        else
            Rec := TopList;
    end;
}