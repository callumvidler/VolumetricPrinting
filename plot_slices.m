function []= plot_slices(movelist)

length_of_movelist  = length(movelist); 


for iii = 2:length_of_movelist 
    
    figure(1)
    plot3(movelist{iii}(:,1),movelist{iii}(:,2),iii*ones(length(movelist{iii}(:,2))))
    hold on 
    
    
end


ende 