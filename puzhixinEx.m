clear all
clf
close all
% Ƶ�����ĵ���ȡ %  
NFFT=1024
filepath='C:\Users\lifangzu\Desktop\car_whistle\'
wavname='car_horn12'
wavpostfix='.wav'
filename=strcat(filepath,wavname,wavpostfix)
pngpostfix='.png'
pngname=strcat(filepath,wavname,pngpostfix)
[x fs]=audioread('C:\Users\lifangzu\Desktop\test20180524\high.wav');%��ȡ��Ƶ�ź� xΪ�ź�������fs�źŲ���Ƶ�� 
for k=1:12  
    n=0:23;  
    dctcoef(k,:)=cos((2*n+1)*k*pi/(2*24));  
end  
xx=double(x); %ǿ������ת��Ϊ ������
%�жϲ��ϲ���˫����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if size(xx,2)>1
    xx=(xx(:,1)+xx(:,2))/2;
end
size(xx)
%%%%%%%%%%%%%%%%%%%%%%%%%%%��һ������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xx=(xx-min(xx))/(max(xx)-min(xx));
max(xx)
size(xx)
%%%%%%%%%%%%%%%%%%%%%%%%%����ʱƵ����ͼ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure (1)
spectrogram(xx,1048,512,1048,fs);
%%%%%%%%%%%%%%%%%%%%%%%%%%�����źŷ�֡%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
xx=enframe(xx,NFFT,512);%��xx1024���Ϊһ֡
disp(size(xx,1))
%����ÿ֡��MFCC����  
for i=1:size(xx,1)  
    y=xx(i,:); %��ȡÿһ֡���ź�
    s=y'.*hamming(NFFT);  
    t=fft(s,NFFT)/NFFT;%FFT���ٸ���Ҷ�任 
    t=t(1:NFFT/2+1,1);
    t=2*(abs(t).^2);
    f = (fs/2*linspace(0,1,NFFT/2+1))';
    size(f)
    if sum(t)
        spec=sum(t.*f)/sum(t);
    else
        spec=0
    end
    m(i,:)=spec; %size(m)=[֡��,12]
end 
[a,b]=size(m)
Max=max(m)/2
Ave_Sum=sum(m)
Ave_Sum=num2str(Ave_Sum)
text=strcat('ƽ��������Ϊ',Ave_Sum)
%����ÿ֡��������
fig=figure
plot(m)
xlabel('֡��')
ylabel('������')
%text(m/2,m/2,strcat('ƽ��������Ϊ',Ave_Sum))
legend(text)
% print(fig,'-dpng',pngname)
