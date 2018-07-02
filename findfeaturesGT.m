function [out] = findfeaturesGT(ingresso,fs)

suono             = double(ingresso);
fsnew             = 8000;
[normalized,slot] = findvoice(suono,fs,fsnew);
C = [];
L = size(slot,1);
for ii=1:L
    if slot(ii,2)-slot(ii,1)>=128
        s = normalized(slot(ii,1):slot(ii,2));
        c = gtcepst(s,fsnew,[],40);
        C = [C;c];
       
    end
end
out = C;