function [vstack qstack istack qids] = set_limit()
global buscon linecon pqcon swcon syncon pvcon

vstack = [];
qstack = [];
istack = [];
if length(swcon(:,1))>=1 
  vstack = [vstack;[swcon(:,1) swcon(:,8) swcon(:,9)]];
  qstack = [qstack;[swcon(:,1) swcon(:,6) swcon(:,7)]];
end
if length(pvcon(:,1))>=1 
  vstack = [vstack;[pvcon(:,1) pvcon(:,8) pvcon(:,9)]];
  qstack = [qstack;[pvcon(:,1) pvcon(:,6) pvcon(:,7)]];
end
if length(pqcon(:,1))>=1
  vstack = [vstack;[pqcon(:,1) pqcon(:,6) pqcon(:,7)]];
end
if length(linecon(:,1))>=1
  istack = [istack;linecon(:,13)];
end

if ~isempty(setdiff(buscon(:,1),vstack(:,1)))
    addids = setdiff(buscon(:,1),vstack(:,1));
    for i = 1:length(addids)
        vstack = [vstack;[addids(i) Inf -Inf]];
    end
end

vstack = sortrows(vstack,1);
qstack = sortrows(qstack,1);

qids = [];

for jq = 1:length(buscon(:,1))
  if ~isempty(find(syncon(:,1) == buscon(jq,1)))
      qids = [qids;jq];
  end
end