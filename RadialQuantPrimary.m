%RUN THIS PROGRAM AFTER RUNNING RadialQuantRegister BUT BEFORE RUNNING
%RadialQuantSecondary.

%This script determines the center of the bone. The amount of bone (or
%periosteum, depending on which you use) in each radial segment is
%collected in countPixels and is expressed in pixel units. CtTh collects
%the average cortical/periosteal thickness in each radial segment; however,
%this is in beta form and may not function correctly for some segments.

clear all;
close all;
clc;

%Comment in our out if you'd like to record a video of your analysis.
% v = VideoWriter('analysisDemo');
% v.FrameRate = 4;
% open(v);

startAng = 0;

file = uigetfile('','Select a File','*.*');
Im = imread(file);
Im = imbinarize(Im);

[yP,xP]=find(Im);
yctr = mean(yP);
xctr = mean(xP);

sizeIm = size(Im);
xSize = sizeIm(2);
ySize = sizeIm(1);

bins = 36;

countPixels = zeros(bins,1);
endoLength = zeros(bins,1);
periLength = zeros(bins,1);
CtTh = zeros(bins,1);
endoPts = [];
periPts = [];

%Analyze right half of image
x = floor(xctr):1:sizeIm(2);
for i = 0:bins/2 - 1
    
    %Indexing start and end angle for pie slice (special cases for vertical
    %and horizontal lines)
    
    if i > 0 && i < 17
        y1 = (1/tan(i*pi/18 + startAng))*(x-xctr)+yctr;
        y2 = (1/tan((i+1)*pi/18 + startAng))*(x-xctr)+yctr;
        
        y1 = (y1 <= ySize).*y1;
        y2 = (y2 <= ySize).*y2;
        x1 = x(find(y1,1,'first'):find(y1,1,'last'));
        x2 = x(find(y2,1,'first'):find(y2,1,'last'));
        y1 = floor(y1(find(y1,1,'first'):find(y1,1,'last')));
        y2 = floor(y2(find(y2,1,'first'):find(y2,1,'last')));
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
        x1 = x(find(y1,1,'first'):find(y1,1,'last'));
        y1 = floor(y1(find(y1,1,'first'):find(y1,1,'last')));
        
        y2 = 1:yctr;
        x2 = xctr*ones(1,length(y2));
        
    end

    %Selecting the pixels within the indexed pie slice from the original image. 
    
    imSlice2Analyze = zeros(sizeIm);
    if i == 0
        
        for n = 1:length(y2)
        
            xn = x(n);
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
                    xn = x(n);
                    y2n = y2(n);

                    imSlice2Analyze(y2n:y1n, xn)=Im(y2n:y1n, xn);

                catch

                    xn = x(n);
                    y2n = y2(n);

                    imSlice2Analyze(y2n:end, xn)=Im(y2n:end, xn);

                end

            else

                try

                    y1n = y1(n);
                    xn = x(n);
                    y2n = y2(n);

                    imSlice2Analyze(y2n:y1n, xn)=Im(y2n:y1n, xn);

                catch

                    xn = x(n);
                    y1n = y1(n);

                    imSlice2Analyze(1:y1n, xn)=Im(1:y1n, xn);

                end

            end

        end
    end
    
    %ANALYSES ON A PARTICULAR PIE SLICE
    
    %Sum pixel values in pie slice
    
    countPixels(i+1)=sum(imSlice2Analyze(:) == 1);
    
    %Calculate periosteal & endosteal length & average radial cortical
    %thickness.
    
    endoX = zeros(1,11);
    endoY = zeros(1,11);
    periX = zeros(1,11);
    periY = zeros(1,11);
    CtThSamp = zeros(1,11);
    
    ang = i*pi/18:pi/180:(i+1)*pi/18;
    firstAng = 1;
    lastAng = 11;
    
    if i == 0
        
        lineSamp = [];
        yS = floor(yctr):1:ySize;
        xS = floor(xctr)*ones(1,length(yS));
        firstAng = 2;
        
        for m = 1:length(yS)
                lineSamp(m) = imSlice2Analyze(yS(m), xS(m));
        end
        
%         endo = find(lineSamp,1,'first');
%         peri = find(lineSamp,1,'last');
%         endoX(1) = xS(endo);
%         endoY(1) = yS(endo);
%         periX(1) = xS(peri);
%         periY(1) = yS(peri);
%         CtThSamp(1) = ((xS(endo)-xS(peri))^2+(yS(endo)-yS(peri))^2)^(1/2);
%         
    elseif i == 17
        
        lineSamp = [];
        yS = floor(yctr):-1:1;
        xS = floor(xctr)*ones(1,length(yS));
        lastAng = 10;
        
        for m = 1:length(yS)
                lineSamp(m) = imSlice2Analyze(yS(m), xS(m));
        end
        
%         endo = find(lineSamp,1,'first');
%         peri = find(lineSamp,1,'last');
%         endoX(11) = xS(endo);
%         endoY(11) = yS(endo);
%         periX(11) = xS(peri);
%         periY(11) = yS(peri);
%         CtThSamp(11) = ((xS(endo)-xS(peri))^2+(yS(endo)-yS(peri))^2)^(1/2);
%         
    end
    
    for j = firstAng:lastAng
            lineSamp = [];
            yS = (1/tan(ang(j)))*(x-xctr)+yctr;
            yS = (yS <= ySize).*yS;
            yS = yS.*(yS>0);
            yS = floor(yS);
            xS = x(find(yS,1,'first'):find(yS,1,'last'));
            yS = yS(find(yS,1,'first'):find(yS,1,'last'));
            for m = 1:length(yS)
                lineSamp(m) = imSlice2Analyze(yS(m), xS(m));
            end
            endo = find(lineSamp,1,'first');
            peri = find(lineSamp,1,'last');
            
            if ~isempty(endo)
                endoX(j) = xS(endo);
                endoY(j) = yS(endo);
            end
            if ~isempty(peri)
                periX(j) = xS(peri);
                periY(j) = yS(peri);
            end
            if ~isempty(endo) && ~isempty(peri)
                CtThSamp(j) = ((xS(endo)-xS(peri))^2+(yS(endo)-yS(peri))^2)^0.5;
            else
                CtThSamp(j) = NaN;
                periX(j) = NaN;
                periY(j) = NaN;
                endoX(j) = NaN;
                endoY(j) = NaN;
                disp(['Cortical bone is incomplete in bin ',num2str(i+bins/2+1),'.']);
            end
        
        
    end
    
%     %FOR SPLINE FIT ONLY: Remove repeat X values
%     
%     if length(unique(endoX,'stable')) ~= length(endoX)
%         [endoX,ia] = unique(endoX,'stable');
%         endoY = endoY(ia);
%     end
%     
%     if length(unique(periX,'stable')) ~= length(periX)
%         [periX,ia] = unique(periX,'stable');
%         periY = periY(ia);
%     end
%     
%     %SPLINE FIT only
%     
%     endoXX = linspace(endoX(1),endoX(length(endoX)));
%     periXX = linspace(periX(1),periX(length(periX)));
% 
%     endoYY = spline(endoX,endoY,endoXX);
%     periYY = spline(periX,periY,periXX);

%     %Calculate peri/endosteal length (spline only)
%     
%     for m = 2:length(endoXX)
%         endoLength(i+1)=endoLength(i+1)+((endoXX(m-1)-endoXX(m))^2+(endoYY(m-1)+endoYY(m))^2)^0.5;
%     end
% 
%     for m = 2:length(periXX)
%         periLength(i+1)=periLength(i+1)+((periXX(m-1)-periXX(m))^2+(periYY(m-1)+periYY(m))^2)^0.5;
%     end

    %Calculate peri/endosteal length (linear interpolation only)
    
    endoPieceLength = zeros(length(endoX)-1,1);
    periPieceLength = zeros(length(periX)-1,1);
    
    for m = 2:length(endoX)
        endoPieceLength(m-1)=((endoX(m-1)-endoX(m))^2+(endoY(m-1)-endoY(m))^2)^0.5;
    end
    
    endoLength(i+1) = sum(endoPieceLength);
    
    for m = 2:length(periX)
        periPieceLength(m-1)=((periX(m-1)-periX(m))^2+(periY(m-1)-periY(m))^2)^0.5;
    end
    
    endoPts = [endoPts,[endoX;endoY]];
    periPts = [periPts,[periX;periY]];
    
    periLength(i+1) = sum(periPieceLength);
    
    CtTh(i+1) = mean(CtThSamp);
    
    figure(2);
    imshow(imSlice2Analyze);
    hold on;
    plot(x1,y1)
    plot(x2,y2)
    plot(endoX,endoY,'r*-');
    plot(periX,periY,'b*-');
    
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
    
    %Calculate peri/endosteal length & mean cortical thickness
    
    endoX = zeros(1,11);
    endoY = zeros(1,11);
    periX = zeros(1,11);
    periY = zeros(1,11);
    CtThSamp = zeros(1,11);
    
    ang = i*pi/18:pi/180:(i+1)*pi/18;
    firstAng = 1;
    lastAng = 11;
    
    if i == 0
        
        lineSamp = [];
        yS = floor(yctr):-1:1;
        xS = floor(xctr)*ones(1,length(yS));
        firstAng = 2;
        
        for m = 1:length(yS)
                lineSamp(m) = imSlice2Analyze(yS(m), xS(m));
        end
        
%         endo = find(lineSamp,1,'first');
%         peri = find(lineSamp,1,'last');
%         endoX(1) = xS(endo);
%         endoY(1) = yS(endo);
%         periX(1) = xS(peri);
%         periY(1) = yS(peri);
%         CtThSamp(1) = ((xS(endo)-xS(peri))^2+(yS(endo)-yS(peri))^2)^(1/2);
%         
    elseif i == 17
        
        lineSamp = [];
        yS = floor(yctr):1:ySize;
        xS = floor(xctr)*ones(1,length(yS));
        lastAng = 10;
        
        for m = 1:length(yS)
                lineSamp(m) = imSlice2Analyze(yS(m), xS(m));
        end
        
%         endo = find(lineSamp,1,'first');
%         peri = find(lineSamp,1,'last');
%         endoX(11) = xS(endo);
%         endoY(11) = yS(endo);
%         periX(11) = xS(peri);
%         periY(11) = yS(peri);
%         CtThSamp(11) = ((xS(endo)-xS(peri))^2+(yS(endo)-yS(peri))^2)^(1/2);
%         
    end
    
    for j = firstAng:lastAng
        
            lineSamp = [];
            yS = (1/tan(ang(j)))*(xL-xctr)+yctr;
            yS = (yS <= ySize).*yS;
            yS = yS.*(yS>0);
            yS = floor(yS);
            xS = xL(find(yS,1,'first'):find(yS,1,'last'));
            yS = yS(find(yS,1,'first'):find(yS,1,'last'));
            for m = 1:length(yS)
                lineSamp(m) = imSlice2Analyze(yS(m), xS(m));
            end
            endo = find(lineSamp,1,'first');
            peri = find(lineSamp,1,'last');
            if ~isempty(endo)
                endoX(j) = xS(endo);
                endoY(j) = yS(endo);
            end
            if ~isempty(peri)
                periX(j) = xS(peri);
                periY(j) = yS(peri);
            end
            if ~isempty(endo) && ~isempty(peri)
                CtThSamp(j) = ((xS(endo)-xS(peri))^2+(yS(endo)-yS(peri))^2)^(1/2);
            else
                CtThSamp(j) = NaN;
                periX(j) = NaN;
                periY(j) = NaN;
                endoX(j) = NaN;
                endoY(j) = NaN;
                disp(['Cortical bone is incomplete in bin ',num2str(i+bins/2+1),'.']);
            end
            
    end
    
    endoPieceLength = zeros(length(endoX)-1,1);
    periPieceLength = zeros(length(periX)-1,1);
    
    for m = 2:length(endoX)
        endoPieceLength(m-1)=((endoX(m-1)-endoX(m))^2+(endoY(m-1)-endoY(m))^2)^0.5;
    end
    
    endoLength(i+bins/2+1) = sum(endoPieceLength);
    
    for m = 2:length(periX)
        periPieceLength(m-1)=((periX(m-1)-periX(m))^2+(periY(m-1)-periY(m))^2)^0.5;
    end
    
    endoPts = [endoPts,[endoX;endoY]];
    periPts = [periPts,[periX;periY]];
    
    periLength(i+bins/2+1) = sum(periPieceLength);
    
    CtTh(i+bins/2+1) = mean(CtThSamp);
    
    figure(2);
    imshow(imSlice2Analyze);
    hold on;
    plot(x1,y1)
    plot(x2,y2)
    plot(endoX,endoY,'r*-');
    plot(periX,periY,'b*-');
    
    hold off;
    
    M(i+bins/2+1) = getframe;
    
end
