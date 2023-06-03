function data = importData(filename, dataLines)
%IMPORTFILE Import data from a text file
%  DATA = IMPORTFILE(FILENAME) reads data from text file
%  FILENAME for the default selection.  Returns the data as a table.
%
%  DATA = IMPORTFILE(FILE, DATALINES) reads data for the
%  specified row interval(s) of text file FILENAME. Specify DATALINES as
%  a positive scalar integer or a N-by-2 array of positive scalar
%  integers for dis-contiguous row intervals.
%
%  Example:
%  data = importfile(PATH, [2, Inf]);
%
%  See also READTABLE.

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 22);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["buyer", "buyerDapperId", "seller", "sellerDapperId", "usdPrice", "transactionHash", "blockTimestamp", "assetId", "metaset_id", "metaset_name", "metaplay_id", "metaplay_serial", "metaplay_count", "metaplay_player_id", "metaplay_player_name", "metaplay_player_jersey_number", "metaplay_player_primary_position", "metaplay_team_id", "metaplay_team_name", "metaplay_date", "metaplay_category", "metaplay_is_jersey"];
opts.VariableTypes = ["categorical", "categorical", "categorical", "categorical", "double", "string", "datetime", "string", "categorical", "categorical", "categorical", "double", "double", "double", "categorical", "double", "categorical", "double", "double", "categorical", "categorical", "categorical"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";

% Specify variable properties
opts = setvaropts(opts, ["transactionHash", "assetId"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["buyer", "buyerDapperId", "seller", "sellerDapperId", "transactionHash", "assetId", "metaset_id", "metaset_name", "metaplay_id", "metaplay_player_name", "metaplay_player_primary_position", "metaplay_date", "metaplay_category", "metaplay_is_jersey"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "blockTimestamp", "InputFormat", "eee MMM dd u HH:mm:ss 'GMT+0000 (Coordinated Universal Time)'");
opts = setvaropts(opts, "metaplay_team_name", "TrimNonNumeric", true);
opts = setvaropts(opts, "metaplay_team_name", "ThousandsSeparator", ",");

% Import the data
data = readtable(filename, opts);

end