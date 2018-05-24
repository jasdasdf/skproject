function updateinternalsettings(q)
%UPDATEINTERNALSETTINGS   

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

% Define Product format and update fimath
[prodWL, prodFL] = set_prodq(q, q.privcoeffwl, q.privcoefffl, ...
    q.privinwl, ...
    q.privinfl);

% Define Accumulator format and update fimath
[accWL, accFL] = set_accq(q, prodWL, prodFL, q.ncoeffs);

% Define State format
[stWL stFL] = set_stateq(q, accWL, accFL);

% Send a quantizestates event
send_quantizestates(q);

% Define Output format
set_outq(q,accWL, accFL);

% [EOF]