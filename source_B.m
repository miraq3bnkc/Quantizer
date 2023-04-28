%answer of the 2nd question of the 1st section of the project

%source B

load cameraman.mat;
figure(1)
imshow(uint8(i));
title('Original signal')
x = i(:);
x = (x-128)/128; % x array will be our source B signal
%firstly, we are calling the LloydMax algorithm
y= cell(2,1);
centers=cell(2,1);
D=cell(2,1);
H=cell(2,1);%entropy
for i=1:2
    N=i*2;
    fprintf('\nThis is the cameraman pic quantized with %d bits\n',N);
    [y{i},centers{i},D{i},H{i}] = LloydMax(x,N,-1,1);
    y{i} = 128*y{i}+128;
    y{i}=reshape(y{i},256,256);
    figure
    imshow(uint8(y{i}));
    title('Quantized signal')
end
