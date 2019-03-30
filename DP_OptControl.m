clear all
close all
clc

m1 = 'Please enter the upper bound of machines age X:';
X = input(m1);
m2 = 'Please enter the time period K:';
K = input(m2);
m3 = 'Please enter the parameter T:';
T = input(m3);

% Dimensions of each array
n = X;   % Number of rows of array nodes
m = K+1; % Number of columns of array nodes 
% node(1:n,1:m) = -500; % We can initialize the array node if we want

for k=m:-1:1 % Filling the array node with the cost - values of the diagram
    for x=n:-1:1
        if k==m
            node(x,k)=x-X;
        elseif k==1 & x==1
            node(x,k) = min((1-1)*(T*sqrt(0)-exp(-x)) + x^2 + node(x+1,k+1),(1-0)*(T*sqrt(0)-exp(-x)) + x^2 + node(1,k+1));
        elseif x~=n & k~=m 
            node(x,k) = min((1-1)*(T*sqrt(k-1)-exp(-x)) + x^2 + node(x+1,k+1),(1-0)*(T*sqrt(k-1)-exp(-x)) + x^2 + node(1,k+1));
        elseif x==n
            node(x,k) = (1-0)*(T*sqrt(k-1)-exp(-x)) + x^2 + node(1,k+1);
        end
    end
end

for k=1:1:K+1 % Calculate number of nodes per level, beginning from level 0 (k = 0...K)
    if k<X
        nodes(k) = k;
    else
        nodes(k) = X;
    end
end

for i=1:1:K+1 % Eliminate the uneeded elements
    for j=n:-1:nodes(i)+1
        if nodes(i)~=n
            node(j,i) = -0.01; % Replace the uneeded values of the array node with -0.01
        end
    end
end
disp('-----------------------------------')
disp('The nodes of the graph are:')
disp(node)

route(1)=node(1,1); % Store in array route the final optimal replacement policy
disp('The optimal replacement policy is:')
disp('-----------------------------------')
disp('Start_Node on level:');
disp('0');
for k=1:1:m-1 % Finding the optimal replacement policy
    for x=1:1:n
        if node(x,k)~=-0.01 & k~=m & x~=n & node(x,k)==route(k) % We are interested only in nodes of the array node that are ~= -0.01 & == route(k)
            if node(x,k) == (1-0)*(T*sqrt(k-1)-exp(-x)) + x^2 + node(1,k+1)
                route(k+1) = node(1,k+1);
                disp('Replacement on level:');
                disp(k);
            elseif node(x,k) == (1-1)*(T*sqrt(k-1)-exp(-x)) + x^2 + node(x+1,k+1)
                route(k+1) = node(x+1,k+1);
                disp('No_Replacement on level:');
                disp(k);
            elseif x==n % If x == n we are making a replacement anyway
                route(k+1) = node(1,k+1);
            end
        end
    end
end
disp('-----------------------------------')
disp('The optimal cost - route is:')
disp(route)
disp('-----------------------------------')

total_cost = 0;
for i=1:1:m-1
    total_cost = total_cost + route(i); % Calculating the total cost of the optimal replacement policy
end

disp('The total cost of the optimal cost - route is:')
disp(total_cost)
disp('-----------------------------------')