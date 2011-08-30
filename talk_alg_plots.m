%% Performance comparison

objdir = '/home/joschu/Data/grasping/obj';
outdir = '/home/joschu/Data/grasping/results';

algs = {'bb1','sat'};
Ks = 7:4:40;
models = [1147 80 288 649 540];
% models = [1147 80];%%
figure(1); clf; hold on;
colors = 'rbkc';
markers = {'-s','-o','--d',':d'};


for i_alg = 1:length(algs)
    rs = zeros(length(Ks),1);
    for i_K = 1:numel(Ks)
        K = Ks(i_K);
        
        for modelnum = models(1)
            
            
            %             objfname = sprintf('%s/m%i.obj',objdir,modelnum);
            outname = sprintf('%s/m%i_%i_%s.mat',outdir,modelnum,K,algs{i_alg});
            s = load(outname);
            rs(i_K) = rs(i_K) + s.r;
        end
    end
    disp('hi')
    h = plot(Ks,rs/length(models),[markers{i_alg},colors(i_alg)],'LineWidth',3,'MarkerSize',14);
    set(gca,'Xtick',Ks)
end

lh=legend('OPTIMAL (B&B)','SATURATE','Location','NorthWest');
%  th = title('Quality metric');
%  set(th,'FontSize',20)
ylh=ylabel('Q_{\infty}');
set(ylh,'FontSize',30)
xlh=xlabel('Num. contacts');
set(xlh,'FontSize',20)

set(gca,'FontSize',20)
set(lh,'FontSize',16)
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [8 8]);
saveas(1,'~/Proj/grasping/isrr_talk/sat_vs_bb.png')

%% Saturate runtime

figure(2); clf; hold on;
ax1 = gca
t_sat = []

for modelnum = models(1)
    
    for i_K = 1:numel(Ks)
        K = Ks(i_K)
        
        
        outname = sprintf('%s/m%i_%i_%s.mat',outdir,modelnum,K,'sat');
        s = load(outname);
        t_sat(i_K) = s.t_elapsed        
        
        
    end
    h1 = plot(ax1,Ks,t_sat,[markers{2},colors(2)],'LineWidth',3,'MarkerSize',14);
%     h2 = plot(ax1,Ks,t_bb,'-ko','LineWidth',3,'MarkerSize',14);

% set(ax1,'Ylim',[0 100])
end

set(ax1,'Xtick',[0 10 20 30 40]);
set(ax1,'FontSize',30)
ylabel('Run-time (seconds)')
xlabel('Num. contacts')
lh=legend('SATURATE','Location','NorthWest');
%  th = title('Algorithm Runtime');
%  set(th,'FontSize',20)

%  set(h1,'LineWidth',3)
%  set(h2,'LineWidth',3)

% set(xlh,'FontSize',20)
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [8 8]);
saveas(2,'~/Proj/grasping/isrr_talk/sat_runtime_seconds.png')

%% BB runtime

figure(3); clf; hold on;
ax1 = gca

i_model = 0
for modelnum = models
    i_model  = i_model+1
    
    for i_K = 1:numel(Ks)
        K = Ks(i_K)
        
        
        outname = sprintf('%s/m%i_%i_%s.mat',outdir,modelnum,K,'bb1');
        s = load(outname);
        t_bb(i_model,i_K) = s.t_elapsed/60
        outname = sprintf('%s/m%i_%i_%s.mat',outdir,modelnum,K,'sat');
        s = load(outname);
        t_sat(i_model,i_K) = s.t_elapsed/60
        
    end
%     h2 = plot(ax1,Ks,t_bb,'-ko','LineWidth',3,'MarkerSize',14);

% set(ax1,'Ylim',[0 100])
end

h1 = plot(ax1,Ks,mean(t_bb,1),[markers{1},colors(1)],'LineWidth',3,'MarkerSize',14);
h2 = plot(ax1,Ks,mean(t_sat,1),[markers{2},colors(2)],'LineWidth',3,'MarkerSize',14);


lh=legend('(B&B)','SATURATE','Location','NorthEast');

set(ax1,'Xtick',[0 10 20 30 40]);
set(ax1,'FontSize',30)
ylabel('Run-time (minutes)')
xlabel('Num. contacts')

set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [8 8]);
saveas(3,'~/Proj/grasping/isrr_talk/bb_runtime.png')
