########## AviSynth 2.5.8 script for my guitar video Chiquitina: https://vimeo.com/87065960
########## ===============================================
########## Any question or something can get better? oceweb@gmail.com // https://vimeo.com/ocevideo // Licence CC-BY 4.0


# I highly recommand the user interface AvsPmod 2.5.1 (or later) to read the script.
# How AvsPmod looks like: http://i.imgur.com/h8r5fjO.png

/* I encode the .avs script into a classic video format, .mov (h.264) for the video and .wav for the sound.

Usually the h.264 is used with mp4 for video and the crappy (Silver Fruit's) .aac for audio. 
But aac is a compressed format and as it is a video for music, I want to preserve the uncompressed .wav quality of my audio.
.mp4 doesn't accept .wav, so I use .mov and it works perfectly well on at least VirtualDub, WMP, VLC, Vimeo and Youtube.

To encode I use the free open source FFmpeg (64 static build from Zeranoe) + VLC or VirtualDub to read the video.
Command lines I use (make sure you're in the same folder as ffmpeg.exe):
1) For ~fast MQ encoding when I need to check a change quickly :
ffmpeg -i E:\Videos\Manhattan\Manhattan.avs -c:v libx264 -preset fast -crf 30 -c:a copy E:\Videos\Manhattan\ManhattanMQ.mov
2) For even faster check, but no user interface (can't play,stop,back), you can use FFplay (comes with ffmpeg dowload), it will read the script without encoding:
ffplay F:\Videos\Loops\Loops4_1\Script.avs --> Can now be done with the little arrow after the Play button in AvsPmod player (bottom left)
3) You can use VirtualDub to read the Script.avs like a video. 
3) For very slow but HQ video and efficient compression (for the file you will upload):
ffmpeg -i E:\Videos\Manhattan\Manhattan..avs -c:v libx264 -preset veryslow -crf 16 -c:a copy E:\Videos\Manhattan\ManhattanHD.mov
*/

# Beginnin of the script itself:
#__________________________________________________________

## I - INTRO

## Define w widht, h heigth, t number of frames of 1 loop
w=1920 
h=1080
t=24
n = 150 #top crop/border
m =150  #bot crop/border

#### A - Sources
loadplugin("C:\Program Files (x86)\AviSynth 2.5\plugins\qtsource.dll")
main = QTInput("E:\Videos\Antiquichi2\VideosBrutes\DSC_0728.MOV",audio=1).trim(1178,13063).crop(0,n,0,-m).AddBorders(0, n, 0, m, color=$000000).BicubicResize(w, h, b=0.33, c=0.33).ConvertToYUY2()
oceascii = ImageSource("E:\Videos\Manhattan\Image\oceascii.png").ConvertToRGB32(matrix="Rec601", interlaced=false)
blank = BlankClip(width=w,height=h,fps=23.976023,length=100*t, color=$000000, stereo=true, audio_rate=44100).BicubicResize(w, h, b=0.33, c=0.33).ConvertToYUY2().AssumeFPS(main)# Create a blank black clip for editing tricks and future mosaique construction

#### B - Mix and overlay

###### 1 - Manhattan pic and name
manha = ImageSource("E:\Videos\Antiquichi2\MontageVideo\TitreChiquitina.png",pixel_type="RGB32").ConvertToYUY2().BicubicResize(w, h, b=0.33, c=0.33).Trim(0,4*t )
manhb = Dissolve(Dissolve(manha.Trim(0, 4*t),manha.Subtitle("Chiqui", align=2, y=270/*, first_frame=74, last_frame=336*/, font="Lucida Console", size=150, text_color=$FFFFFF, halo_color=$FFFFFF),2*t),manha.Trim(0, 4*t).Subtitle("tina", align=2, y=970/*, first_frame=74, last_frame=336*/, font="Lucida Console", size=150, text_color=$FFFFFF, halo_color=$FFFFFF),2*t)
#manhba = Dissolve(manhb, manha.Subtitle("tina", align=2, y=810/*, first_frame=74, last_frame=336*/, font="Lucida Console", size=150, text_color=$FFFFFF, halo_color=$FFFFFF),2*t)
manhc  = AudioDub(manhb,blank).BicubicResize(w, h, b=0.33, c=0.33).ConvertToYUY2().AssumeFPS(main)

###### 2 - Oceascii
back = ImageSource("E:\Videos\Manhattan\Image\oceascii.png",pixel_type="RGB32").ShowAlpha(pixel_type="RGB32").trim(0,100*t)
oceasciia = oceascii.AddBorders(491,54,491, 54, color=$000000).trim(0,100*t)
oceasciib = Layer(oceasciia, back, level=256, x=480, y=60)/*.Loop(100)*/.AssumeFPS(main).ConvertToYUY2().BicubicResize(w, h, b=0.33, c=0.33).Trim(0,40)
oceasciic = AudioDub(oceasciib,blank).BicubicResize(w, h, b=0.33, c=0.33).ConvertToYUY2().AssumeFPS(main)
introa = Dissolve(manhc, oceasciic, 20)
introb= Dissolve(blank.Trim(0,72), introa, 40)
introc = Dissolve(introb, blank.Trim(0,72), 20)


## II - Main <-- audio
maina = AudioDub(main,blank).BicubicResize(w, h, b=0.33, c=0.33).ConvertToYUY2().AssumeFPS(main)
#manhc  = AudioDub(manhb,blank).BicubicResize(w, h, b=0.33, c=0.33).ConvertToYUY2().AssumeFPS(main)
#mainb = introc + maina
audio = WAVSource("E:\Videos\Antiquichi2\MontageVideo\SonAntiquichi2.wav")
vaudio = AudioDub(blank,audio)#.Trim(0*t,8*t-1)
mainb = audiodubex(maina, vaudio).ConvertToYUY2()

#videoa = introc + mainb


## III - Outro

#### A - Sources
w2 = 600 # width for boxes # WARNING: some resize values won't work when encoding with ffmpeg (depends on codec?), while there is no problem with AvsPmod prevue... My guess is that w AND r must be rational, here w7 = w/r = 1920/3,2 = 1920/(16/5) = 600
h2 = 300 #  heigth for boxes # r = 18/5 different from w3, so proportions is not 16/9, but I think, well chosen Addborders parameters+Resize will guarantee the 16/9 final format of the boxes, and it looks like it works.
lr2 = 80 # left-right border
tb2 = 370 # top-bot border 
outro4 = ImageSource("E:\Videos\Manhattan\Image\outro4.png").Loop(100).AssumeFPS(main).ConvertToYUY2().Trim(0,336).AddBorders(0, lr2/4, lr2,lr2/4, color=$000000) # Convert into video
outro5 = ImageSource("E:\Videos\Manhattan\Image\outro5.png").Loop(100).AssumeFPS(main).ConvertToYUY2().Trim(0,336).AddBorders(lr2, lr2/4, lr2,lr2/4, color=$000000)
outro6 = ImageSource("E:\Videos\Manhattan\Image\outro6.png").Loop(100).AssumeFPS(main).ConvertToYUY2().Trim(0,336).AddBorders(lr2, lr2/4, 0,lr2/4, color=$000000)

#### B - Scene
outrobot = StackHorizontal(outro4, outro5, outro6).AddBorders(30, 615, 0, 125, color=$000000).BicubicResize(w, h, b=0.33, c=0.33)

outroocea = outrobot.Subtitle("Music & video", y=300,first_frame=0, font="Times New Roman", size=100, text_color=$FFFFFF, halo_color=$000000, align=5, spc=0, font_width=0, font_angle=0.0, interlaced=False)
outrooceb = outroocea.Subtitle("by Oce",y=400, first_frame=0, font="Times New Roman", size=100, text_color=$FFFFFF, halo_color=$000000, align=5, spc=0, font_width=0, font_angle=0.0, interlaced=False)
#outroema = outrooceb.Subtitle("Manhattan photography:", y=525, first_frame=0, font="Times New Roman", size=80, text_color=$FFFFFF, halo_color=$000000, align=5, spc=0, font_width=0, font_angle=0.0, interlaced=False)
#outroemb = outroema.Subtitle("instagram.com/elainemadelon", y=575, first_frame=0, font="Arial", size=50, text_color=$FFFFFF, halo_color=$000000, align=5, spc=0, font_width=0, font_angle=0.0, interlaced=False)
credit = AudioDub(outrooceb,blank).BicubicResize(w, h, b=0.33, c=0.33).ConvertToYUY2().AssumeFPS(main).Trim(0, 4*t)


video = introc + mainb + credit

return video.BicubicResize(w, h, b=0.33, c=0.33)
