function plot_alg_results(results,series)
n_res = numel(results);

for i_res = 1:4
    
    
   
   subplot(1,n_res,i_res); hold on


   if strcmp(series,'hull'), 
       brute = results(i_res).r_hull_brute
       sat = results(i_res).r_hull_sat
   elseif strcmp(series,'mink')
       brute = results(i_res).r_mink_brute; 
       sat = results(i_res).r_mink_sat;
   end
   
   Qs = 4:3+numel(brute);
       
    plot(Qs,brute,'b-')
    plot(Qs,sat,'r-') 
    set(gca,'XTick',Qs,'YTick',[],...
        'FontSize',16,'yLim',[0,ymax],'xLim',[4,7])
    
   if i_res == 1
      h_y = ylabel('r_{res}') 
%       h_x = xlabel('num. contacts')
      set(h_y,'FontSize',20)
%       set(h_x,'FontSize',20)
      set(gca,'Ytick',[0,1])
   end
    
    
end

end