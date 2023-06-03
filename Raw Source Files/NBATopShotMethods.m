%tic; %use for measuring completion time

%BEFORE RUNNING: 
%Import Topshot Market Data and set NBATSMD = imported data

%POSSIBLE COMPLICATIONS:
%May require date formatting: current format: eee MMM dd u HH:mm:ss 'GMT+0000 (Coordinated Universal Time)'

function [nonSpecialCards,specialS1,specialJTrue] = NBATopShotMethods(yearOfDataToCapture,topShotData)

    
    NBATSMD = topShotData;
    %Linking To Data
    currentNBATSMD = NBATSMD;
    SerialNumber = NBATSMD.metaplay_serial;
    JerseyFlag = NBATSMD.metaplay_is_jersey; 

    %Create new columns to dataset | uniqueCode & setPlayerID
    currentNBATSMD.UniqueCode = convertStringsToChars((strcat(string(currentNBATSMD.metaset_id),',', string(currentNBATSMD.metaplay_player_id),',' , string(year(currentNBATSMD.blockTimestamp)),',' , string(month(currentNBATSMD.blockTimestamp))))); %Combination of Set ID, Player ID, Year, Month 
    currentNBATSMD.setPlayerID = convertStringsToChars(strcat(string(currentNBATSMD.metaset_id),',',string(currentNBATSMD.metaplay_player_id)));

    %filter dataset into 3 Sections 
    allElementsYear = currentNBATSMD(string(year(currentNBATSMD.blockTimestamp)) == yearOfDataToCapture, :); %All cards where year = yearOfDataToCapture
    specialElementsS1 = currentNBATSMD(currentNBATSMD.metaplay_serial < 2 & string(year(currentNBATSMD.blockTimestamp)) == yearOfDataToCapture, :); %All cards where serial = 1
    specialElementsJTrue = currentNBATSMD(currentNBATSMD.metaplay_is_jersey == 'true' & string(year(currentNBATSMD.blockTimestamp)) == yearOfDataToCapture, :); %All cards where Jersey == Serial
    allNonSpecialElements = currentNBATSMD(currentNBATSMD.metaplay_serial >= 2 & currentNBATSMD.metaplay_is_jersey == 'false' & string(year(currentNBATSMD.blockTimestamp)) == yearOfDataToCapture,:); 


    %------------------  Calculate Average Price of Each Set-Player Per Month for each "dataset" -----------

    %--NON SPECIAL ASSET EVALUATION  --

    %Group/Aggregate players by unique code aka by [Set - Player - Year - Month ]
    [setOfUniqueCodesNS, ~, setOfUniqueCodesIndexesNS] = unique(allNonSpecialElements.UniqueCode, 'first');
    %Calculate Sum of each players set per month (USD)
    setPlayerSumPerMonthNS = accumarray(setOfUniqueCodesIndexesNS, allNonSpecialElements.usdPrice, size(setOfUniqueCodesNS), @(x) sum(x));
    %find number of sales for each sum to find the average
    numberOfSalesEachPlayerNS = groupcounts(allNonSpecialElements,'UniqueCode');
    %create table and compute average based on numbers calculated
    rawNonSpecialAvgData = table(numberOfSalesEachPlayerNS.UniqueCode,setPlayerSumPerMonthNS,numberOfSalesEachPlayerNS.GroupCount, setPlayerSumPerMonthNS./numberOfSalesEachPlayerNS.GroupCount );
    %update variable names
    rawNonSpecialAvgData.Properties.VariableNames = {'uniqueCode' 'SumPerMonth' 'SoldPerMonth' 'Average'};
    %Sort the data (for debugging)
    sortedNonSpecialAvgData = sortrows(rawNonSpecialAvgData,{'uniqueCode'});
    %parse and add neccesary metrics year, month, and setPlayerID for calculations 
    s1 = split(sortedNonSpecialAvgData.uniqueCode, ','); 
    s1 = cell2table(s1); 
    %referencing default variable names, if error ever occurs here here then just define the variables instead of using the generated ones
    sortedNonSpecialAvgData.setPlayerID = convertStringsToChars(strcat(string(s1.s11),',',string(s1.s12))); 
    sortedNonSpecialAvgData.month = convertStringsToChars(string(s1.s14));
    sortedNonSpecialAvgData.year = convertStringsToChars(string(s1.s13));

    %--SPECIAL ASSET EVALUATION (Serial == 1)--

    %Group/Aggregate players by unique code aka by [Set - Player - Year - Month ]
    [setOfUniqueCodesS1, ~, setOfUniqueCodesIndexesS1] = unique(specialElementsS1.UniqueCode, 'first');
    %Calculate Sum of each players set per month
    setPlayerSumPerMonthS1 = accumarray(setOfUniqueCodesIndexesS1, specialElementsS1.usdPrice, size(setOfUniqueCodesS1), @(x) sum(x));
    %find number of sales for each sum to find the average
    numberOfSalesEachPlayerS1 = groupcounts(specialElementsS1,'UniqueCode');
    %create table and compute average based on numbers calculated
    rawSpecialElementsS1 = table(numberOfSalesEachPlayerS1.UniqueCode,setPlayerSumPerMonthS1,numberOfSalesEachPlayerS1.GroupCount, setPlayerSumPerMonthS1./numberOfSalesEachPlayerS1.GroupCount );
    %update variable names
    rawSpecialElementsS1.Properties.VariableNames = {'uniqueCode' 'SumPerMonth' 'SoldPerMonth' 'Average'};
    %Sort the data (for debugging)
    sortedSpecialElementsS1 = sortrows(rawSpecialElementsS1,{'uniqueCode'});
    %parse and add neccesary metrics year, month, and setPlayerID for calculations 
    s2 = split(sortedSpecialElementsS1.uniqueCode, ','); 
    s2 = cell2table(s2); 
    %referencing default variable names, if error ever occurs here here then just define the variables instead of using the generated ones
    sortedSpecialElementsS1.setPlayerID = convertStringsToChars(strcat(string(s2.s21),',',string(s2.s22))); 
    sortedSpecialElementsS1.month = convertStringsToChars(string(s2.s24));
    sortedSpecialElementsS1.year = convertStringsToChars(string(s2.s23));

    %--SPECIAL ASSET EVALUATION (Jersey is True)--

    %Group/Aggregate players by unique code aka by [Set - Player - Year - Month ]
    [setOfUniqueCodesS2, ~, setOfUniqueCodesIndexesS2] = unique(specialElementsJTrue.UniqueCode, 'first');
    %Calculate Sum of each players set per month
    setPlayerSumPerMonthS2 = accumarray(setOfUniqueCodesIndexesS2, specialElementsJTrue.usdPrice, size(setOfUniqueCodesS2), @(x) sum(x));
    %find number of sales for each sum to find the average
    numberOfSalesEachPlayerS2 = groupcounts(specialElementsJTrue,'UniqueCode');
    %create table and compute average based on numbers calculated
    rawSpecialElementsJTrue = table(numberOfSalesEachPlayerS2.UniqueCode,setPlayerSumPerMonthS2,numberOfSalesEachPlayerS2.GroupCount, setPlayerSumPerMonthS2./numberOfSalesEachPlayerS2.GroupCount );
    %update variable names
    rawSpecialElementsJTrue.Properties.VariableNames = {'uniqueCode' 'SumPerMonth' 'SoldPerMonth' 'Average'};
    %Sort the data (for debugging)
    sortedSpecialElementsJTrue = sortrows(rawSpecialElementsJTrue,{'uniqueCode'});
    %parse and add neccesary metrics year, month, and setPlayerID for calculations 
    s3 = split(sortedSpecialElementsJTrue.uniqueCode, ','); 
    s3 = cell2table(s3); 
    %referencing default variable names, if error ever occurs here here then just define the variables instead of using the generated ones
    sortedSpecialElementsJTrue.setPlayerID = convertStringsToChars(strcat(string(s3.s31),',',string(s3.s32))); 
    sortedSpecialElementsJTrue.month = convertStringsToChars(string(s3.s34));
    sortedSpecialElementsJTrue.year = convertStringsToChars(string(s3.s33));

    %------------------------------------------------------------------------------------------------------------
    %[setOfUniqueSetPlayerIDs, ~, setOfUniqueSetPlayerIDIndexes] = unique(allNonSpecialElements.setPlayerID, 'first'); 
    
    january =   strcat('January-',yearOfDataToCapture);
    february =  strcat('February-',yearOfDataToCapture);
    march =     strcat('March-',yearOfDataToCapture);
    april =     strcat('April-',yearOfDataToCapture); 
    may =       strcat('May-',yearOfDataToCapture); 
    june =      strcat('June-',yearOfDataToCapture); 
    july =      strcat('July-',yearOfDataToCapture); 
    august =    strcat('August-',yearOfDataToCapture); 
    september = strcat('September-',yearOfDataToCapture); 
    october =   strcat('October-',yearOfDataToCapture); 
    november =  strcat('November-',yearOfDataToCapture);
    december =  strcat('December-',yearOfDataToCapture);
    
    
    
    % Get all Unique Set of Player-Set Ids for ALL YEARS to iterate through
    [setOfUniqueSetPlayerIDs, ~, setOfUniqueSetPlayerIDIndexes] = unique(currentNBATSMD.setPlayerID, 'first'); 
    % Get all Unique Set of Player-Set Ids for the year to iterate through
    %[setOfUniqueSetPlayerIDs, ~, setOfUniqueSetPlayerIDIndexes] = unique(allElementsYear.setPlayerID, 'first'); 
    
    %------------------------------------------------------------------------------------------------------------
    %------------------Reformatting The Raw Non Special Average Data (NON SPECIAL) ------------------------------


    %create a new empty table structure with variables (populates empty first and fills in for loops
    finalNonSpecialTable = table("playerid",string(yearOfDataToCapture),0,0,0,0,0,0,0,0,0,0,0,0);  
    finalNonSpecialTable.Properties.VariableNames = {'Non Special Cards' 'Year' 'January' 'February' 'March' 'April' 'May' 'June' 'July' 'August' 'September' 'October' 'November' 'December'};
    finalNonSpecialTable(1,:) = [];

    %set-PLayer ID x aggregated data x 12 
    %for every unique ID
    for id = 1:size(setOfUniqueSetPlayerIDs,1)

        currentSetPlayerID =  setOfUniqueSetPlayerIDs(id);
        updatedIDWithZeros = {currentSetPlayerID,string(yearOfDataToCapture),0,0,0,0,0,0,0,0,0,0,0,0};
        finalNonSpecialTable = [finalNonSpecialTable;updatedIDWithZeros];

         %for every item in sorted non special table
         for row = 1:size(sortedNonSpecialAvgData,1)
             tempSetPlayerID = sortedNonSpecialAvgData.setPlayerID(row,:); 

            %if id matches the one were looking at
            if string(tempSetPlayerID) == string(currentSetPlayerID)

                   % Fill in the value

                   if string(sortedNonSpecialAvgData.month(row,:)) == "1"
                       finalNonSpecialTable.January(id) = sortedNonSpecialAvgData.Average(row,:);
                   end   

                   if string(sortedNonSpecialAvgData.month(row,:)) == "2"
                       finalNonSpecialTable.February(id) = sortedNonSpecialAvgData.Average(row,:);   
                   end

                   if string(sortedNonSpecialAvgData.month(row,:)) == "3"
                       finalNonSpecialTable.March(id) = sortedNonSpecialAvgData.Average(row,:);   
                   end

                   if string(sortedNonSpecialAvgData.month(row,:)) == "4"
                       finalNonSpecialTable.April(id) = sortedNonSpecialAvgData.Average(row,:);   
                   end

                   if string(sortedNonSpecialAvgData.month(row,:)) == "5"
                       finalNonSpecialTable.May(id) = sortedNonSpecialAvgData.Average(row,:);   
                   end

                   if string(sortedNonSpecialAvgData.month(row,:)) == "6"
                       finalNonSpecialTable.June(id) = sortedNonSpecialAvgData.Average(row,:);   
                   end

                   if string(sortedNonSpecialAvgData.month(row,:)) == "7"
                       finalNonSpecialTable.July(id) = sortedNonSpecialAvgData.Average(row,:);   
                   end

                   if string(sortedNonSpecialAvgData.month(row,:)) == "8"
                      finalNonSpecialTable.August(id) = sortedNonSpecialAvgData.Average(row,:);                  
                   end

                   if string(sortedNonSpecialAvgData.month(row,:)) == "9"
                      finalNonSpecialTable.September(id) = sortedNonSpecialAvgData.Average(row,:);                  
                   end

                   if string(sortedNonSpecialAvgData.month(row,:)) == "10"
                       finalNonSpecialTable.October(id) = sortedNonSpecialAvgData.Average(row,:);                  
                   end

                   if string(sortedNonSpecialAvgData.month(row,:)) == "11"
                      finalNonSpecialTable.November(id) = sortedNonSpecialAvgData.Average(row,:);                  
                   end

                   if string(sortedNonSpecialAvgData.month(row,:)) == "12"
                       finalNonSpecialTable.December(id) = sortedNonSpecialAvgData.Average(row,:);                  
                   end

            end %end big if

         end %end for  

    end %end for

    %------------------------------------------------------------------------------------------------------------------------
    %-----------------------------Reformatting The Raw Special Average Data (S == 1) ----------------------------------------

    finalSpecialTableS1 = table("playerid",string(yearOfDataToCapture),0,0,0,0,0,0,0,0,0,0,0,0);
    finalSpecialTableS1.Properties.VariableNames = {'Serial = 1' 'Year' 'January' 'February' 'March' 'April' 'May' 'June' 'July' 'August' 'September' 'October' 'November' 'December'};
    finalSpecialTableS1(1,:) = [];

    for id = 1:size(setOfUniqueSetPlayerIDs,1)

        currentSetPlayerID =  setOfUniqueSetPlayerIDs(id);
        updatedIDWithZeros2 = {currentSetPlayerID,string(yearOfDataToCapture),0,0,0,0,0,0,0,0,0,0,0,0};
        finalSpecialTableS1 = [finalSpecialTableS1;updatedIDWithZeros2];

         %for every item in sorted non special table
         for row = 1:size(sortedSpecialElementsS1,1)
             tempSetPlayerID = sortedSpecialElementsS1.setPlayerID(row,:); 

            %if id matches the one were looking at
            if string(tempSetPlayerID) == string(currentSetPlayerID)

                   % Fill in the value

                   if string(sortedSpecialElementsS1.month(row,:)) == "1"
                       finalSpecialTableS1.January(id) = sortedSpecialElementsS1.Average(row,:);
                   end   

                   if string(sortedSpecialElementsS1.month(row,:)) == "2"
                       finalSpecialTableS1.February(id) = sortedSpecialElementsS1.Average(row,:);   
                   end

                   if string(sortedSpecialElementsS1.month(row,:)) == "3"
                       finalSpecialTableS1.March(id) = sortedSpecialElementsS1.Average(row,:);   
                   end

                   if string(sortedSpecialElementsS1.month(row,:)) == "4"
                       finalSpecialTableS1.April(id) = sortedSpecialElementsS1.Average(row,:);   
                   end

                   if string(sortedSpecialElementsS1.month(row,:)) == "5"
                       finalSpecialTableS1.May(id) = sortedSpecialElementsS1.Average(row,:);   
                   end

                   if string(sortedSpecialElementsS1.month(row,:)) == "6"
                       finalSpecialTableS1.June(id) = sortedSpecialElementsS1.Average(row,:);   
                   end

                   if string(sortedSpecialElementsS1.month(row,:)) == "7"
                       finalSpecialTableS1.July(id) = sortedSpecialElementsS1.Average(row,:);   
                   end

                   if string(sortedSpecialElementsS1.month(row,:)) == "8"
                      finalSpecialTableS1.August(id) = sortedSpecialElementsS1.Average(row,:);                  
                   end

                   if string(sortedSpecialElementsS1.month(row,:)) == "9"
                      finalSpecialTableS1.September(id) = sortedSpecialElementsS1.Average(row,:);                  
                   end

                   if string(sortedSpecialElementsS1.month(row,:)) == "10"
                       finalSpecialTableS1.October(id) = sortedSpecialElementsS1.Average(row,:);                  
                   end

                   if string(sortedSpecialElementsS1.month(row,:)) == "11"
                      finalSpecialTableS1.November(id) = sortedSpecialElementsS1.Average(row,:);                  
                   end

                   if string(sortedSpecialElementsS1.month(row,:)) == "12"
                       finalSpecialTableS1.December(id) = sortedSpecialElementsS1.Average(row,:);                  
                   end

            end %end big if

         end %end for  

    end %end for


    %-------------------------------------------------------------------------------------------------------------------------
    %-----------------------------Reformatting The Raw Special Average Data (Jersey = True) ----------------------------------

    finalSpecialTableJTrue = table("playerid",string(yearOfDataToCapture),0,0,0,0,0,0,0,0,0,0,0,0);
    finalSpecialTableJTrue.Properties.VariableNames = {'Jersey = True' 'Year' 'January' 'February' 'March' 'April' 'May' 'June' 'July' 'August' 'September' 'October' 'November' 'December'};
    finalSpecialTableJTrue(1,:) = [];

    for id = 1:size(setOfUniqueSetPlayerIDs,1)

        currentSetPlayerID =  setOfUniqueSetPlayerIDs(id);
        updatedIDWithZeros3 = {currentSetPlayerID,string(yearOfDataToCapture),0,0,0,0,0,0,0,0,0,0,0,0};
        finalSpecialTableJTrue = [finalSpecialTableJTrue;updatedIDWithZeros3];

         %for every item in sorted non special table
         for row = 1:size(sortedSpecialElementsJTrue,1)
             tempSetPlayerID = sortedSpecialElementsJTrue.setPlayerID(row,:); 

            %if id matches the one were looking at
            if string(tempSetPlayerID) == string(currentSetPlayerID)

                   % Fill in the value

                   if string(sortedSpecialElementsJTrue.month(row,:)) == "1"
                      finalSpecialTableJTrue.January(id) = sortedSpecialElementsJTrue.Average(row,:);
                   end   

                   if string(sortedSpecialElementsJTrue.month(row,:)) == "2"
                      finalSpecialTableJTrue.February(id) = sortedSpecialElementsJTrue.Average(row,:);   
                   end

                   if string(sortedSpecialElementsJTrue.month(row,:)) == "3"
                      finalSpecialTableJTrue.March(id) = sortedSpecialElementsJTrue.Average(row,:);   
                   end

                   if string(sortedSpecialElementsJTrue.month(row,:)) == "4"
                      finalSpecialTableJTrue.April(id) = sortedSpecialElementsJTrue.Average(row,:);   
                   end

                   if string(sortedSpecialElementsJTrue.month(row,:)) == "5"
                      finalSpecialTableJTrue.May(id) = sortedSpecialElementsJTrue.Average(row,:);   
                   end

                   if string(sortedSpecialElementsJTrue.month(row,:)) == "6"
                      finalSpecialTableJTrue.June(id) = sortedSpecialElementsJTrue.Average(row,:);   
                   end

                   if string(sortedSpecialElementsJTrue.month(row,:)) == "7"
                      finalSpecialTableJTrue.July(id) = sortedSpecialElementsJTrue.Average(row,:);   
                   end

                   if string(sortedSpecialElementsJTrue.month(row,:)) == "8"
                      finalSpecialTableJTrue.August(id) = sortedSpecialElementsJTrue.Average(row,:);                  
                   end

                   if string(sortedSpecialElementsJTrue.month(row,:)) == "9"
                      finalSpecialTableJTrue.September(id) = sortedSpecialElementsJTrue.Average(row,:);                  
                   end

                   if string(sortedSpecialElementsJTrue.month(row,:)) == "10"
                      finalSpecialTableJTrue.October(id) = sortedSpecialElementsJTrue.Average(row,:);                  
                   end

                   if string(sortedSpecialElementsJTrue.month(row,:)) == "11"
                      finalSpecialTableJTrue.November(id) = sortedSpecialElementsJTrue.Average(row,:);                  
                   end

                   if string(sortedSpecialElementsJTrue.month(row,:)) == "12"
                      finalSpecialTableJTrue.December(id) = sortedSpecialElementsJTrue.Average(row,:);                  
                   end

            end %end big if

         end %end for  

    end %end for

    %----------------------------------------------------------------------------------------------------------------------
    
    %change variable names to include year for next script
    finalNonSpecialTable.Properties.VariableNames = {'Non Special Cards','Year',january,february,march,april,may,june,july,august,september,october,november,december};
    finalSpecialTableS1.Properties.VariableNames = {'Serial = 1', 'Year', january ,february, march, april ,may ,june ,july,august, september, october, november, december };
    finalSpecialTableJTrue.Properties.VariableNames = {'Jersey = Serial = True', 'Year', january ,february, march, april ,may ,june ,july,august, september, october, november, december };

    nonSpecialCards = finalNonSpecialTable;
    specialS1 = finalSpecialTableS1;
    specialJTrue = finalSpecialTableJTrue;
    
    
    
end


% writetable(finalNonSpecialTable,append('CardMonthlyPrices-',yearOfDataToCapture,'.xlsx'),'Sheet',1);
% writetable(finalSpecialTableS1,append('CardMonthlyPrices-',yearOfDataToCapture,'.xlsx'),'Sheet',2);
% writetable(finalSpecialTableJTrue,append('CardMonthlyPrices-',yearOfDataToCapture,'.xlsx'),'Sheet',3);

%
