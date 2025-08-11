clc,clear,close all
%% Simulate Uncertain Model at Sampled Parameter Values
% This example shows how to simulate an uncertain model in Simulink(R) using the 
% Uncertain State Space block. You can sample uncertain parameters at specified 
% values or generate random samples. The MultiPlot Graph block lets you visualize 
% the responses of multiple samples on the same plot.
%
% Copyright 2019-2021 The MathWorks, Inc.

%% Uncertain Model
% The simple model |rctUncertainModel| contains an Uncertain State Space
% block with a step input. The step response signal feeds a MultiPlot Graph
% block.
mdl = "model_lft";
open(mdl)
tmax=60;
%%
% 
% By default, the Uncertain State Space block is configured to simulate the
% uncertain model |ss(ureal('a',-5),5,1,1)|, which is a |uss| model with
% one uncertain parameter. For this example, create a model of a
% mass-spring damper system with an uncertain spring constant and damping
% constant.
m = 3;
c = ureal('c',0.75,'Range',[0.5,1]);
k = ureal('k',1.95,'Range',[0.9,3]);
A=[0 1;-k/m -c/m];B=[0;1/m];C=[1 0];D=0;
usys = ss(A,B,C,D);%%
% To simulate this system, in the block parameters, enter |usys| for the

% Alternatively, set the
% parameter value at the command line. 
ublk = strcat(mdl,"/Uncertain State Space");
set_param(ublk,"USystem","usys");
set_param(ublk,"UValue","[]");
%% Simulate Nominal Model
% To simulate the model, Simulink must set the uncertain parameters in
% |usys| to specific, non-uncertain values. Use the *Uncertainty value*
% parameter to specify these values. By
% default, this parameter is set to |[]|, which causes Simulink to use the
% nominal values of all uncertain parameters. 

%%
% |usample| takes random samples of these parameters and
% returns a structure you can use for the *Uncertainty value* parameter. Set
% *Uncertainty value* to |usample(uvars)|, and simulate the model.
%
% <<../rctUncertainExample3.png>>
%
uvars = ufind(mdl);
param=usample(uvars);
figure()
hold on
l_param=[0.9 3   0.9 3 1.6 2.1  2.7
         0.5 0.5 1   1 0.7 0.87 0.57];
for i=1:7
    
    param.k=l_param(1,i);
    param.c=l_param(2,i);
    set_param(ublk,"UValue","param");
    OUT=sim(mdl,tmax);
    plot(OUT.Y.time,OUT.Y.signals.values,LineWidth=2)
    legende(i)=["delta_k = "+round((param.k-k.NominalValue)/(k.Percentage(2)*k.NominalValue)*100,2) +... 
        " delta_d = "+round((param.c-c.NominalValue)/(c.Percentage(2)*c.NominalValue)*100,2)];
end
legend(legende,FontSize=20)
grid()
title("réponse d'un système masse ressort amortisseur avec 2 paramètres incertains choisis aléatoirement",FontSize=20)
