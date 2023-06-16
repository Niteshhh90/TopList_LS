report 52001 "Business Summary APH"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Rep52001_BusinessSummaryAPH.rdl';
    Caption = 'Business Summary - APH';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Transaction Header"; "LSC Transaction Header")
        {
            DataItemTableView = SORTING("Store No.", Date)
                                WHERE("Transaction Type" = FILTER(Sales));
            column(CompanyName; COMPANYNAME)
            {
            }
            column(StoreNo_Filter; StoreNoFilter)
            {
            }

            column(StoreName; StoreName)
            {
            }
            column(FromDate_Filter; DateFilter1)
            {
            }
            column(ToDate_Filter; DateFilter2)
            {
            }
            column(Sales_Revenues; TotSalesAmt)
            {
            }
            column(PaidModifiers_Revenues; TotModifiedAmt)
            {
            }
            column(Surcharges_Revenues; TotSurchargeAmt)
            {
            }
            column(GrossSales_Revenues; TotGrossSales)
            {
            }
            column(Discounts_Revenues; TotDiscAmt)
            {
            }
            column(NetSalesInclVAT_Revenues; NetSalesInclVAT)
            {
            }
            column(Tax_Revenues; TotTax)
            {
            }
            column(NetSalesExclVAT_Revenues; NetSalesExclVAT)
            {
            }
            column(NetSalesExclVATDisc; NetSalesExclVATDisc)
            {
            }
            column(COGS_Costs_Profits; TotCOGS)
            {
            }
            column(GrossProfit_Costs_Profits; GrossProfit)
            {
            }
            column(TotSurchargeTaxAmt; TotSurchargeTaxAmt)
            {
            }
            column(Qty_OrderVoided; QtyOrderVoided)
            {
            }
            column(ValueInclVAT_OrderVoided; ValueInVAT_OrVoid)
            {
            }
            column(ValueExclVAT_OrderVoided; ValueExVAT_OrVoid)
            {
            }
            column(Qty_ItemsVoided; QtyItemsVoided)
            {
            }
            column(ValueInclVAT_ItemsVoided; ValueInVAT_ItmVoid)
            {
            }
            column(ValueExclVAT_ItemsVoided; ValueExVAT_ItmVoid)
            {
            }
            column(TotValueInclVAT_Voided; TotVoidedInclVAT)
            {
            }
            column(TotValueExclVAT_Voided; TotVoidedExclVAT)
            {
            }

            trigger OnAfterGetRecord();
            begin

                //Surcharge
                IncExpAccount.RESET;
                IncExpAccount.SETRANGE("Store No.", StoreNoFilter);
                IncExpAccount.SETFILTER("Gratuity Type", '<>%1', IncExpAccount."Gratuity Type"::Tips);
                IF IncExpAccount.FINDSET THEN BEGIN
                    REPEAT
                        TransIncExpEntry.RESET;
                        TransIncExpEntry.SETRANGE("Store No.", "Store No.");
                        TransIncExpEntry.SETRANGE("POS Terminal No.", "POS Terminal No.");
                        TransIncExpEntry.SETRANGE("Transaction No.", "Transaction No.");
                        TransIncExpEntry.SETRANGE("No.", IncExpAccount."No.");
                        IF TransIncExpEntry.FINDSET THEN
                            REPEAT
                                TotSurchargeAmt += TransIncExpEntry.Amount;
                                TotSurchargeTaxAmt += TransIncExpEntry."VAT Amount";
                                IF NOT SurchargeTemp.GET(TransIncExpEntry."No.") THEN BEGIN
                                    SurchargeTemp.INIT;
                                    SurchargeTemp."Entry No." := TransIncExpEntry."No.";
                                    SurchargeTemp.Description := IncExpAccount.Description;
                                    SurchargeTemp."Published Cost" := TransIncExpEntry.Amount;                       //Incl VAT
                                    SurchargeTemp."Negotiated Cost" := TransIncExpEntry."Net Amount";                //Excl VAT
                                    SurchargeTemp."Net Weight" := 1;
                                    SurchargeTemp.INSERT;
                                END ELSE BEGIN
                                    SurchargeTemp."Published Cost" += TransIncExpEntry.Amount;
                                    SurchargeTemp."Negotiated Cost" += TransIncExpEntry."Net Amount";
                                    SurchargeTemp."Net Weight" += 1;
                                    SurchargeTemp.MODIFY;
                                END;
                            UNTIL TransIncExpEntry.NEXT = 0;
                    UNTIL IncExpAccount.NEXT = 0;
                END;

                //Payment Types
                TransPaymentEntry.RESET;
                TransPaymentEntry.SETRANGE("Store No.", "Store No.");
                TransPaymentEntry.SETRANGE("POS Terminal No.", "POS Terminal No.");
                TransPaymentEntry.SETRANGE("Transaction No.", "Transaction No.");
                IF TransPaymentEntry.FINDSET THEN BEGIN
                    REPEAT
                        IF NOT PaymentTypesTemp.GET(TransPaymentEntry."Tender Type") THEN BEGIN
                            PaymentTypesTemp.INIT;
                            PaymentTypesTemp."Entry No." := TransPaymentEntry."Tender Type";
                            IF TenderType.GET(TransPaymentEntry."Store No.", TransPaymentEntry."Tender Type") THEN
                                PaymentTypesTemp.Description := TenderType.Description;
                            PaymentTypesTemp."Published Cost" := TransPaymentEntry."Amount Tendered";
                            IF NOT TransPaymentEntry."Change Line" THEN
                                PaymentTypesTemp."Net Weight" := TransPaymentEntry.Quantity;
                            PaymentTypesTemp.INSERT;
                        END ELSE BEGIN
                            PaymentTypesTemp."Published Cost" += TransPaymentEntry."Amount Tendered";
                            IF NOT TransPaymentEntry."Change Line" THEN
                                PaymentTypesTemp."Net Weight" += TransPaymentEntry.Quantity;
                            PaymentTypesTemp.MODIFY;
                        END;
                    UNTIL TransPaymentEntry.NEXT = 0;
                END;

                //Tips
                IncExpAccount.RESET;
                IncExpAccount.SETRANGE("Store No.", StoreNoFilter);
                IncExpAccount.SETRANGE("Gratuity Type", IncExpAccount."Gratuity Type"::Tips);
                IF IncExpAccount.FINDSET THEN BEGIN
                    REPEAT
                        TransIncExpEntry.RESET;
                        TransIncExpEntry.SETRANGE("Store No.", "Store No.");
                        TransIncExpEntry.SETRANGE("POS Terminal No.", "POS Terminal No.");
                        TransIncExpEntry.SETRANGE("Transaction No.", "Transaction No.");
                        TransIncExpEntry.SETRANGE("No.", IncExpAccount."No.");
                        IF TransIncExpEntry.FINDSET THEN
                            REPEAT
                                TransPaymentEntry.RESET;
                                TransPaymentEntry.SETRANGE("Store No.", TransIncExpEntry."Store No.");
                                TransPaymentEntry.SETRANGE("POS Terminal No.", TransIncExpEntry."POS Terminal No.");
                                TransPaymentEntry.SETRANGE("Transaction No.", TransIncExpEntry."Transaction No.");
                                IF TransPaymentEntry.FINDSET THEN BEGIN
                                    REPEAT
                                        IF NOT TipsTemp.GET(TransPaymentEntry."Tender Type") THEN BEGIN
                                            TipsTemp.INIT;
                                            TipsTemp."Entry No." := TransPaymentEntry."Tender Type";
                                            IF TenderType.GET(IncExpAccount."Store No.", TransPaymentEntry."Tender Type") THEN
                                                TipsTemp.Description := TenderType.Description;
                                            TipsTemp."Published Cost" := TransIncExpEntry.Amount;
                                            TipsTemp."Net Weight" := 1;
                                            TipsTemp.INSERT;
                                        END ELSE BEGIN
                                            TipsTemp."Published Cost" += TransIncExpEntry.Amount;
                                            TipsTemp."Net Weight" += 1;
                                            TipsTemp.MODIFY;
                                        END;
                                    UNTIL TransPaymentEntry.NEXT = 0;
                                END;
                            UNTIL TransIncExpEntry.NEXT = 0;
                    UNTIL IncExpAccount.NEXT = 0;
                END;

                TotGrossSales := ABS(TotSalesAmt) + ABS(TotModifiedAmt) + ABS(TotSurchargeAmt);
                NetSalesInclVAT := TotGrossSales - ABS(TotDiscAmt);
                NetSalesExclVAT := NetSalesInclVAT - ABS(TotTax);
                NetSalesExclVATDisc := TotGrossSales - ABS(TotTax);     //AJ 110523
                GrossProfit := NetSalesExclVAT - ABS(TotCOGS);

            end;

            trigger OnPreDataItem();
            begin
                "Transaction Header".SETRANGE("Store No.", StoreNoFilter);
                "Transaction Header".SETRANGE(Date, DateFilter1, DateFilter2);
                IF "Transaction Header".ISEMPTY THEN
                    CurrReport.SKIP;
                Clear(StoreName);
                if Store.Get(StoreNoFilter) then
                    StoreName := Store.Name;
                TotSalesAmt := 0;
                TotModifiedAmt := 0;
                TotSurchargeAmt := 0;
                TotSurchargeTaxAmt := 0;
                TotGrossSales := 0;
                TotDiscAmt := 0;
                TotTax := 0;
                TotCOGS := 0;
                NetSalesInclVAT := 0;
                NetSalesExclVAT := 0;
                NetSalesExclVATDisc := 0;
                GrossProfit := 0;
                QtyOrderVoided := 0;
                ValueInVAT_OrVoid := 0;
                ValueExVAT_OrVoid := 0;
                QtyItemsVoided := 0;
                ValueInVAT_ItmVoid := 0;
                ValueExVAT_ItmVoid := 0;
                TotVoidedInclVAT := 0;
                TotVoidedExclVAT := 0;
                TotQty_Staff := 0;
                TotValueEx_Staff := 0;
                TotValueIn_Staff := 0;
                TotQty_IC := 0;
                TotValueEx_IC := 0;
                TotValueIn_IC := 0;
                TotQty_PC := 0;
                TotValueEx_PC := 0;
                TotValueIn_PC := 0;
                TotQty_Div := 0;
                TotValueEx_Div := 0;
                TotValueIn_Div := 0;
                TotValueIn_OT := 0;

                //Orders voided
                OrderVoided_TH.RESET;
                OrderVoided_TH.SETRANGE("Store No.", StoreNoFilter);
                OrderVoided_TH.SETRANGE(Date, DateFilter1, DateFilter2);
                OrderVoided_TH.SETRANGE("Entry Status", OrderVoided_TH."Entry Status"::Voided);
                IF OrderVoided_TH.FINDSET THEN
                    REPEAT
                        QtyOrderVoided += 1;
                        POSVoidedTransLine.RESET;
                        POSVoidedTransLine.SETRANGE("Receipt No.", OrderVoided_TH."Receipt No.");
                        POSVoidedTransLine.SETRANGE("Store No.", OrderVoided_TH."Store No.");
                        POSVoidedTransLine.SETRANGE("POS Terminal No.", OrderVoided_TH."POS Terminal No.");
                        POSVoidedTransLine.SETRANGE("Entry Type", POSVoidedTransLine."Entry Type"::Item);
                        IF POSVoidedTransLine.FINDSET THEN
                            REPEAT
                                ValueInVAT_OrVoid += POSVoidedTransLine.Amount;
                                ValueExVAT_OrVoid += POSVoidedTransLine."Net Amount";
                                IF NOT VoidedDetailsTemp.GET(POSVoidedTransLine.Number) THEN BEGIN
                                    VoidedDetailsTemp."Receipt No." := POSVoidedTransLine.Number;
                                    VoidedDetailsTemp."Member Card No." := POSVoidedTransLine.Description;
                                    VoidedDetailsTemp."Service Charge" := POSVoidedTransLine.Amount;      //Incl VAT
                                    VoidedDetailsTemp.Rounded := POSVoidedTransLine."Net Amount";         //Excl VAT
                                    VoidedDetailsTemp."Order Limit" := POSVoidedTransLine.Quantity;
                                    VoidedDetailsTemp.INSERT;
                                END ELSE BEGIN
                                    VoidedDetailsTemp."Service Charge" += POSVoidedTransLine.Amount;       //Incl VAT
                                    VoidedDetailsTemp.Rounded += POSVoidedTransLine."Net Amount";          //Excl VAT
                                    VoidedDetailsTemp."Order Limit" += POSVoidedTransLine.Quantity;
                                    VoidedDetailsTemp.MODIFY;
                                END;
                            UNTIL POSVoidedTransLine.NEXT = 0;
                    UNTIL OrderVoided_TH.NEXT = 0;

                //Items voided
                ItemsVoided_TH.RESET;
                ItemsVoided_TH.SETRANGE("Store No.", StoreNoFilter);
                ItemsVoided_TH.SETRANGE(Date, DateFilter1, DateFilter2);
                ItemsVoided_TH.SETRANGE("Entry Status", ItemsVoided_TH."Entry Status"::" ");
                IF ItemsVoided_TH.FINDSET THEN
                    REPEAT
                        //Order Types
                        if ItemsVoided_TH."Entry Status" <> ItemsVoided_TH."Entry Status"::Voided then begin
                            IF NOT OrderTypesTemp.GET(ItemsVoided_TH."Sales Type") THEN BEGIN
                                OrderTypesTemp.INIT;
                                OrderTypesTemp."Entry No." := ItemsVoided_TH."Sales Type";
                                OrderTypesTemp."Published Cost" := ItemsVoided_TH."Gross Amount";
                                OrderTypesTemp."Net Weight" := 1;
                                OrderTypesTemp.INSERT;
                            END ELSE BEGIN
                                OrderTypesTemp."Published Cost" += ItemsVoided_TH."Gross Amount";
                                OrderTypesTemp."Net Weight" += 1;
                                OrderTypesTemp.MODIFY;
                            END;
                        end;
                        POSVoidedTransLine.RESET;
                        POSVoidedTransLine.SETRANGE("Receipt No.", ItemsVoided_TH."Receipt No.");
                        POSVoidedTransLine.SETRANGE("Store No.", ItemsVoided_TH."Store No.");
                        POSVoidedTransLine.SETRANGE("POS Terminal No.", ItemsVoided_TH."POS Terminal No.");
                        POSVoidedTransLine.SETRANGE("Entry Type", POSVoidedTransLine."Entry Type"::Item);
                        IF POSVoidedTransLine.FINDSET THEN
                            REPEAT
                                QtyItemsVoided += POSVoidedTransLine.Quantity;
                                ValueInVAT_ItmVoid += POSVoidedTransLine.Amount;
                                ValueExVAT_ItmVoid += POSVoidedTransLine."Net Amount";
                                IF NOT VoidedDetailsTemp.GET(POSVoidedTransLine.Number) THEN BEGIN
                                    VoidedDetailsTemp."Receipt No." := POSVoidedTransLine.Number;
                                    VoidedDetailsTemp."Member Card No." := POSVoidedTransLine.Description;
                                    VoidedDetailsTemp."Service Charge" := POSVoidedTransLine.Amount;      //Incl VAT
                                    VoidedDetailsTemp.Rounded := POSVoidedTransLine."Net Amount";        //Excl VAT
                                    VoidedDetailsTemp."Order Limit" := POSVoidedTransLine.Quantity;
                                    VoidedDetailsTemp.INSERT;
                                END ELSE BEGIN
                                    VoidedDetailsTemp."Service Charge" += POSVoidedTransLine.Amount;       //Incl VAT
                                    VoidedDetailsTemp.Rounded += POSVoidedTransLine."Net Amount";          //Excl VAT
                                    VoidedDetailsTemp."Order Limit" += POSVoidedTransLine.Quantity;
                                    VoidedDetailsTemp.MODIFY;
                                END;
                            UNTIL POSVoidedTransLine.NEXT = 0;
                    UNTIL ItemsVoided_TH.NEXT = 0;

                TotVoidedInclVAT := ABS(ValueInVAT_OrVoid) + ABS(ValueInVAT_ItmVoid);
                TotVoidedExclVAT := ABS(ValueExVAT_OrVoid) + ABS(ValueExVAT_ItmVoid);

                TransSalesEntry.RESET;
                TransSalesEntry.SETRANGE("Store No.", StoreNoFilter);
                TransSalesEntry.SETRANGE(Date, DateFilter1, DateFilter2);
                IF TransSalesEntry.FINDSET THEN BEGIN
                    REPEAT
                        IF (TransSalesEntry."Parent Line No." = 0) THEN
                            TotSalesAmt += TransSalesEntry."Net Amount" + TransSalesEntry."VAT Amount";
                        IF (TransSalesEntry."Line No." <> TransSalesEntry."Parent Line No.") AND (TransSalesEntry."Parent Line No." <> 0) THEN
                            TotModifiedAmt += TransSalesEntry."Net Amount" + TransSalesEntry."VAT Amount";
                        TotTax += TransSalesEntry."VAT Amount";
                        TotCOGS += TransSalesEntry."Cost Amount";

                        //Sales By Staff
                        IF NOT StaffTemp.GET(TransSalesEntry."Staff ID") THEN BEGIN
                            StaffTemp.INIT;
                            StaffTemp.ID := TransSalesEntry."Staff ID";
                            IF Staff.GET(TransSalesEntry."Staff ID") THEN
                                StaffTemp."Name on Receipt" := Staff."Name on Receipt";
                            StaffTemp."Hourly Rate" := TransSalesEntry."Net Amount" + TransSalesEntry."VAT Amount";   //Incl VAT                               //Incl VAT
                            StaffTemp."Max. Tender Decl. Difference" := TransSalesEntry."Net Amount";                 //Excl VAT
                            IF (TransSalesEntry."Line No." <> TransSalesEntry."Parent Line No.") AND (TransSalesEntry."Parent Line No." <> 0) THEN begin
                                if not TransSalesEntry."Return No Sale" then
                                    StaffTemp."Fraud Sort Field" := -1
                                else
                                    StaffTemp."Fraud Sort Field" := 1
                            end else
                                StaffTemp."Fraud Sort Field" := TransSalesEntry.Quantity;
                            StaffTemp.INSERT;
                        END ELSE BEGIN
                            StaffTemp."Hourly Rate" += TransSalesEntry."Net Amount" + TransSalesEntry."VAT Amount";
                            StaffTemp."Max. Tender Decl. Difference" += TransSalesEntry."Net Amount";
                            IF (TransSalesEntry."Line No." <> TransSalesEntry."Parent Line No.") AND (TransSalesEntry."Parent Line No." <> 0) THEN begin
                                if not TransSalesEntry."Return No Sale" then
                                    StaffTemp."Fraud Sort Field" += -1
                                else
                                    StaffTemp."Fraud Sort Field" += 1
                            end else
                                StaffTemp."Fraud Sort Field" += TransSalesEntry.Quantity;
                            StaffTemp.MODIFY;
                        END;

                        //Sales By Item Cateogry
                        IF NOT ItemCategoryTemp.GET(TransSalesEntry."Item Category Code") THEN BEGIN
                            ItemCategoryTemp.INIT;
                            ItemCategoryTemp.Code := TransSalesEntry."Item Category Code";
                            IF ItemCategory.GET(TransSalesEntry."Item Category Code") THEN
                                ItemCategoryTemp.Description := ItemCategory.Description;                //Excl VAT
                            ItemCategoryTemp."LSC Difference (LCY)" := TransSalesEntry."Net Amount" + TransSalesEntry."VAT Amount";                      //Incl VAT
                            ItemCategoryTemp."LSC Default Profit %" := TransSalesEntry."Net Amount";                //Excl VAT
                            IF (TransSalesEntry."Line No." <> TransSalesEntry."Parent Line No.") AND (TransSalesEntry."Parent Line No." <> 0) THEN begin
                                if not TransSalesEntry."Return No Sale" then
                                    ItemCategoryTemp."LSC Suggested Qty. on POS" := -1
                                else
                                    ItemCategoryTemp."LSC Suggested Qty. on POS" := 1
                            end else
                                ItemCategoryTemp."LSC Suggested Qty. on POS" := TransSalesEntry.Quantity;
                            ItemCategoryTemp.INSERT;
                        END ELSE BEGIN
                            ItemCategoryTemp."LSC Difference (LCY)" += TransSalesEntry."Net Amount" + TransSalesEntry."VAT Amount";    //Incl VAT
                            ItemCategoryTemp."LSC Default Profit %" += TransSalesEntry."Net Amount";                                   //Excl VAT
                            IF (TransSalesEntry."Line No." <> TransSalesEntry."Parent Line No.") AND (TransSalesEntry."Parent Line No." <> 0) THEN begin
                                if not TransSalesEntry."Return No Sale" then
                                    ItemCategoryTemp."LSC Suggested Qty. on POS" += -1
                                else
                                    ItemCategoryTemp."LSC Suggested Qty. on POS" += 1
                            end else
                                ItemCategoryTemp."LSC Suggested Qty. on POS" += TransSalesEntry.Quantity;
                            ItemCategoryTemp.MODIFY;
                        END;

                        //Sales By Product Group Code
                        IF NOT ProductGroupTemp.GET('', TransSalesEntry."Retail Product Code") THEN BEGIN
                            ProductGroupTemp.INIT;
                            ProductGroupTemp.Code := TransSalesEntry."Retail Product Code";
                            IF RetProductGroup.GET(TransSalesEntry."Item Category Code", TransSalesEntry."Retail Product Code") THEN
                                ProductGroupTemp.Description := RetProductGroup.Description;
                            ProductGroupTemp."Profit Goal %" := TransSalesEntry."Net Amount" + TransSalesEntry."VAT Amount";    //Incl VAT
                            ProductGroupTemp."Default Profit %" := TransSalesEntry."Net Amount";                                //Excl VAT
                            IF (TransSalesEntry."Line No." <> TransSalesEntry."Parent Line No.") AND (TransSalesEntry."Parent Line No." <> 0) THEN begin
                                if not TransSalesEntry."Return No Sale" then
                                    ProductGroupTemp."Suggested Qty. on POS" := -1
                                else
                                    ProductGroupTemp."Suggested Qty. on POS" := 1
                            end else
                                ProductGroupTemp."Suggested Qty. on POS" := TransSalesEntry.Quantity;
                            ProductGroupTemp.INSERT;
                        END ELSE BEGIN
                            ProductGroupTemp."Profit Goal %" += TransSalesEntry."Net Amount" + TransSalesEntry."VAT Amount";
                            ProductGroupTemp."Default Profit %" += TransSalesEntry."Net Amount";
                            IF (TransSalesEntry."Line No." <> TransSalesEntry."Parent Line No.") AND (TransSalesEntry."Parent Line No." <> 0) THEN begin
                                if not TransSalesEntry."Return No Sale" then
                                    ProductGroupTemp."Suggested Qty. on POS" += -1
                                else
                                    ProductGroupTemp."Suggested Qty. on POS" += 1
                            end else
                                ProductGroupTemp."Suggested Qty. on POS" += TransSalesEntry.Quantity;
                            ProductGroupTemp.MODIFY;
                        END;

                        //Sales By Division Code
                        IF NOT DivisionTemp.GET(TransSalesEntry."Division Code") THEN BEGIN
                            DivisionTemp.INIT;
                            DivisionTemp."Entry No." := TransSalesEntry."Division Code";
                            IF Division.GET(TransSalesEntry."Division Code") THEN
                                DivisionTemp.Description := Division.Description;
                            DivisionTemp."Published Cost" := TransSalesEntry."Net Amount" + TransSalesEntry."VAT Amount";     //Incl VAT
                            DivisionTemp."Negotiated Cost" := TransSalesEntry."Net Amount";                                   //Excl VAT
                            IF (TransSalesEntry."Line No." <> TransSalesEntry."Parent Line No.") AND (TransSalesEntry."Parent Line No." <> 0) THEN begin
                                if not TransSalesEntry."Return No Sale" then
                                    DivisionTemp."Net Weight" := -1
                                else
                                    DivisionTemp."Net Weight" := 1
                            end else
                                DivisionTemp."Net Weight" := TransSalesEntry.Quantity;
                            DivisionTemp.INSERT;
                        END ELSE BEGIN
                            DivisionTemp."Published Cost" += TransSalesEntry."Net Amount" + TransSalesEntry."VAT Amount";
                            DivisionTemp."Negotiated Cost" += TransSalesEntry."Net Amount";
                            IF (TransSalesEntry."Line No." <> TransSalesEntry."Parent Line No.") AND (TransSalesEntry."Parent Line No." <> 0) THEN begin
                                if not TransSalesEntry."Return No Sale" then
                                    DivisionTemp."Net Weight" += -1
                                else
                                    DivisionTemp."Net Weight" += 1
                            end else
                                DivisionTemp."Net Weight" += TransSalesEntry.Quantity;
                            DivisionTemp.MODIFY;
                        END;

                        TransDiscountEntry.RESET;
                        TransDiscountEntry.SETRANGE("Transaction No.", TransSalesEntry."Transaction No.");
                        TransDiscountEntry.SETRANGE("POS Terminal No.", TransSalesEntry."POS Terminal No.");
                        TransDiscountEntry.SETRANGE("Store No.", TransSalesEntry."Store No.");
                        TransDiscountEntry.SETRANGE("Line No.", TransSalesEntry."Line No.");
                        IF TransDiscountEntry.FINDFIRST THEN BEGIN
                            TotDiscAmt += TransDiscountEntry."Discount Amount";
                            IF NOT TransDiscEntryTemp.GET(TransDiscountEntry."Discount Code") THEN BEGIN
                                TransDiscEntryTemp."Entry No." := TransDiscountEntry."Discount Code";
                                TransDiscEntryTemp."Published Cost" := TransDiscountEntry."Discount Amount";
                                TransDiscEntryTemp."Net Weight" := 1;
                                TransDiscEntryTemp.INSERT;
                            END ELSE BEGIN
                                TransDiscEntryTemp."Published Cost" += TransDiscountEntry."Discount Amount";
                                TransDiscEntryTemp."Net Weight" += 1;
                                TransDiscEntryTemp.MODIFY;
                            END;
                        END;
                    UNTIL TransSalesEntry.NEXT = 0;
                END;

                StaffTemp.RESET;
                IF StaffTemp.FINDSET THEN
                    REPEAT
                        TotValueIn_Staff += ABS(StaffTemp."Hourly Rate");
                        TotValueEx_Staff += ABS(StaffTemp."Max. Tender Decl. Difference");
                        TotQty_Staff += StaffTemp."Fraud Sort Field";
                    UNTIL StaffTemp.NEXT = 0;

                ItemCategoryTemp.RESET;
                IF ItemCategoryTemp.FINDSET THEN
                    REPEAT
                        TotValueIn_IC += ABS(ItemCategoryTemp."LSC Difference (LCY)");
                        TotValueEx_IC += ABS(ItemCategoryTemp."LSC Default Profit %");
                        TotQty_IC += ItemCategoryTemp."LSC Suggested Qty. on POS";
                    UNTIL ItemCategoryTemp.NEXT = 0;

                ProductGroupTemp.RESET;
                IF ProductGroupTemp.FINDSET THEN
                    REPEAT
                        TotValueIn_PC += ABS(ProductGroupTemp."Profit Goal %");
                        TotValueEx_PC += ABS(ProductGroupTemp."Default Profit %");
                        TotQty_PC += ProductGroupTemp."Suggested Qty. on POS";
                    UNTIL ProductGroupTemp.NEXT = 0;

                DivisionTemp.RESET;
                IF DivisionTemp.FINDSET THEN
                    REPEAT
                        TotValueIn_Div += ABS(DivisionTemp."Published Cost");
                        TotValueEx_Div += ABS(DivisionTemp."Negotiated Cost");
                        TotQty_Div += DivisionTemp."Net Weight";
                    UNTIL DivisionTemp.NEXT = 0;

                OrderTypesTemp.RESET;
                IF OrderTypesTemp.FINDSET THEN
                    REPEAT
                        TotValueIn_OT += ABS(OrderTypesTemp."Published Cost");
                    UNTIL OrderTypesTemp.NEXT = 0;

            end;
        }
        dataitem(SalesBystaff; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1 ..));
            column(StaffID_Staff; StaffTemp.ID)
            {
            }
            column(StaffName_Staff; StaffTemp."Name on Receipt")
            {
            }
            column(ValueInclVAT_Staff; ABS(StaffTemp."Hourly Rate"))
            {
            }
            column(ValueExclVAT_Staff; ABS(StaffTemp."Max. Tender Decl. Difference"))
            {
            }
            column(Qty_Staff; StaffTemp."Fraud Sort Field")
            {
            }
            column(TotQty_Staff; TotQty_Staff)
            {
            }
            column(TotValueEx_Staff; TotValueEx_Staff)
            {
            }
            column(TotValueIn_Staff; TotValueIn_Staff)
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF Number = 1 THEN BEGIN
                    IF NOT StaffTemp.FIND('-') THEN
                        CurrReport.BREAK;
                END ELSE
                    IF StaffTemp.NEXT = 0 THEN
                        CurrReport.BREAK;
            end;
        }
        dataitem(SalesByItemCategory; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1 ..));
            column(ItemCategoryCode_IC; ItemCategoryTemp.Code)
            {
            }
            column(ItemCateName_IC; ItemCategoryTemp.Description)
            {
            }
            column(ValueInclVAT_IC; ABS(ItemCategoryTemp."LSC Difference (LCY)"))
            {
            }
            column(ValueExclVAT_IC; ABS(ItemCategoryTemp."LSC Default Profit %"))
            {
            }
            column(Qty_IC; ItemCategoryTemp."LSC Suggested Qty. on POS")
            {
            }
            column(TotQty_IC; TotQty_IC)
            {
            }
            column(TotValueEx_IC; TotValueEx_IC)
            {
            }
            column(TotValueIn_IC; TotValueIn_IC)
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF Number = 1 THEN BEGIN
                    IF NOT ItemCategoryTemp.FINDFIRST THEN
                        CurrReport.BREAK;
                END ELSE
                    IF ItemCategoryTemp.NEXT = 0 THEN
                        CurrReport.BREAK;
            end;
        }
        dataitem(SalesByProductGroup; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1 ..));
            column(ProdGrpCode_PC; ProductGroupTemp.Code)
            {
            }
            column(ProdGrpName_PC; ProductGroupTemp.Description)
            {
            }
            column(ValueInclVAT_PC; ABS(ProductGroupTemp."Profit Goal %"))
            {
            }
            column(ValueExclVAT_PC; ABS(ProductGroupTemp."Default Profit %"))
            {
            }
            column(Qty_PC; ProductGroupTemp."Suggested Qty. on POS")
            {
            }
            column(TotQty_PC; TotQty_PC)
            {
            }
            column(TotValueEx_PC; TotValueEx_PC)
            {
            }
            column(TotValueIn_PC; TotValueIn_PC)
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF Number = 1 THEN BEGIN
                    IF NOT ProductGroupTemp.FINDFIRST THEN
                        CurrReport.BREAK;
                END ELSE
                    IF ProductGroupTemp.NEXT = 0 THEN
                        CurrReport.BREAK;
            end;
        }
        dataitem(SalesByDivision; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1 ..));
            column(DivisionCode_Div; DivisionTemp."Entry No.")
            {
            }
            column(DivisionName_Div; DivisionTemp.Description)
            {
            }
            column(ValueInclVAT_Div; ABS(DivisionTemp."Published Cost"))
            {
            }
            column(ValueExclVAT_Div; ABS(DivisionTemp."Negotiated Cost"))
            {
            }
            column(Qty_Div; DivisionTemp."Net Weight")
            {
            }
            column(TotQty_Div; TotQty_Div)
            {
            }
            column(TotValueEx_Div; TotValueEx_Div)
            {
            }
            column(TotValueIn_Div; TotValueIn_Div)
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF Number = 1 THEN BEGIN
                    IF NOT DivisionTemp.FIND('-') THEN
                        CurrReport.BREAK;
                END ELSE
                    IF DivisionTemp.NEXT = 0 THEN
                        CurrReport.BREAK;
            end;
        }
        dataitem(VoidDetails; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1 ..));
            column(ItemNo_VoidDetails; VoidedDetailsTemp."Receipt No.")
            {
            }
            column(Description_VoidDetails; VoidedDetailsTemp."Member Card No.")
            {
            }
            column(ValueInclVAT_VoidDetails; ABS(VoidedDetailsTemp."Service Charge"))
            {
            }
            column(ValueExclVAT_VoidDetails; ABS(VoidedDetailsTemp.Rounded))
            {
            }
            column(Qty_VoidDetails; VoidedDetailsTemp."Order Limit")
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF Number = 1 THEN BEGIN
                    IF NOT VoidedDetailsTemp.FIND('-') THEN
                        CurrReport.BREAK;
                END ELSE
                    IF VoidedDetailsTemp.NEXT = 0 THEN
                        CurrReport.BREAK;
            end;
        }
        dataitem(Discount; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1 ..));
            column(DiscountAmt_Discount; ABS(TransDiscEntryTemp."Published Cost"))
            {
            }
            column(DiscQty_Discount; TransDiscEntryTemp."Net Weight")
            {
            }
            column(DiscountCode_Discount; TransDiscEntryTemp."Entry No.")
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF Number = 1 THEN BEGIN
                    IF NOT TransDiscEntryTemp.FIND('-') THEN
                        CurrReport.BREAK;
                END ELSE
                    IF TransDiscEntryTemp.NEXT = 0 THEN
                        CurrReport.BREAK;
            end;
        }
        dataitem(PaymentTypes; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1 ..));
            column(PaymentCode_PaymentTypes; PaymentTypesTemp."Entry No.")
            {
            }
            column(Value_PaymentTypes; ABS(PaymentTypesTemp."Published Cost"))
            {
            }
            column(Qty_PaymentTypes; PaymentTypesTemp."Net Weight")
            {
            }
            column(Description_PaymentTypes; PaymentTypesTemp.Description)
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF Number = 1 THEN BEGIN
                    IF NOT PaymentTypesTemp.FIND('-') THEN
                        CurrReport.BREAK;
                END ELSE
                    IF PaymentTypesTemp.NEXT = 0 THEN
                        CurrReport.BREAK;
            end;
        }
        dataitem(Tips; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1 ..));
            column(PaymentCode_Tips; TipsTemp."Entry No.")
            {
            }
            column(Amount_Tips; ABS(TipsTemp."Published Cost"))
            {
            }
            column(Qty_Tips; TipsTemp."Net Weight")
            {
            }
            column(Description_Tips; TipsTemp.Description)
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF Number = 1 THEN BEGIN
                    IF NOT TipsTemp.FIND('-') THEN
                        CurrReport.BREAK;
                END ELSE
                    IF TipsTemp.NEXT = 0 THEN
                        CurrReport.BREAK;
            end;
        }
        dataitem(Surcharge; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1 ..));
            column(IncExpNo_Surcharge; SurchargeTemp."Entry No.")
            {
            }
            column(Description_Surcharge; SurchargeTemp.Description)
            {
            }
            column(ValueInclVAT_Surcharge; ABS(SurchargeTemp."Published Cost"))
            {
            }
            column(ValueExclVAT_Surcharge; ABS(SurchargeTemp."Negotiated Cost"))
            {
            }
            column(Qty_Surcharge; SurchargeTemp."Net Weight")
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF Number = 1 THEN BEGIN
                    IF NOT SurchargeTemp.FIND('-') THEN
                        CurrReport.BREAK;
                END ELSE
                    IF SurchargeTemp.NEXT = 0 THEN
                        CurrReport.BREAK;
            end;
        }
        dataitem(OrderTypes; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1 ..));
            column(SalesType_OrderType; OrderTypesTemp."Entry No.")
            {
            }
            column(ValueInclVAT_OrderType; ABS(OrderTypesTemp."Published Cost"))
            {
            }
            column(NoOfOrders_OrderType; OrderTypesTemp."Net Weight")
            {
            }
            column(TotValueIn_OT; TotValueIn_OT)
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF Number = 1 THEN BEGIN
                    IF NOT OrderTypesTemp.FIND('-') THEN
                        CurrReport.BREAK;
                END ELSE
                    IF OrderTypesTemp.NEXT = 0 THEN
                        CurrReport.BREAK;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StoreNoFilter; StoreNoFilter)
                    {
                        Caption = 'Store';
                        TableRelation = "LSC Store";
                        ApplicationArea = All;
                    }
                    field(DateFilter1; DateFilter1)
                    {
                        Caption = 'From Date';
                        ApplicationArea = All;
                    }
                    field(DateFilter2; DateFilter2)
                    {
                        Caption = 'To Date';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            if DateFilter2 < DateFilter1 then
                                Error('To Date cannot be less then From Date.');
                        end;
                    }
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
        IF RetailUser.GET(USERID) THEN
            StoreNoFilter := RetailUser."Store No.";
    end;

    trigger OnPostReport();
    begin
        PaymentTypesTemp.DeleteAll();
        TipsTemp.DeleteAll();
        StaffTemp.DeleteAll();
        ItemCategoryTemp.DeleteAll();
        ProductGroupTemp.DeleteAll();
        DivisionTemp.DeleteAll();
        SurchargeTemp.DeleteAll();
        TransDiscEntryTemp.DeleteAll();
        VoidedDetailsTemp.DeleteAll();
        OrderTypesTemp.DeleteAll();
    end;

    trigger OnPreReport();
    begin
        IF StoreNoFilter = '' THEN
            ERROR('Store No. can not be blank.');
        IF (DateFilter1 = 0D) AND (DateFilter2 = 0D) THEN
            ERROR('Date filters can not be blank.');
        IF DateFilter1 = 0D THEN
            ERROR('From Date can not be blank.');
        IF DateFilter2 = 0D THEN
            ERROR('To Date can not be blank.');
        if DateFilter2 < DateFilter1 then
            Error('To Date cannot be less then From Date.');
        PaymentTypesTemp.DeleteAll();
        TipsTemp.DeleteAll();
        StaffTemp.DeleteAll();
        ItemCategoryTemp.DeleteAll();
        ProductGroupTemp.DeleteAll();
        DivisionTemp.DeleteAll();
        SurchargeTemp.DeleteAll();
        TransDiscEntryTemp.DeleteAll();
        VoidedDetailsTemp.DeleteAll();
        OrderTypesTemp.DeleteAll();
    end;

    var
        Store: Record "LSC Store";
        RetailUser: Record "LSC Retail User";
        TransSalesEntry: Record "LSC Trans. Sales Entry";
        TransDiscountEntry: Record "LSC Trans. Discount Entry";
        TransIncExpEntry: Record "LSC Trans. Inc./Exp. Entry";
        IncExpAccount: Record "LSC Income/Expense Account";
        TransPaymentEntry: Record "LSC Trans. Payment Entry";
        TenderType: Record "LSC Tender Type";
        POSVoidedTransLine: Record "LSC POS Voided Trans. Line";
        Staff: Record "LSC Staff";
        ItemCategory: Record "Item Category";
        Division: Record "LSC Division";
        RetProductGroup: Record "LSC Retail Product Group";
        OrderTypesTemp: Record "Nonstock Item" temporary;
        PaymentTypesTemp: Record "Nonstock Item" temporary;
        TipsTemp: Record "Nonstock Item" temporary;
        StaffTemp: Record "LSC Staff" temporary;
        ProductGroupTemp: Record "LSC Retail Product Group" temporary;
        ItemCategoryTemp: Record "Item Category" temporary;
        DivisionTemp: Record "Nonstock Item" temporary;
        SurchargeTemp: Record "Nonstock Item" temporary;
        TransDiscEntryTemp: Record "Nonstock Item" temporary;
        OrderVoided_TH: Record "LSC Transaction Header";
        ItemsVoided_TH: Record "LSC Transaction Header";
        VoidedDetailsTemp: Record "LSC POS Voided Transaction" temporary;
        DateFilter1: Date;
        DateFilter2: Date;
        StoreNoFilter: Code[10];
        StoreName: Text[100];
        TotSalesAmt: Decimal;
        TotModifiedAmt: Decimal;
        TotSurchargeAmt: Decimal;
        TotGrossSales: Decimal;
        TotDiscAmt: Decimal;
        NetSalesInclVAT: Decimal;
        TotTax: Decimal;
        NetSalesExclVAT: Decimal;
        NetSalesExclVATDisc: Decimal;
        TotCOGS: Decimal;
        GrossProfit: Decimal;
        TotQty_IC: Decimal;
        TotQty_PC: Decimal;
        TotQty_Div: Decimal;
        QtyOrderVoided: Decimal;
        ValueInVAT_OrVoid: Decimal;
        ValueExVAT_OrVoid: Decimal;
        QtyItemsVoided: Decimal;
        ValueInVAT_ItmVoid: Decimal;
        ValueExVAT_ItmVoid: Decimal;
        TotVoidedInclVAT: Decimal;
        TotVoidedExclVAT: Decimal;
        TotSurchargeTaxAmt: Decimal;
        TotValueEx_Div: Decimal;
        TotValueIn_Div: Decimal;
        TotValueEx_Staff: Decimal;
        TotValueIn_Staff: Decimal;
        TotValueEx_IC: Decimal;
        TotValueIn_IC: Decimal;
        TotValueEx_PC: Decimal;
        TotValueIn_PC: Decimal;
        TotQty_Staff: Decimal;
        TotValueIn_OT: Decimal;
}

