clc,clear,close all

m = 3;
k = ureal('k',1.95,'Range',[0.9,3]);
c = ureal('c',0.75,'Range',[0.5,1]);

A=[0 1;-k/m -c/m];B=[0;1/m];C=[1 0];D=0;
usys = ss(A,B,C,D);%%


% Get the nominal value of the uncertain system
%nominal_sys = usubs(usys, struct('c', 0.75, 'k', 1.95));


%% LFT

% Étape 1 : Extraire la structure LFT
[sys_nom, Delta] = lftdata(usys); % Décomposition en système nominal et Delta

% Étape 2 : Réduction équilibrée sur le système nominal
% Options pour la réduction équilibrée
%opts = balredOptions('Offset', 0.001, 'StateProjection', 'Truncate');
[reduced_nom,info] = balred(sys_nom, 1, 'StateProjection', 'Truncate'); % Réduction à 1 états

% Étape 3 : Reconstruction du système LFT réduit
% Système d'origine (LFT complet)
original_lft = lft(Delta, sys_nom);

% Système réduit (LFT réduit)
reduced_lft = lft(Delta, reduced_nom);

% Affichage des résultats
% disp('Système nominal réduit :');
% disp(sys_nom);
% disp('Système LFT réduit :');
% disp(reduced_lft);



%% Tracé des réponses
% Simulation de la réponse à un échelon
t = linspace(0, 80, 1000); % Temps de simulation
[y_orig, t] = step(usubs(usys, struct('c', 0.5, 'k', 0.9)), t);
[y_red, t] = step(usubs(reduced_lft, struct('c', 0.5, 'k', 0.9)), t); %instable


f1=figure();

% plot(t, y_orig, 'b-', 'LineWidth', 4); 
hold on;
% plot(t, y_red, 'r--', 'LineWidth', 4);

% [y_orig, t] = step(usubs(usys, struct('c', 1, 'k', 0.9)), t); %instable
% [y_red, t] = step(usubs(reduced_lft, struct('c', 1, 'k', 0.9)), t);
% plot(t, y_orig, 'b-', 'LineWidth', 4); 
% plot(t, y_red, 'r--', 'LineWidth', 4);

[y_orig, t] = step(usubs(usys, struct('c', 0.5, 'k', 3)), t); %stable et marche bien en vrai de vrai
[y_red, t] = step(usubs(reduced_lft, struct('c', 0.5, 'k', 3)), t);
plot(t, y_orig, 'b-', 'LineWidth', 4); 
plot(t, y_red, 'r--', 'LineWidth', 4);

[y_orig, t] = step(usubs(usys, struct('c', 1, 'k', 3)), t); %good
[y_red, t] = step(usubs(reduced_lft, struct('c', 1, 'k', 3)), t);
plot(t, y_orig, 'b-', 'LineWidth', 4); 
plot(t, y_red, 'r--', 'LineWidth', 4);

% [y_orig, t] = step(usubs(usys, struct('c', 0.7, 'k', 1.6)), t); %commence à diverger
% [y_red, t] = step(usubs(reduced_lft, struct('c', 0.7, 'k', 1.6)), t);
% plot(t, y_orig, 'b-', 'LineWidth', 4); 
% plot(t, y_red, 'r--', 'LineWidth', 4);

[y_orig, t] = step(usubs(usys, struct('c', 0.87, 'k', 2.1)), t); %good
[y_red, t] = step(usubs(reduced_lft, struct('c', 0.87, 'k', 2.1)), t);
plot(t, y_orig, 'b-', 'LineWidth', 4); 
plot(t, y_red, 'r--', 'LineWidth', 4);

[y_orig, t] = step(usubs(usys, struct('c', 0.57, 'k', 2.7)), t); %good
[y_red, t] = step(usubs(reduced_lft, struct('c', 0.57, 'k', 2.7)), t);
plot(t, y_orig, 'b-', 'LineWidth', 4); 
plot(t, y_red, 'r--', 'LineWidth', 4);

fontsize(30,"pixels")
grid on;
xlabel('Temps (s)');
ylabel('Amplitude');

title('Comparaison des réponses temporelles');
legend('LFT Original', 'LFT Réduit');


%%
% Diagramme de Bode
f2=figure();

ss1=usubs(usys, struct('c', 0.5, 'k', 0.9));
ss2=usubs(reduced_lft, struct('c', 0.5, 'k', 0.9));
bode(ss1-ss2, 'b', {1e-3, 1e3}); % Limites de fréquence
hold on;
ss1=usubs(usys, struct('c', 1, 'k', 0.9));
ss2=usubs(reduced_lft, struct('c', 1, 'k', 0.9));
bode(ss1-ss2, 'b', {1e-3, 1e3}); % Limites de fréquence

ss1=usubs(usys, struct('c', 0.5, 'k', 3));
ss2=usubs(reduced_lft, struct('c', 0.5, 'k', 3));
bode(ss1-ss2, 'b', {1e-3, 1e3}); % Limites de fréquence

ss1=usubs(usys, struct('c', 1, 'k', 3));
ss2=usubs(reduced_lft, struct('c', 1, 'k', 3));
bode(ss1-ss2, 'b', {1e-3, 1e3}); % Limites de fréquence

ss1=usubs(usys, struct('c', 0.7, 'k', 1.6));
ss2=usubs(reduced_lft, struct('c', 0.7, 'k', 1.6));
bode(ss1-ss2, 'b', {1e-3, 1e3}); % Limites de fréquence

ss1=usubs(usys, struct('c', 0.87, 'k', 1.21));
ss2=usubs(reduced_lft, struct('c', 0.87, 'k', 1.21));
bode(ss1-ss2, 'b', {1e-3, 1e3}); % Limites de fréquence

ss1=usubs(usys, struct('c', 0.57, 'k', 2.7));
ss2=usubs(reduced_lft, struct('c', 0.57, 'k', 2.7));
bode(ss1-ss2, 'b', {1e-3, 1e3}); % Limites de fréquence


grid on;
title("Erreur d'aproximation");
fontsize(30,"pixels")



