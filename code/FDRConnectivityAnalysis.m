pos = [152,230;61,436;155,609;338,169;208,264;157,417;208,571;338,665;312,285;289,417;312,549;418,156;418,287;418,417;418,547;418,679;525,285;548,417;525,549;499,169;629,264;679,417;629,570;499,665;685,230;776,436;682,609];
p = -1*pos;
names = {'F9','A1','P9','Fp1','F7','T7','P7','O1','F3','C3','P3','Fpz','Fz','Cz','Pz','Oz','F4','C4','P4','Fp2','F8','T8','P8','O2','F10','A2','P10'};

x = besa_channels.amplitudes;
%subtract mean to normalize
x = x - repmat(mean(x),size(x,1),1);

% Change 'concussed'/'control' and initials as necessary for current file
control_AM_con01_x = x./repmat(std(x),size(x,1),1);         % 1 concussed/control, 1 set of initials
control_AM_con01_g = learn_struct_PC(control_AM_con01_x);       % 2 concussed/control, 2 sets of initials
draw_undir_graph('AMcon01_graph',control_AM_con01_g,[],names,p)    % 1 concussed/control, 2 sets of initials