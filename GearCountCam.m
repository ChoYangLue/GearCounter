clear all;close all;clc;

%カメラオブジェクト
cam=webcam('CEVCECM');
%preview(cam);

%キャプチャ
img=snapshot(cam);
%画像サイズを取得
[ix,iy,iz]=size(img);
%figure
hf=figure();

%歯の枚数を初期化
gear_num = 0;
% 無限ループを実行
while 1
    % 最近の入力文字が q であるかを比較
    if strcmp(get(hf,'currentcharacter'),'q')
        close(hf)
        break
    end
    
    %webカメラから画像を取得
    img=snapshot(cam);
    %二値化
    BWo = im2bw(img,0.42);
    BW = BWo<1;
    imshow(img);
    %imshow(BW);
    
    try
        %半径 r が [15, 30] ピクセルの範囲にある円を検出
        [centers, radii, metric] = imfindcircles(img,[15 30]);
        centersStrong5 = centers(1,:);%円の中心座標
        radiiStrong = radii(1);%円の半径
        %metricStrong5 = metric(1);
        %中心の円を表示（青）
        viscircles(centersStrong5, radiiStrong,'EdgeColor','b');
        r=radii(1)+70;%円の半径
        flag=1;%ループフラグ
        inner_r=0;%歯の部分までの半径
        while flag
            %歯車の半径が求まるまでループ
            r=r+1;%半径を更新
            pic_num=0;%画像情報変数初期化
            i=0;%ループカウント
            for ti=0:0.01:pi/2
                %扇形に探索
                tx=centersStrong5(1)+r*cos(ti);
                ty=centersStrong5(2)+r*sin(ti);
                now = BW(round(ty),round(tx));
                pic_num=pic_num+now;%画素の値を足す
                i=i+1;
            end
            if pic_num==0
                %全ての画素の値が０だったら、終了
                flag=0;
            elseif pic_num==i
                %全ての画素の値が１だったら、歯の部分までの半径とする
                inner_r=r;
            end
        end
        %disp(r)
        %歯の部分までの円を表示（緑）
        viscircles(centersStrong5, inner_r,'EdgeColor','g');
        %歯までの円を表示（赤）
        viscircles(centersStrong5, r,'EdgeColor','r');
        %歯を数えるために使う半径
        gear_h=inner_r+(r-inner_r)*4/5;
        %歯を数えるために使う円（黄）
        viscircles(centersStrong5, gear_h,'EdgeColor','y');
       
        gear_num = 0;%歯の枚数を初期化
        pre=0;%前の画素値
        now=0;%今の画素値
        for ti=0:0.01:2*pi
            %円状に探索
            tx=gear_h*cos(ti);
            ty=gear_h*sin(ti);
            now = BW(round(centersStrong5(2)+ty),round(centersStrong5(1)+tx));
            if now~=pre
                %前の画素と違ったらカウントする
                gear_num=gear_num+1;
            end
            pre=now;%更新
        end
        disp(gear_num/2)%歯の枚数を表示
    catch
        gear_num = 0;
    end
    
     if gear_num/2==11
        img=snapshot(cam);
        imwrite(img,'gear11.png');
        close(hf)
        break
     end

    % 繰り返し毎にその時点のFigureを認識
    figure(hf)
    drawnow
end