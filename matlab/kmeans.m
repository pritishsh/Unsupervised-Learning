clc;
clear all; 
%close all;


firstdata = 1;
dpts      = 100;  % number of data points
clstno    = 4;     % number of clusters
iters     = 8;     % number of iterations:

D = csvread('emissiondata.txt');
D = D(8:8:end,:,:);
D = D(firstdata:firstdata+dpts,2:3);
datrange = max(D);
D = [ D(:,1)/datrange(1) , D(:,2)/datrange(2) ]; % normalise data so it is 0 to 1

kmeanplot(D,clstno,iters)

function kmeanplot(D,clstno,iters)
subpltrows = 2;
dpts    = size(D,1);
clstcol = ["red","green","blue","yellow"];

memno   = [];            % number of members in given cluster
distmat = [];            % col 1 is distance, col 2 is closest cluster number
clstgp  = [];            % coordinates of cluster center

%%%%%%%     ITERATION 1     %%%%%%%%%%%
subplot(subpltrows,iters/2,1);
for i = 1:clstno
    clstgp = [ clstgp ; D(i,1),D(i,2) ] ; 
    scatter( clstgp(i,1),clstgp(i,2), 50, clstcol(i) );
    hold on
end

for i = 1:dpts
    tempdist = []; % holds distances from all cluster centers
    for j = 1:clstno
        tempdist = [tempdist,distcal( D(i,:) , clstgp(j,:) )];
    end 
    [temp1,temp2] = min(tempdist);
    distmat = [ distmat ; temp1,temp2  ];
    
    scatter( D(i,1) , D(i,2), 4, clstcol(distmat(i,2)) );
    hold on
end
xlim([0 1.5]);
ylim([0 1.5]);

D = [D(:,1:2),distmat(:,2)];





%%%%%%% ITERATION 2 onwards %%%%%%%%%%%

for itno = 2:iters
    subplot(subpltrows,iters/2,itno);
    memno = [];
    
    % reset cluster centers
    for i = 1:clstno 
        clstgp(i,1) = 0 ;
        clstgp(i,2) = 0 ;
        memno  = [memno,0]; 
    end
    
    % calculate new cluster centers
    for i = 1:dpts
        g = D(i,3); % cluster number to which i'th datapt currently belongs
        memno(g) = memno(g)+1; 
        clstgp(g,1) = clstgp(g,1) + D(i,1) ;
        clstgp(g,2) = clstgp(g,2) + D(i,2) ;
    end

    % normalise and plot new cluster center
    for i = 1:clstno
        clstgp(i,1) =  clstgp(i,1)/memno(i);
        clstgp(i,2) =  clstgp(i,2)/memno(i);
        scatter( clstgp(i,1),clstgp(i,2), 50, clstcol(i) );
        hold on
    end

    % plot datapoints and calculate their membership
    distmat = [];
    for i = 1:dpts
        tempdist = []; % temporarily holds distances from all cluster centers
        for j = 1:clstno
            tempdist = [tempdist,distcal( D(i,:) , clstgp(j,:) )];
        end 
        [temp1,temp2] = min(tempdist); % temp1 is dist, temp2 is cluster number
        distmat = [ distmat ; temp1,temp2  ];
    
        scatter( D(i,1) , D(i,2), 4, clstcol(distmat(i,2)) );
        hold on
    end
    D = [D(:,1:2),distmat(:,2)];

    xlim([0 1.5]);
    ylim([0 1.5]);

end



end

function m = distcal(a,b)
m = (a(1)-b(1))*(a(1)-b(1)) + (a(2)-b(2))*(a(2)-b(2)) ;
end
