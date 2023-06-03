disp('NBA Topshot Exectuable Evaluation by www.NonFungible.com | Version 1.0');
disp('*PLEASE MAKE SURE YOU SELECT THE CORRECT FILES IN THE CORRECT ORDER*');
disp('Select the WALLET to Evaluate:');

[file,path] = uigetfile('*.csv');
walletPath = fullfile(path,file);

if isequal(file,0)
   disp('User selected Cancel. Please Exit and Restart The Program.');
   return;
else
   disp(['User selected ', walletPath]);
end

disp('Select the MARKET DATA to Evaluate:');

[file,path] = uigetfile('*.csv');
dataPath = fullfile(path,file);

if isequal(file,0)
   disp('User selected Cancel. Please Exit and Restart The Program.');
   return;
else
   disp(['User selected ', dataPath]);
end

tic;

disp('Importing Wallet Data..');
wallet = importWallet(walletPath, [2, Inf]);

disp('Importing Market Data..');
data = importData(dataPath, [2, Inf]);

disp('Data Succesfully Imported.');

allDataEval(data,wallet);

toc
