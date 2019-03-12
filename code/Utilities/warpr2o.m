% function to warp images with different dimensions
function [warpI2,outnum]=warpr2o(im,xx,yy,im0)

[height2,width2,nchannels]=size(im);
[height1,width1,~]=size(im0);

warpI2 = zeros([height1,width1,nchannels]);

outnum = 0;
for i=1:nchannels
    for r =1:height2
        for c = 1:width2
            warpI2(yy(r,c),xx(r,c),i)=im(r,c,i);            
        end
    end
end