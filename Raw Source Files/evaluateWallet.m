function [nonSpecialPriceWallet, specialS1_Wallet, specialJTrue_Wallet] = evaluateWallet(finalPriceTableS1,finalPriceTableJtrue,finalNonSpecialPriceTable,wallet);

    %------assign non special price to all wallet assets----------
    %-------------------------------------------------------------
    
    tempWallet = wallet;
    %add code for identification
    tempWallet.setPlayerID = (strcat(string(wallet.set_id),',',string(wallet.play_player_id))); 
    %sort      
    tempWallet = sortrows(tempWallet,{'setPlayerID'});
    %remove dumb columns
    tempWallet = removevars(tempWallet,{'id' 'play_id' 'play_date' 'owner' 'play_team_id' 'play_player_primary_position'});
    
    walletWithPrices = table; 
    
    %for each asset in wallet
    for x = 1:size(tempWallet,1)    
        
        assetID =  tempWallet.setPlayerID(x);
        fullAsset = tempWallet(x,:);
        
        %for each item in the non special price table
         for i = 1:size(finalNonSpecialPriceTable,1) 
             tablePrice = finalNonSpecialPriceTable.NonSpecialFinalPrices(i);
             tableID = finalNonSpecialPriceTable.PlayerSetID(i);            
             %if we found the asset, concat price
             if tableID == assetID      
               fullAsset.evaluatedPrice = tablePrice;
               walletWithPrices = [ walletWithPrices; fullAsset ];
               break;                 
             end %end if
             
         end

    end
    
    walletWithPrices = movevars(walletWithPrices,{'set_id','play_player_id','set_name','play_player_name','play_serial','play_count'},'Before','evaluatedPrice');
    walletWithPrices = movevars(walletWithPrices,{'play_team_name','play_category','play_player_jersey_number','play_is_jersey'},'After','evaluatedPrice');
   
    
    %-------------------Non Special Wallet Evaluation----------------------
    %----------------------------------------------------------------------
    
    nonSpecialPriceWallet = walletWithPrices(walletWithPrices.play_is_jersey == {'false'} & walletWithPrices.play_serial > 1 , :);
    
    %-------------------Serial == 1 Wallet Evaluation----------------------
    %----------------------------------------------------------------------
    
    specialS1_Wallet =  walletWithPrices(walletWithPrices.play_serial == 1, :);
    
    %for each asset in s1
    for i = 1:size(specialS1_Wallet,1)        
        fullAsset = specialS1_Wallet(i,:);       
        %for each range
        for x = 1:size(finalPriceTableS1,1)                        
            %if price falls within price range, multiply value by ratio
            if  (fullAsset.evaluatedPrice <=  finalPriceTableS1.RangeHigh(x)) & (fullAsset.evaluatedPrice >=  finalPriceTableS1.RangeLow(x))
                %if ratio is nan then don't update and keep average price
                 if isnan(finalPriceTableS1{x,3})
                     break;
                 else
                     %calculation [nonspecialprice * factor]
                     specialS1_Wallet(i,:).evaluatedPrice = fullAsset.evaluatedPrice * finalPriceTableS1{x,3};
                     break;
                 end
            end %end if
               
        end %for
          
    end %for
    
    specialS1_Wallet;
    

    %-------------------JTrue Wallet Evaluation----------------------------
    %----------------------------------------------------------------------
    
    specialJTrue_Wallet =  walletWithPrices(walletWithPrices.play_is_jersey == {'true'}, :);
    
    %for each asset in s1
    for i = 1:size(specialJTrue_Wallet,1)        
        fullAsset = specialJTrue_Wallet(i,:);       
        %for each range
        for x = 1:size(finalPriceTableJtrue,1)                        
            %if price falls within price range, multiply value by ratio
            if  (fullAsset.evaluatedPrice <=  finalPriceTableJtrue.RangeHigh(x)) & (fullAsset.evaluatedPrice >=  finalPriceTableJtrue.RangeLow(x))
                %if ratio is nan then don't update and keep average price
                 if isnan(finalPriceTableJtrue{x,3})
                     break;
                 else
                     %calculation [nonspecialprice * factor]
                     specialJTrue_Wallet(i,:).evaluatedPrice = fullAsset.evaluatedPrice * finalPriceTableJtrue{x,3};
                     break;
                 end
            end %end if
               
        end %for
          
    end %for
    
    specialJTrue_Wallet;
    


end