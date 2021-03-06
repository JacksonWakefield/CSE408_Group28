% function to create a vocabulary from multiple text files under folders

function voc = buildVoc(folder, voc, finvoc)

stopword = {'ourselves', 'hers', 'between', 'yourself', 'but', 'again', 'there', ...
    'about', 'once', 'during', 'out', 'very', 'having', 'with', 'they', 'own', ...
    'an', 'be', 'some', 'for', 'do', 'its', 'yours', 'such', 'into', ...
    'of', 'most', 'itself', 'other', 'off', 'is', 's', 'am', 'or', ...
    'who', 'as', 'from', 'him', 'each', 'the', 'themselves', 'until', ...
    'below', 'are', 'we', 'these', 'your', 'his', 'through', 'don', 'nor', ...
    'me', 'were', 'her', 'more', 'himself', 'this', 'down', 'should', 'our', ...
    'their', 'while', 'above', 'both', 'up', 'to', 'ours', 'had', 'she', 'all', ...
    'no', 'when', 'at', 'any', 'before', 'them', 'same', 'and', 'been', 'have', ...
    'in', 'will', 'on', 'does', 'yourselves', 'then', 'that', 'because', ...
    'what', 'over', 'why', 'so', 'can', 'did', 'not', 'now', 'under', 'he', ...
    'you', 'herself', 'has', 'just', 'where', 'too', 'only', 'myself', ...
    'which', 'those', 'i', 'after', 'few', 'whom', 'being', 'if', ...
    'theirs', 'my', 'against', 'a', 'by', 'doing', 'it', 'how','the ', ...
    'further', 'was','here', 'than '}; % define English stop words, from NLTK

% Input data under ./Data/kNN/training and ./Data/kNN/testing

files = dir(fullfile(folder, '*.txt' ));

words_unique = [];
word_array = [];


for file = files'
    [fid, msg] = fopen(fullfile(folder,file.name),  'rt' );
    error(msg);
    line = fgets(fid); % Get the first line from
     % the file.
     
    while line ~= -1
        %PUT YOUR IMPLEMENTATION HERE
        words_line = [];
        
        %some extra stuff to get rid of
        punct = [ "." ,  "," ,  ")" ,  "(" ,  "!" ,  "?",  '"' , "'", ":", ";", "'", "%", "&", "/", "*", "=", "`", "+"];
        nums = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]; %there must be a better way to do this ):
        
        %try statement just in case for debugging
        try
            
            %This block just messes with each individual line to make sure
            %we get just words
            line = erase(line, punct);
        
            line = erase(line, nums);
            line = replace(line, "-", " "); %special case, i.e. state-of-the-art should not result in stateoftheart
            line = replace(line, "_", " "); %special case, i.e. state_of_the_art should not result in stateoftheart
            line = lower(line);
            
            line = replace(line, " ", "  ");

            words_line = split(line);
            %words_line = unique(words_line);
            
            
        catch ME %catch - any problems with the try and we see which line and where it is (and what error)
           disp(line);
           disp(file);
           disp(ME);
        end
        
        %This adds all the words from each line to the voc (excluding
        %stopwords and 1 letter words)
        for i=1:length(words_line)
            if ~ismember(words_line{i}, stopword) && length(words_line{i}) > 1
                voc{end+1} = words_line{i};
            end
        end
        
        %loop to next line
        line = fgets(fid);
    end
    fclose(fid);
    
    if finvoc
        n = 8; % count threshold -- here you can try 1, 2, 3, etc.
        
        %PUT YOUR IMPLEMENTATION HERE
        % this code is just to make your computation faster
        % Include code to drop words with low count, and make the voc an array
        % of unique words (use function "unique")
        % the first time you call buildvoc is with voc as an empty cell array
        % The second time you call it with voc from the first call:
        % voc = [];
        % voc = buildVoc( ' **path to neg data dir** ' , voc, 0)
        % voc = buildVoc( ' **path to pos data dir** ' , voc, 1)
        % notice the argument finvoc, is 0 the first time around,
        % 1 the second time to finish voc: make it unique and remove low count
        % words.
        
        %This all adds each file's words to the voc, excluding low
        %count (<=n)
        words_unique = unique(voc);
        words_unique = words_unique(2:end);
        words_unique_count = zeros(length(words_unique), 1);
        
        %get word count for comparison on n
        for i = 1:length(voc)
            index = find(strcmp(words_unique, voc{i}));
            words_unique_count(index) = words_unique_count(index) + 1;
        end
        
        %look through and add all to word_array which are >= to n
        for i = 1:length(words_unique)
           if words_unique_count(i) >= n
               word_array{end+1} = words_unique{i};
           end
        end
        %This runs on every file, so as word_array is global, it will end
        %up being the previous word_array concatenated with the new file 
        %word_array. As such, we need to get rid of all the newly added
        %words that are duplicated from previous files
        word_array = unique(word_array);
        
        voc = word_array;
    end
end


