function [] = plot_estimation( estimation_result, data )

% close all
% addpath('Math_Liegroup/');

%% plot ground truth poses and estimated poses
errposition = [];
N  = size(estimation_result, 2);

T = 1:N;
for i = T
    position = estimation_result{i}.position;
    plot3(position(1),position(2),position(3),'ro');
    hold on;
    ap = data.poses.position(:,i);
    subplot(3,2,1);
    plot3(ap(1),ap(2),ap(3),'b+');
    axis equal;
    errposition = [errposition norm(position-ap)];
    hold on;
end

%% plot error in position
subplot(3,2,2);
plot(T, errposition);

N  = size(estimation_result, 2);
NL = size(estimation_result{N}.landmarks, 2);

ErrLandmark = zeros(1, NL);
for j = 1:NL
    ErrLandmark(j) = norm(estimation_result{N}.landmarks(1:3,j)-data.landmarks( estimation_result{N}.landmarks(4,j),1:3)');
end
axis equal;

%% plot error in orientation
N=200;
dT=1:N;
ThetaVector=zeros(3,N);
SigmaTheta=zeros(3,N);
for j = 1:N
    ThetaVector(:,j)=so3_log((data.poses.orientation(3*j-2:3*j,1:3))'*estimation_result{j}.orientation);
    SigmaTheta(:,j)= [sqrt(estimation_result{j}.cov(1,1));sqrt(estimation_result{j}.cov(2,2));sqrt(estimation_result{j}.cov(3,3))];
end

subplot(3,2,4)
plot(dT,ThetaVector(1,:),'g');
hold on
plot(dT,3*SigmaTheta(1,:),'r');
hold on
plot(dT,-3*SigmaTheta(1,:),'r');
hold on

subplot(3,2,5)
plot(dT,ThetaVector(2,:),'g');
hold on
plot(dT,3*SigmaTheta(2,:),'r');
hold on
plot(dT,-3*SigmaTheta(2,:),'r');
hold on

subplot(3,2,6)
plot(dT,ThetaVector(3,:),'g');
hold on
plot(dT,3*SigmaTheta(3,:),'r');
hold on
plot(dT,-3*SigmaTheta(3,:),'r');
hold on


figure(2)
PositionVector=zeros(3,N);
Sigma=zeros(3,N);
for j = 1:N
    PositionVector(:,j)=inv(jaco_r(-ThetaVector(:,j)))*( data.poses.orientation(3*j-2:3*j,1:3)' *(estimation_result{j}.position-data.poses.position(:,j)));
    Sigma(:,j)= [sqrt(estimation_result{j}.cov(4,4));sqrt(estimation_result{j}.cov(5,5));sqrt(estimation_result{j}.cov(6,6))];
end
subplot(3,2,1)
plot(dT,PositionVector(1,:),'g');
hold on
plot(dT,3*Sigma(1,:),'r');
hold on
plot(dT,-3*Sigma(1,:),'r');
hold on

subplot(3,2,2)
plot(dT,PositionVector(2,:),'g');
hold on
plot(dT,3*Sigma(2,:),'r');
hold on
plot(dT,-3*Sigma(2,:),'r');
hold on

subplot(3,2,3)
plot(dT,PositionVector(3,:),'g');
hold on
plot(dT,3*Sigma(3,:),'r');
hold on
plot(dT,-3*Sigma(3,:),'r');
hold on