img=imread('gear11.png');
%“ñ’l‰»
BWo = im2bw(img,0.42);
BW = BWo<1;
imshow(img);

%”¼Œa r ‚ª [15, 30] ƒsƒNƒZƒ‹‚Ì”ÍˆÍ‚É‚ ‚é‰~‚ðŒŸo
[centers, radii, metric] = imfindcircles(img,[15 30]);
centersStrong5 = centers(1,:);%‰~‚Ì’†SÀ•W
radiiStrong = radii(1);%‰~‚Ì”¼Œa
%metricStrong5 = metric(1);
%’†S‚Ì‰~‚ð•\Ž¦iÂj
viscircles(centersStrong5, radiiStrong,'EdgeColor','b');
r=radii(1)+70;%‰~‚Ì”¼Œa
flag=1;%ƒ‹[ƒvƒtƒ‰ƒO
inner_r=0;%Ž•‚Ì•”•ª‚Ü‚Å‚Ì”¼Œa
while flag
    %Ž•ŽÔ‚Ì”¼Œa‚ª‹‚Ü‚é‚Ü‚Åƒ‹[ƒv
    r=r+1;%”¼Œa‚ðXV
    pic_num=0;%‰æ‘œî•ñ•Ï”‰Šú‰»
    i=0;%ƒ‹[ƒvƒJƒEƒ“ƒg
    for ti=0:0.01:pi/2
        %îŒ`‚É’Tõ
        tx=centersStrong5(1)+r*cos(ti);
        ty=centersStrong5(2)+r*sin(ti);
        now = BW(round(ty),round(tx));
        pic_num=pic_num+now;%‰æ‘f‚Ì’l‚ð‘«‚·
        i=i+1;
    end
    if pic_num==0
        %‘S‚Ä‚Ì‰æ‘f‚Ì’l‚ª‚O‚¾‚Á‚½‚çAI—¹
        flag=0;
    elseif pic_num==i
        %‘S‚Ä‚Ì‰æ‘f‚Ì’l‚ª‚P‚¾‚Á‚½‚çAŽ•‚Ì•”•ª‚Ü‚Å‚Ì”¼Œa‚Æ‚·‚é
        inner_r=r;
    end
end
%disp(r)
%Ž•‚Ì•”•ª‚Ü‚Å‚Ì‰~‚ð•\Ž¦i—Îj
viscircles(centersStrong5, inner_r,'EdgeColor','g');
%Ž•‚Ü‚Å‚Ì‰~‚ð•\Ž¦iÔj
viscircles(centersStrong5, r,'EdgeColor','r');
%Ž•‚ð”‚¦‚é‚½‚ß‚ÉŽg‚¤”¼Œa
gear_h=inner_r+(r-inner_r)*4/5;
%Ž•‚ð”‚¦‚é‚½‚ß‚ÉŽg‚¤‰~i‰©j
viscircles(centersStrong5, gear_h,'EdgeColor','y');

gear_num = 0;%Ž•‚Ì–‡”‚ð‰Šú‰»
pre=0;%‘O‚Ì‰æ‘f’l
now=0;%¡‚Ì‰æ‘f’l
for ti=0:0.01:2*pi
    %‰~ó‚É’Tõ
    tx=gear_h*cos(ti);
    ty=gear_h*sin(ti);
    now = BW(round(centersStrong5(2)+ty),round(centersStrong5(1)+tx));
    if now~=pre
        %‘O‚Ì‰æ‘f‚Æˆá‚Á‚½‚çƒJƒEƒ“ƒg‚·‚é
        gear_num=gear_num+1;
    end
    pre=now;%XV
end
disp(gear_num/2)%Ž•‚Ì–‡”‚ð•\Ž¦
