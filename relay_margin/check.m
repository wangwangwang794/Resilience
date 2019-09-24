function check(ps,type,varargin)

clc

switch ps
    case 1
        load('U:\Uploaded_data\PHD\Research\Resilience of PS\MATLAB Codes\Sensitivity\Conlist_23rd Sep\test_1.mat')
    case 2
        load('U:\Uploaded_data\PHD\Research\Resilience of PS\MATLAB Codes\Sensitivity\Conlist_23rd Sep\test_2.mat')
    case 3
        load('U:\Uploaded_data\PHD\Research\Resilience of PS\MATLAB Codes\Sensitivity\Conlist_23rd Sep\test_3.mat')
end


switch nargin
    case 3
        for i = 2:length(event)
            if strcmp(event{i}.faulttype,'line')
                if all(event{i}.faultcomp == varargin{1}) && (event{i}.level == 1)
                    fprintf('Relay margin:\n')
                    disp(num2str(event{i}.RM))
                    break
                end
            end
        end            
    case 4
        for i = 2:length(event)
            if strcmp(event{i}.faulttype,'line')
                if event{i}.level == 2
                    if all(event{event{i}.base}.faultcomp == varargin{1}) && strcmp(event{event{i}.base}.faulttype,type)
                        if all(event{i}.faultcomp == varargin{2})
                            fprintf('Relay margin:\n')
                            disp(num2str(event{i}.RM))
                            i
                        end
                    end
                end
            end
        end 
end
