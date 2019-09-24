clear
clc

global event

global Line time R X

load('eventlist_ps1')

for i = 1:length(event)
    event{i}.syn(:,19) = 45;
end
% for i = 2:2
for i = 2:length(event)
    i = i    
    fprintf(event{i}.faulttype)
    get_RM(i)
end