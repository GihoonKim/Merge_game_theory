
%% Initialize
car_m = [70, 0, 35, 0,0];  % X,Y,Vx,Vy,a
car_t = [160, -10, 21.9, 0, 0];
car_b = [75, 10, 35, 0, 0];

m = 1430;

M_long = [-4, -2, 0, 2, 4];  %accleration
M_lat = [-1, 0, 1];    %-1 : LCL;   0:LK;   1:LCR;

P_inm = zeros(5,3);    %manuever prob -> row : long,  column : lat
P_int = zeros(5,3);    %need to be changed
P_inb = zeros(5,3);

P_inm(3,2)=1;   %constant velocity 
P_int(3,2)=1;   %constant velocity
P_inb(3,1)=1;   %constant velocity LCL

% P_inm = 1/5*1/3*ones(5,3);    %manuever prob -> row : long,  column : lat
% P_int = 1/5*1/3*ones(5,3);    %need to be changed
% P_inb = 1/5*1/3*ones(5,3);

% Need to check : GMM model.... Where can i get data?? NGSIM???
% given dy, ddy P(dy,ddy | class ) < -- how to modeling
% fixed value 

% interaction_unaware prob
P_uit = 1/5*1/3*ones(5,3);   
P_uim = 1/5*1/3*ones(5,3);
P_uib = 1/5*1/3*ones(5,3);

% interaction_aware prob
P_it = 1/5*1/3*ones(5,3);
P_im = 1/5*1/3*ones(5,3);
P_ib = 1/5*1/3*ones(5,3);

P_b = 1/5*1/3*ones(5,3);

P_pred = 1/5*1/3*ones(5,3);
P_pred_ex = 1/5*1/3*ones(5,3);

node_list = {};

%P_surr = by_gmm;
P_o = zeros(5,3);

obj_left = gmdistribution([-1,-0.5],[1 0; 0 0.5],1);
obj_str = gmdistribution([0,0],[1 0; 0 0.5],1);
obj_right = gmdistribution([1,0.5],[1 0; 0 0.5],1);


%connect_matrix = 

%% prediction step
dt=2;

% top lane vehicle status change
car_t(1) = car_t(3)*dt;

%% Each vehicle interation-unaware function
dyu = 0;
ddyu = 0;

dym = 0;
ddym = 0;

dyb = -1;
ddyb = -0.5;

for i=1:5
    for j=1:3
        
        if j==1
            P_uit(i,j) = P_int(i,j)*pdf(obj_left,[dyu,ddyu]);
            P_uim(i,j) = P_inm(i,j)*pdf(obj_left,[dym,ddym]);
            P_uib(i,j) = P_inb(i,j)*pdf(obj_left,[dyb,ddyb]);
            
        elseif j==2
            P_uit(i,j) = P_int(i,j)*pdf(obj_str,[dyu,ddyu]);
            P_uim(i,j) = P_inm(i,j)*pdf(obj_str,[dym,ddym]);
            P_uib(i,j) = P_inb(i,j)*pdf(obj_str,[dyb,ddyb]);

        else
            P_uit(i,j) = P_int(i,j)*pdf(obj_right,[dyu,ddyu]);
            P_uim(i,j) = P_inm(i,j)*pdf(obj_right,[dym,ddym]);
            P_uib(i,j) = P_inb(i,j)*pdf(obj_right,[dyb,ddyb]);
            
        end
    % cognitive and botom level status change

 
    end
end

%% merging vehicle interaction-aware function
% when merging vehicle move along m(i,j)

check = zeros(5,3);

for i=1:5
    for j=1:3
        
        sum_temp = 0;
        %P_Ia_v_ = prod(prod(P_uit));
        
        for ti=1:5
            for tj=1:3
                for mi=1:5
                    for mj=1:3
                        sum_temp = sum_temp + 1-reward(M_long(i),M_lat(j),P_uit(ti,tj),P_uim(mi,mj))*P_uit(ti,tj)*P_uim(mi,mj);  
                        % because of last two term, other vehicle can consider ego car's action
                    end
                end
            end
        end
        
        P_ib(i,j) = sum_temp;     % P_interaction(mj,v | pi_c)
        
        P_b(i,j) = P_uib(i,j)*P_ib(i,j);  %P(mj,v | pi_c)
        
        P_pred(i,j) = prod(prod(P_b(i,j)*P_pred_ex));   % P_pred_ex value should be calculated or assumed 
        
        check(i,j) = P_pred(i,j); 
        new_node = node('parents','child',P_pred(i,j));
        
        node_list = [node_list, new_node];
    end    
end


check
%% planning step


%%
