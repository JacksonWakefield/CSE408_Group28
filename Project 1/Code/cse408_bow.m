% function to create a vocabulary from multiple text files under folders

function feat_vec = cse408_bow(filepath, voc)



[fid, msg] = fopen(filepath, 'rt');
error(msg);
line = fgets(fid); % Get the first line from
 % the file.
feat_vec = zeros(size(voc)); %Initialize the feature vector'

while line ~= -1
    
    punct = [ "." ,  "," ,  ")" ,  "(" ,  "!" ,  "?",  '"' , "'", ":", ";", "'", "%", "&", "/", "*", "=", "`", "+"];
    nums = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]; %there must be a better way to do this ):
    
    %This block just messes with each individual line to make sure
    %we get just words
    line = erase(line, punct);

    line = erase(line, nums);
    line = replace(line, "-", " "); %special case, i.e. state-of-the-art should not result in stateoftheart
    line = replace(line, "_", " "); %special case, i.e. state_of_the_art should not result in stateoftheart
    line = lower(line);

    line = replace(line, " ", "  ");

    words_line = split(line);
    
    for i = 1:length(words_line)
        for j = 1:length(voc)
           if strcmp(words_line{i}, voc{j})
              feat_vec(j) = feat_vec(j) + 1;
           end
        end
    end
    
    line = fgets(fid);
end
fclose(fid);