clc;
clear all; 
%close all;
figure

firstdata = 350;
dpts      = 50;  % number of data points
clstno    = 3;     % number of clusters
iters     = 4;     % number of iterations
%m         = 2;     % fuzziness prameter

D = csvread('emissiondata.txt');
D = D(2:5:end,:,:);
D = D(firstdata:firstdata+dpts,2:3);
datrange = max(D);
D = [ D(:,1)/datrange(1) , D(:,2)/datrange(2) ]; % normalise data so it is 0 to 1

kmeanplot(D,clstno,iters)

function kmeanplot(D,clstno,iters)
subpltrows = 2;
dpts    = size(D,1);
clstcol = ["red","green","blue","black"];

memfunc = zeros(dpts,clstno);    % number of members per cluster
distmat = zeros(dpts,2);         % col 1 is distance, col 2 is closest cluster number
clstgp  = zeros(clstno,2);       % coordinates of cluster center

%%%%%%%     ITERATION 1     %%%%%%%%%%%
subplot(subpltrows,ceil(iters/2),1);
for i = 1:clstno
    clstgp(i,:) = [ D(i,1),D(i,2) ] ; 
    scatter( clstgp(i,1),clstgp(i,2), 50, clstcol(i) );
    hold on
end

for i = 1:dpts
    tempdist = zeros(1,clstno); % temporrily holds distances from all cluster centers
    for j = 1:clstno
        tempdist(j) = distcal( D(i,:) , clstgp(j,:) );
    end 
    [temp1,temp2] = min(tempdist);   % temp1 is distance, temp2 is cluster number
    distmat(i,:) = [ temp1,temp2  ];
    
    scatter( D(i,1) , D(i,2), 4, clstcol(distmat(i,2)) );
    hold on
end
xlim([0 1.5]);
ylim([0 1.5]);
title("Iteration Number "+1)

D = [D(:,1:2),distmat(:,2)];





%%%%%%% ITERATION 2 onwards %%%%%%%%%%%

for itno = 2:iters
    subplot(subpltrows,ceil(iters/2),itno);
    
    memfunc = [];
    
    % reset cluster centers
    memfunc = zeros(dpts,clstno);
    clstgp  = zeros(clstno,2);

    
    % calculate new cluster centers
    for i = 1:dpts
        g = D(i,3); % cluster number to which i'th datapt currently belongs
        memfunc(g) = memfunc(g)+1; 
        clstgp(g,1) = clstgp(g,1) + D(i,1) ;
        clstgp(g,2) = clstgp(g,2) + D(i,2) ;
    end

    % normalise and plot new cluster center
    for i = 1:clstno
        clstgp(i,1) =  clstgp(i,1)/memfunc(i);
        clstgp(i,2) =  clstgp(i,2)/memfunc(i);
        scatter( clstgp(i,1),clstgp(i,2), 50, clstcol(i) );
        hold on
    end

    % plot datapoints and calculate their membership
    distmat = zeros(dpts,2);
    for i = 1:dpts
        tempdist = zeros(1,clstno); % temporrily holds distances from all cluster centers
        for j = 1:clstno
            tempdist(j) = distcal( D(i,:) , clstgp(j,:) );
        end 
        [temp1,temp2] = min(tempdist); % temp1 is dist, temp2 is cluster number
        distmat(i,:) = [ temp1,temp2  ];
    
        scatter( D(i,1) , D(i,2), 4, clstcol(distmat(i,2)) );
        hold on
    end
    D = [D(:,1:2),distmat(:,2)];

    xlim([0 1.5]);
    ylim([0 1.5]);
    title("Iteration Number "+itno);

end



end

function m = distcal(a,b)
m = (a(1)-b(1))*(a(1)-b(1)) + (a(2)-b(2))*(a(2)-b(2)) ;
end
