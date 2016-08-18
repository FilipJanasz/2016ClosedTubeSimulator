%data filter for htrnr
htrnrTest=htrnr{2,2};
htrnr_size=size(htrnrTest);
for n=1:htrnr_size(1)
    for m=1:htrnr_size(2)
        if abs(htrnrTest(n,m))>abs(30*htrnrTest(2,2))
            if htrnrTest(n,m)<0
                htrnrTest(n,m)=-30*htrnrTest(2,2);
            else
                htrnrTest(n,m)=30*htrnrTest(2,2);  
            end
        end
    end
end