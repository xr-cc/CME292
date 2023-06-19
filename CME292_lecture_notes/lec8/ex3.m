
fig = uifigure('Name','My GUI');

gl = uigridlayout(fig,[2,5]);
gl.RowHeight = {'0.12x','1x'};
gl.ColumnWidth = {'0.33x','0.42x','0.1x','0.3x','0.7x'};
  
% create a button
btn = uibutton(gl);
btn.Layout.Row = 1; btn.Layout.Column = 1;
btn.Text = "Generate line";

% create a state button
btnDlt = uibutton(gl,'state');
btnDlt.Layout.Row = 1; btnDlt.Layout.Column = 2;
btnDlt.Text = "Clear previous lines";
btnDlt.Value = false;

% create a text area
edt = uieditfield(gl,'numeric');
edt.Layout.Row = 1; edt.Layout.Column = 3;
edt.Limits = [-5,5];
edt.Value = 3;
edt.Tooltip = "intercept";

% create a drop-down
dd = uidropdown(gl,'Items',{'None','Uniform','Normal'});
dd.Layout.Row = 1; dd.Layout.Column = 4;
dd.Value = 'None';

% create a slider
sld = uislider(gl);
sld.Layout.Row = 1; sld.Layout.Column = 5;
sld.Limits = [-10 10];
sld.Value = 0;
sld.Tooltip = "slope";

% create and lay out panel
pnl = uipanel(gl);
pnl.Layout.Row = 2;
pnl.Layout.Column = [1 5];
ax = axes(pnl); ax.NextPlot = 'add'; % for plotting
ax.XLim = [-1,1];
ax.YLim = [-15,15];

fig.UserData = struct("Edt",edt, "Dd", dd, ...
    "Sld",sld,"Axes",ax,"BtnDlt",btnDlt);
btn.ButtonPushedFcn = @CreateLine;

function CreateLine(src, event)
    fig = ancestor(src,"figure","toplevel");
    data = fig.UserData;
    if data.BtnDlt.Value
        delete(fig.Children.Children(end).Children.Children)
    end
    ax = data.Axes;
    edt_val = data.Edt.Value;
    sld_val = data.Sld.Value;
    dd_val = data.Dd.Value;
    x = linspace(-1,1,100); % str2double(edt_val)
    switch dd_val
        case 'None'
            plot(ax,x,edt_val+sld_val.*x); 
        case 'Uniform'
            plot(ax,x,edt_val+sld_val.*x+rand(size(x))); 
        case 'Normal'
            plot(ax,x,edt_val+sld_val.*x+randn(size(x))); 
        otherwise
            plot(ax,x,edt_val+sld_val.*x); 
    end
end