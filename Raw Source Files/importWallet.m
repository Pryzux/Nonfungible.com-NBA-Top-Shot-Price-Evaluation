function wallet = importWallet(filename, dataLines)
%IMPORTFILE Import data from a text file
%  WALLET = IMPORTDATA(FILENAME) reads data from text file
%  FILENAME for the default selection.  Returns the data as a table.
%
%  WALLET = IMPORTDATA(FILE, DATALINES) reads data for the
%  specified row interval(s) of text file FILENAME. Specify DATALINES as
%  a positive scalar integer or a N-by-2 array of positive scalar
%  integers for dis-contiguous row intervals.
%
%  Example:
%  whalevaulttopshots = importData("PATH", [2, Inf]);
%
%  See also READTABLE.


%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 16);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["id", "owner", "set_id", "set_name", "play_id", "play_serial", "play_count", "play_player_id", "play_player_name", "play_player_jersey_number", "play_player_primary_position", "play_team_id", "play_team_name", "play_date", "play_category", "play_is_jersey"];
opts.VariableTypes = ["string", "double", "categorical", "categorical", "string", "double", "double", "double", "categorical", "double", "categorical", "double", "categorical", "categorical", "categorical", "categorical"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";

% Specify variable properties
opts = setvaropts(opts, ["id", "play_id"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["id", "set_id", "set_name", "play_id", "play_player_name", "play_player_primary_position", "play_team_name", "play_date", "play_category", "play_is_jersey"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "owner", "TrimNonNumeric", true);
opts = setvaropts(opts, "owner", "ThousandsSeparator", ",");

% Import the data
wallet = readtable(filename, opts);

end