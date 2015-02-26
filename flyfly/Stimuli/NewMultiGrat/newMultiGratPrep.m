function [critInput] = matSequencePrep(Parameters, ScreenData, StimSettings, NumSubframes)
%
% Prepares input parameters for matSequenceDraw

%--------------------------------------------------------------------------
% FlyFly v2
%
% Jonas Henriksson, 2010                            info@flyfly.se
%--------------------------------------------------------------------------

if nargin<4
    NumSubframes = 1;
end

[tmp, numRuns] = size(Parameters);

P.fps  = Parameters(1,:);
P.Xpos = Parameters(2,:);
P.Ypos = Parameters(3,:);
P.wavelength = Parameters(4,:);
P.case = Parameters(5,:);
P.endTime = Parameters(6,:); 
%P.frequency = Parameters(6,:); 

% Wavelength
l = P.wavelength;

f = cell(numRuns,1);
w = cell(numRuns,1);
f_den = cell(numRuns,1);

for k = 1:numRuns
    % Stimuli frequency
    fd = StimSettings(k).edit1{2};
    fd = str2num(fd)';
    nf = length(fd);
    
    wd = StimSettings(k).edit2{2};
    wd = str2num(wd)';
    
    f{k} = fd;
    w{k} = wd;
    if length(wd) ~= nf
        error('Number of frequencies does not match with number of weights.')
    end
end



spatial_approach = P.case;
for k = 1:numRuns
switch spatial_approach(k)
    case 1
        f_den{k} = ones(nf,1)*f{k}(1);
    case 2
        f_den{k} = f{k};
end
end




usedTextures = {};
newTex       = 1;
index        = 1;
p            = 1;


[scr_h] = ScreenData.rect(3);
[scr_w] = ScreenData.rect(4);
R = scr_w;
C = scr_h;

for k = 1:numRuns
    
    % Sampling period
%dt = 1/160;
    dt = 1/P.fps(k);

% Simulation time
    Te = floor(P.endTime(k)/60);
    t = 0:dt:Te;
    %nt = length(t);
    Z = length(t);
    
    fileName = StimSettings(k).path1{2};
    
    for n = 1:length(usedTextures)
        if strcmp(fileName, usedTextures{n})
            newTex = 0;
            index  = n;
            break;
        end
    end
    
    if newTex
%         usedTextures{end+1} = [fileName];
%         
%         load(fileName);
%         
%         try
%             [R, C, Z] = size(out); %out is the matrix loaded from "fileName"
%         catch
%             disp(['File error. Does ' fileName 'contain a 3D matrix with the name "out"? ']);
%         end
        
        for z = 1:Z
            I = zeros(scr_h,scr_w);
            for i_f = 1:length(f{k})
                I = I+w{k}(i_f)*ones(scr_h,1)*sin(2*pi*(z-1+([0:scr_w-1])/(f_den{k}(i_f)*dt*l(k)))*f{k}(i_f)*dt);
                % Constant image
                %I = I+w(i_f)*ones(scr_h,1)*sin(2*pi*(z-1+([0:scr_w-1])/(f(1)*dt*l))*f(i_f)*dt);
                % Dynamic image
                %I = I+0.5*ones(scr_h,1)*sin(2*pi*([0:scr_w-1])/l+2*pi*(z-1)*f(i_f)*dt) + 0.5*ones(scr_h,scr_w);
            end
            I  = 0.5*I/sum(w{k})+0.5*ones(scr_h,scr_w);
            textures(p, z) = Screen('MakeTexture', ScreenData.wPtr, 255*I);
        end
        
        [index tmp] = size(textures);
        newTex = 1;
        p = p+1;
    end
    
    textureIndex(k) = index;
    numFrames(k) = Z;
    
    stretch = StimSettings(k).box1{2}; %true/false
    if stretch
        dstRect(:,k) = [0; 0; ScreenData.rect(3); ScreenData.rect(4)];
    else
        dstRect(:,k) = [P.Xpos(k)-C/2 P.Ypos(k)-R/2 P.Xpos(k)+C/2 P.Ypos(k)+R/2];
    end
    
   
end

critInput.textures  = textures;
critInput.numFrames = numFrames;
critInput.nSwitch   = P.fps / ScreenData.hz;
%critInput.nSwitch   = P.fps / 60;

critInput.dstRect   = dstRect;
critInput.textureIndex = textureIndex;
