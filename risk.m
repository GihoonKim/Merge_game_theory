function value = risk(maneuv1 ,maneuv2, maneuv3,Car1,Car2,Car3)

m=1350;
dt=2;
r=0.8*9.81;

M_long = [-4, -2, 0, 2, 4];  %accleration
M_lat = [-1, 0, 1];    %-1 : LCL;   0:LK;   1:LCR;



%% Car1 update
long1 = maneuv1(1);
lat1 = maneuv1(2);

Car1(5) = M_long(long1);
Car1(6) = M_lat(lat1);

Car1(3) = Car1(3) + dt*Car1(5);
Car1(4) = Car1(4) + dt*Car1(6);
Car1(1) = Car1(1) + 1/2*Car1(5)*dt^2;
Car1(2) = Car1(2) + 1/2*Car1(6)*dt^2;





%% for maneuv2
long2 = maneuv2(1);
lat2 = maneuv2(2);
Car2(5) = M_long(long2);
Car2(6) = M_lat(lat2);

Car2(3) = Car2(3) + dt*Car2(5);
Car2(4) = Car2(4) + dt*Car2(6);
Car2(1) = Car2(1) + 1/2*Car2(5)*dt^2;
Car2(2) = Car2(2) + 1/2*Car2(6)*dt^2;


D2 = sqrt((Car1(1)-Car2(1))^2+(Car1(2)-Car2(2))^2);
EES2 = abs(sqrt(Car1(3)^2 + Car1(4)^2)-sqrt(Car2(3)^2 + Car2(4)^2)); %injury percent


TTC2 = abs(D2/EES2);
TIV2 = abs(D2/sqrt(Car1(3)^2 + Car1(4)^2));

EES2_r = abs(sqrt(Car1(3)^2 + Car1(4)^2)-sqrt(Car2(3)^2 + Car2(4)^2)-r*TIV2);

[P_ttc2, P_tiv2] = Probs(TTC2,TIV2);

R_ttc2 = P_ttc2*EES2;
R_tiv2 = P_tiv2*max(EES2,EES2_r);



%% for maneuv3
long3 = maneuv3(1);
lat3 = maneuv3(2);
Car3(5) = M_long(long3);
Car3(6) = M_lat(lat3);

Car3(3) = Car3(3) + dt*Car3(5);
Car3(4) = Car3(4) + dt*Car3(6);
Car3(1) = Car3(1) + 1/2*Car3(5)*dt^2;
Car3(2) = Car3(2) + 1/2*Car3(6)*dt^2;




D3 = sqrt((Car1(1)-Car3(1))^2+(Car1(2)-Car3(2))^2);
EES3 = abs(sqrt(Car1(3)^2 + Car1(4)^2)-sqrt(Car3(3)^2 + Car3(4)^2)); %injury percent


TTC3 = abs(D3/EES3);
TIV3 = abs(D3/sqrt(Car1(3)^2 + Car1(4)^2));

EES3_r = abs(sqrt(Car1(3)^2 + Car1(4)^2)-sqrt(Car3(3)^2 + Car3(4)^2)-r*TIV3);

[P_ttc3, P_tiv3] = Probs(TTC3,TIV3);

R_ttc3 = P_ttc3*EES3;
R_tiv3 = P_tiv3*max(EES3,EES3_r);


% max

value = max(R_ttc2,R_ttc3)*max(R_tiv2,R_tiv3);


end

