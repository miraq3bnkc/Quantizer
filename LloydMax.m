function [xq, centers, D, H] = LloydMax(x, N, min_value, max_value)

% Parameters
% x: input signal
% N: number of bit/sample that are gonna be used
% min_value: minimum accepted value of input signal
% max_value: maximum accepted value of input signal


% The Lloyd Max algorithm will start with the centers of the uniform quantizer
levels = 2^N;
delta= abs(max_value-min_value)/levels;

%find the centers

centers = zeros(levels,1);
centers(1) = max_value - delta/2;
for i=2:levels
    centers(i) = centers(i-1) - delta;
end

%THIS IS THE LLOYD MAX 
D=[0 1]; %Distortion initialization
k=2;
e=10^-6;

sqnr=[];

while abs(D(k)-D(k-1))>=e
    %some initializations
    xq=zeros(size(x));
    d=zeros(size(x)); %to calculate the distortion in every point of the signal
    %variables needed for the calculations of new centers
    sum_x=zeros(levels,1);
    numOf_x=zeros(levels,1);
    
    %Calculating quantization zones limits
    t=zeros(levels+1,1);
    t(1)= max_value; 
    for i=2:length(centers)
        t(i)=(centers(i-1)+centers(i))/2;
    end
    t(i+1)=min_value;
    
    
    %Now we will calculate the quantized signal
    for i=1:length(x)
        for j=1:length(t)-1
            if t(j)>x(i) && x(i)>=t(j+1)
                xq(i)=centers(j);
                
                %calculations for the new centers 
                sum_x(j)=sum_x(j)+x(i);%sum of values in this zone
                %number of values in this zone
                numOf_x(j)=numOf_x(j)+1;
                break;
            elseif x(i)==t(1)
                %same as above
                xq(i)=centers(1);
                %calculations for the new centers
                sum_x(1)=sum_x(1)+x(i);            
                numOf_x(1)=numOf_x(1)+1;
                break;
            end
        end
        
        
        %distortion array
        %we calculate the difference the quantized signal has
        %for every sample of the signal
        d(i)=abs(xq(i)- x(i));
    end
    
    %DISTORTION
    d_avg = sum(d)/length(d);
    D = [D d_avg];
    
    %New centers , they are equal to E[x] for T_k<x<T_k+1
    %so basically, equal to the average value of the signal in each zone
    for j=1:levels
        if numOf_x(j)~=0 %to avoid zones with no samples
            centers(j)= sum_x(j)/numOf_x(j);
        end
    end
    
    sqnr(k-1)=SQNR(x,xq);%just to see how SQNR changes in every loop
    %it's not needed for the Lloyd max algorithm

    k = k + 1;
end

%deleting the initialization values
D(1)=[];
D(1)=[];

%unrelated to lloyd max algorithm, only for analysis
figure 
bar(sqnr);

%Calculation of Entropy
%not needed for Lloyd max algorithm 
p=zeros(levels,1);%we have as many probabilities as centers
H=0;
for i=1:levels
    if numOf_x(i)~=0 %to avoid zones with no samples 
        p(i)=numOf_x(i)/length(x); %probability of signals in a certain zone
        H=H+(p(i)*log2(1/p(i)));
    end
end

end