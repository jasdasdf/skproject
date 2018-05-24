D1=structsort(D,'$Evalisi$');
for s=1:length(D1)
    if isempty(find(D1(s).RaySig<=0.001))==1
        D1(s).maxR=NaN;
        D1(s).maxRRaySig=NaN;
        D1(s).StimFreq=D1(s).BinFreq(1);
    else
        [a,n]=max(D1(s).R(find(D1(s).RaySig<=0.001)));
        D1(s).maxR=a;
        select=D1(s).RaySig(find(D1(s).RaySig<=0.001));
        D1(s).maxRRaySig=select(n);
        clear a;clear n;clear select
        D1(s).StimFreq=D1(s).BinFreq(1);
    end;
end;
D1_A=D1([1 3:57 58:81 82:89 90 91:108 109:124 125:129]);
D1_Ac=structfilter(D1_A,'$CF$-$StimFreq$<1 & $CF$-$StimFreq$>-1');

D1_B=D1([130:213]);
D1_Bc=structfilter(D1_B,'$CF$-$StimFreq$<1 & $CF$-$StimFreq$>-1');

structplot(D1_A,'StimFreq','maxR',D1_Ac,'StimFreq','maxR',...
    D1_B,'StimFreq','maxR',D1_Bc,'StimFreq','maxR',...
    'markers',{'o','o','o','o'}, 'Colors',{'k','r','b','c'})






