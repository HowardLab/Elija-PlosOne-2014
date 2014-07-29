function model = InitDefs();
% define statements for babble

% type of pattern regression used
model.rbf = 1;
model.mlp = 2;
model.elman = 3;
model.mlpElman = 3;
model.sparsemlp = 4;
model.mlp2       = 5;

% training ditection
model.inversemodel =1;
model.fowardmodel = 2;
model.distalinversemodel =3;

% definition: sample from vowel space
model.sampleVowelSpace = 1;
model.sampleVTSpace = 2;
model.sampleConVowelSpace = 3;

model.sampleAbASpace = 6;
model.sampleAabAaSpace = 5;
model.sampleEbESpace = 7;
model.sampleibiSpace = 8;
model.sampleObOSpace = 9;
model.sampleUubUuSpace = 10;

model.sampleAagAaSpace = 11;
model.sampleAgASpace = 12;
model.sampleEgESpace = 13;
model.sampleigiSpace = 14;
model.sampleOgOSpace = 15;
model.sampleUugUuSpace = 16;

model.sampleAiubAiuSpace = 17;
model.sampleAiugAiuSpace = 18;
