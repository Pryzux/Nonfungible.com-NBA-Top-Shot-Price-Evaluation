%This Function accepts yearly evaluated data from NBATopShotMethods and
%evaluates x months of data
%final = indicates the return value

function [ratioForXMonthsS1, ratioForXMonthsJTrue,xMonthsNonSpecialPrices] = months2Evaluate(months2Eval,nonSpecialCards,specialS1,specialJTrue)

    currentDate = today('datetime');
    currentMonth = month(currentDate);
    currentYear = year(currentDate); 
    
    %new tables to solve indexing issues
    tempNonSpecialCards = table;
    tempNonSpecialCards = [tempNonSpecialCards nonSpecialCards(:,3:14)]; 
    
    tempSpecialJTrue = table;
    tempSpecialJTrue = [tempSpecialJTrue specialJTrue(:,3:14)];  
    
    tempSpecialS1 = table;
    tempSpecialS1 = [tempSpecialS1 specialS1(:,3:14)];
    
    %if we are in the most recent year, index from present Month, else start at december
    if string(currentYear) == nonSpecialCards.Year(1)     
        if months2Eval > currentMonth
           months2Eval = currentMonth;
        end
        %CHANGE TO MONTH YOU WANT TO START EVALUATING FROM
        maxMonthEval = currentMonth;
    else
        maxMonthEval = 12;
    end  
    
    %starting month to evaluate
    start = maxMonthEval - months2Eval + 1;
       
    xMonthsNonSpecialPrices = table;
     
    %get x months of prices for evaluating price range table later
    for y = start:maxMonthEval
        xMonthsNonSpecialPrices = [xMonthsNonSpecialPrices tempNonSpecialCards(:,y)];       
    end
     
    %final
    xMonthsNonSpecialPrices;
    
    %create table S1
    ratioForXMonthsS1 = table;
    ratioForXMonthsS1 = [ratioForXMonthsS1 nonSpecialCards(:,1)];
    ratioForXMonthsS1.Properties.VariableNames = {'Set, Player ID'};
    
    %create table JTrue
    ratioForXMonthsJTrue = table;
    ratioForXMonthsJTrue = [ratioForXMonthsJTrue nonSpecialCards(:,1)];
    ratioForXMonthsJTrue.Properties.VariableNames = {'Set, Player ID'};
   
    for x = start:maxMonthEval      
        
           % ---------- ratio For X Months JTrue ------------
           
        monthJTrue = table2array(tempSpecialJTrue(:,x)); % Jersey True prices for month
        monthNS = table2array(tempNonSpecialCards(:,x)); %Non Special Prices for month
        
        ratioJTrue = monthJTrue ./ monthNS; %CALCULATION
         
        ratioJTrue = array2table(ratioJTrue);
        %if 0 / monthNS = 0 replace with nan becuase signifies not enough data
        ratioJTrue{:,1}(ratioJTrue{:,1}==0) = nan;
        %if monthJTrue / 0  = nan signifies not enough non special card data (rare but does happen)
        
        %create name for column
        name = strcat('RatioJTrue-', tempNonSpecialCards.Properties.VariableNames{x});
        ratioJTrue.Properties.VariableNames = {name}; 
        %append to dataset
        ratioForXMonthsJTrue = [ratioForXMonthsJTrue ratioJTrue ];
        %final
        ratioForXMonthsJTrue;
        
        % ------------- ratio For X Months S1 ----------------
        
        %grab month to eval       
        monthS1 = table2array(tempSpecialS1(:,x)); % Serial = 1 prices for month
       
 
        %FIND S1 and add to dataset
        ratioS1 = monthS1 ./ monthNS; %CALCULATION  
              
        ratioS1 = array2table(ratioS1);
        %if 0 / monthNS = 0 replace with nan becuase signifies not enough data
        ratioS1{:,1}(ratioS1{:,1}==0) = nan;
        %replace nans with 1s (aka no multiplicity)
        
        %create name for column
        name = strcat('RatioSerialOne-', tempNonSpecialCards.Properties.VariableNames{x});
        ratioS1.Properties.VariableNames = {name}; 
        %append to dataset
        ratioForXMonthsS1 = [ratioForXMonthsS1 ratioS1 ];
        %final
        ratioForXMonthsS1;
        
             
    end
                    
end

%if you want to print the values
%  writetable(ratioForXMonthsJTrue,'ratioForxMonths-2021.xlsx','Sheet',1);
%  writetable(ratioForXMonthsS1,'ratioForxMonths-2021.xlsx','Sheet',2);