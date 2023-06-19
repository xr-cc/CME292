
fig = uifigure('Name','My GUI');

gl = uigridlayout(fig,[2,2]);
gl.RowHeight = {'0.15x','1x'};
gl.ColumnWidth = {'1x','1x'};
  
% create a button
btn = uibutton(gl);
btn.Layout.Row = 1; btn.Layout.Column = 1;
btn.Text = "Button";

% create a slider
sld = uislider(gl);
sld.Layout.Row = 1; sld.Layout.Column = 2;

% create and lay out panel
pnl = uipanel(gl);
pnl.Layout.Row = 2;
pnl.Layout.Column = [1 2];
% ax = axes(pnl); ax.NextPlot = 'add';

% lstbx = uilistbox(g);
% lstbx.Items = {'Channel 1','Channel 2','Channel 3'};
% lstbx.Layout.Row = 3;
% lstbx.Layout.Column = 1;
%   
% fig.UserData = struct("TextArea",txt, "Axes",ax);
% btn.ButtonPushedFcn = @CreateLine;
% 
% function CreateLine(src, event)
%     fig = ancestor(src,"figure","toplevel");
%     data = fig.UserData;
%     txt = data.TextArea;
%     ax = data.Axes;
%     val = txt.Value;
%     x = linspace(0,1,100);
%     plot(ax,x,str2double(val).*x+randn(size(x))); 
% end