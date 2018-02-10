clear all;
close all;

nhFig = 0; % Figure Number;
SeaRegLx = 40e+3; % Sea region length, unit: m
SeaRegLy = 40e+3; % Sea region length, unit: m
% 根据频域采样定理，在确定采样周期即波束的足迹宽度之后，
% 可以利用时域采样的采样点数目(通过空间频谱的宽度即根据时域采样定理计算出采样点数)，实现频域采样.
% 对于海洋波谱而言，波谱宽度是非常宽的，因此其波谱宽度一般是指包括了大部分能量(或者说主要的能量部分)的不完全谱宽度
% 所以这里事先根据波谱函数计算主要能量部分对应的谱宽度
xSampleStep = 50; % unit: m
ySampleStep = 50;
xNs = round( SeaRegLx / xSampleStep );
yNs = round( SeaRegLy / ySampleStep );

x = linspace( -SeaRegLx / 2, SeaRegLx / 2, xNs );
y = linspace( -SeaRegLy/ 2, SeaRegLy / 2, yNs );

% 海浪谱仿真
g = 9.8; % gravity acceleration
% swell wave spectrum parameter
SwellWaveLength = 1000; % 涌浪波长
KswellWavePeak = 2 * pi / SwellWaveLength;
SwellAngled=0;
SwellAngle = SwellAngled/ 180 * pi; % 涌浪与观测向夹角
KxswellWavePeak = KswellWavePeak * cos( SwellAngle );
KyswellWavePeak = KswellWavePeak * sin( SwellAngle );
SigmaKx = 2.5e-3; % 涌浪谱宽度
SigmaKy = 2.5e-3;
SigmaHSwell = 2; %涌浪波高
% wind wave spectrum parameter
WindAngle = 45 / 180 * pi; % 风向与观测向夹角
U10 = 12; % 10米高处海面风速 % 5m/s, 10m/s, 15m/s 的风浪谱宽度分别为 1.5, 0.4, 0.15.对应的最大空间采样间隔为2m, 10m, 20m
KwindPeak = g / ( 1.2 * U10 )^2;
% sea wave spectrum parameter
NxSeaWave = xNs; % 频域采样点数，方便傅立叶变换
NySeaWave = yNs; 
KxSeaWave = 2 * pi / SeaRegLx * ( -xNs / 2 : 1 : xNs / 2 - 1 );
KySeaWave = 2 * pi / SeaRegLy * ( -yNs / 2 : 1 : yNs / 2 - 1 );
KxSeaWaveTicks = KxSeaWave;
KySeaWaveTicks = KySeaWave;
KxSeaWave = ( KxSeaWave == 0 ) * ( max( KxSeaWave ) * 1e-16 ) + KxSeaWave; % avoid divided by 0
KySeaWave = ( KySeaWave == 0 ) * ( max( KySeaWave ) * 1e-16 ) + KySeaWave; % avoid divided by 0

% swell wave spectrum
SpectrumSwell = zeros( NySeaWave, NxSeaWave );
Temp1 = ones( NySeaWave, 1 ) * ( KxSeaWave - KxswellWavePeak ) / SigmaKx;
Temp2 = ( KySeaWave - KyswellWavePeak )' / SigmaKy * ones( 1, NxSeaWave );
SpectrumSwell = SigmaHSwell^2 / 2 / pi / SigmaKx / SigmaKy * exp( -0.5 * ( Temp1.^2 + Temp2.^2 ) );
clear Temp1;
clear Temp2;
figure;
colormap(gray(256));
image( KxSeaWave, KySeaWave, 256 - 255 / ( max( max( abs( SpectrumSwell ) ) ) - min( min ( abs( SpectrumSwell ) ) ) ) * ( abs( SpectrumSwell ) - min( min ( abs( SpectrumSwell ) ) ) ) );
axis('xy');
xlabel( 'kx:X方向波数');
ylabel( 'ky:Y方向波数');
title( '涌浪谱');

KxSeaWaveMatrix = ones( NySeaWave, 1 ) * KxSeaWave;
KySeaWaveMatrix = KySeaWave' * ones( 1, NxSeaWave );
KSeaWaveTemp1 = ( sqrt( KxSeaWaveMatrix.^2 + KySeaWaveMatrix.^2 ) );
Fwk1 = exp( - 1.22 * ( sqrt( KSeaWaveTemp1 ./ KwindPeak ) -1 ).^2  );
HKKpx1 = 1.24 * ( ( KSeaWaveTemp1 / KwindPeak < 0.31 ) & ( KSeaWaveTemp1 / KwindPeak >= 0 ) );
HKKpx2 = 2.61 * ( ( KSeaWaveTemp1 / KwindPeak ).^0.65 ) .* ( ( KSeaWaveTemp1 / KwindPeak < 0.9 ) & ( KSeaWaveTemp1 / KwindPeak >= 0.31 ) );
HKKpx3 = 2.28 * ( ( KSeaWaveTemp1 / KwindPeak ).^( -0.65 ) ) .* ( KSeaWaveTemp1 / KwindPeak >= 0.9 );
HKKp1 = HKKpx1 + HKKpx2 + HKKpx3;
Temp1x = 1.62 * 1e-3 * U10 / ( g^0.5 ) ./ ( KSeaWaveTemp1 ).^3.5;
Temp2x = exp( -( KwindPeak ./ KSeaWaveTemp1 ).^2 ) .* ( 1.7 .^ Fwk1 );
Temp3x = ( HKKp1 .* ( sech( ( HKKp1 .* ( atan( ( KySeaWaveMatrix ./ KxSeaWaveMatrix ) ) - WindAngle ) ) ) ).^2 );
% SpectrumWind1 = ( Temp1x .* Temp2x .* Temp3x )';
% SpectrumWind = SpectrumWind1';
SpectrumWind = Temp1x .* Temp2x .* Temp3x;
clear KSeaWaveTemp1 Fwk1 HKKpx1 HKKpx2 HKKpx3 HKKp1 Temp1x Temp2x Temp3x;
figure;
contour( KxSeaWave, KySeaWave, abs( SpectrumWind ) );
axis('xy');
xlabel( 'kx:X方向波数');
ylabel( 'ky:Y方向波数');
title( '风浪谱');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%全谱＝ 涌浪谱+风浪谱
SpectrumSea = SpectrumSwell + SpectrumWind;
% 用于产生海面仿真的真实海浪谱，叠加了随机因素
% 产生均值为1的瑞利分布和均匀相位分布
rand('state',sum(100*clock));
PhiSeaRand = 2 * pi * rand( NySeaWave, NxSeaWave );
AmRayleigh = raylrnd( 1, NySeaWave, NxSeaWave );
SpectrumSeaReal = 2 * pi .* sqrt( 2 * xNs * yNs / xSampleStep / ySampleStep .* SpectrumSea ) .* AmRayleigh .* exp( j * PhiSeaRand );
% 海面高度
wh = zeros( yNs, xNs );   % Wave Height, heigth depart from mean sea level
% wh = real( ( fftshift( fft( ( fftshift( fftshift( fft( fftshift( SpectrumSeaReal ), yNs ) ) ) )', xNs ) ) )' ) / NySeaWave / NxSeaWave;
wh = ( fftshift( fft( ( fftshift( fftshift( fft( fftshift( SpectrumSeaReal ), yNs ) ) ) )', xNs ) ) )' / NySeaWave / NxSeaWave;
Varwh = sqrt( sum( sum( ( real( wh ) - mean( mean( real( wh ) ) ) ).^2 ) ) / xNs / yNs );
wh = wh / Varwh * ( SigmaHSwell / 2 );% 用涌浪波高进行归一化

hFig = figure;
colormap(gray(256));
image( x, y, 256 - 255 / ( max( max( real( wh ) ) ) - min( min ( real( wh ) ) ) ) * ( real( wh ) - min( min ( real( wh ) ) ) ) );
% title('涌浪方向 45 度, 波长 ', SwellWaveLength)
title(['涌浪方向: ',num2str(SwellAngled),' 度',',  波长: ',num2str(SwellWaveLength),' m',',  涌浪波高: ',num2str(SigmaHSwell),' m'])
xlabel( ['X ( unit: ', num2str(xSampleStep),' m)']);
ylabel( ['Y ( unit: ', num2str(ySampleStep),' m)']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 海面散射系数仿真
Sigma = zeros( xNs, yNs );
ms2 = 3.66 * 1e-3 * U10;
MR02 = 1;
% 由海面波谱计算每点的x,y方向坡度
xSlope = ones( yNs, 1 ) * real( ( fftshift( fft( fftshift( ( j * KxSeaWaveMatrix( 1, : ) .* SpectrumSeaReal( 1, : ) )' ), xNs ) ) )' ) / NxSeaWave;
ySlope = real( ( fftshift( fft( fftshift( ( j * KySeaWaveMatrix( :, 1 ) .* SpectrumSeaReal( :, 1 ) ) ), yNs ) ) ) ) / NySeaWave * ones( 1, xNs );
% 本地入射角矩阵,正切表示
IncidentAngleLocal = xSlope.^2 + ySlope.^2;
Sigma = MR02 / ms2 .* exp( -IncidentAngleLocal / ms2 );
% Sigma0Coef = sqrt( Sigma );
hFig = figure;
colormap(gray(256));
image( x, y, 256 - 255 / ( max( max( abs( Sigma ) ) ) - min( min ( abs( Sigma ) ) ) ) * ( abs( Sigma ) - min( min ( abs( Sigma ) ) ) ) );
axis('xy');
xlabel( 'x0: along track');
ylabel( 'y0: cross track');
title( 'Scattering Coffecient Distribution');

fid=fopen('sea_top_wl1000_wh50m.dat','w')
fprintf(fid,'%10.5f\n',real(wh));
status=fclose(fid);

fid=fopen('sea_top_wl1000_wh50m.dat','r');
sea_dem=fscanf(fid,'%g',[800,800]);
fclose(fid);
%image( x, y, 256 - 255 / ( max( max( real( sea_dem ) ) ) - min( min ( real( sea_dem ) ) ) ) * ( real( sea_dem ) - min( min ( real( sea_dem ) ) ) ) );
% 
 mesh(sea_dem)
 colorbar
% view(0,90)
%colormap(gray)
