% function to create a vocabulary from multiple text files under folders

function voc = buildVoc(folder, voc, finvoc)

stopword = { ' ourselves ' ,  ' hers ' ,  ' between ' ,  ' yourself ' ,  ' but ' ,  ' again ' ,  ' there ' , ...
     ' about ' ,  ' once ' ,  ' during ' ,  ' out ' ,  ' very ' ,  ' having ' ,  ' with ' ,  ' they ' ,  ' own ' , ...
     ' an ' ,  ' be ' ,  ' some ' ,  ' for ' ,  ' do ' ,  ' its ' ,  ' yours ' ,  ' such ' ,  ' into ' , ...
     ' of ' ,  ' most ' ,  ' itself ' ,  ' other ' ,  ' off ' ,  ' is ' ,  ' s ' ,  ' am ' ,  ' or ' , ...
     ' who ' ,  ' as ' ,  ' from ' ,  ' him ' ,  ' each ' ,  ' the ' ,  ' themselves ' ,  ' until ' , ...
     ' below ' ,  ' are ' ,  ' we ' ,  ' these ' ,  ' your ' ,  ' his ' ,  ' through ' ,  ' don ' ,  ' nor ' , ...
     ' me ' ,  ' were ' ,  ' her ' ,  ' more ' ,  ' himself ' ,  ' this ' ,  ' down ' ,  ' should ' ,  ' our ' , ...
     ' their ' ,  ' while ' ,  ' above ' ,  ' both ' ,  ' up ' ,  ' to ' ,  ' ours ' ,  ' had ' ,  ' she ' ,  ' all ' , ...
     ' no ' ,  ' when ' ,  ' at ' ,  ' any ' ,  ' before ' ,  ' them ' ,  ' same ' ,  ' and ' ,  ' been ' ,  ' have ' , ...
     ' in ' ,  ' will ' ,  ' on ' ,  ' does ' ,  ' yourselves ' ,  ' then ' ,  ' that ' ,  ' because ' , ...
     ' what ' ,  ' over ' ,  ' why ' ,  ' so ' ,  ' can ' ,  ' did ' ,  ' not ' ,  ' now ' ,  ' under ' ,  ' he ' , ...
     ' you ' ,  ' herself ' ,  ' has ' ,  ' just ' ,  ' where ' ,  ' too ' ,  ' only ' ,  ' myself ' , ...
     ' which ' ,  ' those ' ,  ' i ' ,  ' after ' ,  ' few ' ,  ' whom ' ,  ' t ' ,  ' being ' ,  ' if ' , ...
     ' theirs ' ,  ' my ' ,  ' against ' ,  ' a ' ,  ' by ' ,  ' doing ' ,  ' it ' ,  ' how ' , ' the ', ...
     ' further ' ,  ' was ' , ' here ' ,  ' than '}; % define English stop words, from NLTK

% Input data under ./Data/kNN/training and ./Data/kNN/testing

files = dir(fullfile(folder, '*.txt' ));

words_all = [];
words_unique = [];
word_array = [];


for file = files'
    [fid, msg] = fopen(fullfile(folder,file.name),  'rt' );
    error(msg);
    line = fgets(fid); % Get the first line from
     % the file.
     
    words = [];
     
    while line ~= -1
        %PUT YOUR IMPLEMENTATION HERE
        words_line = [];
        
        punct = [ "." ,  "," ,  ")" ,  "(" ,  "!" ,  "?",  ' " ' , " ' ", ":", ";", "'", "%" ];
        nums = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]; %there must be a better way to do this ):
        
        try
            line = erase(line, punct);
        
            line = erase(line, nums);
            line = replace(line, "-", " "); %special case, i.e. state-of-the-art should not result in stateoftheart
            line = lower(line);
            
            line = replace(line, " ", "  ");
            line = erase(line, stopword);

            words_line = split(line);
            words_line = unique(words_line);
        catch ME
           disp(line);
           disp(file);
           disp(ME);
        end
        
        for i=1:length(words_line)
            words{end+1} = words_line{i};
            words_all{end+1} = words_line{i};
        end
        
        
        line = fgets(fid);
    end
    fclose(fid);
    
    if ~finvoc
        n = 3; % count threshold -- here you can try 1, 2, 3, etc.
        
        %PUT YOUR IMPLEMENTATION HERE
        % this code is just to make your computation faster
        % Include code to drop words with low count, and make the voc an array
        % of unique words (use function "unique")
        % the first time you call buildvoc is with voc as and empty cell array
        % The second time you call it with voc from the first call:
        % voc = [];
        % voc = buildVoc( ' **path to neg data dir** ' , voc, 0)
        % voc = buildVoc( ' **path to pos data dir** ' , voc, 1)
        % notice the argument finvoc, is 0 the first time around,
        % 1 the second time to finish voc: make it unique and remove low count
        % words.
        
        %for each array
            %for each word
                %add word/count to array and word count array
        %for each word in word count array
            %if wordcount{i} > n, add wordcountarray{i} to master list
        
        words_unique = unique(words);
        words_unique = words_unique(2:end);
        words_unique_count = zeros(length(words_unique), 1);
        
        for i = 1:length(words)
            index = find(strcmp(words_unique, words{i}));
            
            words_unique_count(index) = words_unique_count(index) + 1;
        end
        
        for i = 1:length(words_unique)
           if words_unique_count(i) >= n
               word_array{end+1} = words_unique{i};
           end
        end
        
        word_array = unique(word_array);
    end
end

voc = word_array;
