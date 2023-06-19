fig = uifigure('Name','My GUI');

gl = uigridlayout(fig,[2,3]);
gl.RowHeight = {'0.12x','1x'};
gl.ColumnWidth = {'0.8x','0.2x','1x'};
  
% create a button
btn = uibutton(gl);
btn.Layout.Row = 1; btn.Layout.Column = 1;
btn.Text = "Generate line";

% create a text area
edt = uieditfield(gl,'numeric');
edt.Layout.Row = 1; edt.Layout.Column = 2;
edt.Limits = [-5,5];
edt.Value = 3;
edt.Tooltip = "intercept";

% create a slider
sld = uislider(gl);
sld.Layout.Row = 1; sld.Layout.Column = 3;
sld.Limits = [-10 10];
sld.Value = 0;
sld.Tooltip = "slope";

% create and lay out panel
pnl = uipanel(gl);
pnl.Layout.Row = 2;
pnl.Layout.Column = [1 3];
ax = axes(pnl); ax.NextPlot = 'add'; % for plotting
ax.XLim = [-1,1];
ax.YLim = [-15,15];

fig.UserData = struct("Edt",edt, "Sld",sld,"Axes",ax);
btn.ButtonPushedFcn = @CreateLine;

function CreateLine(src, event)
    fig = ancestor(src,"figure","toplevel");
    data = fig.UserData;
    ax = data.Axes;
    edt_val = data.Edt.Value;
    sld_val = data.Sld.Value;
    x = linspace(-1,1,100); % str2double(edt_val)
    plot(ax,x,edt_val+sld_val.*x); 
end