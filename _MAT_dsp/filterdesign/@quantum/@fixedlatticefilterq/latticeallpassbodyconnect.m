function [NL, PrevIPorts, PrevOPorts, NextIPorts, NextOPorts, mainparams]=latticeallpassbodyconnect(q,NL,H,mainparams)
%LATTICEALLPASSBODYCONNECT specifies the connection and quantization parameters in the
%conceptual body stage

%   Author(s): Honglei Chen
%   Copyright 1988-2004 The MathWorks, Inc.

%add quantization blocks
NL.setnode(filtgraph.node('cast'),6);
set(NL.nodes(6).block,'label','CastInProd');
set(NL.nodes(6),'position',[0.6 0.7 0.6 0.7]);
set(NL.nodes(6).block,'orientation','left');
mainparams(6)=filtgraph.indexparam(6,{});

NL.setnode(filtgraph.node('cast'),7);
set(NL.nodes(7).block,'label','CastState');
set(NL.nodes(7),'position',[0.9 1 0.9 1]);
set(NL.nodes(7).block,'orientation','left');
mainparams(7)=filtgraph.indexparam(7,{});

% specify the qparam
%CastStates, CastInProd
castqparam.outQ=[H.StateWordLength H.StateFracLength];
castqparam.RoundMode=H.RoundMode;
castqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(6),'qparam',castqparam);
set(NL.nodes(7),'qparam',castqparam);

%Lattice Gain
latticegainqparam.qcoeff=[H.CoeffWordLength H.LatticeFracLength];
latticegainqparam.qproduct=[H.ProductWordLength H.ProductFracLength];
latticegainqparam.Signed=H.Signed;
latticegainqparam.RoundMode=H.RoundMode;
latticegainqparam.OverflowMode=H.OverflowMode;
set(NL.nodes(2),'qparam', latticegainqparam);
set(NL.nodes(3),'qparam', latticegainqparam);

if H.CastBeforeSum
    %Lattice sum
    latticesumqparam.AccQ = [H.AccumWordLength H.AccumFracLength];
    latticesumqparam.sumQ = [H.AccumWordLength H.AccumFracLength];
    latticesumqparam.RoundMode = H.RoundMode;
    latticesumqparam.OverflowMode = H.OverflowMode;
    set(NL.nodes(1),'qparam',latticesumqparam);
    set(NL.nodes(4),'qparam',latticesumqparam);
else
    s=getbestprecision(H);
    latticesumqparam.AccQ = [s.AccumWordLength s.AccumFracLength];
    latticesumqparam.sumQ = [H.AccumWordLength H.AccumFracLength];
    latticesumqparam.RoundMode = H.RoundMode;
    latticesumqparam.OverflowMode = H.OverflowMode;
    set(NL.nodes(1),'qparam',latticesumqparam);
    set(NL.nodes(4),'qparam',latticesumqparam);
end

%connection
NL.connect(1,1,6,1);
NL.connect(2,1,1,2);
NL.connect(3,1,4,1);
NL.connect(5,1,2,1);
NL.connect(5,1,4,2);
NL.connect(6,1,3,1);
NL.connect(7,1,5,1);
PrevIPorts = [filtgraph.nodeport(7,1)];
PrevOPorts = [filtgraph.nodeport(1,1)];
NextIPorts=[filtgraph.nodeport(1,1)];
NextOPorts=[filtgraph.nodeport(4,1)];