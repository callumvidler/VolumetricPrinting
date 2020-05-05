clc
clear



[baseName, folder] = uigetfile('*.png');
fullFileName = fullfile(folder, baseName)


I = imread(fullFileName);



I = im2bw(I);
I = 1-I;

image_size = 250;

I = imresize(I, [image_size,image_size]);

hFig = gcf;
hAx  = gca;
% set the figure to full screen
set(hFig,'units','normalized','outerposition',[0 0 1 1]);
% set the axes to full screen
set(hAx,'Unit','normalized','Position',[0 0 1 1]);
% hide the toolbar
set(hFig,'menubar','none')
% to hide the title
set(hFig,'NumberTitle','off');
set(gcf,'color','white');


for filter = 1:4
    
    if filter == 1
        filter_type = 'shepp-logan';
        interpolation_type = 'nearest';
    end
    
    if filter == 2
        filter_type = 'shepp-logan';
        interpolation_type = 'linear';
    end
    
    if filter == 3
        filter_type = 'shepp-logan';
        interpolation_type = 'spline';
    end
    
    if filter == 4
        filter_type = 'shepp-logan';
        interpolation_type = 'pchip';
    end
    
    
    
    
    
    
    
    
    for i = 1:1:180
        
        tic;
        
        R = radon(I,1:i);
        InR = iradon(R,1:i,filter_type,interpolation_type);
        zeros = find(InR < 0); 
        InR(zeros) = 0; 
        
        
        
        subplot(2,4,1);
        
        imshow(I,[]);
        title(sprintf('Input Image [%d px, %d px]',image_size,image_size));
        
        
        subplot(2,4,2);
        m = surf(I);
        title('Target Dose');
        set(m,'edgecolor','none')
        
        
        subplot(2,4,3);
        zlim([-1 2]);
        h = surf(InR);
        size_1 = size(I);
        set(h,'edgecolor','none')
        
        % K = imabsdiff(I,imresize(InR,size_1));
        %  errorPercent = sum(sum(K))/size_1(1)^2;
        
        cInR = InR;
        
        cInR(:,1) = [];
        cInR(1,:) = [];
        
        [y_h x_h] = size(cInR);
        
        cInR(:,x_h) = [];
        cInR(y_h,:) = [];
        
        [y_h x_h] = size(cInR);
        
        errorPercent = sum(sum(abs(I-cInR)/(y_h*x_h)));
        
        
        
        
        
        title(sprintf('Summed Dose: Angle %.2f \n Error Percentage: %.2f %%',i,100*errorPercent));
        
        subplot(2,4,4);
        
        title('Convergence');
        plot(i,errorPercent,'ro');
        xlabel('Projection Angles');
        ylabel('Percentage Error');
        xlim([0 180])
        ylim([0 1])
        hold on;
        
        subplot(2,4,5);
        imshow(InR,[]);
        title('Procedurally Generated Output');
        pause(0.1);
        
        
        
        
        time = toc;
        
        error_matrix(i,filter) = errorPercent;
        time_matrix(i,filter) = time;
        
    end
    
    [width height] = size(time_matrix);
    output_time(1,filter) = time_matrix(1,filter);
    
    for r = 2:width
        
        output_time(r,filter) = time_matrix(r,filter) + output_time(r-1,filter);
    end
    
    subplot(2,4,[6 7]);
    title('Compliance Time');
    plot(output_time(:,filter), error_matrix(:,filter),'DisplayName',strcat(filter_type,' [',interpolation_type,']'));
    legend()
    xlabel('Time (s)');
    ylabel('Error');
    hold on;
    
    subplot(2,4,8);
    
    c = categorical({strcat(filter_type,' [',interpolation_type,']')});
    bar(c,100*error_matrix(end,filter));
    title('Error Comparrison');
    ylabel('Final Error (%)');
    
    hold on;
    
    
    
end















