function [xq,b]=ADM(x)

%xq is the output of Decoder ADM 
%b is the output of encoder ADM
x=interp(x,2);
b=zeros(size(x));
eq=zeros(size(x));
xq=zeros(size(x));
K=1.5;
delta=zeros(size(x));
delta(1)=1;

%ADM Encoder (or transmitter)
for i=2:length(x)
    %1bit quantizer 
    if x(i)-xq(i-1)>=0
        b(i)=1;
    else 
        b(i)=-1;
    end
    
    %Step control logic 
    if b(i)==b(i-1)
        delta(i)=delta(i-1)*K;
    else 
        delta(i)=delta(i-1)/K;
    end
    
    %multiplication of b(i) with delta gives as 
    %the quantization error
    eq(i)=b(i)*delta(i);
    
    %delay
    xq(i)=eq(i)+xq(i-1);
end

end
