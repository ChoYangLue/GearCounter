clear all;close all;clc;

%�J�����I�u�W�F�N�g
cam=webcam('CEVCECM');
%preview(cam);

%�L���v�`��
img=snapshot(cam);
%�摜�T�C�Y���擾
[ix,iy,iz]=size(img);
%figure
hf=figure();

%���̖�����������
gear_num = 0;
% �������[�v�����s
while 1
    % �ŋ߂̓��͕����� q �ł��邩���r
    if strcmp(get(hf,'currentcharacter'),'q')
        close(hf)
        break
    end
    
    %web�J��������摜���擾
    img=snapshot(cam);
    %��l��
    BWo = im2bw(img,0.42);
    BW = BWo<1;
    imshow(img);
    %imshow(BW);
    
    try
        %���a r �� [15, 30] �s�N�Z���͈̔͂ɂ���~�����o
        [centers, radii, metric] = imfindcircles(img,[15 30]);
        centersStrong5 = centers(1,:);%�~�̒��S���W
        radiiStrong = radii(1);%�~�̔��a
        %metricStrong5 = metric(1);
        %���S�̉~��\���i�j
        viscircles(centersStrong5, radiiStrong,'EdgeColor','b');
        r=radii(1)+70;%�~�̔��a
        flag=1;%���[�v�t���O
        inner_r=0;%���̕����܂ł̔��a
        while flag
            %���Ԃ̔��a�����܂�܂Ń��[�v
            r=r+1;%���a���X�V
            pic_num=0;%�摜���ϐ�������
            i=0;%���[�v�J�E���g
            for ti=0:0.01:pi/2
                %��`�ɒT��
                tx=centersStrong5(1)+r*cos(ti);
                ty=centersStrong5(2)+r*sin(ti);
                now = BW(round(ty),round(tx));
                pic_num=pic_num+now;%��f�̒l�𑫂�
                i=i+1;
            end
            if pic_num==0
                %�S�Ẳ�f�̒l���O��������A�I��
                flag=0;
            elseif pic_num==i
                %�S�Ẳ�f�̒l���P��������A���̕����܂ł̔��a�Ƃ���
                inner_r=r;
            end
        end
        %disp(r)
        %���̕����܂ł̉~��\���i�΁j
        viscircles(centersStrong5, inner_r,'EdgeColor','g');
        %���܂ł̉~��\���i�ԁj
        viscircles(centersStrong5, r,'EdgeColor','r');
        %���𐔂��邽�߂Ɏg�����a
        gear_h=inner_r+(r-inner_r)*4/5;
        %���𐔂��邽�߂Ɏg���~�i���j
        viscircles(centersStrong5, gear_h,'EdgeColor','y');
       
        gear_num = 0;%���̖�����������
        pre=0;%�O�̉�f�l
        now=0;%���̉�f�l
        for ti=0:0.01:2*pi
            %�~��ɒT��
            tx=gear_h*cos(ti);
            ty=gear_h*sin(ti);
            now = BW(round(centersStrong5(2)+ty),round(centersStrong5(1)+tx));
            if now~=pre
                %�O�̉�f�ƈ������J�E���g����
                gear_num=gear_num+1;
            end
            pre=now;%�X�V
        end
        disp(gear_num/2)%���̖�����\��
    catch
        gear_num = 0;
    end
    
     if gear_num/2==11
        img=snapshot(cam);
        imwrite(img,'gear11.png');
        close(hf)
        break
     end

    % �J��Ԃ����ɂ��̎��_��Figure��F��
    figure(hf)
    drawnow
end