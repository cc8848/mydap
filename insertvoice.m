function [data]=insertvoice(sample,fs)
% --- 声纹录入
addpath('voicerecog');
prompt={'录入说话人身份'};
name='';
numlines=1;
defaultanswer={''};
answer=inputdlg(prompt,name,numlines,defaultanswer);

filt=melfilter(150,300,15);
fr1=frm(sample,16,fs,1);
mc2=train(fr1,filt,20);
mc2=mc2(3:18,:);
mc1=banshengsin(mc2);
s1=pitch(sample);
a=length(s1);
b=length(mc1(1,:));
if a>b
    s1(b+1:a)=[];
else
    s1(a+1:b)=0;
end
mc1=[mc1;s1];
[im,is,ip]=init(mc1,16);
[nim1,nis1,nip1,times]=gmm(im,is,ip,mc1);
data=struct('name',{},'means',{},'cov',{},'prob',{},'pitch',{});

if (exist('speech_database.dat')==2)
    load('speech_database.dat','-mat');
    speaker_number=speaker_number+1;
    if (~isempty(answer))
        data(speaker_number).name=answer{1,1};
        data(speaker_number).means=nim1;
        data(speaker_number).cov=readcov(nis1);
        data(speaker_number).prob=nip1;
        data(speaker_number).pitch=s1;
        save('speech_database.dat','data','speaker_number','-append');
        message=strcat('成功录入，说话人是： ',answer{1,1});
        msgbox(message,'','help');
    end
else
    speaker_number=1;
    if (~isempty(answer))
        data(speaker_number).name=answer{1,1};
        data(speaker_number).means=nim1;
        data(speaker_number).cov=readcov(nis1);
        data(speaker_number).prob=nip1;
        data(speaker_number).pitch=s1;
        save('speech_database.dat','data','speaker_number');
        message=strcat('成功录入，说话人是： ',answer{1,1});
        msgbox(message,'','help');
    end
end
end