% function looming_light3(type, setupNum)
%对应bonsai程序是looming_light_along_inter4;
%视觉刺激自动和手动需要等待的时间间隔是一致的；  光刺激之间中间没有时间间隔；
%变化范围(0,2)2-20度;(2,2)2-40度   身体前方20度给予looming
% sample: looming_light(0, 2)
%分别不同时给予视觉刺激和光刺激,共有4种光刺激，a、b、c、d分别代表四种光刺激
%a,b,c,d+m分别手动给予光刺激；
%space+m 表示第一种视觉刺激， t+m表示第二种视觉刺激；space或者t键按下，表示是进入视觉刺激
%的等待状态；小老鼠进入自触发，有时间间隔；第一种和第二种达到3刺刺及，不再给予刺激
%如果手动可以再次触发
%给予光刺激的时候也会出现黑框，欸给视觉刺激打标
%% set parameters
close all;   
clear all;
sca;

loomingNum = 0;
COM_EVENT = COM_open('COM13',9600,1);     %该串口用来触发光刺激
scom1 = serial('com3');          % 打标灯光
set(scom1, 'BaudRate', 9600, 'DataBits', 8, 'StopBits', 1, 'Parity', 'none', 'FlowControl', 'none');
fopen(scom1);
if ~exist('type','var')||isempty(type)
    type = 0;
end
if ~exist('setupNum','var')||isempty(setupNum)
    setupNum = 2;
end


%% prepare the serial port communication
global strRead;
global scom2;
scom2 = serial('com4');
% get(som)
set(scom2, 'BaudRate', 9600, 'TimeOut', 0.1, 'Terminator','CR/LF')
word = 'Start';
triggerWord = 'blink!';
% scom.BytesAvaibleFcnMode='byte';
% scom.BytesAvailableFcnCount=length(word)*2;
% scom.BytesAvailableFcn=@scomCallback;
% scom.RecordMode='append';
fopen(scom2);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Disable Synctests
white = 255;
black = 0;
Screen('Preference','SkipSyncTests',1);

%% experiment parameters
repeatTimes = 15; % stimili was repeated 15 times

fRate = FrameRate; % 60HZ
fRate = fix(fRate);
screenID = max(Screen('Screens'));
cishu1 = 0;   %统计给光刺激的次数
shijue_cishu1 = 0;
shijue_cishu2 = 0;
guang_cishu  = 0;
button = 0;
guang_time = 0;
isshijue = false;
isguang = false
iszidong = false;
isskey = false;
istkey = false;
type1 = 1;
type_tishi1 = 0;
type_tishi2 =0;
maker_times = [];
askLastNum = 0;
%光刺激参数
stiColor = 0;
bg = 180;
blinkLumi = [0 128 255 128 0];
s = [1800 950 1920 1080];
%%% time
switch type
    case -1 % no looming control
        stiDur = 250; % expanded in 250 ms
        remainDur = 250; % remained at that size for 250 ms
        pauseDur = 500; % stimili was repeated 15 times with 500 ms pauses
        startAngle = 0; % 2 degrees
        endAngle = 0; % 20 degrees
    case 0 % stimuli used in Yilmaz & Meister 2013
        stiDur = 250; % expanded in 250 ms
        remainDur = 250; % remained at that size for 250 ms
        pauseDur = 500; % stimili was repeated 15 times with 500 ms pauses
        startAngle = 2; % 2 degrees
        endAngle = 20; % 20 degrees            楼
        %         endAngle = 0;
    case 1 % stimuli used in Wei et al 2015
        stiDur = 250; % expanded in 250 ms
        remainDur = 50; % remained at that size for 50 ms
        pauseDur = 30; % stimili was repeated 15 times with 30 ms pauses
        startAngle = 2; % 2 degrees
        endAngle = 40; % 20 degrees              楼
        %          endAngle = 0;
    case 2 % stimuli used in our lab
        stiDur = 250; % expanded in 250 ms
        remainDur = 50; % remained at that size for 50 ms
        pauseDur = 30; % stimili was repeated 15 times with 30 ms pauses
        startAngle = 2; % 2 degrees
        endAngle = 40; % 20 degrees               楼
        %         endAngle = 0;
    case 3
        repeatTimes = 1;
        stiDur = 1500; % expanded in 3 s
        remainDur = 1000; % remained at that size for 250 ms
        pauseDur = 500; % stimili was repeated 15 times with 500 ms pauses
        startAngle = 2; % 2 degrees
        endAngle = 40; % 20 degrees            楼
        %          endAngle = 0;
    case 4
        repeatTimes = 1;
        stiDur = 250; % expanded in 3 s
        remainDur = 50; % remained at that size for 250 ms
        pauseDur = 30; % stimili was repeated 15 times with 500 ms pauses
        startAngle = 2; % 2 degrees
        endAngle = 40; % 20 degrees            楼
        %          endAngle = 0;
    case 5
        repeatTimes = 1;
        stiDur = 350; % expanded in 3 s
        remainDur = 2150; % remained at that size for 250 ms
        pauseDur = 30; % stimili was repeated 15 times with 500 ms pauses
        startAngle = 2; % 2 degrees
        endAngle = 80; % 20 degrees            楼
        %          endAngle = 0;
    case 6 % stimuli used by THY
        stiDur = 250; % expanded in 3 s
        remainDur = 50; % remained at that size for 250 ms
        pauseDur = 30; % stimili was repeated 15 times with 500 ms pauses
        startAngle = 2; % 2 degrees
        endAngle = 40; % 20 degrees             楼
        %          endAngle = 0;
    case 7 % no looming control
        stiDur = 250; % expanded in 250 ms
        remainDur = 250; % remained at that size for 250 ms
        pauseDur = 500; % stimili was repeated 15 times with 500 ms pauses
        startAngle = 0; % 2 degrees
        endAngle = 0; % 20 degrees              喽
        %          endAngle = 0;
end

switch setupNum
    case 0
        dMonitor2Ground = 335; % mm distance from the monitor to the ground
        screenHeight = 270; % mm
        %         vResolution = 1024;
        rotMat = [0 -1;1 0];
        PIXEL2mm = 0.486; %  1920 pixels = 932.3 mm for touchscreen 1;
    case 2
        dMonitor2Ground = 415;
        screenHeight = 395;
        %         vResolution = 1080;
        rotMat = [0 1;1 0];
        PIXEL2mm = 0.486; %  1920 pixels = 932.3 mm for touchscreen 1;
        refPoint = [0 0]';
    case 1
        dMonitor2Ground = 400;
        %         screenHeight = 525;
        screenHeight = 320;
        %         vResolution = 1080;
        %         rotMat = [-1 0;0 1];
        rotMat = [1 0;0 1];
        PIXEL2mm = 0.486; %  1920 pixels = 932.3 mm for touchscreen 1;
        refPoint = [0 0]'; %[-320 0]';
    case 3
        dMonitor2Ground = 300;
        %         screenHeight = 525;
        screenHeight = 320;
        %         vResolution = 1080;
        rotMat = [1 0;0 1];
        PIXEL2mm = 0.486; %  1920 pixels = 932.3 mm for touchscreen 1;
        refPoint = [0 0]'; %[-320 0]';
end

%% the response key
KbName('UnifyKeyNames');
sKey = KbName('space');      % start every trial
qKey = KbName('escape');     % exit

%% prepare some windows
%%% main window
[window, screenRect] = Screen('OpenWindow', screenID , bg, [], 32);
vResolution = screenRect(4)-screenRect(2);
hResolution = screenRect(3)-screenRect(1);
pMonitor2Ground = dMonitor2Ground*vResolution/screenHeight;

alpha = 0; % 0 front; pi back; pi/2 left; -pi/2 right; [] center;
shiftLength = tand(10)*pMonitor2Ground; % looming disk shifts 20 degree

%%% frame
nFrame = round(stiDur/1000*fRate)+1; % the whole frames
dAngle = linspace(startAngle, endAngle, nFrame);
%% present the stimuli
% HideCursor;
WaitSecs(1);
isQuit = 0;
isBlink = false;
strRead = [];
while 1
    Screen('FillRect', window, bg);
    Screen('Flip', window);
    Screen('FillRect',window,black,s);% Turn on the spot in one period
    Screen('Flip', window);
    while KbCheck; end
    posShift = [-hResolution/4;0];
    %     pos = cenPoint;
    while 1
        if scom2.BytesAvailable >= 5 %length(word)
            a = fgets(scom2);
            strRead = [strRead a]
        end
        [keyIsDown, sec, keyCode] = KbCheck;
        %         if keyIsDown && keyCode(sKey)
        %             break;
        if keyIsDown && keyCode(KbName('a') )
            button = 1;
            isguang= true;
            if keyIsDown && keyCode(KbName('m') )
                break;
            end
        elseif keyIsDown && keyCode(KbName('b') )
            button = 2;
            isguang= true;
            if keyIsDown && keyCode(KbName('m') )
                break;
            end
        elseif keyIsDown && keyCode(KbName('c') )
            button = 3;
            isguang= true;
            if keyIsDown && keyCode(KbName('m') )
                break;
            end
        elseif keyIsDown && keyCode(KbName('d') )
            button = 4;
            isguang= true;
            if keyIsDown &&keyCode(KbName('m') )
                break;
            end
        elseif keyIsDown && keyCode(sKey)
            type = 0;
            setupNum = 2;
            if shijue_cishu1<3
                isshijue= true;
                isskey = true;
                iszidong = true
            else
                isshijue= false;
            end
            if keyIsDown &&keyCode(KbName('m') )
                isshijue= true;
                type_tishi1 = 1;
                type1 =1;
                break;
            end
        elseif keyIsDown && keyCode(KbName('t') )
            type = 0;
            setupNum = 2;
            if  shijue_cishu2 <3
                isshijue= true;
                istkey = true;
                iszidong = true
            else
                isshijue= false;
            end
            if keyIsDown &&keyCode(KbName('m') )
                isshijue= true;
                type2 =1;
                break;
            end
        elseif keyIsDown && keyCode(qKey)
            delete(scom1);
            clear scom1;
            sca;
            isQuit = 1;
            break;
        end
        if ~isempty(strRead) && contains(strRead, word) && contains(strRead, '!')&&iszidong
            tword = strRead(strfind(strRead, word):strfind(strRead, '!'));
            blankPos = strfind(tword,' ');
            if length(blankPos)==5
                x = str2double(tword(blankPos(1)+1:blankPos(2)-1));
                y = str2double(tword(blankPos(2)+1:blankPos(3)-1));
                xVector = str2double(tword(blankPos(3)+1:blankPos(4)-1));
                yVector = str2double(tword(blankPos(4)+1:blankPos(5)-1));
                
                if setupNum == 3
                    x = str2double(tword(blankPos(1)+1:blankPos(2)-1));
                    y = -150;
                    xVector = str2double(tword(blankPos(3)+1:blankPos(4)-1));
                    yVector = 0;
                end
                
                pos = rotMat*[x;y];
                vector = rotMat*[xVector;yVector];
                if vector(1)~=0 % xVector~=0
                    %                     theta = atan(yVector/xVector);
                    theta = atan(vector(2)/vector(1));
                    if vector(1)<0 % xVector<0
                        theta = theta + pi;
                    end
                elseif vector(2)~=0 % yVector~=0
                    if vector(2)>0 % yVector>0
                        theta = pi/2;
                    else
                        theta = -pi/2;
                    end
                else
                    theta = [];
                end
                theta = theta + alpha;
                if ~isempty(theta)
                    %                     xShift = round(x+endSize*cos(theta));
                    %                     yShift = round(y+endSize*sin(theta));
                    posShift = round(pos+shiftLength*[cos(theta);sin(theta)]);
                    %                     posShift(2) = 0;
                else
                    posShift = [0; 0];%round(pos);
                end
            end
            strRead = strrep(strRead, tword, '*');
            if isskey&&shijue_cishu1<3
                isshijue = true;
            elseif isskey&&shijue_cishu1>=3
                isshijue = false;
                isskey =false;
            end
            if istkey&&shijue_cishu2<3
                isshijue = true;
            elseif istkey&&shijue_cishu2>=3
                isshijue = false;
                istkey =false;
            end
            break;
        elseif ~isempty(strRead) && contains(strRead, triggerWord) && contains(strRead, '!')
            strRead = strrep(strRead, triggerWord, '#');
            isBlink = true;
            break;
        end
    end
    %光刺激参数
    switch(button)
        case 1
            send_command = 'F0020 D010 N0100';                  %光刺激参数，第一是频率，第二是占空比，第三是重复的次数
            guang_time = 5;
        case 2
            send_command = 'F0060 D030 N0300';                  %光刺激参数，第一是频率，第二是占空比，第三是重复的次数
            guang_time = 5;
        case 3
            send_command = 'F0020 D010 N1200';
            guang_time = 60;
        case 4
            send_command = 'F0060 D030 N3600';
            guang_time = 60;
    end
    if isQuit
        Screen('CloseAll');
        break;
    end
    if isBlink
        fwrite(scom1, '1');  m
        fprintf('event start。\n');
        loomingNum = loomingNum+1;
        fprintf(['已经触发了第', num2str(loomingNum), '次Looming！']);
        type1=1;
        while (type1==1)
            
            fprintf(COM_EVENT, send_command);
            
            if (COM_EVENT.BytesAvailable - askLastNum >= 5)      %收到arduino返回的命令
                askLastNum = COM_EVENT.BytesAvailable;
                fwrite(scom2, '1');
                type1 =0
                cishu1 = cishu1 + 1;
            end
        end
        for jloop = 1:fRate
            
            for kloop = 1:length(blinkLumi)
                Screen('FillRect',window,white,s);
                Screen('FillRect', window, blinkLumi(kloop));
                Screen('Flip', window);
            end
        end
        maker_times = [maker_times, cishu1];
        fwrite(scom1, '0');
        fprintf('event stop。\n');
        isBlink = false;
        isready = false;
    elseif ~isBlink&&isguang
        type1=1;
        while (type1==1)
            Screen('FillRect', window, bg);
            Screen('FillRect',window,white,s);
            Screen('Flip', window);
            fwrite(scom1, '1');
            fprintf(COM_EVENT, send_command);
            if (COM_EVENT.BytesAvailable - askLastNum >= 5)      %收到arduino返回的命令
                askLastNum = COM_EVENT.BytesAvailable;
                fwrite(scom2, '1');
                type1 =0
            end
            
            isguang = false;
            guang_cishu = guang_cishu+1;
            
        end
        WaitSecs(guang_time);
        fwrite(scom1, '0');
        Screen('FillRect',window,white,s);
        Screen('FillRect', window, bg);
        Screen('Flip', window);
   
        
    elseif ~isBlink&&isshijue
        fwrite(scom1, '1');
        fprintf('event start。\n');
        loomingNum = loomingNum+1;
        %         fprintf(['已经触发了第', num2str(loomingNum), '次Looming！']);
        isshijue = false;
        if shijue_cishu1<3
            shijue_cishu1 =  shijue_cishu1+1;
            fprintf(['已经触发了第一种', num2str(shijue_cishu1), '次Looming！'])
        else
            if type_tishi1 ==1
                shijue_cishu1 =  shijue_cishu1+1;
                type_tishi1 =0;
                fprintf(['已经触发了第一种', num2str(shijue_cishu1), '次Looming！'])
            else
                shijue_cishu2 =  shijue_cishu2+1;
                fprintf(['已经触发了第二种', num2str(shijue_cishu2), '次Looming！'])
            end
        end
        type1=1;
        
        for jloop = 1:repeatTimes
            for kloop = 1:nFrame
                diskAngle = dAngle(kloop);
                %             diskSize = startSize + dSize*(kloop-1);
                diskSize = round(2*pMonitor2Ground*tand(diskAngle/2));
                diskRect = [0 0 diskSize diskSize];
                %             rectShift = [xShift yShift xShift yShift];
                rectShift = [posShift' posShift'];
                %                     Screen('FillOval', frameWin(i), stiColor, rectShift+CenterRect(diskRect,screenRect));
                %                 Screen('FillOval', window, stiColor, rectShift+CenterRect(diskRect,screenRect));
                Screen('FillRect',window,white,s);
                Screen('FillOval', window, stiColor, rectShift+CenterRect(diskRect,screenRect)+[refPoint' refPoint']);
                %                     Screen('DrawTexture', window, frameWin(i));
                Screen('Flip', window);
            end
            
            WaitSecs(remainDur/1000);
            %         Screen('DrawTexture', window, blankWin);
            Screen('FillRect', window, bg);
            Screen('FillRect',window,white,s);
            Screen('Flip', window);
            WaitSecs(pauseDur/1000);
        end
        fwrite(scom1, '0');
        fprintf('event stop。\n');
        isshijue=false;  
         Screen('FillRect',window,white,s);
    Screen('FillRect', window, bg);
    Screen('Flip', window);
    WaitSecs(30);           %视觉间隔时间
      while scom2.BytesAvailable >= 5 %length(word)
            a = fgets(scom2);
            strRead = [strRead a]
            strRead = [];
      end    
      strRead = [];
    end
    %     Screen('DrawTexture', window, blankWin);
%     Screen('FillRect',window,white,s);
%     Screen('FillRect', window, bg);
%     Screen('Flip', window);
end
fclose(scom2);
delete(scom2);
clear scom2
fclose(scom1);
delete(scom1);
clear scom1;
clear global
%  end