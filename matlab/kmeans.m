clc;
clear all; %#ok<*CLALL> 
close all;

dpts    = 100;
clstno  = 3;
clstcol = ["red","green","blue","orange","yellow"];

memno   = [];            % number of members in given cluster
distmat = [];            % col 1 is distance, col 2 is closest cluster number
clstgp  = [];            % coordinates of cluster center

D = csvread('emissiondata.txt'); %#ok<*CSVRD> 
D = D(1:dpts,2:3);
datrange = max(D);
D = [ D(:,1)/datrange(1) , D(:,2)/datrange(2) ];

subplot(1,3,1);
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ITERATION 2

subplot(1,3,2);

% reset cluster centers
for i = 1:clstno 
    clstgp(i,1) = 0 ;
    clstgp(i,2) = 0 ;
    memno  = [memno,0]; %#ok<*AGROW> 
end

for i = 1:dpts
    g = D(i,3); % cluster number to which i'th datapt currently belongs
    memno(g) = memno(g)+1; 
    clstgp(g,1) = clstgp(g,1) + D(i,1) ;
    clstgp(g,2) = clstgp(g,2) + D(i,2) ;
end

for i = 1:clstno
    clstgp(i,1) =  clstgp(i,1)/memno(i);
    clstgp(i,2) =  clstgp(i,2)/memno(i);
    scatter( clstgp(i,1),clstgp(i,2), 50, clstcol(i) );
    hold on
end

distmat = [];
for i = 1:dpts
    tempdist = [];
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

memno = zeros(1,clstno)


D = [D(:,1),D(:,2),distmat(:,2)];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      iteration 3


for i = 1:clstno
    clstgp(i,1) = 0 ;
    clstgp(i,2) = 0 ;
    memno  = [memno,0]; %#ok<*AGROW> 
end

subplot(1,3,3);

for i = 1:dpts
    g = D(i,3);
    memno(g) = memno(g)+1; %#ok<*SAGROW> 
    clstgp(g,1) = clstgp(g,1) + D(i,1) ;
    clstgp(g,2) = clstgp(g,2) + D(i,2) ;
end

for i = 1:clstno
    clstgp(i,1) =  clstgp(i,1)/memno(i);
    clstgp(i,2) =  clstgp(i,2)/memno(i);
    scatter( clstgp(i,1),clstgp(i,2), 50, clstcol(i) );
    hold on
end

distmat = [];
for i = 1:dpts
    tempdist = [];
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







function m = distcal(a,b)
m = (a(1)-b(1))*(a(1)-b(1)) + (a(2)-b(2))*(a(2)-b(2)) ;
end
