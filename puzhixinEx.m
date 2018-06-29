clear all
clf
close all
% 频谱质心的提取 %  
NFFT=1024
filepath='C:\Users\lifangzu\Desktop\car_whistle\'
wavname='car_horn12'
wavpostfix='.wav'
filename=strcat(filepath,wavname,wavpostfix)
pngpostfix='.png'
pngname=strcat(filepath,wavname,pngpostfix)
[x fs]=audioread('C:\Users\lifangzu\Desktop\test20180524\high.wav');%读取音频信号 x为信号样本，fs信号采样频率 
for k=1:12  
    n=0:23;  
    dctcoef(k,:)=cos((2*n+1)*k*pi/(2*24));  
end  
xx=double(x); %强制类型转换为 浮点型
%判断并合并单双声道%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if size(xx,2)>1
    xx=(xx(:,1)+xx(:,2))/2;
end
size(xx)
%%%%%%%%%%%%%%%%%%%%%%%%%%%归一化处理%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xx=(xx-min(xx))/(max(xx)-min(xx));
max(xx)
size(xx)
%%%%%%%%%%%%%%%%%%%%%%%%%绘制时频特征图%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure (1)
spectrogram(xx,1048,512,1048,fs);
%%%%%%%%%%%%%%%%%%%%%%%%%%语音信号分帧%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
xx=enframe(xx,NFFT,512);%对xx1024点分为一帧
disp(size(xx,1))
%计算每帧的MFCC参数  
for i=1:size(xx,1)  
    y=xx(i,:); %提取每一帧的信号
    s=y'.*hamming(NFFT);  
    t=fft(s,NFFT)/NFFT;%FFT快速傅里叶变换 
    t=t(1:NFFT/2+1,1);
    t=2*(abs(t).^2);
    f = (fs/2*linspace(0,1,NFFT/2+1))';
    size(f)
    if sum(t)
        spec=sum(t.*f)/sum(t);
    else
        spec=0
    end
    m(i,:)=spec; %size(m)=[帧数,12]
end 
[a,b]=size(m)
Max=max(m)/2
Ave_Sum=sum(m)
Ave_Sum=num2str(Ave_Sum)
text=strcat('平均谱质心为',Ave_Sum)
%画出每帧的谱质心
fig=figure
plot(m)
xlabel('帧数')
ylabel('谱质心')
%text(m/2,m/2,strcat('平均谱质心为',Ave_Sum))
legend(text)
% print(fig,'-dpng',pngname)
