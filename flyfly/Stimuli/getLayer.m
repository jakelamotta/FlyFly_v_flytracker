function layer = getLayer(Name)
% All different layers are defined here.
%

%--------------------------------------------------------------------------
% FlyFly v2
%
% Jonas Henriksson, 2010                                   info@flyfly.se
%--------------------------------------------------------------------------

%default settings for all objects
settings.global = 1;
settings.path1  = {'OFF', 0};
settings.box1   = {'OFF', 0};
settings.box2   = {'OFF', 0};
settings.box3   = {'OFF', 0};
settings.box4   = {'OFF', 0};
settings.box5   = {'OFF', 0};
settings.edit1  = {'OFF', 0};
settings.edit2  = {'OFF', 0};
settings.edit3  = {'OFF', 0};
settings.edit4  = {'OFF', 0};
settings.edit5  = {'OFF', 0};

experiment_names = {'Rect Target', 'Sine Grating', 'Rolling Image', ...
    'Color Fill', '.Mat Sequence', 'Aperture', 'Flicker Rect', ...
    'White Noise', 'Sine Grating RF', 'Mouse Target', 'Grid', ...
    'TextString', 'Rolling Image MII', 'Dual Apertures', ...
    'Starfield', 'newMultiGrat', 'Random Flicker Bar'};%, 'Starfield Target'};

switch Name
    
    case 'List' %return list of available draw functions
        layer = experiment_names;
        
    otherwise
        switch Name
            case 1 %Rect Target
                
                fcnPrep = @rectTargetPrep;
                fcnDraw = @rectTargetDraw;
                
                data = [ 5; 5; 100; 100; 60; 0; 0];
                
                rowNames = {'Height', 'Width', 'Xpos', 'Ypos',...
                    'Velocity', 'Direction', 'Brightness'};
                
            case 2 %Sine grating
                
                fcnPrep = @sineGratingPrep;
                fcnDraw = @sineGratingDraw;
                
                data = [ 20; 2; 0; 200; 200; 100; 100; 1];
                
                rowNames = {'Wavelength', 'Temporal Freq', 'Direction', ...
                    'PatchHeight', 'patchWidth', 'Patch Xpos', 'Patch Ypos',...
                    'Contrast'};
                
            case 3 %Rolling Image
                
                fcnPrep = @rollingImagePrep;
                fcnDraw = @rollingImageDraw;
                
                data = [ 10; 0; 320; 240; 480; 640; 0; 1];
                
                rowNames = {'Speed', 'Direction', 'Xpos', 'Ypos',...
                    'Height', 'Width', 'Offset', 'Contrast'};
                
                settings.path1  = {'Image Path', 'Images/defaultImage.png', '*.png'};
                settings.box1   = {'Keep Offset', 0};
                settings.box2   = {'DLP  mode', 0};
                settings.box3   = {'Generate image', 0};
                settings.box4   = {'Horizontal bars', 0};
                
                settings.edit3  = {'(width)','640'};
                settings.edit4  = {'(height)','480'};
                
            case 4 %Color Fill
                
                fcnPrep = @colorFillPrep;
                fcnDraw = @colorFillDraw;
                
                data = [127];
                
                rowNames = {'Brightness'};
                
            case 5 %Mat sequence
                
                fcnPrep = @matSequencePrep;
                fcnDraw = @matSequenceDraw;
                
                data = [160; 320; 240];
                
                rowNames = {'Fps', 'Xpos', 'Ypos'};
                
                settings.global = 0;
                settings.path1  = {'.Mat path: ', [cd '/Mat sequences/out.mat'], '*.mat'};
                settings.box1   = {'Use fullscreen', 0};
                
            case 6 %Aperture
                
                fcnPrep = @aperturePrep;
                fcnDraw = @apertureDraw;
                
                data = [50; 0; 100; 100; 320; 280];
                
                rowNames = {'Transp Surround', 'Transp Hole', 'Width', 'Height', 'Xpos', 'Ypos'};
                
                settings.box1   = {'Use Rect', 0};
                
            case 7 %Flicker rect
                
                fcnPrep = @flickerRectPrep;
                fcnDraw = @flickerRectDraw;
                
                data = [ 100; 80; 320; 240; 2; 0; 255];
                
                rowNames = {'Height', 'Width', 'Xpos', 'Ypos',...
                    'FramesPerFlicker', 'Brightness 1', 'Brightness 2'};
                
                settings.box1  = {'Offset X function', 0};
                settings.box2  = {'Offset Y function', 0};
                settings.edit1 = {'X function: ', '100*sin(2*pi/3 *(n-1)*ifi)'};
                settings.edit2 = {'Y function: ', '100*cos(2*pi/3 *(n-1)*ifi)'};
                
            case 8 %white noise
                
                fcnPrep = @whiteNoisePrep;
                fcnDraw = @whiteNoiseDraw;
                
                data = [ 80; 100; 320; 240; 1; 1];
                
                rowNames = {'Height', 'Width', 'Xpos', 'Ypos',...
                    'Contrast', 'Pixels'};
                
                settings.box1  = {'Offset X function', 0};
                settings.box2  = {'Offset Y function', 0};
                settings.edit1 = {'X function: ', '100*sin(2*pi/3 *(n-1)*ifi)'};
                settings.edit2 = {'Y function: ', '100*cos(2*pi/3 *(n-1)*ifi)'};
                
            case 9 %sine grating Rf
                
                fcnPrep = @sineGratingRfPrep;
                fcnDraw = @sineGratingRfDraw;
                
                data = [ 20; 2; 0; 16; 200; 200; 100; 100; 1];
                
                rowNames = {'Wavelength', 'Temporal Freq', 'Starting Direction', 'Steps' ...
                    'PatchHeight', 'patchWidth', 'Patch Xpos', 'Patch Ypos', 'Contrast'};
                
                settings.box1   = {'Counter Clockwise', 0};
                
            case 10 %mouse target
                
                fcnPrep = @mouseTargetPrep;
                fcnDraw = @mouseTargetDraw;
                
                data = [ 5; 100; 0];
                
                rowNames = {'Width', 'Height', 'Brightness'};
                
            case 11 %grid
                
                fcnPrep = @gridPrep;
                fcnDraw = @gridDraw;
                
                data = [];
                
                rowNames = {};
                
            case 12 %TextString
                
                fcnPrep = @textStringPrep;
                fcnDraw = @textStringDraw;
                
                data = [50; 220; 240];
                
                rowNames = {'Size', 'Xpos', 'Ypos'};
                
                settings.edit1  = {'Text String', 'FlyFly'};
                
            case 13 %Rolling Image MII
                
                fcnPrep = @rollingImageM2Prep;
                fcnDraw = @rollingImageM2Draw;
                
                data = [0; 100; 100; 200; 200; 1];
                
                rowNames = {'Direction', 'Xpos', 'Ypos',...
                    'Height', 'Width', 'Contrast'};
                
                settings.path1  = {'Image Path', 'Images/defaultImage.png', '*.png'};
                settings.box1   = {'Image offset = ', 1};
                settings.box2   = {'X pos = Xpos + ', 0};
                settings.box3   = {'Y pos = Ypos + ', 0};
                settings.box4   = {'Generate image', 0};
                settings.box5   = {'Horizontal bars', 0};
                
                %T: Total experiment time
                %t: Time in current trial
                %n: Number of frames in total
                %k: Current trial
                settings.edit1  = {'(internal roll)', '100*abs(2*(n/1 - floor(n/1+0.5)))'}; %period 1s
                settings.edit2  = {'(patch movement)', '100*sin(n)'};
                settings.edit3  = {'(patch movement)', '100*cos(n)'};
                settings.edit4  = {'(width)','640'};
                settings.edit5  = {'(height)','480'};
                
            case 14 %Dual Apertures
                
                %Created by Olof J???nsson
                
                fcnPrep = @DualAperturesPrep;
                fcnDraw = @DualAperturesDraw;
                
                data = [255; 127; 0; 255; 100; 100; 320; 280; 50; 50; 100; 100];
                
                rowNames = {'Opacity Surround', 'Brightness Surround', 'Opacity Hole', ...
                    'Brightness Hole', 'Width', 'Height', 'Xpos', 'Ypos' ...
                    'Width2', 'Height2', 'Xpos2', 'Ypos2'};
                
                settings.box1   = {'Use Rect for 1', 0};
                settings.box2   = {'Use Rect for 2', 0};
                
            case 15 %Starfield
                
                fcnPrep = @starfieldCylPrep;
                fcnDraw = @starfieldCylDraw;
                
                data = [1; 3000; 0; 0; 0; 0; 0; 20];
                
                rowNames = {'Dot size', 'Number of dots', 'Sideslip', ...
                    'Lift', 'Thrust', 'Pitch', 'Yaw', 'Roll'};
                
            case 16 %New Multi Gratings
                
                fcnPrep = @newMultiGratPrep;
                fcnDraw = @newMultiGratDraw;
                
                data = [160; 320; 240; 20; 1];
                
                rowNames = {'Fps', 'Xpos', 'Ypos', 'Wavelength',...
                    'Case'};
                
                settings.edit1 = {'Frequencies', '8 13 19 28 42 52 59 77'};
                settings.edit2 = {'Weights', '1 1 1 1 1 1 1 1'};
                
            case 17 %Random Flicker Bar
               
                fcnPrep = @randflickerRectPrep;
                fcnDraw = @randflickerRectDraw;
                
                data = [ 100; 80; 320; 240; 2; 0; 255];
                
                rowNames = {'Height', 'Width', 'Xpos', 'Ypos',...
                    'FramesPerFlicker', 'Brightness 1', 'Brightness 2'};
                
                settings.box1  = {'Offset X function', 0};
                settings.box2  = {'Offset Y function', 0};
                settings.edit1 = {'X function: ', '100*sin(2*pi/3 *(n-1)*ifi)'};
                settings.edit2 = {'Y function: ', '100*cos(2*pi/3 *(n-1)*ifi)'};
                
%                             case 17 %New Stim
%                 
%                                 fcnPrep = @newStimGratPrep;
%                                 fcnDraw = @newStimGratDraw;
%                 
%                                 data = [160; 320; 240; 60; 20; 5; 20];
%                 
%                                 rowNames = {'Fps', 'Xpos', 'Ypos', 'endTime','Wavelength',...
%                                     'Frequency 1','Frequency 2'};
                %
                %             case 17 %New Stim Triple
                %
                %                 fcnPrep = @newStimGratTriplePrep;
                %                 fcnDraw = @newStimGratTripleDraw;
                %
                %                 data = [160; 320; 240; 60; 20; 5; 20; 30];
                %
                %                 rowNames = {'Fps', 'Xpos', 'Ypos', 'endTime','Wavelength',...
                %                     'Frequency 1','Frequency 2','Frequency 3'};
                %
                %             case 18 %New Stim 4 Sine Gratings
                %
                %                 fcnPrep = @newStimGrat4FreqPrep;
                %                 fcnDraw = @newStimGrat4FreqDraw;
                %
                %                 data = [160; 320; 240; 60; 20; 5; 20; 30; 50];
                %
                %                 rowNames = {'Fps', 'Xpos', 'Ypos', 'endTime','Wavelength',...
                %                     'Frequency 1','Frequency 2','Frequency 3','Frequency 4'};
                %
                %             case 19 %New Stim 5 Sine Gratings
                %
                %                 fcnPrep = @newStimGrat5FreqPrep;
                %                 fcnDraw = @newStimGrat5FreqDraw;
                %
                %                 data = [160; 320; 240; 60; 20; 5; 20; 30; 50; 70];
                %
                %                 rowNames = {'Fps', 'Xpos', 'Ypos', 'endTime','Wavelength',...
                %                     'Frequency 1','Frequency 2','Frequency 3','Frequency 4',...
                %                     'Frequency 5'};
                %
                %
                %
                %            case 21 %New Rectangular Stimulus
                %
                %                 fcnPrep = @newRectWavePrep;
                %                 fcnDraw = @newRectWaveDraw;
                %
                %                 data = [160; 320; 240; 60; 20; 0.2; 20];
                %
                %                 rowNames = {'Fps', 'Xpos', 'Ypos', 'endTime','Wavelength',...
                %                     'Width Ratio','Frequency'};
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                %                 settings.global = 0;
                %                 settings.path1  = {'.Mat path: ', [cd '/NewStim/out.mat'], '*.mat'};
                %                 settings.box1   = {'Use fullscreen', 0};
                
                %             case 16 %Starfield Target
                %
                %                 fcnPrep = @starfieldTargetPrep;
                %                 fcnDraw = @starfieldTargetDraw;
                %
                %                 data = [1; 3000; 0; 0; 0; 0; 0; 20; 1];
                %
                %                 rowNames = {'Dot size', 'Number of dots', 'Sideslip', ...
                %                     'Lift', 'Thrust', 'Pitch', 'Yaw', 'Roll', 'Target size'};
                %
                %                 settings.edit2  = {'(x movement)', '50'};
                %                 settings.edit3  = {'(y movement)', '50'};
                %                 settings.edit4  = {'(z movement)', '50'};
                %
                %                 settings.box2   = {'Rectangle', 0};
                
        end
        
        %set layer
        layer = struct(...
            'name',       experiment_names{Name}, ...
            'fcnPrep',    fcnPrep, ...
            'fcnDraw',    fcnDraw, ...
            'parameters', {[rowNames, {'Time', 'PauseTime', 'PreStimTime', 'PostStimTime'}]}, ...
            'data',       [data; 60; 0; 0; 0], ...
            'settings',   settings, ...
            'impulse',    false);
end
