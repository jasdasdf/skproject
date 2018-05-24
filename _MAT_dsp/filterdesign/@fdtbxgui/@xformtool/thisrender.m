function thisrender(this, varargin)
%THISRENDER Render this object

%   Copyright 1999-2011 The MathWorks, Inc.

pos = parserenderinputs(this, varargin{:});
sz  = gui_sizes(this);
if isempty(pos),
    pos = [34 28 732 248]*sz.pixf;
end

hFig = get(this, 'FigureHandle');

h.container = uicontainer('Parent', hFig, ...
    'Units', 'Pixels', ...
    'Visible', 'Off', ...
    'Position', [pos(1) pos(2)+(25*sz.pixf) pos(3) pos(4)*.9], ...
    'Units', 'Normalized');

h.clayout = siglayout.gridbaglayout(h.container, ...
    'VerticalWeights', [1 0], ...
    'VerticalGap', 5*sz.pixf, ...
    'HorizontalGap', 5*sz.pixf);

h.panel = uipanel('Parent', h.container, ...
    'Title', getString(message('signal:sigtools:siggui:FrequencyTransformations')));

h.clayout.add(h.panel, 1, 1, 'Fill', 'Both');

cbs   = siggui_cbs(this);

buttonWidth  = largestuiwidth({getString(message('signal:sigtools:siggui:TransformFilter'))},'Push');
h.button = uicontrol(hFig, ...
    'Style', 'Push', ...
    'String', getString(message('signal:sigtools:siggui:TransformFilter')), ...
    'Visible','Off',...
    'Position', [pos(1)+315*sz.pixf pos(2)+5*sz.pixf buttonWidth+3*sz.pixf sz.uh+3*sz.pixf], ...
    'Tag','xformtool_transformbutton',...
    'Callback', {cbs.method, this, @transformfilter, 'Transform Filter'});

if iscalledbydspblks(this)
  inputPrcPos =  [pos(1)+12*sz.pixf pos(2) pos(3) pos(4)];
  [h.inputprocessing_lbl h.inputprocessing_popup inputProcOffset] = inputProcessingSelector(this, inputPrcPos);
  guiWidth = pos(3)+pos(1);
  inputProcOffset = inputProcOffset + inputPrcPos(1);
  buttonPos = get(h.button,'Position');
  newCenter = inputProcOffset + (guiWidth - inputProcOffset)/2;
  set(h.button,'Position',[newCenter-buttonPos(3)/2 buttonPos(2:4)]);
  set([h.inputprocessing_lbl h.inputprocessing_popup],'Units','Normalized');
end
set(h.button,'Units','Normalized');

h.sourcetype_lbl = uicontrol(h.panel, ...
    'HorizontalAlignment', 'Left', ...
    'Tag', 'xformtool_fromlbl', ...
    'Style', 'Text', ...
    'String', getString(message('signal:sigtools:siggui:OriginalFilterType')));

h.sourcetype = uicontrol(h.panel, ...
    'Callback', @(hcbo, ev) sourceType_cb(this, hcbo), ...
    'BackgroundColor', 'w', ...
    'HorizontalAlignment', 'Left', ...
    'Tag', 'xformtool_frompoup', ...
    'Style', 'Popup', ...
    'String', {getString(message('signal:sigtools:siggui:Lowpass')) ...
               getString(message('signal:sigtools:siggui:Highpass')) ...
               getString(message('signal:sigtools:siggui:Bandpass')) ...
               getString(message('signal:sigtools:siggui:Bandstop'))});

h.sourcefrequency_lbl = uicontrol(h.panel, ...
    'Tag', 'xformtool_fromlbl', ...
    'HorizontalAlignment', 'Left', ...
    'Style', 'Text', ...
    'String', getString(message('signal:sigtools:siggui:FrequencyPointToTransform')));

h.sourcefrequency = uicontrol(h.panel, ...
    'Callback', @(hcbo, ev) fromebox_cb(hcbo, this), ...
    'HorizontalAlignment', 'Left', ...
    'BackgroundColor', 'w', ...
    'Style', 'Edit', ...
    'Tag', 'xformtool_fromebox', ...
    'String', this.SourceFrequency);

h.sourceunits = uicontrol(h.panel, ...
    'Style', 'Text', ...
    'String', 'Normalized', ...
    'HorizontalAlignment', 'Left');

h.divider = uicontrol(h.panel, ...
    'Style', 'Frame', ...
    'Tag', 'xformtool_divider');

h.targettype_lbl = uicontrol(h.panel, ...
    'HorizontalAlignment', 'Left', ...
    'Tag', 'xformtool_fromlbl', ...
    'Style', 'Text', ...
    'String', getString(message('signal:sigtools:siggui:TransformedFilterType')));

h.targettype = uicontrol(h.panel, ...
    'Callback', @(hcbo, ev) targetType_cb(this, hcbo), ...
    'BackgroundColor', 'w', ...
    'Tag', 'xformtool_topopup', ...
    'HorizontalAlignment', 'Left', ...
    'Style', 'Popup', ...
    'String', {getString(message('signal:sigtools:siggui:Lowpass')) ...
               getString(message('signal:sigtools:siggui:Highpass')) ...
               getString(message('signal:sigtools:siggui:Bandpass')) ...
               getString(message('signal:sigtools:siggui:Bandstop'))});

h.targetfrequency_lbl = uicontrol(h.panel, ...
    'Visible', 'Off', ...
    'String', 'Text', ...
    'Style','text', ...
    'Tag', 'xformtool_tolbl1', ...
    'HorizontalAlignment', 'Left');

h.targetunits(1) = uicontrol(h.panel, ...
    'Visible', 'Off', ...
    'String', 'Normalized', ...
    'Style', 'Text', ...
    'HorizontalAlignment', 'Left');

h.targetfrequency = uicontrol(hFig, ...
    'Visible', 'Off', ...
    'Style','edit', ...
    'BackgroundColor', 'w', ...
    'Tag', 'xformtool_toebox1', ...
    'Visible','Off', ...
    'HorizontalAlignment', 'Left', ...
    'Callback', @(hcbo, ev) toebox_cb(hcbo, this, 1));

h.targetfrequency_lbl(2) = uicontrol(hFig, ...
    'Visible', 'Off', ...
    'String', 'Test', ...
    'Style','text', ...
    'Tag', 'xformtool_tolbl2', ...
    'HorizontalAlignment', 'Left');

h.targetfrequency(2) = uicontrol(hFig, ...
    'Visible', 'Off', ...
    'Style','edit', ...
    'BackgroundColor', 'w', ...
    'Tag', 'xformtool_toebox2', ...
    'Visible','Off', ...
    'HorizontalAlignment', 'Left', ...
    'Callback', @(hcbo, ev) toebox_cb(hcbo, this, 2));

h.mbtargetfrequency = uicontrol(hFig, ...
    'Visible', 'Off', ...
    'Style','edit', ...
    'BackgroundColor', 'w', ...
    'Tag', 'xformtool_toebox2', ...
    'Visible','Off', ...
    'HorizontalAlignment', 'Left', ...
    'Callback', @(hcbo, ev) toebox_cb(hcbo, this, []));

h.targetunits(2) = uicontrol(hFig, ...
    'Visible', 'Off', ...
    'String', '(0 to 1)', ...
    'Style', 'Text', ...
    'HorizontalAlignment', 'Left');

h.playout = siglayout.gridbaglayout(h.panel, ...
    'HorizontalWeights', [0 1 0 0 0 1 0], ...
    'VerticalWeights',   [0 0 0 1], ...
    'VerticalGap',       5*sz.pixf, ...
    'HorizontalGap',     5*sz.pixf);

h.playout.add(h.sourcetype_lbl, 1, 1, ...
    'TopInset', 15*sz.pixf+sz.lblTweak, ...
    'Anchor', 'west', ...
    'MinimumWidth', largestuiwidth(h.sourcetype_lbl));

h.playout.add(h.sourcetype, 1, [2 3], ...
    'TopInset', 15*sz.pixf, ...
    'Anchor', 'North', ...
    'Fill', 'Horizontal', ...
    'MinimumWidth', largestuiwidth(h.sourcetype));

h.playout.add(h.sourcefrequency_lbl, 2, 1, ...
    'Anchor', 'west', ...
    'TopInset', sz.lblTweak, ...
    'MinimumWidth', largestuiwidth(h.sourcefrequency_lbl));

h.playout.add(h.sourcefrequency, 2, 2, ...
    'Fill', 'Horizontal', ...
    'Anchor', 'North', ...
    'MinimumWidth', 20*sz.pixf);

h.playout.add(h.sourceunits, 2, 3, ...
    'TopInset', sz.lblTweak, ...
    'MinimumWidth', largestuiwidth({getString(message('signal:sigtools:siggui:Normalized1'))}));

if isunix, width = 2;
else       width = 1; end

h.playout.add(h.divider, [1 4], 4, ...
    'TopInset', 15*sz.pixf, ...
    'MinimumWidth', width, 'MaximumWidth', width, ...
    'Fill', 'Vertical');

h.playout.add(h.targettype_lbl, 1, 5, ...
    'TopInset', 15*sz.pixf+sz.lblTweak, ...
    'Anchor', 'West', ...
    'MinimumWidth', largestuiwidth(h.targettype_lbl));

h.playout.add(h.targettype, 1, [6 7], ...
    'TopInset', 15*sz.pixf, ...
    'RightInset', 5*sz.pixf, ...
    'Anchor', 'North', ...
    'Fill', 'Horizontal', ...
    'MinimumWidth', largestuiwidth(h.targettype));
    
set(this, ...
    'Handles',   h, ...
    'Container', h.container, ...
    'Layout',    h.clayout);

updateTargetTypes(this);
updateSourceType(this);
updateTargetType(this);
updateSourceFrequency(this);
updateTargetFrequency(this)
updateUnits(this);
updateLayout(this);

addCSH(this);
attachlisteners(this);
setupenablelink(this, 'isTransformed', false, 'button');

% --------------------------------------------------------------
function attachlisteners(this)

listener = [ ...
    listen(this, 'Transform',       @(hSrc, ev) updateLayout(this)); ...
    listen(this, 'TargetFrequency', @(hSrc, ev) updateTargetFrequency(this)); ...
    listen(this, 'SourceFrequency', @(hSrc, ev) updateSourceFrequency(this)); ...
    listen(this, 'CurrentFs',       @(hSrc, ev) updateUnits(this)); ....
    listen(this, 'Filter',          @(hSrc, ev) updateTargetTypes(this)); ...
    listen(this, 'TargetType',      @(hSrc, ev) updateTargetType(this)); ...
    listen(this, 'SourceType',      @(hSrc, ev) updateSourceType(this)); ...
    ];

set(listener, 'CallbackTarget', this);
set(this, 'WhenRenderedListeners', listener);

% -----------------------------------------------------------------------
function l = listen(this, property, fcn)

l = handle.listener(this, this.findprop(property), 'PropertyPostSet', fcn);

% -----------------------------------------------------------------------
%       Callbacks
% -----------------------------------------------------------------------

% -----------------------------------------------------------------------
function sourceType_cb(this, hcbo)

index = get(hcbo, 'Value');
vals  = {'Lowpass', 'Highpass', 'Bandpass', 'Bandstop'};
set(this, 'SourceType', vals{index});

% -----------------------------------------------------------------------
function targetType_cb(this, hcbo)

index = get(hcbo, 'Value');
vals  = getValidTargetTypes(this);
set(this, 'TargetType', vals{index});

% -----------------------------------------------------------------------
function updateTargetType(this)

vals = getValidTargetTypes(this);
indx = find(strcmpi(this.TargetType, vals));

set(this.Handles.targettype, 'Value', indx);

% -----------------------------------------------------------------------
function updateSourceType(this)

vals = {'Lowpass', 'Highpass', 'Bandpass', 'Bandstop'};
indx = find(strcmpi(this.SourceType, vals));

set(this.Handles.sourcetype, 'Value', indx);

updateTargetTypes(this);

% -----------------------------------------------------------------------
function updateSourceFrequency(this)

set(this.Handles.sourcefrequency, 'String', this.SourceFrequency);

% -----------------------------------------------------------------------
function updateTargetTypes(this)

strs = getValidTargetTypes(this);
indx = find(strcmpi(this.TargetType, strs));
for jndx = 1:length(strs)
    strs{jndx} = getTranslatedString('signal:sigtools:siggui',strs{jndx});
end

set(this.Handles.targettype, 'String', strs, 'Value', indx);

% -----------------------------------------------------------------------
function updateTargetFrequency(this)

target = get(this, 'TargetFrequency');
h      = get(this, 'Handles');

for indx = 1:min([2 length(target)]),
    set(h.targetfrequency(indx), 'String', target(indx));
end

str = sprintf('%s   ', target{:});
str(end-2:end) = [];

% Set up the multiband editbox
set(h.mbtargetfrequency, 'String', sprintf('[%s]',str));

set(this, 'isTransformed', 0);
sendfiledirty(this);

% -----------------------------------------------------------------------
function updateLayout(this)

h     = get(this, 'Handles');
lbls  = get(this, 'Labels');
xform = get(this, 'Transform');
sz    = gui_sizes(this);

xlbls = lbls.(xform);

% Remove the target frequency editboxes from the layout.
h.playout.remove(2, 5);
h.playout.remove(2, 6);
h.playout.remove(2, 7);
h.playout.remove(3, 5);
h.playout.remove(3, 6);
h.playout.remove(3, 7);

if strncmp(xform, 'iirlp2mb', 8)
    
    set(h.targetfrequency_lbl(1), 'String', getTranslatedString('signal:sigtools:siggui',xlbls{1}));
    h.playout.add(h.targetfrequency_lbl(1), 2, [5 7], ...
        'Anchor', 'west', ...
        'TopInset', sz.lblTweak, ...
        'MinimumWidth', largestuiwidth(h.targetfrequency_lbl));
    h.playout.add(h.mbtargetfrequency, 3, [5 6], ...
        'Anchor', 'North', ...
        'Fill', 'Horizontal');
    h.playout.add(h.targetunits(2), 3, 7, ...
        'TopInset', sz.lblTweak, ...
        'MinimumWidth', largestuiwidth({'Normalized'}));
    
    set([h.targetfrequency_lbl(2:end), h.targetfrequency, h.targetunits(1)], 'Visible', 'Off');
    set([h.targetfrequency_lbl(1) h.mbtargetfrequency h.targetunits(2)], 'Visible', 'On');
else
    
    set(h.mbtargetfrequency, 'Visible', 'Off');

    for indx = 1:length(xlbls),
        set(h.targetfrequency_lbl(indx), 'String', getTranslatedString('signal:sigtools:siggui',xlbls{indx}));
        
        h.playout.add(h.targetfrequency_lbl(indx), indx+1, 5, ...
            'TopInset', sz.lblTweak, ...
            'MinimumWidth', largestuiwidth(h.targetfrequency_lbl(indx)), ...
            'Anchor', 'West');
        h.playout.add(h.targetfrequency(indx), indx+1, 6, ...
            'Anchor', 'North', ...
            'Fill', 'Horizontal');
        h.playout.add(h.targetunits(indx), indx+1, 7, ...
            'TopInset', sz.lblTweak, ...
            'MinimumWidth', largestuiwidth({'Normalized'}))
        
        set([h.targetfrequency_lbl(indx) h.targetfrequency(indx) h.targetunits(indx)], ...
            'Visible', 'On');
    end
    
    offindx = length(xlbls)+1;
    set([h.targetfrequency_lbl(offindx:end) h.targetfrequency(offindx:end) ...
        h.targetunits(offindx:end)], 'Visible', 'Off');
end

% -----------------------------------------------------------------------
function updateUnits(this)

units = this.CurrentFs.units;

h = get(this, 'Handles');
if strcmpi(units, 'normalized (0 to 1)'), units = 'Normalized'; end
set([h.sourceunits h.targetunits], 'String', units);

% -----------------------------------------------------------------------
function fromebox_cb(hcbo, this)

sf = fixup_uiedit(hcbo);

set(this, 'SourceFrequency', sf{1});


% -----------------------------------------------------------------------
function toebox_cb(hcbo, this, indx)

tf = get(this, 'TargetFrequency');

sf = fixup_uiedit(hcbo);
while iscell(sf), sf = char([sf{:}]); end

if isempty(indx), %from multiband
    sf = strrep(sf, '[', '');
    sf = strrep(sf, ']', '');
    tf = strread(sf, '%s', 'delimiter', ' ');
else
    tf{indx} = sf;
end

set(this, 'TargetFrequency', tf);

% -----------------------------------------------------------------------
function addCSH(this)

h = get(this, 'Handles');

csmenu(h.button,                        'xform_actionbtn');
csmenu(h.panel,                         'xform_overview');
csmenu([h.sourcetype_lbl h.sourcetype], 'xform_orig_specs');
csmenu([h.targettype_lbl h.targettype], 'xform_target_specs');
csmenu([h.targetfrequency_lbl h.targetfrequency h.mbtargetfrequency h.targetunits], ...
    'xform_location_specs');
csmenu([h.sourcefrequency_lbl h.sourcefrequency h.sourceunits], ...
    'xform_point_specs');

% -----------------------------------------------------------------------
function csmenu(h, tag)

hFig = ancestor(h, 'figure'); if iscell(hFig), hFig = hFig{1}; end
cshelpcontextmenu(hFig, h, ['fdatool_' tag filesep 'dsp'], 'fdatool');

% [EOF]