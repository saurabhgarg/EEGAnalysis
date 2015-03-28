pos = [152,230;61,436;155,609;338,169;208,264;157,417;208,571;338,665;312,285;289,417;312,549;418,156;418,287;418,417;418,547;418,679;525,285;548,417;525,549;499,169;629,264;679,417;629,570;499,665;685,230;776,436;682,609];
p = -1*pos;
names = {'F9','A1','P9','Fp1','F7','T7','P7','O1','F3','C3','P3','Fpz','Fz','Cz','Pz','Oz','F4','C4','P4','Fp2','F8','T8','P8','O2','F10','A2','P10'};

x = besa_channels.data.amplitudes;
x = x - repmat(mean(x),size(x,1),1);

% Change 'adult'/'infant', initials, and object/reaching/walking as necessary for current file
Test_AN_object_x = x./repmat(std(x),size(x,1),1);         % 1 adult/infant, 1 set of initials
Test_AN_object_g = learn_struct_PC(Test_AN_object_x);       % 2 adult/infant, 2 sets of initials, 2 object/reaching/walking
draw_undir_graph('Test_AN_object_graph',Test_AN_object_g,[],names,p)    % 1 adult/infant, 2 sets of initials, 2 object/reaching/walking