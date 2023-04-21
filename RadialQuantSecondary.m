%%Run RadialQuantPrimary PRIOR TO RUNNING
%%NOTE: centroids, centers, ctr, xctr, yctr should already be defined. DO
%%NOT clear variables before running this script.

%This script determines the amount of a particular feature (i.e. axon
%length, bone surface, etc.) in each radial segment. The amount is
%collected in countPixels and is expressed in pixel units.

%Comment in our out if you'd like to record a video of your analysis.
% v = VideoWriter('analysisDemo');
% v.FrameRate = 4;
% open(v);

startAng = 0;

file = uigetfile('','Select a File','*.*');
Im = imread(file);
Im = imbinarize(Im);
sizeIm = size(Im);
xSize = sizeIm(2);
ySize = sizeIm(1);

bins = 36;

countPixels = zeros(bins,1);

%Analyze right half of image
x = floor(xctr):1:sizeIm(2);
for i = 0:bins/2 - 1
    
    %Indexing start and end angle for pie slice (special cases for vertical
    %and horizontal lines)
    
    if i > 0 && i < 17
        y1 = (1/tan(i*pi/18 + startAng))*(x-xctr)+yctr;
        y2 = (1/tan((i+1)*pi/18 + startAng))*(x-xctr)+yctr;
        
        y1 = (y1 <= ySize).*y1;
        y1 = (y1 > 0).*y1;
        y2 = (y2 <= ySize).*y2;
        y2 = (y2 > 0).*y2;
        x1 = x(find(y1,1,'first'):find(y1,1,'last'));
        x2 = x(find(y2,1,'first'):find(y2,1,'last'));
        y1 = ceil(y1(find(y1,1,'first'):find(y1,1,'last')));
        y2 = ceil(y2(find(y2,1,'first'):find(y2,1,'last')));
    elseif i == 0
        
        y1 = yctr:1:ySize;
        x1 = xctr*ones(1,length(y1));
        y2 = (1/tan((i+1)*pi/18 + startAng))*(x-xctr)+yctr;
        
        y2 = (y2 <= ySize).*y2;
        x2 = x(find(y2,1,'first'):find(y2,1,'last'));
        y2 = floor(y2(find(y2,1,'first'):find(y2,1,'last')));
        
    elseif i == 17
        
        y1 = (1/tan(i*pi/18 + startAng))*(x-xctr)+yctr;
        y1 = (y1 <= ySize).*y1;
        y1 = (y1 > 0).*y1;
        x1 = x(find(y1,1,'first'):find(y1,1,'last'));
        y1 = floor(y1(find(y1,1,'first'):find(y1,1,'last')));
        
        y2 = 1:yctr;
        x2 = xctr*ones(1,length(y2));
        
    end

    %Selecting the pixels within the indexed pie slice from the original image. 
    
    imSlice2Analyze = zeros(sizeIm);
    if i == 0
        
        for n = 1:length(y2)
        
            xn = x2(n);
            y2n = y2(n);

            imSlice2Analyze(y2n:end, xn)=Im(y2n:end, xn);
            
        end
        
    elseif i == 17
        
        for n = 1:length(y1)
        
            xn = x(n);
            y1n = y1(n);

            imSlice2Analyze(1:y1n, xn)=Im(1:y1n, xn);
            
        end
        
    else
    
        for n = 1:max([length(y1),length(y2)])
        
             if length(y2)>length(y1) %y1 is smaller

                try

                    y1n = y1(n);
                    xn = x2(n);
                    y2n = y2(n);

                    imSlice2Analyze(y2n:y1n, xn)=Im(y2n:y1n, xn);

                catch

                        xn = x2(n);
                        y2n = y2(n);

                        imSlice2Analyze(y2n:end, xn)=Im(y2n:end, xn);

                end

            else

                try

                    y1n = y1(n);
                    xn = x1(n);
                    y2n = y2(n);

                    imSlice2Analyze(y2n:y1n, xn)=Im(y2n:y1n, xn);

                catch

                    xn = x1(n);
                    y1n = y1(n);

                    imSlice2Analyze(1:y1n, xn)=Im(1:y1n, xn);

                end

            end

        end
    end
    
    %ANALYSES ON A PARTICULAR PIE SLICE
    
    %Sum pixel values in pie slice
    
    countPixels(i+1)=sum(imSlice2Analyze(:) == 1);
    
    figure(2);
    imshow(imSlice2Analyze);
    hold on;
    plot(x1,y1)
    plot(x2,y2)
    
    hold off;
    
    M(i+1) = getframe;
    
end

%%

%Analyze left half of image
xL = floor(xctr):-1:1;
for i = 0:bins/2-1
    
    %Indexing start and end ray for pie slice
    
    if i > 0 && i < 17
        
        y1 = (1/tan(i*pi/18 + startAng))*(xL-xctr)+yctr;
        y2 = (1/tan((i+1)*pi/18 + startAng))*(xL-xctr)+yctr;

        y1 = (y1 >= 1).*y1;
        y2 = (y2 >= 1).*y2;
        x1 = xL(find(y1,1,'first'):find(y1,1,'last'));
        x2 = xL(find(y2,1,'first'):find(y2,1,'last'));
        y1 = floor(y1(find(y1,1,'first'):find(y1,1,'last')));
        y2 = floor(y2(find(y2,1,'first'):find(y2,1,'last')));
        
    elseif i == 0
        
        y1 = 1:yctr;
        x1 = xctr*ones(1,length(y1));
        
        y2 = (1/tan((i+1)*pi/18 + startAng))*(xL-xctr)+yctr;
        y2 = (y2 >= 1).*y2;
        x2 = xL(find(y2,1,'first'):find(y2,1,'last'));
        y2 = floor(y2(find(y2,1,'first'):find(y2,1,'last')));
        
    elseif i == 17
        
        y1 = (1/tan(i*pi/18 + startAng))*(xL-xctr)+yctr;
        y1 = (y1 >= 1).*y1;
        x1 = xL(find(y1,1,'first'):find(y1,1,'last'));
        y1 = floor(y1(find(y1,1,'first'):find(y1,1,'last')));
        
        y2 = yctr:ySize;
        x2 = xctr*ones(1,length(y2));
        
    end
    
    %Generating pie slice to analyze from original image based on pie slice
    %coordinates calculated above.
    
    imSlice2Analyze = zeros(sizeIm);
    if i == 0
        
        for n = 1:length(y2)
        
            xn = xL(n);
            y2n = y2(n);

            imSlice2Analyze(1:y2n, xn)=Im(1:y2n, xn);
            
        end
        
    elseif i == 17
        
        for n = 1:length(y1)
        
            xn = xL(n);
            y1n = y1(n);

            imSlice2Analyze(y1n:end, xn)=Im(y1n:end, xn);
            
        end
        
    else
        for n = 1:max([length(y1),length(y2)])

            if length(y2)>length(y1) %y1 is smaller

                try

                    xn = x2(n);
                    y2n = y2(n);
                    y1n = y1(n);

                    imSlice2Analyze(y1n:y2n, xn)=Im(y1n:y2n, xn);

                catch

                    xn = x2(n);
                    y2n = y2(n);

                    imSlice2Analyze(1:y2n,xn)=Im(1:y2n,xn);

                end

            else

                try

                    xn = x1(n);
                    y1n = y1(n);
                    y2n = y2(n);

                    imSlice2Analyze(y1n:y2n, xn)=Im(y1n:y2n, xn);

                catch

                    xn = x1(n);
                    y1n = y1(n);

                    imSlice2Analyze(y1n:end, xn)=Im(y1n:end, xn);

                end


            end

        end
    end
    
    %ANALYZE PIE SLICE
    
    %Sum pixel values in pie slice
    
    countPixels(i+bins/2+1)=sum(imSlice2Analyze(:) == 1);
    
    figure(2);
    imshow(imSlice2Analyze);
    hold on;
    plot(x1,y1)
    plot(x2,y2)
    
    hold off;
    
    M(i+bins/2+1) = getframe;
    
end

% writeVideo(v,M);
% close(v);