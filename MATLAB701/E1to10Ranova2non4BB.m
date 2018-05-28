% E1to10Ranova2non4BB
function H4L=E1to10Ranova2non4BB(S1,S2,S3,S4,S5,S6,S7,S8,S9,M1,M2,M3,M4,M5,M6,M7,M8,M9,N1,N2,N3,N4,N5,N6,N7,N8,N9,V)
% S:FFTby4HzBB; M:FFTby6.66HzBB; N:FFTbyNoBB; V:channels202XY 
for c=1:202
    Sn((1:123),c,1)=S1((15:137),c);
    Sn((1:123),c,2)=S2((15:137),c);
    Sn((1:123),c,3)=S3((15:137),c);
    Sn((1:123),c,4)=S4((15:137),c);
    Sn((1:123),c,5)=S5((15:137),c);
    Sn((1:123),c,6)=S6((15:137),c);
    Sn((1:123),c,7)=S7((15:137),c);
    Sn((1:123),c,8)=S8((15:137),c);
    Sn((1:123),c,9)=S9((15:137),c);
    Mn((1:123),c,1)=M1((15:137),c);
    Mn((1:123),c,2)=M2((15:137),c);
    Mn((1:123),c,3)=M3((15:137),c);
    Mn((1:123),c,4)=M4((15:137),c);
    Mn((1:123),c,5)=M5((15:137),c);
    Mn((1:123),c,6)=M6((15:137),c);
    Mn((1:123),c,7)=M7((15:137),c);
    Mn((1:123),c,8)=M8((15:137),c);
    Mn((1:123),c,9)=M9((15:137),c);
    Nn((1:123),c,1)=N1((15:137),c);
    Nn((1:123),c,2)=N2((15:137),c);
    Nn((1:123),c,3)=N3((15:137),c);
    Nn((1:123),c,4)=N4((15:137),c);
    Nn((1:123),c,5)=N5((15:137),c);
    Nn((1:123),c,6)=N6((15:137),c);
    Nn((1:123),c,7)=N7((15:137),c);
    Nn((1:123),c,8)=N8((15:137),c);
    Nn((1:123),c,9)=N9((15:137),c);
end;
for i=1:9
    Sn((1:123),203,i)=S1((15:137),203)/1000;
    Mn((1:123),203,i)=M1((15:137),203)/1000;
    Nn((1:123),203,i)=N1((15:137),203)/1000;
end;
% significant 4HzBB-dominant frequency on right 40 channels 
R=find(V(2,(1:202))==2);
for f=1:123
    X=[Sn(f,R,1);Mn(f,R,1);Nn(f,R,1);Sn(f,R,2);Mn(f,R,2);Nn(f,R,2);Sn(f,R,3);Mn(f,R,3);Nn(f,R,3);Sn(f,R,4);Mn(f,R,4);Nn(f,R,4);Sn(f,R,5);Mn(f,R,5);Nn(f,R,5);Sn(f,R,6);Mn(f,R,6);Nn(f,R,6);Sn(f,R,7);Mn(f,R,7);Nn(f,R,7);Sn(f,R,8);Mn(f,R,8);Nn(f,R,8);Sn(f,R,9);Mn(f,R,9);Nn(f,R,9)];
    if (mean(mean(Sn(f,R,:),2),3)>mean(mean(Mn(f,R,:),2),3))&(mean(mean(Sn(f,R,:),2),3)>mean(mean(Nn(f,R,:),2),3))
        p1=anova2(X,9,'off');
        H4L(f,(1:3))=p1;
    else
        H4L(f,(1:3))=[1 1 1];
    end;
end;
for r=1:123
    if H4L(r,3)<0.01
        h4L(r,1)=H4L(r,1);
        h4L(r,3)=H4L(r,3);
        h4L(r,2)=1;
    else
        h4L(r,(1:3))=H4L(r,(1:3));
    end;
assignin('base','h4L',h4L);
FR=S1((15:137),203)/1000;
plot(ones(size(FR(find(h4L(:,2)<0.01),1)),1),FR(find(h4L(:,2)<0.01),1),'bo'),axis([0 2 1 10]),grid on
end