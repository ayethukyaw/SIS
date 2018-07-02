function [normalized,slot]=findvoice(suono,fs,fsnew)
% Input--------------------------------------------------------------------
% suono:      input sound (loaded by wavread)
% fs:         input sampling frequency
% fsnew:      output sampling frequency
% Output-------------------------------------------------------------------
% normalized: normalized sound
% slot:       slot(ii,1) start of sound sequence (the i-th one) of interest
%             slot(ii,2) end of sound sequence (the i-th one) of interest
% -------------------------------------------------------------------------
% Input sound is resampled to fsnew and DC component is removed.
% Example:
% fsnew             = 8000;
% [suono,fs]        = wavread('mysound.wav');
% [normalized,slot] = findvoice(suono,fs,fsnew);

[dimx, dimy]       = size(suono);
% conversion from stereo 2 mono
if dimy==2
    suono = suono(:,1);
end
if dimx==2
    suono = suono(1,:);
end
%figure,plot(suono)
% fsnew              = 8000;
suono_ricampionato = resample(suono,fsnew,fs);
% elimino pause
sr       = suono_ricampionato;
srdct    = dct(sr);
srdct(1) = 0;
sr       = idct(srdct);
%------------------------------------------------------------- first output
normalized = sr;
%--------------------------------------------------------------------------
sr       = abs(sr);
minimo   = min(sr);
massimo  = max(sr);

L        = length(sr);

percentuale = 5;

valmin      = minimo+(massimo-minimo)/100*percentuale;
% posinf      = find(sr<valmin);
possup      = find(sr>=valmin);

Lok    = length(possup);
thresh = 100;
cont   = 1;

slot(cont,1) = possup(1);
slot(cont,2) = possup(1);
for ii=2:Lok
    dv = possup(ii)-possup(ii-1);
    if dv<=thresh
        slot(cont,2) = possup(ii);
    else
        cont = cont+1;
        slot(cont,1) = possup(ii);
    end
end
% srt         = sr;
% srt(posinf) = 0;
% 
% ascissa =[1:L];
% figure,plot(ascissa,suono_ricampionato,ascissa,srt),
% hold on,plot(possup(1),1,'X'),plot(possup(end),1,'X'),hold off
% 
% Lok  = length(possup);
% dmax = 0;
% dv   = zeros(Lok,1); 
% for ii=2:Lok
%     dv(ii) = possup(ii)-possup(ii-1);
%     if possup(ii)-possup(ii-1)>dmax
%         dmax = possup(ii)-possup(ii-1);
%     end
% end
% disp(dmax);
% figure,hist(dv);