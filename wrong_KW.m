k = 10;
mu_1 = [2,3];
sigma_1 = [1,1.5;1.5,3];

mu_2 = [4,6];
sigma_2 = [4,6;6,12];

rng(2)  % For reproducibility
A = mvnrnd(mu_1,sigma_1,300);
B = mvnrnd(mu_2,sigma_2,700);
r = [A;B];

idx = kmeans(r,k);
idx_A = idx(1:300,:);
idx_B = idx(301:1000,:);
num_A = 1:k;
num_B = 1:k;

for i = 1:k
    num_A(i) = length(find(idx_A==i));
    num_B(i) = length(find(idx_B==i));
end

num_A = num_A/300;
num_B = num_B/700;
plot(1:10,num_A)
hold on
plot(1:10,num_B,'r')
