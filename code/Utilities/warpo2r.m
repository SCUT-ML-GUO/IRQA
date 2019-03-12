function [warp,outnum]=warpo2r(im,xx,yy,im0)
[height2,width2,nchannels]=size(im);
%[height1,width1,~]=size(im0);

warp = zeros(height2,width2,nchannels);

outnum = 0;
for i=1:nchannels
    for r =1:height2
        for c = 1:width2
            warp(r,c,i)=im0(yy(r,c),xx(r,c),i);            
        end
    end
end