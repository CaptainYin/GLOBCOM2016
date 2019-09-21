semilogy(erlangs,1-accpratios2,'Marker','o','LineWidth',2);
hold  on
semilogy(erlangs,1-accpratios1,'Color','r','Marker','+','LineWidth',2);
semilogy(erlangs,1-accpratios3,'Color','m','Marker','s','LineWidth',2);
%legend('1:0.1','1:1','0.1:1');
grid on
mins=zeros(3,1);
maxs=zeros(3,1);
mins(1)=min(1-accpratios1);
mins(2)=min(1-accpratios2);
mins(3)=min(1-accpratios3);
maxs(1)=max(1-accpratios1);
maxs(2)=max(1-accpratios2);
maxs(3)=max(1-accpratios3);
axis([0 100 min(mins) max(maxs)]);
set(gca,'YTick',min(mins):0.05:max(maxs))
ylabel('Blocking Probability');
xlabel('Traffic Load (Erlangs)');
