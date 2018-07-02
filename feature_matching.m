function [out] = feature_matching(features)
load('speaker_database.dat','-mat');
% features_data{features_size+1,1} = features;
% features_data{features_size+1,2} = class_number;
% features_data{features_size+1,3} = strcat(pathname,namefile);
% features_size = size(features_data,1);
% max_class (classi presenti + 1)

P = [];
T = [];
L = features_size;
for ii=1:L
    C = features_data{ii,1};
    [dimx,dimy] = size(C);
    P = [P C'];
    t   = zeros(max_class-1,dimx);
    pos =  features_data{ii,2};
    for jj=1:(max_class-1)
        if jj==pos
            t(jj,:) = 1;
        else
            t(jj,:) = -1;
        end
    end
    T = [T t];
end

input_vector = features';
%Normalization
for ii=1:size(P,1)
    v = P(ii,:);
    v = v(:);
    bii = max([v;1]);
    aii = min([v;-1]);
    P(ii,:) = 2*(P(ii,:)-aii)/(bii-aii)-1;
    input_vector(ii,:) = 2*(input_vector(ii,:)-aii)/(bii-aii)-1;
end
[net]       = createnn(P,T);
risultato   = sim(net,input_vector);
[dimx,dimy] = size(risultato);
vettore     = zeros(dimy,1);
for jj=1:dimy
    c            = risultato(:,jj);
    [val,pos]    = max(c);
    vettore(pos) = vettore(pos)+1;
end
[val,pos] = max(vettore);
out       = pos;