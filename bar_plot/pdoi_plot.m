%pdoi_plot.m
%Plot PDO index with respect to time(Month Year)
%Positive bars are in red while negative ones in blue;
%
%Xiaowei Huai; 2015/6/22
%
clear;close all;clc

%Read data from csv file
PDOData = csvread('pdodata.csv',2,0);
yrmon = PDOData(:,1);
pdoi = PDOData(:,2);

%Change year and month to serial date number
dateStrIn = 'yyyymm';
yrmon_new = datenum(num2str(yrmon(:,1)),dateStrIn);
startYrMon = yrmon_new(1,1);
endYrMon = yrmon_new(length(yrmon_new),1);
dateStrOut = 'mmmyyyy';

%-----------------------------------------------------------------
%If you want to calculate moving average, just use filter function:
%   windowSize = 24;
%   pout = filter(ones(1,windowSize)/windowSize,1,pdoi)
%   plot(yrmon_new,pout,'k-','LineWidth',1.5)
%------------------------------------------------------------------

%--------THE WHOLE TIME
%EdgeColor is BLACK by default. If too many bars then the whole picture
%will be shown as black bars.
figure
bar(yrmon_new,pdoi,0.5)
positive = (pdoi>0); %logical
bar(yrmon_new(positive),pdoi(positive),'r','BarWidth',0.5,'LineWidth',0.01,'FaceColor','r','EdgeColor','r')
hold on
bar(yrmon_new(~positive),pdoi(~positive),'r','BarWidth',0.5,'LineWidth',0.01,'FaceColor','b','EdgeColor','b')
hold off

datetick('x',dateStrOut,'keeplimits')
set(gca,'xlim',[startYrMon,endYrMon])
set(gca,'ylim',[-4,4])
%set(gca,'XTickMode','auto')
%set(gca,'xtick',[])
grid on
box on
xlabel('\fontsize{14}Time');ylabel('\fontsize{14}PDO Index')
print(gcf,'-dpng','pdoi_matlab_whole.png')
close(gcf)
%--------------------------------
%
%-------TIME INTERVAL BY 12 MONTHS----------
figure
N=length(yrmon);
ys=yrmon_new(1:12:N);
ps=pdoi(1:12:N);
inx=(ps>=0);
bar(ys(inx),ps(inx),'BarWidth',0.5,'FaceColor','r','LineWidth',0.05,'EdgeColor','r')
hold on
bar(ys(~inx),ps(~inx),'BarWidth',0.5,'FaceColor','b','LineWidth',0.05,'EdgeColor','b')

datetick('x',dateStrOut,'keeplimits')
set(gca,'xlim',[startYrMon,endYrMon])
set(gca,'ylim',[-3,3])
%set(gca,'XTickMode','auto')
%set(gca,'xtick',[])
grid on
box on
xlabel('\fontsize{14}Time');ylabel('\fontsize{14}PDO Index')

print(gcf,'-dpng','pdoi_matlab_interval12mon.png')
close(gcf)