function [finalPriceTableS1,finalPriceTableJtrue,finalNonSpecialPriceTable] = makeTable(ratioForXMonthsJTrue, ratioForXMonthsS1, xMonthsNonSpecialPrices)
    
    ranges = {[1,100],[101,500],[501,1000],[1001,2500],[2501,5000],[5001,7500],[7501,10000],[10001,100000]};
    
    %----------Serial = 1 Ratio Table -------------------------------------
    %----------------------------------------------------------------------
    
    %indexing - removes player Ids
    tempRatioForXMonthsS1 = removevars(ratioForXMonthsS1,{'Set, Player ID'});
    PriceTableS1 = [];

    for x = 1:size(ranges,2) % 8 price ranges (0-100,101-500,501-1000,1001-2500,2501-5000,5001-7500,7501-10000,10001-100000)
    
        currentRange = ranges{x};
        evaluatedRange = [];
        avgFactorMonths = [];
        
        %for each month
        for m = 1:size(xMonthsNonSpecialPrices,2) 
            
            count = 0;
            sum = 0;
            
            %for each non special price
            for i = 1:size(xMonthsNonSpecialPrices,1) 
                %if non special price is within range specified and the corresponding ratio is not NaN 
                if ((xMonthsNonSpecialPrices{i,m} >= currentRange(1)) & (xMonthsNonSpecialPrices{i,m} <= currentRange(2)) & (not(isnan(tempRatioForXMonthsS1{i,m}))) )
                                       
                    count = count+1;
                    sum = sum + tempRatioForXMonthsS1{i,m}; 
                  
                end  
            end
            
            avgFactorMonths = [avgFactorMonths (sum ./ count)];
            
         
        end
        
        evaluatedRange = [currentRange avgFactorMonths];
        PriceTableS1 = [PriceTableS1; evaluatedRange];      
        
    end
     
    %RENAME ALL THE VARIABLE HEADERS
    finalPriceTableS1Values = array2table(PriceTableS1(:,3:size(PriceTableS1,2)));
    finalPriceTableS1Header = array2table(PriceTableS1(:,1:2));    
    finalPriceTableS1Header.Properties.VariableNames = {'RangeLow' 'RangeHigh'};
    
    for i = 1:size(finalPriceTableS1Values,2)
        
        currentName = finalPriceTableS1Values.Properties.VariableNames{i};
        name = xMonthsNonSpecialPrices.Properties.VariableNames{i};                    
        finalPriceTableS1Values.Properties.VariableNames{currentName} = name;
           
    end
    
    %--AVG RATIO OF ALL MONTHS--
    %avgRatios = array2table(mean(table2array(finalPriceTableS1Values), 2, 'omitnan'));
    
    %-- AVG RATIO FOR LAST 2 MONTHS OF DATA -- 
    flippedRatios = fliplr(finalPriceTableS1Values);
    averages = [];
    
    %for each row
    for x = 1:size(flippedRatios,1)        
        count = 0;
        sum = 0;
        i = 1;
        %for each month
        while (count ~= 2) & (i <= size(flippedRatios,2))  
            
            if flippedRatios{x,i} > 0 %if we found a value
                count = count + 1;
                sum = sum + flippedRatios{x,i};
            end
            
            i = i + 1;
        
        end
        
        averages = [averages; (sum ./ count) ];  
        
    end
    
    avgRatios = array2table(averages);
    avgRatios.Properties.VariableNames = {'Final_Ratio_S1'};
    debugfinalPriceTableS1 = [finalPriceTableS1Header finalPriceTableS1Values avgRatios];  %displays months
    %final serial == 1
    finalPriceTableS1 = [finalPriceTableS1Header avgRatios];
    
    
    
    %----------Jersey = True Ratio Table ---------------------------------
    %---------------------------------------------------------------------
    
    %indexing - removes player Ids
    tempRatioForXMonthsJTrue = removevars(ratioForXMonthsJTrue,{'Set, Player ID'});
    PriceTableJTrue = [];

    for x = 1:size(ranges,2) % 8 price ranges (0-100,101-500,501-1000,1001-2500,2501-5000,5001-7500,7501-10000,10001-100000)
    
        currentRange = ranges{x};
        evaluatedRange = [];
        avgFactorMonths = [];
        
        %for each month
        for m = 1:size(xMonthsNonSpecialPrices,2) 
            
            count = 0;
            sum = 0;
            
            %for each asset
            for i = 1:size(xMonthsNonSpecialPrices,1) 
                %if monthly value is within range                
                if ((xMonthsNonSpecialPrices{i,m} >= currentRange(1)) & (xMonthsNonSpecialPrices{i,m} <= currentRange(2)) & (not(isnan(tempRatioForXMonthsJTrue{i,m}))))                   
                    count = count+1;
                    sum = sum + tempRatioForXMonthsJTrue{i,m};                                                     
                end  
            end
            
            avgFactorMonths = [avgFactorMonths (sum ./ count)];
            
         
        end
        
        evaluatedRange = [currentRange avgFactorMonths];
        PriceTableJTrue = [PriceTableJTrue; evaluatedRange];      
        
    end
     
    %------RENAME ALL THE VARIABLE HEADERS------
    finalPriceTableJTrueValues = array2table(PriceTableJTrue(:,3:size(PriceTableJTrue,2)));
    finalPriceTableJTrueHeader = array2table(PriceTableJTrue(:,1:2));    
    finalPriceTableJTrueHeader.Properties.VariableNames = {'RangeLow' 'RangeHigh'};
    
    for i = 1:size(finalPriceTableJTrueValues,2)
        
        currentName = finalPriceTableJTrueValues.Properties.VariableNames{i};
        name = xMonthsNonSpecialPrices.Properties.VariableNames{i};                    
        finalPriceTableJTrueValues.Properties.VariableNames{currentName} = name;
           
    end
    
    %----AVG RATIO FOR ALL MONTHS OF DATA------
    %avgRatios = array2table(mean(table2array(finalPriceTableJTrueValues), 2, 'omitnan'));
        
    %----AVG RATIO FOR LAST 2 MONTHS OF DATA---
    flippedRatios = fliplr(finalPriceTableJTrueValues);
    averages = [];
    
    %for each row
    for x = 1:size(flippedRatios,1)        
        count = 0;
        sum = 0;
        i = 1;
        %for each month
        while (count ~= 2) & (i <= size(flippedRatios,2))  
            
            if flippedRatios{x,i} > 0 %if we found a value
                count = count + 1;
                sum = sum + flippedRatios{x,i};
            end
            
            i = i + 1;
        
        end
        
        averages = [averages; (sum ./ count) ];  
        
    end
    
    avgRatios = array2table(averages);    
    avgRatios.Properties.VariableNames = {'Final_Ratio_JTrue'};
    debugfinalPriceTableJtrue = [finalPriceTableJTrueHeader finalPriceTableJTrueValues avgRatios];
    %final JTrue == 1
    finalPriceTableJtrue = [finalPriceTableJTrueHeader avgRatios];
    
    %--------------Final Prices Non Special Cards---------------------
    %----------------------------------------------------------------
    nonSpecialPricesFormat = table2array(xMonthsNonSpecialPrices);
    
    %----calculate average all months omitting 0s------. 
    %     [ii,~,v] = find(nonSpecialPricesFormat);
    %     nonSpecialPrices = array2table(accumarray(ii,v,[],@mean));
    %     ids = array2table(ratioForXMonthsJTrue{:,1});

    %----calculate average LAST 2 MONTHS THAT EXIST------ 

    flippedMonths = fliplr(xMonthsNonSpecialPrices);
    averages = [];
    
    %for each row
    for x = 1:size(flippedMonths,1)        
        count = 0;
        sum = 0;
        i = 1;
        %for each month
        while (count ~= 2) & (i <= size(xMonthsNonSpecialPrices,2))  
            
            if flippedMonths{x,i} > 0 %if we found a value
                count = count + 1;
                sum = sum + flippedMonths{x,i};
            end
            
            i = i + 1;
        
        end
        
        averages = [averages; (sum ./ count) ];  
        
    end
    
    nonSpecialPrices = array2table(averages);
    ids = array2table(ratioForXMonthsJTrue{:,1});        
                
%---------------------------------------------------------------      

    nonSpecialPrices.Properties.VariableNames = {'NonSpecialFinalPrices'};
    ids.Properties.VariableNames = {'PlayerSetID'};
    
    
    finalNonSpecialPriceTable = table;
    finalNonSpecialPriceTable = [ids nonSpecialPrices];
    
    %final
    finalNonSpecialPriceTable;
    
    
    
    
    
    
end