function varargout = HafniumPlotter_1_7(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name', mfilename,'gui_Singleton',  gui_Singleton,'gui_OpeningFcn', @HafniumPlotter_1_7_OpeningFcn,'gui_OutputFcn',  @HafniumPlotter_1_7_OutputFcn, ...
                   'gui_LayoutFcn',  [] ,'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function HafniumPlotter_1_7_OpeningFcn(hObject, eventdata, H, varargin)
H.output = hObject;
view([-37.5, 30]);
set(H.d3,'Value',1)
plot_Callback(hObject, eventdata, H)
guidata(hObject, H);

function varargout = HafniumPlotter_1_7_OutputFcn(hObject, eventdata, H) 
varargout{1} = H.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PUSH BUTTONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function uploaddata_Callback(hObject, eventdata, H)
[filename pathname] = uigetfile({'*'},'File Selector');
data = readtable(char(strcat(pathname, filename)));
data = table2array(data);
set(H.uitable1, 'Data', data);
data = get(H.uitable1, 'Data');
plot_Callback(hObject, eventdata, H)

function set_Callback(hObject, eventdata, H)
az = get(H.axes1, 'View');
set(H.azim,'String',round(az(1,1),1));
set(H.elev,'String',round(az(1,2),1));

function res_Callback(hObject, eventdata, H)
view([-37.5, 30]);
plot_Callback(hObject, eventdata, H)

function FAQs_Callback(hObject, eventdata, H)
Hafnium_Plotter_FAQs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plot_Callback(hObject, eventdata, H)

az = get(H.axes1, 'View');

data_tmp = get(H.uitable1, 'Data');

cla(H.axes1, 'reset');

if iscell(data_tmp) == 1
	data_tmp = cell2num(data_tmp);
end

for i = 1:length(data_tmp(:,1))
	if data_tmp(i,1) >= str2double(get(H.xmin,'String')) && data_tmp(i,1) <= str2double(get(H.xmax,'String'))
		data(i,:) = data_tmp(i,:);
	end
end

data = data(any(data ~= 0,2),:);

cla(H.axes1, 'reset');

global botev
global bandwidth_x
global bandwidth_y
global bandwidth_opt

rad_on=get(H.ui_bandwidth,'selectedobject');
switch rad_on
	case H.optimized
		botev = 1;
	case H.setbandwidth
		botev = 0;
bandwidth_x = str2double(get(H.setMyr,'String'));
bandwidth_y = str2double(get(H.set_eHf,'String'));
end

gridspc = 2^9;
MIN_XY=[str2double(get(H.xmin,'String')),str2double(get(H.ymin,'String'))];
MAX_XY=[str2double(get(H.xmax,'String')),str2double(get(H.ymax,'String'))];

[bandwidth,density,X,Y]=kde2d(data, gridspc, MIN_XY, MAX_XY);
density = density./sum(sum(density));

set(H.opt_Myr, 'String', round(bandwidth_opt(1,1),2));
set(H.opt_eHf, 'String', round(bandwidth_opt(1,2),2));

axes(H.axes1);
%legend(H.axes1, 'off'); 
hold on

if get(H.plot_heat,'Value')==1

	if get(H.transparency, 'Value') == 1
		transp = 1;
	elseif get(H.transparency, 'Value') == 2
		transp = 0.75;
	elseif get(H.transparency, 'Value') == 3
		transp = 0.5;
	elseif get(H.transparency, 'Value') == 4
		transp = 0.25;
	elseif get(H.transparency, 'Value') == 5
		transp = 0;
	end

	if get(H.colormap, 'Value') == 1
			colormap(parula)
	elseif get(H.colormap, 'Value') == 2	
			colormap(jet)
	elseif get(H.colormap, 'Value') == 3
			colormap(hsv)
	elseif get(H.colormap, 'Value') == 4
			colormap(hot)
	elseif get(H.colormap, 'Value') == 5
			colormap(cool)
	elseif get(H.colormap, 'Value') == 6
			colormap(spring)
	elseif get(H.colormap, 'Value') == 7
			colormap(summer)
	elseif get(H.colormap, 'Value') == 8
			colormap(winter)
	elseif get(H.colormap, 'Value') == 9
			colormap(gray)
	elseif get(H.colormap, 'Value') == 10
			colormap(bone)
	elseif get(H.colormap, 'Value') == 11
			colormap(copper)
	elseif get(H.colormap, 'Value') == 12
			colormap(pink)
	elseif get(H.colormap, 'Value') == 13
			colormap(lines)
	elseif get(H.colormap, 'Value') == 14
			colormap(colorcube)
	elseif get(H.colormap, 'Value') == 15
			colormap(prism)
	elseif get(H.colormap, 'Value') == 16
			colormap(flag)		
	end

	s = surf(X,Y,density,'FaceAlpha',transp,'EdgeColor','none');

	rad_on=get(H.ui_view,'selectedobject');
	switch rad_on
		case H.d2
			view(2)
		case H.d3
			view(3)
	end
	
	shading interp;
end

size = str2num(get(H.size,'String'));

if get(H.marker, 'Value') == 1
	mark = 'o';
elseif get(H.marker, 'Value') == 2
	mark = '+';
elseif get(H.marker, 'Value') == 3
	mark = '*';
elseif get(H.marker, 'Value') == 4
	mark = '.';
elseif get(H.marker, 'Value') == 5
	mark = 'x';
elseif get(H.marker, 'Value') == 6
	mark = 's';	
elseif get(H.marker, 'Value') == 7
	mark = 'd';
elseif get(H.marker, 'Value') == 8
	mark = '^';
elseif get(H.marker, 'Value') == 9
	mark = 'v';	
elseif get(H.marker, 'Value') == 10
	mark = '>';	
elseif get(H.marker, 'Value') == 11
	mark = '<';	
elseif get(H.marker, 'Value') == 12
	mark = 'p';	
elseif get(H.marker, 'Value') == 13
	mark = 'h';	
elseif get(H.marker, 'Value') == 14
	mark = 'none';	
end

if get(H.s_color, 'Value') == 1
	face = 'r';
elseif get(H.s_color, 'Value') == 2
	face = 'g';
elseif get(H.s_color, 'Value') == 3
	face = 'b';
elseif get(H.s_color, 'Value') == 4
	face = 'y';
elseif get(H.s_color, 'Value') == 5
	face = 'm';
elseif get(H.s_color, 'Value') == 6
	face = 'c';	
elseif get(H.s_color, 'Value') == 7
	face = 'w';
elseif get(H.s_color, 'Value') == 8
	face = 'k';
elseif get(H.s_color, 'Value') == 9
	face = 'none';	
end

if get(H.s_edge, 'Value') == 1
	edge = 'r';
elseif get(H.s_edge, 'Value') == 2
	edge = 'g';
elseif get(H.s_edge, 'Value') == 3
	edge = 'b';
elseif get(H.s_edge, 'Value') == 4
	edge = 'y';
elseif get(H.s_edge, 'Value') == 5
	edge = 'm';
elseif get(H.s_edge, 'Value') == 6
	edge = 'c';	
elseif get(H.s_edge, 'Value') == 7
	edge = 'w';
elseif get(H.s_edge, 'Value') == 8
	edge = 'k';
elseif get(H.s_edge, 'Value') == 9
	edge = 'none';	
end

if get(H.plot_scat,'Value')==1 	
	scatter3(data(:,1), data(:,2), ones(length(data(:,1)),1).*max(max(density)) + (ones(length(data(:,1)),1).*max(max(density)))*.05, size, ...
		mark, 'MarkerEdgeColor', edge, 'MarkerFaceColor', face, 'LineWidth', str2num(get(H.edge_t,'String')));
end

if get(H.plot_scat3,'Value')==1 	
	for i = 1:length(data(:,1))		
		tmpx = val2ind(X(1,:),data(i,1));
		tmpy = val2ind(Y(:,1),data(i,2));
		X_index(i,1) = tmpx(1,1);
		Y_index(i,1) = tmpy(1,1);
		clear tmpx
		clear tmpy
	end		
	for i = 1:length(data(:,1))	
		Z(i,1) = density(Y_index(i,1),X_index(i,1));
	end
	scatter3(data(:,1),data(:,2),Z + Z.*0.05, size, mark, 'MarkerEdgeColor', edge, 'MarkerFaceColor', face);
end

if get(H.plot_runmean,'Value')==1 	
	X1 = (data(:,1));
	Y1 = (data(:,2));
	[X_sorted, X_order] = sort(X1);
	Y_sorted = Y1(X_order,:);
	M = movmean(Y_sorted,str2double(get(H.runmean_n,'String')));
	if get(H.runmean_c, 'Value') == 1
		runmean_co = 'r';
	elseif get(H.runmean_c, 'Value') == 2
		runmean_co = 'g';
	elseif get(H.runmean_c, 'Value') == 3
		runmean_co = 'b';
	elseif get(H.runmean_c, 'Value') == 4
		runmean_co = 'y';
	elseif get(H.runmean_c, 'Value') == 5
		runmean_co = 'm';
	elseif get(H.runmean_c, 'Value') == 6
		runmean_co = 'c';	
	elseif get(H.runmean_c, 'Value') == 7
		runmean_co = 'w';
	elseif get(H.runmean_c, 'Value') == 8
		runmean_co = 'k';
	elseif get(H.runmean_c, 'Value') == 9
		runmean_co = 'none';	
	end
	p1 = plot3(X_sorted,M,ones(length(data(:,1)),1).*max(max(density)), 'LineWidth', str2num(get(H.runmean_w,'String')), 'Color', runmean_co);
end

if get(H.plot_runmedian,'Value')==1 	
	X1 = (data(:,1));
	Y1 = (data(:,2));
	[X_sorted, X_order] = sort(X1);
	Y_sorted = Y1(X_order,:);
	M2 = movmedian(Y_sorted,str2double(get(H.runmedian_n,'String')));
	if get(H.runmedian_c, 'Value') == 1
		runmedian_co = 'r';
	elseif get(H.runmedian_c, 'Value') == 2
		runmedian_co = 'g';
	elseif get(H.runmedian_c, 'Value') == 3
		runmedian_co = 'b';
	elseif get(H.runmedian_c, 'Value') == 4
		runmedian_co = 'y';
	elseif get(H.runmedian_c, 'Value') == 5
		runmedian_co = 'm';
	elseif get(H.runmedian_c, 'Value') == 6
		runmedian_co = 'c';	
	elseif get(H.runmedian_c, 'Value') == 7
		runmedian_co = 'w';
	elseif get(H.runmedian_c, 'Value') == 8
		runmedian_co = 'k';
	elseif get(H.runmedian_c, 'Value') == 9
		runmedian_co = 'none';	
	end
	p2 = plot3(X_sorted,M2,ones(length(data(:,1)),1).*max(max(density)), 'LineWidth', str2num(get(H.runmedian_w,'String')), 'Color', runmedian_co);
end

if get(H.plot_poly,'Value')==1 	
	X1 = (data(:,1));
	Y1 = (data(:,2));
	[X_sorted, X_order] = sort(X1);
	Y_sorted = Y1(X_order,:);
	p = polyfit(X_sorted, Y_sorted, str2double(get(H.poly_n,'String')));
	pp = polyval(p, X_sorted);
	if get(H.poly_c, 'Value') == 1
		poly_co = 'r';
	elseif get(H.poly_c, 'Value') == 2
		poly_co = 'g';
	elseif get(H.poly_c, 'Value') == 3
		poly_co = 'b';
	elseif get(H.poly_c, 'Value') == 4
		poly_co = 'y';
	elseif get(H.poly_c, 'Value') == 5
		poly_co = 'm';
	elseif get(H.poly_c, 'Value') == 6
		poly_co = 'c';	
	elseif get(H.poly_c, 'Value') == 7
		poly_co = 'w';
	elseif get(H.poly_c, 'Value') == 8
		poly_co = 'k';
	elseif get(H.poly_c, 'Value') == 9
		poly_co = 'none';	
	end
	p3 = plot3(X_sorted, pp, ones(length(data(:,1)),1).*max(max(density)), 'LineWidth', str2num(get(H.poly_w,'String')), 'Color', poly_co);
end

if get(H.plot_runmeanh,'Value')==1 
	[max_dens, max_dens_ind] = max(density,[],1);
	for i = 1:length(Y(:,1))
		Y2(1,i) = Y(max_dens_ind(1,i),1);
	end
	X2 = [X(1,:)]';
	Y2_movmean = movmean(Y2,str2double(get(H.runmeanh_n,'String')));
	for i = 1:length(Y2)
		tmpy = val2ind(Y(:,1),Y2_movmean(1,i));
		Y2_movmean_idx(1,i) = tmpy(1,1);
		clear tmpy
	end	
	for i = 1:length(Y2_movmean_idx)	
		M3z(i,1) = density(Y2_movmean_idx(1,i),i);
	end
	if get(H.runmeanh_c, 'Value') == 1
		runmeanh_co = 'r';
	elseif get(H.runmeanh_c, 'Value') == 2
		runmeanh_co = 'g';
	elseif get(H.runmeanh_c, 'Value') == 3
		runmeanh_co = 'b';
	elseif get(H.runmeanh_c, 'Value') == 4
		runmeanh_co = 'y';
	elseif get(H.runmeanh_c, 'Value') == 5
		runmeanh_co = 'm';
	elseif get(H.runmeanh_c, 'Value') == 6
		runmeanh_co = 'c';	
	elseif get(H.runmeanh_c, 'Value') == 7
		runmeanh_co = 'w';
	elseif get(H.runmeanh_c, 'Value') == 8
		runmeanh_co = 'k';
	elseif get(H.runmeanh_c, 'Value') == 9
		runmeanh_co = 'none';	
	end
	p4 = plot3(X2,Y2_movmean,M3z + max(M3z)*0.1, 'LineWidth', str2num(get(H.runmeanh_w,'String')), 'Color', runmeanh_co);
end

if get(H.plot_runmedianh,'Value')==1 
	[max_dens, max_dens_ind] = max(density,[],1);
	for i = 1:length(Y(:,1))
		Y2(1,i) = Y(max_dens_ind(1,i),1);
	end
	Y2_movmedian = movmedian(Y2,str2double(get(H.runmedianh_n,'String')));
	for i = 1:length(Y2)
		tmpy = val2ind(Y(:,1),Y2_movmedian(1,i));
		Y2_movmedian_idx(1,i) = tmpy(1,1);
		clear tmpy
	end	
	for i = 1:length(Y2_movmedian_idx)	
		M3z(i,1) = density(Y2_movmedian_idx(1,i),i);
	end
	if get(H.runmedianh_c, 'Value') == 1
		runmedianh_co = 'r';
	elseif get(H.runmedianh_c, 'Value') == 2
		runmedianh_co = 'g';
	elseif get(H.runmedianh_c, 'Value') == 3
		runmedianh_co = 'b';
	elseif get(H.runmedianh_c, 'Value') == 4
		runmedianh_co = 'y';
	elseif get(H.runmedianh_c, 'Value') == 5
		runmedianh_co = 'm';
	elseif get(H.runmedianh_c, 'Value') == 6
		runmedianh_co = 'c';	
	elseif get(H.runmedianh_c, 'Value') == 7
		runmedianh_co = 'w';
	elseif get(H.runmedianh_c, 'Value') == 8
		runmedianh_co = 'k';
	elseif get(H.runmedianh_c, 'Value') == 9
		runmedianh_co = 'none';	
	end
	p5 = plot3(X(1,:),Y2_movmedian,M3z + max(M3z)*0.1, 'LineWidth', str2num(get(H.runmedianh_w,'String')), 'Color', runmedianh_co);
end

if get(H.contour_color, 'Value') == 1
	cont = 'r';
elseif get(H.contour_color, 'Value') == 2
	cont = 'g';
elseif get(H.contour_color, 'Value') == 3
	cont = 'b';
elseif get(H.contour_color, 'Value') == 4
	cont = 'y';
elseif get(H.contour_color, 'Value') == 5
	cont = 'm';
elseif get(H.contour_color, 'Value') == 6
	cont = 'c';	
elseif get(H.contour_color, 'Value') == 7
	cont = 'w';
elseif get(H.contour_color, 'Value') == 8
	cont = 'k';
elseif get(H.contour_color, 'Value') == 9
	cont = 'none';	
end

max_density = max(max(density));
max_density_conf = max_density - max_density*str2num(get(H.conf,'String'))*.01;

if get(H.contour,'Value')==1 
	contour3(X,Y,density,cont, 'LineWidth', str2num(get(H.contour_w,'String')));
end

if get(H.contour_num,'Value')==1 
	contour3(X,Y,density,str2double(get(H.cont_num,'String')),cont,'LineWidth', str2num(get(H.contour_w,'String')));
end

if get(H.contour_vals,'Value')==1 
	contour3(X,Y,density,[max_density_conf max_density_conf],cont, 'LineWidth', str2num(get(H.contour_w,'String')));
end

axis([str2double(get(H.xmin,'String')),str2double(get(H.xmax,'String')),str2double(get(H.ymin,'String')),str2double(get(H.ymax,'String'))]);

set(H.axes1,'FontSize',str2num(get(H.fontsize,'String')));

if get(H.bold,'Value') == 1
	set(H.axes1,'FontWeight','bold');
end
	
view(az);

set(H.azim,'String',round(az(1,1),1));
set(H.elev,'String',round(az(1,2),1));

if get(H.d2,'Value') == 1
	view(2)
end

xlabel(get(H.x_lab,'String'));
ylabel(get(H.y_lab,'String'));
if get(H.d3,'Value') == 1
	zlabel(get(H.z_lab,'String'));
end

DM_Slider = str2num(get(H.dms,'String'));

Epsilon_plot = [16.5,14.6,0,15.6,0;15.0,13.0,500,14.0,0;13.4,11.5,1000,12.5,0;11.9,9.9,1500,10.9,0;10.3,8.3,2000,9.3,0; ...
	8.7,6.7,2500,7.7,0;5.4,3.4,3500,4.4,0;3.7,1.7,4000,2.7,0;2.0,0.0,4500,1.0,0];

Decay_const_176Lu = 0.01867; %176Lu decay constant (Scherer et al., 2001) 1.867*10^-11 (same as Soderland et al., 2004)
DM_176Hf_177Hf = 0.283225; %Vervoort and Blichert-Toft, 1999
DM_176Lu_177Hf = 0.0383; %Vervoort and Blichert-Toft, 1999
BSE_176Hf_177Hf = 0.282785; %Bouvier et al. 2008
BSE_176Lu_177Hf = 0.0336; %Bouvier et al. 2008

t_176Hf_177Hf = DM_176Hf_177Hf - (DM_176Lu_177Hf*(exp(Decay_const_176Lu*DM_Slider/1000)-1));

CHURt = BSE_176Hf_177Hf - (BSE_176Lu_177Hf*(exp(Decay_const_176Lu*DM_Slider/1000)-1));
 
DMpoint_Epsi_x = DM_Slider;
DMpoint_Epsi_y = 10000*((t_176Hf_177Hf/CHURt)-1);

Y0_Evol_DM_176Lu_177Hf = t_176Hf_177Hf + (0.0115*(exp(Decay_const_176Lu*DM_Slider/1000)-1));
Y0_u_Evol_DM_176Lu_177Hf = t_176Hf_177Hf + (0.0193*(exp(Decay_const_176Lu*DM_Slider/1000)-1));
Y0_l_Evol_DM_176Lu_177Hf = t_176Hf_177Hf + (0.0036*(exp(Decay_const_176Lu*DM_Slider/1000)-1));
Ys_Evol_DM_176Lu_177Hf = t_176Hf_177Hf;

Y0_Epsi_DM_176Lu_177Hf = 10000*((Y0_Evol_DM_176Lu_177Hf/BSE_176Hf_177Hf)-1);
Y0_u_Epsi_DM_176Lu_177Hf = 10000*((Y0_u_Evol_DM_176Lu_177Hf/BSE_176Hf_177Hf)-1);
Y0_l_Epsi_DM_176Lu_177Hf = 10000*((Y0_l_Evol_DM_176Lu_177Hf/BSE_176Hf_177Hf)-1);
Ys_Epsi_DM_176Lu_177Hf = DMpoint_Epsi_y;

if get(H.evol_color, 'Value') == 1
	evo = 'r';
elseif get(H.evol_color, 'Value') == 2
	evo = 'g';
elseif get(H.evol_color, 'Value') == 3
	evo = 'b';
elseif get(H.evol_color, 'Value') == 4
	evo = 'y';
elseif get(H.evol_color, 'Value') == 5
	evo = 'm';
elseif get(H.evol_color, 'Value') == 6
	evo = 'c';	
elseif get(H.evol_color, 'Value') == 7
	evo = 'w';
elseif get(H.evol_color, 'Value') == 8
	evo = 'k';
elseif get(H.evol_color, 'Value') == 9
	evo = 'none';	
end

if get(H.chur, 'Value') == 1
	plot3(Epsilon_plot(:,3),Epsilon_plot(:,5),ones(9,1).*max(max(density)),evo,'LineWidth',str2num(get(H.evo_t,'String')))
end

if get(H.DM, 'Value') == 1
	plot3(Epsilon_plot(:,3),Epsilon_plot(:,4),ones(9,1).*max(max(density)),evo,'LineWidth',str2num(get(H.evo_t,'String')))
	plot3(Epsilon_plot(:,3),Epsilon_plot(:,1),ones(9,1).*max(max(density)),strcat('--',evo),'LineWidth',str2num(get(H.evo_t,'String')))
	plot3(Epsilon_plot(:,3),Epsilon_plot(:,2),ones(9,1).*max(max(density)),strcat('--',evo),'LineWidth',str2num(get(H.evo_t,'String')))
end

if get(H.Y, 'Value') == 1
	plot3([0 DM_Slider],[Y0_u_Epsi_DM_176Lu_177Hf, Ys_Epsi_DM_176Lu_177Hf],ones(2,1).*max(max(density)), 'Color', evo, 'LineWidth', str2num(get(H.evo_t,'String')))
end
if get(H.Yu, 'Value') == 1
	plot3([0 DM_Slider],[Y0_Epsi_DM_176Lu_177Hf, Ys_Epsi_DM_176Lu_177Hf],ones(2,1).*max(max(density)), 'Color', evo, 'LineWidth', str2num(get(H.evo_t,'String')))
end
if get(H.Yl', 'Value') == 1
	plot3([0 DM_Slider],[Y0_l_Epsi_DM_176Lu_177Hf, Ys_Epsi_DM_176Lu_177Hf],ones(2,1).*max(max(density)), 'Color', evo, 'LineWidth', str2num(get(H.evo_t,'String')))
end

hold off
%set(gca, 'XDir','reverse')
guidata(hObject,H);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ui_bandwidth_SelectionChangedFcn(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)

function opt_Myr_Callback(hObject, eventdata, H)
function opt_Myr_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function opt_eHf_Callback(hObject, eventdata, H)
function opt_eHf_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function setMyr_Callback(hObject, eventdata, H)
set(H.setbandwidth,'Value',1);
plot_Callback(hObject, eventdata, H)
function setMyr_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function set_eHf_Callback(hObject, eventdata, H)
set(H.setbandwidth,'Value',1);
plot_Callback(hObject, eventdata, H)
function set_eHf_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function x_lab_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)
function x_lab_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function xmin_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)
function xmin_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function xmax_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)
function xmax_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function y_lab_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)
function y_lab_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ymin_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)
function ymin_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ymax_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)
function ymax_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function z_lab_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)
function z_lab_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fontsize_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)
function fontsize_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function bold_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)

function plot_runmean_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)

function runmean_n_Callback(hObject, eventdata, H)
set(H.plot_runmean,'Value',1);
plot_Callback(hObject, eventdata, H)
function runmean_n_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function runmean_c_Callback(hObject, eventdata, H)
set(H.plot_runmean,'Value',1);
plot_Callback(hObject, eventdata, H)
function runmean_c_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function runmean_w_Callback(hObject, eventdata, H)
set(H.plot_runmean,'Value',1);
plot_Callback(hObject, eventdata, H)
function runmean_w_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function plot_runmedian_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)

function runmedian_n_Callback(hObject, eventdata, H)
set(H.plot_runmedian,'Value',1);
plot_Callback(hObject, eventdata, H)
function runmedian_n_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function runmedian_c_Callback(hObject, eventdata, H)
set(H.plot_runmedian,'Value',1);
plot_Callback(hObject, eventdata, H)
function runmedian_c_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function runmedian_w_Callback(hObject, eventdata, H)
set(H.plot_runmedian,'Value',1);
plot_Callback(hObject, eventdata, H)
function runmedian_w_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function plot_poly_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)

function poly_n_Callback(hObject, eventdata, H)
set(H.plot_poly,'Value',1);
plot_Callback(hObject, eventdata, H)
function poly_n_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function poly_c_Callback(hObject, eventdata, H)
set(H.plot_poly,'Value',1);
plot_Callback(hObject, eventdata, H)
function poly_c_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function poly_w_Callback(hObject, eventdata, H)
set(H.plot_poly,'Value',1);
plot_Callback(hObject, eventdata, H)
function poly_w_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function plot_runmeanh_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)

function runmeanh_n_Callback(hObject, eventdata, H)
set(H.plot_runmeanh,'Value',1);
plot_Callback(hObject, eventdata, H)
function runmeanh_n_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function runmeanh_c_Callback(hObject, eventdata, H)
set(H.plot_runmeanh,'Value',1);
plot_Callback(hObject, eventdata, H)
function runmeanh_c_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function runmeanh_w_Callback(hObject, eventdata, H)
set(H.plot_runmeanh,'Value',1);
plot_Callback(hObject, eventdata, H)
function runmeanh_w_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function plot_runmedianh_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)

function runmedianh_n_Callback(hObject, eventdata, H)
set(H.plot_runmedianh,'Value',1);
plot_Callback(hObject, eventdata, H)
function runmedianh_n_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function runmedianh_c_Callback(hObject, eventdata, H)
set(H.plot_runmedianh,'Value',1);
plot_Callback(hObject, eventdata, H)
function runmedianh_c_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function runmedianh_w_Callback(hObject, eventdata, H)
set(H.plot_runmedianh,'Value',1);
plot_Callback(hObject, eventdata, H)
function runmedianh_w_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function uitable1_ButtonDownFcn(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)
function uitable1_DeleteFcn(hObject, eventdata, H)

function uitable1_CellEditCallback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)

function plot_heat_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)

function ui_view_SelectionChangedFcn(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)

function d2_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)

function d3_Callback(hObject, eventdata, H)
view(3)
plot_Callback(hObject, eventdata, H)

function colormap_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)
function colormap_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function transparency_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)
function transparency_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function azim_Callback(hObject, eventdata, H)
az = get(H.axes1, 'View');
view(str2num(get(H.azim,'String')),az(1,2));
plot_Callback(hObject, eventdata, H)
function azim_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function elev_Callback(hObject, eventdata, H)
az = get(H.axes1, 'View');
view(az(1,1),str2num(get(H.elev,'String')));
plot_Callback(hObject, eventdata, H)
function elev_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function evol_color_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)
function evol_color_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function DM_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)

function dms_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)
function dms_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function chur_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)

function Y_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)

function evol_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)
function evol_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function evo_t_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)
function evo_t_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Yu_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)

function Yl_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)

function plot_scat_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)

function plot_scat3_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)

function marker_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)
function marker_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function s_color_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)
function s_color_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function s_edge_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)
function s_edge_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function size_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)
function size_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edge_t_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)
function edge_t_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function contour_color_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)
function contour_color_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function contour_Callback(hObject, eventdata, H)
set(H.contour_num,'Value', 0)
set(H.contour_vals,'Value', 0)
plot_Callback(hObject, eventdata, H)

function contour_num_Callback(hObject, eventdata, H)
set(H.contour,'Value', 0)
set(H.contour_vals,'Value', 0)
plot_Callback(hObject, eventdata, H)

function cont_num_Callback(hObject, eventdata, H)
set(H.contour,'Value', 0)
set(H.contour_num,'Value', 1)
set(H.contour_vals,'Value', 0)
plot_Callback(hObject, eventdata, H)
function cont_num_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function contour_vals_Callback(hObject, eventdata, H)
set(H.contour,'Value', 0)
set(H.contour_num,'Value', 0)
plot_Callback(hObject, eventdata, H)

function conf_Callback(hObject, eventdata, H)
set(H.contour,'Value', 0)
set(H.contour_num,'Value', 0)
set(H.contour_vals,'Value', 1)
plot_Callback(hObject, eventdata, H)
function conf_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function contour_w_Callback(hObject, eventdata, H)
plot_Callback(hObject, eventdata, H)
function contour_w_CreateFcn(hObject, eventdata, H)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXPORT FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function export_figure_Callback(hObject, eventdata, H)

az = get(H.axes1, 'View');

data_tmp = get(H.uitable1, 'Data');

for i = 1:length(data_tmp(:,1))
	if data_tmp(i,1) >= str2double(get(H.xmin,'String')) && data_tmp(i,1) <= str2double(get(H.xmax,'String'))
		data(i,:) = data_tmp(i,:);
	end
end

data = data(any(data ~= 0,2),:);

global botev
global bandwidth_x
global bandwidth_y
global bandwidth_opt

rad_on=get(H.ui_bandwidth,'selectedobject');
switch rad_on
	case H.optimized
		botev = 1;
	case H.setbandwidth
		botev = 0;
bandwidth_x = str2double(get(H.setMyr,'String'));
bandwidth_y = str2double(get(H.set_eHf,'String'));
end

gridspc = 2^9;
MIN_XY=[str2double(get(H.xmin,'String')),str2double(get(H.ymin,'String'))];
MAX_XY=[str2double(get(H.xmax,'String')),str2double(get(H.ymax,'String'))];

[bandwidth,density,X,Y]=kde2d(data, gridspc, MIN_XY, MAX_XY);
density = density./sum(sum(density));

set(H.opt_Myr, 'String', round(bandwidth_opt(1,1),2));
set(H.opt_eHf, 'String', round(bandwidth_opt(1,2),2));

figure;
hold on

if get(H.plot_heat,'Value')==1

	if get(H.transparency, 'Value') == 1
		transp = 1;
	elseif get(H.transparency, 'Value') == 2
		transp = 0.75;
	elseif get(H.transparency, 'Value') == 3
		transp = 0.5;
	elseif get(H.transparency, 'Value') == 4
		transp = 0.25;
	elseif get(H.transparency, 'Value') == 5
		transp = 0;
	end

	if get(H.colormap, 'Value') == 1
			colormap(parula)
	elseif get(H.colormap, 'Value') == 2	
			colormap(jet)
	elseif get(H.colormap, 'Value') == 3
			colormap(hsv)
	elseif get(H.colormap, 'Value') == 4
			colormap(hot)
	elseif get(H.colormap, 'Value') == 5
			colormap(cool)
	elseif get(H.colormap, 'Value') == 6
			colormap(spring)
	elseif get(H.colormap, 'Value') == 7
			colormap(summer)
	elseif get(H.colormap, 'Value') == 8
			colormap(winter)
	elseif get(H.colormap, 'Value') == 9
			colormap(gray)
	elseif get(H.colormap, 'Value') == 10
			colormap(bone)
	elseif get(H.colormap, 'Value') == 11
			colormap(copper)
	elseif get(H.colormap, 'Value') == 12
			colormap(pink)
	elseif get(H.colormap, 'Value') == 13
			colormap(lines)
	elseif get(H.colormap, 'Value') == 14
			colormap(colorcube)
	elseif get(H.colormap, 'Value') == 15
			colormap(prism)
	elseif get(H.colormap, 'Value') == 16
			colormap(flag)		
	end

	s = surf(X,Y,density,'FaceAlpha',transp,'EdgeColor','none');

	rad_on=get(H.ui_view,'selectedobject');
	switch rad_on
		case H.d2
			view(2)
		case H.d3
			view(3)
	end
	
	shading interp;
end

size = str2num(get(H.size,'String'));

if get(H.marker, 'Value') == 1
	mark = 'o';
elseif get(H.marker, 'Value') == 2
	mark = '+';
elseif get(H.marker, 'Value') == 3
	mark = '*';
elseif get(H.marker, 'Value') == 4
	mark = '.';
elseif get(H.marker, 'Value') == 5
	mark = 'x';
elseif get(H.marker, 'Value') == 6
	mark = 's';	
elseif get(H.marker, 'Value') == 7
	mark = 'd';
elseif get(H.marker, 'Value') == 8
	mark = '^';
elseif get(H.marker, 'Value') == 9
	mark = 'v';	
elseif get(H.marker, 'Value') == 10
	mark = '>';	
elseif get(H.marker, 'Value') == 11
	mark = '<';	
elseif get(H.marker, 'Value') == 12
	mark = 'p';	
elseif get(H.marker, 'Value') == 13
	mark = 'h';	
elseif get(H.marker, 'Value') == 14
	mark = 'none';	
end

if get(H.s_color, 'Value') == 1
	face = 'r';
elseif get(H.s_color, 'Value') == 2
	face = 'g';
elseif get(H.s_color, 'Value') == 3
	face = 'b';
elseif get(H.s_color, 'Value') == 4
	face = 'y';
elseif get(H.s_color, 'Value') == 5
	face = 'm';
elseif get(H.s_color, 'Value') == 6
	face = 'c';	
elseif get(H.s_color, 'Value') == 7
	face = 'w';
elseif get(H.s_color, 'Value') == 8
	face = 'k';
elseif get(H.s_color, 'Value') == 9
	face = 'none';	
end

if get(H.s_edge, 'Value') == 1
	edge = 'r';
elseif get(H.s_edge, 'Value') == 2
	edge = 'g';
elseif get(H.s_edge, 'Value') == 3
	edge = 'b';
elseif get(H.s_edge, 'Value') == 4
	edge = 'y';
elseif get(H.s_edge, 'Value') == 5
	edge = 'm';
elseif get(H.s_edge, 'Value') == 6
	edge = 'c';	
elseif get(H.s_edge, 'Value') == 7
	edge = 'w';
elseif get(H.s_edge, 'Value') == 8
	edge = 'k';
elseif get(H.s_edge, 'Value') == 9
	edge = 'none';	
end

if get(H.plot_scat,'Value')==1 	
	scatter3(data(:,1), data(:,2), ones(length(data(:,1)),1).*max(max(density)) + (ones(length(data(:,1)),1).*max(max(density)))*.05, size, ...
		mark, 'MarkerEdgeColor', edge, 'MarkerFaceColor', face, 'LineWidth', str2num(get(H.edge_t,'String')));
end

if get(H.plot_scat3,'Value')==1 	
	for i = 1:length(data(:,1))		
		tmpx = val2ind(X(1,:),data(i,1));
		tmpy = val2ind(Y(:,1),data(i,2));
		X_index(i,1) = tmpx(1,1);
		Y_index(i,1) = tmpy(1,1);
		clear tmpx
		clear tmpy
	end		
	for i = 1:length(data(:,1))	
		Z(i,1) = density(Y_index(i,1),X_index(i,1));
	end
	scatter3(data(:,1),data(:,2),Z + Z.*0.05, size, mark, 'MarkerEdgeColor', edge, 'MarkerFaceColor', face);
end

if get(H.plot_runmean,'Value')==1 	
	X1 = (data(:,1));
	Y1 = (data(:,2));
	[X_sorted, X_order] = sort(X1);
	Y_sorted = Y1(X_order,:);
	M = movmean(Y_sorted,str2double(get(H.runmean_n,'String')));
	if get(H.runmean_c, 'Value') == 1
		runmean_co = 'r';
	elseif get(H.runmean_c, 'Value') == 2
		runmean_co = 'g';
	elseif get(H.runmean_c, 'Value') == 3
		runmean_co = 'b';
	elseif get(H.runmean_c, 'Value') == 4
		runmean_co = 'y';
	elseif get(H.runmean_c, 'Value') == 5
		runmean_co = 'm';
	elseif get(H.runmean_c, 'Value') == 6
		runmean_co = 'c';	
	elseif get(H.runmean_c, 'Value') == 7
		runmean_co = 'w';
	elseif get(H.runmean_c, 'Value') == 8
		runmean_co = 'k';
	elseif get(H.runmean_c, 'Value') == 9
		runmean_co = 'none';	
	end
	p1 = plot3(X_sorted,M,ones(length(data(:,1)),1).*max(max(density)), 'LineWidth', str2num(get(H.runmean_w,'String')), 'Color', runmean_co);
end

if get(H.plot_runmedian,'Value')==1 	
	X1 = (data(:,1));
	Y1 = (data(:,2));
	[X_sorted, X_order] = sort(X1);
	Y_sorted = Y1(X_order,:);
	M2 = movmedian(Y_sorted,str2double(get(H.runmedian_n,'String')));
	if get(H.runmedian_c, 'Value') == 1
		runmedian_co = 'r';
	elseif get(H.runmedian_c, 'Value') == 2
		runmedian_co = 'g';
	elseif get(H.runmedian_c, 'Value') == 3
		runmedian_co = 'b';
	elseif get(H.runmedian_c, 'Value') == 4
		runmedian_co = 'y';
	elseif get(H.runmedian_c, 'Value') == 5
		runmedian_co = 'm';
	elseif get(H.runmedian_c, 'Value') == 6
		runmedian_co = 'c';	
	elseif get(H.runmedian_c, 'Value') == 7
		runmedian_co = 'w';
	elseif get(H.runmedian_c, 'Value') == 8
		runmedian_co = 'k';
	elseif get(H.runmedian_c, 'Value') == 9
		runmedian_co = 'none';	
	end
	p2 = plot3(X_sorted,M2,ones(length(data(:,1)),1).*max(max(density)), 'LineWidth', str2num(get(H.runmedian_w,'String')), 'Color', runmedian_co);
end

if get(H.plot_poly,'Value')==1 	
	X1 = (data(:,1));
	Y1 = (data(:,2));
	[X_sorted, X_order] = sort(X1);
	Y_sorted = Y1(X_order,:);
	p = polyfit(X_sorted, Y_sorted, str2double(get(H.poly_n,'String')));
	pp = polyval(p, X_sorted);
	if get(H.poly_c, 'Value') == 1
		poly_co = 'r';
	elseif get(H.poly_c, 'Value') == 2
		poly_co = 'g';
	elseif get(H.poly_c, 'Value') == 3
		poly_co = 'b';
	elseif get(H.poly_c, 'Value') == 4
		poly_co = 'y';
	elseif get(H.poly_c, 'Value') == 5
		poly_co = 'm';
	elseif get(H.poly_c, 'Value') == 6
		poly_co = 'c';	
	elseif get(H.poly_c, 'Value') == 7
		poly_co = 'w';
	elseif get(H.poly_c, 'Value') == 8
		poly_co = 'k';
	elseif get(H.poly_c, 'Value') == 9
		poly_co = 'none';	
	end
	p3 = plot3(X_sorted, pp, ones(length(data(:,1)),1).*max(max(density)), 'LineWidth', str2num(get(H.poly_w,'String')), 'Color', poly_co);
end

if get(H.plot_runmeanh,'Value')==1 
	[max_dens, max_dens_ind] = max(density,[],1);
	for i = 1:length(Y(:,1))
		Y2(1,i) = Y(max_dens_ind(1,i),1);
	end
	X2 = [X(1,:)]';
	Y2_movmean = movmean(Y2,str2double(get(H.runmeanh_n,'String')));
	for i = 1:length(Y2)
		tmpy = val2ind(Y(:,1),Y2_movmean(1,i));
		Y2_movmean_idx(1,i) = tmpy(1,1);
		clear tmpy
	end	
	for i = 1:length(Y2_movmean_idx)	
		M3z(i,1) = density(Y2_movmean_idx(1,i),i);
	end
	if get(H.runmeanh_c, 'Value') == 1
		runmeanh_co = 'r';
	elseif get(H.runmeanh_c, 'Value') == 2
		runmeanh_co = 'g';
	elseif get(H.runmeanh_c, 'Value') == 3
		runmeanh_co = 'b';
	elseif get(H.runmeanh_c, 'Value') == 4
		runmeanh_co = 'y';
	elseif get(H.runmeanh_c, 'Value') == 5
		runmeanh_co = 'm';
	elseif get(H.runmeanh_c, 'Value') == 6
		runmeanh_co = 'c';	
	elseif get(H.runmeanh_c, 'Value') == 7
		runmeanh_co = 'w';
	elseif get(H.runmeanh_c, 'Value') == 8
		runmeanh_co = 'k';
	elseif get(H.runmeanh_c, 'Value') == 9
		runmeanh_co = 'none';	
	end
	p4 = plot3(X2,Y2_movmean,M3z + max(M3z)*0.1, 'LineWidth', str2num(get(H.runmeanh_w,'String')), 'Color', runmeanh_co);
end

if get(H.plot_runmedianh,'Value')==1 
	[max_dens, max_dens_ind] = max(density,[],1);
	for i = 1:length(Y(:,1))
		Y2(1,i) = Y(max_dens_ind(1,i),1);
	end
	Y2_movmedian = movmedian(Y2,str2double(get(H.runmedianh_n,'String')));
	for i = 1:length(Y2)
		tmpy = val2ind(Y(:,1),Y2_movmedian(1,i));
		Y2_movmedian_idx(1,i) = tmpy(1,1);
		clear tmpy
	end	
	for i = 1:length(Y2_movmedian_idx)	
		M3z(i,1) = density(Y2_movmedian_idx(1,i),i);
	end
	if get(H.runmedianh_c, 'Value') == 1
		runmedianh_co = 'r';
	elseif get(H.runmedianh_c, 'Value') == 2
		runmedianh_co = 'g';
	elseif get(H.runmedianh_c, 'Value') == 3
		runmedianh_co = 'b';
	elseif get(H.runmedianh_c, 'Value') == 4
		runmedianh_co = 'y';
	elseif get(H.runmedianh_c, 'Value') == 5
		runmedianh_co = 'm';
	elseif get(H.runmedianh_c, 'Value') == 6
		runmedianh_co = 'c';	
	elseif get(H.runmedianh_c, 'Value') == 7
		runmedianh_co = 'w';
	elseif get(H.runmedianh_c, 'Value') == 8
		runmedianh_co = 'k';
	elseif get(H.runmedianh_c, 'Value') == 9
		runmedianh_co = 'none';	
	end
	p5 = plot3(X(1,:),Y2_movmedian,M3z + max(M3z)*0.1, 'LineWidth', str2num(get(H.runmedianh_w,'String')), 'Color', runmedianh_co);
end

if get(H.contour_color, 'Value') == 1
	cont = 'r';
elseif get(H.contour_color, 'Value') == 2
	cont = 'g';
elseif get(H.contour_color, 'Value') == 3
	cont = 'b';
elseif get(H.contour_color, 'Value') == 4
	cont = 'y';
elseif get(H.contour_color, 'Value') == 5
	cont = 'm';
elseif get(H.contour_color, 'Value') == 6
	cont = 'c';	
elseif get(H.contour_color, 'Value') == 7
	cont = 'w';
elseif get(H.contour_color, 'Value') == 8
	cont = 'k';
elseif get(H.contour_color, 'Value') == 9
	cont = 'none';	
end

max_density = max(max(density));
max_density_conf = max_density - max_density*str2num(get(H.conf,'String'))*.01;

if get(H.contour,'Value')==1 
	contour3(X,Y,density,cont, 'LineWidth', str2num(get(H.contour_w,'String')));
end

if get(H.contour_num,'Value')==1 
	contour3(X,Y,density,str2double(get(H.cont_num,'String')),cont,'LineWidth', str2num(get(H.contour_w,'String')));
end

if get(H.contour_vals,'Value')==1 
	contour3(X,Y,density,[max_density_conf max_density_conf],cont, 'LineWidth', str2num(get(H.contour_w,'String')));
end

axis([str2double(get(H.xmin,'String')),str2double(get(H.xmax,'String')),str2double(get(H.ymin,'String')),str2double(get(H.ymax,'String'))]);

set(H.axes1,'FontSize',str2num(get(H.fontsize,'String')));

if get(H.bold,'Value') == 1
	set(H.axes1,'FontWeight','bold');
end

view(az);

set(H.azim,'String',round(az(1,1),1));
set(H.elev,'String',round(az(1,2),1));

if get(H.d2,'Value') == 1
	view(2)
end

xlabel(get(H.x_lab,'String'));
ylabel(get(H.y_lab,'String'));
if get(H.d3,'Value') == 1
	zlabel(get(H.z_lab,'String'));
end

DM_Slider = str2num(get(H.dms,'String'));

Epsilon_plot = [16.5,14.6,0,15.6,0;15.0,13.0,500,14.0,0;13.4,11.5,1000,12.5,0;11.9,9.9,1500,10.9,0;10.3,8.3,2000,9.3,0; ...
	8.7,6.7,2500,7.7,0;5.4,3.4,3500,4.4,0;3.7,1.7,4000,2.7,0;2.0,0.0,4500,1.0,0];

Decay_const_176Lu = 0.01867; %176Lu decay constant (Scherer et al., 2001) 1.867*10^-11 (same as Soderland et al., 2004)
DM_176Hf_177Hf = 0.283225; %Vervoort and Blichert-Toft, 1999
DM_176Lu_177Hf = 0.0383; %Vervoort and Blichert-Toft, 1999
BSE_176Hf_177Hf = 0.282785; %Bouvier et al. 2008
BSE_176Lu_177Hf = 0.0336; %Bouvier et al. 2008

t_176Hf_177Hf = DM_176Hf_177Hf - (DM_176Lu_177Hf*(exp(Decay_const_176Lu*DM_Slider/1000)-1));

CHURt = BSE_176Hf_177Hf - (BSE_176Lu_177Hf*(exp(Decay_const_176Lu*DM_Slider/1000)-1));
 
DMpoint_Epsi_x = DM_Slider;
DMpoint_Epsi_y = 10000*((t_176Hf_177Hf/CHURt)-1);

Y0_Evol_DM_176Lu_177Hf = t_176Hf_177Hf + (0.0115*(exp(Decay_const_176Lu*DM_Slider/1000)-1));
Y0_u_Evol_DM_176Lu_177Hf = t_176Hf_177Hf + (0.0193*(exp(Decay_const_176Lu*DM_Slider/1000)-1));
Y0_l_Evol_DM_176Lu_177Hf = t_176Hf_177Hf + (0.0036*(exp(Decay_const_176Lu*DM_Slider/1000)-1));
Ys_Evol_DM_176Lu_177Hf = t_176Hf_177Hf;

Y0_Epsi_DM_176Lu_177Hf = 10000*((Y0_Evol_DM_176Lu_177Hf/BSE_176Hf_177Hf)-1);
Y0_u_Epsi_DM_176Lu_177Hf = 10000*((Y0_u_Evol_DM_176Lu_177Hf/BSE_176Hf_177Hf)-1);
Y0_l_Epsi_DM_176Lu_177Hf = 10000*((Y0_l_Evol_DM_176Lu_177Hf/BSE_176Hf_177Hf)-1);
Ys_Epsi_DM_176Lu_177Hf = DMpoint_Epsi_y;

if get(H.evol_color, 'Value') == 1
	evo = 'r';
elseif get(H.evol_color, 'Value') == 2
	evo = 'g';
elseif get(H.evol_color, 'Value') == 3
	evo = 'b';
elseif get(H.evol_color, 'Value') == 4
	evo = 'y';
elseif get(H.evol_color, 'Value') == 5
	evo = 'm';
elseif get(H.evol_color, 'Value') == 6
	evo = 'c';	
elseif get(H.evol_color, 'Value') == 7
	evo = 'w';
elseif get(H.evol_color, 'Value') == 8
	evo = 'k';
elseif get(H.evol_color, 'Value') == 9
	evo = 'none';	
end

if get(H.chur, 'Value') == 1
	plot3(Epsilon_plot(:,3),Epsilon_plot(:,5),ones(9,1).*max(max(density)),evo,'LineWidth',str2num(get(H.evo_t,'String')))
end

if get(H.DM, 'Value') == 1
	plot3(Epsilon_plot(:,3),Epsilon_plot(:,4),ones(9,1).*max(max(density)),evo,'LineWidth',str2num(get(H.evo_t,'String')))
	plot3(Epsilon_plot(:,3),Epsilon_plot(:,1),ones(9,1).*max(max(density)),strcat('--',evo),'LineWidth',str2num(get(H.evo_t,'String')))
	plot3(Epsilon_plot(:,3),Epsilon_plot(:,2),ones(9,1).*max(max(density)),strcat('--',evo),'LineWidth',str2num(get(H.evo_t,'String')))
end

if get(H.Y, 'Value') == 1
	plot3([0 DM_Slider],[Y0_u_Epsi_DM_176Lu_177Hf, Ys_Epsi_DM_176Lu_177Hf],ones(2,1).*max(max(density)), 'Color', evo, 'LineWidth', str2num(get(H.evo_t,'String')))
end
if get(H.Yu, 'Value') == 1
	plot3([0 DM_Slider],[Y0_Epsi_DM_176Lu_177Hf, Ys_Epsi_DM_176Lu_177Hf],ones(2,1).*max(max(density)), 'Color', evo, 'LineWidth', str2num(get(H.evo_t,'String')))
end
if get(H.Yl', 'Value') == 1
	plot3([0 DM_Slider],[Y0_l_Epsi_DM_176Lu_177Hf, Ys_Epsi_DM_176Lu_177Hf],ones(2,1).*max(max(density)), 'Color', evo, 'LineWidth', str2num(get(H.evo_t,'String')))
end

hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SAVE FIGURE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function save_plot_Callback(hObject, eventdata, H)

az = get(H.axes1, 'View');

data_tmp = get(H.uitable1, 'Data');

%cla(H.axes1, 'reset');

if iscell(data_tmp) == 1
	data_tmp = cell2num(data_tmp);
end

for i = 1:length(data_tmp(:,1))
	if data_tmp(i,1) >= str2double(get(H.xmin,'String')) && data_tmp(i,1) <= str2double(get(H.xmax,'String'))
		data(i,:) = data_tmp(i,:);
	end
end

data = data(any(data ~= 0,2),:);

%cla(H.axes1, 'reset');

global botev
global bandwidth_x
global bandwidth_y
global bandwidth_opt

rad_on=get(H.ui_bandwidth,'selectedobject');
switch rad_on
	case H.optimized
		botev = 1;
	case H.setbandwidth
		botev = 0;
bandwidth_x = str2double(get(H.setMyr,'String'));
bandwidth_y = str2double(get(H.set_eHf,'String'));
end

gridspc = 2^9;
MIN_XY=[str2double(get(H.xmin,'String')),str2double(get(H.ymin,'String'))];
MAX_XY=[str2double(get(H.xmax,'String')),str2double(get(H.ymax,'String'))];

[bandwidth,density,X,Y]=kde2d(data, gridspc, MIN_XY, MAX_XY);
density = density./sum(sum(density));

set(H.opt_Myr, 'String', round(bandwidth_opt(1,1),2));
set(H.opt_eHf, 'String', round(bandwidth_opt(1,2),2));

FIG = figure('visible', 'off');
%legend(H.axes1, 'off'); 
hold on

if get(H.plot_heat,'Value')==1

	if get(H.transparency, 'Value') == 1
		transp = 1;
	elseif get(H.transparency, 'Value') == 2
		transp = 0.75;
	elseif get(H.transparency, 'Value') == 3
		transp = 0.5;
	elseif get(H.transparency, 'Value') == 4
		transp = 0.25;
	elseif get(H.transparency, 'Value') == 5
		transp = 0;
	end

	if get(H.colormap, 'Value') == 1
			colormap(parula)
	elseif get(H.colormap, 'Value') == 2	
			colormap(jet)
	elseif get(H.colormap, 'Value') == 3
			colormap(hsv)
	elseif get(H.colormap, 'Value') == 4
			colormap(hot)
	elseif get(H.colormap, 'Value') == 5
			colormap(cool)
	elseif get(H.colormap, 'Value') == 6
			colormap(spring)
	elseif get(H.colormap, 'Value') == 7
			colormap(summer)
	elseif get(H.colormap, 'Value') == 8
			colormap(winter)
	elseif get(H.colormap, 'Value') == 9
			colormap(gray)
	elseif get(H.colormap, 'Value') == 10
			colormap(bone)
	elseif get(H.colormap, 'Value') == 11
			colormap(copper)
	elseif get(H.colormap, 'Value') == 12
			colormap(pink)
	elseif get(H.colormap, 'Value') == 13
			colormap(lines)
	elseif get(H.colormap, 'Value') == 14
			colormap(colorcube)
	elseif get(H.colormap, 'Value') == 15
			colormap(prism)
	elseif get(H.colormap, 'Value') == 16
			colormap(flag)		
	end

	s = surf(X,Y,density,'FaceAlpha',transp,'EdgeColor','none');

	rad_on=get(H.ui_view,'selectedobject');
	switch rad_on
		case H.d2
			view(2)
		case H.d3
			view(3)
	end
	
	shading interp;
end

size = str2num(get(H.size,'String'));

if get(H.marker, 'Value') == 1
	mark = 'o';
elseif get(H.marker, 'Value') == 2
	mark = '+';
elseif get(H.marker, 'Value') == 3
	mark = '*';
elseif get(H.marker, 'Value') == 4
	mark = '.';
elseif get(H.marker, 'Value') == 5
	mark = 'x';
elseif get(H.marker, 'Value') == 6
	mark = 's';	
elseif get(H.marker, 'Value') == 7
	mark = 'd';
elseif get(H.marker, 'Value') == 8
	mark = '^';
elseif get(H.marker, 'Value') == 9
	mark = 'v';	
elseif get(H.marker, 'Value') == 10
	mark = '>';	
elseif get(H.marker, 'Value') == 11
	mark = '<';	
elseif get(H.marker, 'Value') == 12
	mark = 'p';	
elseif get(H.marker, 'Value') == 13
	mark = 'h';	
elseif get(H.marker, 'Value') == 14
	mark = 'none';	
end

if get(H.s_color, 'Value') == 1
	face = 'r';
elseif get(H.s_color, 'Value') == 2
	face = 'g';
elseif get(H.s_color, 'Value') == 3
	face = 'b';
elseif get(H.s_color, 'Value') == 4
	face = 'y';
elseif get(H.s_color, 'Value') == 5
	face = 'm';
elseif get(H.s_color, 'Value') == 6
	face = 'c';	
elseif get(H.s_color, 'Value') == 7
	face = 'w';
elseif get(H.s_color, 'Value') == 8
	face = 'k';
elseif get(H.s_color, 'Value') == 9
	face = 'none';	
end

if get(H.s_edge, 'Value') == 1
	edge = 'r';
elseif get(H.s_edge, 'Value') == 2
	edge = 'g';
elseif get(H.s_edge, 'Value') == 3
	edge = 'b';
elseif get(H.s_edge, 'Value') == 4
	edge = 'y';
elseif get(H.s_edge, 'Value') == 5
	edge = 'm';
elseif get(H.s_edge, 'Value') == 6
	edge = 'c';	
elseif get(H.s_edge, 'Value') == 7
	edge = 'w';
elseif get(H.s_edge, 'Value') == 8
	edge = 'k';
elseif get(H.s_edge, 'Value') == 9
	edge = 'none';	
end

if get(H.plot_scat,'Value')==1 	
	scatter3(data(:,1), data(:,2), ones(length(data(:,1)),1).*max(max(density)) + (ones(length(data(:,1)),1).*max(max(density)))*.05, size, ...
		mark, 'MarkerEdgeColor', edge, 'MarkerFaceColor', face, 'LineWidth', str2num(get(H.edge_t,'String')));
end

if get(H.plot_scat3,'Value')==1 	
	for i = 1:length(data(:,1))		
		tmpx = val2ind(X(1,:),data(i,1));
		tmpy = val2ind(Y(:,1),data(i,2));
		X_index(i,1) = tmpx(1,1);
		Y_index(i,1) = tmpy(1,1);
		clear tmpx
		clear tmpy
	end		
	for i = 1:length(data(:,1))	
		Z(i,1) = density(Y_index(i,1),X_index(i,1));
	end
	scatter3(data(:,1),data(:,2),Z + Z.*0.05, size, mark, 'MarkerEdgeColor', edge, 'MarkerFaceColor', face);
end

if get(H.plot_runmean,'Value')==1 	
	X1 = (data(:,1));
	Y1 = (data(:,2));
	[X_sorted, X_order] = sort(X1);
	Y_sorted = Y1(X_order,:);
	M = movmean(Y_sorted,str2double(get(H.runmean_n,'String')));
	if get(H.runmean_c, 'Value') == 1
		runmean_co = 'r';
	elseif get(H.runmean_c, 'Value') == 2
		runmean_co = 'g';
	elseif get(H.runmean_c, 'Value') == 3
		runmean_co = 'b';
	elseif get(H.runmean_c, 'Value') == 4
		runmean_co = 'y';
	elseif get(H.runmean_c, 'Value') == 5
		runmean_co = 'm';
	elseif get(H.runmean_c, 'Value') == 6
		runmean_co = 'c';	
	elseif get(H.runmean_c, 'Value') == 7
		runmean_co = 'w';
	elseif get(H.runmean_c, 'Value') == 8
		runmean_co = 'k';
	elseif get(H.runmean_c, 'Value') == 9
		runmean_co = 'none';	
	end
	p1 = plot3(X_sorted,M,ones(length(data(:,1)),1).*max(max(density)), 'LineWidth', str2num(get(H.runmean_w,'String')), 'Color', runmean_co);
end

if get(H.plot_runmedian,'Value')==1 	
	X1 = (data(:,1));
	Y1 = (data(:,2));
	[X_sorted, X_order] = sort(X1);
	Y_sorted = Y1(X_order,:);
	M2 = movmedian(Y_sorted,str2double(get(H.runmedian_n,'String')));
	if get(H.runmedian_c, 'Value') == 1
		runmedian_co = 'r';
	elseif get(H.runmedian_c, 'Value') == 2
		runmedian_co = 'g';
	elseif get(H.runmedian_c, 'Value') == 3
		runmedian_co = 'b';
	elseif get(H.runmedian_c, 'Value') == 4
		runmedian_co = 'y';
	elseif get(H.runmedian_c, 'Value') == 5
		runmedian_co = 'm';
	elseif get(H.runmedian_c, 'Value') == 6
		runmedian_co = 'c';	
	elseif get(H.runmedian_c, 'Value') == 7
		runmedian_co = 'w';
	elseif get(H.runmedian_c, 'Value') == 8
		runmedian_co = 'k';
	elseif get(H.runmedian_c, 'Value') == 9
		runmedian_co = 'none';	
	end
	p2 = plot3(X_sorted,M2,ones(length(data(:,1)),1).*max(max(density)), 'LineWidth', str2num(get(H.runmedian_w,'String')), 'Color', runmedian_co);
end

if get(H.plot_poly,'Value')==1 	
	X1 = (data(:,1));
	Y1 = (data(:,2));
	[X_sorted, X_order] = sort(X1);
	Y_sorted = Y1(X_order,:);
	p = polyfit(X_sorted, Y_sorted, str2double(get(H.poly_n,'String')));
	pp = polyval(p, X_sorted);
	if get(H.poly_c, 'Value') == 1
		poly_co = 'r';
	elseif get(H.poly_c, 'Value') == 2
		poly_co = 'g';
	elseif get(H.poly_c, 'Value') == 3
		poly_co = 'b';
	elseif get(H.poly_c, 'Value') == 4
		poly_co = 'y';
	elseif get(H.poly_c, 'Value') == 5
		poly_co = 'm';
	elseif get(H.poly_c, 'Value') == 6
		poly_co = 'c';	
	elseif get(H.poly_c, 'Value') == 7
		poly_co = 'w';
	elseif get(H.poly_c, 'Value') == 8
		poly_co = 'k';
	elseif get(H.poly_c, 'Value') == 9
		poly_co = 'none';	
	end
	p3 = plot3(X_sorted, pp, ones(length(data(:,1)),1).*max(max(density)), 'LineWidth', str2num(get(H.poly_w,'String')), 'Color', poly_co);
end

if get(H.plot_runmeanh,'Value')==1 
	[max_dens, max_dens_ind] = max(density,[],1);
	for i = 1:length(Y(:,1))
		Y2(1,i) = Y(max_dens_ind(1,i),1);
	end
	X2 = [X(1,:)]';
	Y2_movmean = movmean(Y2,str2double(get(H.runmeanh_n,'String')));
	for i = 1:length(Y2)
		tmpy = val2ind(Y(:,1),Y2_movmean(1,i));
		Y2_movmean_idx(1,i) = tmpy(1,1);
		clear tmpy
	end	
	for i = 1:length(Y2_movmean_idx)	
		M3z(i,1) = density(Y2_movmean_idx(1,i),i);
	end
	if get(H.runmeanh_c, 'Value') == 1
		runmeanh_co = 'r';
	elseif get(H.runmeanh_c, 'Value') == 2
		runmeanh_co = 'g';
	elseif get(H.runmeanh_c, 'Value') == 3
		runmeanh_co = 'b';
	elseif get(H.runmeanh_c, 'Value') == 4
		runmeanh_co = 'y';
	elseif get(H.runmeanh_c, 'Value') == 5
		runmeanh_co = 'm';
	elseif get(H.runmeanh_c, 'Value') == 6
		runmeanh_co = 'c';	
	elseif get(H.runmeanh_c, 'Value') == 7
		runmeanh_co = 'w';
	elseif get(H.runmeanh_c, 'Value') == 8
		runmeanh_co = 'k';
	elseif get(H.runmeanh_c, 'Value') == 9
		runmeanh_co = 'none';	
	end
	p4 = plot3(X2,Y2_movmean,M3z + max(M3z)*0.1, 'LineWidth', str2num(get(H.runmeanh_w,'String')), 'Color', runmeanh_co);
end

if get(H.plot_runmedianh,'Value')==1 
	[max_dens, max_dens_ind] = max(density,[],1);
	for i = 1:length(Y(:,1))
		Y2(1,i) = Y(max_dens_ind(1,i),1);
	end
	Y2_movmedian = movmedian(Y2,str2double(get(H.runmedianh_n,'String')));
	for i = 1:length(Y2)
		tmpy = val2ind(Y(:,1),Y2_movmedian(1,i));
		Y2_movmedian_idx(1,i) = tmpy(1,1);
		clear tmpy
	end	
	for i = 1:length(Y2_movmedian_idx)	
		M3z(i,1) = density(Y2_movmedian_idx(1,i),i);
	end
	if get(H.runmedianh_c, 'Value') == 1
		runmedianh_co = 'r';
	elseif get(H.runmedianh_c, 'Value') == 2
		runmedianh_co = 'g';
	elseif get(H.runmedianh_c, 'Value') == 3
		runmedianh_co = 'b';
	elseif get(H.runmedianh_c, 'Value') == 4
		runmedianh_co = 'y';
	elseif get(H.runmedianh_c, 'Value') == 5
		runmedianh_co = 'm';
	elseif get(H.runmedianh_c, 'Value') == 6
		runmedianh_co = 'c';	
	elseif get(H.runmedianh_c, 'Value') == 7
		runmedianh_co = 'w';
	elseif get(H.runmedianh_c, 'Value') == 8
		runmedianh_co = 'k';
	elseif get(H.runmedianh_c, 'Value') == 9
		runmedianh_co = 'none';	
	end
	p5 = plot3(X(1,:),Y2_movmedian,M3z + max(M3z)*0.1, 'LineWidth', str2num(get(H.runmedianh_w,'String')), 'Color', runmedianh_co);
end

if get(H.contour_color, 'Value') == 1
	cont = 'r';
elseif get(H.contour_color, 'Value') == 2
	cont = 'g';
elseif get(H.contour_color, 'Value') == 3
	cont = 'b';
elseif get(H.contour_color, 'Value') == 4
	cont = 'y';
elseif get(H.contour_color, 'Value') == 5
	cont = 'm';
elseif get(H.contour_color, 'Value') == 6
	cont = 'c';	
elseif get(H.contour_color, 'Value') == 7
	cont = 'w';
elseif get(H.contour_color, 'Value') == 8
	cont = 'k';
elseif get(H.contour_color, 'Value') == 9
	cont = 'none';	
end

max_density = max(max(density));
max_density_conf = max_density - max_density*str2num(get(H.conf,'String'))*.01;

if get(H.contour,'Value')==1 
	contour3(X,Y,density,cont, 'LineWidth', str2num(get(H.contour_w,'String')));
end

if get(H.contour_num,'Value')==1 
	contour3(X,Y,density,str2double(get(H.cont_num,'String')),cont,'LineWidth', str2num(get(H.contour_w,'String')));
end

if get(H.contour_vals,'Value')==1 
	contour3(X,Y,density,[max_density_conf max_density_conf],cont, 'LineWidth', str2num(get(H.contour_w,'String')));
end

axis([str2double(get(H.xmin,'String')),str2double(get(H.xmax,'String')),str2double(get(H.ymin,'String')),str2double(get(H.ymax,'String'))]);

set(H.axes1,'FontSize',str2num(get(H.fontsize,'String')));

if get(H.bold,'Value') == 1
	set(H.axes1,'FontWeight','bold');
end
	
view(az);

set(H.azim,'String',round(az(1,1),1));
set(H.elev,'String',round(az(1,2),1));

if get(H.d2,'Value') == 1
	view(2)
end

xlabel(get(H.x_lab,'String'));
ylabel(get(H.y_lab,'String'));
if get(H.d3,'Value') == 1
	zlabel(get(H.z_lab,'String'));
end

DM_Slider = str2num(get(H.dms,'String'));

Epsilon_plot = [16.5,14.6,0,15.6,0;15.0,13.0,500,14.0,0;13.4,11.5,1000,12.5,0;11.9,9.9,1500,10.9,0;10.3,8.3,2000,9.3,0; ...
	8.7,6.7,2500,7.7,0;5.4,3.4,3500,4.4,0;3.7,1.7,4000,2.7,0;2.0,0.0,4500,1.0,0];

Decay_const_176Lu = 0.01867; %176Lu decay constant (Scherer et al., 2001) 1.867*10^-11 (same as Soderland et al., 2004)
DM_176Hf_177Hf = 0.283225; %Vervoort and Blichert-Toft, 1999
DM_176Lu_177Hf = 0.0383; %Vervoort and Blichert-Toft, 1999
BSE_176Hf_177Hf = 0.282785; %Bouvier et al. 2008
BSE_176Lu_177Hf = 0.0336; %Bouvier et al. 2008

t_176Hf_177Hf = DM_176Hf_177Hf - (DM_176Lu_177Hf*(exp(Decay_const_176Lu*DM_Slider/1000)-1));

CHURt = BSE_176Hf_177Hf - (BSE_176Lu_177Hf*(exp(Decay_const_176Lu*DM_Slider/1000)-1));
 
DMpoint_Epsi_x = DM_Slider;
DMpoint_Epsi_y = 10000*((t_176Hf_177Hf/CHURt)-1);

Y0_Evol_DM_176Lu_177Hf = t_176Hf_177Hf + (0.0115*(exp(Decay_const_176Lu*DM_Slider/1000)-1));
Y0_u_Evol_DM_176Lu_177Hf = t_176Hf_177Hf + (0.0193*(exp(Decay_const_176Lu*DM_Slider/1000)-1));
Y0_l_Evol_DM_176Lu_177Hf = t_176Hf_177Hf + (0.0036*(exp(Decay_const_176Lu*DM_Slider/1000)-1));
Ys_Evol_DM_176Lu_177Hf = t_176Hf_177Hf;

Y0_Epsi_DM_176Lu_177Hf = 10000*((Y0_Evol_DM_176Lu_177Hf/BSE_176Hf_177Hf)-1);
Y0_u_Epsi_DM_176Lu_177Hf = 10000*((Y0_u_Evol_DM_176Lu_177Hf/BSE_176Hf_177Hf)-1);
Y0_l_Epsi_DM_176Lu_177Hf = 10000*((Y0_l_Evol_DM_176Lu_177Hf/BSE_176Hf_177Hf)-1);
Ys_Epsi_DM_176Lu_177Hf = DMpoint_Epsi_y;

if get(H.evol_color, 'Value') == 1
	evo = 'r';
elseif get(H.evol_color, 'Value') == 2
	evo = 'g';
elseif get(H.evol_color, 'Value') == 3
	evo = 'b';
elseif get(H.evol_color, 'Value') == 4
	evo = 'y';
elseif get(H.evol_color, 'Value') == 5
	evo = 'm';
elseif get(H.evol_color, 'Value') == 6
	evo = 'c';	
elseif get(H.evol_color, 'Value') == 7
	evo = 'w';
elseif get(H.evol_color, 'Value') == 8
	evo = 'k';
elseif get(H.evol_color, 'Value') == 9
	evo = 'none';	
end

if get(H.chur, 'Value') == 1
	plot3(Epsilon_plot(:,3),Epsilon_plot(:,5),ones(9,1).*max(max(density)),evo,'LineWidth',str2num(get(H.evo_t,'String')))
end

if get(H.DM, 'Value') == 1
	plot3(Epsilon_plot(:,3),Epsilon_plot(:,4),ones(9,1).*max(max(density)),evo,'LineWidth',str2num(get(H.evo_t,'String')))
	plot3(Epsilon_plot(:,3),Epsilon_plot(:,1),ones(9,1).*max(max(density)),strcat('--',evo),'LineWidth',str2num(get(H.evo_t,'String')))
	plot3(Epsilon_plot(:,3),Epsilon_plot(:,2),ones(9,1).*max(max(density)),strcat('--',evo),'LineWidth',str2num(get(H.evo_t,'String')))
end

if get(H.Y, 'Value') == 1
	plot3([0 DM_Slider],[Y0_u_Epsi_DM_176Lu_177Hf, Ys_Epsi_DM_176Lu_177Hf],ones(2,1).*max(max(density)), 'Color', evo, 'LineWidth', str2num(get(H.evo_t,'String')))
end
if get(H.Yu, 'Value') == 1
	plot3([0 DM_Slider],[Y0_Epsi_DM_176Lu_177Hf, Ys_Epsi_DM_176Lu_177Hf],ones(2,1).*max(max(density)), 'Color', evo, 'LineWidth', str2num(get(H.evo_t,'String')))
end
if get(H.Yl', 'Value') == 1
	plot3([0 DM_Slider],[Y0_l_Epsi_DM_176Lu_177Hf, Ys_Epsi_DM_176Lu_177Hf],ones(2,1).*max(max(density)), 'Color', evo, 'LineWidth', str2num(get(H.evo_t,'String')))
end

hold off
%set(gca, 'XDir','reverse')
%guidata(hObject,H);

[file,path] = uiputfile('*.eps','Save file');

if get(H.contour,'Value') == 1 || get(H.contour_num,'Value') == 1 || get(H.contour_vals,'Value') == 1 && get(H.plot_heat,'Value') == 0 && get(H.plot_scat,'Value') == 0 && get(H.plot_scat3,'Value') == 0
	print(FIG,'-depsc','-painters',[path file]);
	epsclean([path file]); 
elseif get(H.plot_heat,'Value') == 1 
	print(FIG,'-depsc',[path file]);
else
	print(FIG,'-depsc','-painters',[path file]);
end








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function copytable_Callback(hObject, eventdata, H)
data = get(H.uitable1, 'Data');
copy(data);

function pastetotable_Callback(hObject, eventdata, H)
data = paste;
set(H.uitable1, 'Data', data);
plot_Callback(hObject, eventdata, H)



