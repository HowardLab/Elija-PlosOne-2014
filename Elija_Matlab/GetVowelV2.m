function vtpars = GetVowelV2(vowel, vx, fx)
% return vowel vocal tract parameters given vowel (or b,g)
% copy vx and fx directly
% returned parameters as follows:
% p1 Jaw position
% p2 Tongue dorsum position
% p3 Tongue dorsum shape
% p4 Tongue apex position
% p5 Lip height (aperture)
% p6 Lip protrusion
% p7 Larynx height
% p8 vx
% p9 fx

%static char *ARTnote[9] = {
%"Vowel = iy, ey, eh, ah, aa, ao, oh, uw, iw, ew, and oe",

%"Jaw position",
%"Tongue dorsum position",
%"Tongue dorsum shape",
%"Tongue apex position",
%"Lip height (aperture)",
%"Lip protrusion",
%"Larynx height",
%"Nasal coupling (cm2)" };

%static char vowelcode[11][3]
%= { "iy", "ey", "eh", "ah", "aa", "ao", "oh", "uw",
%"iw", "ew", "oe" };
%static float vowelpar[11][7]
%= {
%{ 0.5, -2.0, 1.0, -2.0, 1.0, -1.0, 0.0 }, /* iy */
%{ 0.0, -1.0, 1.0, -2.0, 1.0, -1.0, 0.0 }, /* ey */
%{ -1.0, 0.0, 1.0, -2.0, 1.0, -0.5, 0.0 }, /* eh */
%{ -1.5, 0.5, 0.0, -0.5, 0.5, -0.5, 0.0 }, /* ah */
%{ -1.5, 2.0, 0.0, -0.5, 0.5, -0.5, 0.0 }, /* aa */
%{ -0.4, 3.0, 1.5, 0.0, -0.3, 0.0, 0.0 }, /* ao */
%{ -.7, 3.0, 1.5, 0.0, -0.6, 0.0, 0.0 }, /* oh */
%{ 0.5, 2.0, 1.5, -2.0, -1.0, 1.5, 0.0 }, /* uw */
%{ 0.5, -1.0, 1.0, -2.0, -0.5, 1.0, 0.0 }, /* iw */
%{ 0.0, -0.2, 1.0, -1.5, -0.25, 0.5, 0.0 }, /* ew */
%{ -1.0, -0.5, 0.5, -2.0, 0.2, -0.5, 0.0 } /* oe */
%};

%I don't think nasal coupling is used in my code.
%Of course I've also added a voicing and an Fx parameter.

% Schwa is the most common vowel sound in English, 
% a reduced vowel in many unstressed syllables, 
% especially if syllabic consonants are not used:
 %   * like the 'a' in about [??ba?t]
 %   * like the 'e' in taken [?te?k?n]
 %   * like the 'i' in pencil [?p?ns?l]
 %   * like the 'o' in eloquent [??l?kw?nt]
 %   * like the 'u' in supply [s??pla?]
 %   * like the 'y' in sibyl [?s?b?l]


    % decode vowel quality
    switch vowel
        case 'gA' 
            % Generate b consonant with remaining params set to 'A' vowel config as a target
            % Generate A vowel as a target
            vtpars(1) = -1.5/-3;
            vtpars(2) =  0.5/3;
            vtpars(3) =  0.0/-3;
            vtpars(4) = -1.5;           % tongue closure here !
            vtpars(5) =  0.5/3;
            vtpars(6) = -0.5/-3;
            vtpars(7) =  0;            
            vtpars(8) =  vx;    
            vtpars(9) =  fx;
            vtpars(10) =  -1;
        case 'gAa' 
            % Generate g consonant with remaining params set to 'Aa' vowel config as a target
            % NB: still need to optimize, maybe tongue shape!
            vtpars(1) = -1.5/-3;
            vtpars(2) =  2.0/3;
            vtpars(3) =  0.0/-3;
            vtpars(4) = -1.5;           % tongue closure here !
            vtpars(5) =  0.5/3;
            vtpars(6) = -0.5/-3;  
            vtpars(7) =  0;            
            vtpars(8) =  vx;    
            vtpars(9) =  fx;
            vtpars(10) =  -1;
        case 'gE' 
            % Generate g consonant with remaining params set to 'E' vowel config as a target
            % NB: still need to optimize, maybe tongue shape!
            vtpars(1) = -1.0/-3;
            vtpars(2) =  0.0/3;
            vtpars(3) =  1.0/-3;
            vtpars(4) = -1.5;           % tongue closure here !
            vtpars(5) =  1.0/3;
            vtpars(6) = -0.5/-3;            
            vtpars(7) =  0;            
            vtpars(8) =  vx;    
            vtpars(9) =  fx;
            vtpars(10) =  -1;
        case 'gi:' 
            % Generate g consonant with remaining params set to 'i:' vowel config as a target
            % NB: still need to optimize, maybe tongue shape!
            vtpars(1)=-0.16; 
            vtpars(2)=-0.66; 
            vtpars(3)=-0.33; 
            vtpars(4) = -1.5;           % tongue closure here !
            vtpars(5)=0.33; 
            vtpars(6)=0.33; 
            vtpars(7) =  0;            
            vtpars(8) =  vx;    
            vtpars(9) =  fx;
            vtpars(10) =  -1;
        case 'gO' 
            % Generate g consonant with remaining params set to 'iO' vowel config as a target
            % NB: still need to optimize, maybe tongue shape!
            vtpars(1) = -0.4/-3;
            vtpars(2) =  3.0/3;
            vtpars(3) =  1.5/-3;
            vtpars(4) = -1.5;           % tongue closure here !
            vtpars(5) = -0.3/3;
            vtpars(6) =  0.0/-3;
            vtpars(7) =  0;            
            vtpars(8) =  vx;    
            vtpars(9) =  fx;
            vtpars(10) =  -1;
        case 'gUu' 
            % Generate g consonant with remaining params set to 'Uu' vowel config as a target
            % NB: still need to optimize, maybe tongue shape!
            vtpars(1) =  0.5/-3;
            vtpars(2) =  2.0/3;
            vtpars(3) =  1.5/-3;
            vtpars(4) = -1.5;           % tongue closure here !
            vtpars(5) = -1.0/3;
            vtpars(6) =  1.5/-3;
            vtpars(7) =  0;            
            vtpars(8) =  vx;    
            vtpars(9) =  fx;
            vtpars(10) =  -1;
        case 'bA' 
            % Generate b consonant with remaining params set to 'A' vowel config as a target
            vtpars(1) = -1.5/-3;
            vtpars(2) =  0.5/3;
            vtpars(3) =  0.0/-3;
            vtpars(4) = -0.5/-3;
            vtpars(5) = -0.5;           % bilabial closure here !
            vtpars(6) = -0.5/-3;
            vtpars(7) =  0;            
            vtpars(8) =  vx;    
            vtpars(9) =  fx;
            vtpars(10) =  -1;
        case 'bAa' 
            % Generate b consonant with remaining params set to 'Aa' vowel config as a target
            vtpars(1) = -1.5/-3;
            vtpars(2) =  2.0/3;
            vtpars(3) =  0.0/-3;
            vtpars(4) = -0.5/-3;
            vtpars(5) = -0.5;           % bilabial closure here !
            vtpars(6) = -0.5/-3;
            vtpars(7) =  0;            
            vtpars(8) =  vx;    
            vtpars(9) =  fx;
            vtpars(10) =  -1;
        case 'bE' 
            % Generate b consonant with remaining params set to 'E' vowel config as a target
            vtpars(1) = -1.0/-3;
            vtpars(2) =  0.0/3;
            vtpars(3) =  1.0/-3;
            vtpars(4) = -2.0/-3;
            vtpars(5) = -0.5;           % bilabial closure here !
            vtpars(6) = -0.5/-3;
            vtpars(7) =  0;            
            vtpars(8) =  vx;    
            vtpars(9) =  fx;
            vtpars(10) =  -1;
        case 'bi:' 
            % Generate b consonant with remaining params set to 'i:' vowel config as a target
            vtpars(1)=-0.16; 
            vtpars(2)=-0.66; 
            vtpars(3)=-0.33; 
            vtpars(4)=0.66; 
            vtpars(5) = -0.5;           % bilabial closure here !
            vtpars(6)=0.33; 
            vtpars(7) =  0;            
            vtpars(8) =  vx;    
            vtpars(9) =  fx;
            vtpars(10) =  -1;
        case 'bO' 
            % Generate b consonant with remaining params set to 'O' vowel config as a target
            vtpars(1) = -0.4/-3;
            vtpars(2) =  3.0/3;
            vtpars(3) =  1.5/-3;
            vtpars(4) =  0.0/-3;
            vtpars(5) = -0.5;           % bilabial closure here !
            vtpars(6) =  0.0/-3;        
            vtpars(7) =  0;            
            vtpars(8) =  vx;    
            vtpars(9) =  fx;
            vtpars(10) =  -1;
        case 'bUu' 
            % Generate b consonant with remaining params set to 'Uu' vowel config as a target
            vtpars(1) =  0.5/-3;
            vtpars(2) =  2.0/3;
            vtpars(3) =  1.5/-3;
            vtpars(4) = -2.0/-3;
            vtpars(5) = -0.5;           % bilabial closure here !
            vtpars(6) =  1.5/-3;                        
            vtpars(7) =  0;            
            vtpars(8) =  vx;    
            vtpars(9) =  fx;
            vtpars(10) =  -1;
        case 'i:'             
            % Generate i: vowel as a target
            vtpars(1)=-0.16; 
            vtpars(2)=-0.66; 
            vtpars(3)=-0.33; 
            vtpars(4)=0.66; 
            vtpars(5)=0.33; 
            vtpars(6)=0.33; 
            vtpars(7) =  0;            
            vtpars(8) =  vx;    
            vtpars(9) =  fx;
            vtpars(10) =  -1;
        case 'A' 
            % Generate A vowel as a target
            vtpars(1) = -1.5/-3;
            vtpars(2) =  0.5/3;
            vtpars(3) =  0.0/-3;
            vtpars(4) = -0.5/-3;
            vtpars(5) =  0.5/3;
            vtpars(6) = -0.5/-3;
            vtpars(7) =  0;            
            vtpars(8) =  vx;    
            vtpars(9) =  fx;
            vtpars(10) =  -1;
        case 'Aa' 
            % Generate Aa vowel as a target
            vtpars(1) = -1.5/-3;
            vtpars(2) =  2.0/3;
            vtpars(3) =  0.0/-3;
            vtpars(4) = -0.5/-3;
            vtpars(5) =  0.5/3;
            vtpars(6) = -0.5/-3;
            vtpars(7) =  0;            
            vtpars(8) =  vx;    
            vtpars(9) =  fx;
            vtpars(10) =  -1;
        case 'E' 
            % Generate E vowel as a target
            vtpars(1) = -1.0/-3;
            vtpars(2) =  0.0/3;
            vtpars(3) =  1.0/-3;
            vtpars(4) = -2.0/-3;
            vtpars(5) =  1.0/3;
            vtpars(6) = -0.5/-3;
            vtpars(7) =  0;            
            vtpars(8) =  vx;    
            vtpars(9) =  fx;
            vtpars(10) =  -1;
        case 'O'     
            % Generate O vowel as a target
            vtpars(1) = -0.4/-3;
            vtpars(2) =  3.0/3;
            vtpars(3) =  1.5/-3;
            vtpars(4) =  0.0/-3;
            vtpars(5) = -0.3/3;
            vtpars(6) =  0.0/-3;
            vtpars(7) =  0;            
            vtpars(8) =  vx;    
            vtpars(9) =  fx;
            vtpars(10) =  -1;
         case 'Uu' 
            % Generate Uu vowel as a target
            vtpars(1) =  0.5/-3;
            vtpars(2) =  2.0/3;
            vtpars(3) =  1.5/-3;
            vtpars(4) = -2.0/-3;
            vtpars(5) = -1.0/3;
            vtpars(6) =  1.5/-3;
            vtpars(7) =  0;            
            vtpars(8) =  vx;    
            vtpars(9) =  fx;
            vtpars(10) =  -1;
         case 'Sil' 
            % Generate 'E' vowel as a target
            vtpars(1) = -1.0/-3;
            vtpars(2) =  0.0/3;
            vtpars(3) =  1.0/-3;
            vtpars(4) = -2.0/-3;
            vtpars(5) =  1.0/3;
            vtpars(6) = -0.5/-3;
            vtpars(7) =  0;            
            vtpars(8) =  -1;    
            vtpars(9) =  0;
            vtpars(10) =  0;        
        otherwise
            comment = sprintf('GetVowel Failed: %s', vowel);
            error([comment]);        
    end
    
    