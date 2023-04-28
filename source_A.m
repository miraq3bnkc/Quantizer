%this will be the programm for 
% question 1, section 1 of the project

%SOURCE A
%Fisrtly we need to define two autoregressive processes
x = randn(10000,1);
a1=[1 -0.9].';
a2=[1 -0.01].';
AR1 = filter(1,a1,x);
AR2 = filter(1,a2,x);


%ENCODING INPUT SIGNALS AR1 , AR2
%after encoding we are going to have 8 different quantized signals
%four for AR1 and four for AR2
y= cell(8,1);
%firstly, we are calling the LloydMax algorithm
centers=cell(6,1);
D=cell(6,1);
H=cell(6,1); %entropy
for i=1:2:6
    N=2^(floor(i/2)+1);
    fprintf('\nThis is the AR1 signal quantized with %d bits\n',N);
    [y{i},centers{i},D{i},H{i}] = LloydMax(AR1,N,min(AR1), max(AR1));
    t=['SQNR with signal N=' num2str(N) 'bits of AR_1'];
    title(t);
    fprintf('\nThis is the AR2 signal quantized with %d bits\n',N);
    [y{i+1},centers{i+1},D{i+1},H{i+1}] = LloydMax(AR2,N,min(AR2), max(AR2));
    t=['SQNR with signal N=' num2str(N) 'bits of AR_2'];
    title(t);
end

%now the ADM 
y{7}=ADM(AR1);
y{8}=ADM(AR2);

%CALCULATING SQNR VALUES
%in Lloyd Max algorithm , we have already calculated them inside the 
%Lloyd max function, so we will be calculating only for ADM
fprintf('\nThis is the AR1 signal quantized with ADM\n');
SQNR(interp(AR1,2),y{7});
fprintf('\nThis is the AR2 signal quantized with ADM\n');
SQNR(interp(AR2,2),y{8});

%PLOTS FOR THE OUTPUT SIGNALS
%FOR AR1
figure
subplot(2,2,1)%2 rows 2 columns 1st position
plot(AR1);
title('Signal AR_1');

for i=1:3
    subplot(2,2,i+1)%2 rows 2 columns i position
    plot(y{2*i-1}); %y{1}, y{3}, y{5}
    t=['Quantized signal N=' num2str(2^i) 'bits'];
    title(t);
end 

%FOR AR2 
figure
subplot(2,2,1)%2 rows 2 columns 1st position
plot(AR2);
title('Signal AR_2');

for i=1:3
    subplot(2,2,i+1)%2 rows 2 columns i position
    plot(y{i*2});
    t=['Quantized signal N=' num2str(2^i) 'bits'];
    title(t);
end 

%PLOTS AFTER THE APPLICATION OF ADM
for i=1:2
    figure
    plot(y{6+i});
    t=['ADM of AR_' num2str(i)];
    title(t);
end