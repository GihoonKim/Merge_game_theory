function [P_ttc, P_tiv] = Probs(ttc,tiv)


if ttc<=1
    P_ttc=1;
else
    P_ttc = -1/9*(ttc-1)+1;
    
    if P_ttc<=0
        P_ttc=0;
    end
end

if tiv<=0.5
    P_tiv = 1;
elseif tiv<=1
    P_tiv = -1*(tiv-0.5)+1;
else
    P_tiv = -1/2*(tiv-1)+0.5;
    
    if P_tiv<=0
        P_tiv=0;
    end
end
