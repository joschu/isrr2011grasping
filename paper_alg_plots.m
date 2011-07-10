objdir = '/home/joschu/Data/grasping/obj';
outdir = '/home/joschu/Data/grasping/results';

algs = {'bb','sat','unif','rand'};
Ks = 7:4:40;
% models = [1147 80 288 649 540];
models = [1147 80];

%%
figure(1); clf; hold on;
colors = [0 0 1; .5 .5 .5; .5 .5 .5; 0 1 0]
markers = {'-s','-o','--d',':d'}
    
for modelnum = models(1)
    
    for i_alg = 1:length(algs)        
        for i_K = 1:numel(Ks)
            K = Ks(i_K)

%             objfname = sprintf('%s/m%i.obj',objdir,modelnum);
            outname = sprintf('%s/m%i_%i_%s.mat',outdir,modelnum,K,algs{i_alg});
            s = load(outname);
            rs(i_K) = s.r
        end
        h = plot(Ks,rs,[markers{i_alg},'k'],'LineWidth',3,'MarkerSize',14)
        set(gca,'Xtick',Ks)
    end
end

lh=legend('OPTIMAL (B&B)','SATURATE','UNIFORM','RANDOM','Location','NorthWest')
%  th = title('Quality metric');
%  set(th,'FontSize',20)
 ylh=ylabel('Q_{\infty}')
 set(ylh,'FontSize',20)
xlh=xlabel('Num. contacts')
 set(xlh,'FontSize',20)

 set(gca,'FontSize',20)
set(lh,'FontSize',16)

%%

for modelnum = models(1)

    for i_K = 1:numel(Ks)
        K = Ks(i_K)


        outname = sprintf('%s/m%i_%i_%s.mat',outdir,modelnum,K,'sat');
        s = load(outname);
        t_sat(i_K) = s.t_elapsed
        
        outname = sprintf('%s/m%i_%i_%s.mat',outdir,modelnum,K,'bb');
        s = load(outname);
        t_bb(i_K) = s.t_elapsed/60

    end

figure(2); clf; hold on;    
ax1 = gca    
ax2 = axes('Position',get(ax1,'Position'),...
           'XAxisLocation','bottom',...
           'YAxisLocation','right',...
           'Color','none',...
           'XColor','k','YColor','k');    
ax =[ax1,ax2]    
    
h1 = plot(ax1,Ks,t_sat,'-ks','LineWidth',3,'MarkerSize',14);
h2 = plot(ax1,Ks,t_bb,'-ko','LineWidth',3,'MarkerSize',14);
%  th = title('Algorithm Runtime');
%  set(th,'FontSize',20)

%  set(h1,'LineWidth',3)
%  set(h2,'LineWidth',3)

% set(xlh,'FontSize',20)
set(ax(1),'Ylim',[0 40])
set(ax(1),'Ytick',[0 10 20 30 40],'Xtick',[]);
set(ax(2),'Ylim',get(ax(1),'Ylim'))  
set(ax(2),'Ytick',[])

set(get(ax(1),'Ylabel'),'String','SATURATE runtime (seconds)','FontSize',20)
set(get(ax(2),'Ylabel'),'String','Branch and bound runtime (minutes)','FontSize',20) 
set(ax(1),'FontSize',20)    
set(ax(2),'FontSize',20)    

set(get(ax(1),'Xlabel'),'String',sprintf('\nNum. contacts'),'FontSize',20)
legend(ax1,'SATURATE','B & B')
    
end
