function [evaluatedWallet] = allDataEval(data,wallet)
    currentDate = today('datetime'); 
    currentYear = year(currentDate);
    middleYears = currentYear - 2020; %years to evaluate that isn't 2020 || current year
   
    %'blocktimestamp' current date format: eee MMM dd u HH:mm:ss 'GMT+0000 (Coordinated Universal Time)'
    %the NBATopShotMethod is only capable of processing data a year at a
    %time #sns so this is the work around to process all years of data.
    % we first process the earliest year of data (in hindsight i probably
    % could have included this in middle years) then we process the middle
    % years, then the current year, then append all the data together and
    % process through other functions left same as before. 
     disp(['Starting Evaluation for Years ',num2str(currentYear),'-2020']);
    
    %-------------EARLIEST YEAR--------------------
    %----------------------------------------------

    %process very first year -  6 months of data from July - December
    disp('Processing Year: 2020..');
    [nonSpecialCards_2020,specialS1_2020,specialJTrue_2020] = NBATopShotMethods('2020',data);
    disp('Creating Monthly Ratios..');
    [ratioForXMonthsS1_2020, ratioForXMonthsJTrue_2020,xMonthsNonSpecialPrices_2020] = months2Evaluate(6,nonSpecialCards_2020,specialS1_2020,specialJTrue_2020); 
    disp('2020 Completed');
    
    %-------------MIDDLE YEARS---------------------
    %----------------------------------------------
    %This function has never been tested and won't execute until 2022
    %SAMPLE CALC where currentYear = 2022 | ((2022 - 2020 = 2) - 1) = 1 middle years [2021]
    
    middleXMonthsS1 = table;
    middleXMonthsJTrue = table;
    middleXMonthsNS = table;
    
    %if we have no middle years
    if middleYears == 1
        n = 0;
    elseif middleYears > 1 
        n = middleYears - 1;
        yearToStartEval = currentYear - 1;
        disp(['Middle Years To Process: ',num2str(n)] );
    end
          
    %for each year
    for i = 1:n     
        %process year x
        disp(['Processing Year: ',num2str(yearToStartEval),'..']);
        [nonSpecialCards,specialS1,specialJTrue] = NBATopShotMethods(char(string(yearToStartEval)),data);      
        [ratioForXMonthsS1, ratioForXMonthsJTrue,xMonthsNonSpecialPrices] = months2Evaluate(12,nonSpecialCards,specialS1,specialJTrue);        
        %append data        
        middleXMonthsS1 = [middleXMonthsS1 ratioForXMonthsS1(:,2:size(ratioForXMonthsS1,2))];
        middleXMonthsJTrue = [middleXMonthsJTrue ratioForXMonthsJTrue(:,2:size(ratioForXMonthsJTrue,2))];
        middleXMonthsNS = [middleXMonthsNS xMonthsNonSpecialPrices];
        disp(['Processed Year: ',num2str(yearToStartEval)]);
        %next year to eval 
        yearToStartEval = yearToStartEval - 1;

    end
    
    %-------------CURRENT YEAR---------------------
    %----------------------------------------------
    
     %evaluate current year
     disp(['Processing Year: ',num2str(currentYear),'..']);
     [nonSpecialCards_CY,specialS1_CY,specialJTrue_CY] = NBATopShotMethods(char(string(currentYear)),data);
     disp(['Processed Year: ',num2str(currentYear)]);
     [ratioForXMonthsS1_CY, ratioForXMonthsJTrue_CY,xMonthsNonSpecialPrices_CY] = months2Evaluate(12,nonSpecialCards_CY,specialS1_CY,specialJTrue_CY);
     
     
    %-------------APPEND ALL YEARS-----------------
    %----------------------------------------------
     %append             [first year 2020    -      middle years  -    current year ]
     finalxMonthsNS = [xMonthsNonSpecialPrices_2020 middleXMonthsNS xMonthsNonSpecialPrices_CY]; 
     finalRatioxMonthsS1 = [ratioForXMonthsS1_2020 middleXMonthsS1 ratioForXMonthsS1_CY(:,2:size(ratioForXMonthsS1_CY,2))]; 
     finalRatioxMonthsJTrue = [ratioForXMonthsJTrue_2020 middleXMonthsJTrue ratioForXMonthsJTrue_CY(:,2:size(ratioForXMonthsJTrue_CY,2))]; 
     
    %----------------EVALUATE----------------------
    %----------------------------------------------
  
    %Input evaluation data, output ratios for x months of data and x months of nonspecial prices for creating the price range table
    [finalPriceTableS1,finalPriceTableJtrue,finalNonSpecialPriceTable] = makeTable(finalRatioxMonthsJTrue, finalRatioxMonthsS1, finalxMonthsNS);
    disp('Making Ratio Tables..');
    %EVALUATE WALLET
    disp('Evaluating Wallet.. ');
    [nonSpecialPriceWallet, specialS1_Wallet, specialJTrue_Wallet] = evaluateWallet(finalPriceTableS1,finalPriceTableJtrue,finalNonSpecialPriceTable,wallet);
    disp('Wallet Evaluated!');
    
    %final
    evaluatedWallet = [specialS1_Wallet; specialJTrue_Wallet; nonSpecialPriceWallet];
    
    disp('Printing Evaluated Wallet..');
    writetable(evaluatedWallet,'NBAevaluatedWallet.xlsx','Sheet',1);
    disp('Printing Wallet Breakdown..');
    writetable(nonSpecialPriceWallet,'NBAevaluatedWalletBreakdown.xlsx','Sheet',1);
    writetable(specialJTrue_Wallet,'NBAevaluatedWalletBreakdown.xlsx','Sheet',2);
    writetable(specialS1_Wallet,'NBAevaluatedWalletBreakdown.xlsx','Sheet',3);
    writetable(finalPriceTableS1,'NBAevaluatedWalletBreakdown.xlsx','Sheet',4);
    writetable(finalPriceTableJtrue,'NBAevaluatedWalletBreakdown.xlsx','Sheet',5);
    writetable(finalNonSpecialPriceTable,'NBAevaluatedWalletBreakdown.xlsx','Sheet',6);
    disp('Files Succesfully Created: NBAevaluatedWallet & NBAevaluatedWalletBreakdown');

end