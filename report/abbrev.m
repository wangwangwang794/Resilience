function a = abbrev(b)

switch b
    case 'line'
        a = 'L';
    case 'bus'
        a = 'B';
    case 'gen'
        a = 'G';
    case 'trafo'
        a = 'T';
end