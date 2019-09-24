function [varargout] = cellTSMCCTLSM(varargin)

optionals = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
numInputs = nargin;
inputVar = 1;

while numInputs > 0
    if ~isempty(varargin{inputVar})
        optionals{inputVar} = varargin{inputVar};
    end
    inputVar = inputVar + 1;
    numInputs = numInputs - 1;
end

for i = 1:nargin    
    varargout{i} = val_translate(optionals{i});
end