function SaveAsWav(params, resynthOutputBuffer, filename)
% save as .wav file
wavwrite(resynthOutputBuffer,params.samplerate,params.wavBits, filename);

